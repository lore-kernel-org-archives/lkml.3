Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaFKSoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:34269 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaFKSoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:06 -0400
Message-Id: <20140611183852.937945560@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch V4 01/10] rtmutex: Plug slow unlock race
References: <20140611182944.108526809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=rtmutex-plug-slow-unlock-race.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the rtmutex fast path is enabled the slow unlock function can
create the following situation:

spin_lock(foo->m->wait_lock);
foo->m->owner = NULL;
	    			rt_mutex_lock(foo->m); <-- fast path
				free = atomic_dec_and_test(foo->refcnt);
				rt_mutex_unlock(foo->m); <-- fast path
				if (free)
				   kfree(foo);

spin_unlock(foo->m->wait_lock); <--- Use after free.

Plug the race by changing the slow unlock to the following scheme:

     while (!rt_mutex_has_waiters(m)) {
     	    /* Clear the waiters bit in m->owner */
	    clear_rt_mutex_waiters(m);
      	    owner = rt_mutex_owner(m);
      	    spin_unlock(m->wait_lock);
      	    if (cmpxchg(m->owner, owner, 0) == owner)
      	       return;
      	    spin_lock(m->wait_lock);
     }

So in case of a new waiter incoming while the owner tries the slow
path unlock we have two situations:

 unlock(wait_lock);
					lock(wait_lock);
 cmpxchg(p, owner, 0) == owner
 	    	   			mark_rt_mutex_waiters(lock);
	 				acquire(lock);

Or:

 unlock(wait_lock);
					lock(wait_lock);
	 				mark_rt_mutex_waiters(lock);
 cmpxchg(p, owner, 0) != owner
					enqueue_waiter();
					unlock(wait_lock);
 lock(wait_lock);
 wakeup_next waiter();
 unlock(wait_lock);
					lock(wait_lock);
					acquire(lock);

If the fast path is disabled, then the simple

   m->owner = NULL;
   unlock(m->wait_lock);

is sufficient as all access to m->owner is serialized via
m->wait_lock;

Also document and clarify the wakeup_next_waiter function as suggested
by Oleg Nesterov.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |  118 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 112 insertions(+), 6 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -83,6 +83,47 @@ static inline void mark_rt_mutex_waiters
 		owner = *p;
 	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
 }
+
+/*
+ * Safe fastpath aware unlock:
+ * 1) Clear the waiters bit
+ * 2) Drop lock->wait_lock
+ * 3) Try to unlock the lock with cmpxchg
+ */
+static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
+	__releases(lock->wait_lock)
+{
+	struct task_struct *owner = rt_mutex_owner(lock);
+
+	clear_rt_mutex_waiters(lock);
+	raw_spin_unlock(&lock->wait_lock);
+	/*
+	 * If a new waiter comes in between the unlock and the cmpxchg
+	 * we have two situations:
+	 *
+	 * unlock(wait_lock);
+	 *					lock(wait_lock);
+	 * cmpxchg(p, owner, 0) == owner
+	 *					mark_rt_mutex_waiters(lock);
+	 *					acquire(lock);
+	 * or:
+	 *
+	 * unlock(wait_lock);
+	 *					lock(wait_lock);
+	 *					mark_rt_mutex_waiters(lock);
+	 *
+	 * cmpxchg(p, owner, 0) != owner
+	 *					enqueue_waiter();
+	 *					unlock(wait_lock);
+	 * lock(wait_lock);
+	 * wake waiter();
+	 * unlock(wait_lock);
+	 *					lock(wait_lock);
+	 *					acquire(lock);
+	 */
+	return rt_mutex_cmpxchg(lock, owner, NULL);
+}
+
 #else
 # define rt_mutex_cmpxchg(l,c,n)	(0)
 static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
@@ -90,6 +131,17 @@ static inline void mark_rt_mutex_waiters
 	lock->owner = (struct task_struct *)
 			((unsigned long)lock->owner | RT_MUTEX_HAS_WAITERS);
 }
