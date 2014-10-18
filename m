Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaJRA2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:28:53 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38571 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaJRA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:28:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/7] wait.h: mark complex wait functions to prepare for simple wait
Date: Fri, 17 Oct 2014 20:22:56 -0400
Message-ID: <1413591782-23453-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing wait queue code supports custom call backs and an
exclusive flag that can be used to limit the number of call backs
executed.  Most waiters do not need these two features, and so we
are adding simple wait queue support that reduces overhead for
users that aren't using those features.

The end goal is to explicitly distinguish between complex wait
and simple wait in the names of functions and structs.  We avoid
re-using the old namespace like "add_wait_foo(), to ensure people
play an active role in choosing which variant they want to use.

In order to achieve this in an incremental way that preserves
bisection, avoids "flag day" type changes, and allows tree wide
changes to be done at convenient times, we will do the following:

1) rename existing structs and functions with an additonal "c"
   to indicate they are the complex variants [limited to wait.h]

2) introduce temporary wait_xyz() ----> cwait_xyz() mappings that will
   let us do tree-wide conversions at our leisure (with coccinelle).
   The mappings can be disabled with #undef CWAIT_COMPAT for testing.

3) update existing core implementation of complex wait functions in
   kernel/sched/wait.c to have "c" prefix and hence not rely on #2

4) introduce simple wait support as swait_xyz() and friends into the
   now prepared kernel/sched/wait.c and include/linux/wait.h files.

5) deploy swait support for an initial select number of subsystems,
   like completions and RCU.

This commit achieves #1 and #2 in a single commit, as the two must be
paired together to ensure bisection is not broken.

Once the above are done, we will probably want to continue by:

a) Continue converting more cwait users over to swait on a per subsystem
   basis, for systems not really making use of the added functionality.

b) Use coccinelle to convert remaining implicit complex wait calls like
   wait_ABC() into cwait_ABC() as a rc1 [quiescent] treewide change.

c) remove the temporary mappings added in #2 above, once there are
   no more remaining ambiguous wait users w/o a "c" or "s" prefix.

d) Use coccinelle to remove existing wait_queue_t and wait_queue_head_t
   typedef users, and delete the typedefs.

Note that the "queue" has been dropped from waiter names where
appropriate; it was confusing anyway, since the list head really
served as the actual "queue", and the list elements were just individual
waiters, and not really queues themselves.  This helps shorten some of
the more cumbersome names like "__add_wait_queue_tail_exclusive()".

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6fb1ba5f9b2f..526e398cc249 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -9,35 +9,55 @@
 #include <asm/current.h>
 #include <uapi/linux/wait.h>
 
-typedef struct __wait_queue wait_queue_t;
-typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
-int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
+/*
+ * We are adding the distinction between complex wait queues with custom
+ * callbacks, and capped/exclusive number of wakes; vs simple wait queues
+ * that won't support either of those features.  Enable temporary mapping
+ * of wait_foo --> cwait_foo for ease of transition.  The define will
+ * enable ease of removal later, and allows a one-line change to enable
+ * testing of the coccinelle transformation tree-wide.
+ */
+#define CWAIT_COMPAT
+
+typedef struct cwait cwait_t;
+typedef int (*cwait_func_t)(cwait_t *wait, unsigned mode, int flags, void *key);
+int default_cwake_function(cwait_t *wait, unsigned mode, int flags, void *key);
 
-struct __wait_queue {
+struct cwait {
 	unsigned int		flags;
 #define WQ_FLAG_EXCLUSIVE	0x01
 	void			*private;
-	wait_queue_func_t	func;
+	cwait_func_t		func;
 	struct list_head	task_list;
 };
 
-struct wait_bit_key {
+struct cwait_bit_key {
 	void			*flags;
 	int			bit_nr;
-#define WAIT_ATOMIC_T_BIT_NR	-1
+#define CWAIT_ATOMIC_T_BIT_NR	-1
 	unsigned long		private;
 };
 
-struct wait_bit_queue {
-	struct wait_bit_key	key;
-	wait_queue_t		wait;
+struct cwait_bit {
+	struct cwait_bit_key	key;
+	struct cwait		wait;
 };
 
-struct __wait_queue_head {
+struct cwait_head {
 	spinlock_t		lock;
 	struct list_head	task_list;
 };
-typedef struct __wait_queue_head wait_queue_head_t;
+typedef struct cwait_head cwait_head_t;
+
+#ifdef CWAIT_COMPAT
+#define wait_queue_t		cwait_t
+#define wait_queue_head_t	cwait_head_t
+#define wait_queue_func_t	cwait_func_t
+#define default_wake_function	default_cwake_function
+#define wait_bit_key		cwait_bit_key
+#define wait_bit_queue		cwait_bit
+#define WAIT_ATOMIC_T_BIT_NR	CWAIT_ATOMIC_T_BIT_NR
+#endif
 
 struct task_struct;
 
@@ -45,70 +65,93 @@ struct task_struct;
  * Macros for declaration and initialisaton of the datatypes
  */
 
-#define __WAITQUEUE_INITIALIZER(name, tsk) {				\
+#define CWAIT_INITIALIZER(name, tsk) {					\
 	.private	= tsk,						\
-	.func		= default_wake_function,			\
+	.func		= default_cwake_function,			\
 	.task_list	= { NULL, NULL } }
 
-#define DECLARE_WAITQUEUE(name, tsk)					\
-	wait_queue_t name = __WAITQUEUE_INITIALIZER(name, tsk)
+#define DECLARE_CWAIT(name, tsk)					\
+	struct cwait name = CWAIT_INITIALIZER(name, tsk)
 
-#define __WAIT_QUEUE_HEAD_INITIALIZER(name) {				\
+#define CWAIT_HEAD_INITIALIZER(name) {					\
 	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),		\
 	.task_list	= { &(name).task_list, &(name).task_list } }
 
-#define DECLARE_WAIT_QUEUE_HEAD(name) \
-	wait_queue_head_t name = __WAIT_QUEUE_HEAD_INITIALIZER(name)
+#define DECLARE_CWAIT_HEAD(name) \
+	struct cwait_head name = CWAIT_HEAD_INITIALIZER(name)
 
-#define __WAIT_BIT_KEY_INITIALIZER(word, bit)				\
+#define CWAIT_BIT_KEY_INITIALIZER(word, bit)				\
 	{ .flags = word, .bit_nr = bit, }
 
-#define __WAIT_ATOMIC_T_KEY_INITIALIZER(p)				\
-	{ .flags = p, .bit_nr = WAIT_ATOMIC_T_BIT_NR, }
+#define CWAIT_ATOMIC_T_KEY_INITIALIZER(p)				\
+	{ .flags = p, .bit_nr = CWAIT_ATOMIC_T_BIT_NR, }
 
-extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *);
+extern void __init_cwait_head(struct cwait_head *q, const char *name,
+			      struct lock_class_key *);
 
