Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaGJLvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:51:21 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:34768 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbaGJLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:51:18 -0400
Message-ID: <53BE7E20.8080500@tu-dresden.de>
Date: Thu, 10 Jul 2014 13:50:56 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perf script: Provide additional sample information on
 generic events
References: <87wqd5f7j5.fsf@sejong.aot.lge.com> <538F0BF2.1010806@tu-dresden.de> <20140707171706.GA20752@krava.redhat.com> <53BCF1F2.70100@tu-dresden.de> <20140709112721.GC1814@krava.redhat.com> <53BD2AD6.6020309@tu-dresden.de> <20140709114903.GA5767@krava.redhat.com> <53BD4EC1.1060907@tu-dresden.de> <20140709190921.GD5721@kernel.org> <20140709191223.GE5721@kernel.org> <20140709192926.GF5721@kernel.org>
In-Reply-To: <20140709192926.GF5721@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 perf script: Provide additional sample information on
 generic events  to Python scripts, including pid, tid, and cpu for which the
 event was  recorded. At the moment, the pointer to the sample struct is
 passed to  scripts, which seems to be of little use. The patch puts this
 information in  dictionaries for easy access by Python scripts.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Acked-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
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
-- 
1.8.1.2

