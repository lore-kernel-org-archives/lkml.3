Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3BRNgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:36:19 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:54359
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab3BRNgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:36:17 -0500
From: Tim Sander <tim@krieglstein.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RCU?: Scheduling while atomic with 3.4.23-rt33
Date: Mon, 18 Feb 2013 14:36:11 +0100
Message-ID: <5660399.UWv5Yrbf86@dabox>
User-Agent: KMail/4.10 (Linux/3.6.0; KDE/4.10.0; x86_64; ; )
In-Reply-To: <alpine.LFD.2.02.1302181214250.22263@ionos>
References: <4738617.pBMCEJ5E3K@dabox> <alpine.LFD.2.02.1302181214250.22263@ionos>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2247419.LBhmIrd90v"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2247419.LBhmIrd90v
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 18. Februar 2013, 12:16:41 schrieb Thomas Gleixner:
> On Mon, 18 Feb 2013, Tim Sander wrote:
> > Here is a transtribed backtrace for easier reading:
> > c0010fac t dump_backtrace
> > c022c188 T dump_stack
> > c022c71c t __schedule_bug
> > c022fb28 t __schedule
> > c0230644 t rt_spin_lock_slowlock
> > c0230ba8 T rt_spin_lock
> > c003a9b8 T __wake_up
> > c0052a44 t invoke_rcu_callbacks
> > c0053764 T rcu_check_callbacks
> > c0026060 T update_process_times
> 
> That's due to CONFIG_TINY_PREEMPT_RCU=y. That's a known issue, which
> has been fixed in 3.6-rt.
> 
> Steven, could you backport that to 3.2/3.4 please ?
Mh, i just saw that i forgot to add the other patch which adds the wait-simple 
stuff. Its attached so thats hopefully all to get rid of that error?

Local smoke test is running... but as its a relative rare race i'm not holding 
my breath.

Btw. is that wait-simple stuff safe from irq context?

Best regards
Tim

PS: sorry for the legalese in the first mail, its just for Steven to keep him 
learning german legalese ;-). 
--nextPart2247419.LBhmIrd90v
Content-Disposition: attachment; filename="0023-add-wait-simple.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0023-add-wait-simple.patch"

>From 3d1861c022f159a5419a2395704fa1201c0c7c84 Mon Sep 17 00:00:00 2001
From: Tim Sander <tim.sander@hbm.com>
Date: Mon, 18 Feb 2013 13:59:21 +0100
Subject: [PATCH] add wait-simple

---
 include/linux/wait-simple.h |  172 +++++++++++++++++++++++++++++++++++++++++++
 kernel/Makefile             |    2 +-
 kernel/wait-simple.c        |  119 ++++++++++++++++++++++++++++++
 3 files changed, 292 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/wait-simple.h
 create mode 100644 kernel/wait-simple.c

diff --git a/include/linux/wait-simple.h b/include/linux/wait-simple.h
new file mode 100644
index 0000000..44fee60
--- /dev/null
+++ b/include/linux/wait-simple.h
@@ -0,0 +1,172 @@
+#ifndef _LINUX_WAIT_SIMPLE_H
+#define _LINUX_WAIT_SIMPLE_H
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
+struct swait_head {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+
+#define SWAIT_HEAD_INITIALIZER(name) {				\
+		.lock	= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
+		.list	= LIST_HEAD_INIT((name).list),		\
+	}
+
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_head name = SWAIT_HEAD_INITIALIZER(name)
+
+extern void __init_swait_head(struct swait_head *h, struct lock_class_key *key);
+
+#define init_swait_head(swh)					\
+	do {							\
+		static struct lock_class_key __key;		\
+								\
+		__init_swait_head((swh), &__key);		\
+	} while (0)
+
+/*
+ * Waiter functions
+ */
+extern void swait_prepare_locked(struct swait_head *head, struct swaiter *w);
+extern void swait_prepare(struct swait_head *head, struct swaiter *w, int state);
+extern void swait_finish_locked(struct swait_head *head, struct swaiter *w);
+extern void swait_finish(struct swait_head *head, struct swaiter *w);
+
+/*
+ * Wakeup functions
+ */
+extern unsigned int __swait_wake(struct swait_head *head, unsigned int state, unsigned int num);
+extern unsigned int __swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num);
+
+#define swait_wake(head)			__swait_wake(head, TASK_NORMAL, 1)
+#define swait_wake_interruptible(head)		__swait_wake(head, TASK_INTERRUPTIBLE, 1)
+#define swait_wake_all(head)			__swait_wake(head, TASK_NORMAL, 0)
+#define swait_wake_all_interruptible(head)	__swait_wake(head, TASK_INTERRUPTIBLE, 0)
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
+ * wake_up() has to be called after changing any variable that could
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
+/**
+ * swait_event_interruptible - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
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
+ * wake_up() has to be called after changing any variable that could
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
index f4bf68a..e7bbd15 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o
+	    async.o range.o groups.o wait-simple.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
new file mode 100644
index 0000000..c35ec78
--- /dev/null
+++ b/kernel/wait-simple.c
@@ -0,0 +1,119 @@
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
+#include <linux/wait-simple.h>
+
+/* Adds w to head->list. Must be called with head->lock locked. */
+static inline void __swait_enqueue(struct swait_head *head, struct swaiter *w)
+{
+	list_add(&w->node, &head->list);
+}
+
+/* Removes w from head->list. Must be called with head->lock locked. */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+/* Check whether a head has waiters enqueued */
+static inline bool swait_head_has_waiters(struct swait_head *h)
+{
+	return !list_empty(&h->list);
+}
+
+void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
+{
+	raw_spin_lock_init(&head->lock);
+	lockdep_set_class(&head->lock, key);
+	INIT_LIST_HEAD(&head->list);
+}
+EXPORT_SYMBOL_GPL(__init_swait_head);
+
+void swait_prepare_locked(struct swait_head *head, struct swaiter *w)
+{
+	w->task = current;
+	if (list_empty(&w->node))
+		__swait_enqueue(head, w);
+}
+
+void swait_prepare(struct swait_head *head, struct swaiter *w, int state)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	swait_prepare_locked(head, w);
+	__set_current_state(state);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+}
+EXPORT_SYMBOL_GPL(swait_prepare);
+
+void swait_finish_locked(struct swait_head *head, struct swaiter *w)
+{
+	__set_current_state(TASK_RUNNING);
+	if (w->task)
+		__swait_dequeue(w);
+}
+
+void swait_finish(struct swait_head *head, struct swaiter *w)
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
+EXPORT_SYMBOL_GPL(swait_finish);
+
+unsigned int
+__swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num)
+{
+	struct swaiter *curr, *next;
+	int woken = 0;
+
+	list_for_each_entry_safe(curr, next, &head->list, node) {
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
+__swait_wake(struct swait_head *head, unsigned int state, unsigned int num)
+{
+	unsigned long flags;
+	int woken;
+
+	if (!swait_head_has_waiters(head))
+		return 0;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	woken = __swait_wake_locked(head, state, num);
+	raw_spin_unlock_irqrestore(&head->lock, flags);
+	return woken;
+}
+EXPORT_SYMBOL_GPL(__swait_wake);
-- 
1.7.9.5


--nextPart2247419.LBhmIrd90v--

