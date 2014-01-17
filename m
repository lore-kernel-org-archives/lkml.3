Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaAQIJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:09:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60517 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaAQIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:08:49 -0500
X-AuditID: 9c930197-b7b7cae000000e34-0f-52d8e50cfab6
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 3/5] tracing/uprobes: Support ftrace_event_file base multibuffer
Date: Fri, 17 Jan 2014 17:08:38 +0900
Message-Id: <1389946120-19610-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Support multi-buffer on uprobe-based dynamic events by
using ftrace_event_file.

This patch is based kprobe-based dynamic events multibuffer
support work initially, commited by Masami(commit 41a7dd420c),
but revised as below:

Oleg changed the kprobe-based multibuffer design from
array-pointers of ftrace_event_file into simple list,
so this patch also change to the list design.

rcu_read_lock/unlock added into uprobe_trace_func/uretprobe_trace_func,
to synchronize with ftrace_event_file list add and delete.

Even though we allow multi-uprobes instances now,
but TP_FLAG_PROFILE/TP_FLAG_TRACE are still mutually exclusive
in probe_event_enable currently, this means we cannot allow
one user is using uprobe-tracer, and another user is using
perf-probe on same uprobe concurrently.
(Perhaps this will be fix in future, kprobe don't have this
limitation now)

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c |  17 -------
 kernel/trace/trace_probe.h  |  17 +++++++
 kernel/trace/trace_uprobe.c | 105 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 101 insertions(+), 38 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index bdbae450c13e..d021d21dd150 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -35,11 +35,6 @@ struct trace_kprobe {
 	struct trace_probe	tp;
 };
 
-struct event_file_link {
-	struct ftrace_event_file	*file;
-	struct list_head		list;
-};
-
 #define SIZEOF_TRACE_KPROBE(n)				\
 	(offsetof(struct trace_kprobe, tp.args) +	\
 	(sizeof(struct probe_arg) * (n)))
@@ -387,18 +382,6 @@ enable_trace_kprobe(struct trace_kprobe *tk, struct ftrace_event_file *file)
 	return ret;
 }
 
-static struct event_file_link *
-find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
-{
-	struct event_file_link *link;
-
-	list_for_each_entry(link, &tp->files, list)
-		if (link->file == file)
-			return link;
-
-	return NULL;
-}
-
 /*
  * Disable trace_probe
  * if the file is NULL, disable "perf" handler, or disable "trace" handler.
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index b73574a5f429..fb1ab5dfbd42 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -288,6 +288,11 @@ struct trace_probe {
 	struct probe_arg		args[];
 };
 
+struct event_file_link {
+	struct ftrace_event_file	*file;
+	struct list_head		list;
+};
+
 static inline bool trace_probe_is_enabled(struct trace_probe *tp)
 {
 	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
@@ -316,6 +321,18 @@ static inline int is_good_name(const char *name)
 	return 1;
 }
 
+static inline struct event_file_link *
+find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
+{
+	struct event_file_link *link;
+
+	list_for_each_entry(link, &tp->files, list)
+		if (link->file == file)
+			return link;
+
+	return NULL;
+}
+
 extern int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		   struct probe_arg *parg, bool is_return, bool is_kprobe);
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d83155e0da78..349c6df9e332 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -260,6 +260,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 		goto error;
 
 	INIT_LIST_HEAD(&tu->list);
+	INIT_LIST_HEAD(&tu->tp.files);
 	tu->consumer.handler = uprobe_dispatcher;
 	if (is_ret)
 		tu->consumer.ret_handler = uretprobe_dispatcher;
@@ -760,7 +761,8 @@ static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
 
 static void __uprobe_trace_func(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs,
-				struct uprobe_cpu_buffer *ucb, int dsize)
+				struct uprobe_cpu_buffer *ucb, int dsize,
+				struct ftrace_event_file *ftrace_file)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -769,13 +771,15 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 	int size, esize;
 	struct ftrace_event_call *call = &tu->tp.call;
 
+	WARN_ON(call != ftrace_file->event_call);
+
 	if (WARN_ON_ONCE(tu->tp.size + dsize > PAGE_SIZE))
 		return;
 
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	size = esize + tu->tp.size + dsize;
-	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, 0, 0);
+	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
+						call->event.type, size, 0, 0);
 	if (!event)
 		return;
 
@@ -799,8 +803,16 @@ static void __uprobe_trace_func(struct trace_uprobe *tu,
 static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs,
 			     struct uprobe_cpu_buffer *ucb, int dsize)
 {
-	if (!is_ret_probe(tu))
-		__uprobe_trace_func(tu, 0, regs, ucb, dsize);
+	struct event_file_link *link;
+
+	if (is_ret_probe(tu))
+		return 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(link, &tu->tp.files, list)
+		__uprobe_trace_func(tu, 0, regs, ucb, dsize, link->file);
+	rcu_read_unlock();
+
 	return 0;
 }
 
@@ -808,7 +820,12 @@ static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
 				 struct pt_regs *regs,
 				 struct uprobe_cpu_buffer *ucb, int dsize)
 {
-	__uprobe_trace_func(tu, func, regs, ucb, dsize);
+	struct event_file_link *link;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(link, &tu->tp.files, list)
+		__uprobe_trace_func(tu, func, regs, ucb, dsize, link->file);
+	rcu_read_unlock();
 }
 
 /* Event entry printers */
