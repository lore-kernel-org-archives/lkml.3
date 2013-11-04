Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3KDSCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:02:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37954 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3KDR7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:30 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/29] tools lib traceevent: Add pevent_print_func_field() helper function
Date: Mon,  4 Nov 2013 14:59:07 -0300
Message-Id: <1383587947-17419-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the pevent_print_func_field() that will look up a field that is
expected to be a function pointer, and it will print the function name
and offset of the address given by the field.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215501.869542711@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 42 ++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |  4 ++++
 2 files changed, 46 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index fc6f35f591f6..8f450adaa9c2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5367,6 +5367,48 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 	return -1;
 }
 
+/**
+ * pevent_print_func_field - print a field and a format for function pointers
+ * @s: The seq to print to
+ * @fmt: The printf format to print the field with.
+ * @event: the event that the field is for
+ * @name: The name of the field
+ * @record: The record with the field name.
+ * @err: print default error if failed.
+ *
+ * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ */
+int pevent_print_func_field(struct trace_seq *s, const char *fmt,
+			    struct event_format *event, const char *name,
+			    struct pevent_record *record, int err)
+{
+	struct format_field *field = pevent_find_field(event, name);
+	struct pevent *pevent = event->pevent;
+	unsigned long long val;
+	struct func_map *func;
+	char tmp[128];
+
+	if (!field)
+		goto failed;
+
+	if (pevent_read_number_field(field, record->data, &val))
+		goto failed;
+
+	func = find_func(pevent, val);
+
+	if (func)
+		snprintf(tmp, 128, "%s/0x%llx", func->func, func->addr - val);
+	else
+		sprintf(tmp, "0x%08llx", val);
+
+	return trace_seq_printf(s, fmt, tmp);
+
+ failed:
+	if (err)
+		trace_seq_printf(s, "CAN'T FIND FIELD \"%s\"", name);
+	return -1;
+}
+
 static void free_func_handle(struct pevent_function_handler *func)
 {
 	struct pevent_func_params *params;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index dc8539ee9485..8d73d2594f65 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -569,6 +569,10 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct pevent_record *record, int err);
 
+int pevent_print_func_field(struct trace_seq *s, const char *fmt,
+			   struct event_format *event, const char *name,
+			   struct pevent_record *record, int err);
+
 int pevent_register_event_handler(struct pevent *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  pevent_event_handler_func func, void *context);
-- 
1.8.1.4

