Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaFEP2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:28:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:49932 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaFEP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:28:35 -0400
Message-Id: <20140605152801.930031935@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 15:28:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Brad Mouring <bmouring@ni.com>
Subject: [patch 2/2] rtmutex: Detect changes in the pi lock chain
References: <20140605152544.641846795@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=rtmutex-detect-lock-chain-changes.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we walk the lock chain, we drop all locks after each step. So the
lock chain can change under us before we reacquire the locks. That's
harmless in principle as we just follow the wrong lock path. But it
can lead to a false positive in the dead lock detection logic:

T0 holds L0
T0 blocks on L1 held by T1
T1 blocks on L2 held by T2
T2 blocks on L3 held by T3
T4 blocks on L4 held by T4

Now we walk the chain

lock T1 -> lock L2 -> adjust L2 -> unlock T1 -> 
     lock T2 ->  adjust T2 ->  drop locks

T2 times out and blocks on L0

Now we continue:

lock T2 -> lock L0 -> deadlock detected, but it's not a deadlock at all.

Brad tried to work around that in the deadlock detection logic itself,
but the more I looked at it the less I liked it, because it's crystal
ball magic after the fact.

We actually can detect a chain change very simple:

lock T1 -> lock L2 -> adjust L2 -> unlock T1 -> lock T2 -> adjust T2 ->

     next_lock = T2->pi_blocked_on->lock;

drop locks

T2 times out and blocks on L0

Now we continue:

lock T2 -> 

     if (next_lock != T2->pi_blocked_on->lock)
     	   return;

So if we detect that T2 is now blocked on a different lock we stop the
chain walk. That's also correct in the following scenario:

lock T1 -> lock L2 -> adjust L2 -> unlock T1 -> lock T2 -> adjust T2 ->

     next_lock = T2->pi_blocked_on->lock;

drop locks

T3 times out and drops L3
T2 acquires L3 and blocks on L4 now

Now we continue:

lock T2 -> 

     if (next_lock != T2->pi_blocked_on->lock)
     	   return;

We don't have to follow up the chain at that point, because T2
propagated our priority up to T4 already.

Reported-by: Brad Mouring <bmouring@ni.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   84 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 23 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -264,23 +264,27 @@ int max_lock_depth = 1024;
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
@@ -339,6 +343,18 @@ static int rt_mutex_adjust_prio_chain(st
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
@@ -422,11 +438,28 @@ static int rt_mutex_adjust_prio_chain(st
 		__rt_mutex_adjust_prio(task);
 	}
 
+	/*
+	 * Check whether the task which owns the current lock is pi
+	 * blocked itself. If yes we store a pointer to the lock for
+	 * the lock chain change detection above.
+	 */
+	if (task->pi_blocked_on)
+		next_lock = task->pi_blocked_on->lock;
+	else
+		next_lock = NULL;
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
 
@@ -536,8 +569,9 @@ static int task_blocks_on_rt_mutex(struc
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
+	struct rt_mutex *next_lock = NULL;
 	unsigned long flags;
-	int chain_walk = 0, res;
+	int chain_walk, res;
 
 	/*
 	 * Early deadlock detection. We really don't want the task to
@@ -569,19 +603,21 @@ static int task_blocks_on_rt_mutex(struc
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
+	if (owner->pi_blocked_on)
+		next_lock = owner->pi_blocked_on->lock;
 
+	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	if (!chain_walk)
 		return 0;
 
@@ -594,8 +630,8 @@ static int task_blocks_on_rt_mutex(struc
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 task);
+	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock,
+					 next_lock, waiter, task);
 
 	raw_spin_lock(&lock->wait_lock);
 
@@ -644,8 +680,8 @@ static void remove_waiter(struct rt_mute
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
+	struct rt_mutex *next_lock = NULL;
 	unsigned long flags;
-	int chain_walk = 0;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 	rt_mutex_dequeue(lock, waiter);
@@ -670,12 +706,12 @@ static void remove_waiter(struct rt_mute
 		__rt_mutex_adjust_prio(owner);
 
 		if (owner->pi_blocked_on)
-			chain_walk = 1;
+			next_lock = owner->pi_blocked_on->lock;
 
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
-	if (!chain_walk)
+	if (!next_lock)
 		return;
 
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
@@ -683,7 +719,7 @@ static void remove_waiter(struct rt_mute
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
+	rt_mutex_adjust_prio_chain(owner, 0, lock, next_lock, NULL, current);
 
 	raw_spin_lock(&lock->wait_lock);
 }
@@ -696,6 +732,7 @@ static void remove_waiter(struct rt_mute
 void rt_mutex_adjust_pi(struct task_struct *task)
 {
 	struct rt_mutex_waiter *waiter;
+	struct rt_mutex *next_lock;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -706,12 +743,13 @@ void rt_mutex_adjust_pi(struct task_stru
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
@@ -764,7 +802,7 @@ __rt_mutex_slowlock(struct rt_mutex *loc
 }
 
 static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
-				     struct rtmutex_waiter *w)
+				     struct rt_mutex_waiter *w)
 {
 	/*
 	 * If the result is not -EDEADLOCK or the caller requested


