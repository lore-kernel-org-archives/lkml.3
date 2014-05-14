Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaENUDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:03:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:47699 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaENUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:03:13 -0400
Message-Id: <20140514200104.670614672@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 14 May 2014 20:03:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch 2/2] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
References: <20140514195705.618583609@linutronix.de>
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
 kernel/locking/rtmutex.c |   47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/locking/rtmutex.c
===================================================================
--- linux-2.6.orig/kernel/locking/rtmutex.c
+++ linux-2.6/kernel/locking/rtmutex.c
@@ -284,10 +284,11 @@ static int rt_mutex_adjust_prio_chain(st
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
-	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
 	int detect_deadlock, ret = 0, depth = 0;
+	struct rt_mutex *lock;
 	unsigned long flags;
+	int requeue = 1;
 
 	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
 							 deadlock_detect);
@@ -350,6 +351,7 @@ static int rt_mutex_adjust_prio_chain(st
 		if (top_waiter != task_top_pi_waiter(task)) {
 			if (!detect_deadlock)
 				goto out_unlock_pi;
+			requeue = 0;
 		}
 	}
 
@@ -360,6 +362,7 @@ static int rt_mutex_adjust_prio_chain(st
 	if (waiter->prio == task->prio) {
 		if (!detect_deadlock)
 			goto out_unlock_pi;
+		requeue = 0;
 	}
 
 	lock = waiter->lock;
@@ -379,19 +382,25 @@ static int rt_mutex_adjust_prio_chain(st
 
 	top_waiter = rt_mutex_top_waiter(lock);
 
-	/* Requeue the waiter */
-	rt_mutex_dequeue(lock, waiter);
-	waiter->prio = task->prio;
-	rt_mutex_enqueue(lock, waiter);
+	if (requeue) {
+		/* Requeue the waiter */
+		rt_mutex_dequeue(lock, waiter);
+		waiter->prio = task->prio;
+		rt_mutex_enqueue(lock, waiter);
+	}
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	/*
+	 * We must abort the chain walk if there is no lock owner even
+	 * in the dead lock detection case, as we have nothing to
+	 * follow here.
+	 */
 	if (!rt_mutex_owner(lock)) {
 		/*
 		 * If the requeue above changed the top waiter, then we need
 		 * to wake the new top waiter up to try to get the lock.
 		 */
-
 		if (top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
 		raw_spin_unlock(&lock->wait_lock);
@@ -404,18 +413,20 @@ static int rt_mutex_adjust_prio_chain(st
 	get_task_struct(task);
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
-	if (waiter == rt_mutex_top_waiter(lock)) {
-		/* Boost the owner */
-		rt_mutex_dequeue_pi(task, top_waiter);
-		rt_mutex_enqueue_pi(task, waiter);
-		__rt_mutex_adjust_prio(task);
-
-	} else if (top_waiter == waiter) {
-		/* Deboost the owner */
-		rt_mutex_dequeue_pi(task, waiter);
-		waiter = rt_mutex_top_waiter(lock);
-		rt_mutex_enqueue_pi(task, waiter);
-		__rt_mutex_adjust_prio(task);
+	if (requeue) {
+		if (waiter == rt_mutex_top_waiter(lock)) {
+			/* Boost the owner */
+			rt_mutex_dequeue_pi(task, top_waiter);
+			rt_mutex_enqueue_pi(task, waiter);
+			__rt_mutex_adjust_prio(task);
+
+		} else if (top_waiter == waiter) {
+			/* Deboost the owner */
+			rt_mutex_dequeue_pi(task, waiter);
+			waiter = rt_mutex_top_waiter(lock);
+			rt_mutex_enqueue_pi(task, waiter);
+			__rt_mutex_adjust_prio(task);
+		}
 	}
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);


