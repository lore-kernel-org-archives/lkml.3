Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3J1Opn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:45:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51841 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab3J1Opm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:45:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf script python: Fix mem leak due to missing Py_DECREFs on dict entries
Date: Mon, 28 Oct 2013 11:45:24 -0300
Message-Id: <1382971525-2078-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382971525-2078-1-git-send-email-acme@infradead.org>
References: <1382971525-2078-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

We are using the Python scripting interface in perf to extract kernel
events relevant for performance analysis of HPC codes. We noticed that
the "perf script" call allocates a significant amount of memory (in the
order of several 100 MiB) during it's run, e.g. 125 MiB for a 25 MiB
input file:

  $> perf record -o perf.data -a -R -g fp \
       -e power:cpu_frequency -e sched:sched_switch \
       -e sched:sched_migrate_task -e sched:sched_process_exit \
       -e sched:sched_process_fork -e sched:sched_process_exec \
       -e cycles  -m 4096 --freq 4000
  $> /usr/bin/time perf script -i perf.data -s dummy_script.py
  0.84user 0.13system 0:01.92elapsed 51%CPU (0avgtext+0avgdata
  125532maxresident)k
  73072inputs+0outputs (57major+33086minor)pagefaults 0swaps

Upon further investigation using the valgrind massif tool, we noticed
that Python objects that are created in trace-event-python.c via
PyString_FromString*() (and their Integer and Long counterparts) are
never free'd.

The reason for this seem to be missing Py_DECREF calls on the objects
that are returned by these functions and stored in the Python
dictionaries. The Python dictionaries do not steal references (as
opposed to Python tuples and lists) but instead add their own reference.

Hence, the reference that is returned by these object creation functions
is never released and the memory is leaked. (see [1,2])

The attached patch fixes this by wrapping all relevant calls to
PyDict_SetItemString() and decrementing the reference counter
immediately after the Python function call.

This reduces the allocated memory to a reasonable amount:

  $> /usr/bin/time perf script -i perf.data -s dummy_script.py
  0.73user 0.05system 0:00.79elapsed 99%CPU (0avgtext+0avgdata
  49132maxresident)k
  0inputs+0outputs (0major+14045minor)pagefaults 0swaps

For comparison, with a 120 MiB input file the memory consumption
reported by time drops from almost 600 MiB to 146 MiB.

The patch has been tested using Linux 3.8.2 with Python 2.7.4 and Linux
3.11.6 with Python 2.7.5.

Please let me know if you need any further information.

[1] http://docs.python.org/2/c-api/tuple.html#PyTuple_SetItem
[2] http://docs.python.org/2/c-api/dict.html#PyDict_SetItemString

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Link: http://lkml.kernel.org/r/1381468543-25334-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    | 37 ++++++++++++++--------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cc75a3cef388..95d91a0b23af 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -56,6 +56,17 @@ static void handler_call_die(const char *handler_name)
 	Py_FatalError("problem in Python trace event handler");
 }
 
+/*
+ * Insert val into into the dictionary and decrement the reference counter.
+ * This is necessary for dictionaries since PyDict_SetItemString() does not 
+ * steal a reference, as opposed to PyTuple_SetItem().
+ */
+static void pydict_set_item_string_decref(PyObject *dict, const char *key, PyObject *val)
+{
+	PyDict_SetItemString(dict, key, val);
+	Py_DECREF(val);
+}
+
 static void define_value(enum print_arg_type field_type,
 			 const char *ev_name,
 			 const char *field_name,
@@ -279,11 +290,11 @@ static void python_process_tracepoint(union perf_event *perf_event
 		PyTuple_SetItem(t, n++, PyInt_FromLong(pid));
 		PyTuple_SetItem(t, n++, PyString_FromString(comm));
 	} else {
-		PyDict_SetItemString(dict, "common_cpu", PyInt_FromLong(cpu));
-		PyDict_SetItemString(dict, "common_s", PyInt_FromLong(s));
-		PyDict_SetItemString(dict, "common_ns", PyInt_FromLong(ns));
-		PyDict_SetItemString(dict, "common_pid", PyInt_FromLong(pid));
-		PyDict_SetItemString(dict, "common_comm", PyString_FromString(comm));
+		pydict_set_item_string_decref(dict, "common_cpu", PyInt_FromLong(cpu));
+		pydict_set_item_string_decref(dict, "common_s", PyInt_FromLong(s));
+		pydict_set_item_string_decref(dict, "common_ns", PyInt_FromLong(ns));
+		pydict_set_item_string_decref(dict, "common_pid", PyInt_FromLong(pid));
+		pydict_set_item_string_decref(dict, "common_comm", PyString_FromString(comm));
 	}
 	for (field = event->format.fields; field; field = field->next) {
 		if (field->flags & FIELD_IS_STRING) {
@@ -313,7 +324,7 @@ static void python_process_tracepoint(union perf_event *perf_event
 		if (handler)
 			PyTuple_SetItem(t, n++, obj);
 		else
-			PyDict_SetItemString(dict, field->name, obj);
+			pydict_set_item_string_decref(dict, field->name, obj);
 
 	}
 	if (!handler)
@@ -370,21 +381,21 @@ static void python_process_general_event(union perf_event *perf_event
 	if (!handler || !PyCallable_Check(handler))
 		goto exit;
 
-	PyDict_SetItemString(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
-	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
+	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
+	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
-	PyDict_SetItemString(dict, "sample", PyString_FromStringAndSize(
+	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSize(
 			(const char *)sample, sizeof(*sample)));
-	PyDict_SetItemString(dict, "raw_buf", PyString_FromStringAndSize(
+	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
 			(const char *)sample->raw_data, sample->raw_size));
-	PyDict_SetItemString(dict, "comm",
+	pydict_set_item_string_decref(dict, "comm",
 			PyString_FromString(thread->comm));
 	if (al->map) {
-		PyDict_SetItemString(dict, "dso",
+		pydict_set_item_string_decref(dict, "dso",
 			PyString_FromString(al->map->dso->name));
 	}
 	if (al->sym) {
-		PyDict_SetItemString(dict, "symbol",
+		pydict_set_item_string_decref(dict, "symbol",
 			PyString_FromString(al->sym->name));
 	}
 
-- 
1.8.1.4