@@ -855,12 +872,31 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
 				struct mm_struct *mm);
 
 static int
-probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
+probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
+		   filter_func_t filter)
 {
-	int ret = 0;
+	bool enabled = trace_probe_is_enabled(&tu->tp);
+	struct event_file_link *link = NULL;
+	int ret;
+
+	if (file) {
+		if (tu->tp.flags & TP_FLAG_PROFILE)
+			return -EINTR;
 
-	if (trace_probe_is_enabled(&tu->tp))
-		return -EINTR;
+		link = kmalloc(sizeof(*link), GFP_KERNEL);
+		if (!link)
+			return -ENOMEM;
+
+		link->file = file;
+		list_add_tail_rcu(&link->list, &tu->tp.files);
+
+		tu->tp.flags |= TP_FLAG_TRACE;
+	} else {
+		if (tu->tp.flags & TP_FLAG_TRACE)
+			return -EINTR;
+
+		tu->tp.flags |= TP_FLAG_PROFILE;
+	}
 
 	ret = uprobe_buffer_enable();
 	if (ret < 0)
@@ -868,24 +904,49 @@ probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
 
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
-	tu->tp.flags |= flag;
+	if (enabled)
+		return 0;
+
 	tu->consumer.filter = filter;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
-	if (ret)
-		tu->tp.flags &= ~flag;
+	if (ret) {
+		if (file) {
+			list_del(&link->list);
+			kfree(link);
+			tu->tp.flags &= ~TP_FLAG_TRACE;
+		} else
+			tu->tp.flags &= ~TP_FLAG_PROFILE;
+	}
 
 	return ret;
 }
 
-static void probe_event_disable(struct trace_uprobe *tu, int flag)
+static void
+probe_event_disable(struct trace_uprobe *tu, struct ftrace_event_file *file)
 {
 	if (!trace_probe_is_enabled(&tu->tp))
 		return;
 
+	if (file) {
+		struct event_file_link *link;
+
+		link = find_event_file_link(&tu->tp, file);
+		if (!link)
+			return;
+
+		list_del_rcu(&link->list);
+		/* synchronize with u{,ret}probe_trace_func */
+		synchronize_sched();
+		kfree(link);
+
+		if (!list_empty(&tu->tp.files))
+			return;
+	}
+
 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
 
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
-	tu->tp.flags &= ~flag;
+	tu->tp.flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
 
 	uprobe_buffer_disable();
 }
@@ -1077,25 +1138,27 @@ static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
-static
-int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type, void *data)
+static int
+trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
+		      void *data)
 {
 	struct trace_uprobe *tu = event->data;
+	struct ftrace_event_file *file = data;
 
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return probe_event_enable(tu, TP_FLAG_TRACE, NULL);
+		return probe_event_enable(tu, file, NULL);
 
 	case TRACE_REG_UNREGISTER:
-		probe_event_disable(tu, TP_FLAG_TRACE);
+		probe_event_disable(tu, file);
 		return 0;
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return probe_event_enable(tu, TP_FLAG_PROFILE, uprobe_perf_filter);
+		return probe_event_enable(tu, NULL, uprobe_perf_filter);
 
 	case TRACE_REG_PERF_UNREGISTER:
-		probe_event_disable(tu, TP_FLAG_PROFILE);
+		probe_event_disable(tu, NULL);
 		return 0;
 
 	case TRACE_REG_PERF_OPEN:
-- 
1.7.11.7

