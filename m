Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaFKSoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:34292 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbaFKSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:08 -0400
Message-Id: <20140611183853.388781896@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch V4 06/10] rtmutex: Document pi chain walk
References: <20140611182944.108526809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=rtmutex-document-chain-walk.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add commentry to document the chain walk and the protection mechanisms
and their scope.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |  100 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 91 insertions(+), 9 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -337,6 +337,48 @@ static inline struct rt_mutex *task_bloc
  * @top_task:	the current top waiter
  *
  * Returns 0 or -EDEADLK.
+ *
+ * Chain walk basics and protection scope
+ *
+ * [R] refcount on task
+ * [P] task->pi_lock held
+ * [L] rtmutex->wait_lock held
+ *
+ * Step	Description				Protected by
+ *	function arguments:
+ *	@task					[R]
+ *	@orig_lock if != NULL			@top_task is blocked on it
+ *	@next_lock				Unprotected. Cannot be
+ *						dereferenced. Only used for
+ *						comparison.
+ *	@orig_waiter if != NULL			@top_task is blocked on it
+ *	@top_task				current, or in case of proxy
+ *						locking protected by calling
+ *						code
+ *	again:
+ *	  loop_sanity_check();
+ *	retry:
+ * [1]	  lock(task->pi_lock);			[R] acquire [P]
+ * [2]	  waiter = task->pi_blocked_on;		[P]
+ * [3]	  check_exit_conditions_1();		[P]
+ * [4]	  lock = waiter->lock;			[P]
+ * [5]	  if (!try_lock(lock->wait_lock)) {	[P] try to acquire [L]
+ *	    unlock(task->pi_lock);		release [P]
+ *	    goto retry;
+ *	  }
+ * [6]	  check_exit_conditions_2();		[P] + [L]
+ * [7]	  requeue_lock_waiter(lock, waiter);	[P] + [L]
+ * [8]	  unlock(task->pi_lock);		release [P]
+ *	  put_task_struct(task);		release [R]
+ * [9]	  check_exit_conditions_3();		[L]
+ * [10]	  task = owner(lock);			[L]
+ *	  get_task_struct(task);		[L] acquire [R]
+ *	  lock(task->pi_lock);			[L] acquire [P]
+ * [11]	  requeue_pi_waiter(tsk, waiters(lock));[P] + [L]
+ * [12]	  check_exit_conditions_4();		[P] + [L]
+ * [13]	  unlock(task->pi_lock);		release [P]
+ *	  unlock(lock->wait_lock);		release [L]
+ *	  goto again;
  */
 static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 				      int deadlock_detect,
@@ -361,6 +403,9 @@ static int rt_mutex_adjust_prio_chain(st
 	 * carefully whether things change under us.
 	 */
  again:
+	/*
+	 * We limit the lock chain length for each invocation.
+	 */
 	if (++depth > max_lock_depth) {
 		static int prev_max;
 
@@ -378,13 +423,28 @@ static int rt_mutex_adjust_prio_chain(st
 
 		return -EDEADLK;
 	}
+
+	/*
+	 * We are fully preemptible here and only hold the refcount on
+	 * @task. So everything can have changed under us since the
+	 * caller or our own code below (goto retry/again) dropped all
+	 * locks.
+	 */
  retry:
 	/*
-	 * Task can not go away as we did a get_task() before !
+	 * [1] Task cannot go away as we did a get_task() before !
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
+	/*
+	 * [2] Get the waiter on which @task is blocked on.
+	 */
 	waiter = task->pi_blocked_on;
+
+	/*
+	 * [3] check_exit_conditions_1() protected by task->pi_lock.
+	 */
+
 	/*
 	 * Check whether the end of the boosting chain has been
 	 * reached or the state of the chain has changed while we
@@ -435,7 +495,15 @@ static int rt_mutex_adjust_prio_chain(st
 	if (!detect_deadlock && waiter->prio == task->prio)
 		goto out_unlock_pi;
 
+	/*
+	 * [4] Get the next lock
+	 */
 	lock = waiter->lock;
+	/*
+	 * [5] We need to trylock here as we are holding task->pi_lock,
+	 * which is the reverse lock order versus the other rtmutex
+	 * operations.
+	 */
 	if (!raw_spin_trylock(&lock->wait_lock)) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		cpu_relax();
@@ -443,6 +511,9 @@ static int rt_mutex_adjust_prio_chain(st
 	}
 
 	/*
+	 * [6] check_exit_conditions_2() protected by task->pi_lock and
+	 * lock->wait_lock.
+	 *
 	 * Deadlock detection. If the lock is the same as the original
 	 * lock which caused us to walk the lock chain or if the
 	 * current lock is owned by the task which initiated the chain
@@ -462,24 +533,27 @@ static int rt_mutex_adjust_prio_chain(st
 	 */
 	prerequeue_top_waiter = rt_mutex_top_waiter(lock);
 
-	/* Requeue the waiter in the lock waiter list. */
+	/* [7] Requeue the waiter in the lock waiter list. */
 	rt_mutex_dequeue(lock, waiter);
 	waiter->prio = task->prio;
 	rt_mutex_enqueue(lock, waiter);
 
-	/* Release the task */
+	/* [8] Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	put_task_struct(task);
 
 	/*
+	 * [9] check_exit_conditions_3 protected by lock->wait_lock.
+	 *
 	 * We must abort the chain walk if there is no lock owner even
 	 * in the dead lock detection case, as we have nothing to
 	 * follow here. This is the end of the chain we are walking.
 	 */
 	if (!rt_mutex_owner(lock)) {
 		/*
-		 * If the requeue above changed the top waiter, then we need
-		 * to wake the new top waiter up to try to get the lock.
+		 * If the requeue [7] above changed the top waiter,
+		 * then we need to wake the new top waiter up to try
+		 * to get the lock.
 		 */
 		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
@@ -487,11 +561,12 @@ static int rt_mutex_adjust_prio_chain(st
 		return 0;
 	}
 
-	/* Grab the next task, i.e. the owner of @lock */
+	/* [10] Grab the next task, i.e. the owner of @lock */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
+	/* [11] requeue the pi waiters if necessary */
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/*
 		 * The waiter became the new top (highest priority)
@@ -526,23 +601,30 @@ static int rt_mutex_adjust_prio_chain(st
 	}
 
 	/*
+	 * [12] check_exit_conditions_4() protected by task->pi_lock
+	 * and lock->wait_lock. The actual decisions are made after we
+	 * dropped the locks.
+	 *
 	 * Check whether the task which owns the current lock is pi
 	 * blocked itself. If yes we store a pointer to the lock for
 	 * the lock chain change detection above. After we dropped
 	 * task->pi_lock next_lock cannot be dereferenced anymore.
 	 */
 	next_lock = task_blocked_on_lock(task);
-
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-
 	/*
 	 * Store the top waiter of @lock for the end of chain walk
 	 * decision below.
 	 */
 	top_waiter = rt_mutex_top_waiter(lock);
+
+	/* [13] Drop the locks */
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	raw_spin_unlock(&lock->wait_lock);
 
 	/*
+	 * Make the actual exit decisions [12], based on the stored
+	 * values.
+	 *
 	 * We reached the end of the lock chain. Stop right here. No
 	 * point to go back just to figure that out.
 	 */


