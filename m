Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaJRA3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:29:38 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38565 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaJRA2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:28:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait) implementation
Date: Fri, 17 Oct 2014 20:22:58 -0400
Message-ID: <1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing wait queue support has support for custom wake up call
backs, wake flags, wake key (passed to call back) and exclusive
flags that allow wakers to be tagged as exclusive, for limiting
the number of wakers.

In a lot of cases, none of these features are used, and hence we
can benefit from a slimmed down version that lowers memory overhead
and reduces runtime overhead.

The concept originated from RT, where waitqueues are a constant
source of trouble, as we can't convert the head lock to a raw
spinlock due to fancy and long lasting callbacks.  Unlike the RT
version, which had support in stand-alone files, here we integrate
it into existing wait.[ch] files and make it as parallel as possible
to the already in tree complex wait queue support.

With the removal of custom callbacks, we can use a raw lock for
queue list manipulations, hence allowing the simple wait support
to be used in RT.

The other big difference between the -rt version is that here we
add the code alongside the existing complex waitqueue support, for
ease of maintenance, and to highlight any differences between the
two implementations.

Originally-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 526e398cc249..2a57e00250f9 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -31,6 +31,11 @@ struct cwait {
 	struct list_head	task_list;
 };
 
+struct swait {
+	struct task_struct	*task;
+	struct list_head	node;
+};
+
 struct cwait_bit_key {
 	void			*flags;
 	int			bit_nr;
@@ -49,6 +54,11 @@ struct cwait_head {
 };
 typedef struct cwait_head cwait_head_t;
 
+struct swait_head {
+	raw_spinlock_t		lock;
+	struct list_head	task_list;
+};
+
 #ifdef CWAIT_COMPAT
 #define wait_queue_t		cwait_t
 #define wait_queue_head_t	cwait_head_t
@@ -70,16 +80,30 @@ struct task_struct;
 	.func		= default_cwake_function,			\
 	.task_list	= { NULL, NULL } }
 
+#define SWAIT_INITIALIZER(name, tsk) {					\
+	.task		= current,					\
+	.node		= LIST_HEAD_INIT((name).node) }
+
 #define DECLARE_CWAIT(name, tsk)					\
 	struct cwait name = CWAIT_INITIALIZER(name, tsk)
 
+#define DECLARE_SWAIT(name)						\
+	struct swait name = SWAIT_INITIALIZER(name, tsk)
+
 #define CWAIT_HEAD_INITIALIZER(name) {					\
 	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),		\
 	.task_list	= { &(name).task_list, &(name).task_list } }
 
+#define SWAIT_HEAD_INITIALIZER(name) {					\
+	.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),		\
+	.task_list	= { &(name).task_list, &(name).task_list } }
+
 #define DECLARE_CWAIT_HEAD(name) \
 	struct cwait_head name = CWAIT_HEAD_INITIALIZER(name)
 
+#define DECLARE_SWAIT_HEAD(name) \
+	struct swait_head name = SWAIT_HEAD_INITIALIZER(name)
+
 #define CWAIT_BIT_KEY_INITIALIZER(word, bit)				\
 	{ .flags = word, .bit_nr = bit, }
 
@@ -89,6 +113,9 @@ struct task_struct;
 extern void __init_cwait_head(struct cwait_head *q, const char *name,
 			      struct lock_class_key *);
 
