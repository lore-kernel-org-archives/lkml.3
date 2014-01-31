Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaAaOKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:10:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46529 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaAaOKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:10:03 -0500
Date: Fri, 31 Jan 2014 15:09:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Message-ID: <20140131140941.GF4941@twins.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
 <20140129115142.GE9636@twins.programming.kicks-ass.net>
 <1391138977.6284.82.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391138977.6284.82.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 07:29:37PM -0800, Jason Low wrote:
> On Wed, 2014-01-29 at 12:51 +0100, Peter Zijlstra wrote:
> > On Tue, Jan 28, 2014 at 02:51:35PM -0800, Jason Low wrote:
> > > > But urgh, nasty problem. Lemme ponder this a bit.
> > 
> > OK, please have a very careful look at the below. It survived a boot
> > with udev -- which usually stresses mutex contention enough to explode
> > (in fact it did a few time when I got the contention/cancel path wrong),
> > however I have not ran anything else on it.
> 
> I tested this patch on a 2 socket, 8 core machine with the AIM7 fserver
> workload. After 100 users, the system gets soft lockups.
> 
> Some condition may be causing threads to not leave the "goto unqueue"
> loop. I added a debug counter, and threads were able to reach more than
> 1,000,000,000 "goto unqueue".
> 
> I also was initially thinking if there can be problems when multiple
> threads need_resched() and unqueue at the same time. As an example, 2
> nodes that need to reschedule are next to each other in the middle of
> the MCS queue. The 1st node executes "while (!(next =
> ACCESS_ONCE(node->next)))" and exits the while loop because next is not
> NULL. Then, the 2nd node execute its "if (cmpxchg(&prev->next, node,
> NULL) != node)". We may then end up in a situation where the node before
> the 1st node gets linked with the outdated 2nd node.

Yes indeed, I found two bugs. If you consider the MCS lock with 4 queued
nodes:

       .----.
 L ->  | N4 |
       `----'
        ^  V
       .----.
       | N3 |
       `----'
        ^  V
       .----.
       | N2 |
       `----'
        ^  V
       .----.
       | N1 |
       `----'

And look at the 3 unqueue steps in the below patch, and read 3A to
mean, Node 3 ran step A.

Both bugs were in Step B, the first was triggered through:

  3A,4A,3B,4B

In this case the old code would have 3 spinning in @n3->next, however
4B would have moved L to N3 and left @n3->next empty. FAIL.

The second was:

  2A,2B,3A,2C,3B,3C

In this case the cancellation of both 2 and 3 'succeed' and we end up
with N1 linked to N3 and N2 linked to N4. Total fail.


The first bug was fixed by having Step-B spin on both @n->next and @l
just like the unlink() path already did.

The second bug was fixed by having Step-B xchg(@n->next, NULL) instead
of only reading it; this way the 3A above cannot complete until after 2C
and we have a coherent chain back.

I've downloaded AIM7 from sf.net and I hope I'm running it with 100+
loads but I'm not entirely sure I got this thing right, its not really
making progress with or without patch :/

---
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -166,6 +166,9 @@ static inline int mutex_can_spin_on_owne
 	struct task_struct *owner;
 	int retval = 1;
 
+	if (need_resched())
+		return 0;
+
 	rcu_read_lock();
 	owner = ACCESS_ONCE(lock->owner);
 	if (owner)
@@ -358,6 +361,166 @@ ww_mutex_set_context_fastpath(struct ww_
 	spin_unlock_mutex(&lock->base.wait_lock, flags);
 }
 
