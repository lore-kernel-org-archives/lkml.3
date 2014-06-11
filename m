Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaFKSqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:46:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:34304 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaFKSoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:09 -0400
Message-Id: <20140611183853.553977348@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch V4 08/10] rtmutex: Confine deadlock logic to futex
References: <20140611182944.108526809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rtmutex-confine-deadlock-logic-to-futex.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The deadlock logic is only required for futexes.

Remove the extra arguments for the public functions and also for the
futex specific ones which get always called with deadlock detection
enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rtmutex.h         |    6 +---
 kernel/futex.c                  |   10 +++---
 kernel/locking/rtmutex.c        |   59 ++++++++++++++++++++--------------------
 kernel/locking/rtmutex_common.h |    7 ++--
 4 files changed, 40 insertions(+), 42 deletions(-)

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
@@ -1718,7 +1718,7 @@ retry_private:
 			this->pi_state = pi_state;
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
-							this->task, 1);
+							this->task);
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
@@ -2337,9 +2337,9 @@ retry_private:
 	/*
 	 * Block on the PI mutex:
 	 */
-	if (!trylock)
-		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);
-	else {
+	if (!trylock) {
+		ret = __rt_mutex_timed_lock(&q.pi_state->pi_mutex, to);
+	} else {
 		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
 		ret = ret ? 0 : -EWOULDBLOCK;
@@ -2669,7 +2669,7 @@ static int futex_wait_requeue_pi(u32 __u
 		 */
 		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
-		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
+		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
 		spin_lock(q.lock_ptr);
Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -1232,16 +1232,15 @@ rt_mutex_slowunlock(struct rt_mutex *loc
  */
 static inline int
 rt_mutex_fastlock(struct rt_mutex *lock, int state,
-		  int detect_deadlock,
 		  int (*slowfn)(struct rt_mutex *lock, int state,
 				struct hrtimer_sleeper *timeout,
 				int detect_deadlock))
 {
-	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
+	if (likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
 		return 0;
 	} else
-		return slowfn(lock, state, NULL, detect_deadlock);
+		return slowfn(lock, state, NULL, 0);
 }
 
 static inline int
@@ -1288,54 +1287,59 @@ void __sched rt_mutex_lock(struct rt_mut
 {
 	might_sleep();
 
-	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, 0, rt_mutex_slowlock);
+	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock);
 
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
 
-	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE,
-				 detect_deadlock, rt_mutex_slowlock);
+	return rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE, rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
+/*
+ * Futex variant with full deadlock detection.
+ */
+int __rt_mutex_timed_lock(struct rt_mutex *lock,
+			  struct hrtimer_sleeper *timeout)
+{
+	might_sleep();
+
+	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 1,
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
 	might_sleep();
 
-	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout,
-				       detect_deadlock, rt_mutex_slowlock);
+	return rt_mutex_timed_fastlock(lock, TASK_INTERRUPTIBLE, timeout, 0,
+				       rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_timed_lock);
 
@@ -1441,7 +1445,6 @@ void rt_mutex_proxy_unlock(struct rt_mut
  * @lock:		the rt_mutex to take
  * @waiter:		the pre-initialized rt_mutex_waiter
  * @task:		the task to prepare
- * @detect_deadlock:	perform deadlock detection (1) or not (0)
  *
  * Returns:
  *  0 - task blocked on lock
@@ -1452,7 +1455,7 @@ void rt_mutex_proxy_unlock(struct rt_mut
  */
 int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
-			      struct task_struct *task, int detect_deadlock)
+			      struct task_struct *task)
 {
 	int ret;
 
@@ -1510,22 +1513,20 @@ struct task_struct *rt_mutex_next_owner(
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
  * Returns:
  *  0 - success
- * <0 - error, one of -EINTR, -ETIMEDOUT, or -EDEADLK
+ * <0 - error, one of -EINTR, -ETIMEDOUT
  *
  * Special API call for PI-futex requeue support
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
@@ -111,12 +111,11 @@ extern void rt_mutex_proxy_unlock(struct
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