+extern void __init_swait_head(struct swait_head *q, const char *name,
+			      struct lock_class_key *);
+
 #define init_cwait_head(q)				\
 	do {						\
 		static struct lock_class_key __key;	\
@@ -96,13 +123,25 @@ extern void __init_cwait_head(struct cwait_head *q, const char *name,
 		__init_cwait_head((q), #q, &__key);	\
 	} while (0)
 
+#define init_swait_head(q)				\
+	do {						\
+		static struct lock_class_key __key;	\
+							\
+		__init_swait_head((q), #q, &__key);	\
+	} while (0)
+
 #ifdef CONFIG_LOCKDEP
 # define CWAIT_HEAD_INIT_ONSTACK(name) \
 	({ init_cwait_head(&name); name; })
+# define SWAIT_HEAD_INIT_ONSTACK(name) \
+	({ init_swait_head(&name); name; })
 # define DECLARE_CWAIT_HEAD_ONSTACK(name) \
 	struct cwait_head name = CWAIT_HEAD_INIT_ONSTACK(name)
+# define DECLARE_SWAIT_HEAD_ONSTACK(name) \
+	struct swait_head name = SWAIT_HEAD_INIT_ONSTACK(name)
 #else
 # define DECLARE_CWAIT_HEAD_ONSTACK(name) DECLARE_CWAIT_HEAD(name)
+# define DECLARE_SWAIT_HEAD_ONSTACK(name) DECLARE_SWAIT_HEAD(name)
 #endif
 
 static inline void init_cwait_entry(struct cwait *q, struct task_struct *p)
@@ -140,9 +179,16 @@ static inline int cwait_active(struct cwait_head *q)
 	return !list_empty(&q->task_list);
 }
 
+static inline int swait_active(struct swait_head *q)
+{
+	return !list_empty(&q->task_list);
+}
+
 extern void add_cwait(struct cwait_head *q, struct cwait *wait);
+extern void add_swait(struct swait_head *q, struct swait *wait);
 extern void add_cwait_exclusive(struct cwait_head *q, struct cwait *wait);
 extern void remove_cwait(struct cwait_head *q, struct cwait *wait);
+extern void remove_swait(struct swait_head *q, struct swait *wait);
 
 #ifdef CWAIT_COMPAT
 #define waitqueue_active		cwait_active
@@ -156,6 +202,11 @@ static inline void __add_cwait(struct cwait_head *head, struct cwait *new)
 	list_add(&new->task_list, &head->task_list);
 }
 
+static inline void __add_swait(struct swait_head *head, struct swait *new)
+{
+	list_add(&new->node, &head->task_list);
+}
+
 /*
  * Used for wake-one threads:
  */
@@ -172,6 +223,12 @@ static inline void __add_cwait_tail(struct cwait_head *head,
 	list_add_tail(&new->task_list, &head->task_list);
 }
 
+static inline void __add_swait_tail(struct swait_head *head,
+				    struct swait *new)
+{
+	list_add_tail(&new->node, &head->task_list);
+}
+
 static inline void __add_cwait_tail_exclusive(struct cwait_head *q,
 					      struct cwait *wait)
 {
@@ -185,6 +242,12 @@ __remove_cwait(struct cwait_head *head, struct cwait *old)
 	list_del(&old->task_list);
 }
 
+static inline void
+__remove_swait(struct swait_head *head, struct swait *old)
+{
+	list_del_init(&old->node);
+}
+
 #ifdef CWAIT_COMPAT
 #define __add_wait_queue		__add_cwait
 #define __remove_wait_queue		__remove_cwait
@@ -195,9 +258,11 @@ __remove_cwait(struct cwait_head *head, struct cwait *old)
 
 typedef int cwait_bit_action_f(struct wait_bit_key *);
 void __cwake_up(struct cwait_head *q, unsigned int mode, int nr, void *key);
+void __swake_up(struct swait_head *q, unsigned int mode, int nr);
 void __cwake_up_locked_key(struct cwait_head *q, unsigned int mode, void *key);
 void __cwake_up_sync_key(struct cwait_head *q, unsigned int mode, int nr, void *key);
 void __cwake_up_locked(struct cwait_head *q, unsigned int mode, int nr);
+void __swake_up_locked(struct swait_head *q, unsigned int mode, int nr);
 void __cwake_up_sync(struct cwait_head *q, unsigned int mode, int nr);
 void __cwake_up_bit(struct cwait_head *, void *, int);
 int __cwait_on_bit(struct cwait_head *, struct cwait_bit *, cwait_bit_action_f *, unsigned);
@@ -223,10 +288,15 @@ int out_of_line_cwait_on_atomic_t(atomic_t *, int (*)(atomic_t *), unsigned);
 struct cwait_head *bit_cwaitqueue(void *, int);
 
 #define cwake_up(x)			__cwake_up(x, TASK_NORMAL, 1, NULL)
+#define swake_up(x)			__swake_up(x, TASK_NORMAL, 1)
 #define cwake_up_nr(x, nr)		__cwake_up(x, TASK_NORMAL, nr, NULL)
+#define swake_up_nr(x, nr)		__swake_up(x, TASK_NORMAL, nr)
 #define cwake_up_all(x)			__cwake_up(x, TASK_NORMAL, 0, NULL)
+#define swake_up_all(x)			__swake_up(x, TASK_NORMAL, 0)
 #define cwake_up_locked(x)		__cwake_up_locked((x), TASK_NORMAL, 1)
+#define swake_up_locked(x)		__swake_up_locked((x), TASK_NORMAL, 1)
 #define cwake_up_all_locked(x)		__cwake_up_locked((x), TASK_NORMAL, 0)
+#define swake_up_all_locked(x)		__swake_up_locked((x), TASK_NORMAL, 0)
 
 #ifdef CWAIT_COMPAT
 #define wake_up				cwake_up
@@ -337,10 +407,39 @@ struct cwait_head *bit_cwaitqueue(void *, int);
 __out:	__ret;								\
 })
 
+/* as above but for swait, and hence with implied "exclusive == 0" */
+#define ___swait_event(wq, condition, state, ret, cmd)			\
+({									\
+	struct swait __wait;						\
+	long __ret = ret;						\
+									\
+	INIT_LIST_HEAD(&__wait.node);				\
+	for (;;) {							\
+		long __int = prepare_to_swait_event(&wq, &__wait, state);\
+									\
+		if (condition)						\
+			break;						\
+									\
+		if (___wait_is_interruptible(state) && __int) {		\
+			__ret = __int;					\
+			break;						\
+		}							\
+									\
+		cmd;							\
+	}								\
+	finish_swait(&wq, &__wait);					\
+	__ret;								\
+})
+
+
 #define __cwait_event(wq, condition)					\
 	(void)___cwait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    schedule())
 
+#define __swait_event(wq, condition)					\
+	(void)___swait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,	\
+			    schedule())
+
 /**
  * cwait_event - sleep until a condition gets true
  * @wq: the complex waitqueue to wait on
@@ -360,11 +459,23 @@ do {									\
 	__cwait_event(wq, condition);					\
 } while (0)
 
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
 #define __cwait_event_timeout(wq, condition, timeout)			\
 	___cwait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
 		      __ret = schedule_timeout(__ret))
 
+#define __swait_event_timeout(wq, condition, timeout)			\
+	___swait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_UNINTERRUPTIBLE, timeout,			\
+		      __ret = schedule_timeout(__ret))
+
 /**
  * cwait_event_timeout - sleep until a condition gets true or a timeout elapses
  * @wq: the complex waitqueue to wait on
@@ -390,10 +501,22 @@ do {									\
 	__ret;								\
 })
 
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __swait_event_timeout(wq, condition, timeout);	\
+	__ret;								\
+})
+
 #define __cwait_event_cmd(wq, condition, cmd1, cmd2)			\
 	(void)___cwait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    cmd1; schedule(); cmd2)
 
+#define __swait_event_cmd(wq, condition, cmd1, cmd2)			\
+	(void)___swait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,	\
+			    cmd1; schedule(); cmd2)
+
 /**
  * cwait_event_cmd - sleep until a condition gets true
  * @wq: the complex waitqueue to wait on
@@ -415,10 +538,21 @@ do {									\
 	__cwait_event_cmd(wq, condition, cmd1, cmd2);			\
 } while (0)
 
+#define swait_event_cmd(wq, condition, cmd1, cmd2)			\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event_cmd(wq, condition, cmd1, cmd2);			\
+} while (0)
+
 #define __cwait_event_interruptible(wq, condition)			\
 	___cwait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
 		      schedule())
 
+#define __swait_event_interruptible(wq, condition)			\
+	___swait_event(wq, condition, TASK_INTERRUPTIBLE, 0,		\
+		      schedule())
+
 /**
  * cwait_event_interruptible - sleep until a condition gets true
  * @wq: the complex waitqueue to wait on
@@ -442,11 +576,24 @@ do {									\
 	__ret;								\
 })
 
+#define swait_event_interruptible(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __swait_event_interruptible(wq, condition);	\
+	__ret;								\
+})
+
 #define __cwait_event_interruptible_timeout(wq, condition, timeout)	\
 	___cwait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_INTERRUPTIBLE, 0, timeout,			\
 		      __ret = schedule_timeout(__ret))
 
+#define __swait_event_interruptible_timeout(wq, condition, timeout)	\
+	___swait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, timeout,			\
+		      __ret = schedule_timeout(__ret))
+
 /**
  * cwait_event_interruptible_timeout - sleep until a condition gets true or a
  *				       timeout elapses
@@ -475,6 +622,15 @@ do {									\
 	__ret;								\
 })
 
+#define swait_event_interruptible_timeout(wq, condition, timeout)	\
+({									\
+	long __ret = timeout;						\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __swait_event_interruptible_timeout(wq,		\
+						condition, timeout);	\
+	__ret;								\
+})
+
 #define __cwait_event_hrtimeout(wq, condition, timeout, state)		\
 ({									\
 	int __ret = 0;							\
@@ -500,6 +656,8 @@ do {									\
 	__ret;								\
 })
 
+/* no __swait_event_hrtimeout yet, as the cwait version has zero users */
+
 /**
  * cwait_event_hrtimeout - sleep until a condition gets true or a
  *			   timeout elapses
@@ -957,9 +1115,14 @@ do {									\
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
 void prepare_to_cwait(struct cwait_head *q, struct cwait *wait, int state);
+void prepare_to_swait(struct swait_head *q, struct swait *wait, int state);
+void __prepare_to_swait(struct swait_head *q, struct swait *wait);
 void prepare_to_cwait_exclusive(struct cwait_head *q, struct cwait *wait, int state);
 long prepare_to_cwait_event(struct cwait_head *q, struct cwait *wait, int state);
+long prepare_to_swait_event(struct swait_head *q, struct swait *wait, int state);
 void finish_cwait(struct cwait_head *q, struct cwait *wait);
+void finish_swait(struct swait_head *q, struct swait *wait);
+void __finish_swait(struct swait_head *q, struct swait *wait);
 void abort_exclusive_cwait(struct cwait_head *q, struct cwait *wait, unsigned int mode, void *key);
 int autoremove_cwake_function(struct cwait *wait, unsigned mode, int sync, void *key);
 int cwake_bit_function(struct cwait *wait, unsigned mode, int sync, void *key);
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index e62bd9c8aaf7..634427c25945 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -2,7 +2,25 @@
  * Generic waiting primitives.
  *
  * (C) 2004 Nadia Yvette Chambers, Oracle
+ *
+ * There are two different types of wait queues, the complex ones and the
+ * simple ones.  The complex ones are the original implementation, with
+ * custom callbacks and waiter specific flags (EXCLUSIVE).  But most users
+ * simply use the default (try_to_wake_up) callback and don't bother with
+ * any exclusive wakeup filtering, or key passing.
+ *
+ * Given that, we added simple wait queue support, which doesn't support
+ * custom callbacks or exclusive flags.  This reduces the associated struct
+ * sizes.  The simple wait queue manipulations are also done under the
+ * protection of a raw lock, which enables them to be used for general
+ * infrastructural tasks (completions, RCU, etc.) in a preempt-rt kernel.
+ *
+ * The two implementations exist as cwait_XYZ() and swait_XYZ(), and they
+ * parallel each other as much as possible.  Evidently there are some cases
+ * where no such swait parallel function exists -- as in the case for the
+ * exclusive variants of the cwait functions.
  */
