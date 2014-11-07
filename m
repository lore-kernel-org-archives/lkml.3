Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaKGF3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:29:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57773 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaKGF3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:29:45 -0500
Date: Thu, 6 Nov 2014 21:28:49 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c29414f5cfd641d956c5287848fdd8f25bb2afa3@git.kernel.org>
Cc: namhyung@gmail.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        dsahern@gmail.com, fweisbec@gmail.com, jolsa@redhat.com,
        mingo@kernel.org, hpa@zytor.com, adrian.hunter@intel.com,
        peterz@infradead.org, tglx@linutronix.de, eranian@google.com,
        paulus@samba.org
Reply-To: namhyung@gmail.com, acme@redhat.com, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, hpa@zytor.com, adrian.hunter@intel.com,
        peterz@infradead.org, tglx@linutronix.de, eranian@google.com,
        paulus@samba.org
In-Reply-To: <1414678188-14946-4-git-send-email-adrian.hunter@intel.com>
References: <1414678188-14946-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add branch_type and in_tx to Python export
Git-Commit-ID: c29414f5cfd641d956c5287848fdd8f25bb2afa3
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

Commit-ID:  c29414f5cfd641d956c5287848fdd8f25bb2afa3
Gitweb:     http://git.kernel.org/tip/c29414f5cfd641d956c5287848fdd8f25bb2afa3
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 30 Oct 2014 16:09:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 3 Nov 2014 18:07:34 -0300

perf tools: Add branch_type and in_tx to Python export

Add branch_type and in_tx to Python db export and the
export-to-postgresql.py script.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1414678188-14946-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 2fd7ee8..f3ca779 100644
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
@@ -664,13 +665,31 @@ static int python_export_symbol(struct db_export *dbe, struct symbol *sym,
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
@@ -691,6 +710,8 @@ static int python_export_sample(struct db_export *dbe,
 	tuple_set_u64(t, 16, es->sample->weight);
 	tuple_set_u64(t, 17, es->sample->transaction);
 	tuple_set_u64(t, 18, es->sample->data_src);
+	tuple_set_s32(t, 19, es->sample->flags & PERF_BRANCH_MASK);
+	tuple_set_s32(t, 20, !!(es->sample->flags & PERF_IP_FLAG_IN_TX));
 
 	call_object(tables->sample_handler, t, "sample_table");
 
@@ -861,6 +882,7 @@ static void set_table_handlers(struct tables *tables)
 	SET_TABLE_HANDLER(comm_thread);
 	SET_TABLE_HANDLER(dso);
 	SET_TABLE_HANDLER(symbol);
+	SET_TABLE_HANDLER(branch_type);
 	SET_TABLE_HANDLER(sample);
 }
 
@@ -910,6 +932,12 @@ static int python_start_script(const char *script, int argc, const char **argv)
 
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
