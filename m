Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaJWKrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:47:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:60790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbaJWKrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594446077"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/16] perf tools: Add call information to Python export
Date: Thu, 23 Oct 2014 13:45:20 +0300
Message-Id: <1414061124-26830-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to export detailed information about
paired calls and returns to Python db export and
the export-to-postgresql.py script.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 .../scripts/python/bin/export-to-postgresql-report | 15 ++--
 tools/perf/scripts/python/export-to-postgresql.py  | 66 ++++++++++++++++-
 .../util/scripting-engines/trace-event-python.c    | 84 +++++++++++++++++++++-
 3 files changed, 158 insertions(+), 7 deletions(-)

diff --git a/tools/perf/scripts/python/bin/export-to-postgresql-report b/tools/perf/scripts/python/bin/export-to-postgresql-report
index a8fdd15..cd335b6 100644
--- a/tools/perf/scripts/python/bin/export-to-postgresql-report
+++ b/tools/perf/scripts/python/bin/export-to-postgresql-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: export perf data to a postgresql database
-# args: [database name] [columns]
+# args: [database name] [columns] [calls]
 n_args=0
 for i in "$@"
 do
@@ -9,11 +9,16 @@ do
     fi
     n_args=$(( $n_args + 1 ))
 done
-if [ "$n_args" -gt 2 ] ; then
-    echo "usage: export-to-postgresql-report [database name] [columns]"
+if [ "$n_args" -gt 3 ] ; then
+    echo "usage: export-to-postgresql-report [database name] [columns] [calls]"
     exit
 fi
-if [ "$n_args" -gt 1 ] ; then
+if [ "$n_args" -gt 2 ] ; then
+    dbname=$1
+    columns=$2
+    calls=$3
+    shift 3
+elif [ "$n_args" -gt 1 ] ; then
     dbname=$1
     columns=$2
     shift 2
@@ -21,4 +26,4 @@ elif [ "$n_args" -gt 0 ] ; then
     dbname=$1
     shift
 fi
-perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/export-to-postgresql.py $dbname $columns
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/export-to-postgresql.py $dbname $columns $calls
diff --git a/tools/perf/scripts/python/export-to-postgresql.py b/tools/perf/scripts/python/export-to-postgresql.py
index bb79aec..4cdafd8 100644
--- a/tools/perf/scripts/python/export-to-postgresql.py
+++ b/tools/perf/scripts/python/export-to-postgresql.py
@@ -40,10 +40,12 @@ sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 #from Core import *
 
 perf_db_export_mode = True
+perf_db_export_calls = False
 
 def usage():
-	print >> sys.stderr, "Usage is: export-to-postgresql.py <database name> [<columns>]"
+	print >> sys.stderr, "Usage is: export-to-postgresql.py <database name> [<columns>] [<calls>]"
 	print >> sys.stderr, "where:	columns		'all' or 'branches'"
+	print >> sys.stderr, "		calls		'calls' => create calls table"
 	raise Exception("Too few arguments")
 
 if (len(sys.argv) < 2):
@@ -61,6 +63,12 @@ if columns not in ("all", "branches"):
 
 branches = (columns == "branches")
 
+if (len(sys.argv) >= 4):
+	if (sys.argv[3] == "calls"):
+		perf_db_export_calls = True
+	else:
+		usage()
+
 output_dir_name = os.getcwd() + "/" + dbname + "-perf-data"
 os.mkdir(output_dir_name)
 
@@ -170,6 +178,25 @@ else:
 		'branch_type	integer,'
 		'in_tx		boolean)')
 
