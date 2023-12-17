-- how to concatenate
-- select concat(first_name, ' ', last_name) as Name, phone, state
-- from customer
-- where state = 'TX'

-- get the toal value of all business shoes that are in our inventory
-- select product_id, sum(price) as Total
-- from item
-- where product_id = 1
-- group by product_id;

-- get a list of states we have customers in
-- select distinct state
-- from customer
-- order by state;

-- find all states where we have customers excluding CA
-- select distinct state
-- from customer
-- where state != 'CA';

-- just list CA and NJ
-- select distinct state
-- from customer
-- where state in ('CA', 'NJ');

-- find the number of customers in CA and NJ
-- select count(state) as state_count, state
-- from customer
-- where state in ('CA', 'NJ')
-- group by state;


-- inner join
-- list items that are ordered
-- use join condition to find IDs that are equal in the tables
-- select item_id, price
-- from item inner join sales_item
-- on item.id = sales_item.id and price > 120.00
-- order by item_id;

-- join 3 tables: the quantity and the total sales
-- sales_items.sales_order_id matches up with sales_order.id, item.id matches up with sales_item.id
-- use tables sales_order, sales_item, item
-- select sales_order.id, sales_item.quantity, item.price,
-- (sales_item.quantity * item.price) as total
-- from sales_order
-- join sales_item
-- on sales_order.id = sales_item.sales_order_id
-- join item
-- on sales_item.item_id = item.id
-- order by sales_order.id;

-- select item_id, price
-- from item, sales_item
-- where item.id = sales_item.item_id
-- and price > 120.00
-- order by item_id


-- outer join
-- return all of the rows from one of the tables being joined even if NO MATCHES are found
-- left outer join: return all rows from the table being joined on the left
-- select name, supplier, price
-- from product
-- left join item
-- on product.id = item.product_id
-- order by name;

-- cross join: include data from each row in both tables
-- select sales_order_id, quantity, product_id
-- from item
-- cross join sales_item
-- order by sales_order_id;

-- unions
-- combine results of two or more select statements into 1 result
-- each result MUST return the same number of columns + each column MUST have the same data type
-- eg:send birthday cards to all of customers and sales people for the month of December
-- select first_name, last_name, street, city, zip, birth_date
-- from customer
-- where extract(month from birth_date) = 12
-- union
-- select first_name, last_name, street, city, zip, birth_date
-- from sales_person
-- where extract(month from birth_date) = 12
-- order by birth_date

-- select product_id, price
-- from item
-- where price = NULL
-- where price is not NULL

-- string match
-- 1. search any customer whose name begins with M
-- select concat(first_name, ' ', last_name)
-- from customer
-- where first_name similar to 'M%';
-- %：match 0 or more chars
-- 2. match someone whose name begins with A and have 5 cahrs after that
-- select concat(first_name, ' ', last_name)
-- from customer
-- where first_name like 'A_____';
-- _: placeholder
-- 3. match people whose first name begins with D or last name ends with N
-- select concat(first_name, ' ', last_name)
-- from customer
-- where first_name similar to 'D%' or last_name similar to '%n';
-- 4. first name that starts with Ma
-- select concat(first_name, ' ', last_name)
-- from customer
-- where first_name ~ '^Ma';
-- 5. last name that ends with ez
-- select concat(first_name, ' ', last_name)
-- from customer
-- where last_name ~ 'ez$|son$';
-- 6. last name that contains x, y or z
-- select concat(first_name, ' ', last_name)
-- from customer
-- where last_name ~ '[w-z]';

-- group by
-- how results are grouped
--
-- find how many customers have birthdays in certain months
-- select extract(month from birth_date) as month, count(*) as amount
-- from customer
-- group by month
-- order by month;

-- having
-- narrow the results based off of a condition
-- get months if more than 1 person have birthday that month
-- select extract(month from birth_date) as month, count(*) as amount
-- from customer
-- group by month
-- having count(*) > 1
-- order by month;

-- aggregate funcs
-- 1. get sum price on item
-- select sum(price)
-- from item;
-- 2.more funcs
-- select count(*) as items, sum(price) as value, round(avg(price), 2) as avg,
-- min(price) as min, max(price) as max
-- from item;