-#define init_waitqueue_head(q)				\
+#define init_cwait_head(q)				\
 	do {						\
 		static struct lock_class_key __key;	\
 							\
-		__init_waitqueue_head((q), #q, &__key);	\
+		__init_cwait_head((q), #q, &__key);	\
 	} while (0)
 
 #ifdef CONFIG_LOCKDEP
-# define __WAIT_QUEUE_HEAD_INIT_ONSTACK(name) \
-	({ init_waitqueue_head(&name); name; })
-# define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) \
-	wait_queue_head_t name = __WAIT_QUEUE_HEAD_INIT_ONSTACK(name)
+# define CWAIT_HEAD_INIT_ONSTACK(name) \
+	({ init_cwait_head(&name); name; })
+# define DECLARE_CWAIT_HEAD_ONSTACK(name) \
+	struct cwait_head name = CWAIT_HEAD_INIT_ONSTACK(name)
 #else
-# define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
+# define DECLARE_CWAIT_HEAD_ONSTACK(name) DECLARE_CWAIT_HEAD(name)
 #endif
 
-static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
+static inline void init_cwait_entry(struct cwait *q, struct task_struct *p)
 {
 	q->flags	= 0;
 	q->private	= p;
-	q->func		= default_wake_function;
+	q->func		= default_cwake_function;
 }
 
-static inline void
-init_waitqueue_func_entry(wait_queue_t *q, wait_queue_func_t func)
+static inline void init_cwait_func_entry(struct cwait *q, cwait_func_t func)
 {
 	q->flags	= 0;
 	q->private	= NULL;
 	q->func		= func;
 }
 
-static inline int waitqueue_active(wait_queue_head_t *q)
+#ifdef CWAIT_COMPAT
+#define DECLARE_WAITQUEUE		DECLARE_CWAIT
+#define __WAITQUEUE_INITIALIZER		CWAIT_INITIALIZER
+#define DECLARE_WAIT_QUEUE_HEAD		DECLARE_CWAIT_HEAD
+#define __WAIT_QUEUE_HEAD_INITIALIZER	CWAIT_HEAD_INITIALIZER
+#define __WAIT_QUEUE_HEAD_INIT_ONSTACK	CWAIT_HEAD_INIT_ONSTACK
+#define DECLARE_WAIT_QUEUE_HEAD_ONSTACK	DECLARE_CWAIT_HEAD_ONSTACK
+#define __WAIT_BIT_KEY_INITIALIZER	CWAIT_BIT_KEY_INITIALIZER
+#define __WAIT_ATOMIC_T_KEY_INITIALIZER	CWAIT_ATOMIC_T_KEY_INITIALIZER
+
+#define __init_waitqueue_head		__init_cwait_head
+#define init_waitqueue_head		init_cwait_head
+#define init_waitqueue_entry		init_cwait_entry
+#define init_waitqueue_func_entry	init_cwait_func_entry
+#endif
+
+static inline int cwait_active(struct cwait_head *q)
 {
 	return !list_empty(&q->task_list);
 }
 
-extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
-extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
-extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
+extern void add_cwait(struct cwait_head *q, struct cwait *wait);
+extern void add_cwait_exclusive(struct cwait_head *q, struct cwait *wait);
+extern void remove_cwait(struct cwait_head *q, struct cwait *wait);
+
+#ifdef CWAIT_COMPAT
+#define waitqueue_active		cwait_active
+#define add_wait_queue			add_cwait
+#define add_wait_queue_exclusive	add_cwait_exclusive
+#define remove_wait_queue		remove_cwait
+#endif
 
-static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
+static inline void __add_cwait(struct cwait_head *head, struct cwait *new)
 {
 	list_add(&new->task_list, &head->task_list);
 }
@@ -116,71 +159,125 @@ static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 /*
  * Used for wake-one threads:
  */
-static inline void
-__add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
+static inline void __add_cwait_exclusive(struct cwait_head *q,
+					 struct cwait *wait)
 {
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
-	__add_wait_queue(q, wait);
+	__add_cwait(q, wait);
 }
 
-static inline void __add_wait_queue_tail(wait_queue_head_t *head,
-					 wait_queue_t *new)
+static inline void __add_cwait_tail(struct cwait_head *head,
+				    struct cwait *new)
 {
 	list_add_tail(&new->task_list, &head->task_list);
 }
 
-static inline void
-__add_wait_queue_tail_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
+static inline void __add_cwait_tail_exclusive(struct cwait_head *q,
+					      struct cwait *wait)
 {
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
-	__add_wait_queue_tail(q, wait);
+	__add_cwait_tail(q, wait);
 }
 
 static inline void
-__remove_wait_queue(wait_queue_head_t *head, wait_queue_t *old)
+__remove_cwait(struct cwait_head *head, struct cwait *old)
 {
 	list_del(&old->task_list);
 }
 
-typedef int wait_bit_action_f(struct wait_bit_key *);
-void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
-void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
-void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
-void __wake_up_bit(wait_queue_head_t *, void *, int);
-int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
-int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
-void wake_up_bit(void *, int);
-void wake_up_atomic_t(atomic_t *);
-int out_of_line_wait_on_bit(void *, int, wait_bit_action_f *, unsigned);
-int out_of_line_wait_on_bit_lock(void *, int, wait_bit_action_f *, unsigned);
-int out_of_line_wait_on_atomic_t(atomic_t *, int (*)(atomic_t *), unsigned);
-wait_queue_head_t *bit_waitqueue(void *, int);
-
-#define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
-#define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
-#define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
-#define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
-
-#define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
-#define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
-#define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
-#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
+#ifdef CWAIT_COMPAT
+#define __add_wait_queue		__add_cwait
+#define __remove_wait_queue		__remove_cwait
+#define __add_wait_queue_tail		__add_cwait_tail
+#define __add_wait_queue_exclusive	__add_cwait_exclusive
+#define __add_wait_queue_tail_exclusive	__add_cwait_tail_exclusive
+#endif
+
+typedef int cwait_bit_action_f(struct wait_bit_key *);
+void __cwake_up(struct cwait_head *q, unsigned int mode, int nr, void *key);
+void __cwake_up_locked_key(struct cwait_head *q, unsigned int mode, void *key);
+void __cwake_up_sync_key(struct cwait_head *q, unsigned int mode, int nr, void *key);
+void __cwake_up_locked(struct cwait_head *q, unsigned int mode, int nr);
+void __cwake_up_sync(struct cwait_head *q, unsigned int mode, int nr);
+void __cwake_up_bit(struct cwait_head *, void *, int);
+int __cwait_on_bit(struct cwait_head *, struct cwait_bit *, cwait_bit_action_f *, unsigned);
+int __cwait_on_bit_lock(struct cwait_head *, struct cwait_bit *, cwait_bit_action_f *, unsigned);
+
+#ifdef CWAIT_COMPAT
+#define wait_bit_action_f		cwait_bit_action_f
+#define __wake_up			__cwake_up
+#define __wake_up_locked_key		__cwake_up_locked_key
+#define __wake_up_sync_key		__cwake_up_sync_key
+#define __wake_up_locked		__cwake_up_locked
+#define __wake_up_sync			__cwake_up_sync
+#define __wake_up_bit			__cwake_up_bit
+#define __wait_on_bit			__cwait_on_bit
+#define __wait_on_bit_lock		__cwait_on_bit_lock
+#endif
+
+void cwake_up_bit(void *, int);
+void cwake_up_atomic_t(atomic_t *);
+int out_of_line_cwait_on_bit(void *, int, cwait_bit_action_f *, unsigned);
+int out_of_line_cwait_on_bit_lock(void *, int, cwait_bit_action_f *, unsigned);
+int out_of_line_cwait_on_atomic_t(atomic_t *, int (*)(atomic_t *), unsigned);
+struct cwait_head *bit_cwaitqueue(void *, int);
+
+#define cwake_up(x)			__cwake_up(x, TASK_NORMAL, 1, NULL)
+#define cwake_up_nr(x, nr)		__cwake_up(x, TASK_NORMAL, nr, NULL)
+#define cwake_up_all(x)			__cwake_up(x, TASK_NORMAL, 0, NULL)
+#define cwake_up_locked(x)		__cwake_up_locked((x), TASK_NORMAL, 1)
+#define cwake_up_all_locked(x)		__cwake_up_locked((x), TASK_NORMAL, 0)
+
+#ifdef CWAIT_COMPAT
+#define wake_up				cwake_up
+#define wake_up_nr			cwake_up_nr
+#define wake_up_all			cwake_up_all
+#define wake_up_bit			cwake_up_bit
+#define wake_up_atomic_t		cwake_up_atomic_t
+#define out_of_line_wait_on_bit		out_of_line_cwait_on_bit
+#define out_of_line_wait_on_bit_lock	out_of_line_cwait_on_bit_lock
+#define out_of_line_wait_on_atomic_t	out_of_line_cwait_on_atomic_t
+#define bit_waitqueue			bit_cwaitqueue
+#define wake_up_locked			cwake_up_locked
+#define wake_up_all_locked		cwake_up_all_locked
+#endif
+
+#define cwake_up_interruptible(x)					\
+	__cwake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
+#define cwake_up_interruptible_nr(x, nr)				\
+	__cwake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
+#define cwake_up_interruptible_all(x)					\
+	__cwake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
+#define cwake_up_interruptible_sync(x)					\
+	__cwake_up_sync((x), TASK_INTERRUPTIBLE, 1)
+
+#ifdef CWAIT_COMPAT
+#define wake_up_interruptible		cwake_up_interruptible
+#define wake_up_interruptible_nr	cwake_up_interruptible_nr
+#define wake_up_interruptible_all	cwake_up_interruptible_all
+#define wake_up_interruptible_sync	cwake_up_interruptible_sync
+#endif
 
 /*
  * Wakeup macros to be used to report events to the targets.
  */
-#define wake_up_poll(x, m)						\
-	__wake_up(x, TASK_NORMAL, 1, (void *) (m))
-#define wake_up_locked_poll(x, m)					\
-	__wake_up_locked_key((x), TASK_NORMAL, (void *) (m))
-#define wake_up_interruptible_poll(x, m)				\
-	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
-#define wake_up_interruptible_sync_poll(x, m)				\
-	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
+#define cwake_up_poll(x, m)						\
+	__cwake_up(x, TASK_NORMAL, 1, (void *) (m))
+#define cwake_up_locked_poll(x, m)					\
+	__cwake_up_locked_key((x), TASK_NORMAL, (void *) (m))
+#define cwake_up_interruptible_poll(x, m)				\
+	__cwake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
+#define cwake_up_interruptible_sync_poll(x, m)				\
+	__cwake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
+
+#ifdef CWAIT_COMPAT
+#define wake_up_poll			cwake_up_poll
+#define wake_up_locked_poll		cwake_up_locked_poll
+#define wake_up_interruptible_poll	cwake_up_interruptible_poll
+#define wake_up_interruptible_sync_poll	cwake_up_interruptible_sync_poll
+#endif
 
+/* valid for both simple and complex wait queues */
 #define ___wait_cond_timeout(condition)					\
 ({									\
 	bool __cond = (condition);					\
@@ -189,26 +286,27 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 	__cond || !__ret;						\
 })
 
+/* valid for both simple and complex wait queues */
 #define ___wait_is_interruptible(state)					\
 	(!__builtin_constant_p(state) ||				\
 		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
 
 /*
- * The below macro ___wait_event() has an explicit shadow of the __ret
+ * The below macro ___cwait_event() has an explicit shadow of the __ret
  * variable when used from the wait_event_*() macros.
  *
- * This is so that both can use the ___wait_cond_timeout() construct
+ * This is so that both can use the ___cwait_cond_timeout() construct
  * to wrap the condition.
  *
- * The type inconsistency of the wait_event_*() __ret variable is also
+ * The type inconsistency of the cwait_event_*() __ret variable is also
  * on purpose; we use long where we can return timeout values and int
  * otherwise.
  */
 
-#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
+#define ___cwait_event(wq, condition, state, exclusive, ret, cmd)	\
 ({									\
 	__label__ __out;						\
-	wait_queue_t __wait;						\
+	struct cwait __wait;						\
 	long __ret = ret;	/* explicit shadow */			\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
@@ -218,7 +316,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 		__wait.flags = 0;					\
 									\
 	for (;;) {							\
-		long __int = prepare_to_wait_event(&wq, &__wait, state);\
+		long __int = prepare_to_cwait_event(&wq, &__wait, state);\
 									\
 		if (condition)						\
 			break;						\
@@ -226,8 +324,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 		if (___wait_is_interruptible(state) && __int) {		\
 			__ret = __int;					\
 			if (exclusive) {				\
-				abort_exclusive_wait(&wq, &__wait,	\
-						     state, NULL);	\
+				abort_exclusive_cwait(&wq, &__wait,	\
+						      state, NULL);	\
 				goto __out;				\
 			}						\
 			break;						\
@@ -235,41 +333,41 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 									\
 		cmd;							\
 	}								\
-	finish_wait(&wq, &__wait);					\
+	finish_cwait(&wq, &__wait);					\
 __out:	__ret;								\
 })
 
-#define __wait_event(wq, condition)					\
-	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+#define __cwait_event(wq, condition)					\
+	(void)___cwait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    schedule())
 
 /**
- * wait_event - sleep until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event - sleep until a condition gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  *
  * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
  * @condition evaluates to true. The @condition is checked each time
  * the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  */
-#define wait_event(wq, condition)					\
+#define cwait_event(wq, condition)					\
 do {									\
 	if (condition)							\
 		break;							\
-	__wait_event(wq, condition);					\
+	__cwait_event(wq, condition);					\
 } while (0)
 
-#define __wait_event_timeout(wq, condition, timeout)			\
-	___wait_event(wq, ___wait_cond_timeout(condition),		\
+#define __cwait_event_timeout(wq, condition, timeout)			\
+	___cwait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
 		      __ret = schedule_timeout(__ret))
 
 /**
- * wait_event_timeout - sleep until a condition gets true or a timeout elapses
- * @wq: the waitqueue to wait on
+ * cwait_event_timeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @timeout: timeout, in jiffies
  *
@@ -277,28 +375,28 @@ do {									\
  * @condition evaluates to true. The @condition is checked each time
  * the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * The function returns 0 if the @timeout elapsed, or the remaining
  * jiffies (at least 1) if the @condition evaluated to %true before
  * the @timeout elapsed.
  */
-#define wait_event_timeout(wq, condition, timeout)			\
+#define cwait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
 	if (!___wait_cond_timeout(condition))				\
-		__ret = __wait_event_timeout(wq, condition, timeout);	\
+		__ret = __cwait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
 
-#define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
-	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+#define __cwait_event_cmd(wq, condition, cmd1, cmd2)			\
+	(void)___cwait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    cmd1; schedule(); cmd2)
 
 /**
- * wait_event_cmd - sleep until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event_cmd - sleep until a condition gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @cmd1: the command will be executed before sleep
  * @cmd2: the command will be executed after sleep
@@ -310,20 +408,20 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  */
-#define wait_event_cmd(wq, condition, cmd1, cmd2)			\
+#define cwait_event_cmd(wq, condition, cmd1, cmd2)			\
 do {									\
 	if (condition)							\
 		break;							\
-	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
+	__cwait_event_cmd(wq, condition, cmd1, cmd2);			\
 } while (0)
 
-#define __wait_event_interruptible(wq, condition)			\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
+#define __cwait_event_interruptible(wq, condition)			\
+	___cwait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
 		      schedule())
 
 /**
- * wait_event_interruptible - sleep until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event_interruptible - sleep until a condition gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  *
  * The process is put to sleep (TASK_INTERRUPTIBLE) until the
@@ -336,22 +434,23 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible(wq, condition)				\
+#define cwait_event_interruptible(wq, condition)			\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_interruptible(wq, condition);	\
+		__ret = __cwait_event_interruptible(wq, condition);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_timeout(wq, condition, timeout)	\
-	___wait_event(wq, ___wait_cond_timeout(condition),		\
+#define __cwait_event_interruptible_timeout(wq, condition, timeout)	\
+	___cwait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_INTERRUPTIBLE, 0, timeout,			\
 		      __ret = schedule_timeout(__ret))
 
 /**
- * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
- * @wq: the waitqueue to wait on
+ * cwait_event_interruptible_timeout - sleep until a condition gets true or a
+ *				       timeout elapses
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @timeout: timeout, in jiffies
  *
@@ -359,7 +458,7 @@ do {									\
  * @condition evaluates to true or a signal is received.
  * The @condition is checked each time the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * Returns:
@@ -367,16 +466,16 @@ do {									\
  * a signal, or the remaining jiffies (at least 1) if the @condition
  * evaluated to %true before the @timeout elapsed.
  */
-#define wait_event_interruptible_timeout(wq, condition, timeout)	\
+#define cwait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
 	if (!___wait_cond_timeout(condition))				\
-		__ret = __wait_event_interruptible_timeout(wq,		\
+		__ret = __cwait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
 	__ret;								\
 })
 