+if perf_db_export_calls:
+	do_query(query, 'CREATE TABLE call_paths ('
+		'id		bigint		NOT NULL,'
+		'parent_id	bigint,'
+		'symbol_id	bigint,'
+		'ip		bigint)')
+	do_query(query, 'CREATE TABLE calls ('
+		'id		bigint		NOT NULL,'
+		'thread_id	bigint,'
+		'comm_id	bigint,'
+		'call_path_id	bigint,'
+		'call_time	bigint,'
+		'return_time	bigint,'
+		'branch_count	bigint,'
+		'call_id	bigint,'
+		'return_id	bigint,'
+		'parent_call_path_id	bigint,'
+		'flags		integer)')
+
 do_query(query, 'CREATE VIEW samples_view AS '
 	'SELECT '
 		'id,'
@@ -246,6 +273,9 @@ dso_file		= open_output_file("dso_table.bin")
 symbol_file		= open_output_file("symbol_table.bin")
 branch_type_file	= open_output_file("branch_type_table.bin")
 sample_file		= open_output_file("sample_table.bin")
+if perf_db_export_calls:
+	call_path_file		= open_output_file("call_path_table.bin")
+	call_file		= open_output_file("call_table.bin")
 
 def trace_begin():
 	print datetime.datetime.today(), "Writing to intermediate files..."
@@ -256,6 +286,9 @@ def trace_begin():
 	comm_table(0, "unknown")
 	dso_table(0, 0, "unknown", "unknown", "")
 	symbol_table(0, 0, 0, 0, 0, "unknown")
+	sample_table(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
+	if perf_db_export_calls:
+		call_path_table(0, 0, 0, 0)
 
 unhandled_count = 0
 
@@ -270,6 +303,9 @@ def trace_end():
 	copy_output_file(symbol_file,		"symbols")
 	copy_output_file(branch_type_file,	"branch_types")
 	copy_output_file(sample_file,		"samples")
+	if perf_db_export_calls:
+		copy_output_file(call_path_file,	"call_paths")
+		copy_output_file(call_file,		"calls")
 
 	print datetime.datetime.today(), "Removing intermediate files..."
 	remove_output_file(evsel_file)
@@ -281,6 +317,9 @@ def trace_end():
 	remove_output_file(symbol_file)
 	remove_output_file(branch_type_file)
 	remove_output_file(sample_file)
+	if perf_db_export_calls:
+		remove_output_file(call_path_file)
+		remove_output_file(call_file)
 	os.rmdir(output_dir_name)
 	print datetime.datetime.today(), "Adding primary keys"
 	do_query(query, 'ALTER TABLE selected_events ADD PRIMARY KEY (id)')
@@ -292,6 +331,9 @@ def trace_end():
 	do_query(query, 'ALTER TABLE symbols         ADD PRIMARY KEY (id)')
 	do_query(query, 'ALTER TABLE branch_types    ADD PRIMARY KEY (id)')
 	do_query(query, 'ALTER TABLE samples         ADD PRIMARY KEY (id)')
+	if perf_db_export_calls:
+		do_query(query, 'ALTER TABLE call_paths      ADD PRIMARY KEY (id)')
+		do_query(query, 'ALTER TABLE calls           ADD PRIMARY KEY (id)')
 
 	print datetime.datetime.today(), "Adding foreign keys"
 	do_query(query, 'ALTER TABLE threads '
@@ -313,6 +355,18 @@ def trace_end():
 					'ADD CONSTRAINT symbolfk   FOREIGN KEY (symbol_id)    REFERENCES symbols    (id),'
 					'ADD CONSTRAINT todsofk    FOREIGN KEY (to_dso_id)    REFERENCES dsos       (id),'
 					'ADD CONSTRAINT tosymbolfk FOREIGN KEY (to_symbol_id) REFERENCES symbols    (id)')
+	if perf_db_export_calls:
+		do_query(query, 'ALTER TABLE call_paths '
+					'ADD CONSTRAINT parentfk    FOREIGN KEY (parent_id)    REFERENCES call_paths (id),'
+					'ADD CONSTRAINT symbolfk    FOREIGN KEY (symbol_id)    REFERENCES symbols    (id)')
+		do_query(query, 'ALTER TABLE calls '
+					'ADD CONSTRAINT threadfk    FOREIGN KEY (thread_id)    REFERENCES threads    (id),'
+					'ADD CONSTRAINT commfk      FOREIGN KEY (comm_id)      REFERENCES comms      (id),'
+					'ADD CONSTRAINT call_pathfk FOREIGN KEY (call_path_id) REFERENCES call_paths (id),'
+					'ADD CONSTRAINT callfk      FOREIGN KEY (call_id)      REFERENCES samples    (id),'
+					'ADD CONSTRAINT returnfk    FOREIGN KEY (return_id)    REFERENCES samples    (id),'
+					'ADD CONSTRAINT parent_call_pathfk FOREIGN KEY (parent_call_path_id) REFERENCES call_paths (id)')
+		do_query(query, 'CREATE INDEX pcpid_idx ON calls (parent_call_path_id)')
 
 	if (unhandled_count):
 		print datetime.datetime.today(), "Warning: ", unhandled_count, " unhandled events"
@@ -378,3 +432,13 @@ def sample_table(sample_id, evsel_id, machine_id, thread_id, comm_id, dso_id, sy
 	else:
 		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiqiqiqiqiqiiiB", 21, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip, 8, period, 8, weight, 8, transaction, 8, data_src, 4, branch_type, 1, in_tx)
 	sample_file.write(value)
+
+def call_path_table(cp_id, parent_id, symbol_id, ip, *x):
+	fmt = "!hiqiqiqiq"
+	value = struct.pack(fmt, 4, 8, cp_id, 8, parent_id, 8, symbol_id, 8, ip)
+	call_path_file.write(value)
+
+def call_return_table(cr_id, thread_id, comm_id, call_path_id, call_time, return_time, branch_count, call_id, return_id, parent_call_path_id, flags, *x):
+	fmt = "!hiqiqiqiqiqiqiqiqiqiqii"
+	value = struct.pack(fmt, 11, 8, cr_id, 8, thread_id, 8, comm_id, 8, call_path_id, 8, call_time, 8, return_time, 8, branch_count, 8, call_id, 8, return_id, 8, parent_call_path_id, 4, flags)
+	call_file.write(value)
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 553aded..e7792b7 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -37,6 +37,7 @@
 #include "../comm.h"
 #include "../machine.h"
 #include "../db-export.h"
+#include "../thread-stack.h"
 #include "../trace-event.h"
 #include "../machine.h"
 
@@ -68,6 +69,8 @@ struct tables {
 	PyObject		*symbol_handler;
 	PyObject		*branch_type_handler;
 	PyObject		*sample_handler;
+	PyObject		*call_path_handler;
+	PyObject		*call_return_handler;
 	bool			db_export_mode;
 };
 
@@ -719,6 +722,64 @@ static int python_export_sample(struct db_export *dbe,
 	return 0;
 }
 
+static int python_export_call_path(struct db_export *dbe, struct call_path *cp)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+	u64 parent_db_id, sym_db_id;
+
+	parent_db_id = cp->parent ? cp->parent->db_id : 0;
+	sym_db_id = cp->sym ? cp->sym->db_id : 0;
+
+	t = tuple_new(4);
+
+	tuple_set_u64(t, 0, cp->db_id);
+	tuple_set_u64(t, 1, parent_db_id);
+	tuple_set_u64(t, 2, sym_db_id);
+	tuple_set_u64(t, 3, cp->ip);
+
+	call_object(tables->call_path_handler, t, "call_path_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_call_return(struct db_export *dbe,
+				     struct call_return *cr)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	u64 comm_db_id = cr->comm ? cr->comm->db_id : 0;
+	PyObject *t;
+
+	t = tuple_new(11);
+
+	tuple_set_u64(t, 0, cr->db_id);
+	tuple_set_u64(t, 1, cr->thread->db_id);
+	tuple_set_u64(t, 2, comm_db_id);
+	tuple_set_u64(t, 3, cr->cp->db_id);
+	tuple_set_u64(t, 4, cr->call_time);
+	tuple_set_u64(t, 5, cr->return_time);
+	tuple_set_u64(t, 6, cr->branch_count);
+	tuple_set_u64(t, 7, cr->call_ref);
+	tuple_set_u64(t, 8, cr->return_ref);
+	tuple_set_u64(t, 9, cr->cp->parent->db_id);
+	tuple_set_s32(t, 10, cr->flags);
+
+	call_object(tables->call_return_handler, t, "call_return_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_process_call_return(struct call_return *cr, void *data)
+{
+	struct db_export *dbe = data;
+
+	return db_export__call_return(dbe, cr);
+}
+
 static void python_process_general_event(struct perf_sample *sample,
 					 struct perf_evsel *evsel,
 					 struct thread *thread,
@@ -851,7 +912,9 @@ error:
 static void set_table_handlers(struct tables *tables)
 {
 	const char *perf_db_export_mode = "perf_db_export_mode";
-	PyObject *db_export_mode;
+	const char *perf_db_export_calls = "perf_db_export_calls";
+	PyObject *db_export_mode, *db_export_calls;
+	bool export_calls = false;
 	int ret;
 
 	memset(tables, 0, sizeof(struct tables));
@@ -868,6 +931,23 @@ static void set_table_handlers(struct tables *tables)
 	if (!ret)
 		return;
 
+	tables->dbe.crp = NULL;
+	db_export_calls = PyDict_GetItemString(main_dict, perf_db_export_calls);
+	if (db_export_calls) {
+		ret = PyObject_IsTrue(db_export_calls);
+		if (ret == -1)
+			handler_call_die(perf_db_export_calls);
+		export_calls = !!ret;
+	}
+
+	if (export_calls) {
+		tables->dbe.crp =
+			call_return_processor__new(python_process_call_return,
+						   &tables->dbe);
+		if (!tables->dbe.crp)
+			Py_FatalError("failed to create calls processor");
+	}
+
 	tables->db_export_mode = true;
 
 	SET_TABLE_HANDLER(evsel);
@@ -879,6 +959,8 @@ static void set_table_handlers(struct tables *tables)
 	SET_TABLE_HANDLER(symbol);
 	SET_TABLE_HANDLER(branch_type);
 	SET_TABLE_HANDLER(sample);
+	SET_TABLE_HANDLER(call_path);
+	SET_TABLE_HANDLER(call_return);
 }
 
 /*
-- 
1.9.1

