Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaEaP5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:57:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:34398 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEaP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:57:53 -0400
Message-Id: <20140531155739.430525601@linutronix.de>
User-Agent: quilt/0.63-1
Date: Sat, 31 May 2014 15:57:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: [patch v2 4/5] rtmutex: Clarify the lock chain walk
References: <20140531155229.493650009@linutronix.de>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/20140522031950.168005692@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   51 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -303,10 +303,11 @@ static int rt_mutex_adjust_prio_chain(st
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
-	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
+	struct rt_mutex_waiter *prerequeue_top_waiter;
 	enum rtmutex_chainwalk detect_deadlock;
 	int ret = 0, depth = 0;
+	struct rt_mutex *lock;
 	unsigned long flags;
 
 	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter,
@@ -381,6 +382,11 @@ static int rt_mutex_adjust_prio_chain(st
 	if (!detect_deadlock && waiter->prio == task->prio)
 		goto out_unlock_pi;
 
+	/*
+	 * We need to trylock here as we are holding task->pi_lock,
+	 * which is the reverse lock order versus the other rtmutex
+	 * operations.
+	 */
 	lock = waiter->lock;
 	if (!raw_spin_trylock(&lock->wait_lock)) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -401,7 +407,11 @@ static int rt_mutex_adjust_prio_chain(st
 		goto out_unlock_pi;
 	}
 
-	top_waiter = rt_mutex_top_waiter(lock);
+	/*
+	 * Store the top waiter before doing any requeue operation. We
+	 * need it for the boost/deboost decision below.
+	 */
+	prerequeue_top_waiter = rt_mutex_top_waiter(lock);
 
 	/* Requeue the waiter */
 	rt_mutex_dequeue(lock, waiter);
@@ -410,13 +420,18 @@ static int rt_mutex_adjust_prio_chain(st
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
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
 		goto out_put_task;
@@ -429,17 +444,32 @@ static int rt_mutex_adjust_prio_chain(st
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		/* Boost the owner */
-		rt_mutex_dequeue_pi(task, top_waiter);
+		/*
+		 * The waiter became the new top (highest priority)
+		 * waiter on the lock. Replace the previous top waiter
+		 * in the owner tasks pi waiters list with this waiter.
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
+		 * (highest priority) waiter.
+		 */
 		rt_mutex_dequeue_pi(task, waiter);
 		waiter = rt_mutex_top_waiter(lock);
 		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
+
+	} else {
+		/*
+		 * Nothing changed. No need to do any priority
+		 * adjustment.
+		 */
 	}
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -447,6 +477,11 @@ static int rt_mutex_adjust_prio_chain(st
 	top_waiter = rt_mutex_top_waiter(lock);
 	raw_spin_unlock(&lock->wait_lock);
 
+	/*
+	 * If the current waiter is not the top waiter on the lock,
+	 * then we can stop the chain walk here if we are not in full
+	 * deadlock detection mode.
+	 */
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
 


