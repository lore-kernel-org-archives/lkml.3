Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbaE3QZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:25:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:56055 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500AbaE3QZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:25:34 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: acme@kernel.org
Cc: namhyung.kim@lge.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        jolsa@redhat.com, a.p.zijlstra@chello.nl, mingo@kernel.org,
        paulus@samba.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] perf script: pass more arguments to the python event handler
Date: Fri, 30 May 2014 18:25:23 +0200
Message-Id: <1401467123-12773-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.0.rc4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the current argument list in case of events by
- IP / addr of the event. Currently only the function name is passed.
- seconds and ns as the timestamp. Split into two value to stay close to
  what the trace handler passes.
- the pid of the proccess

I added a common_ prefix to stay close to the naming of the "trace"
handler. Currently I don't mind dropping it since "comm" isn't named
"common_comm". Any suggestions?

All items I added here are already exposed by the generic output i.e.
"perf script"

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 tools/perf/util/scripting-engines/trace-event-python.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 40a815a..591bd97 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -381,6 +381,8 @@ static void python_process_general_event(struct perf_sample *sample,
 {
 	PyObject *handler, *retval, *t, *dict;
 	static char handler_name[64];
+	unsigned long long nsecs = sample->time;
+	unsigned long s, ns;
 	unsigned n = 0;
 
 	/*
@@ -401,6 +403,9 @@ static void python_process_general_event(struct perf_sample *sample,
 	if (!handler || !PyCallable_Check(handler))
 		goto exit;
 
+	s = nsecs / NSECS_PER_SEC;
+	ns = nsecs - s * NSECS_PER_SEC;
+
 	pydict_set_item_string_decref(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
 	pydict_set_item_string_decref(dict, "attr", PyString_FromStringAndSize(
 			(const char *)&evsel->attr, sizeof(evsel->attr)));
@@ -410,6 +415,12 @@ static void python_process_general_event(struct perf_sample *sample,
 			(const char *)sample->raw_data, sample->raw_size));
 	pydict_set_item_string_decref(dict, "comm",
 			PyString_FromString(thread__comm_str(thread)));
+	pydict_set_item_string_decref(dict, "addr",
+			PyLong_FromUnsignedLongLong(sample->ip));
+	pydict_set_item_string_decref(dict, "common_s", PyInt_FromLong(s));
+	pydict_set_item_string_decref(dict, "common_ns", PyInt_FromLong(ns));
+	pydict_set_item_string_decref(dict, "common_pid",
+			PyInt_FromLong(sample->pid));
 	if (al->map) {
 		pydict_set_item_string_decref(dict, "dso",
 			PyString_FromString(al->map->dso->name));
-- 
2.0.0.rc4

