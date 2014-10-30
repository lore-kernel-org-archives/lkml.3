Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbaJ3Gsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:48:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277AbaJ3Gs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:48:27 -0400
Date: Wed, 29 Oct 2014 23:47:22 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-2987e32f75dcb40bce0f3ab1d5d48cc1c580fd8b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        eranian@google.com, hpa@zytor.com, paulus@samba.org,
        fweisbec@gmail.com, mingo@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, namhyung@gmail.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: tglx@linutronix.de, peterz@infradead.org, adrian.hunter@intel.com,
        namhyung@gmail.com, mingo@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, paulus@samba.org, hpa@zytor.com,
        eranian@google.com, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        acme@redhat.com
In-Reply-To: <1414061124-26830-8-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Add Python script to export to postgresql
Git-Commit-ID: 2987e32f75dcb40bce0f3ab1d5d48cc1c580fd8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2987e32f75dcb40bce0f3ab1d5d48cc1c580fd8b
Gitweb:     http://git.kernel.org/tip/2987e32f75dcb40bce0f3ab1d5d48cc1c580fd8b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 23 Oct 2014 13:45:15 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:49 -0200

perf script: Add Python script to export to postgresql

Add a Python script to export to a postgresql database.

The script requires the Python pyside module and the Qt PostgreSQL
driver.  The packages needed are probably named "python-pyside" and
"libqt4-sql-psql"

The caller of the script must be able to create postgresql databases.

The script takes the database name as a parameter.  The database and
database tables are created.  Data is written to flat files which are
then imported using SQL COPY FROM.

Example:

  $ perf record ls
  ...
  $ perf script report export-to-postgresql lsdb
  2014-02-14 10:55:38.631431 Creating database...
  2014-02-14 10:55:39.291958 Writing to intermediate files...
  2014-02-14 10:55:39.350280 Copying to database...
  2014-02-14 10:55:39.358536 Removing intermediate files...
  2014-02-14 10:55:39.358665 Adding primary keys
  2014-02-14 10:55:39.658697 Adding foreign keys
  2014-02-14 10:55:39.667412 Done
  $ psql lsdb
  lsdb-# \d
              List of relations
   Schema |      Name       | Type  | Owner
  --------+-----------------+-------+-------
   public | comm_threads    | table | acme
   public | comms           | table | acme
   public | dsos            | table | acme
   public | machines        | table | acme
   public | samples         | table | acme
   public | samples_view    | view  | acme
   public | selected_events | table | acme
   public | symbols         | table | acme
   public | threads         | table | acme
  (9 rows)
  lsdb-# \d samples
         Table "public.samples"
      Column     |  Type   | Modifiers
  ---------------+---------+-----------
   id            | bigint  | not null
   evsel_id      | bigint  |
   machine_id    | bigint  |
   thread_id     | bigint  |
   comm_id       | bigint  |
   dso_id        | bigint  |
   symbol_id     | bigint  |
   sym_offset    | bigint  |
   ip            | bigint  |
   time          | bigint  |
   cpu           | integer |
   to_dso_id     | bigint  |
   to_symbol_id  | bigint  |
   to_sym_offset | bigint  |
   to_ip         | bigint  |
   period        | bigint  |
   weight        | bigint  |
   transaction   | bigint  |
   data_src      | bigint  |
  Indexes:
      "samples_pkey" PRIMARY KEY, btree (id)
  Foreign-key constraints:
      "commfk" FOREIGN KEY (comm_id) REFERENCES comms(id)
      "dsofk" FOREIGN KEY (dso_id) REFERENCES dsos(id)
      "evselfk" FOREIGN KEY (evsel_id) REFERENCES selected_events(id)
      "machinefk" FOREIGN KEY (machine_id) REFERENCES machines(id)
      "symbolfk" FOREIGN KEY (symbol_id) REFERENCES symbols(id)
      "threadfk" FOREIGN KEY (thread_id) REFERENCES threads(id)
      "todsofk" FOREIGN KEY (to_dso_id) REFERENCES dsos(id)
      "tosymbolfk" FOREIGN KEY (to_symbol_id) REFERENCES symbols(id)

  lsdb-# \d samples_view
                 View "public.samples_view"
        Column       |          Type           | Modifiers
  -------------------+-------------------------+-----------
   id                | bigint                  |
   time              | bigint                  |
   cpu               | integer                 |
   pid               | integer                 |
   tid               | integer                 |
   command           | character varying(16)   |
   event             | character varying(80)   |
   ip_hex            | text                    |
   symbol            | character varying(2048) |
   sym_offset        | bigint                  |
   dso_short_name    | character varying(256)  |
   to_ip_hex         | text                    |
   to_symbol         | character varying(2048) |
   to_sym_offset     | bigint                  |
   to_dso_short_name | character varying(256)  |

    lsdb=# select * from samples_view;

   id| time       |cpu | pid  | tid  |command| event  |   ip_hex      |           symbol    |sym_off| dso_name|to_ip_hex|to_symbol|to_sym_off|to_dso_name
   --+------------+----+------+------+-------+--------+---------------+---------------------+-------+---------+---------+---------+----------+----------
   1 |12202825015 | -1 | 7339 | 7339 |:17339 | cycles | fffff8104d24a |native_write_msr_safe|    10 | [kernel]| 0       | unknown |         0| unknown
   2 |12203258804 | -1 | 7339 | 7339 |:17339 | cycles | fffff8104d24a |native_write_msr_safe|    10 | [kernel]| 0       | unknown |         0| unknown
   3 |12203988119 | -1 | 7339 | 7339 |:17339 | cycles | fffff8104d24a |native_write_msr_safe|    10 | [kernel]| 0       | unknown |         0| unknown

