Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbbAWOIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:08:44 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41803 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbbAWOIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:08:41 -0500
Date: Fri, 23 Jan 2015 14:08:32 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: Behaviour of smp_mb__{before,after}_spin* and acquire/release
Message-ID: <20150123140832.GE23058@arm.com>
References: <20150113163353.GE31784@arm.com>
 <20150120093443.GA11596@twins.programming.kicks-ass.net>
 <20150120213545.GT9719@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120213545.GT9719@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 09:35:45PM +0000, Paul E. McKenney wrote:
> On Tue, Jan 20, 2015 at 10:34:43AM +0100, Peter Zijlstra wrote:
> > On Tue, Jan 13, 2015 at 04:33:54PM +0000, Will Deacon wrote:
> > > I started dusting off a series I've been working to implement a relaxed
> > > atomic API in Linux (i.e. things like atomic_read(v, ACQUIRE)) but I'm
> > > having trouble making sense of the ordering semantics we have in mainline
> > > today:
> > 
> > >   2. Does smp_mb__after_unlock_lock order smp_store_release against
> > >      smp_load_acquire? Again, Documentation/memory-barriers.txt puts
> > >      these operations into the RELEASE and ACQUIRE classes respectively,
> > >      but since smp_mb__after_unlock_lock is a NOP everywhere other than
> > >      PowerPC, I don't think this is enforced by the current code. 
> > 
> > Yeah, wasn't Paul going to talk to Ben about that? PPC is the only arch
> > that has the weak ACQUIRE/RELEASE for its spinlocks.
> 
> I thought that you guys were going to propose something and we would see
> what the reaction was.  ;-)

Well, ripping it out is quite easy (patch below) :)

I didn't fully grok the comment in the MCS code, since mcs_lock uses an
xchg, which does have full barrier semantics and therefore mcs_unlock +
mcs_lock also has full barrier semantics afaict.

The remaining problem it that this puts PowerPC back into its original state
(before the barrier) where UNLOCK + LOCK doesn't imply a full barrier, so
that would need to be fixed.

Anyway, kicking this out there for comments.

Will

--->8

>From 23d1db44f20a12924d2addeb73231f10d90e9f05 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Fri, 23 Jan 2015 13:55:34 +0000
Subject: [PATCH] memory-barriers: remove smp_mb__after_unlock_lock()

smp_mb__after_unlock_lock is used to promote an UNLOCK + LOCK sequence
into a full memory barrier.

However:

  - This ordering guarantee is already provided without the barrier on
    all architectures apart from PowerPC

  - The barrier only applies to UNLOCK + LOCK, not general
    RELEASE + ACQUIRE operations

  - The barrier is not well used outside of RCU and, because it was
    retrofitted into the kernel, it's not clear whether other areas of
    the kernel are incorrectly relying on UNLOCK + LOCK implying a full
    barrier

This patch removes the barrier and instead requires architectures to
provide full barrier semantics for an UNLOCK + LOCK sequence.

TODO: add a barrier to PowerPC unlock?

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 Documentation/memory-barriers.txt   | 77 ++-----------------------------------
 arch/powerpc/include/asm/spinlock.h |  2 -
 include/linux/spinlock.h            | 10 -----
 kernel/locking/mcs_spinlock.h       |  9 -----
 kernel/rcu/tree.c                   | 19 +--------
 kernel/rcu/tree_plugin.h            | 13 -------
 6 files changed, 4 insertions(+), 126 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 9c0e3c45a807..fed47737e4c6 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1777,74 +1777,9 @@ RELEASE are to the same lock variable, but only from the perspective of
 another CPU not holding that lock.  In short, a ACQUIRE followed by an
 RELEASE may -not- be assumed to be a full memory barrier.
 
