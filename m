Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaIPC7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:59:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51129 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaIPC7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:59:40 -0400
From: Joonwoo Park <joonwoop@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Joonwoo Park <joonwoop@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 RESEND/RFC] timer: make deferrable cpu unbound timers really not bound to a cpu
Date: Mon, 15 Sep 2014 19:59:36 -0700
Message-Id: <1410836376-27267-1-git-send-email-joonwoop@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a deferrable work (INIT_DEFERRABLE_WORK, etc.) is queued via
queue_delayed_work() it's probably intended to run the work item on any
CPU that isn't idle. However, we queue the work to run at a later time
by starting a deferrable timer that binds to whatever CPU the work is
queued on which is same with queue_delayed_work_on(smp_processor_id())
effectively.

As a result WORK_CPU_UNBOUND work items aren't really cpu unbound now.
In fact this is perfectly fine with UP kernel and also won't affect much a
system without dyntick with SMP kernel too as every cpus run timers
periodically.  But on SMP systems with dyntick current implementation leads
deferrable timers not very scalable because the timer's base which has
queued the deferrable timer won't wake up till next non-deferrable timer
expires even though there are possible other non idle cpus are running
which are able to run expired deferrable timers.

The deferrable work is a good example of the current implementation's
victim like below.

INIT_DEFERRABLE_WORK(&dwork, fn);
CPU 0                                 CPU 1
queue_delayed_work(wq, &dwork, HZ);
    queue_delayed_work_on(WORK_CPU_UNBOUND);
        ...
	__mod_timer() -> queues timer to the
			 current cpu's timer
			 base.
	...
tick_nohz_idle_enter() -> cpu enters idle.
A second later
cpu 0 is now in idle.                 cpu 1 exits idle or wasn't in idle so
                                      now it's in active but won't
cpu 0 won't wake up till next         handle cpu unbound deferrable timer
non-deferrable timer expires.         as it's in cpu 0's timer base.