-#define __wait_event_hrtimeout(wq, condition, timeout, state)		\
+#define __cwait_event_hrtimeout(wq, condition, timeout, state)		\
 ({									\
 	int __ret = 0;							\
 	struct hrtimer_sleeper __t;					\
@@ -389,7 +488,7 @@ do {									\
 				       current->timer_slack_ns,		\
 				       HRTIMER_MODE_REL);		\
 									\
-	__ret = ___wait_event(wq, condition, state, 0, 0,		\
+	__ret = ___cwait_event(wq, condition, state, 0, 0,		\
 		if (!__t.task) {					\
 			__ret = -ETIME;					\
 			break;						\
@@ -402,8 +501,9 @@ do {									\
 })
 
 /**
- * wait_event_hrtimeout - sleep until a condition gets true or a timeout elapses
- * @wq: the waitqueue to wait on
+ * cwait_event_hrtimeout - sleep until a condition gets true or a
+ *			   timeout elapses
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @timeout: timeout, as a ktime_t
  *
@@ -411,24 +511,25 @@ do {									\
  * @condition evaluates to true or a signal is received.
  * The @condition is checked each time the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * The function returns 0 if @condition became true, or -ETIME if the timeout
  * elapsed.
  */
-#define wait_event_hrtimeout(wq, condition, timeout)			\
+#define cwait_event_hrtimeout(wq, condition, timeout)			\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
+		__ret = __cwait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_UNINTERRUPTIBLE);	\
 	__ret;								\
 })
 
 /**
- * wait_event_interruptible_hrtimeout - sleep until a condition gets true or a timeout elapses
- * @wq: the waitqueue to wait on
+ * cwait_event_interruptible_hrtimeout - sleep until a condition gets true or
+ *					 a timeout elapses
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @timeout: timeout, as a ktime_t
  *
@@ -442,37 +543,37 @@ do {									\
  * The function returns 0 if @condition became true, -ERESTARTSYS if it was
  * interrupted by a signal, or -ETIME if the timeout elapsed.
  */
-#define wait_event_interruptible_hrtimeout(wq, condition, timeout)	\
+#define cwait_event_interruptible_hrtimeout(wq, condition, timeout)	\
 ({									\
 	long __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_hrtimeout(wq, condition, timeout,	\
+		__ret = __cwait_event_hrtimeout(wq, condition, timeout,	\
 					       TASK_INTERRUPTIBLE);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_exclusive(wq, condition)		\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, 0,		\
+#define __cwait_event_interruptible_exclusive(wq, condition)		\
+	___cwait_event(wq, condition, TASK_INTERRUPTIBLE, 1, 0,		\
 		      schedule())
 
-#define wait_event_interruptible_exclusive(wq, condition)		\
+#define cwait_event_interruptible_exclusive(wq, condition)		\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_interruptible_exclusive(wq, condition);\
+		__ret = __cwait_event_interruptible_exclusive(wq, condition);\
 	__ret;								\
 })
 
 
-#define __wait_event_interruptible_locked(wq, condition, exclusive, irq) \
+#define __cwait_event_interruptible_locked(wq, condition, exclusive, irq)\
 ({									\
 	int __ret = 0;							\
-	DEFINE_WAIT(__wait);						\
+	DEFINE_CWAIT(__wait);						\
 	if (exclusive)							\
 		__wait.flags |= WQ_FLAG_EXCLUSIVE;			\
 	do {								\
 		if (likely(list_empty(&__wait.task_list)))		\
-			__add_wait_queue_tail(&(wq), &__wait);		\
+			__add_cwait_tail(&(wq), &__wait);		\
 		set_current_state(TASK_INTERRUPTIBLE);			\
 		if (signal_pending(current)) {				\
 			__ret = -ERESTARTSYS;				\
@@ -488,15 +589,15 @@ do {									\
 		else							\
 			spin_lock(&(wq).lock);				\
 	} while (!(condition));						\
-	__remove_wait_queue(&(wq), &__wait);				\
+	__remove_cwait(&(wq), &__wait);					\
 	__set_current_state(TASK_RUNNING);				\
 	__ret;								\
 })
 
 
 /**
- * wait_event_interruptible_locked - sleep until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event_interruptible_locked - sleep until a condition gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  *
  * The process is put to sleep (TASK_INTERRUPTIBLE) until the
@@ -517,13 +618,13 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible_locked(wq, condition)			\
+#define cwait_event_interruptible_locked(wq, condition)			\
 	((condition)							\
-	 ? 0 : __wait_event_interruptible_locked(wq, condition, 0, 0))
+	 ? 0 : __cwait_event_interruptible_locked(wq, condition, 0, 0))
 
 /**
- * wait_event_interruptible_locked_irq - sleep until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event_interruptible_locked_irq - sleep until a condition gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  *
  * The process is put to sleep (TASK_INTERRUPTIBLE) until the
@@ -544,13 +645,14 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible_locked_irq(wq, condition)		\
+#define cwait_event_interruptible_locked_irq(wq, condition)		\
 	((condition)							\
-	 ? 0 : __wait_event_interruptible_locked(wq, condition, 0, 1))
+	 ? 0 : __cwait_event_interruptible_locked(wq, condition, 0, 1))
 
 /**
- * wait_event_interruptible_exclusive_locked - sleep exclusively until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event_interruptible_exclusive_locked - sleep exclusively until a
+ *						condition gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  *
  * The process is put to sleep (TASK_INTERRUPTIBLE) until the
@@ -569,19 +671,20 @@ do {									\
  * set thus when other process waits process on the list if this
  * process is awaken further processes are not considered.
  *
- * wake_up_locked() has to be called after changing any variable that could
+ * cwake_up_locked() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible_exclusive_locked(wq, condition)	\
+#define cwait_event_interruptible_exclusive_locked(wq, condition)	\
 	((condition)							\
-	 ? 0 : __wait_event_interruptible_locked(wq, condition, 1, 0))
+	 ? 0 : __cwait_event_interruptible_locked(wq, condition, 1, 0))
 
 /**
- * wait_event_interruptible_exclusive_locked_irq - sleep until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event_interruptible_exclusive_locked_irq - sleep until a condition
+ *						    gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  *
  * The process is put to sleep (TASK_INTERRUPTIBLE) until the
@@ -606,51 +709,51 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible_exclusive_locked_irq(wq, condition)	\
+#define cwait_event_interruptible_exclusive_locked_irq(wq, condition)	\
 	((condition)							\
-	 ? 0 : __wait_event_interruptible_locked(wq, condition, 1, 1))
+	 ? 0 : __cwait_event_interruptible_locked(wq, condition, 1, 1))
 
 
-#define __wait_event_killable(wq, condition)				\
-	___wait_event(wq, condition, TASK_KILLABLE, 0, 0, schedule())
+#define __cwait_event_killable(wq, condition)				\
+	___cwait_event(wq, condition, TASK_KILLABLE, 0, 0, schedule())
 
 /**
- * wait_event_killable - sleep until a condition gets true
- * @wq: the waitqueue to wait on
+ * cwait_event_killable - sleep until a condition gets true
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  *
  * The process is put to sleep (TASK_KILLABLE) until the
  * @condition evaluates to true or a signal is received.
  * The @condition is checked each time the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_killable(wq, condition)				\
+#define cwait_event_killable(wq, condition)				\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_killable(wq, condition);		\
+		__ret = __cwait_event_killable(wq, condition);		\
 	__ret;								\
 })
 
 
-#define __wait_event_lock_irq(wq, condition, lock, cmd)			\
-	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+#define __cwait_event_lock_irq(wq, condition, lock, cmd)		\
+	(void)___cwait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    spin_unlock_irq(&lock);			\
 			    cmd;					\
 			    schedule();					\
 			    spin_lock_irq(&lock))
 
 /**
- * wait_event_lock_irq_cmd - sleep until a condition gets true. The
- *			     condition is checked under the lock. This
- *			     is expected to be called with the lock
- *			     taken.
- * @wq: the waitqueue to wait on
+ * cwait_event_lock_irq_cmd - sleep until a condition gets true. The
+ *			      condition is checked under the lock. This
+ *			      is expected to be called with the lock
+ *			      taken.
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @lock: a locked spinlock_t, which will be released before cmd
  *	  and schedule() and reacquired afterwards.
@@ -661,26 +764,26 @@ do {									\
  * @condition evaluates to true. The @condition is checked each time
  * the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
  * dropped before invoking the cmd and going to sleep and is reacquired
  * afterwards.
  */
-#define wait_event_lock_irq_cmd(wq, condition, lock, cmd)		\
+#define cwait_event_lock_irq_cmd(wq, condition, lock, cmd)		\
 do {									\
 	if (condition)							\
 		break;							\
-	__wait_event_lock_irq(wq, condition, lock, cmd);		\
+	__cwait_event_lock_irq(wq, condition, lock, cmd);		\
 } while (0)
 
 /**
- * wait_event_lock_irq - sleep until a condition gets true. The
- *			 condition is checked under the lock. This
- *			 is expected to be called with the lock
- *			 taken.
- * @wq: the waitqueue to wait on
+ * cwait_event_lock_irq - sleep until a condition gets true. The
+ *			  condition is checked under the lock. This
+ *			  is expected to be called with the lock
+ *			  taken.
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @lock: a locked spinlock_t, which will be released before schedule()
  *	  and reacquired afterwards.
@@ -695,26 +798,26 @@ do {									\
  * This is supposed to be called while holding the lock. The lock is
  * dropped before going to sleep and is reacquired afterwards.
  */
-#define wait_event_lock_irq(wq, condition, lock)			\
+#define cwait_event_lock_irq(wq, condition, lock)			\
 do {									\
 	if (condition)							\
 		break;							\
-	__wait_event_lock_irq(wq, condition, lock, );			\
+	__cwait_event_lock_irq(wq, condition, lock, );			\
 } while (0)
 
 
-#define __wait_event_interruptible_lock_irq(wq, condition, lock, cmd)	\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
+#define __cwait_event_interruptible_lock_irq(wq, condition, lock, cmd)	\
+	___cwait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
 		      spin_unlock_irq(&lock);				\
 		      cmd;						\
 		      schedule();					\
 		      spin_lock_irq(&lock))
 
 /**
- * wait_event_interruptible_lock_irq_cmd - sleep until a condition gets true.
+ * cwait_event_interruptible_lock_irq_cmd - sleep until a condition gets true.
  *		The condition is checked under the lock. This is expected to
  *		be called with the lock taken.
- * @wq: the waitqueue to wait on
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @lock: a locked spinlock_t, which will be released before cmd and
  *	  schedule() and reacquired afterwards.
@@ -725,7 +828,7 @@ do {									\
  * @condition evaluates to true or a signal is received. The @condition is
  * checked each time the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
@@ -735,20 +838,20 @@ do {									\
  * The macro will return -ERESTARTSYS if it was interrupted by a signal
  * and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible_lock_irq_cmd(wq, condition, lock, cmd)	\
+#define cwait_event_interruptible_lock_irq_cmd(wq, condition, lock, cmd)\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_interruptible_lock_irq(wq,		\
+		__ret = __cwait_event_interruptible_lock_irq(wq,	\
 						condition, lock, cmd);	\
 	__ret;								\
 })
 
 /**
- * wait_event_interruptible_lock_irq - sleep until a condition gets true.
+ * cwait_event_interruptible_lock_irq - sleep until a condition gets true.
  *		The condition is checked under the lock. This is expected
  *		to be called with the lock taken.
- * @wq: the waitqueue to wait on
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @lock: a locked spinlock_t, which will be released before schedule()
  *	  and reacquired afterwards.
@@ -757,7 +860,7 @@ do {									\
  * @condition evaluates to true or signal is received. The @condition is
  * checked each time the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
@@ -766,28 +869,28 @@ do {									\
  * The macro will return -ERESTARTSYS if it was interrupted by a signal
  * and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible_lock_irq(wq, condition, lock)		\
+#define cwait_event_interruptible_lock_irq(wq, condition, lock)		\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__ret = __wait_event_interruptible_lock_irq(wq,		\
+		__ret = __cwait_event_interruptible_lock_irq(wq,	\
 						condition, lock,);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
+#define __cwait_event_interruptible_lock_irq_timeout(wq, condition,	\
 						    lock, timeout)	\
-	___wait_event(wq, ___wait_cond_timeout(condition),		\
+	___cwait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_INTERRUPTIBLE, 0, timeout,			\
 		      spin_unlock_irq(&lock);				\
 		      __ret = schedule_timeout(__ret);			\
 		      spin_lock_irq(&lock));
 
 /**
- * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets
+ * cwait_event_interruptible_lock_irq_timeout - sleep until a condition gets
  *		true or a timeout elapses. The condition is checked under
  *		the lock. This is expected to be called with the lock taken.
- * @wq: the waitqueue to wait on
+ * @wq: the complex waitqueue to wait on
  * @condition: a C expression for the event to wait for
  * @lock: a locked spinlock_t, which will be released before schedule()
  *	  and reacquired afterwards.
@@ -797,7 +900,7 @@ do {									\
  * @condition evaluates to true or signal is received. The @condition is
  * checked each time the waitqueue @wq is woken up.
  *
- * wake_up() has to be called after changing any variable that could
+ * cwake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
@@ -807,61 +910,110 @@ do {									\
  * was interrupted by a signal, and the remaining jiffies otherwise
  * if the condition evaluated to true before the timeout elapsed.
  */
-#define wait_event_interruptible_lock_irq_timeout(wq, condition, lock,	\
+#define cwait_event_interruptible_lock_irq_timeout(wq, condition, lock,	\
 						  timeout)		\
 ({									\
 	long __ret = timeout;						\
 	if (!___wait_cond_timeout(condition))				\
-		__ret = __wait_event_interruptible_lock_irq_timeout(	\
+		__ret = __cwait_event_interruptible_lock_irq_timeout(	\
 					wq, condition, lock, timeout);	\
 	__ret;								\
 })
 
+#ifdef CWAIT_COMPAT
+#define wait_event			cwait_event
+#define __wait_event			__cwait_event
+#define ___wait_event			___cwait_event
+#define wait_event_cmd			cwait_event_cmd
+#define wait_event_timeout		cwait_event_timeout
+#define wait_event_killable		cwait_event_killable
+#define wait_event_lock_irq		cwait_event_lock_irq
+#define wait_event_lock_irq_cmd		cwait_event_lock_irq_cmd
+#define wait_event_interruptible	cwait_event_interruptible
+#define __wait_event_interruptible	__cwait_event_interruptible
+#define wait_event_interruptible_timeout				\
+				cwait_event_interruptible_timeout
+#define wait_event_interruptible_hrtimeout				\
+				cwait_event_interruptible_hrtimeout
+#define wait_event_interruptible_exclusive				\
+				cwait_event_interruptible_exclusive
+#define wait_event_interruptible_locked					\
+				cwait_event_interruptible_locked
+#define wait_event_interruptible_lock_irq				\
+				cwait_event_interruptible_lock_irq
+#define wait_event_interruptible_locked_irq				\
+				cwait_event_interruptible_locked_irq
+#define wait_event_interruptible_lock_irq_cmd				\
+				cwait_event_interruptible_lock_irq_cmd
+#define wait_event_interruptible_lock_irq_timeout			\
+				cwait_event_interruptible_lock_irq_timeout
+#define wait_event_interruptible_exclusive_locked			\
+				cwait_event_interruptible_exclusive_locked
+#define wait_event_interruptible_exclusive_locked_irq			\
+				cwait_event_interruptible_exclusive_locked_irq
+#endif
+
 /*
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
-void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
-void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
-long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
-void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
-void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigned int mode, void *key);
-int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
-int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
-
-#define DEFINE_WAIT_FUNC(name, function)				\
-	wait_queue_t name = {						\
+void prepare_to_cwait(struct cwait_head *q, struct cwait *wait, int state);
+void prepare_to_cwait_exclusive(struct cwait_head *q, struct cwait *wait, int state);
+long prepare_to_cwait_event(struct cwait_head *q, struct cwait *wait, int state);
+void finish_cwait(struct cwait_head *q, struct cwait *wait);
+void abort_exclusive_cwait(struct cwait_head *q, struct cwait *wait, unsigned int mode, void *key);
+int autoremove_cwake_function(struct cwait *wait, unsigned mode, int sync, void *key);
+int cwake_bit_function(struct cwait *wait, unsigned mode, int sync, void *key);
+
+#ifdef CWAIT_COMPAT
+#define prepare_to_wait			prepare_to_cwait
+#define prepare_to_wait_exclusive	prepare_to_cwait_exclusive
+#define prepare_to_wait_event		prepare_to_cwait_event
+#define finish_wait			finish_cwait
+#define abort_exclusive_wait		abort_exclusive_cwait
+#define autoremove_wake_function	autoremove_cwake_function
+#define wake_bit_function		cwake_bit_function
+#endif
+
+#define DEFINE_CWAIT_FUNC(name, function)				\
+	struct cwait name = {						\
 		.private	= current,				\
 		.func		= function,				\
 		.task_list	= LIST_HEAD_INIT((name).task_list),	\
 	}
 
-#define DEFINE_WAIT(name) DEFINE_WAIT_FUNC(name, autoremove_wake_function)
+#define DEFINE_CWAIT(name) DEFINE_CWAIT_FUNC(name, autoremove_wake_function)
 
-#define DEFINE_WAIT_BIT(name, word, bit)				\
-	struct wait_bit_queue name = {					\
-		.key = __WAIT_BIT_KEY_INITIALIZER(word, bit),		\
+#define DEFINE_CWAIT_BIT(name, word, bit)				\
+	struct cwait_bit name = {					\
+		.key =	CWAIT_BIT_KEY_INITIALIZER(word, bit),		\
 		.wait	= {						\
 			.private	= current,			\
-			.func		= wake_bit_function,		\
+			.func		= cwake_bit_function,		\
 			.task_list	=				\
 				LIST_HEAD_INIT((name).wait.task_list),	\
 		},							\
 	}
 
-#define init_wait(wait)							\
+#define init_cwait(wait)						\
 	do {								\
 		(wait)->private = current;				\
-		(wait)->func = autoremove_wake_function;		\
+		(wait)->func = autoremove_cwake_function;		\
 		INIT_LIST_HEAD(&(wait)->task_list);			\
 		(wait)->flags = 0;					\
 	} while (0)
 
+#ifdef CWAIT_COMPAT
+#define DEFINE_WAIT_FUNC	DEFINE_CWAIT_FUNC
+#define DEFINE_WAIT		DEFINE_CWAIT
+#define DEFINE_WAIT_BIT		DEFINE_CWAIT_BIT
+#define init_wait		init_cwait
+#endif
 
 extern int bit_wait(struct wait_bit_key *);
 extern int bit_wait_io(struct wait_bit_key *);
 
 /**
- * wait_on_bit - wait for a bit to be cleared
+ * cwait_on_bit - wait for a bit to be cleared
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
  * @mode: the task state to sleep in
@@ -869,7 +1021,7 @@ extern int bit_wait_io(struct wait_bit_key *);
  * There is a standard hashed waitqueue table for generic use. This
  * is the part of the hashtable's accessor API that waits on a bit.
  * For instance, if one were to have waiters on a bitflag, one would
- * call wait_on_bit() in threads waiting for the bit to clear.
+ * call cwait_on_bit() in threads waiting for the bit to clear.
  * One uses wait_on_bit() where one is waiting for the bit to clear,
  * but has no intention of setting it.
  * Returned value will be zero if the bit was cleared, or non-zero
@@ -877,23 +1029,23 @@ extern int bit_wait_io(struct wait_bit_key *);
  * on that signal.
  */
 static inline int
-wait_on_bit(void *word, int bit, unsigned mode)
+cwait_on_bit(void *word, int bit, unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
-	return out_of_line_wait_on_bit(word, bit,
-				       bit_wait,
-				       mode);
+	return out_of_line_cwait_on_bit(word, bit,
+					bit_wait,
+					mode);
 }
 
 /**
- * wait_on_bit_io - wait for a bit to be cleared
+ * cwait_on_bit_io - wait for a bit to be cleared
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
  * @mode: the task state to sleep in
  *
  * Use the standard hashed waitqueue table to wait for a bit
- * to be cleared.  This is similar to wait_on_bit(), but calls
+ * to be cleared.  This is similar to cwait_on_bit(), but calls
  * io_schedule() instead of schedule() for the actual waiting.
  *
  * Returned value will be zero if the bit was cleared, or non-zero
@@ -901,17 +1053,17 @@ wait_on_bit(void *word, int bit, unsigned mode)
  * on that signal.
  */
 static inline int
-wait_on_bit_io(void *word, int bit, unsigned mode)
+cwait_on_bit_io(void *word, int bit, unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
-	return out_of_line_wait_on_bit(word, bit,
-				       bit_wait_io,
-				       mode);
+	return out_of_line_cwait_on_bit(word, bit,
+					bit_wait_io,
+					mode);
 }
 
 /**
- * wait_on_bit_action - wait for a bit to be cleared
+ * cwait_on_bit_action - wait for a bit to be cleared
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
  * @action: the function used to sleep, which may take special actions
@@ -919,7 +1071,7 @@ wait_on_bit_io(void *word, int bit, unsigned mode)
  *
  * Use the standard hashed waitqueue table to wait for a bit
  * to be cleared, and allow the waiting action to be specified.
- * This is like wait_on_bit() but allows fine control of how the waiting
+ * This is like cwait_on_bit() but allows fine control of how the waiting
  * is done.
  *
  * Returned value will be zero if the bit was cleared, or non-zero
@@ -927,15 +1079,15 @@ wait_on_bit_io(void *word, int bit, unsigned mode)
  * on that signal.
  */
 static inline int
-wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
+cwait_on_bit_action(void *word, int bit, cwait_bit_action_f *action, unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
-	return out_of_line_wait_on_bit(word, bit, action, mode);
+	return out_of_line_cwait_on_bit(word, bit, action, mode);
 }
 
 /**
- * wait_on_bit_lock - wait for a bit to be cleared, when wanting to set it
+ * cwait_on_bit_lock - wait for a bit to be cleared, when wanting to set it
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
  * @mode: the task state to sleep in
@@ -945,7 +1097,7 @@ wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode
  * when one intends to set it, for instance, trying to lock bitflags.
  * For instance, if one were to have waiters trying to set bitflag
  * and waiting for it to clear before setting it, one would call
- * wait_on_bit() in threads waiting to be able to set the bit.
+ * cwait_on_bit() in threads waiting to be able to set the bit.
  * One uses wait_on_bit_lock() where one is waiting for the bit to
  * clear with the intention of setting it, and when done, clearing it.
  *
@@ -954,22 +1106,22 @@ wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode
  * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock(void *word, int bit, unsigned mode)
+cwait_on_bit_lock(void *word, int bit, unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
-	return out_of_line_wait_on_bit_lock(word, bit, bit_wait, mode);
+	return out_of_line_cwait_on_bit_lock(word, bit, bit_wait, mode);
 }
 
 /**
- * wait_on_bit_lock_io - wait for a bit to be cleared, when wanting to set it
+ * cwait_on_bit_lock_io - wait for a bit to be cleared, when wanting to set it
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
  * @mode: the task state to sleep in
  *
  * Use the standard hashed waitqueue table to wait for a bit
  * to be cleared and then to atomically set it.  This is similar
- * to wait_on_bit(), but calls io_schedule() instead of schedule()
+ * to cwait_on_bit(), but calls io_schedule() instead of schedule()
  * for the actual waiting.
  *
  * Returns zero if the bit was (eventually) found to be clear and was
@@ -977,15 +1129,15 @@ wait_on_bit_lock(void *word, int bit, unsigned mode)
  * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock_io(void *word, int bit, unsigned mode)
+cwait_on_bit_lock_io(void *word, int bit, unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
-	return out_of_line_wait_on_bit_lock(word, bit, bit_wait_io, mode);
+	return out_of_line_cwait_on_bit_lock(word, bit, bit_wait_io, mode);
 }
 
 /**
- * wait_on_bit_lock_action - wait for a bit to be cleared, when wanting to set it
+ * cwait_on_bit_lock_action - wait for a bit to be cleared, when wanting to set it
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
  * @action: the function used to sleep, which may take special actions
@@ -994,7 +1146,7 @@ wait_on_bit_lock_io(void *word, int bit, unsigned mode)
  * Use the standard hashed waitqueue table to wait for a bit
  * to be cleared and then to set it, and allow the waiting action
  * to be specified.
- * This is like wait_on_bit() but allows fine control of how the waiting
+ * This is like cwait_on_bit() but allows fine control of how the waiting
  * is done.
  *
  * Returns zero if the bit was (eventually) found to be clear and was
@@ -1002,15 +1154,15 @@ wait_on_bit_lock_io(void *word, int bit, unsigned mode)
  * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
+cwait_on_bit_lock_action(void *word, int bit, cwait_bit_action_f *action, unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
-	return out_of_line_wait_on_bit_lock(word, bit, action, mode);
+	return out_of_line_cwait_on_bit_lock(word, bit, action, mode);
 }
 
 /**
- * wait_on_atomic_t - Wait for an atomic_t to become 0
+ * cwait_on_atomic_t - Wait for an atomic_t to become 0
  * @val: The atomic value being waited on, a kernel virtual address
  * @action: the function used to sleep, which may take special actions
  * @mode: the task state to sleep in
@@ -1020,11 +1172,21 @@ wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned
  * outside of the target 'word'.
  */
 static inline
-int wait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
+int cwait_on_atomic_t(atomic_t *val, int (*action)(atomic_t *), unsigned mode)
 {
 	if (atomic_read(val) == 0)
 		return 0;
-	return out_of_line_wait_on_atomic_t(val, action, mode);
+	return out_of_line_cwait_on_atomic_t(val, action, mode);
 }
 
+#ifdef CWAIT_COMPAT
+#define wait_on_bit			cwait_on_bit
+#define wait_on_bit_io			cwait_on_bit_io
+#define wait_on_bit_lock		cwait_on_bit_lock
+#define wait_on_bit_lock_io		cwait_on_bit_lock_io
+#define wait_on_bit_action		cwait_on_bit_action
+#define wait_on_bit_lock_action		cwait_on_bit_lock_action
+#define wait_on_atomic_t		cwait_on_atomic_t
+#endif
+
 #endif /* _LINUX_WAIT_H */
-- 
1.9.2

