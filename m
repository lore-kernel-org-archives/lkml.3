Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaFKSqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:46:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:34321 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaFKSoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:11 -0400
Message-Id: <20140611183853.734541303@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch V4 10/10] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
References: <20140611182944.108526809@linutronix.de>
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
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/20140522031950.280830190@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   77 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 7 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -412,6 +412,7 @@ static int rt_mutex_adjust_prio_chain(st
 	struct rt_mutex *lock;
 	bool detect_deadlock;
 	unsigned long flags;
+	bool requeue = true;
 
 	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter, chwalk);
 
@@ -501,18 +502,31 @@ static int rt_mutex_adjust_prio_chain(st
 			goto out_unlock_pi;
 		/*
 		 * If deadlock detection is off, we stop here if we
-		 * are not the top pi waiter of the task.
+		 * are not the top pi waiter of the task. If deadlock
+		 * detection is enabled we continue, but stop the
+		 * requeueing in the chain walk.
 		 */
-		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
-			goto out_unlock_pi;
+		if (top_waiter != task_top_pi_waiter(task)) {
+			if (!detect_deadlock)
+				goto out_unlock_pi;
+			else
+				requeue = false;
+		}
 	}
 
 	/*
-	 * When deadlock detection is off then we check, if further
-	 * priority adjustment is necessary.
+	 * If the waiter priority is the same as the task priority
+	 * then there is no further priority adjustment necessary.  If
+	 * deadlock detection is off, we stop the chain walk. If its
+	 * enabled we continue, but stop the requeueing in the chain
+	 * walk.
 	 */
-	if (!detect_deadlock && waiter->prio == task->prio)
-		goto out_unlock_pi;
+	if (waiter->prio == task->prio) {
+		if (!detect_deadlock)
+			goto out_unlock_pi;
+		else
+			requeue = false;
+	}
 
 	/*
 	 * [4] Get the next lock
@@ -546,6 +560,55 @@ static int rt_mutex_adjust_prio_chain(st
 	}
 
 	/*
+	 * If we just follow the lock chain for deadlock detection, no
+	 * need to do all the requeue operations. To avoid a truckload
+	 * of conditionals around the various places below, just do the
+	 * minimum chain walk checks.
+	 */
+	if (!requeue) {
+		/*
+		 * No requeue[7] here. Just release @task [8]
+		 */
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		put_task_struct(task);
+
+		/*
+		 * [9] check_exit_conditions_3 protected by lock->wait_lock.
+		 * If there is no owner of the lock, end of chain.
+		 */
+		if (!rt_mutex_owner(lock)) {
+			raw_spin_unlock(&lock->wait_lock);
+			return 0;
+		}
+
+		/* [10] Grab the next task, i.e. owner of @lock */
+		task = rt_mutex_owner(lock);
+		get_task_struct(task);
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+		/*
+		 * No requeue [11] here. We just do deadlock detection.
+		 *
+		 * Get the top waiter for the next iteration
+		 */
+		top_waiter = rt_mutex_top_waiter(lock);
+
+		/*
+		 * [12] Store whether owner is blocked
+		 * itself. Decision is made after dropping the locks
+		 */
+		next_lock = task_blocked_on_lock(task);
+		/* [13] Drop locks */
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
+
+		/* If owner is not blocked, end of chain. */
+		if (!next_lock)
+			goto out_put_task;
+		goto again;
+	}
+
+	/*
 	 * Store the current top waiter before doing the requeue
 	 * operation on @lock. We need it for the boost/deboost
 	 * decision below.