-- views
-- select statemtns that's result is stored in database
-- 1. create a view that contains our main purchase order info
-- create view purchase_order_overview as
-- select sales_order.purchase_order_number, customer.company,
-- sales_item.quantity, product.supplier, product.name, item.price,
-- (sales_item.quantity * item.price) as total,
-- concat(sales_person.first_name, ' ', sales_person.last_name) as salesperson
-- from sales_order
-- join sales_item on sales_item.sales_order_id = sales_order.id
-- join item on item.id = sales_item.item_id
-- join product on product.id = item.product_id
-- join customer on customer.id = sales_order.cust_id
-- join sales_person on sales_person.id = sales_order.sales_person_id
-- order by purchase_order_number;
--
-- select * from purchase_order_overview;

-- create view purchase_order_overview_2 as
-- select sales_order.purchase_order_number, customer.company,
-- sales_item.quantity, product.supplier, product.name, item.price,
-- concat(sales_person.first_name, ' ', sales_person.last_name) as salesperson
-- from sales_order
-- join sales_item on sales_item.sales_order_id = sales_order.id
-- join item on item.id = sales_item.item_id
-- join product on product.id = item.product_id
-- join customer on customer.id = sales_order.cust_id
-- join sales_person on sales_person.id = sales_order.sales_person_id
-- order by purchase_order_number;
-- select *, (quantity * price) as total from purchase_order_overview_2;
-- drop view purchase_order_overview_2;

-- SQL funcs
-- create or replace func function_name() returns void as 'SQL commands'
-- $1 the very first value inside of
-- create or replace function fn_add_ints(int ,int)
-- returns int as
-- '
-- select $1 + $2;;
-- '
-- language sql
--
-- select fn_add_ints(2, 3);
--
-- create or replace function fn_add_ints(int, int)
-- returns int as
-- $body$
-- select $1 + $2
-- $body$
-- language sql;
-- select fn_add_ints(2, 14);
--
-- void
-- check if a salesperson's state is assigned, if not assign 'PA' to state column 
-- create or replace function fn_update_employee_state()
-- returns void as
-- $body$
-- 	update sales_person
-- 	set state = 'PA'
-- 	where state is null
-- $body$
-- language sql;
-- select fn_update_employee_state();
--
-- get max price in item
-- create or replace function fn_max_product_price()
-- returns numeric as
-- $body$
-- select max(price)
-- from item
-- $body$
-- language sql;
-- select fn_max_product_price();
--
-- get the total inventory value
-- create or replace function fn_get_value_inventory()
-- returns numeric as
-- $body$
-- select sum(price)
-- from item;
-- $body$
-- language sql;
-- select fn_get_value_inventory();
--
-- get the total num of customers
-- create or replace function fn_get_number_customers()
-- returns numeric as
-- $body$
-- select count(*)
-- from customer;
-- $body$
-- language sql;
-- select fn_get_number_customers();
--
-- get the number of customers who do not have a phone number
-- create or replace function fn_get_customers_no_phone()
-- returns numeric as
-- $body$
-- select count(*)
-- from customer
-- where phone is NULL;
-- $body$
-- language sql;
-- select fn_get_customers_no_phone();
--
-- get the number of customers from Texas and use the name parameter as "Texas"
-- create or replace function fn_get_number_customers_from_state(state_name char(2))
-- returns numeric as
-- $body$
-- select count(*)
-- from customer
-- where state = state_name;
-- $body$
-- language sql;
-- select fn_get_number_customers_from_state('TX');
--
--
-- select count(*)
-- from sales_order
-- natural join customer
-- where customer.first_name = 'Christopher' AND customer.last_name = 'Jones';
--
-- create or replace function fn_get_number_orders_from_customer(cus_fname varchar, cus_lname varchar)
-- returns numeric as
-- $body$
-- select count(*)
-- from sales_order
-- natural join customer
-- -- on customer.id = sales_order.cust_id
-- where customer.first_name = cus_fname and customer.last_name = cus_lname
-- $body$
-- language sql;
-- select fn_get_number_orders_from_customer('Christopher', 'Jones');
--
-- composite
-- return a row
-- /*get the latest order*/
-- create or replace function fn_get_last_order()
-- returns sales_order as
-- $body$
-- select *
-- from sales_order
-- order by time_order_taken desc
-- limit 1;
-- $body$
-- language sql;
-- select fn_get_last_order();
-- select (fn_get_last_order()).*; -- make the result in a table format
--
-- time_stamp: 2:03:40 https://youtu.be/85pG_pDkITY?si=huZNTtkVBamHmmF6
--
-- /*get all rows of every employee inside California*/
-- create or replace function fn_get_employees_location(loc varchar)
-- returns setof sales_person as -- setof: returns rows of results
-- $body$
-- select *
-- from sales_person
-- where state = loc;
-- $body$
-- language sql;
-- select (fn_get_employees_location('CA')).*; /* return results in table format */
--
-- /* select specific columns from results of a function */
-- select first_name, last_name, phone
-- from fn_get_employees_location('CA');

