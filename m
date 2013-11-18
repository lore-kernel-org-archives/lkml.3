Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3KROKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:10:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40371 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3KROKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:10:31 -0500
Date: Mon, 18 Nov 2013 15:10:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] rtmutex: take the waiter lock with irqs off
Message-ID: <20131118141021.GA10022@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
 <1383794799.5441.16.camel@marge.simpson.net>
 <1383798668.5441.25.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
 <20131107125923.GB24644@localhost.localdomain>
 <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
 <1384243595.15180.63.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de>
 <20131115163008.GB12164@linutronix.de>
 <20131115201436.GC12164@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115201436.GC12164@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:14:36PM +0100, Sebastian Andrzej Siewior wrote:
> Mike Galbraith captered the following:
> | >#11 [ffff88017b243e90] _raw_spin_lock at ffffffff815d2596
> | >#12 [ffff88017b243e90] rt_mutex_trylock at ffffffff815d15be
> | >#13 [ffff88017b243eb0] get_next_timer_interrupt at ffffffff81063b42
> | >#14 [ffff88017b243f00] tick_nohz_stop_sched_tick at ffffffff810bd1fd
> | >#15 [ffff88017b243f70] tick_nohz_irq_exit at ffffffff810bd7d2
> | >#16 [ffff88017b243f90] irq_exit at ffffffff8105b02d
> | >#17 [ffff88017b243fb0] reschedule_interrupt at ffffffff815db3dd
> | >--- <IRQ stack> ---
> | >#18 [ffff88017a2a9bc8] reschedule_interrupt at ffffffff815db3dd
> | >    [exception RIP: task_blocks_on_rt_mutex+51]
> | >#19 [ffff88017a2a9ce0] rt_spin_lock_slowlock at ffffffff815d183c
> | >#20 [ffff88017a2a9da0] lock_timer_base.isra.35 at ffffffff81061cbf
> | >#21 [ffff88017a2a9dd0] schedule_timeout at ffffffff815cf1ce
> | >#22 [ffff88017a2a9e50] rcu_gp_kthread at ffffffff810f9bbb
> | >#23 [ffff88017a2a9ed0] kthread at ffffffff810796d5
> | >#24 [ffff88017a2a9f50] ret_from_fork at ffffffff815da04c
> 
> lock_timer_base() does a try_lock() which deadlocks on the waiter lock
> not the lock itself.
> This patch makes sure all users of the waiter_lock take the lock with
> interrupts off so a try_lock from irq context is possible.

Its get_next_timer_interrupt() that does a trylock() and only for
PREEMPT_RT_FULL.

Also; on IRC you said:

  "<bigeasy> I'm currently not sure if we should do
the _irq() lock or a trylock for the wait_lock in
rt_mutex_slowtrylock()"

Which I misread and dismissed -- but yes that might actually work too
and would be a much smaller patch. You'd only need trylock and unlock.

That said, allowing such usage from actual IRQ context is iffy; suppose
the trylock succeeds, who then is the lock owner?

I suppose it would be whatever task we interrupted and boosting will
'work' because we're non-preemptable, but still *YUCK*.


That said; the reason I looked at this is that lockdep didn't catch it.
This turns out to be because in irq_exit():

	void irq_exit(void)
	{
	#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
		local_irq_disable();
	#else
		WARN_ON_ONCE(!irqs_disabled());
	#endif

		account_irq_exit_time(current);
		trace_hardirq_exit();
		sub_preempt_count(HARDIRQ_OFFSET);
		if (!in_interrupt() && local_softirq_pending())
			invoke_softirq();

		tick_irq_exit();
		rcu_irq_exit();
	}

We call trace_hardirq_exit() before tick_irq_exit(), so lockdep doesn't
see the offending raw_spin_lock(&->wait_lock) as happening from IRQ
context.

So I tried the little hack below to try and catch it; but no luck so
far. I suppose with regular NOHZ the tick_irq_exit() condition:

	static inline void tick_irq_exit(void)
	{
	#ifdef CONFIG_NO_HZ_COMMON
		int cpu = smp_processor_id();

		/* Make sure that timer wheel updates are propagated */
		if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
			if (!in_interrupt())
				tick_nohz_irq_exit();
		}
	#endif
	}

Is rather uncommon; maybe I should let the box run for a bit; see if it
triggers.

Ugleh problem allround.

Also, I'm not sure if this patch was supposed to be an 'upstream' patch
-- $SUBJECT seems to suggest so, but note that it will not apply to
anything recent.

---


--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -746,13 +746,23 @@ void irq_exit(void)
 #endif
 
 	account_irq_exit_time(current);
-	trace_hardirq_exit();
 	sub_preempt_count(HARDIRQ_OFFSET);
-	if (!in_interrupt() && local_softirq_pending())
+	if (!in_interrupt() && local_softirq_pending()) {
+		/*
+		 * Temp. disable hardirq context so as not to confuse lockdep;
+		 * otherwise it might think we're running softirq handler from
+		 * hardirq context.
+		 *
+		 * Should probably sort this someplace else..
+		 */
+		trace_hardirq_exit();
 		invoke_softirq();
+		trace_hardirq_enter();
+	}
 
 	tick_irq_exit();
 	rcu_irq_exit();
+	trace_hardirq_exit();
 }
 
 void raise_softirq(unsigned int nr)
