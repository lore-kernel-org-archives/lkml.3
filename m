Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaFKSr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:47:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:34287 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaFKSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:08 -0400
Message-Id: <20140611183853.297793547@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch V4 05/10] rtmutex: Clarify the boost/deboost part
References: <20140611182944.108526809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=rtmutex-clarify-the-lock-chain-walk.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a separate local variable for the boost/deboost logic to make the
code more readable. Add comments where appropriate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   58 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 10 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -345,9 +345,10 @@ static int rt_mutex_adjust_prio_chain(st
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
-	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
+	struct rt_mutex_waiter *prerequeue_top_waiter;
 	int detect_deadlock, ret = 0, depth = 0;
+	struct rt_mutex *lock;
 	unsigned long flags;
 
 	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
@@ -454,9 +455,14 @@ static int rt_mutex_adjust_prio_chain(st
 		goto out_unlock_pi;
 	}
 
-	top_waiter = rt_mutex_top_waiter(lock);
+	/*
+	 * Store the current top waiter before doing the requeue
+	 * operation on @lock. We need it for the boost/deboost
+	 * decision below.
+	 */
+	prerequeue_top_waiter = rt_mutex_top_waiter(lock);
 
-	/* Requeue the waiter */
+	/* Requeue the waiter in the lock waiter list. */
 	rt_mutex_dequeue(lock, waiter);
 	waiter->prio = task->prio;
 	rt_mutex_enqueue(lock, waiter);
@@ -465,35 +471,58 @@ static int rt_mutex_adjust_prio_chain(st
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	put_task_struct(task);
 
+	/*
+	 * We must abort the chain walk if there is no lock owner even
+	 * in the dead lock detection case, as we have nothing to
+	 * follow here. This is the end of the chain we are walking.
+	 */
 	if (!rt_mutex_owner(lock)) {
 		/*
 		 * If the requeue above changed the top waiter, then we need
 		 * to wake the new top waiter up to try to get the lock.
 		 */
-
-		if (top_waiter != rt_mutex_top_waiter(lock))
+		if (prerequeue_top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
 		raw_spin_unlock(&lock->wait_lock);
 		return 0;
 	}
 
-	/* Grab the next task */
+	/* Grab the next task, i.e. the owner of @lock */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		/* Boost the owner */
-		rt_mutex_dequeue_pi(task, top_waiter);
+		/*
+		 * The waiter became the new top (highest priority)
+		 * waiter on the lock. Replace the previous top waiter
+		 * in the owner tasks pi waiters list with this waiter
+		 * and adjust the priority of the owner.
+		 */
+		rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
 		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 
-	} else if (top_waiter == waiter) {
-		/* Deboost the owner */
+	} else if (prerequeue_top_waiter == waiter) {
+		/*
+		 * The waiter was the top waiter on the lock, but is
+		 * no longer the top prority waiter. Replace waiter in
+		 * the owner tasks pi waiters list with the new top
+		 * (highest priority) waiter and adjust the priority
+		 * of the owner.
+		 * The new top waiter is stored in @waiter so that
+		 * @waiter == @top_waiter evaluates to true below and
+		 * we continue to deboost the rest of the chain.
+		 */
 		rt_mutex_dequeue_pi(task, waiter);
 		waiter = rt_mutex_top_waiter(lock);
 		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
+	} else {
+		/*
+		 * Nothing changed. No need to do any priority
+		 * adjustment.
+		 */
 	}
 
 	/*
@@ -506,6 +535,10 @@ static int rt_mutex_adjust_prio_chain(st
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
+	/*
+	 * Store the top waiter of @lock for the end of chain walk
+	 * decision below.
+	 */
 	top_waiter = rt_mutex_top_waiter(lock);
 	raw_spin_unlock(&lock->wait_lock);
 
@@ -516,6 +549,11 @@ static int rt_mutex_adjust_prio_chain(st
 	if (!next_lock)
 		goto out_put_task;
 
+	/*
+	 * If the current waiter is not the top waiter on the lock,
+	 * then we can stop the chain walk here if we are not in full
+	 * deadlock detection mode.
+	 */
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
 