+
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/sched.h>
@@ -19,6 +37,16 @@ void __init_cwait_head(struct cwait_head *q, const char *name,
 }
 EXPORT_SYMBOL(__init_cwait_head);
 
+void __init_swait_head(struct swait_head *q, const char *name,
+			    struct lock_class_key *key)
+{
+	raw_spin_lock_init(&q->lock);
+	lockdep_set_class_and_name(&q->lock, key, name);
+	INIT_LIST_HEAD(&q->task_list);
+}
+EXPORT_SYMBOL(__init_swait_head);
+
+
 void add_cwait(struct cwait_head *q, struct cwait *wait)
 {
 	unsigned long flags;
@@ -30,6 +58,16 @@ void add_cwait(struct cwait_head *q, struct cwait *wait)
 }
 EXPORT_SYMBOL(add_cwait);
 
+void add_swait(struct swait_head *q, struct swait *wait)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&q->lock, flags);
+	__add_swait(q, wait);
+	raw_spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(add_swait);
+
 void add_cwait_exclusive(struct cwait_head *q, struct cwait *wait)
 {
 	unsigned long flags;
@@ -51,6 +89,16 @@ void remove_cwait(struct cwait_head *q, struct cwait *wait)
 }
 EXPORT_SYMBOL(remove_cwait);
 
