Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaF0MV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:21:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbaF0MVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:21:25 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 4/5] perf script: Move the number processing into its own function
Date: Fri, 27 Jun 2014 14:21:00 +0200
Message-Id: <1403871661-18474-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
References: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I was going to change something here and the result was so much on the
right side of the screen that I decided to move that piece into its own
function.
This patch should make no function change except the moving the code
into its own function.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1401207274-8170-1-git-send-email-bigeasy@linutronix.de
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../util/scripting-engines/trace-event-python.c    | 38 +++++++++++++---------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 1c41932..99c2536 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -231,6 +231,28 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
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
@@ -239,7 +261,6 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
-	unsigned long long val;
 	unsigned long s, ns;
 	struct event_format *event;
 	unsigned n = 0;
@@ -303,20 +324,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
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
1.8.3.1