My notes (which may be out-of-date) on setting up postgresql so you can
create databases:

fedora:

        $ sudo yum install postgresql postgresql-server python-pyside qt-postgresql
        $ sudo su - postgres -c initdb
        $ sudo service postgresql start
        $ sudo su - postgres
        $ createuser -s <your username>

I used the the unix user name in createuser.

If it fails, try createuser without -s and answer the following question
to allow your user to create tables:

        Shall the new role be a superuser? (y/n) y

ubuntu:

        $ sudo apt-get install postgresql
        $ sudo su - postgres
        $ createuser <your username>
        Shall the new role be a superuser? (y/n) y

You may want to disable automatic startup.  One way is to edit
/etc/postgresql/9.3/main/start.conf.  Another is to disable the init
script e.g. sudo update-rc.d postgresql disable

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414061124-26830-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../scripts/python/bin/export-to-postgresql-record |   8 +
 .../scripts/python/bin/export-to-postgresql-report |  24 ++
 tools/perf/scripts/python/export-to-postgresql.py  | 360 +++++++++++++++++++++
 3 files changed, 392 insertions(+)

diff --git a/tools/perf/scripts/python/bin/export-to-postgresql-record b/tools/perf/scripts/python/bin/export-to-postgresql-record
new file mode 100644
index 0000000..221d66e
--- /dev/null
+++ b/tools/perf/scripts/python/bin/export-to-postgresql-record
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+#
+# export perf data to a postgresql database. Can cover
+# perf ip samples (excluding the tracepoints). No special
+# record requirements, just record what you want to export.
+#
+perf record $@
diff --git a/tools/perf/scripts/python/bin/export-to-postgresql-report b/tools/perf/scripts/python/bin/export-to-postgresql-report
new file mode 100644
index 0000000..a8fdd15
--- /dev/null
+++ b/tools/perf/scripts/python/bin/export-to-postgresql-report
@@ -0,0 +1,24 @@
+#!/bin/bash
+# description: export perf data to a postgresql database
+# args: [database name] [columns]
+n_args=0
+for i in "$@"
+do
+    if expr match "$i" "-" > /dev/null ; then
+	break
+    fi
+    n_args=$(( $n_args + 1 ))
+done
+if [ "$n_args" -gt 2 ] ; then
+    echo "usage: export-to-postgresql-report [database name] [columns]"
+    exit
+fi
+if [ "$n_args" -gt 1 ] ; then
+    dbname=$1
+    columns=$2
+    shift 2
+elif [ "$n_args" -gt 0 ] ; then
+    dbname=$1
+    shift
+fi
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/export-to-postgresql.py $dbname $columns
diff --git a/tools/perf/scripts/python/export-to-postgresql.py b/tools/perf/scripts/python/export-to-postgresql.py
new file mode 100644
index 0000000..d8f6df0
--- /dev/null
+++ b/tools/perf/scripts/python/export-to-postgresql.py
@@ -0,0 +1,360 @@
+# export-to-postgresql.py: export perf data to a postgresql database
+# Copyright (c) 2014, Intel Corporation.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+# more details.
+
+import os
+import sys
+import struct
+import datetime
+
+from PySide.QtSql import *
+
+# Need to access PostgreSQL C library directly to use COPY FROM STDIN
+from ctypes import *
+libpq = CDLL("libpq.so.5")
+PQconnectdb = libpq.PQconnectdb
+PQconnectdb.restype = c_void_p
+PQfinish = libpq.PQfinish
+PQstatus = libpq.PQstatus
+PQexec = libpq.PQexec
+PQexec.restype = c_void_p
+PQresultStatus = libpq.PQresultStatus
+PQputCopyData = libpq.PQputCopyData
+PQputCopyData.argtypes = [ c_void_p, c_void_p, c_int ]
+PQputCopyEnd = libpq.PQputCopyEnd
+PQputCopyEnd.argtypes = [ c_void_p, c_void_p ]
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+# These perf imports are not used at present
+#from perf_trace_context import *
+#from Core import *
+
+perf_db_export_mode = True
+
+def usage():
+	print >> sys.stderr, "Usage is: export-to-postgresql.py <database name> [<columns>]"
+	print >> sys.stderr, "where:	columns		'all' or 'branches'"
+	raise Exception("Too few arguments")
+
+if (len(sys.argv) < 2):
+	usage()
+
+dbname = sys.argv[1]
+
+if (len(sys.argv) >= 3):
+	columns = sys.argv[2]
+else:
+	columns = "all"
+
+if columns not in ("all", "branches"):
+	usage()
+
+branches = (columns == "branches")
+
+output_dir_name = os.getcwd() + "/" + dbname + "-perf-data"
+os.mkdir(output_dir_name)
+
+def do_query(q, s):
+	if (q.exec_(s)):
+		return
+	raise Exception("Query failed: " + q.lastError().text())
+
+print datetime.datetime.today(), "Creating database..."
+
+db = QSqlDatabase.addDatabase('QPSQL')
+query = QSqlQuery(db)
+db.setDatabaseName('postgres')
+db.open()
+try:
+	do_query(query, 'CREATE DATABASE ' + dbname)
+except:
+	os.rmdir(output_dir_name)
+	raise
+query.finish()
+query.clear()
+db.close()
+
+db.setDatabaseName(dbname)
+db.open()
+
+query = QSqlQuery(db)
+do_query(query, 'SET client_min_messages TO WARNING')
+
+do_query(query, 'CREATE TABLE selected_events ('
+		'id		bigint		NOT NULL,'
+		'name		varchar(80))')
+do_query(query, 'CREATE TABLE machines ('
+		'id		bigint		NOT NULL,'
+		'pid		integer,'
+		'root_dir 	varchar(4096))')
+do_query(query, 'CREATE TABLE threads ('
+		'id		bigint		NOT NULL,'
+		'machine_id	bigint,'
+		'process_id	bigint,'
+		'pid		integer,'
+		'tid		integer)')
+do_query(query, 'CREATE TABLE comms ('
+		'id		bigint		NOT NULL,'
+		'comm		varchar(16))')
+do_query(query, 'CREATE TABLE comm_threads ('
+		'id		bigint		NOT NULL,'
+		'comm_id	bigint,'
+		'thread_id	bigint)')
+do_query(query, 'CREATE TABLE dsos ('
+		'id		bigint		NOT NULL,'
+		'machine_id	bigint,'
+		'short_name	varchar(256),'
+		'long_name	varchar(4096),'
+		'build_id	varchar(64))')
+do_query(query, 'CREATE TABLE symbols ('
+		'id		bigint		NOT NULL,'
+		'dso_id		bigint,'
+		'sym_start	bigint,'
+		'sym_end	bigint,'
+		'binding	integer,'
+		'name		varchar(2048))')
+if branches:
+	do_query(query, 'CREATE TABLE samples ('
+		'id		bigint		NOT NULL,'
+		'evsel_id	bigint,'
+		'machine_id	bigint,'
+		'thread_id	bigint,'
+		'comm_id	bigint,'
+		'dso_id		bigint,'
+		'symbol_id	bigint,'
+		'sym_offset	bigint,'
+		'ip		bigint,'
+		'time		bigint,'
+		'cpu		integer,'
+		'to_dso_id	bigint,'
+		'to_symbol_id	bigint,'
+		'to_sym_offset	bigint,'
+		'to_ip		bigint)')
+else:
+	do_query(query, 'CREATE TABLE samples ('
+		'id		bigint		NOT NULL,'
+		'evsel_id	bigint,'
+		'machine_id	bigint,'
+		'thread_id	bigint,'
+		'comm_id	bigint,'
+		'dso_id		bigint,'
+		'symbol_id	bigint,'
+		'sym_offset	bigint,'
+		'ip		bigint,'
+		'time		bigint,'
+		'cpu		integer,'
+		'to_dso_id	bigint,'
+		'to_symbol_id	bigint,'
+		'to_sym_offset	bigint,'
+		'to_ip		bigint,'
+		'period		bigint,'
+		'weight		bigint,'
+		'transaction	bigint,'
+		'data_src	bigint)')
+
+do_query(query, 'CREATE VIEW samples_view AS '
+	'SELECT '
+		'id,'
+		'time,'
+		'cpu,'
+		'(SELECT pid FROM threads WHERE id = thread_id) AS pid,'
+		'(SELECT tid FROM threads WHERE id = thread_id) AS tid,'
+		'(SELECT comm FROM comms WHERE id = comm_id) AS command,'
+		'(SELECT name FROM selected_events WHERE id = evsel_id) AS event,'
+		'to_hex(ip) AS ip_hex,'
+		'(SELECT name FROM symbols WHERE id = symbol_id) AS symbol,'
+		'sym_offset,'
+		'(SELECT short_name FROM dsos WHERE id = dso_id) AS dso_short_name,'
+		'to_hex(to_ip) AS to_ip_hex,'
+		'(SELECT name FROM symbols WHERE id = to_symbol_id) AS to_symbol,'
+		'to_sym_offset,'
+		'(SELECT short_name FROM dsos WHERE id = to_dso_id) AS to_dso_short_name'
+	' FROM samples')
+
+
+file_header = struct.pack("!11sii", "PGCOPY\n\377\r\n\0", 0, 0)
+file_trailer = "\377\377"
+
+def open_output_file(file_name):
+	path_name = output_dir_name + "/" + file_name
+	file = open(path_name, "w+")
+	file.write(file_header)
+	return file
+
+def close_output_file(file):
+	file.write(file_trailer)
+	file.close()
+
+def copy_output_file_direct(file, table_name):
+	close_output_file(file)
+	sql = "COPY " + table_name + " FROM '" + file.name + "' (FORMAT 'binary')"
+	do_query(query, sql)
+
+# Use COPY FROM STDIN because security may prevent postgres from accessing the files directly
+def copy_output_file(file, table_name):
+	conn = PQconnectdb("dbname = " + dbname)
+	if (PQstatus(conn)):
+		raise Exception("COPY FROM STDIN PQconnectdb failed")
+	file.write(file_trailer)
+	file.seek(0)
+	sql = "COPY " + table_name + " FROM STDIN (FORMAT 'binary')"
+	res = PQexec(conn, sql)
+	if (PQresultStatus(res) != 4):
+		raise Exception("COPY FROM STDIN PQexec failed")
+	data = file.read(65536)
+	while (len(data)):
+		ret = PQputCopyData(conn, data, len(data))
+		if (ret != 1):
+			raise Exception("COPY FROM STDIN PQputCopyData failed, error " + str(ret))
+		data = file.read(65536)
+	ret = PQputCopyEnd(conn, None)
+	if (ret != 1):
+		raise Exception("COPY FROM STDIN PQputCopyEnd failed, error " + str(ret))
+	PQfinish(conn)
+
+def remove_output_file(file):
+	name = file.name
+	file.close()
+	os.unlink(name)
+
+evsel_file		= open_output_file("evsel_table.bin")
+machine_file		= open_output_file("machine_table.bin")
+thread_file		= open_output_file("thread_table.bin")
+comm_file		= open_output_file("comm_table.bin")
+comm_thread_file	= open_output_file("comm_thread_table.bin")
+dso_file		= open_output_file("dso_table.bin")
+symbol_file		= open_output_file("symbol_table.bin")
+sample_file		= open_output_file("sample_table.bin")
+
+def trace_begin():
+	print datetime.datetime.today(), "Writing to intermediate files..."
+	# id == 0 means unknown.  It is easier to create records for them than replace the zeroes with NULLs
+	evsel_table(0, "unknown")
+	machine_table(0, 0, "unknown")
+	thread_table(0, 0, 0, -1, -1)
+	comm_table(0, "unknown")
+	dso_table(0, 0, "unknown", "unknown", "")
+	symbol_table(0, 0, 0, 0, 0, "unknown")
+
+unhandled_count = 0
+
+def trace_end():
+	print datetime.datetime.today(), "Copying to database..."
+	copy_output_file(evsel_file,		"selected_events")
+	copy_output_file(machine_file,		"machines")
+	copy_output_file(thread_file,		"threads")
+	copy_output_file(comm_file,		"comms")
+	copy_output_file(comm_thread_file,	"comm_threads")
+	copy_output_file(dso_file,		"dsos")
+	copy_output_file(symbol_file,		"symbols")
+	copy_output_file(sample_file,		"samples")
+
+	print datetime.datetime.today(), "Removing intermediate files..."
+	remove_output_file(evsel_file)
+	remove_output_file(machine_file)
+	remove_output_file(thread_file)
+	remove_output_file(comm_file)
+	remove_output_file(comm_thread_file)
+	remove_output_file(dso_file)
+	remove_output_file(symbol_file)
+	remove_output_file(sample_file)
+	os.rmdir(output_dir_name)
+	print datetime.datetime.today(), "Adding primary keys"
+	do_query(query, 'ALTER TABLE selected_events ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE machines        ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE threads         ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE comms           ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE comm_threads    ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE dsos            ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE symbols         ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE samples         ADD PRIMARY KEY (id)')
+
+	print datetime.datetime.today(), "Adding foreign keys"
+	do_query(query, 'ALTER TABLE threads '
+					'ADD CONSTRAINT machinefk  FOREIGN KEY (machine_id)   REFERENCES machines   (id),'
+					'ADD CONSTRAINT processfk  FOREIGN KEY (process_id)   REFERENCES threads    (id)')
+	do_query(query, 'ALTER TABLE comm_threads '
+					'ADD CONSTRAINT commfk     FOREIGN KEY (comm_id)      REFERENCES comms      (id),'
+					'ADD CONSTRAINT threadfk   FOREIGN KEY (thread_id)    REFERENCES threads    (id)')
+	do_query(query, 'ALTER TABLE dsos '
+					'ADD CONSTRAINT machinefk  FOREIGN KEY (machine_id)   REFERENCES machines   (id)')
+	do_query(query, 'ALTER TABLE symbols '
+					'ADD CONSTRAINT dsofk      FOREIGN KEY (dso_id)       REFERENCES dsos       (id)')
+	do_query(query, 'ALTER TABLE samples '
+					'ADD CONSTRAINT evselfk    FOREIGN KEY (evsel_id)     REFERENCES selected_events (id),'
+					'ADD CONSTRAINT machinefk  FOREIGN KEY (machine_id)   REFERENCES machines   (id),'
+					'ADD CONSTRAINT threadfk   FOREIGN KEY (thread_id)    REFERENCES threads    (id),'
+					'ADD CONSTRAINT commfk     FOREIGN KEY (comm_id)      REFERENCES comms      (id),'
+					'ADD CONSTRAINT dsofk      FOREIGN KEY (dso_id)       REFERENCES dsos       (id),'
+					'ADD CONSTRAINT symbolfk   FOREIGN KEY (symbol_id)    REFERENCES symbols    (id),'
+					'ADD CONSTRAINT todsofk    FOREIGN KEY (to_dso_id)    REFERENCES dsos       (id),'
+					'ADD CONSTRAINT tosymbolfk FOREIGN KEY (to_symbol_id) REFERENCES symbols    (id)')
+
+	if (unhandled_count):
+		print datetime.datetime.today(), "Warning: ", unhandled_count, " unhandled events"
+	print datetime.datetime.today(), "Done"
+
+def trace_unhandled(event_name, context, event_fields_dict):
+	global unhandled_count
+	unhandled_count += 1
+
+def sched__sched_switch(*x):
+	pass
+
+def evsel_table(evsel_id, evsel_name, *x):
+	n = len(evsel_name)
+	fmt = "!hiqi" + str(n) + "s"
+	value = struct.pack(fmt, 2, 8, evsel_id, n, evsel_name)
+	evsel_file.write(value)
+
+def machine_table(machine_id, pid, root_dir, *x):
+	n = len(root_dir)
+	fmt = "!hiqiii" + str(n) + "s"
+	value = struct.pack(fmt, 3, 8, machine_id, 4, pid, n, root_dir)
+	machine_file.write(value)
+
+def thread_table(thread_id, machine_id, process_id, pid, tid, *x):
+	value = struct.pack("!hiqiqiqiiii", 5, 8, thread_id, 8, machine_id, 8, process_id, 4, pid, 4, tid)
+	thread_file.write(value)
+
+def comm_table(comm_id, comm_str, *x):
+	n = len(comm_str)
+	fmt = "!hiqi" + str(n) + "s"
+	value = struct.pack(fmt, 2, 8, comm_id, n, comm_str)
+	comm_file.write(value)
+
+def comm_thread_table(comm_thread_id, comm_id, thread_id, *x):
+	fmt = "!hiqiqiq"
+	value = struct.pack(fmt, 3, 8, comm_thread_id, 8, comm_id, 8, thread_id)
+	comm_thread_file.write(value)
+
+def dso_table(dso_id, machine_id, short_name, long_name, build_id, *x):
+	n1 = len(short_name)
+	n2 = len(long_name)
+	n3 = len(build_id)
+	fmt = "!hiqiqi" + str(n1) + "si"  + str(n2) + "si" + str(n3) + "s"
+	value = struct.pack(fmt, 5, 8, dso_id, 8, machine_id, n1, short_name, n2, long_name, n3, build_id)
+	dso_file.write(value)
+
+def symbol_table(symbol_id, dso_id, sym_start, sym_end, binding, symbol_name, *x):
+	n = len(symbol_name)
+	fmt = "!hiqiqiqiqiii" + str(n) + "s"
+	value = struct.pack(fmt, 6, 8, symbol_id, 8, dso_id, 8, sym_start, 8, sym_end, 4, binding, n, symbol_name)
+	symbol_file.write(value)
+
+def sample_table(sample_id, evsel_id, machine_id, thread_id, comm_id, dso_id, symbol_id, sym_offset, ip, time, cpu, to_dso_id, to_symbol_id, to_sym_offset, to_ip, period, weight, transaction, data_src, *x):
+	if branches:
+		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiq", 15, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip)
+	else:
+		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiqiqiqiqiq", 19, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip, 8, period, 8, weight, 8, transaction, 8, data_src)
+	sample_file.write(value)
