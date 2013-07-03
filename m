Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab3GCMf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:35:56 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65413 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630Ab3GCMfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:53 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-ee-51d41aa4c9b5
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 05/12] tracing/uprobes: Convert to struct trace_probe
Date: Wed,  3 Jul 2013 21:35:39 +0900
Message-Id: <1372854946-17074-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Convert struct trace_uprobe to make use of the common trace_probe
structure.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 151 ++++++++++++++++++++++----------------------
 1 file changed, 75 insertions(+), 76 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 32494fb0ee64..20c35e2a2339 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -51,22 +51,17 @@ struct trace_uprobe_filter {
  */
 struct trace_uprobe {
 	struct list_head		list;
-	struct ftrace_event_class	class;
-	struct ftrace_event_call	call;
 	struct trace_uprobe_filter	filter;
 	struct uprobe_consumer		consumer;
 	struct inode			*inode;
 	char				*filename;
 	unsigned long			offset;
 	unsigned long			nhit;
-	unsigned int			flags;	/* For TP_FLAG_* */
-	ssize_t				size;	/* trace entry size */
-	unsigned int			nr_args;
-	struct probe_arg		args[];
+	struct trace_probe		p;
 };
 
-#define SIZEOF_TRACE_UPROBE(n)			\
-	(offsetof(struct trace_uprobe, args) +	\
+#define SIZEOF_TRACE_UPROBE(n)				\
+	(offsetof(struct trace_uprobe, p.args) +	\
 	(sizeof(struct probe_arg) * (n)))
 
 static int register_uprobe_event(struct trace_uprobe *tu);
@@ -114,13 +109,13 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	if (!tu)
 		return ERR_PTR(-ENOMEM);
 
-	tu->call.class = &tu->class;
-	tu->call.name = kstrdup(event, GFP_KERNEL);
-	if (!tu->call.name)
+	tu->p.call.class = &tu->p.class;
+	tu->p.call.name = kstrdup(event, GFP_KERNEL);
+	if (!tu->p.call.name)
 		goto error;
 
-	tu->class.system = kstrdup(group, GFP_KERNEL);
-	if (!tu->class.system)
+	tu->p.class.system = kstrdup(group, GFP_KERNEL);
+	if (!tu->p.class.system)
 		goto error;
 
 	INIT_LIST_HEAD(&tu->list);
@@ -131,7 +126,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	return tu;
 
 error:
-	kfree(tu->call.name);
+	kfree(tu->p.call.name);
 	kfree(tu);
 
 	return ERR_PTR(-ENOMEM);
@@ -141,12 +136,12 @@ static void free_trace_uprobe(struct trace_uprobe *tu)
 {
 	int i;
 
-	for (i = 0; i < tu->nr_args; i++)
-		traceprobe_free_probe_arg(&tu->args[i]);
+	for (i = 0; i < tu->p.nr_args; i++)
+		traceprobe_free_probe_arg(&tu->p.args[i]);
 
 	iput(tu->inode);
-	kfree(tu->call.class->system);
-	kfree(tu->call.name);
+	kfree(tu->p.call.class->system);
+	kfree(tu->p.call.name);
 	kfree(tu->filename);
 	kfree(tu);
 }
@@ -156,8 +151,8 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
 	struct trace_uprobe *tu;
 
 	list_for_each_entry(tu, &uprobe_list, list)
-		if (strcmp(tu->call.name, event) == 0 &&
-		    strcmp(tu->call.class->system, group) == 0)
+		if (strcmp(tu->p.call.name, event) == 0 &&
+		    strcmp(tu->p.call.class->system, group) == 0)
 			return tu;
 
 	return NULL;
@@ -180,7 +175,7 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 	mutex_lock(&uprobe_lock);
 
 	/* register as an event */
-	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
+	old_tp = find_probe_event(tu->p.call.name, tu->p.call.class->system);
 	if (old_tp)
 		/* delete old event */
 		unregister_trace_uprobe(old_tp);
@@ -346,34 +341,36 @@ static int create_trace_uprobe(int argc, char **argv)
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		struct probe_arg *parg = &tu->p.args[i];
+
 		/* Increment count for freeing args in error case */
-		tu->nr_args++;
+		tu->p.nr_args++;
 
 		/* Parse argument name */
 		arg = strchr(argv[i], '=');
 		if (arg) {
 			*arg++ = '\0';
-			tu->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+			parg->name = kstrdup(argv[i], GFP_KERNEL);
 		} else {
 			arg = argv[i];
 			/* If argument name is omitted, set "argN" */
 			snprintf(buf, MAX_EVENT_NAME_LEN, "arg%d", i + 1);
-			tu->args[i].name = kstrdup(buf, GFP_KERNEL);
+			parg->name = kstrdup(buf, GFP_KERNEL);
 		}
 
-		if (!tu->args[i].name) {
+		if (!parg->name) {
 			pr_info("Failed to allocate argument[%d] name.\n", i);
 			ret = -ENOMEM;
 			goto error;
 		}
 
-		if (!is_good_name(tu->args[i].name)) {
-			pr_info("Invalid argument[%d] name: %s\n", i, tu->args[i].name);
+		if (!is_good_name(parg->name)) {
+			pr_info("Invalid argument[%d] name: %s\n", i, parg->name);
 			ret = -EINVAL;
 			goto error;
 		}
 
-		if (traceprobe_conflict_field_name(tu->args[i].name, tu->args, i)) {
+		if (traceprobe_conflict_field_name(parg->name, tu->p.args, i)) {
 			pr_info("Argument[%d] name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
@@ -381,7 +378,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tu->size, &tu->args[i], false, false);
+		ret = traceprobe_parse_probe_arg(arg, &tu->p.size, parg,
+						 false, false);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
@@ -441,11 +439,11 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	char c = is_ret_probe(tu) ? 'r' : 'p';
 	int i;
 
-	seq_printf(m, "%c:%s/%s", c, tu->call.class->system, tu->call.name);
+	seq_printf(m, "%c:%s/%s", c, tu->p.call.class->system, tu->p.call.name);
 	seq_printf(m, " %s:0x%p", tu->filename, (void *)tu->offset);
 
-	for (i = 0; i < tu->nr_args; i++)
-		seq_printf(m, " %s=%s", tu->args[i].name, tu->args[i].comm);
+	for (i = 0; i < tu->p.nr_args; i++)
+		seq_printf(m, " %s=%s", tu->p.args[i].name, tu->p.args[i].comm);
 
 	seq_printf(m, "\n");
 	return 0;
@@ -486,7 +484,7 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_uprobe *tu = v;
 
-	seq_printf(m, "  %s %-44s %15lu\n", tu->filename, tu->call.name, tu->nhit);
+	seq_printf(m, "  %s %-44s %15lu\n", tu->filename, tu->p.call.name, tu->nhit);
 	return 0;
 }
 
@@ -518,11 +516,11 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	struct ring_buffer *buffer;
 	void *data;
 	int size, i;
-	struct ftrace_event_call *call = &tu->call;
+	struct ftrace_event_call *call = &tu->p.call;
 
 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size + tu->size, 0, 0);
+						  size + tu->p.size, 0, 0);
 	if (!event)
 		return;
 
@@ -536,8 +534,10 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+	for (i = 0; i < tu->p.nr_args; i++) {
+		call_fetch(&tu->p.args[i].fetch, regs,
+			   data + tu->p.args[i].offset);
+	}
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
@@ -568,23 +568,24 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	int i;
 
 	entry = (struct uprobe_trace_entry_head *)iter->ent;
-	tu = container_of(event, struct trace_uprobe, call.event);
+	tu = container_of(event, struct trace_uprobe, p.call.event);
 
 	if (is_ret_probe(tu)) {
-		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->call.name,
+		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)", tu->p.call.name,
 					entry->vaddr[1], entry->vaddr[0]))
 			goto partial;
 		data = DATAOF_TRACE_ENTRY(entry, true);
 	} else {
-		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name,
+		if (!trace_seq_printf(s, "%s: (0x%lx)", tu->p.call.name,
 					entry->vaddr[0]))
 			goto partial;
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->nr_args; i++) {
-		if (!tu->args[i].type->print(s, tu->args[i].name,
-					     data + tu->args[i].offset, entry))
+	for (i = 0; i < tu->p.nr_args; i++) {
+		struct probe_arg *parg = &tu->p.args[i];
+
+		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
 			goto partial;
 	}
 
@@ -595,11 +596,6 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
-{
-	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
-}
-
 typedef bool (*filter_func_t)(struct uprobe_consumer *self,
 				enum uprobe_filter_ctx ctx,
 				struct mm_struct *mm);
@@ -609,29 +605,29 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
 {
 	int ret = 0;
 
-	if (is_trace_uprobe_enabled(tu))
+	if (trace_probe_is_enabled(&tu->p))
 		return -EINTR;
 
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
-	tu->flags |= flag;
+	tu->p.flags |= flag;
 	tu->consumer.filter = filter;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
 	if (ret)
-		tu->flags &= ~flag;
+		tu->p.flags &= ~flag;
 
 	return ret;
 }
 
 static void probe_event_disable(struct trace_uprobe *tu, int flag)
 {
-	if (!is_trace_uprobe_enabled(tu))
+	if (!trace_probe_is_enabled(&tu->p))
 		return;
 
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
-	tu->flags &= ~flag;
+	tu->p.flags &= ~flag;
 }
 
 static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
@@ -649,12 +645,12 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
 		size = SIZEOF_TRACE_ENTRY(false);
 	}
 	/* Set argument names as fields */