-- /* pl/pgsql SQL funtion */
--
-- /* get product price by name */
-- create or replace function func_get_price_product_name(prod_name varchar)
-- returns numeric(6,2) as
-- $body$
-- begin
-- 	return price
-- 	from item
-- 	join product
-- 	on item.product_id = product.id
-- 	where product.name = prod_name
-- 	limit 1;
-- end
-- $body$
-- language plpgsql;
-- select func_get_price_product_name('Grandview');
--
-- declare a variable
-- := assign
-- create or replace function fn_get_sum(val1 int, val2 int)
-- returns int as
-- $body$
-- declare
-- 	ans int;
-- begin
-- 	ans := val1 + val2 ;
-- 	return ans;
-- end
-- $body$
-- language plpgsql;
-- select fn_get_sum(1, 2);
--
-- declare a varaible with a query
-- create or replace function fn_get_random_number(min_val int, max_val int)
-- returns int as
-- $body$
-- declare
-- 	rand int;
-- begin
-- 	select random()*(max_val - min_val) + min_val into rand;
-- 	return rand;
-- end
-- $body$
-- language plpgsql;
-- select fn_get_random_number(1, 2);
--
-- get a random sales person's name
-- record type: store data
-- create or replace function fn_get_random_salesperson()
-- returns varchar as
-- $$
-- declare
-- 	rand int;
-- 	emp record;
-- begin
-- 	select random()*(5-1)+1 into rand;
-- 	select *
-- 	from sales_person
-- 	into emp
-- 	where id = rand;
-- 	return concat(emp.first_name, ' ', emp.last_name);
-- end
-- $$
-- language plpgsql;
-- select fn_get_random_salesperson();
--
-- IN INOUT and OUT: automatically return OUT. no need to decalre variable.
-- create or replace function fn_get_sum_2(in v1 int, in v2 int, out ans int)
-- as
-- $$
-- begin
-- 	ans := v1 + v2;
-- end;
-- $$
-- language plpgsql;
-- select fn_get_sum_2(2, 3);
--
-- create or replace function fn_get_cust_birthday(in the_month int,
-- 												out bd_month int, out bd_day int,
-- 											   out f_name varchar, out l_name varchar)
-- as
-- $$
-- begin
-- 	-- EXTRACT() function extracts a part from a given date
-- 	select extract(month from birth_date), extract(day from birth_date),
-- 	first_name, last_name
-- 	into bd_month, bd_day, f_name, l_name
-- 	from customer
-- 	where extract(month from birth_date) = the_month
-- 	limit 1;
-- end;
-- $$
-- language plpgsql;
-- select fn_get_cust_birthday(12);
--
-- 2:25:56 Return Query Results
-- create or replace function fn_get_sales_people()
-- returns setof sales_person as
-- -- type of: an SQL function can be declared to return a set (that is, multiple rows) by specifying the function's return type as SETOF sometype, or equivalently by declaring it as RETURNS TABLE(columns). In this case all rows of the last query's result are returned.
-- -- https://stackoverflow.com/questions/22423958/sql-function-return-type-table-vs-setof-records
-- $$
-- 	begin
-- 		return query
-- 		select * from sales_person;
-- 	end;
-- $$
-- language plpgsql;
-- select fn_get_sales_people(); -- the output doesn't have field, not in table format
-- select (fn_get_sales_people()).*; -- in table format
-- select (fn_get_sales_people()).street; -- get the result of a specific column
--
-- return specific data from a query using multiple tables
-- get top 10 most expensive products
-- create or replace function fn_get_10_expensive_products()
-- returns table (
-- 	name varchar,
-- 	supplier varchar,
-- 	price numeric
-- )
-- as
-- $$
-- begin
-- 	return query
-- 	select product.name, product.supplier, item.price
-- 	from item
-- 	natural join product
-- 	order by item.price desc
-- 	limit 10;
-- end;
-- $$
-- language plpgsql;
-- select (fn_get_10_expensive_products()).*;
--
-- if else
-- create or replace function fn_check_month_orders(the_month int)
-- returns varchar as
-- $$
-- declare
-- 	total_orders int;
-- begin
-- 	select count(purchase_order_number)
-- 	into total_orders
-- 	from sales_order
-- 	where extract(month from time_order_taken) = the_month;
-- 	if total_orders > 5 then
-- 		return concat(total_orders,  ' orders: doing good');
-- 	elseif total_orders < 5 then
-- 		return concat(total_orders,  ' orders: doing bad');
-- 	else
-- 		return concat(total_orders,  ' orders: on target');
-- 	end if; --anytime you put an if inside here you have to end the if condition block with an endif
-- end;
-- $$
-- language plpgsql;
-- select fn_check_month_orders(12);
--
-- -- case statement
-- create or replace function fn_check_month_orders(the_month int)
-- returns varchar as
-- $$
-- declare
-- 	total_orders int;
-- begin
-- 	select count(purchase_order_number)
-- 	into total_orders
-- 	from sales_order
-- 	where extract(month from time_order_taken) = the_month;
-- 	case 
-- 		when total_orders < 1 then
-- 			return concat(total_orders, ' orders: terrible');
-- 		when total_orders > 1 and total_orders < 5 then
-- 			return concat(total_orders, ' orders: on target');
-- 		else
-- 			return concat(total_orders, ' orders: doing good');
-- 	end case;
-- end;
-- $$
-- language plpgsql;
-- select fn_check_month_orders(12);
--
-- loop
-- create or replace function fn_loop_test(max_num int)
-- returns int as
-- $$
-- declare
-- 	j int default 1;
-- 	tot_sum int default 0;
-- begin
-- 	loop
-- 		tot_sum := tot_sum + j;
-- 		j := j + 1;
-- 		exit when j > max_num;
-- 	end loop;
-- 	return tot_sum;
-- end
-- $$
-- language plpgsql;
-- select fn_loop_test(3);
--
-- for loop
/*
	 for counter_name in start value .. end_value by stepping -- stepping: how much you add to start_value as you cycle through your looping
	 loop
	 	statement
	end loop;
*/
-- create or replace function fn_for_test(max_num int)
-- returns int as
-- $$
-- declare
-- 	tot_sum int default 0;
-- begin
-- 	for i in 1 .. max_num by 2
-- 	loop
-- 		tot_sum := tot_sum + i;
-- 	end loop;
-- 	return tot_sum;
-- end
-- $$
-- language plpgsql;
-- select fn_for_test(5)
--
-- reverse loop
-- create or replace function fn_for_test_reverse(max_num int)
-- returns int as
-- $$
-- declare
-- 	tot_sum int default 0;
-- begin
-- 	for i in reverse max_num .. 1 by 2
-- 	loop
-- 		tot_sum := tot_sum + i;
-- 	end loop;
-- 	return tot_sum;
-- end
-- $$
-- language plpgsql;
-- select fn_for_test_reverse(5)
--
-- do block
-- do
-- $$
-- --outout all of my sales people's name using for loop
-- 	declare
-- 		rec record;
-- 	begin
-- 	for rec in
-- 		select first_name, last_name
-- 		from sales_person
-- 		limit 5
-- 	loop
-- 		raise notice '% %', rec.first_name, rec.last_name;
-- 	end loop;
-- 	end
-- $$
-- language plpgsql;
--
-- for each var in array
-- do
-- $$
-- 	declare
-- 		arr1 int[] := array[1,2,3];
-- 		i int;
-- 	begin
-- 		foreach i in array arr1
-- 		loop
-- 			raise notice '%', i;
-- 		end loop;
-- 	end;
-- $$
-- language plpgsql;
--
-- while loop
-- do
-- $$
-- 	declare
-- 		j int default 1;
-- 		tot_sum int default 0;
-- 	begin
-- 		while j <= 10
-- 		loop
-- 			tot_sum := tot_sum + j;
-- 			j := j + 1;
-- 		end loop;
-- 		raise notice '%', tot_sum;
-- 	end;
-- $$
-- language plpgsql
--
-- continue
-- do
-- $$
-- 	declare
-- 		i int default 1;
-- 	begin
-- 		loop
-- 			i := i + 1;
-- 			exit when i > 10;
-- 			continue when mod(i, 2) = 0;
-- 			raise notice 'Num : %', i;
-- 		end loop;
-- 	end;
-- $$
-- language plpgsql
--
-- return inventory value by providing a supplier name
-- create or replace function fn_get_supplier_value(the_supplier varchar)
-- returns varchar as 
-- $$
-- declare
-- 	supplier_name varchar;
-- 	price_sum numeric;
-- begin
-- 	select product.supplier, sum(item.price)
-- 	into supplier_name, price_sum
-- 	from product, item
-- 	where product.supplier = the_supplier
-- 	group by product.supplier; -- paired with sum
-- 	return concat(supplier_name, ' inventory value : $', price_sum);
-- end;
-- $$
-- language plpgsql;
-- select fn_get_supplier_value('Nike');
--


