Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaBNU3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:29:36 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:52766 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbaBNUTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:51 -0500
Message-Id: <20140214201906.012489314@linux.com>
Date: Fri, 14 Feb 2014 14:19:01 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 20/48] time: Replace __get_cpu_var uses
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_time
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch depends on another patch in this series that introduces raw_cpu_ops]

Convert uses of __get_cpu_var for creating a address from a percpu
offset to this_cpu_ptr.

The two cases where get_cpu_var is used to actually access a percpu
variable are changed to use this_cpu_read/raw_cpu_read.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/hrtimer.c	2014-02-03 13:22:35.576033413 -0600
@@ -598,7 +598,7 @@
 static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
 	int res;
 
@@ -681,7 +681,7 @@
  */
 static void retrigger_next_event(void *arg)
 {
-	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *base = this_cpu_ptr(&hrtimer_bases);
 
 	if (!hrtimer_hres_active())
 		return;
@@ -955,7 +955,7 @@
 		 */
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
-		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
+		reprogram = base->cpu_base == this_cpu_ptr(&hrtimer_bases);
 		/*
 		 * We must preserve the CALLBACK state flag here,
 		 * otherwise we could move the timer base in
@@ -1010,7 +1010,7 @@
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
+	if (leftmost && new_base->cpu_base == this_cpu_ptr(&hrtimer_bases)
 		&& hrtimer_enqueue_reprogram(timer, new_base)) {
 		if (wakeup) {
 			/*
@@ -1143,7 +1143,7 @@
  */
 ktime_t hrtimer_get_next_event(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
 	unsigned long flags;
@@ -1184,7 +1184,7 @@
 
 	memset(timer, 0, sizeof(struct hrtimer));
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = raw_cpu_ptr(&hrtimer_bases);
 
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
@@ -1227,7 +1227,7 @@
 	struct hrtimer_cpu_base *cpu_base;
 	int base = hrtimer_clockid_to_base(which_clock);
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = raw_cpu_ptr(&hrtimer_bases);
 	*tp = ktime_to_timespec(cpu_base->clock_base[base].resolution);
 
 	return 0;
@@ -1282,7 +1282,7 @@
  */
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
 
@@ -1416,7 +1416,7 @@
 	if (!hrtimer_hres_active())
 		return;
 
-	td = &__get_cpu_var(tick_cpu_device);
+	td = this_cpu_ptr(&tick_cpu_device);
 	if (td && td->evtdev)
 		hrtimer_interrupt(td->evtdev);
 }
@@ -1480,7 +1480,7 @@
 void hrtimer_run_queues(void)
 {
 	struct timerqueue_node *node;
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	int index, gettime = 1;
 
@@ -1718,7 +1718,7 @@
 
 	local_irq_disable();
 	old_base = &per_cpu(hrtimer_bases, scpu);
-	new_base = &__get_cpu_var(hrtimer_bases);
+	new_base = this_cpu_ptr(&hrtimer_bases);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
Index: linux/kernel/irq_work.c
===================================================================
--- linux.orig/kernel/irq_work.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/irq_work.c	2014-02-03 13:22:35.576033413 -0600
@@ -70,7 +70,7 @@
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+	llist_add(&work->llnode, this_cpu_ptr(&irq_work_list));
 
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
@@ -90,7 +90,7 @@
 {
 	struct llist_head *this_list;
 
-	this_list = &__get_cpu_var(irq_work_list);
+	this_list = this_cpu_ptr(&irq_work_list);
 	if (llist_empty(this_list))
 		return false;
 
@@ -115,7 +115,7 @@
 	__this_cpu_write(irq_work_raised, 0);
 	barrier();
 
-	this_list = &__get_cpu_var(irq_work_list);
+	this_list = this_cpu_ptr(&irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
Index: linux/kernel/sched/clock.c
===================================================================
--- linux.orig/kernel/sched/clock.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/sched/clock.c	2014-02-03 13:22:35.576033413 -0600
@@ -133,7 +133,7 @@
 
 static inline struct sched_clock_data *this_scd(void)
 {
-	return &__get_cpu_var(sched_clock_data);
+	return this_cpu_ptr(&sched_clock_data);
 }
 
 static inline struct sched_clock_data *cpu_sdc(int cpu)
Index: linux/kernel/softirq.c
===================================================================
--- linux.orig/kernel/softirq.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/softirq.c	2014-02-03 13:22:35.586033208 -0600
@@ -486,7 +486,7 @@
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_vec.head);
 	__this_cpu_write(tasklet_vec.head, NULL);
-	__this_cpu_write(tasklet_vec.tail, &__get_cpu_var(tasklet_vec).head);
+	__this_cpu_write(tasklet_vec.tail, this_cpu_ptr(&tasklet_vec.head));
 	local_irq_enable();
 
 	while (list) {
@@ -522,7 +522,7 @@
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_hi_vec.head);
 	__this_cpu_write(tasklet_hi_vec.head, NULL);
-	__this_cpu_write(tasklet_hi_vec.tail, &__get_cpu_var(tasklet_hi_vec).head);
+	__this_cpu_write(tasklet_hi_vec.tail, this_cpu_ptr(&tasklet_hi_vec.head));
 	local_irq_enable();
 
 	while (list) {
Index: linux/kernel/time/tick-common.c
===================================================================
--- linux.orig/kernel/time/tick-common.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/time/tick-common.c	2014-02-03 13:22:35.586033208 -0600
@@ -224,7 +224,7 @@
 
 void tick_install_replacement(struct clock_event_device *newdev)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
@@ -374,14 +374,14 @@
 
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
--- linux.orig/kernel/time/tick-oneshot.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/time/tick-oneshot.c	2014-02-03 13:22:35.586033208 -0600
@@ -59,7 +59,7 @@
  */
 int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/time/tick-sched.c	2014-02-03 13:22:35.586033208 -0600
@@ -201,7 +201,7 @@
  */
 void __tick_nohz_full_check(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (tick_nohz_full_cpu(smp_processor_id())) {
 		if (ts->tick_stopped && !is_idle_task(current)) {
@@ -227,7 +227,7 @@
 void tick_nohz_full_kick(void)
 {
 	if (tick_nohz_full_cpu(smp_processor_id()))
-		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+		irq_work_queue(this_cpu_ptr(&nohz_full_kick_work));
 }
 
 static void nohz_full_kick_ipi(void *info)
@@ -530,7 +530,7 @@
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	unsigned long rcu_delta_jiffies;
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 	u64 time_delta;
 
 	time_delta = timekeeping_max_deferment();
@@ -798,7 +798,7 @@
 
 	local_irq_disable();
 
-	ts = &__get_cpu_var(tick_cpu_sched);
+	ts = this_cpu_ptr(&tick_cpu_sched);
 	ts->inidle = 1;
 	__tick_nohz_idle_enter(ts);
 
@@ -816,7 +816,7 @@
  */
 void tick_nohz_irq_exit(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (ts->inidle)
 		__tick_nohz_idle_enter(ts);
@@ -831,7 +831,7 @@
  */
 ktime_t tick_nohz_get_sleep_length(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	return ts->sleep_length;
 }
@@ -944,7 +944,7 @@
  */
 static void tick_nohz_handler(struct clock_event_device *dev)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
@@ -964,7 +964,7 @@
  */
 static void tick_nohz_switch_to_nohz(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t next;
 
 	if (!tick_nohz_active)
@@ -1100,7 +1100,7 @@
  */
 void tick_setup_sched_timer(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now = ktime_get();
 
 	/*
@@ -1169,7 +1169,7 @@
  */
 void tick_oneshot_notify(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	set_bit(0, &ts->check_clocks);
 }
@@ -1184,7 +1184,7 @@
  */
 int tick_check_oneshot_change(int allow_nohz)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (!test_and_clear_bit(0, &ts->check_clocks))
 		return 0;
Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/kernel/timer.c	2014-02-03 13:22:35.586033208 -0600
@@ -621,7 +621,7 @@
 static void do_init_timer(struct timer_list *timer, unsigned int flags,
 			  const char *name, struct lock_class_key *key)
 {
-	struct tvec_base *base = __raw_get_cpu_var(tvec_bases);
+	struct tvec_base *base = raw_cpu_read(tvec_bases);
 
 	timer->entry.next = NULL;
 	timer->base = (void *)((unsigned long)base | flags);
Index: linux/drivers/clocksource/dummy_timer.c
===================================================================
--- linux.orig/drivers/clocksource/dummy_timer.c	2014-02-03 13:22:35.586033208 -0600
+++ linux/drivers/clocksource/dummy_timer.c	2014-02-03 13:22:35.586033208 -0600
@@ -28,7 +28,7 @@
 static void dummy_timer_setup(void)
 {
 	int cpu = smp_processor_id();
-	struct clock_event_device *evt = __this_cpu_ptr(&dummy_timer_evt);
+	struct clock_event_device *evt = raw_cpu_ptr(&dummy_timer_evt);
 
 	evt->name	= "dummy_timer";
 	evt->features	= CLOCK_EVT_FEAT_PERIODIC |