-	for (i = 0; i < tu->nr_args; i++) {
-		ret = trace_define_field(event_call, tu->args[i].type->fmttype,
-					 tu->args[i].name,
-					 size + tu->args[i].offset,
-					 tu->args[i].type->size,
-					 tu->args[i].type->is_signed,
+	for (i = 0; i < tu->p.nr_args; i++) {
+		struct probe_arg *parg = &tu->p.args[i];
+
+		ret = trace_define_field(event_call, parg->type->fmttype,
+					 parg->name, size + parg->offset,
+					 parg->type->size, parg->type->is_signed,
 					 FILTER_OTHER);
 
 		if (ret)
@@ -682,16 +678,16 @@ static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
 
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
 
-	for (i = 0; i < tu->nr_args; i++) {
+	for (i = 0; i < tu->p.nr_args; i++) {
 		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
-				tu->args[i].name, tu->args[i].type->fmt);
+				tu->p.args[i].name, tu->p.args[i].type->fmt);
 	}
 
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
 
-	for (i = 0; i < tu->nr_args; i++) {
+	for (i = 0; i < tu->p.nr_args; i++) {
 		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-				tu->args[i].name);
+				tu->p.args[i].name);
 	}
 
 	return pos;	/* return the length of print_fmt */
@@ -711,7 +707,7 @@ static int set_print_fmt(struct trace_uprobe *tu)
 
 	/* Second: actually write the @print_fmt */
 	__set_print_fmt(tu, print_fmt, len + 1);
-	tu->call.print_fmt = print_fmt;
+	tu->p.call.print_fmt = print_fmt;
 
 	return 0;
 }