+void remove_swait(struct swait_head *q, struct swait *wait)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&q->lock, flags);
+	__remove_swait(q, wait);
+	raw_spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(remove_swait);
+
 
 /*
  * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
@@ -75,6 +123,32 @@ static void __cwake_up_common(struct cwait_head *q, unsigned int mode,
 	}
 }
 
+static void __swake_up_common(struct swait_head *q, unsigned int mode,
+			      int nr_exclusive)
+{
+	struct swait *curr, *next;
+	int woken = 0;
+
+	list_for_each_entry_safe(curr, next, &q->task_list, node) {
+		if (wake_up_state(curr->task, mode)) { /* <-- calls ttwu() */
+			__remove_swait(q, curr);
+			curr->task = NULL;
+			/*
+			 * The waiting task can free the waiter as
+			 * soon as curr->task = NULL is written,
+			 * without taking any locks. A memory barrier
+			 * is required here to prevent the following
+			 * store to curr->task from getting ahead of
+			 * the dequeue operation.
+			 */
+			smp_wmb();
+			if (++woken == nr_exclusive)
+				break;
+		}
+
+	}
+}
+
 /**
  * __cwake_up - wake up threads blocked on a waitqueue.
  * @q: the complex waitqueue
@@ -96,6 +170,19 @@ void __cwake_up(struct cwait_head *q, unsigned int mode, int nr_exclusive,
 }
 EXPORT_SYMBOL(__cwake_up);
 
+void __swake_up(struct swait_head *q, unsigned int mode, int nr_exclusive)
+{
+	unsigned long flags;
+
+	if (!swait_active(q))
+		return;
+
+	raw_spin_lock_irqsave(&q->lock, flags);
+	__swake_up_common(q, mode, nr_exclusive);
+	raw_spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(__swake_up);
+
 /*
  * Same as __cwake_up but called with the spinlock in struct cwait_head held.
  */
@@ -105,6 +192,15 @@ void __cwake_up_locked(struct cwait_head *q, unsigned int mode, int nr)
 }
 EXPORT_SYMBOL_GPL(__cwake_up_locked);
 
+void __swake_up_locked(struct swait_head *q, unsigned int state, int nr)
+{
+	if (!swait_active(q))
+		return;
+
+	__swake_up_common(q, state, nr);
+}
+EXPORT_SYMBOL_GPL(__swake_up_locked);
+
 void __cwake_up_locked_key(struct cwait_head *q, unsigned int mode, void *key)
 {
 	__cwake_up_common(q, mode, 1, 0, key);
@@ -180,6 +276,24 @@ void prepare_to_cwait(struct cwait_head *q, struct cwait *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_cwait);
 
+void __prepare_to_swait(struct swait_head *q, struct swait *wait)
+{
+	wait->task = current;
+	if (list_empty(&wait->node))
+		__add_swait(q, wait);
+}
+
+void prepare_to_swait(struct swait_head *q, struct swait *wait, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&q->lock, flags);
+	__prepare_to_swait(q, wait);
+	set_current_state(state);
+	raw_spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(prepare_to_swait);
+
 void prepare_to_cwait_exclusive(struct cwait_head *q, struct cwait *wait,
 				int state)
 {
@@ -218,6 +332,17 @@ long prepare_to_cwait_event(struct cwait_head *q, struct cwait *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_cwait_event);
 
+long prepare_to_swait_event(struct swait_head *q, struct swait *wait, int state)
+{
+	if (signal_pending_state(state, current))
+		return -ERESTARTSYS;
+
+	prepare_to_swait(q, wait, state);
+
+	return 0;
+}
+EXPORT_SYMBOL(prepare_to_swait_event);
+
 /**
  * finish_cwait - clean up after waiting in a queue
  * @q: complex waitqueue waited on
@@ -253,6 +378,24 @@ void finish_cwait(struct cwait_head *q, struct cwait *wait)
 }
 EXPORT_SYMBOL(finish_cwait);
 
+void __finish_swait(struct swait_head *q, struct swait *wait)
+{
+	__set_current_state(TASK_RUNNING);
+
+	if (wait->task)
+		__remove_swait(q, wait);
+}
+
+void finish_swait(struct swait_head *q, struct swait *wait)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&q->lock, flags);
+	__finish_swait(q, wait);
+	raw_spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(finish_swait);
+
 /**
  * abort_exclusive_cwait - abort exclusive waiting in a queue
  * @q: waitqueue waited on
-- 
1.9.2

