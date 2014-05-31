Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaEaP57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:57:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:34399 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaEaP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:57:53 -0400
Message-Id: <20140531155739.265673091@linutronix.de>
User-Agent: quilt/0.63-1
Date: Sat, 31 May 2014 15:57:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: [patch v2 2/5] rtmutex: Cleanup deadlock detector debug logic
References: <20140531155229.493650009@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rtmutex-cleanup-deadlock-detector-debug-logic.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditions under which deadlock detection is conducted are unclear
and undocumented.

Add constants instead of using 0/1 and provide a selection function
which hides the additional debug dependency from the calling code.

Add comments where needed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/20140522031949.947264874@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c                  |   13 +++++---
 kernel/locking/rtmutex.c        |   59 ++++++++++++++++++++++++++++------------
 kernel/locking/rtmutex.h        |    7 ++++
 kernel/locking/rtmutex_common.h |   15 ++++++++++
 4 files changed, 71 insertions(+), 23 deletions(-)

Index: tip/kernel/futex.c
===================================================================
--- tip.orig/kernel/futex.c
+++ tip/kernel/futex.c
@@ -1619,7 +1619,8 @@ retry_private:
 			this->pi_state = pi_state;
 			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
 							this->rt_waiter,
-							this->task, 1);
+							this->task,
+							RT_MUTEX_FULL_CHAINWALK);
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
@@ -2238,9 +2239,10 @@ retry_private:
 	/*
 	 * Block on the PI mutex:
 	 */
-	if (!trylock)
-		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);
-	else {
+	if (!trylock) {
+		ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to,
+					  RT_MUTEX_FULL_CHAINWALK);
+	} else {
 		ret = rt_mutex_trylock(&q.pi_state->pi_mutex);
 		/* Fixup the trylock return value: */
 		ret = ret ? 0 : -EWOULDBLOCK;
@@ -2562,7 +2564,8 @@ static int futex_wait_requeue_pi(u32 __u
 		 */
 		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
-		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
+		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter,
+						 RT_MUTEX_FULL_CHAINWALK);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
 		spin_lock(q.lock_ptr);
Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -256,6 +256,25 @@ static void rt_mutex_adjust_prio(struct
 }
 
 /*
+ * Deadlock detection is conditional:
+ *
+ * If CONFIG_DEBUG_RT_MUTEXES=n, deadlock detection is only conducted
+ * if the detect argument is == RT_MUTEX_FULL_CHAINWALK.
+ *
+ * If CONFIG_DEBUG_RT_MUTEXES=y, deadlock detection is always
+ * conducted independent of the detect argument.
+ *
+ * If the waiter argument is NULL this indicates the deboost path and
+ * deadlock detection is disabled independent of the detect argument
+ * and the config settings.
+ */
+static int rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
+					 enum rtmutex_chainwalk detect)
+{
+	return debug_rt_mutex_detect_deadlock(waiter, detect);
+}
+
+/*
  * Max number of times we'll walk the boosting chain:
  */
 int max_lock_depth = 1024;
@@ -279,18 +298,19 @@ int max_lock_depth = 1024;
  * Returns 0 or -EDEADLK.
  */
 static int rt_mutex_adjust_prio_chain(struct task_struct *task,
-				      int deadlock_detect,
+				      enum rtmutex_chainwalk deadlock_detect,
 				      struct rt_mutex *orig_lock,
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
 	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
-	int detect_deadlock, ret = 0, depth = 0;
+	enum rtmutex_chainwalk detect_deadlock;
+	int ret = 0, depth = 0;
 	unsigned long flags;
 
-	detect_deadlock = debug_rt_mutex_detect_deadlock(orig_waiter,
-							 deadlock_detect);
+	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter,
+							deadlock_detect);
 
 	/*
 	 * The (de)boosting is a step by step approach with a lot of
@@ -532,7 +552,7 @@ static int try_to_take_rt_mutex(struct r
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
 				   struct task_struct *task,
-				   int detect_deadlock)
+				   enum rtmutex_chainwalk detect_deadlock)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
@@ -548,7 +568,7 @@ static int task_blocks_on_rt_mutex(struc
 	 * which is wrong, as the other waiter is not in a deadlock
 	 * situation.
 	 */
-	if (detect_deadlock && owner == task)
+	if (detect_deadlock == RT_MUTEX_FULL_CHAINWALK && owner == task)
 		return -EDEADLK;
 
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
@@ -578,9 +598,10 @@ static int task_blocks_on_rt_mutex(struc
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
-	}
-	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
+
+	} else if (rt_mutex_cond_detect_deadlock(waiter, detect_deadlock)) {
 		chain_walk = 1;
+	}
 
 	if (!chain_walk)
 		return 0;
