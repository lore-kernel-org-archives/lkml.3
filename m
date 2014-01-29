Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaA2PcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:32:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaA2PcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:32:10 -0500
Date: Wed, 29 Jan 2014 16:32:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Subject: Re: task_ctx_sched_out WARN_ON triggered.
Message-ID: <20140129153204.GB3229@twins.programming.kicks-ass.net>
References: <20140109154707.GB3714@redhat.com>
 <20140110104837.GL31570@twins.programming.kicks-ass.net>
 <20140121150953.GA2408@redhat.com>
 <20140129140744.GF9636@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129140744.GF9636@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 03:07:44PM +0100, Peter Zijlstra wrote:
> Let me see if I can make a 'nice' function to dump state though, it
> might come in handy more often.

Compile tested only...

---
 include/linux/perf_event.h |   4 ++
 init/Kconfig               |   7 ++
 kernel/events/core.c       | 163 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 173 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f5c9b6..4921ecd019db 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -437,6 +437,10 @@ struct perf_event {
 	int				cgrp_defer_enabled;
 #endif
 
+#ifdef CONFIG_PERF_DEBUG
+	struct list_head		debug_list;
+#endif
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
diff --git a/init/Kconfig b/init/Kconfig
index 5236dc562a36..29abe2aadb7d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1514,6 +1514,13 @@ config PERF_EVENTS
 
 	  Say Y if unsure.
 
+config PERF_DEBUG
+	default n
+	bool "Debug: add various debug helpers and overhead"
+	depends on PERF_EVENTS && DEBUG_KERNEL
+	help
+	 Say N if unsure.
+
 config DEBUG_PERF_USE_VMALLOC
 	default n
 	bool "Debug: use vmalloc to back perf mmap() buffers"
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6edfd3..7d5deab0a6f0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -164,6 +164,161 @@ int sysctl_perf_event_paranoid __read_mostly = 1;
 /* Minimum for 512 kiB + 1 user control page */
 int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
 
+#ifdef CONFIG_PERF_DEBUG
+
+static char *print_event_cgroup(struct perf_event *event)
+{
+#ifdef CONFIG_CGROUP_PERF
+	static char path[PATH_MAX];
+
+	if (!event->cgrp)
+		return "(null)";
+
+	cgroup_path(event->cgrp.css.cgroup, path, PATH_MAX);
+	return path;
+#else
+	return "(null)";
+#endif
+}
+
+static char *print_task(struct task_struct *p)
+{
+	static char task[2*TASK_COMM_LEN];
+
+	if (!p)
+		return "(null)";
+
+	snprintf(task, sizeof(task), "%d/%s", p->pid, p->comm);
+	return task;
+}
+
+static char *print_event_task(struct perf_event *event)
+{
+	if (!event->ctx)
+		return "(null)";
+
+	return print_task(event->ctx->task);
+}
+
+static void print_event(struct perf_event *event)
+{
+	struct perf_event *sibling;
+
+	printk("Event (%p) created by task: %s\n", event, print_task(event->owner));
+	printk("  cpu: %d\n", event->cpu);
+	printk("  cgrp: %s\n", print_event_cgroup(event));
+	printk("  task: %s\n", print_event_task(event));
+	printk("  group: ");
+	if (event->group_leader != event) {
+		list_for_each_entry(sibling, &event->sibling_list, group_entry)
+			printk("(%p),", sibling);
+	}
+	printk("\n");
+	printk("  attr: {\n");
+
+#define Pd(_x) if (event->attr._x) printk("\t." #_x " = %lld,\n", (unsigned long long)event->attr._x)
+#define Px(_x) if (event->attr._x) printk("\t." #_x " = 0x%llx,\n", (unsigned long long)event->attr._x)
+	Pd(type);
+	Px(config);
+	if (event->attr.freq) {
+		Pd(sample_freq);
+	} else {
+		Pd(sample_period);
+	}
+	Px(sample_type);
+	Px(read_format);
+
+	Pd(disabled);
+	Pd(inherit);
+	Pd(pinned);
+	Pd(exclusive);
+	Pd(exclude_user);
+	Pd(exclude_kernel);
+	Pd(exclude_hv);
+	Pd(exclude_idle);
+	Pd(mmap);
+	Pd(comm);
+	Pd(freq);
+	Pd(inherit_stat);
+	Pd(enable_on_exec);
+	Pd(task);
+	Pd(watermark);
+	Pd(precise_ip);
+	Pd(mmap_data);
+	Pd(sample_id_all);
+	Pd(exclude_host);
+	Pd(exclude_guest);
+	Pd(exclude_callchain_kernel);
+	Pd(exclude_callchain_user);
+	Pd(mmap2);
+	
+	if (event->attr.watermark) {
+		Pd(wakeup_watermark);
+	} else {
+		Pd(wakeup_events);
+	}
+	if (event->attr.type == PERF_TYPE_BREAKPOINT) {
+		Pd(bp_type);
+		Px(bp_addr);
+		Pd(bp_len);
+	} else {
+		Px(config1);
+		Px(config2);
+	}
+	Px(branch_sample_type);
+	Px(sample_regs_user);
+	Pd(sample_stack_user);
+
+	printk("  };\n");
+}
+
+static DEFINE_RAW_SPINLOCK(perf_debug_lock);
+static LIST_HEAD(perf_debug_list);
+
+static void perf_debug_print_events(void)
+{
+	struct perf_event *event;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &perf_debug_list, debug_list)
+		print_event(event);
+	rcu_read_unlock();
+}
+
+static void perf_debug_add_event(struct perf_event *event)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&perf_debug_lock, flags);
+	list_add_rcu(&event->debug_list, &perf_debug_list);
+	raw_spin_unlock_irqrestore(&perf_debug_lock, flags);
+}
+
+static void perf_debug_del_event(struct perf_event *event)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&perf_debug_lock, flags);
+	list_del_rcu(&event->debug_list);
+	raw_spin_unlock_irqrestore(&perf_debug_lock, flags);
+}
+
+#else /* CONFIG_PERF_DEBUG */
+
+static inline void perf_debug_add_event(struct perf_event *event)
+{
+}
+
+static inline void perf_debug_del_event(struct perf_event *event)
+{
+}
+
+static inline void perf_debug_print_events(void)
+{
+}
+
+#endif /* CONFIG_PERF_DEBUG */
+
 /*
  * max perf event sample rate
  */
@@ -2377,8 +2532,10 @@ static void task_ctx_sched_out(struct perf_event_context *ctx)
 	if (!cpuctx->task_ctx)
 		return;
 
-	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx))
+	if (WARN_ON_ONCE(ctx != cpuctx->task_ctx)) {
+		perf_debug_print_events();
 		return;
+	}
 
 	ctx_sched_out(ctx, cpuctx, EVENT_ALL);
 	cpuctx->task_ctx = NULL;
@@ -3227,6 +3384,7 @@ static void __free_event(struct perf_event *event)
 	if (event->ctx)
 		put_ctx(event->ctx);
 
+	perf_debug_del_event(event);
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 static void free_event(struct perf_event *event)
@@ -6764,6 +6922,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		}
 	}
 
+	perf_debug_add_event(event);
+
 	return event;
 
 err_pmu:
