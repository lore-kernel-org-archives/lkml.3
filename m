Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3K0GUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:20:23 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53837 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3K0GUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:09 -0500
X-AuditID: 9c930197-b7caaae000001cef-aa-52958f166c21
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 04/17] tracing/uprobes: Convert to struct trace_probe
Date: Wed, 27 Nov 2013 15:19:50 +0900
Message-Id: <1385533203-10014-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Convert struct trace_uprobe to make use of the common trace_probe
structure.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 151 ++++++++++++++++++++++----------------------
 1 file changed, 75 insertions(+), 76 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index c77b92d61551..3b2885ef47c9 100644
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
@@ -132,7 +127,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	return tu;
 
 error:
-	kfree(tu->call.name);
+	kfree(tu->p.call.name);
 	kfree(tu);
 
 	return ERR_PTR(-ENOMEM);
@@ -142,12 +137,12 @@ static void free_trace_uprobe(struct trace_uprobe *tu)
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
@@ -157,8 +152,8 @@ static struct trace_uprobe *find_probe_event(const char *event, const char *grou
 	struct trace_uprobe *tu;
 
 	list_for_each_entry(tu, &uprobe_list, list)
-		if (strcmp(tu->call.name, event) == 0 &&
-		    strcmp(tu->call.class->system, group) == 0)
+		if (strcmp(tu->p.call.name, event) == 0 &&
+		    strcmp(tu->p.call.class->system, group) == 0)
 			return tu;
 
 	return NULL;
@@ -187,7 +182,7 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 	mutex_lock(&uprobe_lock);
 
 	/* register as an event */
-	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
+	old_tp = find_probe_event(tu->p.call.name, tu->p.call.class->system);
 	if (old_tp) {
 		/* delete old event */
 		ret = unregister_trace_uprobe(old_tp);
@@ -360,34 +355,36 @@ static int create_trace_uprobe(int argc, char **argv)
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
@@ -395,7 +392,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tu->size, &tu->args[i], false, false);
+		ret = traceprobe_parse_probe_arg(arg, &tu->p.size, parg,
+						 false, false);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
@@ -459,11 +457,11 @@ static int probes_seq_show(struct seq_file *m, void *v)
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
@@ -509,7 +507,7 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_uprobe *tu = v;
 
-	seq_printf(m, "  %s %-44s %15lu\n", tu->filename, tu->call.name, tu->nhit);
+	seq_printf(m, "  %s %-44s %15lu\n", tu->filename, tu->p.call.name, tu->nhit);
 	return 0;
 }
 
@@ -541,11 +539,11 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
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
 
@@ -559,8 +557,10 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 		data = DATAOF_TRACE_ENTRY(entry, false);
 	}
 
-	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+	for (i = 0; i < tu->p.nr_args; i++) {
+		call_fetch(&tu->p.args[i].fetch, regs,
+			   data + tu->p.args[i].offset);
+	}
 
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit(buffer, event, 0, 0);
@@ -591,23 +591,24 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
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
 
@@ -618,11 +619,6 @@ partial:
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
@@ -632,29 +628,29 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
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
@@ -672,12 +668,12 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
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
@@ -705,16 +701,16 @@ static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
 
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
@@ -734,7 +730,7 @@ static int set_print_fmt(struct trace_uprobe *tu)
 
 	/* Second: actually write the @print_fmt */
 	__set_print_fmt(tu, print_fmt, len + 1);
-	tu->call.print_fmt = print_fmt;
+	tu->p.call.print_fmt = print_fmt;
 
 	return 0;
 }
@@ -831,14 +827,14 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
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
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
@@ -858,8 +854,11 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
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
@@ -926,11 +925,11 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
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
@@ -943,11 +942,11 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
 
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
@@ -959,7 +958,7 @@ static struct trace_event_functions uprobe_funcs = {
 
 static int register_uprobe_event(struct trace_uprobe *tu)
 {
-	struct ftrace_event_call *call = &tu->call;
+	struct ftrace_event_call *call = &tu->p.call;
 	int ret;
 
 	/* Initialize ftrace_event_call */
@@ -994,11 +993,11 @@ static int unregister_uprobe_event(struct trace_uprobe *tu)
 	int ret;
 
 	/* tu->event is unregistered in trace_remove_event_call() */
-	ret = trace_remove_event_call(&tu->call);
+	ret = trace_remove_event_call(&tu->p.call);
 	if (ret)
 		return ret;
-	kfree(tu->call.print_fmt);
-	tu->call.print_fmt = NULL;
+	kfree(tu->p.call.print_fmt);
+	tu->p.call.print_fmt = NULL;
 	return 0;
 }
 
-- 
1.7.11.7

