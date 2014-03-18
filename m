Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaCRPPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:15:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33499 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaCRPPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:15:47 -0400
Date: Tue, 18 Mar 2014 08:15:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, josh@joshtriplett.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140318151542.GK4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140316015914.GA22102@linux.vnet.ibm.com>
 <20140317101300.GA27965@twins.programming.kicks-ass.net>
 <20140317165806.GG21124@linux.vnet.ibm.com>
 <20140317171434.GJ25546@laptop.programming.kicks-ass.net>
 <20140318021706.GE4420@linux.vnet.ibm.com>
 <20140318085118.GO25546@laptop.programming.kicks-ass.net>
 <20140318124951.GI4420@linux.vnet.ibm.com>
 <20140318134534.GB23193@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318134534.GB23193@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031815-0928-0000-0000-00000091C483
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 02:45:34PM +0100, Peter Zijlstra wrote:
> > sched,rcu: Make cond_resched() report RCU quiescent states
> > 
> > Given a CPU running a loop containing cond_resched(), with no
> > other tasks runnable on that CPU, RCU will eventually report RCU
> > CPU stall warnings due to lack of quiescent states.  Fortunately,
> > every call to cond_resched() is a perfectly good quiescent state.
> > Unfortunately, invoking rcu_note_context_switch() is a bit heavyweight
> > for cond_resched(), especially given the need to disable preemption,
> > and, for RCU-preempt, interrupts as well.
> > 
> > This commit therefore maintains a per-CPU counter that causes
> > cond_resched(), cond_resched_lock(), and cond_resched_softirq() to call
> > rcu_note_context_switch(), but only about once per 256 invocations.
> > This ratio was chosen in keeping with the relative time constants of
> > RCU grace periods.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 3cea28c64ebe..8d64878111ea 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -44,6 +44,7 @@
> >  #include <linux/debugobjects.h>
> >  #include <linux/bug.h>
> >  #include <linux/compiler.h>
> > +#include <linux/percpu.h>
> >  #include <asm/barrier.h>
> >  
> >  extern int rcu_expedited; /* for sysctl */
> > @@ -287,6 +288,41 @@ bool __rcu_is_watching(void);
> >  #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
> >  
> >  /*
> > + * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
> > + */
> > +
> > +#define RCU_COND_RESCHED_LIM 256	/* ms vs. 100s of ms. */
> > +DECLARE_PER_CPU(int, rcu_cond_resched_count);
> > +void rcu_resched(void);
> > +
> > +/*
> > + * Is it time to report RCU quiescent states?
> > + *
> > + * Note unsynchronized access to rcu_cond_resched_count.  Yes, we might
> > + * increment some random CPU's count, and possibly also load the result from
> > + * yet another CPU's count.  We might even clobber some other CPU's attempt
> > + * to zero its counter.  This is all OK because the goal is not precision,
> > + * but rather reasonable amortization of rcu_note_context_switch() overhead
> > + * and extremely high probability of avoiding RCU CPU stall warnings.
> > + * Note that this function has to be preempted in just the wrong place,
> > + * many thousands of times in a row, for anything bad to happen.
> > + */
> > +static inline bool rcu_should_resched(void)
> > +{
> > +	return __this_cpu_inc_return(rcu_cond_resched_count) >=
> > +	       RCU_COND_RESCHED_LIM;
> > +}
> > +
> > +/*
> > + * Report quiscent states to RCU if it is time to do so.
> > + */
> > +static inline void rcu_cond_resched(void)
> > +{
> > +	if (unlikely(rcu_should_resched()))
> > +		rcu_resched();
> > +}
> > +
> > +/*
> >   * Infrastructure to implement the synchronize_() primitives in
> >   * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
> >   */
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index 4c0a9b0af469..ed7a0d72562c 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -338,3 +338,21 @@ static int __init check_cpu_stall_init(void)
> >  early_initcall(check_cpu_stall_init);
> >  
> >  #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
> > +
> > +/*
> > + * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
> > + */
> > +
> > +DEFINE_PER_CPU(int, rcu_cond_resched_count);
> > +
> > +/*
> > + * Report a set of RCU quiescent states, for use by cond_resched()
> > + * and friends.  Out of line due to being called infrequently.
> > + */
> > +void rcu_resched(void)
> > +{
> > +	preempt_disable();
> > +	__this_cpu_write(rcu_cond_resched_count, 0);
> 
> Somehow I've got the urge to write:
> 
>   __this_cpu_add(rcu_cond_resched_count, -RCU_COND_RESCHED_LIM);
> 
> But the immediate write is saver, and I suppose it doesn't matter at
> all.

My concern is that an unfortunate series of preemptions might cause a
victim CPU's counter to be driven to a large negative number, which
could then result in RCU CPU stall warnings given a subsequent time
with no schedules.  In contrast, the series of preemptions that result
in large positive numbers result in context switches during that time,
which keeps the stall warnings at bay.

> > +	rcu_note_context_switch(smp_processor_id());
> > +	preempt_enable();
> > +}
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index b46131ef6aab..1f53e8871dd2 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4071,6 +4071,7 @@ static void __cond_resched(void)
> >  
> >  int __sched _cond_resched(void)
> >  {
> > +	rcu_cond_resched();
> >  	if (should_resched()) {
> >  		__cond_resched();
> >  		return 1;
> > @@ -4089,6 +4090,7 @@ EXPORT_SYMBOL(_cond_resched);
> >   */
> >  int __cond_resched_lock(spinlock_t *lock)
> >  {
> > +	bool need_rcu_resched = rcu_should_resched();
> >  	int resched = should_resched();
> >  	int ret = 0;
> >  
> 
> I suppose you also need:
> 
> -	if (spin_needbreak(lock) || resched)
> +	if (spin_needbreak(lock) || resched || need_rcu_resched)

Indeed I do, thank you!

> > @@ -4098,6 +4100,8 @@ int __cond_resched_lock(spinlock_t *lock)
> >  		spin_unlock(lock);
> >  		if (resched)
> >  			__cond_resched();
> > +		else if (unlikely(need_rcu_resched))
> > +			rcu_resched();
> >  		else
> >  			cpu_relax();
> >  		ret = 1;
> > @@ -4111,6 +4115,7 @@ int __sched __cond_resched_softirq(void)
> >  {
> >  	BUG_ON(!in_softirq());
> >  
> > +	rcu_cond_resched();  /* BH disabled OK, just recording QSes. */
> >  	if (should_resched()) {
> >  		local_bh_enable();
> >  		__cond_resched();
> 
> At which point I'm wondering; do you also want __cond_resched_softirq()
> to advance rcu_bh? I'm forever forgetting the exact rcu_bh semantics
> though.

My assumption is that a given CPU spends a significant fraction of its
time outside of BH.  This means that we have a high probability of seeing
an RCU-bh quiescent state on the next scheduling-clock interrupt.  (If
there is no next scheduling-clock interrupt, RCU's dyntick-idle logic
should take care of things for us.)

But you are right:  If we start getting RCU-bh CPU stall warnings,
then one potential fix is putting RCU-bh quiescent states into
cond_resched() and friends.

Updated patch below.

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
index 4c0a9b0af469..ed7a0d72562c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -338,3 +338,21 @@ static int __init check_cpu_stall_init(void)
 early_initcall(check_cpu_stall_init);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
+
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131ef6aab..7b8ef161be4c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4071,6 +4071,7 @@ static void __cond_resched(void)
 
 int __sched _cond_resched(void)
 {
+	rcu_cond_resched();
 	if (should_resched()) {
 		__cond_resched();
 		return 1;
@@ -4089,15 +4090,18 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int __cond_resched_lock(spinlock_t *lock)
 {
+	bool need_rcu_resched = rcu_should_resched();
 	int resched = should_resched();
 	int ret = 0;
 
 	lockdep_assert_held(lock);
 
-	if (spin_needbreak(lock) || resched) {
+	if (spin_needbreak(lock) || resched || need_rcu_resched) {
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
 
+	rcu_cond_resched();  /* BH disabled OK, just recording QSes. */
 	if (should_resched()) {
 		local_bh_enable();
 		__cond_resched();

