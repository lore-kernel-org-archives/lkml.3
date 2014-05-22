Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaEVDZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:25:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:46267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEVDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:25:46 -0400
Message-Id: <20140522031950.280830190@linutronix.de>
User-Agent: quilt/0.60-1
Date: Thu, 22 May 2014 03:25:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 6/6] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
References: <20140522031841.797415507@linutronix.de>
Content-Disposition: inline; filename=rtmutex-avoid-pointless-requeueing.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the dead lock detector is enabled we follow the lock chain to
the end in rt_mutex_adjust_prio_chain, even if we could stop earlier
due to the priority/waiter constellation.

But once we are not longer the top priority waiter in a certain step
or the task holding the lock has already the same priority then there
is no point in dequeing and enqueing along the lock chain as there is
no change at all.

So stop the queueing at this point.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   87 +++++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -307,6 +307,7 @@ static int rt_mutex_adjust_prio_chain(st
 	int detect_deadlock, ret = 0, depth = 0;
 	struct rt_mutex *lock;
 	unsigned long flags;
+	bool requeue = true;
 
 	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter,
 							deadlock_detect);
@@ -366,8 +367,11 @@ static int rt_mutex_adjust_prio_chain(st
 		if (!task_has_pi_waiters(task))
 			goto out_unlock_pi;
 
-		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
-			goto out_unlock_pi;
+		if (top_waiter != task_top_pi_waiter(task)) {
+			if (!detect_deadlock)
+				goto out_unlock_pi;
+			requeue = false;
+		}
 	}
 
 	/*
@@ -377,6 +381,7 @@ static int rt_mutex_adjust_prio_chain(st
 	if (waiter->prio == task->prio) {
 		if (!detect_deadlock)
 			goto out_unlock_pi;
+		requeue = false;
 	}
 
 	lock = waiter->lock;
@@ -410,10 +415,16 @@ static int rt_mutex_adjust_prio_chain(st
 	 */
 	prerequeue_top_waiter = rt_mutex_top_waiter(lock);
 
-	/* Requeue the waiter */
-	rt_mutex_dequeue(lock, waiter);
-	waiter->prio = task->prio;
-	rt_mutex_enqueue(lock, waiter);
+	/*
+	 * Requeue the waiter, if we are in the boost/deboost
+	 * operation and not just following the lock chain for
+	 * deadlock detection.
+	 */
+	if (requeue) {
+		rt_mutex_dequeue(lock, waiter);
+		waiter->prio = task->prio;
+		rt_mutex_enqueue(lock, waiter);
+	}
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -428,7 +439,8 @@ static int rt_mutex_adjust_prio_chain(st
 		 * If the requeue above changed the top waiter, then we need
 		 * to wake the new top waiter up to try to get the lock.
 		 */
-		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
+		if (requeue &&
+		    prerequeue_top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
 		raw_spin_unlock(&lock->wait_lock);
 		goto out_put_task;
@@ -440,32 +452,41 @@ static int rt_mutex_adjust_prio_chain(st
 	get_task_struct(task);
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
-	if (waiter == rt_mutex_top_waiter(lock)) {
-		/*
-		 * The waiter became the top waiter on the
-		 * lock. Remove the previous top waiter from the tasks
-		 * pi waiters list and add waiter to it.
-		 */
-		rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
-		rt_mutex_enqueue_pi(task, waiter);
-		__rt_mutex_adjust_prio(task);
-
-	} else if (prerequeue_top_waiter == waiter) {
-		/*
-		 * The waiter was the top waiter on the lock. Remove
-		 * waiter from the tasks pi waiters list and add the
-		 * new top waiter to it.
-		 */
-		rt_mutex_dequeue_pi(task, waiter);
-		waiter = rt_mutex_top_waiter(lock);
-		rt_mutex_enqueue_pi(task, waiter);
-		__rt_mutex_adjust_prio(task);
-
-	} else {
-		/*
-		 * Nothing changed. No need to do any priority
-		 * adjustment.
-		 */
+	/*
+	 * In case we are just following the lock chain for deadlock
+	 * detection we can avoid the whole requeue and priority
+	 * adjustment business.
+	 */
+	if (requeue) {
+		if (waiter == rt_mutex_top_waiter(lock)) {
+			/*
+			 * The waiter became the top waiter on the
+			 * lock. Remove the previous top waiter from
+			 * the tasks pi waiters list and add waiter to
+			 * it.
+			 */
+			rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
+			rt_mutex_enqueue_pi(task, waiter);
+			__rt_mutex_adjust_prio(task);
+
+		} else if (prerequeue_top_waiter == waiter) {
+			/*
+			 * The waiter was the top waiter on the
+			 * lock. Remove waiter from the tasks pi
+			 * waiters list and add the new top waiter to
+			 * it.
+			 */
+			rt_mutex_dequeue_pi(task, waiter);
+			waiter = rt_mutex_top_waiter(lock);
+			rt_mutex_enqueue_pi(task, waiter);
+			__rt_mutex_adjust_prio(task);
+
+		} else {
+			/*
+			 * Nothing changed. No need to do any priority
+			 * adjustment.
+			 */
+		}
 	}
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);


