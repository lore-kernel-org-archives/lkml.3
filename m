Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaGEKm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:42:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaGEKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:42:50 -0400
Date: Sat, 5 Jul 2014 03:42:40 -0700
From: tip-bot for Sebastian Andrzej Siewior <tipbot@zytor.com>
Message-ID: <tip-33058b948e545a911e388e69b8be7274da158fb6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, bigeasy@linutronix.de, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, bigeasy@linutronix.de,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Move the number processing into its own function
Git-Commit-ID: 33058b948e545a911e388e69b8be7274da158fb6
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

Commit-ID:  33058b948e545a911e388e69b8be7274da158fb6
Gitweb:     http://git.kernel.org/tip/33058b948e545a911e388e69b8be7274da158fb6
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 27 May 2014 18:14:33 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 27 Jun 2014 11:14:57 +0200

perf script: Move the number processing into its own function

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
