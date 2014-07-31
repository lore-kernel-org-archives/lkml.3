Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaGaGGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:06:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:1809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbaGaGDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:03:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569800045"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/31] perf tools: Extend Python script interface to export data in a database-friendly way
Date: Thu, 31 Jul 2014 09:01:02 +0300
Message-Id: <1406786474-9306-20-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new db_export facility to export data in a
database-friendly way.

A Python script selects the db_export mode by setting
a global variable 'perf_db_export_mode' to True.  The
script then optionally implements functions to receive
table rows.  The functions are:

	evsel_table
	machine_table
	thread_table
	comm_table
	dso_table
	symbol_table
	sample_table

An example script is provided in a subsequent patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 .../util/scripting-engines/trace-event-python.c    | 281 ++++++++++++++++++++-
 1 file changed, 279 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 26e5f14..3062eb8 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -24,6 +24,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <stdbool.h>
 #include <errno.h>
 
 #include "../../perf.h"
@@ -32,6 +33,9 @@
 #include "../util.h"
 #include "../event.h"
 #include "../thread.h"
+#include "../comm.h"
+#include "../machine.h"
+#include "../db-export.h"
 #include "../trace-event.h"
 #include "../machine.h"
 
@@ -52,6 +56,21 @@ static int zero_flag_atom;
 
 static PyObject *main_module, *main_dict;
 
+struct tables {
+	struct db_export	dbe;
+	PyObject		*evsel_handler;
+	PyObject		*machine_handler;
+	PyObject		*thread_handler;
+	PyObject		*comm_handler;
+	PyObject		*comm_thread_handler;
+	PyObject		*dso_handler;
+	PyObject		*symbol_handler;
+	PyObject		*sample_handler;
+	bool			db_export_mode;
+};
+
+static struct tables tables_global;
+
 static void handler_call_die(const char *handler_name) NORETURN;
 static void handler_call_die(const char *handler_name)
 {
@@ -474,6 +493,210 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	Py_DECREF(t);
 }
 
