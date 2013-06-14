Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab3FNBo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:44:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34274 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3FNBo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:44:58 -0400
Message-ID: <51BA7578.4080108@huawei.com>
Date: Fri, 14 Jun 2013 09:44:24 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/uprobes: Support ftrace_event_file base multibuffer
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support multi-buffer on uprobe-based dynamic events by
using ftrace_event_file.

The code change is based on kprobe-based dynamic events
multibuffer support work commited by Masami(commit 41a7dd420c)

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |  183 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 161 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d5d0cd3..31f08d6 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -53,6 +53,7 @@ struct trace_uprobe {
 	struct list_head		list;
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
+	struct ftrace_event_file * __rcu *files;
 	struct trace_uprobe_filter	filter;
 	struct uprobe_consumer		consumer;
 	struct inode			*inode;
@@ -513,7 +514,8 @@ static const struct file_operations uprobe_profile_ops = {
 };

 static void uprobe_trace_print(struct trace_uprobe *tu,
-				unsigned long func, struct pt_regs *regs)
+				unsigned long func, struct pt_regs *regs,
+				struct ftrace_event_file *ftrace_file)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -522,9 +524,15 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	int size, i;
 	struct ftrace_event_call *call = &tu->call;

+	WARN_ON(call != ftrace_file->event_call);
+
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
-	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size + tu->size, 0, 0);
+	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
+						call->event.type,
+						size + tu->size, 0, 0);
 	if (!event)
 		return;

@@ -548,15 +556,35 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 /* uprobe handler */
 static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 {
-	if (!is_ret_probe(tu))
-		uprobe_trace_print(tu, 0, regs);
+	struct ftrace_event_file **file;
+
+	if (is_ret_probe(tu))
+		return 0;
+
+	file = rcu_dereference_raw(tu->files);
+	if (unlikely(!file))
+		return 0;
+
+	while (*file) {
+		uprobe_trace_print(tu, 0, regs, *file);
+		file++;
+	}
+
 	return 0;
 }

 static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
 				struct pt_regs *regs)
 {
-	uprobe_trace_print(tu, func, regs);
+	struct ftrace_event_file **file = rcu_dereference_raw(tu->files);
+
+	if (unlikely(!file))
+		return;
+
+	while (*file) {
+		uprobe_trace_print(tu, func, regs, *file);
+		file++;
+	}
 }

 /* Event entry printers */
@@ -597,6 +625,26 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }

+
+static int trace_uprobe_nr_files(struct trace_uprobe *tu)
+{
+	struct ftrace_event_file **file;
+	int ret = 0;
+
+	/*
+	 * Since all tu->files updater is protected by uprobe_enable_lock,
+	 * we don't need to lock an rcu_read_lock.
+	 */
+	file = rcu_dereference_raw(tu->files);
+	if (file)
+		while (*(file++))
+			ret++;
+
+	return ret;
+}
+
+static DEFINE_MUTEX(uprobe_enable_lock);
+
 static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
 {
 	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
@@ -607,33 +655,123 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
 				struct mm_struct *mm);

 static int
-probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
+probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
+		   filter_func_t filter)
 {
+	int enabled = 0;
 	int ret = 0;

+	mutex_lock(&uprobe_enable_lock);
+
 	if (is_trace_uprobe_enabled(tu))
-		return -EINTR;
+		enabled = 1;
+
+	if (file) {
+		struct ftrace_event_file **new, **old;
+		int n = trace_uprobe_nr_files(tu);
+
+		old = rcu_dereference_raw(tu->files);
+		/* 1 is for new one and 1 is for stopper */
+		new = kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
+			      GFP_KERNEL);
+		if (!new) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+		memcpy(new, old, n * sizeof(struct ftrace_event_file *));
+		new[n] = file;
+		/* The last one keeps a NULL */
+
+		rcu_assign_pointer(tu->files, new);
+		tu->flags |= TP_FLAG_TRACE;
+
+		if (old) {
+			/* Make sure the probe is done with old files */
+			synchronize_sched();
+			kfree(old);
+		}
+	} else
+		tu->flags |= TP_FLAG_PROFILE;

 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));

-	tu->flags |= flag;
-	tu->consumer.filter = filter;
-	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
-	if (ret)
-		tu->flags &= ~flag;
+	if (!enabled) {
+		tu->consumer.filter = filter;
+		ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
+		if (ret)
+			tu->flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
+	}

+ out_unlock:
+	mutex_unlock(&uprobe_enable_lock);
 	return ret;
 }

-static void probe_event_disable(struct trace_uprobe *tu, int flag)
+static int
+trace_uprobe_file_index(struct trace_uprobe *tu, struct ftrace_event_file *file)
 {
-	if (!is_trace_uprobe_enabled(tu))
-		return;
+	struct ftrace_event_file **files;
+	int i;
+
+	/*
+	 * Since all tu->files updater is protected by uprobe_enable_lock,
+	 * we don't need to lock an rcu_read_lock.
+	 */
+	files = rcu_dereference_raw(tu->files);
+	if (files) {
+		for (i = 0; files[i]; i++)
+			if (files[i] == file)
+				return i;
+	}
+
+	return -1;
+}
+
+static void
+probe_event_disable(struct trace_uprobe *tu, struct ftrace_event_file *file)
+{
+	mutex_lock(&uprobe_enable_lock);
+
+	if (file) {
+		struct ftrace_event_file **new, **old;
+		int n = trace_uprobe_nr_files(tu);
+		int i, j;
+
+		old = rcu_dereference_raw(tu->files);
+		if (n == 0 || trace_uprobe_file_index(tu, file) < 0)
+			goto out_unlock;
+
+		if (n == 1) {	/* Remove the last file */
+			tu->flags &= ~TP_FLAG_TRACE;
+			new = NULL;
+		} else {
+			new = kzalloc(n * sizeof(struct ftrace_event_file *),
+				      GFP_KERNEL);
+			if (!new)
+				goto out_unlock;
+
+			/* This copy & check loop copies the NULL stopper too */
+			for (i = 0, j = 0; j < n && i < n + 1; i++)
+				if (old[i] != file)
+					new[j++] = old[i];
+		}
+
+		rcu_assign_pointer(tu->files, new);
+
+		/* Make sure the probe is done with old files */
+		synchronize_sched();
+		kfree(old);
+	} else
+		tu->flags &= ~TP_FLAG_PROFILE;
+

 	WARN_ON(!uprobe_filter_is_empty(&tu->filter));

-	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
-	tu->flags &= ~flag;
+	if (!is_trace_uprobe_enabled(tu))
+		uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
+
+ out_unlock:
+	mutex_unlock(&uprobe_enable_lock);
 }

 static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
@@ -869,21 +1007,22 @@ static
 int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type, void *data)
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
1.7.9.7


