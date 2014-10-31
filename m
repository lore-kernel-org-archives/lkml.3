Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbaJaQBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:01:42 -0400
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:44752 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497AbaJaQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:01:40 -0400
Date: Fri, 31 Oct 2014 11:01:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [NOHZ] Remove scheduler_tick_max_deferment
Message-ID: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reasoning behind this function is not clear to me and removal seems
to have a limited impact on the system overall. Even without the
cap to 1 second the system will be limited by the boundaries on the period
of interrupts by various devices (in my case I ended up with a 4 second
interval on x86 because of the limitations of periodicy of the underlying
interupt source).

Moreover this artificial limits the impact the benefit that commit
commit 7cc36bbddde5cd0c98f0c06e3304ab833d662565 (on-demand vmstat workers)
should be giving us.

Without this patch timer interrupts will still occur in 1 second intervals
but no vmstat kworker will run. On a processor where all other
events have been redirected to other processors nothing will be
going on just timer interrupts that do not do much.

With this patch the maximum deferrability of other items will become
evident and work can then proceed on eliminating those (like the 4
second limit that I encountered due to the timing limitations of
the underlying hardware)

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -2174,7 +2174,6 @@ static inline void wake_up_nohz_cpu(int

 #ifdef CONFIG_NO_HZ_FULL
 extern bool sched_can_stop_tick(void);
-extern u64 scheduler_tick_max_deferment(void);
 #else
 static inline bool sched_can_stop_tick(void) { return false; }
 #endif
Index: linux/kernel/sched/core.c
===================================================================
--- linux.orig/kernel/sched/core.c
+++ linux/kernel/sched/core.c
@@ -2573,34 +2573,6 @@ void scheduler_tick(void)
 	rq_last_tick_reset(rq);
 }

-#ifdef CONFIG_NO_HZ_FULL
-/**
- * scheduler_tick_max_deferment
- *
- * Keep at least one tick per second when a single
- * active task is running because the scheduler doesn't
- * yet completely support full dynticks environment.
- *
- * This makes sure that uptime, CFS vruntime, load
- * balancing, etc... continue to move forward, even
- * with a very low granularity.
- *
- * Return: Maximum deferment in nanoseconds.
- */
-u64 scheduler_tick_max_deferment(void)
-{
-	struct rq *rq = this_rq();
-	unsigned long next, now = ACCESS_ONCE(jiffies);
-
-	next = rq->last_sched_tick + HZ;
-
-	if (time_before_eq(next, now))
-		return 0;
-
-	return jiffies_to_nsecs(next - now);
-}
-#endif
-
 notrace unsigned long get_parent_ip(unsigned long addr)
 {
 	if (in_lock_functions(addr)) {
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -632,13 +632,6 @@ static ktime_t tick_nohz_stop_sched_tick
 			time_delta = KTIME_MAX;
 		}

-#ifdef CONFIG_NO_HZ_FULL
-		if (!ts->inidle) {
-			time_delta = min(time_delta,
-					 scheduler_tick_max_deferment());
-		}
-#endif
-
 		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer. delta_jiffies >= NEXT_TIMER_MAX_DELTA signals
