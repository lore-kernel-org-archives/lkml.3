Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaHQRaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:30:55 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:32964
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbaHQRak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:30:40 -0400
Message-Id: <20140817173033.239275691@linux.com>
Date: Sun, 17 Aug 2014 12:30:25 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/35] [PATCH 03/36] time: Replace __get_cpu_var uses
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-time-Replace-__get_cpu_var-uses.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert uses of __get_cpu_var for creating a address from a percpu
offset to this_cpu_ptr.

The two cases where get_cpu_var is used to actually access a percpu
variable are changed to use this_cpu_read/raw_cpu_read.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 drivers/clocksource/dummy_timer.c |  2 +-
 kernel/hrtimer.c                  | 22 +++++++++++-----------
 kernel/irq_work.c                 |  6 +++---
 kernel/sched/clock.c              |  2 +-
 kernel/softirq.c                  |  4 ++--
 kernel/time/tick-broadcast.c      |  2 +-
 kernel/time/tick-common.c         |  6 +++---
 kernel/time/tick-oneshot.c        |  2 +-
 kernel/time/tick-sched.c          | 22 +++++++++++-----------
 kernel/timer.c                    |  2 +-
 10 files changed, 35 insertions(+), 35 deletions(-)

Index: linux/drivers/clocksource/dummy_timer.c
===================================================================
--- linux.orig/drivers/clocksource/dummy_timer.c
+++ linux/drivers/clocksource/dummy_timer.c
@@ -28,7 +28,7 @@ static void dummy_timer_set_mode(enum cl
 static void dummy_timer_setup(void)
 {
 	int cpu = smp_processor_id();
-	struct clock_event_device *evt = __this_cpu_ptr(&dummy_timer_evt);
+	struct clock_event_device *evt = raw_cpu_ptr(&dummy_timer_evt);
 
 	evt->name	= "dummy_timer";
 	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
Index: linux/kernel/irq_work.c
===================================================================
--- linux.orig/kernel/irq_work.c
+++ linux/kernel/irq_work.c
@@ -95,11 +95,11 @@ bool irq_work_queue(struct irq_work *wor
 
 	/* If the work is "lazy", handle it from next tick if any */
 	if (work->flags & IRQ_WORK_LAZY) {
-		if (llist_add(&work->llnode, &__get_cpu_var(lazy_list)) &&
+		if (llist_add(&work->llnode, this_cpu_ptr(&lazy_list)) &&
 		    tick_nohz_tick_stopped())
 			arch_irq_work_raise();
 	} else {
-		if (llist_add(&work->llnode, &__get_cpu_var(raised_list)))
+		if (llist_add(&work->llnode, this_cpu_ptr(&raised_list)))
 			arch_irq_work_raise();
 	}
 
@@ -113,8 +113,8 @@ bool irq_work_needs_cpu(void)
 {
 	struct llist_head *raised, *lazy;
 
-	raised = &__get_cpu_var(raised_list);
-	lazy = &__get_cpu_var(lazy_list);
+	raised = this_cpu_ptr(&raised_list);
+	lazy = this_cpu_ptr(&lazy_list);
 	if (llist_empty(raised) && llist_empty(lazy))
 		return false;
 
@@ -166,8 +166,8 @@ static void irq_work_run_list(struct lli
  */
 void irq_work_run(void)
 {
-	irq_work_run_list(&__get_cpu_var(raised_list));
-	irq_work_run_list(&__get_cpu_var(lazy_list));
+	irq_work_run_list(this_cpu_ptr(&raised_list));
+	irq_work_run_list(this_cpu_ptr(&lazy_list));
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
Index: linux/kernel/sched/clock.c
===================================================================
--- linux.orig/kernel/sched/clock.c
+++ linux/kernel/sched/clock.c
@@ -134,7 +134,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(str
 
 static inline struct sched_clock_data *this_scd(void)
 {
-	return &__get_cpu_var(sched_clock_data);
+	return this_cpu_ptr(&sched_clock_data);
 }
 
 static inline struct sched_clock_data *cpu_sdc(int cpu)
Index: linux/kernel/softirq.c
===================================================================
--- linux.orig/kernel/softirq.c
+++ linux/kernel/softirq.c
@@ -485,7 +485,7 @@ static void tasklet_action(struct softir
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_vec.head);
 	__this_cpu_write(tasklet_vec.head, NULL);
-	__this_cpu_write(tasklet_vec.tail, &__get_cpu_var(tasklet_vec).head);
+	__this_cpu_write(tasklet_vec.tail, this_cpu_ptr(&tasklet_vec.head));
 	local_irq_enable();
 
 	while (list) {
@@ -521,7 +521,7 @@ static void tasklet_hi_action(struct sof
 	local_irq_disable();
 	list = __this_cpu_read(tasklet_hi_vec.head);
 	__this_cpu_write(tasklet_hi_vec.head, NULL);
-	__this_cpu_write(tasklet_hi_vec.tail, &__get_cpu_var(tasklet_hi_vec).head);
+	__this_cpu_write(tasklet_hi_vec.tail, this_cpu_ptr(&tasklet_hi_vec.head));
 	local_irq_enable();
 
 	while (list) {
Index: linux/kernel/time/tick-broadcast.c
===================================================================
--- linux.orig/kernel/time/tick-broadcast.c
+++ linux/kernel/time/tick-broadcast.c
@@ -554,7 +554,7 @@ int tick_resume_broadcast_oneshot(struct
 void tick_check_oneshot_broadcast_this_cpu(void)
 {
 	if (cpumask_test_cpu(smp_processor_id(), tick_broadcast_oneshot_mask)) {
-		struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+		struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 
 		/*
 		 * We might be in the middle of switching over from
Index: linux/kernel/time/tick-common.c
===================================================================
--- linux.orig/kernel/time/tick-common.c
+++ linux/kernel/time/tick-common.c
@@ -224,7 +224,7 @@ static void tick_setup_device(struct tic
 
 void tick_install_replacement(struct clock_event_device *newdev)
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	int cpu = smp_processor_id();
 
 	clockevents_exchange_device(td->evtdev, newdev);
@@ -374,14 +374,14 @@ void tick_shutdown(unsigned int *cpup)
 
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
--- linux.orig/kernel/time/tick-oneshot.c
+++ linux/kernel/time/tick-oneshot.c
@@ -59,7 +59,7 @@ void tick_setup_oneshot(struct clock_eve
  */
 int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *))
 {
-	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -205,7 +205,7 @@ static void tick_nohz_restart_sched_tick
  */
 void __tick_nohz_full_check(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (tick_nohz_full_cpu(smp_processor_id())) {
 		if (ts->tick_stopped && !is_idle_task(current)) {
@@ -545,7 +545,7 @@ static ktime_t tick_nohz_stop_sched_tick
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires, ret = { .tv64 = 0 };
 	unsigned long rcu_delta_jiffies;
-	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 	u64 time_delta;
 
 	time_delta = timekeeping_max_deferment();
@@ -813,7 +813,7 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_disable();
 
-	ts = &__get_cpu_var(tick_cpu_sched);
+	ts = this_cpu_ptr(&tick_cpu_sched);
 	ts->inidle = 1;
 	__tick_nohz_idle_enter(ts);
 
@@ -831,7 +831,7 @@ EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
  */
 void tick_nohz_irq_exit(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (ts->inidle)
 		__tick_nohz_idle_enter(ts);
@@ -846,7 +846,7 @@ void tick_nohz_irq_exit(void)
  */
 ktime_t tick_nohz_get_sleep_length(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	return ts->sleep_length;
 }
@@ -959,7 +959,7 @@ static int tick_nohz_reprogram(struct ti
  */
 static void tick_nohz_handler(struct clock_event_device *dev)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
@@ -979,7 +979,7 @@ static void tick_nohz_handler(struct clo
  */
 static void tick_nohz_switch_to_nohz(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t next;
 
 	if (!tick_nohz_enabled)
@@ -1115,7 +1115,7 @@ early_param("skew_tick", skew_tick);
  */
 void tick_setup_sched_timer(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 	ktime_t now = ktime_get();
 
 	/*
@@ -1184,7 +1184,7 @@ void tick_clock_notify(void)
  */
 void tick_oneshot_notify(void)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	set_bit(0, &ts->check_clocks);
 }
@@ -1199,7 +1199,7 @@ void tick_oneshot_notify(void)
  */
 int tick_check_oneshot_change(int allow_nohz)
 {
-	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	if (!test_and_clear_bit(0, &ts->check_clocks))
 		return 0;
Index: linux/kernel/time/hrtimer.c
===================================================================
--- linux.orig/kernel/time/hrtimer.c
+++ linux/kernel/time/hrtimer.c
@@ -1144,7 +1144,7 @@ static void __hrtimer_init(struct hrtime
 
 	memset(timer, 0, sizeof(struct hrtimer));
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = raw_cpu_ptr(&hrtimer_bases);
 
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
@@ -1187,7 +1187,7 @@ int hrtimer_get_res(const clockid_t whic
 	struct hrtimer_cpu_base *cpu_base;
 	int base = hrtimer_clockid_to_base(which_clock);
 
-	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
+	cpu_base = raw_cpu_ptr(&hrtimer_bases);
 	*tp = ktime_to_timespec(cpu_base->clock_base[base].resolution);
 
 	return 0;
@@ -1376,7 +1376,7 @@ static void __hrtimer_peek_ahead_timers(
 	if (!hrtimer_hres_active())
 		return;
 
-	td = &__get_cpu_var(tick_cpu_device);
+	td = this_cpu_ptr(&tick_cpu_device);
 	if (td && td->evtdev)
 		hrtimer_interrupt(td->evtdev);
 }
Index: linux/kernel/time/timer.c
===================================================================
--- linux.orig/kernel/time/timer.c
+++ linux/kernel/time/timer.c
@@ -655,7 +655,7 @@ static inline void debug_assert_init(str
 static void do_init_timer(struct timer_list *timer, unsigned int flags,
 			  const char *name, struct lock_class_key *key)
 {
-	struct tvec_base *base = __raw_get_cpu_var(tvec_bases);
+	struct tvec_base *base = raw_cpu_read(tvec_bases);
 
 	timer->entry.next = NULL;
 	timer->base = (void *)((unsigned long)base | flags);