/*
3:01:43 store procedures
stored procedures:
	1. can be exucted by an application that has access to your database
	2. can also excute transactions which you can't do with functions
	3. can't return values but there is a workaround using INOUT
	4. can't be called by select, using EXECUTE or CALL  instead // we are using parameteres whenever we use excute command
	5. if a stored procedures doesn't have parameters, it's called a static procedure; those with parameters are called dynamic procedures
*/

-- create a sample table that is going to store customer IDs with balances due
-- CREATE TABLE past_due(
-- 	id serial primary key,
-- 	cust_id integer not null,
-- 	balance numeric(6,2) not null
-- )

-- insert into past_due(cust_id, balance)
-- values
-- (1, 123.45),
-- (2, 324.50);

-- create or replace procedure pr_debt_paid(
-- 	past_due_id int,
-- 	payment numeric
-- )
-- as
-- $$
-- 	declare
-- 	begin
-- 		update past_due
-- 		set balance = balance - payment
-- 		where id = past_due_id;
-- 		commit; -- use commit to run this update
-- 	end;
-- $$
-- language plpgsql;
-- call pr_debt_paid(1, 10.00);
-- select * from past_due;

-- use INOUT to return value
-- create or replace procedure pr_debt_paid(
-- 	past_due_id int,
-- 	payment numeric,
-- 	INOUT msg varchar
-- ) as
-- $$
-- declare
-- begin
-- 	update past_due
-- 	set balance = balance - payment
-- 	where id = past_due_id;
-- 	commit;
-- end;
-- $$
-- language plpgsql;
-- call pr_debt_paid(1, 10.00);
-- select * from past_due;



