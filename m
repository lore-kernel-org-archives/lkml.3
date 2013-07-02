Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab3GBU05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:26:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3GBUY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:28 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=OfQvkzwympMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_T5ak8jlKU8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=-JK2zC7XVZM_u-TNkm4A:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202426.313465897@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 07/14] tracing/kprobes: Turn trace_probe->files into list_head
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-kprobes-Turn-trace_probe-files-into-list_hea.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

I think that "ftrace_event_file *trace_probe[]" complicates the
code for no reason, turn it into list_head to simplify the code.
enable_trace_probe() no longer needs synchronize_sched().

This needs the extra sizeof(list_head) memory for every attached
ftrace_event_file, hopefully not a problem in this case.

Link: http://lkml.kernel.org/r/20130620173814.GA13165@redhat.com

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |  138 ++++++++++++-------------------------------
 1 file changed, 37 insertions(+), 101 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 282f86c..405b5b0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -35,12 +35,17 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
-	struct ftrace_event_file * __rcu *files;
+	struct list_head	files;
 	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];
 };
 
+struct event_file_link {
+	struct ftrace_event_file	*file;
+	struct list_head		list;
+};
+
 #define SIZEOF_TRACE_PROBE(n)			\
 	(offsetof(struct trace_probe, args) +	\
 	(sizeof(struct probe_arg) * (n)))
@@ -150,6 +155,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
+	INIT_LIST_HEAD(&tp->files);
 	return tp;
 error:
 	kfree(tp->call.name);
@@ -184,22 +190,6 @@ static struct trace_probe *find_trace_probe(const char *event,
 }
 
 /*
- * This and enable_trace_probe/disable_trace_probe rely on event_mutex
- * held by the caller, __ftrace_set_clr_event().
- */
-static int trace_probe_nr_files(struct trace_probe *tp)
-{
-	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
-	int ret = 0;
-
-	if (file)
-		while (*(file++))
-			ret++;
-
-	return ret;
-}
-
-/*
  * Enable trace_probe
  * if the file is NULL, enable "perf" handler, or enable "trace" handler.
  */
@@ -209,29 +199,18 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 	int ret = 0;
 
 	if (file) {
-		struct ftrace_event_file **new, **old;
-		int n = trace_probe_nr_files(tp);
-
-		old = rcu_dereference_raw(tp->files);
-		/* 1 is for new one and 1 is for stopper */
-		new = kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
-			      GFP_KERNEL);
-		if (!new) {
+		struct event_file_link *link;
+
+		link = kmalloc(sizeof(*link), GFP_KERNEL);
+		if (!link) {
 			ret = -ENOMEM;
 			goto out;
 		}
-		memcpy(new, old, n * sizeof(struct ftrace_event_file *));
-		new[n] = file;
-		/* The last one keeps a NULL */
 
-		rcu_assign_pointer(tp->files, new);
-		tp->flags |= TP_FLAG_TRACE;
+		link->file = file;
+		list_add_tail_rcu(&link->list, &tp->files);
 
-		if (old) {
-			/* Make sure the probe is done with old files */
-			synchronize_sched();
-			kfree(old);
-		}
+		tp->flags |= TP_FLAG_TRACE;
 	} else
 		tp->flags |= TP_FLAG_PROFILE;
 
@@ -245,24 +224,16 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 	return ret;
 }
 
-static int
-trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
+static struct event_file_link *
+find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
 {
-	struct ftrace_event_file **files;
-	int i;
+	struct event_file_link *link;
 
-	/*
-	 * Since all tp->files updater is protected by probe_enable_lock,
-	 * we don't need to lock an rcu_read_lock.
-	 */
-	files = rcu_dereference_raw(tp->files);
-	if (files) {
-		for (i = 0; files[i]; i++)
-			if (files[i] == file)
-				return i;
-	}
+	list_for_each_entry(link, &tp->files, list)
+		if (link->file == file)
+			return link;
 
-	return -1;
+	return NULL;
 }
 
 /*
@@ -275,38 +246,23 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 	int ret = 0;
 
 	if (file) {
-		struct ftrace_event_file **new, **old;
-		int n = trace_probe_nr_files(tp);
-		int i, j;
+		struct event_file_link *link;
 
-		old = rcu_dereference_raw(tp->files);
-		if (n == 0 || trace_probe_file_index(tp, file) < 0) {
+		link = find_event_file_link(tp, file);
+		if (!link) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		if (n == 1) {	/* Remove the last file */
-			tp->flags &= ~TP_FLAG_TRACE;
-			new = NULL;
-		} else {
-			new = kzalloc(n * sizeof(struct ftrace_event_file *),
-				      GFP_KERNEL);
-			if (!new) {
-				ret = -ENOMEM;
-				goto out;
-			}
-
-			/* This copy & check loop copies the NULL stopper too */
-			for (i = 0, j = 0; j < n && i < n + 1; i++)
-				if (old[i] != file)
-					new[j++] = old[i];
-		}
+		list_del_rcu(&link->list);
+		/* synchronize with kprobe_trace_func/kretprobe_trace_func */
+		synchronize_sched();
+		kfree(link);
 
-		rcu_assign_pointer(tp->files, new);
+		if (!list_empty(&tp->files))
+			goto out;
 
-		/* Make sure the probe is done with old files */
-		synchronize_sched();
-		kfree(old);
+		tp->flags &= ~TP_FLAG_TRACE;
 	} else
 		tp->flags &= ~TP_FLAG_PROFILE;
 
@@ -871,20 +827,10 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 static __kprobes void
 kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	/*
-	 * Note: preempt is already disabled around the kprobe handler.
-	 * However, we still need an smp_read_barrier_depends() corresponding
-	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
-	 */
-	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
-
-	if (unlikely(!file))
-		return;
+	struct event_file_link *link;
 
-	while (*file) {
-		__kprobe_trace_func(tp, regs, *file);
-		file++;
-	}
+	list_for_each_entry_rcu(link, &tp->files, list)
+		__kprobe_trace_func(tp, regs, link->file);
 }
 
 /* Kretprobe handler */
@@ -931,20 +877,10 @@ static __kprobes void
 kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
-	/*
-	 * Note: preempt is already disabled around the kprobe handler.
-	 * However, we still need an smp_read_barrier_depends() corresponding
-	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
-	 */
-	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
-
-	if (unlikely(!file))
-		return;
+	struct event_file_link *link;
 
-	while (*file) {
-		__kretprobe_trace_func(tp, ri, regs, *file);
-		file++;
-	}
+	list_for_each_entry_rcu(link, &tp->files, list)
+		__kretprobe_trace_func(tp, ri, regs, link->file);
 }
 
 /* Event entry printers */
-- 
1.7.10.4


