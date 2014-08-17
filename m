Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaHQRa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:30:59 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:45652 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbaHQRao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:30:44 -0400
Message-Id: <20140817173033.556938852@linux.com>
Date: Sun, 17 Aug 2014 12:30:27 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/35] [PATCH 04/36] scheduler: Replace __get_cpu_var with this_cpu_ptr
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-scheduler-Replace-__get_cpu_var-with-this_cpu_ptr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of __get_cpu_var for address calculation to use
this_cpu_ptr instead.

[Uses of __get_cpu_var with cpumask_var_t are no longer
handled by this patch]

Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 include/linux/kernel_stat.h   |  4 ++--
 kernel/events/callchain.c     |  4 ++--
 kernel/events/core.c          | 24 ++++++++++++------------
 kernel/sched/sched.h          |  4 ++--
 kernel/taskstats.c            |  2 +-
 kernel/time/tick-sched.c      |  4 ++--
 kernel/user-return-notifier.c |  4 ++--
 7 files changed, 23 insertions(+), 23 deletions(-)

Index: linux/include/linux/kernel_stat.h
===================================================================
--- linux.orig/include/linux/kernel_stat.h
+++ linux/include/linux/kernel_stat.h
@@ -44,8 +44,8 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
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
--- linux.orig/kernel/events/callchain.c
+++ linux/kernel/events/callchain.c
@@ -137,7 +137,7 @@ static struct perf_callchain_entry *get_
 	int cpu;
 	struct callchain_cpus_entries *entries;
 
-	*rctx = get_recursion_context(__get_cpu_var(callchain_recursion));
+	*rctx = get_recursion_context(this_cpu_ptr(callchain_recursion));
 	if (*rctx == -1)
 		return NULL;
 
@@ -153,7 +153,7 @@ static struct perf_callchain_entry *get_
 static void
 put_callchain_entry(int rctx)
 {
-	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
+	put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
 }
 
 struct perf_callchain_entry *
Index: linux/kernel/events/core.c
===================================================================
--- linux.orig/kernel/events/core.c
+++ linux/kernel/events/core.c
@@ -239,7 +239,7 @@ static void perf_duration_warn(struct ir
 	u64 avg_local_sample_len;
 	u64 local_samples_len;
 
-	local_samples_len = __get_cpu_var(running_sample_length);
+	local_samples_len = __this_cpu_read(running_sample_length);
 	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
 
 	printk_ratelimited(KERN_WARNING
@@ -261,10 +261,10 @@ void perf_sample_event_took(u64 sample_l
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
@@ -877,7 +877,7 @@ static DEFINE_PER_CPU(struct list_head,
 static void perf_pmu_rotate_start(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 
 	WARN_ON(!irqs_disabled());
 
@@ -2389,7 +2389,7 @@ void __perf_event_task_sched_out(struct
 	 * to check if we have to switch out PMU state.
 	 * cgroup event are system-wide mode only
 	 */
-	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+	if (atomic_read(this_cpu_ptr(&perf_cgroup_events)))
 		perf_cgroup_sched_out(task, next);
 }
 
@@ -2632,11 +2632,11 @@ void __perf_event_task_sched_in(struct t
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
 
@@ -2891,7 +2891,7 @@ bool perf_event_can_stop_tick(void)
 
 void perf_event_task_tick(void)
 {
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
 	struct perf_event_context *ctx;
 	int throttled;
@@ -5671,7 +5671,7 @@ static void do_perf_sw_event(enum perf_t
 				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct perf_event *event;
 	struct hlist_head *head;
 
@@ -5690,7 +5690,7 @@ end:
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	return get_recursion_context(swhash->recursion);
 }
@@ -5698,7 +5698,7 @@ EXPORT_SYMBOL_GPL(perf_swevent_get_recur
 
 inline void perf_swevent_put_recursion_context(int rctx)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	put_recursion_context(swhash->recursion, rctx);
 }
@@ -5727,7 +5727,7 @@ static void perf_swevent_read(struct per
 
 static int perf_swevent_add(struct perf_event *event, int flags)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct hw_perf_event *hwc = &event->hw;
 	struct hlist_head *head;
 
Index: linux/kernel/sched/sched.h
===================================================================
--- linux.orig/kernel/sched/sched.h
+++ linux/kernel/sched/sched.h
@@ -650,10 +650,10 @@ static inline int cpu_of(struct rq *rq)
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
Index: linux/kernel/taskstats.c
===================================================================
--- linux.orig/kernel/taskstats.c
+++ linux/kernel/taskstats.c
@@ -638,7 +638,7 @@ void taskstats_exit(struct task_struct *
 		fill_tgid_exit(tsk);
 	}
 
-	listeners = __this_cpu_ptr(&listener_array);
+	listeners = raw_cpu_ptr(&listener_array);
 	if (list_empty(&listeners->list))
 		return;
 
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -924,7 +924,7 @@ static void tick_nohz_account_idle_ticks
  */
 void tick_nohz_idle_exit(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now;
 
 	local_irq_disable();
@@ -1041,7 +1041,7 @@ static void tick_nohz_kick_tick(struct t
 
 static inline void tick_nohz_irq_enter(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)
Index: linux/kernel/user-return-notifier.c
===================================================================
--- linux.orig/kernel/user-return-notifier.c
+++ linux/kernel/user-return-notifier.c
@@ -14,7 +14,7 @@ static DEFINE_PER_CPU(struct hlist_head,
 void user_return_notifier_register(struct user_return_notifier *urn)
 {
 	set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
-	hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
+	hlist_add_head(&urn->link, this_cpu_ptr(&return_notifier_list));
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
@@ -25,7 +25,7 @@ EXPORT_SYMBOL_GPL(user_return_notifier_r
 void user_return_notifier_unregister(struct user_return_notifier *urn)
 {
 	hlist_del(&urn->link);
-	if (hlist_empty(&__get_cpu_var(return_notifier_list)))
+	if (hlist_empty(this_cpu_ptr(&return_notifier_list)))
 		clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_unregister);

