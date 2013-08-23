Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3HWTHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:07:24 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:32967 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932069Ab3HWTHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:07:19 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 15:07:19 EDT
Message-ID: <00000140ac8e2bdd-f0151a00-88ca-4d0b-adbc-007c514b6856-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:02:13 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 04/16] core: Convert __get_cpu_var uses
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 2013.08.23-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/events/callchain.c
===================================================================
--- linux.orig/kernel/events/callchain.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/events/callchain.c	2013-08-22 15:01:55.531964478 -0500
@@ -134,7 +134,7 @@ static struct perf_callchain_entry *get_
 	int cpu;
 	struct callchain_cpus_entries *entries;
 
-	*rctx = get_recursion_context(__get_cpu_var(callchain_recursion));
+	*rctx = get_recursion_context(this_cpu_ptr(callchain_recursion));
 	if (*rctx == -1)
 		return NULL;
 
@@ -150,7 +150,7 @@ static struct perf_callchain_entry *get_
 static void
 put_callchain_entry(int rctx)
 {
-	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
+	put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
 }
 
 struct perf_callchain_entry *
Index: linux/kernel/events/core.c
===================================================================
--- linux.orig/kernel/events/core.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/events/core.c	2013-08-22 15:01:55.531964478 -0500
@@ -238,10 +238,10 @@ void perf_sample_event_took(u64 sample_l
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
@@ -865,7 +865,7 @@ static DEFINE_PER_CPU(struct list_head,
 static void perf_pmu_rotate_start(struct pmu *pmu)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 
 	WARN_ON(!irqs_disabled());
 
@@ -2321,7 +2321,7 @@ void __perf_event_task_sched_out(struct
 	 * to check if we have to switch out PMU state.
 	 * cgroup event are system-wide mode only
 	 */
-	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
+	if (atomic_read(this_cpu_ptr(&perf_cgroup_events)))
 		perf_cgroup_sched_out(task, next);
 }
 
@@ -2566,11 +2566,11 @@ void __perf_event_task_sched_in(struct t
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
 
@@ -2811,7 +2811,7 @@ done:
 #ifdef CONFIG_NO_HZ_FULL
 bool perf_event_can_stop_tick(void)
 {
-	if (list_empty(&__get_cpu_var(rotation_list)))
+	if (list_empty(this_cpu_ptr(&rotation_list)))
 		return true;
 	else
 		return false;
@@ -2820,7 +2820,7 @@ bool perf_event_can_stop_tick(void)
 
 void perf_event_task_tick(void)
 {
-	struct list_head *head = &__get_cpu_var(rotation_list);
+	struct list_head *head = this_cpu_ptr(&rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
 	struct perf_event_context *ctx;
 	int throttled;
@@ -5414,7 +5414,7 @@ static void do_perf_sw_event(enum perf_t
 				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct perf_event *event;
 	struct hlist_head *head;
 
@@ -5433,7 +5433,7 @@ end:
 
 int perf_swevent_get_recursion_context(void)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	return get_recursion_context(swhash->recursion);
 }
@@ -5441,7 +5441,7 @@ EXPORT_SYMBOL_GPL(perf_swevent_get_recur
 
 inline void perf_swevent_put_recursion_context(int rctx)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 
 	put_recursion_context(swhash->recursion, rctx);
 }
@@ -5470,7 +5470,7 @@ static void perf_swevent_read(struct per
 
 static int perf_swevent_add(struct perf_event *event, int flags)
 {
-	struct swevent_htable *swhash = &__get_cpu_var(swevent_htable);
+	struct swevent_htable *swhash = this_cpu_ptr(&swevent_htable);
 	struct hw_perf_event *hwc = &event->hw;
 	struct hlist_head *head;
 
Index: linux/kernel/printk/printk.c
===================================================================
--- linux.orig/kernel/printk/printk.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/printk/printk.c	2013-08-22 15:01:55.531964478 -0500
@@ -2441,7 +2441,7 @@ static void wake_up_klogd_work_func(stru
 	int pending = __this_cpu_xchg(printk_pending, 0);
 
 	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
+		char *buf = this_cpu_ptr(printk_sched_buf);
 		printk(KERN_WARNING "[sched_delayed] %s", buf);
 	}
 
@@ -2459,7 +2459,7 @@ void wake_up_klogd(void)
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	}
 	preempt_enable();
 }
@@ -2472,14 +2472,14 @@ int printk_sched(const char *fmt, ...)
 	int r;
 
 	local_irq_save(flags);
-	buf = __get_cpu_var(printk_sched_buf);
+	buf = this_cpu_ptr(printk_sched_buf);
 
 	va_start(args, fmt);
 	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
-	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
 	local_irq_restore(flags);
 
 	return r;
Index: linux/kernel/rcutree.c
===================================================================
--- linux.orig/kernel/rcutree.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/rcutree.c	2013-08-22 15:01:55.531964478 -0500
@@ -383,7 +383,7 @@ static void rcu_eqs_enter(bool user)
 	long long oldval;
 	struct rcu_dynticks *rdtp;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
@@ -443,7 +443,7 @@ void rcu_user_enter_after_irq(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	/* Ensure this irq is interrupting a non-idle RCU state.  */
 	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_MASK));
 	rdtp->dynticks_nesting = 1;
@@ -474,7 +474,7 @@ void rcu_irq_exit(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
@@ -523,7 +523,7 @@ static void rcu_eqs_exit(bool user)
 	struct rcu_dynticks *rdtp;
 	long long oldval;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
 	if (oldval & DYNTICK_TASK_NEST_MASK)
@@ -581,7 +581,7 @@ void rcu_user_exit_after_irq(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	/* Ensure we are interrupting an RCU idle mode. */
 	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
 	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
@@ -615,7 +615,7 @@ void rcu_irq_enter(void)
 	long long oldval;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
@@ -635,7 +635,7 @@ void rcu_irq_enter(void)
  */
 void rcu_nmi_enter(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 &&
 	    (atomic_read(&rdtp->dynticks) & 0x1))
@@ -657,7 +657,7 @@ void rcu_nmi_enter(void)
  */
 void rcu_nmi_exit(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 ||
 	    --rdtp->dynticks_nmi_nesting != 0)
@@ -680,7 +680,7 @@ int rcu_is_cpu_idle(void)
 	int ret;
 
 	preempt_disable();
-	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	ret = (atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1) == 0;
 	preempt_enable();
 	return ret;
 }
@@ -718,7 +718,7 @@ bool rcu_lockdep_current_cpu_online(void
 	if (in_nmi())
 		return 1;
 	preempt_disable();
-	rdp = &__get_cpu_var(rcu_sched_data);
+	rdp = this_cpu_ptr(&rcu_sched_data);
 	rnp = rdp->mynode;
 	ret = (rdp->grpmask & rnp->qsmaskinit) ||
 	      !rcu_scheduler_fully_active;
@@ -738,7 +738,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cp
  */
 static int rcu_is_cpu_rrupt_from_idle(void)
 {
-	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
+	return __this_cpu_read(rcu_dynticks.dynticks_nesting) <= 1;
 }
 
 /*
Index: linux/kernel/sched/cputime.c
===================================================================
--- linux.orig/kernel/sched/cputime.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/sched/cputime.c	2013-08-22 15:01:55.531964478 -0500
@@ -121,7 +121,7 @@ static inline void task_group_account_fi
 	 * is the only cgroup, then nothing else should be necessary.
 	 *
 	 */
-	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+	__this_cpu_add(kernel_cpustat.cpustat[index], tmp);
 
 	cpuacct_account_field(p, index, tmp);
 }
Index: linux/kernel/sched/fair.c
===================================================================
--- linux.orig/kernel/sched/fair.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/sched/fair.c	2013-08-22 15:01:55.531964478 -0500
@@ -5057,7 +5057,7 @@ static int load_balance(int this_cpu, st
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
+	struct cpumask *cpus = this_cpu_ptr(load_balance_mask);
 
 	struct lb_env env = {
 		.sd		= sd,
Index: linux/kernel/sched/rt.c
===================================================================
--- linux.orig/kernel/sched/rt.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/sched/rt.c	2013-08-22 15:01:55.535964438 -0500
@@ -1389,7 +1389,7 @@ static DEFINE_PER_CPU(cpumask_var_t, loc
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
+	struct cpumask *lowest_mask = this_cpu_ptr(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/time/tick-sched.c	2013-08-22 15:01:55.535964438 -0500
@@ -199,7 +199,7 @@ static void tick_nohz_restart_sched_tick
  */
 void tick_nohz_full_check(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (tick_nohz_full_cpu(smp_processor_id())) {
 		if (ts->tick_stopped && !is_idle_task(current)) {
@@ -225,7 +225,7 @@ static DEFINE_PER_CPU(struct irq_work, n
 void tick_nohz_full_kick(void)
 {
 	if (tick_nohz_full_cpu(smp_processor_id()))
-		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+		irq_work_queue(this_cpu_ptr(&nohz_full_kick_work));
 }
 
 static void nohz_full_kick_ipi(void *info)
@@ -536,7 +536,7 @@ static ktime_t tick_nohz_stop_sched_tick
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	unsigned long rcu_delta_jiffies;
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 	u64 time_delta;
 
 	/* Read jiffies and the time when jiffies were updated last */
@@ -801,7 +801,7 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_disable();
 
-	ts = &__get_cpu_var(tick_cpu_sched);
+	ts = this_cpu_ptr(&tick_cpu_sched);
 	/*
 	 * set ts->inidle unconditionally. even if the system did not
 	 * switch to nohz mode the cpu frequency governers rely on the
@@ -824,7 +824,7 @@ EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
  */
 void tick_nohz_irq_exit(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (ts->inidle)
 		__tick_nohz_idle_enter(ts);
@@ -839,7 +839,7 @@ void tick_nohz_irq_exit(void)
  */
 ktime_t tick_nohz_get_sleep_length(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	return ts->sleep_length;
 }
@@ -953,7 +953,7 @@ static int tick_nohz_reprogram(struct ti
  */
 static void tick_nohz_handler(struct clock_event_device *dev)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
@@ -973,7 +973,7 @@ static void tick_nohz_handler(struct clo
  */
 static void tick_nohz_switch_to_nohz(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t next;
 
 	if (!tick_nohz_enabled)
@@ -1111,7 +1111,7 @@ early_param("skew_tick", skew_tick);
  */
 void tick_setup_sched_timer(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now = ktime_get();
 
 	/*
@@ -1178,7 +1178,7 @@ void tick_clock_notify(void)
  */
 void tick_oneshot_notify(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	set_bit(0, &ts->check_clocks);
 }
@@ -1193,7 +1193,7 @@ void tick_oneshot_notify(void)
  */
 int tick_check_oneshot_change(int allow_nohz)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (!test_and_clear_bit(0, &ts->check_clocks))
 		return 0;
Index: linux/net/ipv4/syncookies.c
===================================================================
--- linux.orig/net/ipv4/syncookies.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/net/ipv4/syncookies.c	2013-08-22 16:17:15.182593775 -0500
@@ -44,7 +44,7 @@ static DEFINE_PER_CPU(__u32 [16 + 5 + SH
 static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
 		       u32 count, int c)
 {
-	__u32 *tmp = __get_cpu_var(ipv4_cookie_scratch);
+	__u32 *tmp = this_cpu_ptr(ipv4_cookie_scratch);
 
 	memcpy(tmp + 4, syncookie_secret[c], sizeof(syncookie_secret[c]));
 	tmp[0] = (__force u32)saddr;
Index: linux/net/ipv6/syncookies.c
===================================================================
--- linux.orig/net/ipv6/syncookies.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/net/ipv6/syncookies.c	2013-08-22 16:17:15.182593775 -0500
@@ -66,7 +66,7 @@ static DEFINE_PER_CPU(__u32 [16 + 5 + SH
 static u32 cookie_hash(const struct in6_addr *saddr, const struct in6_addr *daddr,
 		       __be16 sport, __be16 dport, u32 count, int c)
 {
-	__u32 *tmp = __get_cpu_var(ipv6_cookie_scratch);
+	__u32 *tmp = this_cpu_ptr(ipv6_cookie_scratch);
 
 	/*
 	 * we have 320 bits of information to hash, copy in the remaining
Index: linux/block/blk-iopoll.c
===================================================================
--- linux.orig/block/blk-iopoll.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/block/blk-iopoll.c	2013-08-22 15:01:55.535964438 -0500
@@ -35,7 +35,7 @@ void blk_iopoll_sched(struct blk_iopoll
 	unsigned long flags;
 
 	local_irq_save(flags);
-	list_add_tail(&iop->list, &__get_cpu_var(blk_cpu_iopoll));
+	list_add_tail(&iop->list, this_cpu_ptr(&blk_cpu_iopoll));
 	__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -79,7 +79,7 @@ EXPORT_SYMBOL(blk_iopoll_complete);
 
 static void blk_iopoll_softirq(struct softirq_action *h)
 {
-	struct list_head *list = &__get_cpu_var(blk_cpu_iopoll);
+	struct list_head *list = this_cpu_ptr(&blk_cpu_iopoll);
 	int rearm = 0, budget = blk_iopoll_budget;
 	unsigned long start_time = jiffies;
 
@@ -201,7 +201,7 @@ static int blk_iopoll_cpu_notify(struct
 
 		local_irq_disable();
 		list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
-				 &__get_cpu_var(blk_cpu_iopoll));
+				 this_cpu_ptr(&blk_cpu_iopoll));
 		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
 		local_irq_enable();
 	}
Index: linux/block/blk-softirq.c
===================================================================
--- linux.orig/block/blk-softirq.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/block/blk-softirq.c	2013-08-22 15:01:55.535964438 -0500
@@ -23,7 +23,7 @@ static void blk_done_softirq(struct soft
 	struct list_head *cpu_list, local_list;
 
 	local_irq_disable();
-	cpu_list = &__get_cpu_var(blk_cpu_done);
+	cpu_list = this_cpu_ptr(&blk_cpu_done);
 	list_replace_init(cpu_list, &local_list);
 	local_irq_enable();
 
@@ -44,7 +44,7 @@ static void trigger_softirq(void *data)
 	struct list_head *list;
 
 	local_irq_save(flags);
-	list = &__get_cpu_var(blk_cpu_done);
+	list = this_cpu_ptr(&blk_cpu_done);
 	list_add_tail(&rq->csd.list, list);
 
 	if (list->next == &rq->csd.list)
@@ -90,7 +90,7 @@ static int blk_cpu_notify(struct notifie
 
 		local_irq_disable();
 		list_splice_init(&per_cpu(blk_cpu_done, cpu),
-				 &__get_cpu_var(blk_cpu_done));
+				 this_cpu_ptr(&blk_cpu_done));
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 		local_irq_enable();
 	}
@@ -135,7 +135,7 @@ void __blk_complete_request(struct reque
 	if (ccpu == cpu || shared) {
 		struct list_head *list;
 do_local:
-		list = &__get_cpu_var(blk_cpu_done);
+		list = this_cpu_ptr(&blk_cpu_done);
 		list_add_tail(&req->csd.list, list);
 
 		/*
Index: linux/fs/fscache/object.c
===================================================================
--- linux.orig/fs/fscache/object.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/fs/fscache/object.c	2013-08-22 15:01:55.535964438 -0500
@@ -796,7 +796,7 @@ void fscache_enqueue_object(struct fscac
  */
 bool fscache_object_sleep_till_congested(signed long *timeoutp)
 {
-	wait_queue_head_t *cong_wq = &__get_cpu_var(fscache_object_cong_wait);
+	wait_queue_head_t *cong_wq = this_cpu_ptr(&fscache_object_cong_wait);
 	DEFINE_WAIT(wait);
 
 	if (fscache_object_congested())
Index: linux/include/linux/kernel_stat.h
===================================================================
--- linux.orig/include/linux/kernel_stat.h	2013-08-22 15:01:55.543964358 -0500
+++ linux/include/linux/kernel_stat.h	2013-08-22 15:01:55.535964438 -0500
@@ -47,8 +47,8 @@ DECLARE_PER_CPU(struct kernel_stat, ksta
 DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 /* Must have preemption disabled for this to be meaningful. */
-#define kstat_this_cpu (&__get_cpu_var(kstat))
-#define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
+#define kstat_this_cpu this_cpu_ptr(&kstat)
+#define kcpustat_this_cpu this_cpu_ptr(&kernel_cpustat)
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
 #define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
 
Index: linux/include/linux/kprobes.h
===================================================================
--- linux.orig/include/linux/kprobes.h	2013-08-22 15:01:55.543964358 -0500
+++ linux/include/linux/kprobes.h	2013-08-22 15:01:55.535964438 -0500
@@ -329,7 +329,7 @@ static inline void reset_current_kprobe(
 
 static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
 {
-	return (&__get_cpu_var(kprobe_ctlblk));
+	return this_cpu_ptr(&kprobe_ctlblk);
 }
 
 int register_kprobe(struct kprobe *p);
Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-08-22 15:01:55.543964358 -0500
+++ linux/include/linux/percpu.h	2013-08-22 15:01:55.535964438 -0500
@@ -28,7 +28,7 @@
  */
 #define get_cpu_var(var) (*({				\
 	preempt_disable();				\
-	&__get_cpu_var(var); }))
+	this_cpu_ptr(&var); }))
 
 /*
  * The weird & is necessary because sparse considers (void)(var) to be
Index: linux/include/net/netfilter/nf_conntrack.h
===================================================================
--- linux.orig/include/net/netfilter/nf_conntrack.h	2013-08-22 15:01:55.543964358 -0500
+++ linux/include/net/netfilter/nf_conntrack.h	2013-08-22 15:01:55.535964438 -0500
@@ -243,7 +243,7 @@ extern s16 (*nf_ct_nat_offset)(const str
 DECLARE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
 static inline struct nf_conn *nf_ct_untracked_get(void)
 {
-	return &__raw_get_cpu_var(nf_conntrack_untracked);
+	return __this_cpu_ptr(&nf_conntrack_untracked);
 }
 extern void nf_ct_untracked_status_or(unsigned long bits);
 
Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/hrtimer.c	2013-08-22 15:01:55.535964438 -0500
@@ -597,7 +597,7 @@ hrtimer_force_reprogram(struct hrtimer_c
 static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
 	int res;
 
@@ -680,7 +680,7 @@ static inline ktime_t hrtimer_update_bas
  */
 static void retrigger_next_event(void *arg)
 {
-	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *base = this_cpu_ptr(&hrtimer_bases);
 
 	if (!hrtimer_hres_active())
 		return;
@@ -954,7 +954,7 @@ remove_hrtimer(struct hrtimer *timer, st
 		 */
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
-		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
+		reprogram = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
 		/*
 		 * We must preserve the CALLBACK state flag here,
 		 * otherwise we could move the timer base in
@@ -1009,7 +1009,7 @@ int __hrtimer_start_range_ns(struct hrti
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+	if (leftmost && new_base->cpu_base == this_cpu_ptr(&hrtimer_bases)
 		&& hrtimer_enqueue_reprogram(timer, new_base)) {
 		if (wakeup) {
 			/*
@@ -1142,7 +1142,7 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining)
  */
 ktime_t hrtimer_get_next_event(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
 	unsigned long flags;
@@ -1183,7 +1183,7 @@ static void __hrtimer_init(struct hrtime
 
 	memset(timer, 0, sizeof(struct hrtimer));
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = __this_cpu_ptr(&hrtimer_bases);
 
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
@@ -1226,7 +1226,7 @@ int hrtimer_get_res(const clockid_t whic
 	struct hrtimer_cpu_base *cpu_base;
 	int base = hrtimer_clockid_to_base(which_clock);
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = __this_cpu_ptr(&hrtimer_bases);
 	*tp = ktime_to_timespec(cpu_base->clock_base[base].resolution);
 
 	return 0;
@@ -1281,7 +1281,7 @@ static void __run_hrtimer(struct hrtimer
  */
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
 
@@ -1415,7 +1415,7 @@ static void __hrtimer_peek_ahead_timers(
 	if (!hrtimer_hres_active())
 		return;
 
-	td = &__get_cpu_var(tick_cpu_device);
+	td = this_cpu_ptr(&tick_cpu_device);
 	if (td && td->evtdev)
 		hrtimer_interrupt(td->evtdev);
 }
@@ -1479,7 +1479,7 @@ void hrtimer_run_pending(void)
 void hrtimer_run_queues(void)
 {
 	struct timerqueue_node *node;
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	int index, gettime = 1;
 
@@ -1717,7 +1717,7 @@ static void migrate_hrtimers(int scpu)
 
 	local_irq_disable();
 	old_base = &per_cpu(hrtimer_bases, scpu);
-	new_base = &__get_cpu_var(hrtimer_bases);
+	new_base = this_cpu_ptr(&hrtimer_bases);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
Index: linux/kernel/irq_work.c
===================================================================
--- linux.orig/kernel/irq_work.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/irq_work.c	2013-08-22 15:01:55.535964438 -0500
@@ -70,7 +70,7 @@ void irq_work_queue(struct irq_work *wor
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+	llist_add(&work->llnode, this_cpu_ptr(&irq_work_list));
 
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
@@ -90,7 +90,7 @@ bool irq_work_needs_cpu(void)
 {
 	struct llist_head *this_list;
 
-	this_list = &__get_cpu_var(irq_work_list);
+	this_list = this_cpu_ptr(&irq_work_list);
 	if (llist_empty(this_list))
 		return false;
 
@@ -115,7 +115,7 @@ static void __irq_work_run(void)
 	__this_cpu_write(irq_work_raised, 0);
 	barrier();
 
-	this_list = &__get_cpu_var(irq_work_list);
+	this_list = this_cpu_ptr(&irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
Index: linux/kernel/rcutree_plugin.h
===================================================================
--- linux.orig/kernel/rcutree_plugin.h	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/rcutree_plugin.h	2013-08-22 15:01:55.535964438 -0500
@@ -662,7 +662,7 @@ static void rcu_preempt_check_callbacks(
 
 static void rcu_preempt_do_callbacks(void)
 {
-	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
+	rcu_do_batch(&rcu_preempt_state, this_cpu_ptr(&rcu_preempt_data));
 }
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
@@ -1334,7 +1334,7 @@ static void invoke_rcu_callbacks_kthread
  */
 static bool rcu_is_callbacks_kthread(void)
 {
-	return __get_cpu_var(rcu_cpu_kthread_task) == current;
+	return __this_cpu_read(rcu_cpu_kthread_task) == current;
 }
 
 #define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
@@ -1384,8 +1384,8 @@ static int rcu_spawn_one_boost_kthread(s
 
 static void rcu_kthread_do_work(void)
 {
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_do_batch(&rcu_sched_state, this_cpu_ptr(&rcu_sched_data));
+	rcu_do_batch(&rcu_bh_state, this_cpu_ptr(&rcu_bh_data));
 	rcu_preempt_do_callbacks();
 }
 
@@ -1404,7 +1404,7 @@ static void rcu_cpu_kthread_park(unsigne
 
 static int rcu_cpu_kthread_should_run(unsigned int cpu)
 {
-	return __get_cpu_var(rcu_cpu_has_work);
+	return __this_cpu_read(rcu_cpu_has_work);
 }
 
 /*
@@ -1414,8 +1414,8 @@ static int rcu_cpu_kthread_should_run(un
  */
 static void rcu_cpu_kthread(unsigned int cpu)
 {
-	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
-	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	unsigned int *statusp = this_cpu_ptr(&rcu_cpu_kthread_status);
+	char work, *workp = this_cpu_ptr(&rcu_cpu_has_work);
 	int spincnt;
 
 	for (spincnt = 0; spincnt < 10; spincnt++) {
Index: linux/kernel/sched/clock.c
===================================================================
--- linux.orig/kernel/sched/clock.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/sched/clock.c	2013-08-22 15:01:55.535964438 -0500
@@ -94,7 +94,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(str
 
 static inline struct sched_clock_data *this_scd(void)
 {
-	return &__get_cpu_var(sched_clock_data);
+	return this_cpu_ptr(&sched_clock_data);
 }
 
 static inline struct sched_clock_data *cpu_sdc(int cpu)
Index: linux/kernel/sched/sched.h
===================================================================
--- linux.orig/kernel/sched/sched.h	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/sched/sched.h	2013-08-22 15:01:55.535964438 -0500
@@ -538,10 +538,10 @@ static inline int cpu_of(struct rq *rq)
 DECLARE_PER_CPU(struct rq, runqueues);
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
+#define this_rq()		this_cpu_ptr(&runqueues)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+#define raw_rq()		__this_cpu_ptr(&runqueues)
 
 static inline u64 rq_clock(struct rq *rq)
 {
Index: linux/kernel/smp.c
===================================================================
--- linux.orig/kernel/smp.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/smp.c	2013-08-22 15:01:55.535964438 -0500
@@ -172,7 +172,7 @@ void generic_exec_single(int cpu, struct
  */
 void generic_smp_call_function_single_interrupt(void)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_single_queue *q = this_cpu_ptr(&call_single_queue);
 	LIST_HEAD(list);
 
 	/*
@@ -252,7 +252,7 @@ int smp_call_function_single(int cpu, sm
 			struct call_single_data *csd = &d;
 
 			if (!wait)
-				csd = &__get_cpu_var(csd_data);
+				csd = this_cpu_ptr(&csd_data);
 
 			csd_lock(csd);
 
@@ -401,7 +401,7 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	cfd = &__get_cpu_var(cfd_data);
+	cfd = this_cpu_ptr(&cfd_data);
 
 	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, cfd->cpumask);
Index: linux/kernel/softirq.c
===================================================================
--- linux.orig/kernel/softirq.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/softirq.c	2013-08-22 15:01:55.535964438 -0500
@@ -466,7 +466,7 @@ static void tasklet_action(struct softir
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_vec.head);
 	__this_cpu_write(tasklet_vec.head, NULL);
-	__this_cpu_write(tasklet_vec.tail, &__get_cpu_var(tasklet_vec).head);
+	__this_cpu_write(tasklet_vec.tail, this_cpu_ptr(&tasklet_vec.head));
 	local_irq_enable();
 
 	while (list) {
@@ -501,7 +501,7 @@ static void tasklet_hi_action(struct sof
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_hi_vec.head);
 	__this_cpu_write(tasklet_hi_vec.head, NULL);
-	__this_cpu_write(tasklet_hi_vec.tail, &__get_cpu_var(tasklet_hi_vec).head);
+	__this_cpu_write(tasklet_hi_vec.tail, this_cpu_ptr(&tasklet_hi_vec.head));
 	local_irq_enable();
 
 	while (list) {
@@ -618,7 +618,7 @@ EXPORT_PER_CPU_SYMBOL(softirq_work_list)
 
 static void __local_trigger(struct call_single_data *cp, int softirq)
 {
-	struct list_head *head = &__get_cpu_var(softirq_work_list[softirq]);
+	struct list_head *head = this_cpu_ptr(&softirq_work_list[softirq]);
 
 	list_add_tail(&cp->list, head);
 
@@ -718,7 +718,7 @@ static int remote_softirq_cpu_notify(str
 			if (list_empty(head))
 				continue;
 
-			local_head = &__get_cpu_var(softirq_work_list[i]);
+			local_head = this_cpu_ptr(&softirq_work_list[i]);
 			list_splice_init(head, local_head);
 			raise_softirq_irqoff(i);
 		}
Index: linux/kernel/time/tick-common.c
===================================================================
--- linux.orig/kernel/time/tick-common.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/time/tick-common.c	2013-08-22 15:01:55.535964438 -0500
@@ -208,7 +208,7 @@ static void tick_setup_device(struct tic
 
 void tick_install_replacement(struct clock_event_device *newdev)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
@@ -358,14 +358,14 @@ void tick_shutdown(unsigned int *cpup)
 
 void tick_suspend(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 
 	clockevents_shutdown(td->evtdev);
 }
 
 void tick_resume(void)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	int broadcast = tick_resume_broadcast();
 
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
Index: linux/kernel/time/tick-oneshot.c
===================================================================
--- linux.orig/kernel/time/tick-oneshot.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/time/tick-oneshot.c	2013-08-22 15:01:55.535964438 -0500
@@ -59,7 +59,7 @@ void tick_setup_oneshot(struct clock_eve
  */
 int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/trace/ftrace.c	2013-08-22 15:01:55.535964438 -0500
@@ -870,7 +870,7 @@ function_profile_call(unsigned long ip,
 
 	local_irq_save(flags);
 
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
@@ -901,7 +901,7 @@ static void profile_graph_return(struct
 	unsigned long flags;
 
 	local_irq_save(flags);
-	stat = &__get_cpu_var(ftrace_profile_stats);
+	stat = this_cpu_ptr(&ftrace_profile_stats);
 	if (!stat->hash || !ftrace_profile_enabled)
 		goto out;
 
Index: linux/kernel/user-return-notifier.c
===================================================================
--- linux.orig/kernel/user-return-notifier.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/user-return-notifier.c	2013-08-22 15:01:55.535964438 -0500
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
Index: linux/kernel/watchdog.c
===================================================================
--- linux.orig/kernel/watchdog.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/watchdog.c	2013-08-22 15:01:55.535964438 -0500
@@ -174,8 +174,8 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 void touch_softlockup_watchdog_sync(void)
 {
-	__raw_get_cpu_var(softlockup_touch_sync) = true;
-	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+	__this_cpu_write(softlockup_touch_sync, 1);
+	__this_cpu_write(watchdog_touch_ts, 0);
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -341,7 +341,7 @@ static void watchdog_set_prio(unsigned i
 
 static void watchdog_enable(unsigned int cpu)
 {
-	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+	struct hrtimer *hrtimer = __this_cpu_ptr(&watchdog_hrtimer);
 
 	/* kick off the timer for the hardlockup detector */
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -361,7 +361,7 @@ static void watchdog_enable(unsigned int
 
 static void watchdog_disable(unsigned int cpu)
 {
-	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+	struct hrtimer *hrtimer = __this_cpu_ptr(&watchdog_hrtimer);
 
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
Index: linux/lib/radix-tree.c
===================================================================
--- linux.orig/lib/radix-tree.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/lib/radix-tree.c	2013-08-22 15:01:55.535964438 -0500
@@ -215,7 +215,7 @@ radix_tree_node_alloc(struct radix_tree_
 		 * succeed in getting a node here (and never reach
 		 * kmem_cache_alloc)
 		 */
-		rtp = &__get_cpu_var(radix_tree_preloads);
+		rtp = this_cpu_ptr(&radix_tree_preloads);
 		if (rtp->nr) {
 			ret = rtp->nodes[rtp->nr - 1];
 			rtp->nodes[rtp->nr - 1] = NULL;
@@ -271,14 +271,14 @@ int radix_tree_preload(gfp_t gfp_mask)
 	int ret = -ENOMEM;
 
 	preempt_disable();
-	rtp = &__get_cpu_var(radix_tree_preloads);
+	rtp = this_cpu_ptr(&radix_tree_preloads);
 	while (rtp->nr < ARRAY_SIZE(rtp->nodes)) {
 		preempt_enable();
 		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 		if (node == NULL)
 			goto out;
 		preempt_disable();
-		rtp = &__get_cpu_var(radix_tree_preloads);
+		rtp = this_cpu_ptr(&radix_tree_preloads);
 		if (rtp->nr < ARRAY_SIZE(rtp->nodes))
 			rtp->nodes[rtp->nr++] = node;
 		else
Index: linux/mm/memcontrol.c
===================================================================
--- linux.orig/mm/memcontrol.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/mm/memcontrol.c	2013-08-22 15:01:55.535964438 -0500
@@ -2398,7 +2398,7 @@ static void drain_stock(struct memcg_sto
  */
 static void drain_local_stock(struct work_struct *dummy)
 {
-	struct memcg_stock_pcp *stock = &__get_cpu_var(memcg_stock);
+	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 }
Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/mm/memory-failure.c	2013-08-22 15:01:55.535964438 -0500
@@ -1279,7 +1279,7 @@ static void memory_failure_work_func(str
 	unsigned long proc_flags;
 	int gotten;
 
-	mf_cpu = &__get_cpu_var(memory_failure_cpu);
+	mf_cpu = this_cpu_ptr(&memory_failure_cpu);
 	for (;;) {
 		spin_lock_irqsave(&mf_cpu->lock, proc_flags);
 		gotten = kfifo_get(&mf_cpu->fifo, &entry);
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/mm/page-writeback.c	2013-08-22 15:01:55.539964397 -0500
@@ -1487,7 +1487,7 @@ void balance_dirty_pages_ratelimited(str
 	 * 1000+ tasks, all of them start dirtying pages at exactly the same
 	 * time, hence all honoured too large initial task->nr_dirtied_pause.
 	 */
-	p =  &__get_cpu_var(bdp_ratelimits);
+	p =  this_cpu_ptr(&bdp_ratelimits);
 	if (unlikely(current->nr_dirtied >= ratelimit))
 		*p = 0;
 	else if (unlikely(*p >= ratelimit_pages)) {
@@ -1499,7 +1499,7 @@ void balance_dirty_pages_ratelimited(str
 	 * short-lived tasks (eg. gcc invocations in a kernel build) escaping
 	 * the dirty throttling and livelock other long-run dirtiers.
 	 */
-	p = &__get_cpu_var(dirty_throttle_leaks);
+	p = this_cpu_ptr(&dirty_throttle_leaks);
 	if (*p > 0 && current->nr_dirtied < ratelimit) {
 		unsigned long nr_pages_dirtied;
 		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
Index: linux/mm/swap.c
===================================================================
--- linux.orig/mm/swap.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/mm/swap.c	2013-08-22 15:01:55.539964397 -0500
@@ -359,7 +359,7 @@ void rotate_reclaimable_page(struct page
 
 		page_cache_get(page);
 		local_irq_save(flags);
-		pvec = &__get_cpu_var(lru_rotate_pvecs);
+		pvec = this_cpu_ptr(&lru_rotate_pvecs);
 		if (!pagevec_add(pvec, page))
 			pagevec_move_tail(pvec);
 		local_irq_restore(flags);
Index: linux/mm/vmalloc.c
===================================================================
--- linux.orig/mm/vmalloc.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/mm/vmalloc.c	2013-08-22 15:01:55.539964397 -0500
@@ -1487,7 +1487,7 @@ void vfree(const void *addr)
 	if (!addr)
 		return;
 	if (unlikely(in_interrupt())) {
-		struct vfree_deferred *p = &__get_cpu_var(vfree_deferred);
+		struct vfree_deferred *p = this_cpu_ptr(&vfree_deferred);
 		if (llist_add((struct llist_node *)addr, &p->list))
 			schedule_work(&p->wq);
 	} else
Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/mm/vmstat.c	2013-08-22 15:01:55.539964397 -0500
@@ -1178,7 +1178,7 @@ int sysctl_stat_interval __read_mostly =
 static void vmstat_update(struct work_struct *w)
 {
 	refresh_cpu_vm_stats(smp_processor_id());
-	schedule_delayed_work(&__get_cpu_var(vmstat_work),
+	schedule_delayed_work(this_cpu_ptr(&vmstat_work),
 		round_jiffies_relative(sysctl_stat_interval));
 }
 
Index: linux/net/core/dev.c
===================================================================
--- linux.orig/net/core/dev.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/net/core/dev.c	2013-08-22 15:01:55.539964397 -0500
@@ -2129,7 +2129,7 @@ static inline void __netif_reschedule(st
 	unsigned long flags;
 
 	local_irq_save(flags);
-	sd = &__get_cpu_var(softnet_data);
+	sd = this_cpu_ptr(&softnet_data);
 	q->next_sched = NULL;
 	*sd->output_queue_tailp = q;
 	sd->output_queue_tailp = &q->next_sched;
@@ -2151,7 +2151,7 @@ void dev_kfree_skb_irq(struct sk_buff *s
 		unsigned long flags;
 
 		local_irq_save(flags);
-		sd = &__get_cpu_var(softnet_data);
+		sd = this_cpu_ptr(&softnet_data);
 		skb->next = sd->completion_queue;
 		sd->completion_queue = skb;
 		raise_softirq_irqoff(NET_TX_SOFTIRQ);
@@ -3111,7 +3111,7 @@ static void rps_trigger_softirq(void *da
 static int rps_ipi_queued(struct softnet_data *sd)
 {
 #ifdef CONFIG_RPS
-	struct softnet_data *mysd = &__get_cpu_var(softnet_data);
+	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
 
 	if (sd != mysd) {
 		sd->rps_ipi_next = mysd->rps_ipi_list;
@@ -3138,7 +3138,7 @@ static bool skb_flow_limit(struct sk_buf
 	if (qlen < (netdev_max_backlog >> 1))
 		return false;
 
-	sd = &__get_cpu_var(softnet_data);
+	sd = this_cpu_ptr(&softnet_data);
 
 	rcu_read_lock();
 	fl = rcu_dereference(sd->flow_limit);
@@ -3280,7 +3280,7 @@ EXPORT_SYMBOL(netif_rx_ni);
 
 static void net_tx_action(struct softirq_action *h)
 {
-	struct softnet_data *sd = &__get_cpu_var(softnet_data);
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 
 	if (sd->completion_queue) {
 		struct sk_buff *clist;
@@ -3700,7 +3700,7 @@ EXPORT_SYMBOL(netif_receive_skb);
 static void flush_backlog(void *arg)
 {
 	struct net_device *dev = arg;
-	struct softnet_data *sd = &__get_cpu_var(softnet_data);
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	struct sk_buff *skb, *tmp;
 
 	rps_lock(sd);
@@ -4146,7 +4146,7 @@ void __napi_schedule(struct napi_struct
 	unsigned long flags;
 
 	local_irq_save(flags);
-	____napi_schedule(&__get_cpu_var(softnet_data), n);
+	____napi_schedule(this_cpu_ptr(&softnet_data), n);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__napi_schedule);
@@ -4274,7 +4274,7 @@ EXPORT_SYMBOL(netif_napi_del);
 
 static void net_rx_action(struct softirq_action *h)
 {
-	struct softnet_data *sd = &__get_cpu_var(softnet_data);
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies + 2;
 	int budget = netdev_budget;
 	void *have;
Index: linux/net/core/drop_monitor.c
===================================================================
--- linux.orig/net/core/drop_monitor.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/net/core/drop_monitor.c	2013-08-22 15:01:55.539964397 -0500
@@ -142,7 +142,7 @@ static void trace_drop_common(struct sk_
 	unsigned long flags;
 
 	local_irq_save(flags);
-	data = &__get_cpu_var(dm_cpu_data);
+	data = this_cpu_ptr(&dm_cpu_data);
 	spin_lock(&data->lock);
 	dskb = data->skb;
 
Index: linux/net/core/skbuff.c
===================================================================
--- linux.orig/net/core/skbuff.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/net/core/skbuff.c	2013-08-22 15:01:55.539964397 -0500
@@ -371,7 +371,7 @@ static void *__netdev_alloc_frag(unsigne
 	unsigned long flags;
 
 	local_irq_save(flags);
-	nc = &__get_cpu_var(netdev_alloc_cache);
+	nc = this_cpu_ptr(&netdev_alloc_cache);
 	if (unlikely(!nc->frag.page)) {
 refill:
 		for (order = NETDEV_FRAG_PAGE_MAX_ORDER; ;) {
Index: linux/net/ipv4/tcp_output.c
===================================================================
--- linux.orig/net/ipv4/tcp_output.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/net/ipv4/tcp_output.c	2013-08-22 15:01:55.539964397 -0500
@@ -810,7 +810,7 @@ void tcp_wfree(struct sk_buff *skb)
 
 		/* queue this socket to tasklet queue */
 		local_irq_save(flags);
-		tsq = &__get_cpu_var(tsq_tasklet);
+		tsq = this_cpu_ptr(&tsq_tasklet);
 		list_add(&tp->tsq_node, &tsq->head);
 		tasklet_schedule(&tsq->tasklet);
 		local_irq_restore(flags);
Index: linux/net/rds/ib_rdma.c
===================================================================
--- linux.orig/net/rds/ib_rdma.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/net/rds/ib_rdma.c	2013-08-22 15:01:55.539964397 -0500
@@ -267,7 +267,7 @@ static inline struct rds_ib_mr *rds_ib_r
 	unsigned long *flag;
 
 	preempt_disable();
-	flag = &__get_cpu_var(clean_list_grace);
+	flag = this_cpu_ptr(&clean_list_grace);
 	set_bit(CLEAN_LIST_BUSY_BIT, flag);
 	ret = llist_del_first(&pool->clean_list);
 	if (ret)
Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/timer.c	2013-08-22 15:01:55.539964397 -0500
@@ -621,7 +621,7 @@ static inline void debug_assert_init(str
 static void do_init_timer(struct timer_list *timer, unsigned int flags,
 			  const char *name, struct lock_class_key *key)
 {
-	struct tvec_base *base = __raw_get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 
 	timer->entry.next = NULL;
 	timer->base = (void *)((unsigned long)base | flags);
Index: linux/kernel/trace/trace.c
===================================================================
--- linux.orig/kernel/trace/trace.c	2013-08-22 15:01:55.543964358 -0500
+++ linux/kernel/trace/trace.c	2013-08-22 15:01:55.539964397 -0500
@@ -1676,7 +1676,7 @@ static void __ftrace_trace_stack(struct
 	 */
 	barrier();
 	if (use_stack == 1) {
-		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
 		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
 
 		if (regs)