-Similarly, the reverse case of a RELEASE followed by an ACQUIRE does not
-imply a full memory barrier.  If it is necessary for a RELEASE-ACQUIRE
-pair to produce a full barrier, the ACQUIRE can be followed by an
-smp_mb__after_unlock_lock() invocation.  This will produce a full barrier
-if either (a) the RELEASE and the ACQUIRE are executed by the same
-CPU or task, or (b) the RELEASE and ACQUIRE act on the same variable.
-The smp_mb__after_unlock_lock() primitive is free on many architectures.
-Without smp_mb__after_unlock_lock(), the CPU's execution of the critical
-sections corresponding to the RELEASE and the ACQUIRE can cross, so that:
-
-	*A = a;
-	RELEASE M
-	ACQUIRE N
-	*B = b;
-
-could occur as:
-
-	ACQUIRE N, STORE *B, STORE *A, RELEASE M
-
-It might appear that this reordering could introduce a deadlock.
-However, this cannot happen because if such a deadlock threatened,
-the RELEASE would simply complete, thereby avoiding the deadlock.
-
-	Why does this work?
-
-	One key point is that we are only talking about the CPU doing
-	the reordering, not the compiler.  If the compiler (or, for
-	that matter, the developer) switched the operations, deadlock
-	-could- occur.
-
-	But suppose the CPU reordered the operations.  In this case,
-	the unlock precedes the lock in the assembly code.  The CPU
-	simply elected to try executing the later lock operation first.
-	If there is a deadlock, this lock operation will simply spin (or
-	try to sleep, but more on that later).	The CPU will eventually
-	execute the unlock operation (which preceded the lock operation
-	in the assembly code), which will unravel the potential deadlock,
-	allowing the lock operation to succeed.
-
-	But what if the lock is a sleeplock?  In that case, the code will
-	try to enter the scheduler, where it will eventually encounter
-	a memory barrier, which will force the earlier unlock operation
-	to complete, again unraveling the deadlock.  There might be
-	a sleep-unlock race, but the locking primitive needs to resolve
-	such races properly in any case.
-
-With smp_mb__after_unlock_lock(), the two critical sections cannot overlap.
-For example, with the following code, the store to *A will always be
-seen by other CPUs before the store to *B:
-
-	*A = a;
-	RELEASE M
-	ACQUIRE N
-	smp_mb__after_unlock_lock();
-	*B = b;
-
-The operations will always occur in one of the following orders:
-
-	STORE *A, RELEASE, ACQUIRE, smp_mb__after_unlock_lock(), STORE *B
-	STORE *A, ACQUIRE, RELEASE, smp_mb__after_unlock_lock(), STORE *B
-	ACQUIRE, STORE *A, RELEASE, smp_mb__after_unlock_lock(), STORE *B
-
-If the RELEASE and ACQUIRE were instead both operating on the same lock
-variable, only the first of these alternatives can occur.  In addition,
-the more strongly ordered systems may rule out some of the above orders.
-But in any case, as noted earlier, the smp_mb__after_unlock_lock()
-ensures that the store to *A will always be seen as happening before
-the store to *B.
+However, the reverse case of a RELEASE followed by an ACQUIRE _does_
+imply a full memory barrier when these accesses are performed as a pair
+of UNLOCK and LOCK operations, irrespective of the lock variable.
 
 Locks and semaphores may not provide any guarantee of ordering on UP compiled
 systems, and so cannot be counted on in such a situation to actually achieve
@@ -2087,7 +2022,6 @@ However, if the following occurs:
 	RELEASE M	     [1]
 	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*E) = e;
 					ACQUIRE M		     [2]
-					smp_mb__after_unlock_lock();
 					ACCESS_ONCE(*F) = f;
 					ACCESS_ONCE(*G) = g;
 					RELEASE M	     [2]
@@ -2105,11 +2039,6 @@ But assuming CPU 1 gets the lock first, CPU 3 won't see any of:
 	*F, *G or *H preceding ACQUIRE M [2]
 	*A, *B, *C, *E, *F or *G following RELEASE M [2]
 
-Note that the smp_mb__after_unlock_lock() is critically important
-here: Without it CPU 3 might see some of the above orderings.
-Without smp_mb__after_unlock_lock(), the accesses are not guaranteed
-to be seen in order unless CPU 3 holds lock M.
-
 
 ACQUIRES VS I/O ACCESSES
 ------------------------
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 4dbe072eecbe..523673d7583c 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -28,8 +28,6 @@
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
 