/*
Triggers
	features:
		1. when you want an action to automatically occur when another event occurs, common events include using commands such as insert, update, delete, trucate
		2. associated with tables, foerign tables and views
		3. can execute before or after an event executes
		4. can also execute instead of another event
		5. can put multiple triggers on a table and they execute in alphabetical order
		6. they can't be triggered manually by a user
		6. don't receive parameters
		7. if the trigger is row level, the trigger is called for each row that is modified; if a state level, the trigger is called once
	pros:
		1. can be used for auditing/logging, if something is deleted the trigger could save it in case it is needed later
		2. validate data
		3. make certain events always happen
		4. ensure integrity between diff databases
		5. call functions or procedures
		6. trigger are recursive
	cons:
		1. add execution overhead
		2. nested/recursive trigger errors can be hard to debug
		3. invisible to the client which can cause confusion when actoons aren't allowed
*/

-- want log changes to a table that is called distributor
-- create table distributor(
-- 	id serial primary key,
-- 	name varchar(100)
-- )
-- insert into distributor (name) values
-- ('Parawholesale'),
-- ('J & B Sales'),
-- ('Steel City Clothing');
-- select * from distributor;

-- create another table and store changes to distributor
-- create table distributor_audit(
-- 	id serial primary key,
-- 	dist_id int not null,
-- 	name varchar(100) not null,
-- 	edit_date timestamp not null
-- );

