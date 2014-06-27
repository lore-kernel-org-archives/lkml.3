Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaF0MVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:21:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbaF0MV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:21:26 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5/5] perf script: Handle the num array type in python properly
Date: Fri, 27 Jun 2014 14:21:01 +0200
Message-Id: <1403871661-18474-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
References: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The raw_syscalls:sys_enter tracer for instance passes has one argument
named 'arg' which is an array of 6 integers. Right the python scripts
gets only 0 passed as an argument. The reason is that
pevent_read_number() can not handle data types of 48 and returns always
0.
This patch changes this by passing num array as list of nums which fit
the description. As a result python will now see a list named arg which
contains 6 (integer) items.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1401207274-8170-2-git-send-email-bigeasy@linutronix.de
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../util/scripting-engines/trace-event-python.c    | 43 ++++++++++++++++------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 99c2536..e55b65a 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -234,22 +234,41 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
 static PyObject *get_field_numeric_entry(struct event_format *event,
 		struct format_field *field, void *data)
 {
-	PyObject *obj;
+	bool is_array = field->flags & FIELD_IS_ARRAY;
+	PyObject *obj, *list = NULL;
 	unsigned long long val;
+	unsigned int item_size, n_items, i;
 
-	val = read_size(event, data + field->offset, field->size);
-	if (field->flags & FIELD_IS_SIGNED) {
-		if ((long long)val >= LONG_MIN &&
-				(long long)val <= LONG_MAX)
-			obj = PyInt_FromLong(val);
-		else
-			obj = PyLong_FromLongLong(val);
+	if (is_array) {
+		list = PyList_New(field->arraylen);
+		item_size = field->size / field->arraylen;
+		n_items = field->arraylen;
 	} else {
-		if (val <= LONG_MAX)
-			obj = PyInt_FromLong(val);
-		else
-			obj = PyLong_FromUnsignedLongLong(val);
+		item_size = field->size;
+		n_items = 1;
+	}
+
+	for (i = 0; i < n_items; i++) {
+
+		val = read_size(event, data + field->offset + i * item_size,
+				item_size);
+		if (field->flags & FIELD_IS_SIGNED) {
+			if ((long long)val >= LONG_MIN &&
+					(long long)val <= LONG_MAX)
+				obj = PyInt_FromLong(val);
+			else
+				obj = PyLong_FromLongLong(val);
+		} else {
+			if (val <= LONG_MAX)
+				obj = PyInt_FromLong(val);
+			else
+				obj = PyLong_FromUnsignedLongLong(val);
+		}
+		if (is_array)
+			PyList_SET_ITEM(list, i, obj);
 	}
+	if (is_array)
+		obj = list;
 	return obj;
 }
 
-- 
1.8.3.1

