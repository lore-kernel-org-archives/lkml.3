Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354AbaFTJRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:17:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:57695 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaFTJRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:17:15 -0400
Date: Fri, 20 Jun 2014 11:17:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT pull] locking fixes for 3.16
Message-ID: <alpine.DEB.2.10.1406201111270.5170@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest locking-urgent-for-linus.patch git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking-urgent-for-linus.patch

Another three patches to make the rtmutex code more robust. That's the
last urgent fallout from the big futex/rtmutex investigation.

Thanks,

	tglx

------------------>
Thomas Gleixner (3):
      rtmutex: Handle deadlock detection smarter
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Plug slow unlock race


 kernel/locking/rtmutex-debug.h |   5 +
 kernel/locking/rtmutex.c       | 243 +++++++++++++++++++++++++++++++++++------
 kernel/locking/rtmutex.h       |   5 +
 3 files changed, 218 insertions(+), 35 deletions(-)

diff --git a/kernel/locking/rtmutex-debug.h b/kernel/locking/rtmutex-debug.h
index 14193d5..ab29b6a 100644
--- a/kernel/locking/rtmutex-debug.h
+++ b/kernel/locking/rtmutex-debug.h
@@ -31,3 +31,8 @@ static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
 {
 	return (waiter != NULL);
 }
+
+static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	debug_rt_mutex_print_deadlock(w);
+}
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index a620d4d..fc60594 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -83,6 +83,47 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
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
@@ -90,6 +131,17 @@ static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
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
@@ -260,27 +312,36 @@ static void rt_mutex_adjust_prio(struct task_struct *task)
  */
 int max_lock_depth = 1024;
 
+static inline struct rt_mutex *task_blocked_on_lock(struct task_struct *p)
+{
+	return p->pi_blocked_on ? p->pi_blocked_on->lock : NULL;
+}
+
 /*
  * Adjust the priority chain. Also used for deadlock detection.
  * Decreases task's usage by one - may thus free the task.
  *
- * @task: the task owning the mutex (owner) for which a chain walk is probably
- *	  needed
+ * @task:	the task owning the mutex (owner) for which a chain walk is
+ *		probably needed
  * @deadlock_detect: do we have to carry out deadlock detection?
- * @orig_lock: the mutex (can be NULL if we are walking the chain to recheck
- * 	       things for a task that has just got its priority adjusted, and
- *	       is waiting on a mutex)
+ * @orig_lock:	the mutex (can be NULL if we are walking the chain to recheck
+ *		things for a task that has just got its priority adjusted, and
+ *		is waiting on a mutex)
+ * @next_lock:	the mutex on which the owner of @orig_lock was blocked before
+ *		we dropped its pi_lock. Is never dereferenced, only used for
+ *		comparison to detect lock chain changes.
  * @orig_waiter: rt_mutex_waiter struct for the task that has just donated
- *		 its priority to the mutex owner (can be NULL in the case
- *		 depicted above or if the top waiter is gone away and we are
- *		 actually deboosting the owner)
- * @top_task: the current top waiter
+ *		its priority to the mutex owner (can be NULL in the case
+ *		depicted above or if the top waiter is gone away and we are
+ *		actually deboosting the owner)
+ * @top_task:	the current top waiter
  *
  * Returns 0 or -EDEADLK.
  */
 static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 				      int deadlock_detect,
 				      struct rt_mutex *orig_lock,
+				      struct rt_mutex *next_lock,
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
@@ -314,7 +375,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		}
 		put_task_struct(task);
 
-		return deadlock_detect ? -EDEADLK : 0;
+		return -EDEADLK;
 	}
  retry:
 	/*
@@ -339,6 +400,18 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		goto out_unlock_pi;
 
 	/*
+	 * We dropped all locks after taking a refcount on @task, so
+	 * the task might have moved on in the lock chain or even left
+	 * the chain completely and blocks now on an unrelated lock or
+	 * on @orig_lock.
+	 *
+	 * We stored the lock on which @task was blocked in @next_lock,
+	 * so we can detect the chain change.
+	 */
+	if (next_lock != waiter->lock)
+		goto out_unlock_pi;
+
+	/*
 	 * Drop out, when the task has no waiters. Note,
 	 * top_waiter can be NULL, when we are in the deboosting
 	 * mode!
@@ -377,7 +450,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
-		ret = deadlock_detect ? -EDEADLK : 0;
+		ret = -EDEADLK;
 		goto out_unlock_pi;
 	}
 
@@ -422,11 +495,26 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		__rt_mutex_adjust_prio(task);
 	}
 
+	/*
+	 * Check whether the task which owns the current lock is pi
+	 * blocked itself. If yes we store a pointer to the lock for
+	 * the lock chain change detection above. After we dropped
+	 * task->pi_lock next_lock cannot be dereferenced anymore.
+	 */
+	next_lock = task_blocked_on_lock(task);
+
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	top_waiter = rt_mutex_top_waiter(lock);
 	raw_spin_unlock(&lock->wait_lock);
 
+	/*
+	 * We reached the end of the lock chain. Stop right here. No
+	 * point to go back just to figure that out.
+	 */
+	if (!next_lock)
+		goto out_put_task;
+
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
 