+
+/*
+ * Simple slow path only version: lock->owner is protected by lock->wait_lock.
+ */
+static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
+	__releases(lock->wait_lock)
+{
+	lock->owner = NULL;
+	raw_spin_unlock(&lock->wait_lock);
+	return true;
+}
 #endif
 
 static inline int
@@ -650,7 +702,8 @@ static int task_blocks_on_rt_mutex(struc
 /*
  * Wake up the next waiter on the lock.
  *
- * Remove the top waiter from the current tasks waiter list and wake it up.
+ * Remove the top waiter from the current tasks pi waiter list and
+ * wake it up.
  *
  * Called with lock->wait_lock held.
  */
@@ -671,10 +724,26 @@ static void wakeup_next_waiter(struct rt
 	 */
 	rt_mutex_dequeue_pi(current, waiter);
 
-	rt_mutex_set_owner(lock, NULL);
+	/*
+	 * This is safe versus the fastpath acquire:
+	 *
+	 * We do not remove the waiter from the lock waiter list
+	 * here. It stays the top waiter.
+	 *
+	 * We set the owner to NULL, but keep the RT_MUTEX_HAS_WAITERS
+	 * bit set, which forces all potential new waiters into the
+	 * slow path. So they are serialized along with all enqueued
+	 * waiters on lock->wait_lock.
+	 */
+	lock->owner = (void *) RT_MUTEX_HAS_WAITERS;
 
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
+	/*
+	 * It's safe to dereference waiter as it cannot go away as
+	 * long as we hold lock->wait_lock. The waiter task needs to
+	 * acquire it in order to dequeue the waiter.
+	 */
 	wake_up_process(waiter->task);
 }
 
@@ -928,12 +997,49 @@ rt_mutex_slowunlock(struct rt_mutex *loc
 
 	rt_mutex_deadlock_account_unlock(current);
 
-	if (!rt_mutex_has_waiters(lock)) {
-		lock->owner = NULL;
-		raw_spin_unlock(&lock->wait_lock);
-		return;
+	/*
+	 * We must be careful here if the fast path is enabled. If we
+	 * have no waiters queued we cannot set owner to NULL here
+	 * because of:
+	 *
+	 * foo->lock->owner = NULL;
+	 *			rtmutex_lock(foo->lock);   <- fast path
+	 *			free = atomic_dec_and_test(foo->refcnt);
+	 *			rtmutex_unlock(foo->lock); <- fast path
+	 *			if (free)
+	 *				kfree(foo);
+	 * raw_spin_unlock(foo->lock->wait_lock);
+	 *
+	 * So for the fastpath enabled kernel:
+	 *
+	 * Nothing can set the waiters bit as long as we hold
+	 * lock->wait_lock. So we do the following sequence:
+	 *
+	 *	owner = rt_mutex_owner(lock);
+	 *	clear_rt_mutex_waiters(lock);
+	 *	raw_spin_unlock(&lock->wait_lock);
+	 *	if (cmpxchg(&lock->owner, owner, 0) == owner)
+	 *		return;
+	 *	goto retry;
+	 *
+	 * The fastpath disabled variant is simple as all access to
+	 * lock->owner is serialized by lock->wait_lock:
+	 *
+	 *	lock->owner = NULL;
+	 *	raw_spin_unlock(&lock->wait_lock);
+	 */
+	while (!rt_mutex_has_waiters(lock)) {
+		/* Drops lock->wait_lock ! */
+		if (unlock_rt_mutex_safe(lock) == true)
+			return;
+		/* Relock the rtmutex and try again */
+		raw_spin_lock(&lock->wait_lock);
 	}
 
+	/*
+	 * The wakeup next waiter path does not suffer from the above
+	 * race. See the comments there.
+	 */
 	wakeup_next_waiter(lock);
 
 	raw_spin_unlock(&lock->wait_lock);