@@ -683,7 +704,8 @@ static void remove_waiter(struct rt_mute
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
+	rt_mutex_adjust_prio_chain(owner, RT_MUTEX_MIN_CHAINWALK, lock,
+				   NULL, current);
 
 	raw_spin_lock(&lock->wait_lock);
 }
@@ -711,7 +733,8 @@ void rt_mutex_adjust_pi(struct task_stru
 
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(task);
-	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
+	rt_mutex_adjust_prio_chain(task, RT_MUTEX_MIN_CHAINWALK, NULL, NULL,
+				   task);
 }
 
 /**
@@ -769,7 +792,7 @@ __rt_mutex_slowlock(struct rt_mutex *loc
 static int __sched
 rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		  struct hrtimer_sleeper *timeout,
-		  int detect_deadlock)
+		  enum rtmutex_chainwalk detect_deadlock)
 {
 	struct rt_mutex_waiter waiter;
 	int ret = 0;
@@ -881,10 +904,10 @@ rt_mutex_slowunlock(struct rt_mutex *loc
  */
 static inline int
 rt_mutex_fastlock(struct rt_mutex *lock, int state,
-		  int detect_deadlock,
+		  enum rtmutex_chainwalk detect_deadlock,
 		  int (*slowfn)(struct rt_mutex *lock, int state,
 				struct hrtimer_sleeper *timeout,
-				int detect_deadlock))
+				enum rtmutex_chainwalk detect_deadlock))
 {
 	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
@@ -895,10 +918,11 @@ rt_mutex_fastlock(struct rt_mutex *lock,
 
 static inline int
 rt_mutex_timed_fastlock(struct rt_mutex *lock, int state,
-			struct hrtimer_sleeper *timeout, int detect_deadlock,
+			struct hrtimer_sleeper *timeout,
+			enum rtmutex_chainwalk detect_deadlock,
 			int (*slowfn)(struct rt_mutex *lock, int state,
 				      struct hrtimer_sleeper *timeout,
-				      int detect_deadlock))
+				      enum rtmutex_chainwalk detect_deadlock))
 {
 	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
@@ -937,7 +961,8 @@ void __sched rt_mutex_lock(struct rt_mut
 {
 	might_sleep();
 
-	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, 0, rt_mutex_slowlock);
+	rt_mutex_fastlock(lock, TASK_UNINTERRUPTIBLE, RT_MUTEX_MIN_CHAINWALK,
+			  rt_mutex_slowlock);
 }
 EXPORT_SYMBOL_GPL(rt_mutex_lock);
 
@@ -953,7 +978,7 @@ EXPORT_SYMBOL_GPL(rt_mutex_lock);
  * -EDEADLK	when the lock would deadlock (when deadlock detection is on)
  */
 int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
-						 int detect_deadlock)
+					enum rtmutex_chainwalk detect_deadlock)
 {
 	might_sleep();
 
Index: tip/kernel/locking/rtmutex.h
===================================================================
--- tip.orig/kernel/locking/rtmutex.h
+++ tip/kernel/locking/rtmutex.h
@@ -22,5 +22,10 @@
 #define debug_rt_mutex_init(m, n)			do { } while (0)
 #define debug_rt_mutex_deadlock(d, a ,l)		do { } while (0)
 #define debug_rt_mutex_print_deadlock(w)		do { } while (0)
-#define debug_rt_mutex_detect_deadlock(w,d)		(d)
 #define debug_rt_mutex_reset_waiter(w)			do { } while (0)
+
+static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
+						 enum rtmutex_chainwalk detect)
+{
+	return detect == RT_MUTEX_FULL_CHAINWALK;
+}
Index: tip/kernel/locking/rtmutex_common.h
===================================================================
--- tip.orig/kernel/locking/rtmutex_common.h
+++ tip/kernel/locking/rtmutex_common.h
@@ -80,6 +80,21 @@ static inline struct task_struct *rt_mut
 }
 
 /*
+ * Constants for rt mutex functions which have a selectable deadlock
+ * detection.
+ *
+ * RT_MUTEX_MIN_CHAINWALK:	Stops the lock chain walk when there are
+ *				no further PI adjustments to be made.
+ *
+ * RT_MUTEX_FULL_CHAINWALK:	Invoke deadlock detection with a full
+ *				walk of the lock chain.
+ */
+enum rtmutex_chainwalk {
+	RT_MUTEX_MIN_CHAINWALK,
+	RT_MUTEX_FULL_CHAINWALK,
+};
+
+/*
  * PI-futex support (proxy locking functions, etc.):
  */
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);


