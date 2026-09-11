
-- Table 1: Departments
CREATE TABLE Departments_LMS (
    DepartmentID   NUMBER GENERATED ALWAYS AS IDENTITY START WITH 10 INCREMENT BY 10,
    DepartmentName VARCHAR2(100) NOT NULL,
    HeadOfDept     VARCHAR2(100),
    CONSTRAINT pk_departments_lms PRIMARY KEY (DepartmentID),
    CONSTRAINT uq_dept_name_lms UNIQUE (DepartmentName)
);

-- Table 2: Students
CREATE TABLE All_students (
    StudentID      NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    FirstName      VARCHAR2(50) NOT NULL,
    LastName       VARCHAR2(50) NOT NULL,
    Gender         VARCHAR2(10),
    Age            NUMBER,
    Email          VARCHAR2(100),
    Phone          VARCHAR2(20),
    City           VARCHAR2(50) DEFAULT 'Sialkot',
    EnrollmentDate DATE DEFAULT SYSDATE,
    DepartmentID   NUMBER,
    CONSTRAINT pk_students_lms PRIMARY KEY (StudentID),
    CONSTRAINT uq_student_email_lms UNIQUE (Email),
    CONSTRAINT chk_student_age_lms CHECK (Age >= 16),
    CONSTRAINT chk_student_gender_lms CHECK (Gender IN ('Male', 'Female', 'Other')),
    CONSTRAINT fk_students_dept_lms FOREIGN KEY (DepartmentID) 
        REFERENCES Departments_LMS(DepartmentID) ON DELETE SET NULL
);

-- Table 3: Courses
CREATE TABLE ALL_Courses (
    CourseID     NUMBER GENERATED ALWAYS AS IDENTITY START WITH 101 INCREMENT BY 1,
    CourseName   VARCHAR2(100) NOT NULL,
    CreditHours  NUMBER NOT NULL,
    DepartmentID NUMBER,
    CONSTRAINT pk_courses_lms PRIMARY KEY (CourseID),
    CONSTRAINT chk_credit_hours_lms CHECK (CreditHours BETWEEN 1 AND 4),
    CONSTRAINT fk_courses_dept_lms FOREIGN KEY (DepartmentID) 
        REFERENCES Departments_LMS(DepartmentID) ON DELETE CASCADE
);

-- Table 4: Enrollments
CREATE TABLE ALL_Enrollments (
    EnrollmentID NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1001 INCREMENT BY 1,
    StudentID    NUMBER NOT NULL,
    CourseID     NUMBER NOT NULL,
    Semester     VARCHAR2(20) NOT NULL,
    Marks        NUMBER,
    CONSTRAINT pk_enrollments_lms PRIMARY KEY (EnrollmentID),
    CONSTRAINT chk_enrollment_marks_lms CHECK (Marks BETWEEN 0 AND 100),
    CONSTRAINT fk_enrollments_student_lms FOREIGN KEY (StudentID) 
        REFERENCES All_students(StudentID) ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course_lms FOREIGN KEY (CourseID) 
        REFERENCES  ALL_Courses(CourseID) ON DELETE CASCADE
);


-- Inserting Departments
INSERT INTO Departments_LMS
(DepartmentName, HeadOfDept) VALUES ('Information Technology', 'Dr. AliRaza');

-- Inserting Students
INSERT INTO All_students 
(FirstName, LastName, Gender, Age, Email, Phone, City, DepartmentID) 
VALUES ('Zaki', 'Abaid', 'Male', 22, 'zaki@email.com', '0300-1234567', 'Gujrat', 10);


-- Inserting Courses
INSERT INTO ALL_Courses
(CourseName, CreditHours, DepartmentID) VALUES ('Database Management Systems', 4, 10);


-- Inserting Enrollments
INSERT INTO ALL_Enrollments
(StudentID, CourseID, Semester, Marks) VALUES (1, 101, 'Spring 2026', 85);

COMMIT;


-- SQL Basic 

SELECT FirstName, LastName, City FROM All_Students WHERE City = 'Sialkot';
SELECT * FROM All_Students ORDER BY Age DESC;
SELECT * FROM All_Students WHERE FirstName LIKE 'Z%';
SELECT * FROM All_Students WHERE Age BETWEEN 21 AND 23;
SELECT DISTINCT City FROM All_Students;

-- CRUD Operations 

INSERT INTO All_Students (FirstName, LastName, Gender, Age, Email, Phone, City, DepartmentID) 
VALUES ('Temporary', 'Student', 'Male', 25, 'temp@email.com', '0300-0000000', 'Sialkot', 10);

UPDATE All_Students SET City = 'Gujranwala' WHERE StudentID = 1;

DELETE FROM All_Students WHERE FirstName = 'Temporary';

--Aggregate Functions

SELECT COUNT(*) AS TotalStudents FROM All_Students;
SELECT SUM(Marks) AS TotalMarksAwarded FROM ALL_Enrollments;
SELECT AVG(Marks) AS AverageClassMarks FROM  ALL_Enrollments;
SELECT MIN(Marks) AS LowestMark, MAX(Marks) AS HighestMark FROM  ALL_Enrollments;

--GROUP BY

SELECT City, COUNT(*) AS StudentCount 
FROM ALL_Students 
GROUP BY City;

--INNER JOIN

SELECT s.FirstName, s.LastName, d.DepartmentName, c.CourseName, e.Marks
FROM ALL_Enrollments e
INNER JOIN All_students s    ON e.StudentID = s.StudentID
INNER JOIN ALL_Courses c     ON e.CourseID = c.CourseID    
INNER JOIN Departments_LMS d ON s.DepartmentID = d.DepartmentID; 

--LEFT JOIN 

SELECT s.FirstName, s.LastName, d.DepartmentName
FROM All_students s
LEFT JOIN Departments_LMS d ON s.DepartmentID = d.DepartmentID;

--RIGHT JOIN 

SELECT d.DepartmentName, s.FirstName, s.LastName
FROM All_students s
RIGHT JOIN Departments_LMS d ON s.DepartmentID = d.DepartmentID;