To make all cpu unbound deferrable timers are scalable, introduce a common
timer base which is only for cpu unbound deferrable timers to make those
are indeed cpu unbound so that can be scheduled by any of non idle cpus.
This common timer fixes scalability issue of delayed work and all other cpu
unbound deferrable timer using implementations.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Joonwoo Park <joonwoop@codeaurora.org>
---
 Changes in v2:
 * Use kzalloc_node()/kzalloc()

 kernel/time/timer.c | 106 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 80 insertions(+), 26 deletions(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index aca5dfe..5313cb0 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -93,6 +93,9 @@ struct tvec_base {
 struct tvec_base boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
 static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
+#ifdef CONFIG_SMP
+static struct tvec_base *tvec_base_deferral = &boot_tvec_bases;
+#endif
 
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
@@ -655,7 +658,14 @@ static inline void debug_assert_init(struct timer_list *timer)
 static void do_init_timer(struct timer_list *timer, unsigned int flags,
 			  const char *name, struct lock_class_key *key)
 {
-	struct tvec_base *base = __raw_get_cpu_var(tvec_bases);
+	struct tvec_base *base;
+
+#ifdef CONFIG_SMP
+	if (flags & TIMER_DEFERRABLE)
+		base = tvec_base_deferral;
+	else
+#endif
+		base = __raw_get_cpu_var(tvec_bases);
 
 	timer->entry.next = NULL;
 	timer->base = (void *)((unsigned long)base | flags);
@@ -777,26 +787,32 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	cpu = get_nohz_timer_target(pinned);
-	new_base = per_cpu(tvec_bases, cpu);
+#ifdef CONFIG_SMP
+	if (base != tvec_base_deferral) {
+#endif
+		cpu = get_nohz_timer_target(pinned);
+		new_base = per_cpu(tvec_bases, cpu);
 
-	if (base != new_base) {
-		/*
-		 * We are trying to schedule the timer on the local CPU.
-		 * However we can't change timer's base while it is running,
-		 * otherwise del_timer_sync() can't detect that the timer's
-		 * handler yet has not finished. This also guarantees that
-		 * the timer is serialized wrt itself.
-		 */
-		if (likely(base->running_timer != timer)) {
-			/* See the comment in lock_timer_base() */
-			timer_set_base(timer, NULL);
-			spin_unlock(&base->lock);
-			base = new_base;
-			spin_lock(&base->lock);
-			timer_set_base(timer, base);
+		if (base != new_base) {
+			/*
+			 * We are trying to schedule the timer on the local CPU.
+			 * However we can't change timer's base while it is
+			 * running, otherwise del_timer_sync() can't detect that
+			 * the timer's handler yet has not finished. This also
+			 * guarantees that the timer is serialized wrt itself.
+			 */
+			if (likely(base->running_timer != timer)) {
+				/* See the comment in lock_timer_base() */
+				timer_set_base(timer, NULL);
+				spin_unlock(&base->lock);
+				base = new_base;
+				spin_lock(&base->lock);
+				timer_set_base(timer, base);
+			}
 		}
+#ifdef CONFIG_SMP
 	}
+#endif
 
 	timer->expires = expires;
 	internal_add_timer(base, timer);
@@ -1161,15 +1177,20 @@ static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 /**
  * __run_timers - run all expired timers (if any) on this CPU.
  * @base: the timer vector to be processed.
+ * @try: try and just return if base's lock already acquired.
  *
  * This function cascades all vectors and executes all expired timer
  * vectors.
  */
-static inline void __run_timers(struct tvec_base *base)
+static inline void __run_timers(struct tvec_base *base, bool try)
 {
 	struct timer_list *timer;
 
-	spin_lock_irq(&base->lock);
+	if (!try)
+		spin_lock_irq(&base->lock);
+	else if (!spin_trylock_irq(&base->lock))
+		return;
+
 	if (catchup_timer_jiffies(base)) {
 		spin_unlock_irq(&base->lock);
 		return;
@@ -1400,8 +1421,17 @@ static void run_timer_softirq(struct softirq_action *h)
 
 	hrtimer_run_pending();
 
+#ifdef CONFIG_SMP
+	if (time_after_eq(jiffies, tvec_base_deferral->timer_jiffies))
+		/*
+		 * if other cpu is handling cpu unbound deferrable timer base,
+		 * current cpu doesn't need to handle it so pass try=true.
+		 */
+		__run_timers(tvec_base_deferral, true);
+#endif
+
 	if (time_after_eq(jiffies, base->timer_jiffies))
-		__run_timers(base);
+		__run_timers(base, false);
 }
 
 /*
@@ -1537,7 +1567,7 @@ static int init_timers_cpu(int cpu)
 {
 	int j;
 	struct tvec_base *base;
-	static char tvec_base_done[NR_CPUS];
+	static char tvec_base_done[NR_CPUS + 1];
 
 	if (!tvec_base_done[cpu]) {
 		static char boot_done;
@@ -1546,8 +1576,12 @@ static int init_timers_cpu(int cpu)
 			/*
 			 * The APs use this path later in boot
 			 */
-			base = kzalloc_node(sizeof(*base), GFP_KERNEL,
-					    cpu_to_node(cpu));
+			if (cpu != NR_CPUS)
+				base = kzalloc_node(sizeof(*base), GFP_KERNEL,
+						    cpu_to_node(cpu));
+			else
+				base = kzalloc(sizeof(*base), GFP_KERNEL);
+
 			if (!base)
 				return -ENOMEM;
 
@@ -1556,7 +1590,13 @@ static int init_timers_cpu(int cpu)
 				kfree(base);
 				return -ENOMEM;
 			}
-			per_cpu(tvec_bases, cpu) = base;
+
+			if (cpu != NR_CPUS)
+				per_cpu(tvec_bases, cpu) = base;
+#ifdef CONFIG_SMP
+			else
+				tvec_base_deferral = base;
+#endif
 		} else {
 			/*
 			 * This is for the boot CPU - we use compile-time
@@ -1571,7 +1611,12 @@ static int init_timers_cpu(int cpu)
 		tvec_base_done[cpu] = 1;
 		base->cpu = cpu;
 	} else {
-		base = per_cpu(tvec_bases, cpu);
+		if (cpu != NR_CPUS)
+			base = per_cpu(tvec_bases, cpu);
+#ifdef CONFIG_SMP
+		else
+			base = tvec_base_deferral;
+#endif
 	}
 
 
@@ -1679,6 +1724,15 @@ void __init init_timers(void)
 			       (void *)(long)smp_processor_id());
 	BUG_ON(err != NOTIFY_OK);
 
+#ifdef CONFIG_SMP
+	/*
+	 * initialize cpu unbound deferrable timer base only when CONFIG_SMP.
+	 * UP kernel handles the timers with cpu 0 timer base.
+	 */
+	err = init_timers_cpu(NR_CPUS);
+	BUG_ON(err);
+#endif
+
 	init_timer_stats();
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

