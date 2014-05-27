Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaE0QPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:15:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:56111 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaE0QO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:14:57 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] perf script: handle the num array type in python properly
Date: Tue, 27 May 2014 18:14:34 +0200
Message-Id: <1401207274-8170-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401207274-8170-1-git-send-email-bigeasy@linutronix.de>
References: <1401207274-8170-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw_syscalls:sys_enter tracer for instance passes has one argument
named 'arg' which is an array of 6 integers. Right the python scripts
gets only 0 passed as an argument. The reason is that
pevent_read_number() can not handle data types of 48 and returns always
0.
This patch changes this by passing num array as list of nums which fit
the description. As a result python will now see a list named arg which
contains 6 (integer) items.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../util/scripting-engines/trace-event-python.c    | 43 ++++++++++++++++------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index aa11790..40a815a 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -233,22 +233,41 @@ static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
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
2.0.0.rc4

