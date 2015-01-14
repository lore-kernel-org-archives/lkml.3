Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbbANKip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:38:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48524 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbANKin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:38:43 -0500
Date: Wed, 14 Jan 2015 11:38:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait)
 implementation
Message-ID: <20150114103834.GN23965@worktop.programming.kicks-ass.net>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
 <1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So I had a look at this yesterday and came up with the below --
completely untested etc.

Now in order to compile test I meant to convert the completion code and
ran head first into complete_all; it uses spin_lock_irqsave() which
means it can be used from IRQ context. Now if you look at
__swake_up_all() you'll find a comment on how we cannot have this.

Now I can't remember how important that all was for RT but I figured I'd
post it and let other people stare at it for a bit.

---
 include/linux/swait.h |  181 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/swait.c  |  162 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 343 insertions(+)

--- /dev/null
+++ b/include/linux/swait.h
@@ -0,0 +1,181 @@
+#ifndef _LINUX_SWAIT_H
+#define _LINUX_SWAIT_H
+
+#include <linux/list.h>
+#include <linux/stddef.h>
+#include <linux/spinlock.h>
+#include <asm/current.h>
+
+/*
+ * Simple wait queues
+ *
+ * While these are very similar to the other/complex wait queues (wait.h) the
+ * most important difference is that the simple waitqueue allows for
+ * deterministic behaviour -- IOW it has strictly bounded IRQ and lock hold
+ * times.
+ *
+ * In order to make this so, we had to drop a fair number of features of the
+ * other waitqueue code; notably:
+ *
+ *  - mixing INTERRUPTIBLE and UNINTERRUPTIBLE sleeps on the same waitqueue
+ *
+ *  - the exclusive mode; because this requires preserving the list order
+ *    and this is hard, see __swait_wake().
+ *
+ *  - custom wake functions; because you cannot give any guarantees about
+ *    random code.
+ *
+ * As a side effect of this; the data structures are slimmer.
+ *
+ * One would recommend using this wait queue where possible.
+ */
+
+struct task_struct;
+
+struct swait_queue_head {
+	raw_spinlock_t		lock;
+#ifdef CONFIG_SWAIT_DEBUG
+	unsigned int		state;
+#endif
+	struct list_head	task_list;
+};
+
+struct swait_queue {
+	struct task_struct	*task;
+	struct list_head	task_list;
+};
+
+#define __SWAITQUEUE_INITIALIZER(name) {				\
+	.task		= current,					\
+	.task_list	= LIST_HEAD_INIT((name).task_list),		\
+}
+
+#define DECLARE_SWAITQUEUE(name)					\
+	struct swait_queue name = __SWAITQUEUE_INITIALIZER(name)
+
+#define __SWAIT_QUEUE_HEAD_DEBUG_INIT()					\
+	.state = 0,
+
+#define __SWAIT_QUEUE_HEAD_INITIALIZER(name) {				\
+	.lock		= __RAW_SPIN_LOCK_UNLOCKED(name.lock),		\
+	.task_list	= LIST_HEAD_INIT((name).task_list),		\
+	__SWAIT_QUEUE_HEAD_DEBUG_INIT()					\
+}
+
+#define DECLARE_SWAIT_QUEUE_HEAD(name)					\
+	struct swait_queue_head name = __SWAIT_QUEUE_HEAD_INITIALIZER(name)
+
+extern void __init_swait_queue_head(struct swait_queue_head *q, const char *name,
+				    struct lock_class_key *key);
+
+#define init_swait_queue_head(q)				\
+	do {							\
+		static struct lock_class_key __key;		\
+		__init_swait_queue_head((q), #q, &__key);	\
+	} while (0)
+
+#ifdef CONFIG_LOCKDEP
+# define __SWAIT_QUEUE_HEAD_INIT_ONSTACK(name)			\
+	({ init_swait_queue_head(&name); name; })
+# define DECLARE_SWAIT_QUEUE_HEAD_ONSTACK(name)			\
+	struct swait_queue_head name = __SWAIT_QUEUE_HEAD_INIT_ONSTACK(name)
+#else
+# define DECLARE_SWAIT_QUEUE_HEAD_ONSTACK(name)			\
+	DECLARE_SWAIT_QUEUE_HEAD(name)
+#endif
+
+static inline int swait_active(struct swait_queue_head *q)
+{
+	return !list_empty(&q->task_list);
+}
+
+extern void __swake_up(struct swait_queue_head *q, unsigned int mode);
+extern void __swake_up_all(struct swait_queue_head *q, unsigned int mode);
+extern void __swake_up_locked(struct swait_queue_head *q, unsigned int mode);
+
+#define swake_up(x)			__swake_up(x, TASK_NORMAL)
+#define swake_up_all(x)			__swake_up_all(x, TASK_NORMAL)
+#define swake_up_locked(x)		__swake_up_locked((x), TASK_NORMAL)
+
+extern void __prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait);
+extern void prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait, int state);
+extern long prepare_to_swait_event(struct swait_queue_head *q, struct swait_queue *wait, int state);
+
+extern void __finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
+extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
+
+/* as per ___wait_event() but for swait, therefore "exclusive == 0" */
+#define ___swait_event(wq, condition, state, ret, cmd)			\
+({									\
+	struct swait_queue __wait;					\
+	long __ret = ret;						\
+									\
+	INIT_LIST_HEAD(&__wait.task_list);				\
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
+#define __swait_event(wq, condition)					\
+	(void)___swait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,	\
+			    schedule())
+
+#define swait_event(wq, condition)					\
+do {									\
+	if (condition)							\
+		break;							\
+	__swait_event(wq, condition);					\
+} while (0)
+
+#define __swait_event_timeout(wq, condition, timeout)			\
+	___swait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_UNINTERRUPTIBLE, timeout,			\
+		      __ret = schedule_timeout(__ret))
+
+#define swait_event_timeout(wq, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __swait_event_timeout(wq, condition, timeout);	\
+	__ret;								\
+})
+
+#define __swait_event_interruptible(wq, condition)			\
+	___swait_event(wq, condition, TASK_INTERRUPTIBLE, 0,		\
+		      schedule())
+
+#define swait_event_interruptible(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition))						\
+		__ret = __swait_event_interruptible(wq, condition);	\
+	__ret;								\
+})
+
+#define __swait_event_interruptible_timeout(wq, condition, timeout)	\
+	___swait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, timeout,			\
+		      __ret = schedule_timeout(__ret))
+
+#define swait_event_interruptible_timeout(wq, condition, timeout)	\
+({									\
+	long __ret = timeout;						\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __swait_event_interruptible_timeout(wq,		\
+						condition, timeout);	\
+	__ret;								\
+})
+
+#endif /* _LINUX_SWAIT_H */
--- /dev/null
+++ b/kernel/sched/swait.c
@@ -0,0 +1,162 @@
+
+#include <linux/swait.h>
+
+void __init_swait_queue_head(struct swait_queue_head *q, const char *name,
+			     struct lock_class_key *key)
+{
+	raw_spin_lock_init(&q->lock);
+	lockdep_set_class_and_name(&q->lock, key, name);
+	INIT_LIST_HEAD(&q->task_list);
+#ifdef CONFIG_SWAIT_DEBUG
+	q->state = 0;
+#endif
+}
+EXPORT_SYMBOL(__init_swait_queue_head);
+
+#ifdef CONFIG_SWAIT_DEBUG
+/*
+ * Ensure we do not mix and match INTERRUPTIBLE and UNINTERRUPTIBLE sleeps.
+ * This guarantees wakeups are always valid and we need not go look for
+ * wakeup targets, this ensures __swake_up() is O(1).
+ */
+static inline void __swait_wakeup_debug(struct swait_queue_head *q, unsigned int state)
+{
+	if (q->state == 0)
+		return;
+
+	WARN_ON_ONCE(!(q->state & state));
+}
+static inline void __swait_wait_debug(struct swait_queue_head *q, unsigned int state)
+{
+	if (q->state == 0)
+		q->state = state;
+
+	WARN_ON_ONCE(q->state != state);
+}
+#else
+static inline void __swait_wakeup_debug(struct swait_queue_head *q, unsigned int state)
+{
+}
+static inline void __swait_wait_debug(struct swait_queue_head *q, unsigned int state)
+{
+}
+#endif
+
+/*
+ * The thing about the wake_up_state() return value; I think we can ignore it.
+ *
+ * If for some reason it would return 0, that means the previously waiting
+ * task is already running, so it will observe condition true (or has already).
+ */
+void __swake_up_locked(struct swait_queue_head *q, unsigned int state)
+{
+	struct swait_queue *curr;
+
+	__swait_wakeup_debug(q, state);
+
+	list_for_each_entry(curr, &q->task_list, task_list) {
+		wake_up_state(curr->task, state);
+		list_del_init(&curr->task_list);
+		break;
+	}
+}
+EXPORT_SYMBOL(__swake_up_locked);
+
+void __swake_up(struct swait_queue_head *q, unsigned int state)
+{
+	unsigned long flags;
+
+	__swait_wakeup_debug(q, state);
+
+	if (!swait_active(q))
+		return;
+
+	raw_spin_lock_irqsave(&q->lock, flags);
+	__swake_up_locked(q, state);
+	raw_spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(__swake_up);
+
+/*
+ * Does not allow usage from IRQ disabled, since we must be able to
+ * release IRQs to guarantee bounded hold time.
+ */
+void __swake_up_all(struct swait_queue_head *q, unsigned int state)
+{
+	struct swait_queue *curr, *next;
+	LIST_HEAD(tmp);
+
+	__swait_wakeup_debug(q, state);
+
+	if (!swait_active(q))
+		return;
+
+	raw_spin_lock_irq(&q->lock);
+	list_splice_init(&q->task_list, &tmp);
+	while (!list_empty(&tmp)) {
+		curr = list_first_entry(&tmp, typeof(curr), task_list);
+
+		wake_up_state(curr->task, state);
+		list_del_init(&curr->task_list);
+
+		if (list_empty(&tmp))
+			break;
+
+		raw_spin_unlock_irq(&q->lock);
+		raw_spin_lock_irq(&q->lock);
+	}
+	raw_spin_unlock_irq(&q->lock);
+}
+EXPORT_SYMBOL(__swake_up_all);
+
+void __prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait)
+{
+	wait->task = current;
+	if (list_empty(&wait->node))
+		list_add(&wait->task_list, &q->task_list);
+}
+
+void prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait, int state)
+{
+	unsigned long flags;
+
+	__swait_wait_debug(q, state);
+
+	raw_spin_lock_irqsave(&q->lock, flags);
+	__prepare_to_swait(q, wait);
+	set_current_state(state);
+	raw_spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(prepare_to_swait);
+
+long prepare_to_swait_event(struct swait_queue_head *q, struct swait_queue *wait, int state)
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
+void __finish_swait(struct swait_queue_head *q, struct swait_queue *wait)
+{
+	__set_current_state(TASK_RUNNING);
+	if (!list_empty(&wait->task_list))
+		list_del_init(&wait->task_list);
+}
+
+void finish_swait(struct swait_queue_head *q, struct swait_queue *wait)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+
+	if (!list_empty_careful(&wait->task_list)) {
+		raw_spin_lock_irqsave(&q->lock, flags);
+		list_del_init(&wait->task_list);
+		raw_spin_unlock_irqrestore(&q->lock, flags);
+	}
+}
+EXPORT_SYMBOL(finish_swait);