@@ -536,8 +624,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
-	unsigned long flags;
+	struct rt_mutex *next_lock;
 	int chain_walk = 0, res;
+	unsigned long flags;
 
 	/*
 	 * Early deadlock detection. We really don't want the task to
@@ -548,7 +637,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 * which is wrong, as the other waiter is not in a deadlock
 	 * situation.
 	 */
-	if (detect_deadlock && owner == task)
+	if (owner == task)
 		return -EDEADLK;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -569,20 +658,28 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	if (!owner)
 		return 0;
 
+	raw_spin_lock_irqsave(&owner->pi_lock, flags);
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 		rt_mutex_dequeue_pi(owner, top_waiter);
 		rt_mutex_enqueue_pi(owner, waiter);
 
 		__rt_mutex_adjust_prio(owner);
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
-	}
-	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
+	} else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock)) {
 		chain_walk = 1;
+	}
 
-	if (!chain_walk)
+	/* Store the lock on which owner is blocked or NULL */
+	next_lock = task_blocked_on_lock(owner);
+
+	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+	/*
+	 * Even if full deadlock detection is on, if the owner is not
+	 * blocked itself, we can avoid finding this out in the chain
+	 * walk.
+	 */
+	if (!chain_walk || !next_lock)
 		return 0;
 
 	/*
@@ -594,8 +691,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 task);
+	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock,
+					 next_lock, waiter, task);
 
 	raw_spin_lock(&lock->wait_lock);
 
@@ -605,7 +702,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 /*
  * Wake up the next waiter on the lock.
  *
- * Remove the top waiter from the current tasks waiter list and wake it up.
+ * Remove the top waiter from the current tasks pi waiter list and
+ * wake it up.
  *
  * Called with lock->wait_lock held.
  */
@@ -626,10 +724,23 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	 */
 	rt_mutex_dequeue_pi(current, waiter);
 
-	rt_mutex_set_owner(lock, NULL);
+	/*
+	 * As we are waking up the top waiter, and the waiter stays
+	 * queued on the lock until it gets the lock, this lock
+	 * obviously has waiters. Just set the bit here and this has
+	 * the added benefit of forcing all new tasks into the
+	 * slow path making sure no task of lower priority than
+	 * the top waiter can steal this lock.
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
 
@@ -644,8 +755,8 @@ static void remove_waiter(struct rt_mutex *lock,
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
+	struct rt_mutex *next_lock = NULL;
 	unsigned long flags;
-	int chain_walk = 0;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 	rt_mutex_dequeue(lock, waiter);
@@ -669,13 +780,13 @@ static void remove_waiter(struct rt_mutex *lock,
 		}
 		__rt_mutex_adjust_prio(owner);
 
-		if (owner->pi_blocked_on)
-			chain_walk = 1;
+		/* Store the lock on which owner is blocked or NULL */
+		next_lock = task_blocked_on_lock(owner);
 
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
-	if (!chain_walk)
+	if (!next_lock)
 		return;
 
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
@@ -683,7 +794,7 @@ static void remove_waiter(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
+	rt_mutex_adjust_prio_chain(owner, 0, lock, next_lock, NULL, current);
 
 	raw_spin_lock(&lock->wait_lock);
 }
@@ -696,6 +807,7 @@ static void remove_waiter(struct rt_mutex *lock,
 void rt_mutex_adjust_pi(struct task_struct *task)
 {
 	struct rt_mutex_waiter *waiter;
+	struct rt_mutex *next_lock;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -706,12 +818,13 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
-
+	next_lock = waiter->lock;
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(task);
-	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
+
+	rt_mutex_adjust_prio_chain(task, 0, NULL, next_lock, NULL, task);
 }
 
 /**
@@ -763,6 +876,26 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	return ret;
 }
 
+static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
+				     struct rt_mutex_waiter *w)
+{
+	/*
+	 * If the result is not -EDEADLOCK or the caller requested
+	 * deadlock detection, nothing to do here.
+	 */
+	if (res != -EDEADLOCK || detect_deadlock)
+		return;
+
+	/*
+	 * Yell lowdly and stop the task right here.
+	 */
+	rt_mutex_print_deadlock(w);
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+}
+
 /*
  * Slow path lock function:
  */
@@ -802,8 +935,10 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		remove_waiter(lock, &waiter);
+		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
+	}
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -859,12 +994,49 @@ rt_mutex_slowunlock(struct rt_mutex *lock)
 
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
@@ -1112,7 +1284,8 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	/* We enforce deadlock detection for futexes */
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
diff --git a/kernel/locking/rtmutex.h b/kernel/locking/rtmutex.h
index a1a1dd0..f6a1f3c 100644
--- a/kernel/locking/rtmutex.h
+++ b/kernel/locking/rtmutex.h
@@ -24,3 +24,8 @@
 #define debug_rt_mutex_print_deadlock(w)		do { } while (0)
 #define debug_rt_mutex_detect_deadlock(w,d)		(d)
 #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
+
+static inline void rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	WARN(1, "rtmutex deadlock detected\n");
+}
