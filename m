Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaEVDZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:25:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:46252 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEVDZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:25:40 -0400
Message-Id: <20140522031950.044848781@linutronix.de>
User-Agent: quilt/0.60-1
Date: Thu, 22 May 2014 03:25:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 4/6] rtmutex: Confine deadlock logic to futex
References: <20140522031841.797415507@linutronix.de>
Content-Disposition: inline;
 filename=rtmutex-confine-deadlock-logic-to-futex.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The builtin tester is gone,, so the deadlock logic is now only
required for futexes.

Remove the extra arguments for the public functions and also for the
futex specific ones which get always called with deadlock detection
enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rtmutex.h         |    6 +---
 kernel/futex.c                  |    9 ++----
 kernel/locking/rtmutex.c        |   54 +++++++++++++++++++++-------------------
 kernel/locking/rtmutex_common.h |    7 ++---
 4 files changed, 37 insertions(+), 39 deletions(-)

Index: tip/include/linux/rtmutex.h
===================================================================
--- tip.orig/include/linux/rtmutex.h
+++ tip/include/linux/rtmutex.h
@@ -90,11 +90,9 @@ extern void __rt_mutex_init(struct rt_mu
 extern void rt_mutex_destroy(struct rt_mutex *lock);
 
 extern void rt_mutex_lock(struct rt_mutex *lock);
-extern int rt_mutex_lock_interruptible(struct rt_mutex *lock,
-						int detect_deadlock);
+extern int rt_mutex_lock_interruptible(struct rt_mutex *lock);
 extern int rt_mutex_timed_lock(struct rt_mutex *lock,
-					struct hrtimer_sleeper *timeout,
-					int detect_deadlock);
+			       struct hrtimer_sleeper *timeout);
 
 extern int rt_mutex_trylock(struct rt_mutex *lock);
 
Index: tip/kernel/futex.c
===================================================================
--- tip.orig/kernel/futex.c
+++ tip/kernel/futex.c
@@ -1619,8 +1619,7 @@ retry_private:
 			this->pi_state = pi_state;
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
-							this->task,
-							RT_MUTEX_FULL_CHAINWALK);
+							this->task);
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
@@ -2240,8 +2239,7 @@ retry_private:
 	 * Block on the PI mutex:
 	 */
 	if (!trylock) {
-		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to,
-					  RT_MUTEX_FULL_CHAINWALK);
+		ret = __rt_mutex_timed_lock(&q.pi_state->pi_mutex, to);
 	} else {
 		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
@@ -2564,8 +2562,7 @@ static int futex_wait_requeue_pi(u32 __u
 		 */
 		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
-		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter,
-						 RT_MUTEX_FULL_CHAINWALK);
+		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
 		spin_lock(q.lock_ptr);
Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -957,47 +957,53 @@ EXPORT_SYMBOL_GPL(rt_mutex_lock);
 /**
  * rt_mutex_lock_interruptible - lock a rt_mutex interruptible
  *
- * @lock: 		the rt_mutex to be locked
- * @detect_deadlock:	deadlock detection on/off
+ * @lock:		the rt_mutex to be locked
  *
  * Returns:
- *  0 		on success
- * -EINTR 	when interrupted by a signal
- * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
+ *  0		on success
+ * -EINTR	when interrupted by a signal
  */
-int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
-						 int detect_deadlock)
+int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock)
 {
 	might_sleep();
 
 	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE,
-				 detect_deadlock, rt_mutex_slowlock);
+				 RT_MUTEX_MIN_CHAINWALK, rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
+/*
+ * Futex variant to allow full deadlock detection.
+ */
+int __rt_mutex_timed_lock(struct rt_mutex *lock,
+			  struct hrtimer_sleeper *timeout)
+{
+	might_sleep();
+
+	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
+				       RT_MUTEX_FULL_CHAINWALK,
+				       rt_mutex_slowlock);
+}
+
 /**
  * rt_mutex_timed_lock - lock a rt_mutex interruptible
  *			the timeout structure is provided
  *			by the caller
  *
- * @lock: 		the rt_mutex to be locked
+ * @lock:		the rt_mutex to be locked
  * @timeout:		timeout structure or NULL (no timeout)
- * @detect_deadlock:	deadlock detection on/off
  *
  * Returns:
- *  0 		on success
- * -EINTR 	when interrupted by a signal
+ *  0		on success
+ * -EINTR	when interrupted by a signal
  * -ETIMEDOUT	when the timeout expired
- * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
  */
 int
-rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout,
-		    int detect_deadlock)
+rt_mutex_timed_lock(struct rt_mutex *lock, struct hrtimer_sleeper *timeout)
 {
-	might_sleep();
-
 	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
-				       detect_deadlock, rt_mutex_slowlock);
+				       RT_MUTEX_MIN_CHAINWALK,
+				       rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
 
@@ -1103,7 +1109,6 @@ void rt_mutex_proxy_unlock(struct rt_mut
  * @lock:		the rt_mutex to take
  * @waiter:		the pre-initialized rt_mutex_waiter
  * @task:		the task to prepare
- * @detect_deadlock:	perform deadlock detection (1) or not (0)
  *
  * Returns:
  *  0 - task blocked on lock
@@ -1114,7 +1119,7 @@ void rt_mutex_proxy_unlock(struct rt_mut
  */
 int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
-			      struct task_struct *task, int detect_deadlock)
+			      struct task_struct *task)
 {
 	int ret;
 
@@ -1125,7 +1130,8 @@ int rt_mutex_start_proxy_lock(struct rt_
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, waiter, task,
+				      RT_MUTEX_FULL_CHAINWALK);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
@@ -1171,9 +1177,8 @@ struct task_struct *rt_mutex_next_owner(
  * rt_mutex_finish_proxy_lock() - Complete lock acquisition
  * @lock:		the rt_mutex we were woken on
  * @to:			the timeout, null if none. hrtimer should already have
- * 			been started.
+ *			been started.
  * @waiter:		the pre-initialized rt_mutex_waiter
- * @detect_deadlock:	perform deadlock detection (1) or not (0)
  *
  * Complete the lock acquisition started our behalf by another thread.
  *
@@ -1185,8 +1190,7 @@ struct task_struct *rt_mutex_next_owner(
  */
 int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 			       struct hrtimer_sleeper *to,
-			       struct rt_mutex_waiter *waiter,
-			       int detect_deadlock)
+			       struct rt_mutex_waiter *waiter)
 {
 	int ret;
 
Index: tip/kernel/locking/rtmutex_common.h
===================================================================
--- tip.orig/kernel/locking/rtmutex_common.h
+++ tip/kernel/locking/rtmutex_common.h
@@ -104,12 +104,11 @@ extern void rt_mutex_proxy_unlock(struct
 				  struct task_struct *proxy_owner);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
-				     struct task_struct *task,
-				     int detect_deadlock);
+				     struct task_struct *task);
 extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 				      struct hrtimer_sleeper *to,
-				      struct rt_mutex_waiter *waiter,
-				      int detect_deadlock);
+				      struct rt_mutex_waiter *waiter);
+extern int __rt_mutex_timed_lock(struct rt_mutex *l, struct hrtimer_sleeper *to);
 
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # include "rtmutex-debug.h"