+struct m_spinlock {
+	struct m_spinlock *next, *prev;
+	int locked; /* 1 if lock acquired */
+};
+
+/*
+ * Using a single mcs node per CPU is safe because mutex_lock() should not be
+ * called from interrupt context and we have preemption disabled over the mcs
+ * lock usage.
+ */
+static DEFINE_PER_CPU(struct m_spinlock, m_node);
+
+static bool m_spin_lock(struct m_spinlock **lock)
+{
+	struct m_spinlock *node = this_cpu_ptr(&m_node);
+	struct m_spinlock *prev, *next;
+
+	node->locked = 0;
+	node->next = NULL;
+
+	node->prev = prev = xchg(lock, node);
+	if (likely(prev == NULL))
+		return true;
+
+	ACCESS_ONCE(prev->next) = node;
+
+	/*
+	 * Normally @prev is untouchable after the above store; because at that
+	 * moment unlock can proceed and wipe the node element from stack.
+	 *
+	 * However, since our nodes are static per-cpu storage, we're
+	 * guaranteed their existence -- this allows us to apply
+	 * cmpxchg in an attempt to undo our queueing.
+	 */
+
+	while (!smp_load_acquire(&node->locked)) {
+		if (need_resched())
+			goto unqueue;
+		arch_mutex_cpu_relax();
+	}
+	return true;
+
+unqueue:
+	/*
+	 * Step - A  -- stabilize @prev
+	 *
+	 * Undo our @prev->next assignment; this will make @prev's
+	 * unlock()/cancel() wait for a next pointer since @lock points to us
+	 * (or later).
+	 */
+
+	for (;;) {
+		next = cmpxchg(&prev->next, node, NULL); /* A -> B,C */
+
+		/*
+		 * Because the unlock() path retains @prev->next (for
+		 * performance) we must check @node->locked after clearing
+		 * @prev->next to see if we raced.
+		 *
+		 * Ordered by the cmpxchg() above and the conditional-store in
+		 * unlock().
+		 */
+		if (smp_load_acquire(&node->locked)) {
+			/*
+			 * OOPS, we were too late, we already got the lock. No
+			 * harm done though; @prev is now unused an nobody
+			 * cares we frobbed it.
+			 */
+			return true;
+		}
+
+		if (next == node)
+			break;
+
+		/*
+		 * @prev->next didn't point to us anymore, we didn't own the
+		 * lock, so reload and try again.
+		 *
+		 * Because we observed the new @prev->next, the smp_wmb() at
+		 * (C) ensures that we must now observe the new @node->prev.
+		 */
+		prev = ACCESS_ONCE(node->prev);
+	}
+
+	/*
+	 * Step - B -- stabilize @next
+	 *
+	 * Similar to unlock(), wait for @node->next or move @lock from @node
+	 * back to @prev.
+	 */
+
+	for (;;) {
+		if (*lock == node && cmpxchg(lock, node, prev) == node) {
+			/*
+			 * We were the last queued, we moved @lock back. @prev
+			 * will now observe @lock and will complete its
+			 * unlock()/cancel().
+			 */
+			return false;
+		}
+
+		/*
+		 * We must xchg() the @node->next value, because if we were to
+		 * leave it in, a concurrent cancel() from @node->next might
+		 * complete Step-A and think its @prev is still valid.
+		 *
+		 * If the concurrent cancel() wins the race, we'll wait for
+		 * either @lock to point to us, through its Step-B, or wait for
+		 * a new @node->next from its Step-C.
+		 */
+		next = xchg(&node->next, NULL); /* B -> A */
+		if (next)
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+
+	/*
+	 * Step - C -- unlink
+	 *
+	 * @prev is stable because its still waiting for a new @prev->next
+	 * pointer, @next is stable because our @node->next pointer is NULL and
+	 * it will wait in Step-A.
+	 */
+
+	ACCESS_ONCE(next->prev) = prev;
+
+	/*
+	 * Ensure that @next->prev is written before we write @prev->next,
+	 * this guarantees that when the cmpxchg at (A) fails we must
+	 * observe the new prev value.
+	 */
+	smp_wmb(); /* C -> A */
+
+	/*
+	 * And point @prev to our next, and we're unlinked.
+	 */
+	ACCESS_ONCE(prev->next) = next;
+
+	return false;
+}
+
+static void m_spin_unlock(struct m_spinlock **lock)
+{
+	struct m_spinlock *node = this_cpu_ptr(&m_node);
+	struct m_spinlock *next;
+
+	for (;;) {
+		if (likely(cmpxchg(lock, node, NULL) == node))
+			return;
+
+		next = ACCESS_ONCE(node->next);
+		if (unlikely(next))
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+	smp_store_release(&next->locked, 1);
+}
+
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
@@ -400,9 +563,11 @@ __mutex_lock_common(struct mutex *lock,
 	if (!mutex_can_spin_on_owner(lock))
 		goto slowpath;
 
+	if (!m_spin_lock(&lock->mcs_lock))
+		goto slowpath;
+
 	for (;;) {
 		struct task_struct *owner;
-		struct mcs_spinlock  node;
 
 		if (use_ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
@@ -417,19 +582,16 @@ __mutex_lock_common(struct mutex *lock,
 			 * performed the optimistic spinning cannot be done.
 			 */
 			if (ACCESS_ONCE(ww->ctx))
-				goto slowpath;
+				break;
 		}
 
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-		mcs_spin_lock(&lock->mcs_lock, &node);
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner)) {
-			mcs_spin_unlock(&lock->mcs_lock, &node);
-			goto slowpath;
-		}
+		if (owner && !mutex_spin_on_owner(lock, owner))
+			break;
 
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
@@ -442,11 +604,10 @@ __mutex_lock_common(struct mutex *lock,
 			}
 
 			mutex_set_owner(lock);
-			mcs_spin_unlock(&lock->mcs_lock, &node);
+			m_spin_unlock(&lock->mcs_lock);
 			preempt_enable();
 			return 0;
 		}
-		mcs_spin_unlock(&lock->mcs_lock, &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -455,7 +616,7 @@ __mutex_lock_common(struct mutex *lock,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			goto slowpath;
+			break;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -465,10 +626,19 @@ __mutex_lock_common(struct mutex *lock,
 		 */
 		arch_mutex_cpu_relax();
 	}
+	m_spin_unlock(&lock->mcs_lock);
 slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
+	/*
+	 * XXX arguably, when need_resched() is set and there's other pending
+	 * owners we should not try-acquire and simply queue and schedule().
+	 *
+	 * There's nothing worse than obtaining a lock only to get immediately
+	 * scheduled out.
+	 */
+
 	/* once more, can we acquire the lock? */
 	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
 		goto skip_wait;
