Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbaFTTbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:31:39 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:44681
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbaFTTbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:35 -0400
Message-Id: <20140620193125.209414560@linux.com>
Date: Fri, 20 Jun 2014 14:31:18 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/31] scheduler: Replace __get_cpu_var with this_cpu_ptr
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_scheduler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of __get_cpu_var for address calculation to use
this_cpu_ptr instead.

Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/kernel_stat.h
===================================================================
--- linux.orig/include/linux/kernel_stat.h	2014-06-17 09:27:07.236328230 -0500
+++ linux/include/linux/kernel_stat.h	2014-06-17 09:27:07.228328386 -0500
@@ -44,8 +44,8 @@
 DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 /* Must have preemption disabled for this to be meaningful. */
-#define kstat_this_cpu (&__get_cpu_var(kstat))
-#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
+#define kstat_this_cpu this_cpu_ptr(&kstat)
+#define kcpustat_this_cpu this_cpu_ptr(&kernel_cpustat)
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
 #define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
 
Index: linux/kernel/events/callchain.c
===================================================================
--- linux.orig/kernel/events/callchain.c	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/events/callchain.c	2014-06-17 09:27:07.228328386 -0500
@@ -137,7 +137,7 @@
 	int cpu;
 	struct callchain_cpus_entries *entries;
 
-	*rctx = get_recursion_context(__get_cpu_var(callchain_recursion));
+	*rctx = get_recursion_context(this_cpu_ptr(callchain_recursion));
 	if (*rctx == -1)
 		return NULL;
 
@@ -153,7 +153,7 @@
 static void
 put_callchain_entry(int rctx)
 {
-	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
+	put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
 }
 
 struct perf_callchain_entry *
Index: linux/kernel/events/core.c
===================================================================
--- linux.orig/kernel/events/core.c	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/events/core.c	2014-06-17 09:27:07.232328307 -0500
@@ -238,7 +238,7 @@
 	u64 avg_local_sample_len;
 	u64 local_samples_len;
 
-	local_samples_len = __get_cpu_var(running_sample_length);
+	local_samples_len = __this_cpu_read(running_sample_length);
 	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
 
 	printk_ratelimited(KERN_WARNING
@@ -260,10 +260,10 @@
 		return;
 
 	/* decay the counter by 1 average sample */
-	local_samples_len = __get_cpu_var(running_sample_length);
+	local_samples_len = __this_cpu_read(running_sample_length);
 	local_samples_len -= local_samples_len/NR_ACCUMULATED_SAMPLES;
 	local_samples_len += sample_len_ns;
-	__get_cpu_var(running_sample_length) = local_samples_len;
+	__this_cpu_write(running_sample_length, local_samples_len);
 
 	/*
 	 * note: this will be biased artifically low until we have
@@ -876,7 +876,7 @@
 static void perf_pmu_rotate_start(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 
 	WARN_ON(!irqs_disabled());
 
@@ -2388,7 +2388,7 @@
 	 * to check if we have to switch out PMU state.
 	 * cgroup event are system-wide mode only
 	 */
-	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+	if (atomic_read(this_cpu_ptr(&perf_cgroup_events)))
 		perf_cgroup_sched_out(task, next);
 }
 
@@ -2631,11 +2631,11 @@
 	 * to check if we have to switch in PMU state.
 	 * cgroup event are system-wide mode only
 	 */
-	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+	if (atomic_read(this_cpu_ptr(&perf_cgroup_events)))
 		perf_cgroup_sched_in(prev, task);
 
 	/* check for system-wide branch_stack events */
-	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
+	if (atomic_read(this_cpu_ptr(&perf_branch_stack_events)))
 		perf_branch_stack_sched_in(prev, task);
 }
 
@@ -2890,7 +2890,7 @@
 
 void perf_event_task_tick(void)
 {
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
 	struct perf_event_context *ctx;
 	int throttled;
@@ -5632,7 +5632,7 @@
 				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct perf_event *event;
 	struct hlist_head *head;
 
@@ -5651,7 +5651,7 @@
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	return get_recursion_context(swhash->recursion);
 }
@@ -5659,7 +5659,7 @@
 
 inline void perf_swevent_put_recursion_context(int rctx)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	put_recursion_context(swhash->recursion, rctx);
 }
@@ -5688,7 +5688,7 @@
 
 static int perf_swevent_add(struct perf_event *event, int flags)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct hw_perf_event *hwc = &event->hw;
 	struct hlist_head *head;
 
Index: linux/kernel/sched/fair.c
===================================================================
--- linux.orig/kernel/sched/fair.c	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/sched/fair.c	2014-06-17 09:27:07.232328307 -0500
@@ -6490,7 +6490,7 @@
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
+	struct cpumask *cpus = this_cpu_ptr(load_balance_mask);
 
 	struct lb_env env = {
 		.sd		= sd,
Index: linux/kernel/sched/rt.c
===================================================================
--- linux.orig/kernel/sched/rt.c	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/sched/rt.c	2014-06-17 09:27:07.232328307 -0500
@@ -1522,7 +1522,7 @@
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
+	struct cpumask *lowest_mask = this_cpu_ptr(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
Index: linux/kernel/sched/sched.h
===================================================================
--- linux.orig/kernel/sched/sched.h	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/sched/sched.h	2014-06-17 09:27:07.232328307 -0500
@@ -647,10 +647,10 @@
 DECLARE_PER_CPU(struct rq, runqueues);
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
+#define this_rq()		this_cpu_ptr(&runqueues)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+#define raw_rq()		raw_cpu_ptr(&runqueues)
 
 static inline u64 rq_clock(struct rq *rq)
 {
Index: linux/kernel/user-return-notifier.c
===================================================================
--- linux.orig/kernel/user-return-notifier.c	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/user-return-notifier.c	2014-06-17 09:27:07.232328307 -0500
@@ -14,7 +14,7 @@
 void user_return_notifier_register(struct user_return_notifier *urn)
 {
 	set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
-	hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
+	hlist_add_head(&urn->link, this_cpu_ptr(&return_notifier_list));
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
@@ -25,7 +25,7 @@
 void user_return_notifier_unregister(struct user_return_notifier *urn)
 {
 	hlist_del(&urn->link);
-	if (hlist_empty(&__get_cpu_var(return_notifier_list)))
+	if (hlist_empty(this_cpu_ptr(&return_notifier_list)))
 		clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_unregister);
Index: linux/kernel/taskstats.c
===================================================================
--- linux.orig/kernel/taskstats.c	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/taskstats.c	2014-06-17 09:27:07.232328307 -0500
@@ -638,7 +638,7 @@
 		fill_tgid_exit(tsk);
 	}
 
-	listeners = __this_cpu_ptr(&listener_array);
+	listeners = raw_cpu_ptr(&listener_array);
 	if (list_empty(&listeners->list))
 		return;
 
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c	2014-06-17 09:27:07.236328230 -0500
+++ linux/kernel/time/tick-sched.c	2014-06-17 09:27:07.232328307 -0500
@@ -912,7 +912,7 @@
  */
 void tick_nohz_idle_exit(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now;
 
 	local_irq_disable();
@@ -1029,7 +1029,7 @@
 
 static inline void tick_nohz_irq_enter(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)
Index: linux/kernel/sched/deadline.c
===================================================================
--- linux.orig/kernel/sched/deadline.c	2014-06-17 09:25:49.000000000 -0500
+++ linux/kernel/sched/deadline.c	2014-06-17 09:27:23.368016325 -0500
@@ -1158,7 +1158,7 @@
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
+	struct cpumask *later_mask = this_cpu_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
 	int best_cpu, cpu = task_cpu(task);
 

