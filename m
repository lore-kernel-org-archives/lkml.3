Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaFEP2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:28:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:49930 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFEP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:28:35 -0400
Message-Id: <20140605152801.836501969@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 15:28:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Brad Mouring <bmouring@ni.com>
Subject: [patch 1/2] rtmutex: Handle deadlock detection smarter
References: <20140605152544.641846795@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rtmutex-handle-deadlock-detection-gracefully.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even in the case when deadlock detection is not requested by the
caller, we can detect deadlocks. Right now the code stops the lock
chain walk and keeps the waiter enqueued, even on itself. Silly not to
yell when such a scenario is detected and to keep the waiter enqueued.

Return -EDEADLK unconditionally and handle it at the call sites.

The futex calls return -EDEADLK. The non futex ones dequeue the
waiter, throw a warning and put the task into a schedule loop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   33 ++++++++++++++++++++++++++++-----
 kernel/locking/rtmutex.h |    6 +++++-
 2 files changed, 33 insertions(+), 6 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -314,7 +314,7 @@ static int rt_mutex_adjust_prio_chain(st
 		}
 		put_task_struct(task);
 
-		return deadlock_detect ? -EDEADLK : 0;
+		return -EDEADLK;
 	}
  retry:
 	/*
@@ -377,7 +377,7 @@ static int rt_mutex_adjust_prio_chain(st
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
-		ret = deadlock_detect ? -EDEADLK : 0;
+		ret = -EDEADLK;
 		goto out_unlock_pi;
 	}
 
@@ -548,7 +548,7 @@ static int task_blocks_on_rt_mutex(struc
 	 * which is wrong, as the other waiter is not in a deadlock
 	 * situation.
 	 */
-	if (detect_deadlock && owner == task)
+	if (owner == task)
 		return -EDEADLK;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -763,6 +763,26 @@ __rt_mutex_slowlock(struct rt_mutex *loc
 	return ret;
 }
 
+static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
+				     struct rtmutex_waiter *w)
+{
+	/*
+	 * If the result is not -EDEADLOCK or the caller requested
+	 * deadlock detection, nothing to do here.
+	 */
+	if (res != -EDEADLOCK || detect_deadlock)
+		return;
+
+	/*
+	 * Yell lowdly and stop the task right here.
+	 */
+	debug_rt_mutex_print_deadlock(w);
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+}
+
 /*
  * Slow path lock function:
  */
@@ -802,8 +822,10 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		remove_waiter(lock, &waiter);
+		rt_mutex_handle_deadlock(ret, detect_deadlock, &waiter);
+	}
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -1112,7 +1134,8 @@ int rt_mutex_start_proxy_lock(struct rt_
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	/* We enforce deadlock detection for futexes */
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
Index: tip/kernel/locking/rtmutex.h
===================================================================
--- tip.orig/kernel/locking/rtmutex.h
+++ tip/kernel/locking/rtmutex.h
@@ -21,6 +21,10 @@
 #define debug_rt_mutex_unlock(l)			do { } while (0)
 #define debug_rt_mutex_init(m, n)			do { } while (0)
 #define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
-#define debug_rt_mutex_print_deadlock(w)		do { } while (0)
 #define debug_rt_mutex_detect_deadlock(w,d)		(d)
 #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
+
+static inline void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *w)
+{
+	WARN(1, "rtmutex deadlock detected\n");
+}


