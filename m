Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaDYU2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:28:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:48519 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752823AbaDYU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:28:50 -0400
Date: Fri, 25 Apr 2014 16:28:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC PATCH] rtmutex: Do not prio boost when timeout is used
Message-ID: <20140425162848.0e1deed8@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been discussing an issue on IRC with deadlock checking and found
something wrong with it. Mainly, if any of the locks have a timeout,
then even if the chain loops, there is no real deadlock. If one of the
locks in the chain times out, then things will move forward again.

Now it may not be nice to have locks that do this, but we can break
applications that use futex priority boosting and may use timeouts to
break deadlocks.

Here's the scenario:

Locks:  L1, L2, L3
Tasks:  A, B, C

C grabs L2

A grabs L1
A tries to grab L2 - blocks

B grabs L3
B grabs L1 with a timeout

C grabs L3 and blocks

deadlock detect kicks in and runs up the chain.

L3 is held by B
B is blocked on L1
L1 is owned by A

(in the mean time B times out and release L3)

A is blocked on L2
L2 is owned by C

 if (lock == orig_lock || rt_mutex_owner(lock) == top_task)

Where top_task is C, this is true. The deadlock is reported back up to
userspace and C exits, killing all other threads and the app dies.

The problem here is that there was no deadlock. If we just ignored
this, as B had timed out and released L3, C could have gotten L3 and
continued normally.

As priority boosting is made to prevent unbounded latencies, and a
timeout grabbing of a lock is a bounded latency, I'm suggesting that we
do not bother boosting the owner or even treating the task as being
blocked.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index aa4dff0..c8f2681 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -520,6 +520,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
 				   struct task_struct *task,
+				   void *timeout,
 				   int detect_deadlock)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
@@ -538,7 +539,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 		top_waiter = rt_mutex_top_waiter(lock);
 	rt_mutex_enqueue(lock, waiter);
 
-	task->pi_blocked_on = waiter;
+	/* Treat locks with timeouts as not being blocked */
+	if (likely(!timeout))
+		task->pi_blocked_on = waiter;
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
@@ -558,6 +561,13 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
 		chain_walk = 1;
 
+	/*
+	 * If blocking with a timeout, then it's already bounded.
+	 * No priority boosting necessary.
+	 */
+	if (unlikely(timeout))
+		return 0;
+
 	if (!chain_walk)
 		return 0;
 
@@ -771,7 +781,8 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 			timeout->task = NULL;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current, timeout,
+				      detect_deadlock);
 
 	if (likely(!ret))
 		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
@@ -1088,7 +1099,7 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, NULL, detect_deadlock);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
