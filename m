Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3EIFrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:47:36 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58071 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3EIFrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:47:31 -0400
X-AuditID: 85900ec0-d24c6b900000151e-96-518b3870aad8
Subject: [PATCH 10/11] tracing/kprobes: Support ftrace_event_file base
 multibuffer
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:49 +0900
Message-ID: <20130509054449.30398.88343.stgit@mhiramat-M0-7522>
In-Reply-To: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support multi-buffer on kprobe-based dynamic events by
using ftrace_event_file.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_kprobe.c |  250 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 214 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9ca44fc..fee865d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -27,7 +27,6 @@
 /**
  * Kprobe event core functions
  */
-
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -36,6 +35,7 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
+	struct ftrace_event_file	**files;
 	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];
@@ -183,12 +183,57 @@ static struct trace_probe *find_trace_probe(const char *event,
 	return NULL;
 }
 
-/* Enable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
-static int enable_trace_probe(struct trace_probe *tp, int flag)
+static int trace_probe_nr_files(struct trace_probe *tp)
+{
+	struct ftrace_event_file **file = tp->files;
+	int ret = 0;
+
+	if (file)
+		while (*(file++))
+			ret++;
+
+	return ret;
+}
+
+static DEFINE_MUTEX(probe_enable_lock);
+
+/*
+ * Enable trace_probe
+ * if the file is NULL, enable "perf" handler, or enable "trace" handler.
+ */
+static int
+enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
-	tp->flags |= flag;
+	mutex_lock(&probe_enable_lock);
+
+	if (file) {
+		struct ftrace_event_file **new, **old = tp->files;
+		int n = trace_probe_nr_files(tp);
+
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
+		rcu_assign_pointer(tp->files, new);
+		tp->flags |= TP_FLAG_TRACE;
+
+		if (old) {
+			/* Make sure the probe is done with old files */
+			synchronize_sched();
+			kfree(old);
+		}
+	} else
+		tp->flags |= TP_FLAG_PROFILE;
+
 	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
 	    !trace_probe_has_gone(tp)) {
 		if (trace_probe_is_return(tp))
@@ -197,19 +242,83 @@ static int enable_trace_probe(struct trace_probe *tp, int flag)
 			ret = enable_kprobe(&tp->rp.kp);
 	}
 
+ out_unlock:
+	mutex_unlock(&probe_enable_lock);
+
 	return ret;
 }
 
-/* Disable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
-static void disable_trace_probe(struct trace_probe *tp, int flag)
+static int
+trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
+{
+	int i;
+
+	if (tp->files) {
+		for (i = 0; tp->files[i]; i++)
+			if (tp->files[i] == file)
+				return i;
+	}
+
+	return -1;
+}
+
+/*
+ * Disable trace_probe
+ * if the file is NULL, disable "perf" handler, or disable "trace" handler.
+ */
+static int
+disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
-	tp->flags &= ~flag;
+	int ret = 0;
+
+	mutex_lock(&probe_enable_lock);
+
+	if (file) {
+		struct ftrace_event_file **new, **old = tp->files;
+		int n = trace_probe_nr_files(tp);
+		int i, j;
+
+		if (n == 0 || trace_probe_file_index(tp, file) < 0) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+
+		if (n == 1) {	/* Remove the last file */
+			tp->flags &= ~TP_FLAG_TRACE;
+			new = NULL;
+		} else {
+			new = kzalloc(n * sizeof(struct ftrace_event_file *),
+				      GFP_KERNEL);
+			if (!new) {
+				ret = -ENOMEM;
+				goto out_unlock;
+			}
+
+			/* This copy & check loop copies the NULL stopper too */
+			for (i = 0, j = 0; j < n && i < n + 1; i++)
+				if (old[i] != file)
+					new[j++] = old[i];
+		}
+
+		rcu_assign_pointer(tp->files, new);
+
+		/* Make sure the probe is done with old files */
+		synchronize_sched();
+		kfree(old);
+	} else
+		tp->flags &= ~TP_FLAG_PROFILE;
+
 	if (!trace_probe_is_enabled(tp) && trace_probe_is_registered(tp)) {
 		if (trace_probe_is_return(tp))
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
 	}
+
+ out_unlock:
+	mutex_unlock(&probe_enable_lock);
+
+	return ret;
 }
 
 /* Internal register function - just handle k*probes and flags */
@@ -724,7 +833,8 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 
 /* Kprobe handler */
 static __kprobes void
-kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
+__kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
+		    struct ftrace_event_file *ftrace_file)
 {
 	struct kprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -733,14 +843,17 @@ kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
+	WARN_ON(call != ftrace_file->event_call);
+
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
 	dsize = __get_data_size(tp, regs);
 	size = sizeof(*entry) + tp->size + dsize;
 
-	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, irq_flags, pc);
+	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
+						call->event.type,
+						size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -753,10 +866,23 @@ kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 						irq_flags, pc, regs);
 }
 
+static __kprobes void
+kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
+{
+	struct ftrace_event_file **file = tp->files;
+
+	/* Note: preempt is already disabled around the kprobe handler */
+	while (*file) {
+		__kprobe_trace_func(tp, regs, *file);
+		file++;
+	}
+}
+
 /* Kretprobe handler */
 static __kprobes void
-kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
-		     struct pt_regs *regs)
+__kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+		       struct pt_regs *regs,
+		       struct ftrace_event_file *ftrace_file)
 {
 	struct kretprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -765,14 +891,17 @@ kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
+	WARN_ON(call != ftrace_file->event_call);
+
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
 	dsize = __get_data_size(tp, regs);
 	size = sizeof(*entry) + tp->size + dsize;
 
-	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, irq_flags, pc);
+	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
+						call->event.type,
+						size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -786,6 +915,19 @@ kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 						irq_flags, pc, regs);
 }
 
+static __kprobes void
+kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+		     struct pt_regs *regs)
+{
+	struct ftrace_event_file **file = tp->files;
+
+	/* Note: preempt is already disabled around the kprobe handler */
+	while (*file) {
+		__kretprobe_trace_func(tp, ri, regs, *file);
+		file++;
+	}
+}
+
 /* Event entry printers */
 enum print_line_t
 print_kprobe_event(struct trace_iterator *iter, int flags,
@@ -1041,20 +1183,19 @@ int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
 {
 	struct trace_probe *tp = (struct trace_probe *)event->data;
+	struct ftrace_event_file *file = data;
 
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return enable_trace_probe(tp, TP_FLAG_TRACE);
+		return enable_trace_probe(tp, file);
 	case TRACE_REG_UNREGISTER:
-		disable_trace_probe(tp, TP_FLAG_TRACE);
-		return 0;
+		return disable_trace_probe(tp, file);
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return enable_trace_probe(tp, TP_FLAG_PROFILE);
+		return enable_trace_probe(tp, NULL);
 	case TRACE_REG_PERF_UNREGISTER:
-		disable_trace_probe(tp, TP_FLAG_PROFILE);
-		return 0;
+		return disable_trace_probe(tp, NULL);
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
 	case TRACE_REG_PERF_ADD:
@@ -1190,11 +1331,24 @@ static __used int kprobe_trace_selftest_target(int a1, int a2, int a3,
 	return a1 + a2 + a3 + a4 + a5 + a6;
 }
 
+static struct ftrace_event_file *
+find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
+
+	list_for_each_entry(file, &tr->events, list)
+		if (file->event_call == &tp->call)
+			return file;
+
+	return NULL;
+}
+
 static __init int kprobe_trace_self_tests_init(void)
 {
 	int ret, warn = 0;
 	int (*target)(int, int, int, int, int, int);
 	struct trace_probe *tp;
+	struct ftrace_event_file *file;
 
 	target = kprobe_trace_selftest_target;
 
@@ -1204,31 +1358,43 @@ static __init int kprobe_trace_self_tests_init(void)
 				  "$stack $stack0 +0($stack)",
 				  create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on probing function entry.\n");
+		pr_warn("error on probing function entry.\n");
 		warn++;
 	} else {
 		/* Enable trace point */
 		tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
-			pr_warning("error on getting new probe.\n");
+			pr_warn("error on getting new probe.\n");
 			warn++;
-		} else
-			enable_trace_probe(tp, TP_FLAG_TRACE);
+		} else {
+			file = find_trace_probe_file(tp, top_trace_array());
+			if (WARN_ON_ONCE(file == NULL)) {
+				pr_warn("error on getting probe file.\n");
+				warn++;
+			} else
+				enable_trace_probe(tp, file);
+		}
 	}
 
 	ret = traceprobe_command("r:testprobe2 kprobe_trace_selftest_target "
 				  "$retval", create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on probing function return.\n");
+		pr_warn("error on probing function return.\n");
 		warn++;
 	} else {
 		/* Enable trace point */
 		tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
-			pr_warning("error on getting new probe.\n");
+			pr_warn("error on getting 2nd new probe.\n");
 			warn++;
-		} else
-			enable_trace_probe(tp, TP_FLAG_TRACE);
+		} else {
+			file = find_trace_probe_file(tp, top_trace_array());
+			if (WARN_ON_ONCE(file == NULL)) {
+				pr_warn("error on getting probe file.\n");
+				warn++;
+			} else
+				enable_trace_probe(tp, file);
+		}
 	}
 
 	if (warn)
@@ -1239,27 +1405,39 @@ static __init int kprobe_trace_self_tests_init(void)
 	/* Disable trace points before removing it */
 	tp = find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
 	if (WARN_ON_ONCE(tp == NULL)) {
-		pr_warning("error on getting test probe.\n");
+		pr_warn("error on getting test probe.\n");
 		warn++;
-	} else
-		disable_trace_probe(tp, TP_FLAG_TRACE);
+	} else {
+		file = find_trace_probe_file(tp, top_trace_array());
+		if (WARN_ON_ONCE(file == NULL)) {
+			pr_warn("error on getting probe file.\n");
+			warn++;
+		} else
+			disable_trace_probe(tp, file);
+	}
 
 	tp = find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
 	if (WARN_ON_ONCE(tp == NULL)) {
-		pr_warning("error on getting 2nd test probe.\n");
+		pr_warn("error on getting 2nd test probe.\n");
 		warn++;
-	} else
-		disable_trace_probe(tp, TP_FLAG_TRACE);
+	} else {
+		file = find_trace_probe_file(tp, top_trace_array());
+		if (WARN_ON_ONCE(file == NULL)) {
+			pr_warn("error on getting probe file.\n");
+			warn++;
+		} else
+			disable_trace_probe(tp, file);
+	}
 
 	ret = traceprobe_command("-:testprobe", create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on deleting a probe.\n");
+		pr_warn("error on deleting a probe.\n");
 		warn++;
 	}
 
 	ret = traceprobe_command("-:testprobe2", create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on deleting a probe.\n");
+		pr_warn("error on deleting a probe.\n");
 		warn++;
 	}
 

