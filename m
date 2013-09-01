Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3IAKtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab3IAKt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:28 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 08/24] tools list traceevent: Add pevent_print_func_field function
Date: Sun,  1 Sep 2013 12:48:33 +0200
Message-Id: <1378032529-18498-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pevent_print_func_field function to print a field
and a format for function pointers. It's used in following
patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 42 ++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |  4 ++++
 2 files changed, 46 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index d1c2a6a..7bc75d6 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5326,6 +5326,48 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
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
index 1199934..a2d6306 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -581,6 +581,10 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct pevent_record *record, int err);
 
+int pevent_print_func_field(struct trace_seq *s, const char *fmt,
+			    struct event_format *event, const char *name,
+			    struct pevent_record *record, int err);
+
 int pevent_register_event_handler(struct pevent *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  pevent_event_handler_func func, void *context);
-- 
1.7.11.7

