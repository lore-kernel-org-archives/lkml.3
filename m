Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3LLBJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:09:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:43149 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3LLBJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:09:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/3] wait-simple: Introduce the simple waitqueue implementation
Date: Wed, 11 Dec 2013 20:06:37 -0500
Message-ID: <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The wait_queue is a swiss army knife and in most of the cases the
full complexity is not needed.  Here we provide a slim version, as
it lowers memory consumption and runtime overhead.

The concept originated from RT, where waitqueues are a constant
source of trouble, as we can't convert the head lock to a raw
spinlock due to fancy and long lasting callbacks.

The smp_mb() was added (by Steven Rostedt) to fix a race condition
with swait wakeups vs. adding items to the list.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
[PG: carry forward from multiple v3.10-rt patches to mainline, align
 function names with "normal" wait queue names, update commit log.]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/swait.h | 220 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile       |   2 +-
 kernel/swait.c        | 118 +++++++++++++++++++++++++++
 3 files changed, 339 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/swait.h
 create mode 100644 kernel/swait.c

diff --git a/include/linux/swait.h b/include/linux/swait.h
new file mode 100644
index 0000000..8cd49b1
--- /dev/null
+++ b/include/linux/swait.h
@@ -0,0 +1,220 @@
+#ifndef _LINUX_SWAIT_H
+#define _LINUX_SWAIT_H
+
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+#include <asm/current.h>
+
+struct swaiter {
+	struct task_struct	*task;
+	struct list_head	node;
+};
+
+#define DEFINE_SWAITER(name)					\
+	struct swaiter name = {					\
+		.task	= current,				\
+		.node	= LIST_HEAD_INIT((name).node),		\
+	}
+
+struct swait_queue_head {
+	raw_spinlock_t		lock;
+	struct list_head	task_list;
+};
+
+typedef struct swait_queue_head swait_queue_head_t;
+
+
+#define SWAIT_QUEUE_HEAD_INITIALIZER(name) {				\
+		.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.task_list	= LIST_HEAD_INIT((name).task_list),	\
+	}
+
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_queue_head name = SWAIT_QUEUE_HEAD_INITIALIZER(name)
+
+extern void __init_swaitqueue_head(struct swait_queue_head *h,
+				   struct lock_class_key *key);
+
+#define init_swaitqueue_head(swh)					\
+	do {							\
+		static struct lock_class_key __key;		\
+								\
+		__init_swaitqueue_head((swh), &__key);		\
+	} while (0)
+
+/*
+ * Waiter functions
+ */
+extern void swait_prepare_locked(struct swait_queue_head *head,
+				 struct swaiter *w);
+extern void swait_prepare(struct swait_queue_head *head, struct swaiter *w,
+			  int state);
+extern void swait_finish_locked(struct swait_queue_head *head,
+				struct swaiter *w);
+extern void swait_finish(struct swait_queue_head *head, struct swaiter *w);
+
+/* Check whether a head has waiters enqueued */
+static inline bool swaitqueue_active(struct swait_queue_head *h)
+{
+	/* Make sure the condition is visible before checking list_empty() */
+	smp_mb();
+	return !list_empty(&h->task_list);
+}
+
+/*
+ * Wakeup functions
+ */
+extern unsigned int __swake_up(struct swait_queue_head *head,
+			       unsigned int state, unsigned int num);
+extern unsigned int __swake_up_locked(struct swait_queue_head *head,
+				      unsigned int state, unsigned int num);
+
+#define swake_up(head)							\
+				__swake_up(head, TASK_NORMAL, 1)
+#define swake_up_interruptible(head)					\
+				__swake_up(head, TASK_INTERRUPTIBLE, 1)
+#define swake_up_all(head)						\
+				__swake_up(head, TASK_NORMAL, 0)
+#define swake_up_all_interruptible(head)				\
+				__swake_up(head, TASK_INTERRUPTIBLE, 0)
+
+/*
+ * Event API
+ */
+#define __swait_event(wq, condition)					\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * swake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
+#define __swait_event_interruptible(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+#define __swait_event_interruptible_timeout(wq, condition, ret)		\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+		ret = schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_interruptible - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * swake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define swait_event_interruptible(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__swait_event_interruptible(wq, condition, __ret);	\
+	__ret;								\
+})
+
+#define swait_event_interruptible_timeout(wq, condition, timeout)	\
+({									\
+	int __ret = timeout;						\
+	if (!(condition))						\
+		__swait_event_interruptible_timeout(wq, condition, __ret);\
+	__ret;								\
+})
+
+#define __swait_event_timeout(wq, condition, ret)			\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		ret = schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)
+
+/**
+ * swait_event_timeout - sleep until a condition gets true or a timeout elapses
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * swake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if the @timeout elapsed, and the remaining
+ * jiffies if the condition evaluated to true before the timeout elapsed.
+ */
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	if (!(condition))						\
+		__swait_event_timeout(wq, condition, __ret);		\
+	__ret;								\
+})
+
+#endif
diff --git a/kernel/Makefile b/kernel/Makefile
index bbaf7d5..94b0e34 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    kthread.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o groups.o smpboot.o
+	    async.o range.o groups.o smpboot.o swait.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/swait.c b/kernel/swait.c
new file mode 100644
index 0000000..c798c46
--- /dev/null
+++ b/kernel/swait.c
@@ -0,0 +1,118 @@
+/*
+ * Simple waitqueues without fancy flags and callbacks
+ *
+ * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
+ *
+ * Based on kernel/wait.c
+ *
+ * For licencing details see kernel-base/COPYING
+ */
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/swait.h>
+
+/* Adds w to head->task_list. Must be called with head->lock locked. */
+static inline void __swait_enqueue(struct swait_queue_head *head,
+				   struct swaiter *w)
+{
+	list_add(&w->node, &head->task_list);
+	/* We can't let the condition leak before the setting of head */
+	smp_mb();
+}
+
+/* Removes w from head->task_list. Must be called with head->lock locked. */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+void __init_swaitqueue_head(struct swait_queue_head *head,
+			    struct lock_class_key *key)
+{
+	raw_spin_lock_init(&head->lock);
+	lockdep_set_class(&head->lock, key);
+	INIT_LIST_HEAD(&head->task_list);
+}
+EXPORT_SYMBOL(__init_swaitqueue_head);
+
+void swait_prepare_locked(struct swait_queue_head *head, struct swaiter *w)
+{
+	w->task = current;
+	if (list_empty(&w->node))
+		__swait_enqueue(head, w);
+}
+
+void swait_prepare(struct swait_queue_head *head, struct swaiter *w, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	swait_prepare_locked(head, w);
+	__set_current_state(state);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
+EXPORT_SYMBOL(swait_prepare);
+
+void swait_finish_locked(struct swait_queue_head *head, struct swaiter *w)
+{
+	__set_current_state(TASK_RUNNING);
+	if (w->task)
+		__swait_dequeue(w);
+}
+
+void swait_finish(struct swait_queue_head *head, struct swaiter *w)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	if (w->task) {
+		raw_spin_lock_irqsave(&head->lock, flags);
+		__swait_dequeue(w);
+		raw_spin_unlock_irqrestore(&head->lock, flags);
+	}
+}
+EXPORT_SYMBOL(swait_finish);
+
+unsigned int
+__swake_up_locked(struct swait_queue_head *head, unsigned int state,
+		  unsigned int num)
+{
+	struct swaiter *curr, *next;
+	int woken = 0;
+
+	list_for_each_entry_safe(curr, next, &head->task_list, node) {
+		if (wake_up_state(curr->task, state)) {
+			__swait_dequeue(curr);
+			/*
+			 * The waiting task can free the waiter as
+			 * soon as curr->task = NULL is written,
+			 * without taking any locks. A memory barrier
+			 * is required here to prevent the following
+			 * store to curr->task from getting ahead of
+			 * the dequeue operation.
+			 */
+			smp_wmb();
+			curr->task = NULL;
+			if (++woken == num)
+				break;
+		}
+	}
+	return woken;
+}
+
+unsigned int
+__swake_up(struct swait_queue_head *head, unsigned int state, unsigned int num)
+{
+	unsigned long flags;
+	int woken;
+
+	if (!swaitqueue_active(head))
+		return 0;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	woken = __swake_up_locked(head, state, num);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+	return woken;
+}
+EXPORT_SYMBOL(__swake_up);
-- 
1.8.5.1

