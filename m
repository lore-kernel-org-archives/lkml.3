Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbaGQQNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:13:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:52183 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672AbaGQQN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:13:27 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/33] perf script: Provide additional sample information on generic events
Date: Thu, 17 Jul 2014 13:12:09 -0300
Message-Id: <1405613555-23380-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

To python scripts, including pid, tid, and cpu for which the event was
recorded.

At the moment, the pointer to the sample struct is passed to scripts,
which seems to be of little use.

The patch puts this information in dictionaries for easy access by
Python scripts.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Link: http://lkml.kernel.org/r/53BE7E20.8080500@tu-dresden.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../util/scripting-engines/trace-event-python.c    | 23 +++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cf65404472cb..b366b48646ca 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -473,7 +473,7 @@ static void python_process_general_event(struct perf_sample *sample,
 					 struct thread *thread,
 					 struct addr_location *al)
 {
-	PyObject *handler, *retval, *t, *dict, *callchain;
+	PyObject *handler, *retval, *t, *dict, *callchain, *dict_sample;
 	static char handler_name[64];
 	unsigned n = 0;
 
@@ -489,6 +489,10 @@ static void python_process_general_event(struct perf_sample *sample,
 	if (!dict)
 		Py_FatalError("couldn't create Python dictionary");
 
+	dict_sample = PyDict_New();
+	if (!dict_sample)
+		Py_FatalError("couldn't create Python dictionary");
+
 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
 
 	handler = PyDict_GetItemString(main_dict, handler_name);
@@ -498,8 +502,21 @@ static void python_process_general_event(struct perf_sample *sample,
 	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
 	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
-	pydict_set_item_string_decref(dict, "sample", PyString_FromStringAndSize(
-			(const char *)sample, sizeof(*sample)));
+
+	pydict_set_item_string_decref(dict_sample, "pid",
+			PyInt_FromLong(sample->pid));
+	pydict_set_item_string_decref(dict_sample, "tid",
+			PyInt_FromLong(sample->tid));
+	pydict_set_item_string_decref(dict_sample, "cpu",
+			PyInt_FromLong(sample->cpu));
+	pydict_set_item_string_decref(dict_sample, "ip",
+			PyLong_FromUnsignedLongLong(sample->ip));
+	pydict_set_item_string_decref(dict_sample, "time",
+			PyLong_FromUnsignedLongLong(sample->time));
+	pydict_set_item_string_decref(dict_sample, "period",
+			PyLong_FromUnsignedLongLong(sample->period));
+	pydict_set_item_string_decref(dict, "sample", dict_sample);
+
 	pydict_set_item_string_decref(dict, "raw_buf", PyString_FromStringAndSize(
 			(const char *)sample->raw_data, sample->raw_size));
 	pydict_set_item_string_decref(dict, "comm",
-- 
1.9.3

