Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaCQQ6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:58:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53915 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbaCQQ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:58:10 -0400
Date: Mon, 17 Mar 2014 09:58:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, josh@joshtriplett.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140317165806.GG21124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140316015914.GA22102@linux.vnet.ibm.com>
 <20140317101300.GA27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317101300.GA27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031716-1542-0000-0000-0000006F7727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 11:13:00AM +0100, Peter Zijlstra wrote:
> On Sat, Mar 15, 2014 at 06:59:14PM -0700, Paul E. McKenney wrote:
> > So I have been tightening up rcutorture a bit over the past year.
> > The other day, I came across what looked like a great opportunity for
> > further tightening, namely the schedule() in rcu_torture_reader().
> > Why not turn this into a cond_resched(), speeding up the readers a bit
> > and placing more stress on RCU?
> > 
> > And boy does it increase stress!
> > 
> > Unfortunately, this increased stress sometimes shows up in the form of
> > lots of RCU CPU stall warnings.  These can appear when an instance of
> > rcu_torture_reader() gets a CPU to itself, in which case it won't ever
> > enter the scheduler, and RCU will never see a quiescent state from that
> > CPU, which means the grace period never ends.
> > 
> > So I am taking a more measured approach to cond_resched() in
> > rcu_torture_reader() for the moment.
> > 
> > But longer term, should cond_resched() imply a set of RCU
> > quiescent states?  One way to do this would be to add calls to
> > rcu_note_context_switch() in each of the various cond_resched() functions.
> > Easy change, but of course adds some overhead.  On the other hand,
> > there might be more than a few of the 500+ calls to cond_resched() that
> > expect that RCU CPU stalls will be prevented (to say nothing of
> > might_sleep() and cond_resched_lock()).
> > 
> > Thoughts?
> 
> I share Mike's concern. Some of those functions might be too expensive
> to do in the loops where we have the cond_resched()s. And while its only
> strictly required when nr_running==1, keying off off that seems
> unfortunate in that it makes things behave differently with a single
> running task.
> 
> I suppose your proposed per-cpu counter is the best option; even though
> its still an extra cacheline hit in cond_resched().
> 
> As to the other cond_resched() variants; they might be a little more
> tricky, eg. cond_resched_lock() would have you drop the lock in order to
> note the QS, etc.
> 
> So one thing that might make sense is to have something like
> rcu_should_qs() which will indicate RCUs need for a grace period end.
> Then we can augment the various should_resched()/spin_needbreak() etc.
> with that condition.
> 
> That also gets rid of the counter (or at least hides it in the
> implementation if RCU really can't do anything better).

I did code up a version having a per-CPU bitmask indicating
which flavors of RCU needed quiescent states, and only invoking
rcu_note_context_switch() if at least one of the flavors needed
a quiescent state.  This implementation ended up being more
complex, but worse, slowed down the fast path.  Hard to beat
__this_cpu_inc_return()...  Might be able to break even with a bit more
work, but on most real systems there is pretty much always a grace period
in flight anyway, so it does not appear to be worth it.

So how about the following?  Passes moderate rcutorture testing, no RCU
CPU stall warnings despite cond_resched() in rcu_torture_reader().

							Thanx, Paul

------------------------------------------------------------------------

sched,rcu: Make cond_resched() report RCU quiescent states

Given a CPU running a loop containing cond_resched(), with no
other tasks runnable on that CPU, RCU will eventually report RCU
CPU stall warnings due to lack of quiescent states.  Fortunately,
every call to cond_resched() is a perfectly good quiescent state.
Unfortunately, invoking rcu_note_context_switch() is a bit heavyweight
for cond_resched(), especially given the need to disable preemption,
and, for RCU-preempt, interrupts as well.

This commit therefore maintains a per-CPU counter that causes
cond_resched(), cond_resched_lock(), and cond_resched_softirq() to call
rcu_note_context_switch(), but only about once per 256 invocations.
This ratio was chosen in keeping with the relative time constants of
RCU grace periods.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3cea28c64ebe..8d64878111ea 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -44,6 +44,7 @@
 #include <linux/debugobjects.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <linux/percpu.h>
 #include <asm/barrier.h>
 
 extern int rcu_expedited; /* for sysctl */
@@ -287,6 +288,41 @@ bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
 
 /*
+ * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
+ */
+
+#define RCU_COND_RESCHED_LIM 256	/* ms vs. 100s of ms. */
+DECLARE_PER_CPU(int, rcu_cond_resched_count);
+void rcu_resched(void);
+
+/*
+ * Is it time to report RCU quiescent states?
+ *
+ * Note unsynchronized access to rcu_cond_resched_count.  Yes, we might
+ * increment some random CPU's count, and possibly also load the result from
+ * yet another CPU's count.  We might even clobber some other CPU's attempt
+ * to zero its counter.  This is all OK because the goal is not precision,
+ * but rather reasonable amortization of rcu_note_context_switch() overhead
+ * and extremely high probability of avoiding RCU CPU stall warnings.
+ * Note that this function has to be preempted in just the wrong place,
+ * many thousands of times in a row, for anything bad to happen.
+ */
+static inline bool rcu_should_resched(void)
+{
+	return __this_cpu_inc_return(rcu_cond_resched_count) >=
+	       RCU_COND_RESCHED_LIM;
+}
+
+/*
+ * Report quiscent states to RCU if it is time to do so.
+ */
+static inline void rcu_cond_resched(void)
+{
+	if (unlikely(rcu_should_resched()))
+		rcu_resched();
+}
+
+/*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
  */
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4c0a9b0af469..30eb6bb52be6 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -337,4 +337,22 @@ static int __init check_cpu_stall_init(void)
 }
 early_initcall(check_cpu_stall_init);
 
+/*
+ * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
+ */
+
+DEFINE_PER_CPU(int, rcu_cond_resched_count);
+
+/*
+ * Report a set of RCU quiescent states, for use by cond_resched()
+ * and friends.  Out of line due to being called infrequently.
+ */
+void rcu_resched(void)
+{
+	preempt_disable();
+	__this_cpu_write(rcu_cond_resched_count, 0);
+	rcu_note_context_switch(smp_processor_id());
+	preempt_enable();
+}
+
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131ef6aab..b5c942a5f7ae 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4071,6 +4071,7 @@ static void __cond_resched(void)
 
 int __sched _cond_resched(void)
 {
+	rcu_cond_resched();
 	if (should_resched()) {
 		__cond_resched();
 		return 1;
@@ -4089,6 +4090,7 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int __cond_resched_lock(spinlock_t *lock)
 {
+	bool need_rcu_resched = rcu_should_resched();
 	int resched = should_resched();
 	int ret = 0;
 
@@ -4098,6 +4100,8 @@ int __cond_resched_lock(spinlock_t *lock)
 		spin_unlock(lock);
 		if (resched)
 			__cond_resched();
+		else if (unlikely(need_rcu_resched))
+			rcu_resched();
 		else
 			cpu_relax();
 		ret = 1;
@@ -4111,6 +4115,7 @@ int __sched __cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
+	rcu_cond_resched();
 	if (should_resched()) {
 		local_bh_enable();
 		__cond_resched();