+static PyObject *tuple_new(unsigned int sz)
+{
+	PyObject *t;
+
+	t = PyTuple_New(sz);
+	if (!t)
+		Py_FatalError("couldn't create Python tuple");
+	return t;
+}
+
+static int tuple_set_u64(PyObject *t, unsigned int pos, u64 val)
+{
+#if BITS_PER_LONG == 64
+	return PyTuple_SetItem(t, pos, PyInt_FromLong(val));
+#endif
+#if BITS_PER_LONG == 32
+	return PyTuple_SetItem(t, pos, PyLong_FromLongLong(val));
+#endif
+}
+
+static int tuple_set_s32(PyObject *t, unsigned int pos, s32 val)
+{
+	return PyTuple_SetItem(t, pos, PyInt_FromLong(val));
+}
+
+static int tuple_set_string(PyObject *t, unsigned int pos, const char *s)
+{
+	return PyTuple_SetItem(t, pos, PyString_FromString(s));
+}
+
+static int python_export_evsel(struct db_export *dbe, struct perf_evsel *evsel)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(2);
+
+	tuple_set_u64(t, 0, evsel->db_id);
+	tuple_set_string(t, 1, perf_evsel__name(evsel));
+
+	call_object(tables->evsel_handler, t, "evsel_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_machine(struct db_export *dbe,
+				 struct machine *machine)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(3);
+
+	tuple_set_u64(t, 0, machine->db_id);
+	tuple_set_s32(t, 1, machine->pid);
+	tuple_set_string(t, 2, machine->root_dir ? machine->root_dir : "");
+
+	call_object(tables->machine_handler, t, "machine_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_thread(struct db_export *dbe, struct thread *thread,
+				u64 main_thread_db_id, struct machine *machine)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(5);
+
+	tuple_set_u64(t, 0, thread->db_id);
+	tuple_set_u64(t, 1, machine->db_id);
+	tuple_set_u64(t, 2, main_thread_db_id);
+	tuple_set_s32(t, 3, thread->pid_);
+	tuple_set_s32(t, 4, thread->tid);
+
+	call_object(tables->thread_handler, t, "thread_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_comm(struct db_export *dbe, struct comm *comm)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(2);
+
+	tuple_set_u64(t, 0, comm->db_id);
+	tuple_set_string(t, 1, comm__str(comm));
+
+	call_object(tables->comm_handler, t, "comm_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_comm_thread(struct db_export *dbe, u64 db_id,
+				     struct comm *comm, struct thread *thread)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(3);
+
+	tuple_set_u64(t, 0, db_id);
+	tuple_set_u64(t, 1, comm->db_id);
+	tuple_set_u64(t, 2, thread->db_id);
+
+	call_object(tables->comm_thread_handler, t, "comm_thread_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_dso(struct db_export *dbe, struct dso *dso,
+			     struct machine *machine)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+	PyObject *t;
+
+	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
+
+	t = tuple_new(5);
+
+	tuple_set_u64(t, 0, dso->db_id);
+	tuple_set_u64(t, 1, machine->db_id);
+	tuple_set_string(t, 2, dso->short_name);
+	tuple_set_string(t, 3, dso->long_name);
+	tuple_set_string(t, 4, sbuild_id);
+
+	call_object(tables->dso_handler, t, "dso_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_symbol(struct db_export *dbe, struct symbol *sym,
+				struct dso *dso)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(6);
+
+	tuple_set_u64(t, 0, sym->db_id);
+	tuple_set_u64(t, 1, dso->db_id);
+	tuple_set_u64(t, 2, sym->start);
+	tuple_set_u64(t, 3, sym->end);
+	tuple_set_s32(t, 4, sym->binding);
+	tuple_set_string(t, 5, sym->name);
+
+	call_object(tables->symbol_handler, t, "symbol_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_sample(struct db_export *dbe,
+				struct export_sample *es)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(19);
+
+	tuple_set_u64(t, 0, es->db_id);
+	tuple_set_u64(t, 1, es->evsel->db_id);
+	tuple_set_u64(t, 2, es->al->machine->db_id);
+	tuple_set_u64(t, 3, es->thread->db_id);
+	tuple_set_u64(t, 4, es->comm_db_id);
+	tuple_set_u64(t, 5, es->dso_db_id);
+	tuple_set_u64(t, 6, es->sym_db_id);
+	tuple_set_u64(t, 7, es->offset);
+	tuple_set_u64(t, 8, es->sample->ip);
+	tuple_set_u64(t, 9, es->sample->time);
+	tuple_set_s32(t, 10, es->sample->cpu);
+	tuple_set_u64(t, 11, es->addr_dso_db_id);
+	tuple_set_u64(t, 12, es->addr_sym_db_id);
+	tuple_set_u64(t, 13, es->addr_offset);
+	tuple_set_u64(t, 14, es->sample->addr);
+	tuple_set_u64(t, 15, es->sample->period);
+	tuple_set_u64(t, 16, es->sample->weight);
+	tuple_set_u64(t, 17, es->sample->transaction);
+	tuple_set_u64(t, 18, es->sample->data_src);
+
+	call_object(tables->sample_handler, t, "sample_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
 static void python_process_general_event(struct perf_sample *sample,
 					 struct perf_evsel *evsel,
 					 struct thread *thread,
@@ -550,19 +773,25 @@ exit:
 	Py_DECREF(t);
 }
 
-static void python_process_event(union perf_event *event __maybe_unused,
+static void python_process_event(union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct thread *thread,
 				 struct addr_location *al)
 {
+	struct tables *tables = &tables_global;
+
 	switch (evsel->attr.type) {
 	case PERF_TYPE_TRACEPOINT:
 		python_process_tracepoint(sample, evsel, thread, al);
 		break;
 	/* Reserve for future process_hw/sw/raw APIs */
 	default:
-		python_process_general_event(sample, evsel, thread, al);
+		if (tables->db_export_mode)
+			db_export__sample(&tables->dbe, event, sample, evsel,
+					  thread, al);
+		else
+			python_process_general_event(sample, evsel, thread, al);
 	}
 }
 
@@ -588,11 +817,53 @@ error:
 	return -1;
 }
 
+#define SET_TABLE_HANDLER_(name, handler_name, table_name) do {		\
+	tables->handler_name = get_handler(#table_name);		\
+	if (tables->handler_name)					\
+		tables->dbe.export_ ## name = python_export_ ## name;	\
+} while (0)
+
+#define SET_TABLE_HANDLER(name) \
+	SET_TABLE_HANDLER_(name, name ## _handler, name ## _table)
+
+static void set_table_handlers(struct tables *tables)
+{
+	const char *perf_db_export_mode = "perf_db_export_mode";
+	PyObject *db_export_mode;
+	int ret;
+
+	memset(tables, 0, sizeof(struct tables));
+	if (db_export__init(&tables->dbe))
+		Py_FatalError("failed to initialize export");
+
+	db_export_mode = PyDict_GetItemString(main_dict, perf_db_export_mode);
+	if (!db_export_mode)
+		return;
+
+	ret = PyObject_IsTrue(db_export_mode);
+	if (ret == -1)
+		handler_call_die(perf_db_export_mode);
+	if (!ret)
+		return;
+
+	tables->db_export_mode = true;
+
+	SET_TABLE_HANDLER(evsel);
+	SET_TABLE_HANDLER(machine);
+	SET_TABLE_HANDLER(thread);
+	SET_TABLE_HANDLER(comm);
+	SET_TABLE_HANDLER(comm_thread);
+	SET_TABLE_HANDLER(dso);
+	SET_TABLE_HANDLER(symbol);
+	SET_TABLE_HANDLER(sample);
+}
+
 /*
  * Start trace script
  */
 static int python_start_script(const char *script, int argc, const char **argv)
 {
+	struct tables *tables = &tables_global;
 	const char **command_line;
 	char buf[PATH_MAX];
 	int i, err = 0;
@@ -631,6 +902,8 @@ static int python_start_script(const char *script, int argc, const char **argv)
 
 	free(command_line);
 
+	set_table_handlers(tables);
+
 	return err;
 error:
 	Py_Finalize();
@@ -644,8 +917,12 @@ error:
  */
 static int python_stop_script(void)
 {
+	struct tables *tables = &tables_global;
+
 	try_call_object("trace_end", NULL);
 
+	db_export__exit(&tables->dbe);
+
 	Py_XDECREF(main_dict);
 	Py_XDECREF(main_module);
 	Py_Finalize();
-- 
1.8.3.2

