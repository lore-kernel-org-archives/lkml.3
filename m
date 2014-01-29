Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaA2LwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 06:52:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48372 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2LwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 06:52:07 -0500
Date: Wed, 29 Jan 2014 12:51:42 +0100
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
Message-ID: <20140129115142.GE9636@twins.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390949495.2807.52.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 02:51:35PM -0800, Jason Low wrote:
> > But urgh, nasty problem. Lemme ponder this a bit.

OK, please have a very careful look at the below. It survived a boot
with udev -- which usually stresses mutex contention enough to explode
(in fact it did a few time when I got the contention/cancel path wrong),
however I have not ran anything else on it.

The below is an MCS variant that allows relatively cheap unqueueing. But
its somewhat tricky and I might have gotten a case wrong, esp. the
double concurrent cancel case got my head hurting (I didn't attempt a
tripple unqueue).

Applies to tip/master but does generate a few (harmless) compile
warnings because I didn't fully clean up the mcs_spinlock vs m_spinlock
thing.

Also, there's a comment in the slowpath that bears consideration.

---
 kernel/locking/mutex.c | 158 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 148 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 45fe1b5293d6..4a69da73903c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -166,6 +166,9 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 	struct task_struct *owner;
 	int retval = 1;
 
+	if (need_resched())
+		return 0;
+
 	rcu_read_lock();
 	owner = ACCESS_ONCE(lock->owner);
 	if (owner)
@@ -358,6 +361,134 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
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
+
+	/*
+	 * Undo our @prev->next assignment; this will make @prev's unlock()
+	 * wait for a next pointer since @lock points to us.
+	 */
+	if (cmpxchg(&prev->next, node, NULL) != node) { /* A -> B */
+		/*
+		 * @prev->next no longer pointed to us; either we hold the lock
+		 * or @prev cancelled the wait too and we need to reload and
+		 * retry.
+		 */
+		if (smp_load_acquire(&node->locked))
+			return true;
+
+		/*
+		 * Because we observed the new @prev->next, the smp_wmb() at (B)
+		 * ensures that we must now observe the new @node->prev.
+		 */
+		prev = ACCESS_ONCE(node->prev);
+		goto unqueue;
+	}
+
+	if (smp_load_acquire(&node->locked)) {
+		/*
+		 * OOPS, we were too late, we already got the lock.  No harm
+		 * done though; @prev is now unused an nobody cares we frobbed
+		 * it.
+		 */
+		return true;
+	}
+
+	/*
+	 * Per the above logic @prev's unlock() will now wait,
+	 * therefore @prev is now stable.
+	 */
+
+	if (cmpxchg(lock, node, prev) == node) {
+		/*
+		 * We were still the last queued, we moved @lock back.  @prev
+		 * will now observe @lock and will complete its unlock().
+		 */
+		return false;
+	}
+
+	/*
+	 * We're not the last to be queued, obtain ->next.
+	 */
+
+	while (!(next = ACCESS_ONCE(node->next)))
+		arch_mutex_cpu_relax();
+
+	ACCESS_ONCE(next->prev) = prev;
+
+	/*
+	 * Ensure that @next->prev is written before we write @prev->next,
+	 * this guarantees that when the cmpxchg at (A) fails we must
+	 * observe the new prev value.
+	 */
+	smp_wmb(); /* B -> A */
+
+	/*
+	 * And point @prev to our next, and we're unlinked. We can use an
+	 * non-atomic op because only we modify @prev->next.
+	 */
+	ACCESS_ONCE(prev->next) = next;
+
+	return false;
+}
+
+static void m_spin_unlock(struct m_spinlock **lock)
+{
+	struct m_spinlock *node = this_cpu_ptr(&m_node);
+	struct m_spinlock *next = ACCESS_ONCE(node->next);
+
+	while (likely(!next)) {
+		if (likely(cmpxchg(lock, node, NULL) == node))
+			return;
+
+		arch_mutex_cpu_relax();
+		next = ACCESS_ONCE(node->next);
+	}
+
+	smp_store_release(&next->locked, 1);
+}
+
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
@@ -400,9 +531,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
@@ -417,19 +550,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
@@ -442,11 +572,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
@@ -455,7 +584,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			goto slowpath;
+			break;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -465,10 +594,19 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
