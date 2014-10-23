Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaJWKuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:50:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:60790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbaJWKr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:47:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="594446029"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/16] perf tools: Add branch_type and in_tx to Python export
Date: Thu, 23 Oct 2014 13:45:17 +0300
Message-Id: <1414061124-26830-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add branch_type and in_tx to Python db export and
the export-to-postgresql.py script.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/scripts/python/export-to-postgresql.py  | 32 ++++++++++++++++++----
 .../util/scripting-engines/trace-event-python.c    | 30 +++++++++++++++++++-
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/tools/perf/scripts/python/export-to-postgresql.py b/tools/perf/scripts/python/export-to-postgresql.py
index d8f6df0..bb79aec 100644
--- a/tools/perf/scripts/python/export-to-postgresql.py
+++ b/tools/perf/scripts/python/export-to-postgresql.py
@@ -123,6 +123,10 @@ do_query(query, 'CREATE TABLE symbols ('
 		'sym_end	bigint,'
 		'binding	integer,'
 		'name		varchar(2048))')
+do_query(query, 'CREATE TABLE branch_types ('
+		'id		integer		NOT NULL,'
+		'name		varchar(80))')
+
 if branches:
 	do_query(query, 'CREATE TABLE samples ('
 		'id		bigint		NOT NULL,'
@@ -139,7 +143,9 @@ if branches:
 		'to_dso_id	bigint,'
 		'to_symbol_id	bigint,'
 		'to_sym_offset	bigint,'
-		'to_ip		bigint)')
+		'to_ip		bigint,'
+		'branch_type	integer,'
+		'in_tx		boolean)')
 else:
 	do_query(query, 'CREATE TABLE samples ('
 		'id		bigint		NOT NULL,'
@@ -160,7 +166,9 @@ else:
 		'period		bigint,'
 		'weight		bigint,'
 		'transaction	bigint,'
-		'data_src	bigint)')
+		'data_src	bigint,'
+		'branch_type	integer,'
+		'in_tx		boolean)')
 
 do_query(query, 'CREATE VIEW samples_view AS '
 	'SELECT '
@@ -178,7 +186,9 @@ do_query(query, 'CREATE VIEW samples_view AS '
 		'to_hex(to_ip) AS to_ip_hex,'
 		'(SELECT name FROM symbols WHERE id = to_symbol_id) AS to_symbol,'
 		'to_sym_offset,'
-		'(SELECT short_name FROM dsos WHERE id = to_dso_id) AS to_dso_short_name'
+		'(SELECT short_name FROM dsos WHERE id = to_dso_id) AS to_dso_short_name,'
+		'(SELECT name FROM branch_types WHERE id = branch_type) AS branch_type_name,'
+		'in_tx'
 	' FROM samples')
 
 
@@ -234,6 +244,7 @@ comm_file		= open_output_file("comm_table.bin")
 comm_thread_file	= open_output_file("comm_thread_table.bin")
 dso_file		= open_output_file("dso_table.bin")
 symbol_file		= open_output_file("symbol_table.bin")
+branch_type_file	= open_output_file("branch_type_table.bin")
 sample_file		= open_output_file("sample_table.bin")
 
 def trace_begin():
@@ -257,6 +268,7 @@ def trace_end():
 	copy_output_file(comm_thread_file,	"comm_threads")
 	copy_output_file(dso_file,		"dsos")
 	copy_output_file(symbol_file,		"symbols")
+	copy_output_file(branch_type_file,	"branch_types")
 	copy_output_file(sample_file,		"samples")
 
 	print datetime.datetime.today(), "Removing intermediate files..."
@@ -267,6 +279,7 @@ def trace_end():
 	remove_output_file(comm_thread_file)
 	remove_output_file(dso_file)
 	remove_output_file(symbol_file)
+	remove_output_file(branch_type_file)
 	remove_output_file(sample_file)
 	os.rmdir(output_dir_name)
 	print datetime.datetime.today(), "Adding primary keys"
@@ -277,6 +290,7 @@ def trace_end():
 	do_query(query, 'ALTER TABLE comm_threads    ADD PRIMARY KEY (id)')
 	do_query(query, 'ALTER TABLE dsos            ADD PRIMARY KEY (id)')
 	do_query(query, 'ALTER TABLE symbols         ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE branch_types    ADD PRIMARY KEY (id)')
 	do_query(query, 'ALTER TABLE samples         ADD PRIMARY KEY (id)')
 
 	print datetime.datetime.today(), "Adding foreign keys"
@@ -352,9 +366,15 @@ def symbol_table(symbol_id, dso_id, sym_start, sym_end, binding, symbol_name, *x
 	value = struct.pack(fmt, 6, 8, symbol_id, 8, dso_id, 8, sym_start, 8, sym_end, 4, binding, n, symbol_name)
 	symbol_file.write(value)
 
-def sample_table(sample_id, evsel_id, machine_id, thread_id, comm_id, dso_id, symbol_id, sym_offset, ip, time, cpu, to_dso_id, to_symbol_id, to_sym_offset, to_ip, period, weight, transaction, data_src, *x):
+def branch_type_table(branch_type, name, *x):
+	n = len(name)
+	fmt = "!hiii" + str(n) + "s"
+	value = struct.pack(fmt, 2, 4, branch_type, n, name)
+	branch_type_file.write(value)
+
+def sample_table(sample_id, evsel_id, machine_id, thread_id, comm_id, dso_id, symbol_id, sym_offset, ip, time, cpu, to_dso_id, to_symbol_id, to_sym_offset, to_ip, period, weight, transaction, data_src, branch_type, in_tx, *x):
 	if branches:
-		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiq", 15, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip)
+		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiqiiiB", 17, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip, 4, branch_type, 1, in_tx)
 	else:
-		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiqiqiqiqiq", 19, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip, 8, period, 8, weight, 8, transaction, 8, data_src)
+		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiqiqiqiqiqiiiB", 21, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip, 8, period, 8, weight, 8, transaction, 8, data_src, 4, branch_type, 1, in_tx)
 	sample_file.write(value)
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 539e23d..553aded 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -66,6 +66,7 @@ struct tables {
 	PyObject		*comm_thread_handler;
 	PyObject		*dso_handler;
 	PyObject		*symbol_handler;
+	PyObject		*branch_type_handler;
 	PyObject		*sample_handler;
 	bool			db_export_mode;
 };
@@ -663,13 +664,31 @@ static int python_export_symbol(struct db_export *dbe, struct symbol *sym,
 	return 0;
 }
 
+static int python_export_branch_type(struct db_export *dbe, u32 branch_type,
+				     const char *name)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(2);
+
+	tuple_set_s32(t, 0, branch_type);
+	tuple_set_string(t, 1, name);
+
+	call_object(tables->branch_type_handler, t, "branch_type_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
 static int python_export_sample(struct db_export *dbe,
 				struct export_sample *es)
 {
 	struct tables *tables = container_of(dbe, struct tables, dbe);
 	PyObject *t;
 
-	t = tuple_new(19);
+	t = tuple_new(21);
 
 	tuple_set_u64(t, 0, es->db_id);
 	tuple_set_u64(t, 1, es->evsel->db_id);
@@ -690,6 +709,8 @@ static int python_export_sample(struct db_export *dbe,
 	tuple_set_u64(t, 16, es->sample->weight);
 	tuple_set_u64(t, 17, es->sample->transaction);
 	tuple_set_u64(t, 18, es->sample->data_src);
+	tuple_set_s32(t, 19, es->sample->flags & PERF_BRANCH_MASK);
+	tuple_set_s32(t, 20, !!(es->sample->flags & PERF_FLAG_IN_TX));
 
 	call_object(tables->sample_handler, t, "sample_table");
 
@@ -856,6 +877,7 @@ static void set_table_handlers(struct tables *tables)
 	SET_TABLE_HANDLER(comm_thread);
 	SET_TABLE_HANDLER(dso);
 	SET_TABLE_HANDLER(symbol);
+	SET_TABLE_HANDLER(branch_type);
 	SET_TABLE_HANDLER(sample);
 }
 
@@ -905,6 +927,12 @@ static int python_start_script(const char *script, int argc, const char **argv)
 
 	set_table_handlers(tables);
 
+	if (tables->db_export_mode) {
+		err = db_export__branch_types(&tables->dbe);
+		if (err)
+			goto error;
+	}
+
 	return err;
 error:
 	Py_Finalize();
-- 
1.9.1

