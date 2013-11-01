Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3KAV43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:56:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754662Ab3KAVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:04 -0400
Message-Id: <20131101215501.869542711@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:54:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 8/8] tools lib traceevent: Add pevent_print_func_field() helper function
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0008-tools-lib-traceevent-Add-pevent_print_func_field-hel.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the pevent_print_func_field() that will look up a field that
is expected to be a function pointer, and it will print the function
name and offset of the address given by the field.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 42 ++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |  4 ++++
 2 files changed, 46 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index fc6f35f..8f450ad 100644
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
index dc8539e..8d73d25 100644
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
1.8.4.rc3


