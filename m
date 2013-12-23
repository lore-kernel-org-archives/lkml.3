Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3LWWuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:50:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:42985 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3LWWuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 17:50:19 -0500
Date: Mon, 23 Dec 2013 23:50:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20131223225017.GA8623@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.6-rt9 patch set.

Changes since v3.12.6-rt8
- ARM's mach-sti is now using rawlock as boot_lock (like the other
  mach-*)
- There was a callpath to rcu_preempt_qs() with interrupts enabled. Tiejun
  Chen posted a patch to call it with interrupt disabled like we always
  do.
- A patch from Paul E. McKenney to not activate RCU core on NO_HZ_FULL
  CPUs
- A patch from Thomas Gleixner not to raise the timer softirq
  unconditionally (only if a timer is pending)


There is also a patch in the queue from Paul E. McKenney to move RCU
processing from softirq into its own thread. After Mike Galbraith
reported a few RCU stalls I decided to keep it disabled for now until I
have some time to look at it.

Known issues:

      - bcache is disabled.

      - Brian Silverman reported a BUG (via Debian BTS) where gdb's
        record command does something nasty and causes a double fault on
        x86-64 kernel with 32bit userland (the debugged application).
        32bit and 64bit setup are not kernels are not affected. The
        problem is limited is limited to x86.

      - Sami Pietikäinen reported a crash in __ip_make_skb(). Nicholas
        Mc Guire is preparing a patch for it.

The delta patch against v3.12.6-rt8 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.6-rt8-rt9.patch.xz

The RT patch against 3.12.6 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.6-rt9.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.6-rt9.tar.xz

Sebastian

diff --git a/arch/arm/mach-sti/platsmp.c b/arch/arm/mach-sti/platsmp.c
index dce50d9..c05b764 100644
--- a/arch/arm/mach-sti/platsmp.c
+++ b/arch/arm/mach-sti/platsmp.c
@@ -35,7 +35,7 @@ static void write_pen_release(int val)
 	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
 }
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 void sti_secondary_init(unsigned int cpu)
 {
@@ -50,8 +50,8 @@ void sti_secondary_init(unsigned int cpu)
 	/*
 	 * Synchronise with the boot thread.
 	 */
-	spin_lock(&boot_lock);
-	spin_unlock(&boot_lock);
+	raw_spin_lock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 }
 
 int sti_boot_secondary(unsigned int cpu, struct task_struct *idle)
@@ -62,7 +62,7 @@ int sti_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 * set synchronisation state between this boot processor
 	 * and the secondary one
 	 */
-	spin_lock(&boot_lock);
+	raw_spin_lock(&boot_lock);
 
 	/*
 	 * The secondary processor is waiting to be released from
@@ -93,7 +93,7 @@ int sti_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
 	 */
-	spin_unlock(&boot_lock);
+	raw_spin_unlock(&boot_lock);
 
 	return pen_release != -1 ? -ENOSYS : 0;
 }
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 79a7a35..bdbf77db 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -461,9 +461,8 @@ extern int schedule_hrtimeout_range_clock(ktime_t *expires,
 		unsigned long delta, const enum hrtimer_mode mode, int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
-/* Soft interrupt function to run the hrtimer queues: */
+/* Called from the periodic timer tick */
 extern void hrtimer_run_queues(void);
-extern void hrtimer_run_pending(void);
 
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index c383841..7aa442e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1694,30 +1694,6 @@ static void run_hrtimer_softirq(struct softirq_action *h)
 }
 
 /*
- * Called from timer softirq every jiffy, expire hrtimers:
- *
- * For HRT its the fall back code to run the softirq in the timer
- * softirq context in case the hrtimer initialization failed or has
- * not been done yet.
- */
-void hrtimer_run_pending(void)
-{
-	if (hrtimer_hres_active())
-		return;
-
-	/*
-	 * This _is_ ugly: We have to check in the softirq context,
-	 * whether we can switch to highres and / or nohz mode. The
-	 * clocksource switch happens in the timer interrupt with
-	 * xtime_lock held. Notification from there only sets the
-	 * check bit in the tick_oneshot code, otherwise we might
-	 * deadlock vs. xtime_lock.
-	 */
-	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
-		hrtimer_switch_to_hres();
-}
-
-/*
  * Called from hardirq context every jiffy
  */
 void hrtimer_run_queues(void)
@@ -1730,6 +1706,13 @@ void hrtimer_run_queues(void)
 	if (hrtimer_hres_active())
 		return;
 
+	/*
+	 * Check whether we can switch to highres mode.
+	 */
+	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled())
+	    && hrtimer_switch_to_hres())
+		return;
+
 	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
 		base = &cpu_base->clock_base[index];
 		if (!timerqueue_getnext(&base->active))
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 10365be..f4f61bb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -204,7 +204,12 @@ static void rcu_preempt_qs(int cpu);
 
 void rcu_bh_qs(int cpu)
 {
+	unsigned long flags;
+
+	/* Callers to this function, rcu_preempt_qs(), must disable irqs. */
+	local_irq_save(flags);
 	rcu_preempt_qs(cpu);
+	local_irq_restore(flags);
 }
 #else
 void rcu_bh_qs(int cpu)
@@ -2674,6 +2679,10 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rsp, rdp);
 
+	/* Is this CPU a NO_HZ_FULL CPU that should ignore RCU? */
+	if (rcu_nohz_full_cpu(rsp))
+		return 0;
+
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c36d59a..eb4fe67 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -563,6 +563,7 @@ static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj);
 static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 05bcc6f..c1735a1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2801,3 +2801,23 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 }
 
 #endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+/*
+ * Is this CPU a NO_HZ_FULL CPU that should ignore RCU so that the
+ * grace-period kthread will do force_quiescent_state() processing?
+ * The idea is to avoid waking up RCU core processing on such a
+ * CPU unless the grace period has extended for too long.
+ *
+ * This code relies on the fact that all NO_HZ_FULL CPUs are also
+ * CONFIG_RCU_NOCB_CPUs.
+ */
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (!rcu_gp_in_progress(rsp) ||
+	     ULONG_CMP_LT(jiffies, ACCESS_ONCE(rsp->gp_start) + HZ)))
+		return 1;
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+	return 0;
+}
diff --git a/kernel/timer.c b/kernel/timer.c
index b06c647..46467be 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1443,8 +1443,6 @@ static void run_timer_softirq(struct softirq_action *h)
 	irq_work_run();
 #endif
 
-	hrtimer_run_pending();
-
 	if (time_after_eq(jiffies, base->timer_jiffies))
 		__run_timers(base);
 }
@@ -1454,8 +1452,27 @@ static void run_timer_softirq(struct softirq_action *h)
  */
 void run_local_timers(void)
 {
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
+
 	hrtimer_run_queues();
-	raise_softirq(TIMER_SOFTIRQ);
+	/*
+	 * We can access this lockless as we are in the timer
+	 * interrupt. If there are no timers queued, nothing to do in
+	 * the timer softirq.
+	 */
+	if (!spin_do_trylock(&base->lock)) {
+		raise_softirq(TIMER_SOFTIRQ);
+		return;
+	}
+	if (!base->active_timers)
+		goto out;
+
+	/* Check whether the next pending timer has expired */
+	if (time_before_eq(base->next_timer, jiffies))
+		raise_softirq(TIMER_SOFTIRQ);
+out:
+	rt_spin_unlock_after_trylock_in_irq(&base->lock);
+
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
diff --git a/localversion-rt b/localversion-rt
index 700c857..22746d6 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt8
+-rt9
