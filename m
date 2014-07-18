Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbaGREXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:23:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33045 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaGREXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:23:19 -0400
Date: Thu, 17 Jul 2014 21:23:02 -0700
From: tip-bot for Joseph Schuchart <tipbot@zytor.com>
Message-ID: <tip-57608cfd8827a74237d264a197722e2c99f72da4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@gmail.com, jolsa@redhat.com,
        thomas.ilsche@tu-dresden.de, joseph.schuchart@tu-dresden.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, thomas.ilsche@tu-dresden.de, jolsa@redhat.com,
        joseph.schuchart@tu-dresden.de, tglx@linutronix.de
In-Reply-To: <53BE7E20.8080500@tu-dresden.de>
References: <53BE7E20.8080500@tu-dresden.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Provide additional sample information on generic events
Git-Commit-ID: 57608cfd8827a74237d264a197722e2c99f72da4
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

Commit-ID:  57608cfd8827a74237d264a197722e2c99f72da4
Gitweb:     http://git.kernel.org/tip/57608cfd8827a74237d264a197722e2c99f72da4
Author:     Joseph Schuchart <joseph.schuchart@tu-dresden.de>
AuthorDate: Thu, 10 Jul 2014 13:50:56 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:33 -0300

perf script: Provide additional sample information on generic events

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
index cf65404..b366b48 100644
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
