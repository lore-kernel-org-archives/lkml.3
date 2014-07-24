Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbaGXJs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54997 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934604AbaGXJsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 082/128] rtmutex: Detect changes in the pi lock chain
Date: Thu, 24 Jul 2014 10:45:31 +0100
Message-Id: <1406195177-8656-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 82084984383babe728e6e3c9a8e5c46278091315 upstream.

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

[ Folded a cleanup patch from peterz ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Brad Mouring <bmouring@ni.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140605152801.930031935@linutronix.de
Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/rtmutex.c | 95 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 24 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 1029a85b2c64..ff24a43f192f 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -142,27 +142,36 @@ static void rt_mutex_adjust_prio(struct task_struct *task)
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
@@ -221,6 +230,18 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
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
@@ -306,11 +327,26 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
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
 
@@ -421,8 +457,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
-	unsigned long flags;
+	struct rt_mutex *next_lock;
 	int chain_walk = 0, res;
+	unsigned long flags;
 
 	/*
 	 * Early deadlock detection. We really don't want the task to
@@ -455,20 +492,28 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	if (!owner)
 		return 0;
 
+	raw_spin_lock_irqsave(&owner->pi_lock, flags);
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
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
@@ -480,8 +525,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 task);
+	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock,
+					 next_lock, waiter, task);
 
 	raw_spin_lock(&lock->wait_lock);
 
@@ -530,8 +575,8 @@ static void remove_waiter(struct rt_mutex *lock,
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
+	struct rt_mutex *next_lock = NULL;
 	unsigned long flags;
-	int chain_walk = 0;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
@@ -555,15 +600,15 @@ static void remove_waiter(struct rt_mutex *lock,
 		}
 		__rt_mutex_adjust_prio(owner);
 
-		if (owner->pi_blocked_on)
-			chain_walk = 1;
+		/* Store the lock on which owner is blocked or NULL */
+		next_lock = task_blocked_on_lock(owner);
 
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
 	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 
-	if (!chain_walk)
+	if (!next_lock)
 		return;
 
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
@@ -571,7 +616,7 @@ static void remove_waiter(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
+	rt_mutex_adjust_prio_chain(owner, 0, lock, next_lock, NULL, current);
 
 	raw_spin_lock(&lock->wait_lock);
 }
@@ -584,6 +629,7 @@ static void remove_waiter(struct rt_mutex *lock,
 void rt_mutex_adjust_pi(struct task_struct *task)
 {
 	struct rt_mutex_waiter *waiter;
+	struct rt_mutex *next_lock;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -593,12 +639,13 @@ void rt_mutex_adjust_pi(struct task_struct *task)
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
-- 
1.9.1