-- -- create trigger func
-- create or replace function fn_log_dist_name_change()
-- 	returns trigger
-- 	language plpgsql
-- as
-- $$
-- 	begin
-- 	-- check if a name change has occurred
-- 		if new.name <> old.name then -- <>: not equal
-- 			insert into distributor_audit
-- 			(dist_id, name, edit_date)
-- 			values
-- 			(old.id, old.name, now());
-- 		end if;
-- 		-- trigger info variables
-- 		raise notice 'Trigger Name: %', tg_name;
-- 		raise notice 'Table Name: %', tg_table_name;
-- 		raise notice 'Operation Name: %', tg_op;
-- 		raise notice 'When Executed: %', tg_when;
-- 		raise notice 'Row or Statement: %', tg_level;
-- 		raise notice 'Table Schema: %', tg_table_schema;
-- 		return new;
-- 	end;
-- $$;

-- bind the trigger function above to a trigger
-- create  trigger tr_dist_name_changed
-- 	before update on distributor
-- 	for each row
-- 	execute procedure fn_log_dist_name_change();

-- update distributor
-- set name = 'Western Clothing'
-- where id = 2;

-- select * from distributor_audit;


/* conditional triggers
   revoke delete on tables for some users through the use of triggers
*/
-- -- set up oour system in a way that is not going to allow people to update the records on weekend
-- -- create a trigger func
-- create or replace function fn_block_weekend_changes()
-- 	returns trigger
-- 	language plpgsql
-- as
-- $$
-- begin
-- 	raise notice 'No database changes allowed on the weekend';
-- 	return null;
-- end;
-- $$;
-- -- create a triiger
-- create trigger tr_block_weekend_changes
-- 	before update or insert or delete or truncate
-- 	on distributor
-- 	for each statement
-- 	when(
-- 		extract('DOW' from current_timestamp) = 0 --DOW: day of the week, execute the trigger when it's sunday (0, not 7)
-- 	)
-- 	execute procedure fn_block_weekend_changes();
-- update distributor
-- set name = 'Western Clothing'
-- where id = 2;
-- drop event trigger tr_block_weekend_changes;
-- DROP TRIGGER IF EXISTS tr_block_weekend_changes ON distributor;


/*
 cursor:
 	step backwards or forwards through rows of data, pointed at a row and select, update or delete
*/
-- Do
-- $$
-- declare
-- 	msg text default '';
-- 	rec_customer record;
-- 	cursor_customers cursor
-- 	for -- assign this cursor to for
-- 		select * from customer;
-- 	begin
-- 		open cursor_customers; -- open a cursor
-- 		loop
-- 			fetch cursor_customers into rec_customer;
-- 			exit when not found; --exit when there is no customers found
-- 			msg := msg || rec_customer.first_name || ' ' || rec_customer.last_name || ', ';
--			/*
--			1. := assignment operator
--			2. || concatenation operator
--			3. repeating msg after ":=" can ensure the accumulation of customer names
--          */
-- 		end loop;
-- 		raise notice 'customers: % ', msg;
-- 	end;
-- $$;
--
-- -- using cursors with functions
create or replace function fn_get_cust_by_state(c_state varchar)
returns text
language plpgsql
as
$$
declare
	cust_names text default '';
	rec_customer record;
	--CURSOR DECLARATION--
	-- declare 'cur_cust_by_state' that selects rows from 'customer' table based on the specified state 'c_state'
	cur_cust_by_state cursor (c_state varchar)
	for
		select first_name, last_name, state
		from customer
		where state = c_state;
	--CURSOR DECLARATION--
	begin
		open cur_cust_by_state(c_state);
		loop
			fetch cur_cust_by_state into rec_customer; -- fetches rows into the rec_customer record 
			exit when not found;
			cust_names := cust_names || rec_customer.first_name || ' ' || rec_customer.last_name || ', ';
		end loop;
		close cur_cust_by_state;
		return cust_names;
	end;
$$;

select fn_get_cust_by_state('CA');

/*
lessons learnt
common mistakes that can trigger errors:
	1. forget ; after 'end' in function
	2. forget ; after 'language plpgsql'
	3. forget ; after '$'
	4. forget ; after 'end'
	5. forget 'end loop;'
	6. highligh the wrong section of code when excute
	7. using sum() without 'group by'
*/
