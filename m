Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3KVN7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:59:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:44763 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3KVN7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:59:34 -0500
Date: Fri, 22 Nov 2013 14:59:31 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] rtmutex: take the waiter lock with irqs off
Message-ID: <20131122135931.GA8698@linutronix.de>
References: <1383794799.5441.16.camel@marge.simpson.net>
 <1383798668.5441.25.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
 <20131107125923.GB24644@localhost.localdomain>
 <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
 <1384243595.15180.63.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de>
 <20131115163008.GB12164@linutronix.de>
 <20131115201436.GC12164@linutronix.de>
 <20131118141021.GA10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131118141021.GA10022@twins.programming.kicks-ass.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra | 2013-11-18 15:10:21 [+0100]:

>Its get_next_timer_interrupt() that does a trylock() and only for
>PREEMPT_RT_FULL.
>
>Also; on IRC you said:
>
>  "<bigeasy> I'm currently not sure if we should do
>the _irq() lock or a trylock for the wait_lock in
>rt_mutex_slowtrylock()"
>
>Which I misread and dismissed -- but yes that might actually work too
>and would be a much smaller patch. You'd only need trylock and unlock.

Yes and the patch is at the end of the mail. I also added your "lockdep:
Correctly annotate hardirq context in irq_exit()" to the -RT queue and
saw the splat. After the trylock replacement I needed something similar
for the unlock path _or_ lockdep would complain. So unless there is a
better way…

>That said, allowing such usage from actual IRQ context is iffy; suppose
>the trylock succeeds, who then is the lock owner?
>
>I suppose it would be whatever task we interrupted and boosting will
>'work' because we're non-preemptable, but still *YUCK*.

You are right, this ain't pretty. I hope this timer mess can be replaced
with something else so the whole trylock thingy can be removed.

Sebastian

--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -22,6 +22,7 @@ extern void __lockfunc rt_spin_lock(spin
 extern unsigned long __lockfunc rt_spin_lock_trace_flags(spinlock_t *lock);
 extern void __lockfunc rt_spin_lock_nested(spinlock_t *lock, int subclass);
 extern void __lockfunc rt_spin_unlock(spinlock_t *lock);
+extern void __lockfunc rt_spin_try_unlock(spinlock_t *lock);
 extern void __lockfunc rt_spin_unlock_wait(spinlock_t *lock);
 extern int __lockfunc rt_spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags);
 extern int __lockfunc rt_spin_trylock_bh(spinlock_t *lock);
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -816,10 +816,8 @@ static void  noinline __sched rt_spin_lo
 /*
  * Slow path to release a rt_mutex spin_lock style
  */
-static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
+static void __sched __rt_spin_lock_slowunlock(struct rt_mutex *lock)
 {
-	raw_spin_lock(&lock->wait_lock);
-
 	debug_rt_mutex_unlock(lock);
 
 	rt_mutex_deadlock_account_unlock(current);
@@ -838,6 +836,21 @@ static void  noinline __sched rt_spin_lo
 	rt_mutex_adjust_prio(current);
 }
 
+static void  noinline __sched rt_spin_lock_slowunlock(struct rt_mutex *lock)
+{
+	raw_spin_lock(&lock->wait_lock);
+	__rt_spin_lock_slowunlock(lock);
+}
+
+static void  noinline __sched rt_spin_lock_try_slowunlock(struct rt_mutex *lock)
+{
+	int ret;
+
+	ret = raw_spin_trylock(&lock->wait_lock);
+	BUG_ON(!ret);
+	__rt_spin_lock_slowunlock(lock);
+}
+
 void __lockfunc rt_spin_lock(spinlock_t *lock)
 {
 	rt_spin_lock_fastlock(&lock->lock, rt_spin_lock_slowlock);
@@ -868,6 +881,13 @@ void __lockfunc rt_spin_unlock(spinlock_
 }
 EXPORT_SYMBOL(rt_spin_unlock);
 
+void __lockfunc rt_spin_try_unlock(spinlock_t *lock)
+{
+	/* NOTE: we always pass in '1' for nested, for simplicity */
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	rt_spin_lock_fastunlock(&lock->lock, rt_spin_lock_try_slowunlock);
+}
+
 void __lockfunc __rt_spin_unlock(struct rt_mutex *lock)
 {
 	rt_spin_lock_fastunlock(lock, rt_spin_lock_slowunlock);
@@ -1191,7 +1211,8 @@ rt_mutex_slowtrylock(struct rt_mutex *lo
 {
 	int ret = 0;
 
-	raw_spin_lock(&lock->wait_lock);
+	if (!raw_spin_trylock(&lock->wait_lock))
+		return ret;
 	init_lists(lock);
 
 	if (likely(rt_mutex_owner(lock) != current)) {
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1400,7 +1400,7 @@ unsigned long get_next_timer_interrupt(u
 		expires = base->next_timer;
 	}
 #ifdef CONFIG_PREEMPT_RT_FULL
-	rt_spin_unlock(&base->lock);
+	rt_spin_try_unlock(&base->lock);
 #else
 	spin_unlock(&base->lock);
 #endif