-#define smp_mb__after_unlock_lock()	smp_mb()  /* Full ordering for lock. */
-
 #ifdef CONFIG_PPC64
 /* use 0x800000yy when locked, where yy == CPU number */
 #ifdef __BIG_ENDIAN__
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 262ba4ef9a8e..9e8ba39640ce 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -130,16 +130,6 @@ do {								\
 #define smp_mb__before_spinlock()	smp_wmb()
 #endif
 
-/*
- * Place this after a lock-acquisition primitive to guarantee that
- * an UNLOCK+LOCK pair act as a full barrier.  This guarantee applies
- * if the UNLOCK and LOCK are executed by the same CPU or if the
- * UNLOCK and LOCK operate on the same lock variable.
- */
-#ifndef smp_mb__after_unlock_lock
-#define smp_mb__after_unlock_lock()	do { } while (0)
-#endif
-
 /**
  * raw_spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index 4d60986fcbee..6d60c9f7dc87 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -42,15 +42,6 @@ do {									\
 #endif
 
 /*
- * Note: the smp_load_acquire/smp_store_release pair is not
- * sufficient to form a full memory barrier across
- * cpus for many architectures (except x86) for mcs_unlock and mcs_lock.
- * For applications that need a full barrier across multiple cpus
- * with mcs_unlock and mcs_lock pair, smp_mb__after_unlock_lock() should be
- * used after mcs_lock.
- */
-
-/*
  * In order to acquire the lock, the caller should declare a local node and
  * pass a reference of the node to this function in addition to the lock.
  * If the lock has already been acquired, then this will proceed to spin
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7680fc275036..86595ead34ec 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1322,10 +1322,8 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 	 * hold it, acquire the root rcu_node structure's lock in order to
 	 * start one (if needed).
 	 */
-	if (rnp != rnp_root) {
+	if (rnp != rnp_root)
 		raw_spin_lock(&rnp_root->lock);
-		smp_mb__after_unlock_lock();
-	}
 
 	/*
 	 * Get a new grace-period number.  If there really is no grace
@@ -1574,7 +1572,6 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 		local_irq_restore(flags);
 		return;
 	}
-	smp_mb__after_unlock_lock();
 	needwake = __note_gp_changes(rsp, rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (needwake)
@@ -1591,7 +1588,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
-	smp_mb__after_unlock_lock();
 	if (!ACCESS_ONCE(rsp->gp_flags)) {
 		/* Spurious wakeup, tell caller to go back to sleep.  */
 		raw_spin_unlock_irq(&rnp->lock);
@@ -1617,7 +1613,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	/* Exclude any concurrent CPU-hotplug operations. */
 	mutex_lock(&rsp->onoff_mutex);
-	smp_mb__after_unlock_lock(); /* ->gpnum increment before GP! */
 
 	/*
 	 * Set the quiescent-state-needed bits in all the rcu_node
@@ -1634,7 +1629,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
-		smp_mb__after_unlock_lock();
 		rdp = this_cpu_ptr(rsp->rda);
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
@@ -1684,7 +1678,6 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	/* Clear flag to prevent immediate re-entry. */
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
-		smp_mb__after_unlock_lock();
 		ACCESS_ONCE(rsp->gp_flags) =
 			ACCESS_ONCE(rsp->gp_flags) & ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
@@ -1704,7 +1697,6 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	raw_spin_lock_irq(&rnp->lock);
-	smp_mb__after_unlock_lock();
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
@@ -1730,7 +1722,6 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
-		smp_mb__after_unlock_lock();
 		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
@@ -1742,7 +1733,6 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
-	smp_mb__after_unlock_lock(); /* Order GP before ->completed update. */
 	rcu_nocb_gp_set(rnp, nocb);
 
 	/* Declare grace period done. */
@@ -1978,7 +1968,6 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 		rnp_c = rnp;
 		rnp = rnp->parent;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		smp_mb__after_unlock_lock();
 		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
@@ -2009,7 +1998,6 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 
 	rnp = rdp->mynode;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	smp_mb__after_unlock_lock();
 	if (rdp->passed_quiesce == 0 || rdp->gpnum != rnp->gpnum ||
 	    rnp->completed == rnp->gpnum) {
 
@@ -2224,7 +2212,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
 		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
-		smp_mb__after_unlock_lock();
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
@@ -2437,7 +2424,6 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		cond_resched_rcu_qs();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		smp_mb__after_unlock_lock();
 		if (!rcu_gp_in_progress(rsp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
@@ -2467,7 +2453,6 @@ static void force_qs_rnp(struct rcu_state *rsp,
 	rnp = rcu_get_root(rsp);
 	if (rnp->qsmask == 0) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		smp_mb__after_unlock_lock();
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 	}
 }
@@ -2500,7 +2485,6 @@ static void force_quiescent_state(struct rcu_state *rsp)
 
 	/* Reached the root of the rcu_node tree, acquire lock. */
 	raw_spin_lock_irqsave(&rnp_old->lock, flags);
-	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		rsp->n_force_qs_lh++;
@@ -2625,7 +2609,6 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 			struct rcu_node *rnp_root = rcu_get_root(rsp);
 
 			raw_spin_lock(&rnp_root->lock);
-			smp_mb__after_unlock_lock();
 			needwake = rcu_start_gp(rsp);
 			raw_spin_unlock(&rnp_root->lock);
 			if (needwake)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3ec85cb5d544..a89523605545 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -180,7 +180,6 @@ static void rcu_preempt_note_context_switch(void)
 		rdp = this_cpu_ptr(rcu_preempt_state.rda);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		smp_mb__after_unlock_lock();
 		t->rcu_read_unlock_special.b.blocked = true;
 		t->rcu_blocked_node = rnp;
 
@@ -287,7 +286,6 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	mask = rnp->grpmask;
 	raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	raw_spin_lock(&rnp_p->lock);	/* irqs already disabled. */
-	smp_mb__after_unlock_lock();
 	rcu_report_qs_rnp(mask, &rcu_preempt_state, rnp_p, flags);
 }
 
@@ -362,7 +360,6 @@ void rcu_read_unlock_special(struct task_struct *t)
 		for (;;) {
 			rnp = t->rcu_blocked_node;
 			raw_spin_lock(&rnp->lock);  /* irqs already disabled. */
-			smp_mb__after_unlock_lock();
 			if (rnp == t->rcu_blocked_node)
 				break;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
@@ -576,7 +573,6 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	while (!list_empty(lp)) {
 		t = list_entry(lp->next, typeof(*t), rcu_node_entry);
 		raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
-		smp_mb__after_unlock_lock();
 		list_del(&t->rcu_node_entry);
 		t->rcu_blocked_node = rnp_root;
 		list_add(&t->rcu_node_entry, lp_root);
@@ -601,7 +597,6 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	 * in this case.
 	 */
 	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
-	smp_mb__after_unlock_lock();
 	if (rnp_root->boost_tasks != NULL &&
 	    rnp_root->boost_tasks != rnp_root->gp_tasks &&
 	    rnp_root->boost_tasks != rnp_root->exp_tasks)
@@ -732,7 +727,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 	unsigned long mask;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	smp_mb__after_unlock_lock();
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -750,7 +744,6 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 		rnp = rnp->parent;
 		raw_spin_lock(&rnp->lock); /* irqs already disabled */
-		smp_mb__after_unlock_lock();
 		rnp->expmask &= ~mask;
 	}
 }
@@ -770,7 +763,6 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 	int must_wait = 0;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	smp_mb__after_unlock_lock();
 	if (list_empty(&rnp->blkd_tasks)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else {
@@ -850,7 +842,6 @@ void synchronize_rcu_expedited(void)
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
-		smp_mb__after_unlock_lock();
 		rnp->expmask = rnp->qsmaskinit;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
@@ -1131,7 +1122,6 @@ static int rcu_boost(struct rcu_node *rnp)
 		return 0;  /* Nothing left to boost. */
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	smp_mb__after_unlock_lock();
 
 	/*
 	 * Recheck under the lock: all tasks in need of boosting
@@ -1323,7 +1313,6 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	smp_mb__after_unlock_lock();
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	sp.sched_priority = kthread_prio;
@@ -1717,7 +1706,6 @@ static void rcu_prepare_for_idle(void)
 			continue;
 		rnp = rdp->mynode;
 		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
-		smp_mb__after_unlock_lock();
 		needwake = rcu_accelerate_cbs(rsp, rnp, rdp);
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		if (needwake)
@@ -2226,7 +2214,6 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	struct rcu_node *rnp = rdp->mynode;
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	smp_mb__after_unlock_lock();
 	needwake = rcu_start_future_gp(rnp, rdp, &c);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (needwake)
-- 
2.1.4

