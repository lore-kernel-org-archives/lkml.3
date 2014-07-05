Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856AbaGEKnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:43:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaGEKnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:43:02 -0400
Date: Sat, 5 Jul 2014 03:42:51 -0700
From: tip-bot for Sebastian Andrzej Siewior <tipbot@zytor.com>
Message-ID: <tip-8ac631cd502d6b31fd29f6d019305305b479fa3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, bigeasy@linutronix.de, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, bigeasy@linutronix.de,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Handle the num array type in python properly
Git-Commit-ID: 8ac631cd502d6b31fd29f6d019305305b479fa3e
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

Commit-ID:  8ac631cd502d6b31fd29f6d019305305b479fa3e
Gitweb:     http://git.kernel.org/tip/8ac631cd502d6b31fd29f6d019305305b479fa3e
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 27 May 2014 18:14:34 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 27 Jun 2014 11:15:02 +0200

perf script: Handle the num array type in python properly

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
 
