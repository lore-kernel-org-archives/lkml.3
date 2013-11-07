Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3KGLVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:21:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:50912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3KGLVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:21:18 -0500
Date: Thu, 7 Nov 2013 12:21:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
In-Reply-To: <1383798668.5441.25.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
References: <1383228427.5272.36.camel@marge.simpson.net>  <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>  <1383794799.5441.16.camel@marge.simpson.net> <1383798668.5441.25.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Thu, 7 Nov 2013, Mike Galbraith wrote:

> On Thu, 2013-11-07 at 04:26 +0100, Mike Galbraith wrote: 
> > On Wed, 2013-11-06 at 18:49 +0100, Thomas Gleixner wrote: 
> 
> > > I bet you are trying to work around some of the side effects of the
> > > occasional tick which is still necessary despite of full nohz, right?
> > 
> > Nope, I wanted to check out cost of nohz_full for rt, and found that it
> > doesn't work at all instead, looked, and found that the sole running
> > task has just awakened ksoftirqd when it wants to shut the tick down, so
> > that shutdown never happens. 
> 
> Like so in virgin 3.10-rt.  Box is x3550 M3 booted nowatchdog
> rcu_nocbs=1-3 nohz_full=1-3, and CPUs1-3 are completely isolated via
> cpusets as well.

well, that very same problem is in mainline if you add "threadirqs" to
the command line. But we can be smart about this. The untested patch
below should address that issue. If that works on mainline we can
adapt it for RT (needs a trylock(&base->lock) there).

Though it's not a full solution. It needs some thought versus the
softirq code of timers. Assume we have only one timer queued 1000
ticks into the future. So this change will cause the timer softirq not
to be called until that timer expires and then the timer softirq is
going to do 1000 loops until it catches up with jiffies. That's
anything but pretty ...

What worries me more is this one:

  pert-5229  [003] d..h1..   684.482618: softirq_raise: vec=9 [action=RCU]

The CPU has no callbacks as you shoved them over to cpu 0, so why is
the RCU softirq raised?

Thanks,

	tglx
------------------

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d19a5c2..0816a50 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -445,9 +445,8 @@ extern int schedule_hrtimeout_range_clock(ktime_t *expires,
 		unsigned long delta, const enum hrtimer_mode mode, int clock);
 extern int schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode);
 
-/* Soft interrupt function to run the hrtimer queues: */
+/* Called from the periodic timer tick */
 extern void hrtimer_run_queues(void);
-extern void hrtimer_run_pending(void);
 
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 383319b..7359eaa 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1450,30 +1450,6 @@ static inline void __hrtimer_peek_ahead_timers(void) { }
 #endif	/* !CONFIG_HIGH_RES_TIMERS */
 
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
@@ -1486,6 +1462,13 @@ void hrtimer_run_queues(void)
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
diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13..ba8ee94 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1370,8 +1370,6 @@ static void run_timer_softirq(struct softirq_action *h)
 {
 	struct tvec_base *base = __this_cpu_read(tvec_bases);
 
-	hrtimer_run_pending();
-
 	if (time_after_eq(jiffies, base->timer_jiffies))
 		__run_timers(base);
 }
@@ -1381,8 +1379,20 @@ static void run_timer_softirq(struct softirq_action *h)
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
+	if (!base->active_timers)
+		return;
+
+	/* Check whether the next pending timer has expired */
+	if (time_before_eq(base->next_timer, jiffies))
+		raise_softirq(TIMER_SOFTIRQ);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM



