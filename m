Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3CKHOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26346 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3CKHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:18 -0400
Message-ID: <513D8426.9070109@huawei.com>
Date: Mon, 11 Mar 2013 15:13:42 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 03/13] tracing: move find_event_field function into trace_events.c
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move location of find_event_field function, put together with
trace_get_fields in trace_events.c, this will make some
variable and function become to static.

This patch also rename find_event_field to trace_find_field.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.h               |    6 ++----
 kernel/trace/trace_events.c        |   31 +++++++++++++++++++++++++++++--
 kernel/trace/trace_events_filter.c |   29 +----------------------------
 3 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 57d7e53..8489d83 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -902,8 +902,6 @@ struct filter_pred {
 	unsigned short		right;
 };

-extern struct list_head ftrace_common_fields;
-
 extern enum regex_type
 filter_parse_regex(char *buff, int len, char **search, int *not);
 extern void print_event_filter(struct ftrace_event_call *call,
@@ -916,8 +914,8 @@ extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
 extern int filter_assign_type(const char *type);

-struct list_head *
-trace_get_fields(struct ftrace_event_call *event_call);
+struct ftrace_event_field *
+trace_find_field(struct ftrace_event_call *call, char *name);

 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 57e9b28..85e6ff5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -34,9 +34,9 @@ char event_storage[EVENT_STORAGE_SIZE];
 EXPORT_SYMBOL_GPL(event_storage);

 LIST_HEAD(ftrace_events);
-LIST_HEAD(ftrace_common_fields);
+static LIST_HEAD(ftrace_common_fields);

-struct list_head *
+static struct list_head *
 trace_get_fields(struct ftrace_event_call *event_call)
 {
 	if (!event_call->class->get_fields)
@@ -44,6 +44,33 @@ trace_get_fields(struct ftrace_event_call *event_call)
 	return event_call->class->get_fields(event_call);
 }

+static struct ftrace_event_field *
+__find_event_field(struct list_head *head, char *name)
+{
+	struct ftrace_event_field *field;
+
+	list_for_each_entry(field, head, link) {
+		if (!strcmp(field->name, name))
+			return field;
+	}
+
+	return NULL;
+}
+
+struct ftrace_event_field *
+trace_find_field(struct ftrace_event_call *call, char *name)
+{
+	struct ftrace_event_field *field;
+	struct list_head *head;
+
+	field = __find_event_field(&ftrace_common_fields, name);
+	if (field)
+		return field;
+
+	head = trace_get_fields(call);
+	return __find_event_field(head, name);
+}
+
 static int __trace_define_field(struct list_head *head, const char *type,
 				const char *name, int offset, int size,
 				int is_signed, int filter_type)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e5b0ca8..660cf9c 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -658,33 +658,6 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 	mutex_unlock(&event_mutex);
 }

-static struct ftrace_event_field *
-__find_event_field(struct list_head *head, char *name)
-{
-	struct ftrace_event_field *field;
-
-	list_for_each_entry(field, head, link) {
-		if (!strcmp(field->name, name))
-			return field;
-	}
-
-	return NULL;
-}
-
-static struct ftrace_event_field *
-find_event_field(struct ftrace_event_call *call, char *name)
-{
-	struct ftrace_event_field *field;
-	struct list_head *head;
-
-	field = __find_event_field(&ftrace_common_fields, name);
-	if (field)
-		return field;
-
-	head = trace_get_fields(call);
-	return __find_event_field(head, name);
-}
-
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
 	stack->preds = kcalloc(n_preds + 1, sizeof(*stack->preds), GFP_KERNEL);
@@ -1337,7 +1310,7 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 		return NULL;
 	}

-	field = find_event_field(call, operand1);
+	field = trace_find_field(call, operand1);
 	if (!field) {
 		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
 		return NULL;
-- 
1.7.9.7


