Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab3J1PEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:04:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3J1PD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:03:59 -0400
Date: Mon, 28 Oct 2013 08:03:27 -0700
From: tip-bot for Joseph Schuchart <tipbot@zytor.com>
Message-ID: <tip-c0268e8d1f450e286fc55e77f53a9ede6b72acab@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        tom.zanussi@linux.intel.com, joseph.schuchart@tu-dresden.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tom.zanussi@linux.intel.com, joseph.schuchart@tu-dresden.de,
        tglx@linutronix.de
In-Reply-To: <1381468543-25334-4-git-send-email-namhyung@kernel.org>
References: <1381468543-25334-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script python:
  Fix mem leak due to missing Py_DECREFs on dict entries
Git-Commit-ID: c0268e8d1f450e286fc55e77f53a9ede6b72acab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 28 Oct 2013 08:03:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0268e8d1f450e286fc55e77f53a9ede6b72acab
Gitweb:     http://git.kernel.org/tip/c0268e8d1f450e286fc55e77f53a9ede6b72acab
Author:     Joseph Schuchart <joseph.schuchart@tu-dresden.de>
AuthorDate: Thu, 24 Oct 2013 10:10:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Oct 2013 10:16:54 -0300

perf script python: Fix mem leak due to missing Py_DECREFs on dict entries

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
index cc75a3c..95d91a0 100644
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
 
