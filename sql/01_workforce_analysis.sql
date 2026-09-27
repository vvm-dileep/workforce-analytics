-- ============================================================
-- Project 01: Workforce Analytics
-- Purpose: SQL-based workforce and salary analysis
-- Database: DuckDB
-- Source: employees.csv
-- ============================================================


-- 1. Workforce Headcount by Department
-- Business Question:
-- How is the workforce distributed across departments?

SELECT department, COUNT(*) AS employee_count
FROM '../data/employees.csv'
GROUP BY department
ORDER BY employee_count DESC;


-- 2. Average Salary by Department
-- Business Question:
-- How does average salary vary across departments?

SELECT department, AVG(salary) AS avg_salary
FROM '../data/employees.csv'
GROUP BY department
ORDER BY avg_salary DESC;


-- 3. Department Headcount and Average Salary
-- Business Question:
-- How do workforce size and salary levels compare by department?

SELECT 
    department, 
    COUNT(*) as employee_count, 
    AVG(salary) AS avg_salary
FROM '../data/employees.csv'
GROUP BY department
ORDER BY employee_count DESC;



-- 4. Departments with Average Salary Above 80K
-- Business Question:
-- Which departments have relatively higher average salary levels?

SELECT department, AVG(salary) AS avg_salary
FROM '../data/employees.csv'
GROUP BY department
HAVING AVG(salary) > 80000
ORDER BY avg_salary DESC;

-- 5. Top 5 Highest-Paid Employees
-- Business Question:
-- Which employees have the highest salaries?

SELECT employee_name, department, salary
FROM '../data/employees.csv'
ORDER BY salary DESC
LIMIT 5;


-- 6. Employee Salary Compared with Department Average
-- Business Question:
-- How does each employee's salary compare with their department average?

WITH employee_salary AS (
    SELECT
        employee_name,
        department,
        salary,
        AVG(salary) OVER (
            PARTITION BY department
        ) AS department_avg_salary
    FROM '../data/employees.csv'
)

SELECT
    employee_name,
    department,
    salary,
    department_avg_salary,
    salary - department_avg_salary AS salary_difference,
    ROUND(
        ((salary - department_avg_salary) / department_avg_salary) * 100,
        1
    ) AS salary_difference_pct
FROM employee_salary
ORDER BY salary_difference_pct DESC;


-- 7. Employee Salary Ranking Within Department
-- Business Question:
-- How does each employee rank by salary within their department?

WITH employee_salary AS (
    SELECT 
        employee_name, 
        department, 
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
    FROM '../data/employees.csv'
)
SELECT 
    employee_name, 
    department, 
    salary, 
    salary_rank
FROM employee_salary
ORDER BY department, salary_rank, salary DESC;

-- 8. Highest-Paid Employee in Each Department
-- Business Question:
-- Who is the highest-paid employee within each department?

WITH employee_salary AS (
    SELECT 
        employee_name, 
        department, 
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
    FROM '../data/employees.csv'
)
SELECT 
    employee_name, 
    department, 
    salary, 
    salary_rank
FROM employee_salary
WHERE salary_rank = 1
ORDER BY salary DESC;