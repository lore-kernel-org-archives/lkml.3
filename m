Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaE0QOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:14:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:56107 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaE0QOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:14:49 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] perf script: move the number processing into its own function
Date: Tue, 27 May 2014 18:14:33 +0200
Message-Id: <1401207274-8170-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.0.rc4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was going to change something here and the result was so much on the
right side of the screen that I decided to move that piece into its own
function.
This patch should make no function change except the moving the code
into its own function.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../util/scripting-engines/trace-event-python.c    | 38 +++++++++++++---------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cd9774d..aa11790 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -230,6 +230,28 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 	return event;
 }
 
+static PyObject *get_field_numeric_entry(struct event_format *event,
+		struct format_field *field, void *data)
+{
+	PyObject *obj;
+	unsigned long long val;
+
+	val = read_size(event, data + field->offset, field->size);
+	if (field->flags & FIELD_IS_SIGNED) {
+		if ((long long)val >= LONG_MIN &&
+				(long long)val <= LONG_MAX)
+			obj = PyInt_FromLong(val);
+		else
+			obj = PyLong_FromLongLong(val);
+	} else {
+		if (val <= LONG_MAX)
+			obj = PyInt_FromLong(val);
+		else
+			obj = PyLong_FromUnsignedLongLong(val);
+	}
+	return obj;
+}
+
 static void python_process_tracepoint(struct perf_sample *sample,
 				      struct perf_evsel *evsel,
 				      struct thread *thread,
@@ -238,7 +260,6 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
-	unsigned long long val;
 	unsigned long s, ns;
 	struct event_format *event;
 	unsigned n = 0;
@@ -302,20 +323,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 				offset = field->offset;
 			obj = PyString_FromString((char *)data + offset);
 		} else { /* FIELD_IS_NUMERIC */
-			val = read_size(event, data + field->offset,
-					field->size);
-			if (field->flags & FIELD_IS_SIGNED) {
-				if ((long long)val >= LONG_MIN &&
-				    (long long)val <= LONG_MAX)
-					obj = PyInt_FromLong(val);
-				else
-					obj = PyLong_FromLongLong(val);
-			} else {
-				if (val <= LONG_MAX)
-					obj = PyInt_FromLong(val);
-				else
-					obj = PyLong_FromUnsignedLongLong(val);
-			}
+			obj = get_field_numeric_entry(event, field, data);
 		}
 		if (handler)
 			PyTuple_SetItem(t, n++, obj);
-- 
2.0.0.rc4

