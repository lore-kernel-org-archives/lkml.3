Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaEaP6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:58:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:34404 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaEaP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:57:53 -0400
Message-Id: <20140531155739.518873369@linutronix.de>
User-Agent: quilt/0.63-1
Date: Sat, 31 May 2014 15:57:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: [patch v2 5/5] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
References: <20140531155229.493650009@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rtmutex-avoid-pointless-requeueing-in-the-deadlock-detection-chain-walk.patch
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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/20140522031950.280830190@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |  107 ++++++++++++++++++++++++++++-------------------
 1 file changed, 66 insertions(+), 41 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -309,6 +309,7 @@ static int rt_mutex_adjust_prio_chain(st
 	int ret = 0, depth = 0;
 	struct rt_mutex *lock;
 	unsigned long flags;
+	bool requeue = true;
 
 	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter,
 							deadlock_detect);
@@ -369,18 +370,29 @@ static int rt_mutex_adjust_prio_chain(st
 			goto out_unlock_pi;
 		/*
 		 * If deadlock detection is off, we stop here if we
-		 * are not the top pi waiter of the task.
-		 */
-		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
-			goto out_unlock_pi;
+		 * are not the top pi waiter of the task. If deadlock
+		 * detection is enabled we continue, but stop the
+		 * requeueing in the chain walk.
+		 */
+		if (top_waiter != task_top_pi_waiter(task)) {
+			if (!detect_deadlock)
+				goto out_unlock_pi;
+			requeue = false;
+		}
 	}
 
 	/*
-	 * When deadlock detection is off then we check, if further
-	 * priority adjustment is necessary.
+	 * If the waiter priority is the same as the task priority
+	 * then there is no further priority adjustment necessary.  If
+	 * deadlock detection is off, we stop the chain walk. If its
+	 * enable we continue, but stop the requeueing in the chain
+	 * walk.
 	 */
-	if (!detect_deadlock && waiter->prio == task->prio)
-		goto out_unlock_pi;
+	if (waiter->prio == task->prio) {
+		if (!detect_deadlock)
+			goto out_unlock_pi;
+		requeue = false;
+	}
 
 	/*
 	 * We need to trylock here as we are holding task->pi_lock,
@@ -413,10 +425,16 @@ static int rt_mutex_adjust_prio_chain(st
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
@@ -431,7 +449,8 @@ static int rt_mutex_adjust_prio_chain(st
 		 * If the requeue above changed the top waiter, then we need
 		 * to wake the new top waiter up to try to get the lock.
 		 */
-		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
+		if (requeue &&
+		    prerequeue_top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
 		raw_spin_unlock(&lock->wait_lock);
 		goto out_put_task;
@@ -441,38 +460,44 @@ static int rt_mutex_adjust_prio_chain(st
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
-	if (waiter == rt_mutex_top_waiter(lock)) {
-		/*
-		 * The waiter became the new top (highest priority)
-		 * waiter on the lock. Replace the previous top waiter
-		 * in the owner tasks pi waiters list with this waiter.
-		 */
-		rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
-		rt_mutex_enqueue_pi(task, waiter);
-		__rt_mutex_adjust_prio(task);
+	if (requeue) {
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
 
-	} else if (prerequeue_top_waiter == waiter) {
-		/*
-		 * The waiter was the top waiter on the lock, but is
-		 * no longer the top prority waiter. Replace waiter in
-		 * the owner tasks pi waiters list with the new top
-		 * (highest priority) waiter.
-		 */
-		rt_mutex_dequeue_pi(task, waiter);
-		waiter = rt_mutex_top_waiter(lock);
-		rt_mutex_enqueue_pi(task, waiter);
-		__rt_mutex_adjust_prio(task);
+		if (waiter == rt_mutex_top_waiter(lock)) {
+			/*
+			 * The waiter became the new top (highest
+			 * priority) waiter on the lock. Replace the
+			 * previous top waiter in the owner tasks pi
+			 * waiters list with this waiter.
+			 */
+			rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
+			rt_mutex_enqueue_pi(task, waiter);
+			__rt_mutex_adjust_prio(task);
+
+		} else if (prerequeue_top_waiter == waiter) {
+			/*
+			 * The waiter was the top waiter on the lock,
+			 * but is no longer the top prority
+			 * waiter. Replace waiter in the owner tasks
+			 * pi waiters list with the new top (highest
+			 * priority) waiter.
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
 
-	} else {
-		/*
-		 * Nothing changed. No need to do any priority
-		 * adjustment.
-		 */
-	}
+		}
 
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	}
 
 	top_waiter = rt_mutex_top_waiter(lock);
 	raw_spin_unlock(&lock->wait_lock);


