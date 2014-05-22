Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaEVDZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:25:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:46228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaEVDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:25:28 -0400
Message-Id: <20140522031949.725272460@linutronix.de>
User-Agent: quilt/0.60-1
Date: Thu, 22 May 2014 03:25:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 1/6] rtmutex: Fix deadlock detector for real
References: <20140522031841.797415507@linutronix.de>
Content-Disposition: inline;
 filename=rtmutex-fix-deadlock-detector-for-real.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current deadlock detection logic does not work reliably due to the
following early exit path:

	/*
	 * Drop out, when the task has no waiters. Note,
	 * top_waiter can be NULL, when we are in the deboosting
	 * mode!
	 */
	if (top_waiter && (!task_has_pi_waiters(task) ||
			   top_waiter != task_top_pi_waiter(task)))
		goto out_unlock_pi;

So this not only exits when the task has no waiters, it also exits
unconditionally when the current waiter is not the top priority waiter
of the task.

So in a nested locking scenario, it might abort the lock chain walk
and therefor miss a potential deadlock.

Simple fix: Continue the chain walk, when deadlock detection is
enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 kernel/locking/rtmutex.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -343,16 +343,22 @@ static int rt_mutex_adjust_prio_chain(st
 	 * top_waiter can be NULL, when we are in the deboosting
 	 * mode!
 	 */
-	if (top_waiter && (!task_has_pi_waiters(task) ||
-			   top_waiter != task_top_pi_waiter(task)))
-		goto out_unlock_pi;
+	if (top_waiter) {
+		if (!task_has_pi_waiters(task))
+			goto out_unlock_pi;
+
+		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
+			goto out_unlock_pi;
+	}
 
 	/*
 	 * When deadlock detection is off then we check, if further
 	 * priority adjustment is necessary.
 	 */
-	if (!detect_deadlock && waiter->prio == task->prio)
-		goto out_unlock_pi;
+	if (waiter->prio == task->prio) {
+		if (!detect_deadlock)
+			goto out_unlock_pi;
+	}
 
 	lock = waiter->lock;
 	if (!raw_spin_trylock(&lock->wait_lock)) {
@@ -361,7 +367,12 @@ static int rt_mutex_adjust_prio_chain(st
 		goto retry;
 	}
 
-	/* Deadlock detection */
+	/*
+	 * Deadlock detection. If the lock is the same as the original
+	 * lock which caused us to walk the lock chain or if the
+	 * current lock is owned by the task which initiated the chain
+	 * walk, we detected a deadlock.
+	 */
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
@@ -527,6 +538,10 @@ static int task_blocks_on_rt_mutex(struc
 	unsigned long flags;
 	int chain_walk = 0, res;
 
+	/* Early deadlock detection */
+	if (detect_deadlock && owner == task)
+		return -EDEADLK;
+
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;