@@ -808,14 +804,14 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 static void uprobe_perf_print(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
-	struct ftrace_event_call *call = &tu->call;
+	struct ftrace_event_call *call = &tu->p.call;
 	struct uprobe_trace_entry_head *entry;
 	struct hlist_head *head;
 	void *data;
 	int size, rctx, i;
 
 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
+	size = ALIGN(size + tu->p.size + sizeof(u32), sizeof(u64)) - sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
 		return;
 
@@ -837,8 +833,11 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+	for (i = 0; i < tu->p.nr_args; i++) {
+		struct probe_arg *parg = &tu->p.args[i];
+
+		call_fetch(&parg->fetch, regs, data + parg->offset);
+	}
 
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
  out:
@@ -905,11 +904,11 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	tu = container_of(con, struct trace_uprobe, consumer);
 	tu->nhit++;
 
-	if (tu->flags & TP_FLAG_TRACE)
+	if (tu->p.flags & TP_FLAG_TRACE)
 		ret |= uprobe_trace_func(tu, regs);
 
 #ifdef CONFIG_PERF_EVENTS
-	if (tu->flags & TP_FLAG_PROFILE)
+	if (tu->p.flags & TP_FLAG_PROFILE)
 		ret |= uprobe_perf_func(tu, regs);
 #endif
 	return ret;
@@ -922,11 +921,11 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 
 	tu = container_of(con, struct trace_uprobe, consumer);
 
-	if (tu->flags & TP_FLAG_TRACE)
+	if (tu->p.flags & TP_FLAG_TRACE)
 		uretprobe_trace_func(tu, func, regs);
 
 #ifdef CONFIG_PERF_EVENTS
-	if (tu->flags & TP_FLAG_PROFILE)
+	if (tu->p.flags & TP_FLAG_PROFILE)
 		uretprobe_perf_func(tu, func, regs);
 #endif
 	return 0;
@@ -938,7 +937,7 @@ static struct trace_event_functions uprobe_funcs = {
 
 static int register_uprobe_event(struct trace_uprobe *tu)
 {
-	struct ftrace_event_call *call = &tu->call;
+	struct ftrace_event_call *call = &tu->p.call;
 	int ret;
 
 	/* Initialize ftrace_event_call */
@@ -971,9 +970,9 @@ static int register_uprobe_event(struct trace_uprobe *tu)
 static void unregister_uprobe_event(struct trace_uprobe *tu)
 {
 	/* tu->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tu->call);
-	kfree(tu->call.print_fmt);
-	tu->call.print_fmt = NULL;
+	trace_remove_event_call(&tu->p.call);
+	kfree(tu->p.call.print_fmt);
+	tu->p.call.print_fmt = NULL;
 }
 
 /* Make a trace interface for controling probe points */
-- 
1.7.11.7

