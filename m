Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3KFLUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:07 -0500
Date: Wed, 6 Nov 2013 03:19:34 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-x2y49rmxu5dljt66ai2lcfuw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] sched:
  Move completion code from core.c to completion.c
Git-Commit-ID: b8a216269ec0ce2e961d32e6d640d7010b8a818e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:19:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8a216269ec0ce2e961d32e6d640d7010b8a818e
Gitweb:     http://git.kernel.org/tip/b8a216269ec0ce2e961d32e6d640d7010b8a818e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 4 Oct 2013 22:06:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 07:49:19 +0100

sched: Move completion code from core.c to completion.c

Completions already have their own header file: linux/completion.h
Move the implementation out of kernel/sched/core.c and into its own
file: kernel/sched/completion.c.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-x2y49rmxu5dljt66ai2lcfuw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/completion.h |   2 +-
 kernel/sched/Makefile      |   2 +-
 kernel/sched/completion.c  | 299 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c        | 284 ------------------------------------------
 4 files changed, 301 insertions(+), 286 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 3cd574d..22c33e3 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -5,7 +5,7 @@
  * (C) Copyright 2001 Linus Torvalds
  *
  * Atomic wait-for-completion handler data structures.
- * See kernel/sched/core.c for details.
+ * See kernel/sched/completion.c for details.
  */
 
 #include <linux/wait.h>
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index f8d3f4b..7b62140 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -12,7 +12,7 @@ CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
 obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
-obj-y += wait.o
+obj-y += wait.o completion.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
new file mode 100644
index 0000000..a63f4dc
--- /dev/null
+++ b/kernel/sched/completion.c
@@ -0,0 +1,299 @@
+/*
+ * Generic wait-for-completion handler;
+ *
+ * It differs from semaphores in that their default case is the opposite,
+ * wait_for_completion default blocks whereas semaphore default non-block. The
+ * interface also makes it easy to 'complete' multiple waiting threads,
+ * something which isn't entirely natural for semaphores.
+ *
+ * But more importantly, the primitive documents the usage. Semaphores would
+ * typically be used for exclusion which gives rise to priority inversion.
+ * Waiting for completion is a typically sync point, but not an exclusion point.
+ */
+
+#include <linux/sched.h>
+#include <linux/completion.h>
+
+/**
+ * complete: - signals a single thread waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up a single thread waiting on this completion. Threads will be
+ * awakened in the same order in which they were queued.
+ *
+ * See also complete_all(), wait_for_completion() and related routines.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void complete(struct completion *x)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	x->done++;
+	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+}
+EXPORT_SYMBOL(complete);
+
+/**
+ * complete_all: - signals all threads waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up all threads waiting on this particular completion event.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void complete_all(struct completion *x)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	x->done += UINT_MAX/2;
+	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+}
+EXPORT_SYMBOL(complete_all);
+
+static inline long __sched
+do_wait_for_common(struct completion *x,
+		   long (*action)(long), long timeout, int state)
+{
+	if (!x->done) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		__add_wait_queue_tail_exclusive(&x->wait, &wait);
+		do {
+			if (signal_pending_state(state, current)) {
+				timeout = -ERESTARTSYS;
+				break;
+			}
+			__set_current_state(state);
+			spin_unlock_irq(&x->wait.lock);
+			timeout = action(timeout);
+			spin_lock_irq(&x->wait.lock);
+		} while (!x->done && timeout);
+		__remove_wait_queue(&x->wait, &wait);
+		if (!x->done)
+			return timeout;
+	}
+	x->done--;
+	return timeout ?: 1;
+}
+
+static inline long __sched
+__wait_for_common(struct completion *x,
+		  long (*action)(long), long timeout, int state)
+{
+	might_sleep();
+
+	spin_lock_irq(&x->wait.lock);
+	timeout = do_wait_for_common(x, action, timeout, state);
+	spin_unlock_irq(&x->wait.lock);
+	return timeout;
+}
+
+static long __sched
+wait_for_common(struct completion *x, long timeout, int state)
+{
+	return __wait_for_common(x, schedule_timeout, timeout, state);
+}
+
+static long __sched
+wait_for_common_io(struct completion *x, long timeout, int state)
+{
+	return __wait_for_common(x, io_schedule_timeout, timeout, state);
+}
+
+/**
+ * wait_for_completion: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout.
+ *
+ * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
+ * and interrupt capability. Also see complete().
+ */
+void __sched wait_for_completion(struct completion *x)
+{
+	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion);
+
+/**
+ * wait_for_completion_timeout: - waits for completion of a task (w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible.
+ *
+ * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
+ * till timeout) if completed.
+ */
+unsigned long __sched
+wait_for_completion_timeout(struct completion *x, unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_timeout);
+
+/**
+ * wait_for_completion_io: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout. The caller is accounted as waiting
+ * for IO.
+ */
+void __sched wait_for_completion_io(struct completion *x)
+{
+	wait_for_common_io(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_io);
+
+/**
+ * wait_for_completion_io_timeout: - waits for completion of a task (w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible. The caller is accounted as waiting for IO.
+ *
+ * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
+ * till timeout) if completed.
+ */
+unsigned long __sched
+wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
+{
+	return wait_for_common_io(x, timeout, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_io_timeout);
+
+/**
+ * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits for completion of a specific task to be signaled. It is
+ * interruptible.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
+ */
+int __sched wait_for_completion_interruptible(struct completion *x)
+{
+	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
+	if (t == -ERESTARTSYS)
+		return t;
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_completion_interruptible);
+
+/**
+ * wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. It is interruptible. The timeout is in jiffies.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
+ * or number of jiffies left till timeout) if completed.
+ */
+long __sched
+wait_for_completion_interruptible_timeout(struct completion *x,
+					  unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
+
+/**
+ * wait_for_completion_killable: - waits for completion of a task (killable)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It can be
+ * interrupted by a kill signal.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if completed.
+ */
+int __sched wait_for_completion_killable(struct completion *x)
+{
+	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
+	if (t == -ERESTARTSYS)
+		return t;
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_completion_killable);
+
+/**
+ * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be
+ * signaled or for a specified timeout to expire. It can be
+ * interrupted by a kill signal. The timeout is in jiffies.
+ *
+ * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
+ * or number of jiffies left till timeout) if completed.
+ */
+long __sched
+wait_for_completion_killable_timeout(struct completion *x,
+				     unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_KILLABLE);
+}
+EXPORT_SYMBOL(wait_for_completion_killable_timeout);
+
+/**
+ *	try_wait_for_completion - try to decrement a completion without blocking
+ *	@x:	completion structure
+ *
+ *	Return: 0 if a decrement cannot be done without blocking
+ *		 1 if a decrement succeeded.
+ *
+ *	If a completion is being used as a counting completion,
+ *	attempt to decrement the counter without blocking. This
+ *	enables us to avoid waiting if the resource the completion
+ *	is protecting is not available.
+ */
+bool try_wait_for_completion(struct completion *x)
+{
+	unsigned long flags;
+	int ret = 1;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	if (!x->done)
+		ret = 0;
+	else
+		x->done--;
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(try_wait_for_completion);
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Return: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+bool completion_done(struct completion *x)
+{
+	unsigned long flags;
+	int ret = 1;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(completion_done);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 91b2845..aa066f3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2688,290 +2688,6 @@ int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 }
 EXPORT_SYMBOL(default_wake_function);
 
-/**
- * complete: - signals a single thread waiting on this completion
- * @x:  holds the state of this particular completion
- *
- * This will wake up a single thread waiting on this completion. Threads will be
- * awakened in the same order in which they were queued.
- *
- * See also complete_all(), wait_for_completion() and related routines.
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void complete(struct completion *x)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	x->done++;
-	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-}
-EXPORT_SYMBOL(complete);
-
-/**
- * complete_all: - signals all threads waiting on this completion
- * @x:  holds the state of this particular completion
- *
- * This will wake up all threads waiting on this particular completion event.
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void complete_all(struct completion *x)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	x->done += UINT_MAX/2;
-	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-}
-EXPORT_SYMBOL(complete_all);
-
-static inline long __sched
-do_wait_for_common(struct completion *x,
-		   long (*action)(long), long timeout, int state)
-{
-	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		__add_wait_queue_tail_exclusive(&x->wait, &wait);
-		do {
-			if (signal_pending_state(state, current)) {
-				timeout = -ERESTARTSYS;
-				break;
-			}
-			__set_current_state(state);
-			spin_unlock_irq(&x->wait.lock);
-			timeout = action(timeout);
-			spin_lock_irq(&x->wait.lock);
-		} while (!x->done && timeout);
-		__remove_wait_queue(&x->wait, &wait);
-		if (!x->done)
-			return timeout;
-	}
-	x->done--;
-	return timeout ?: 1;
-}
-
-static inline long __sched
-__wait_for_common(struct completion *x,
-		  long (*action)(long), long timeout, int state)
-{
-	might_sleep();
-
-	spin_lock_irq(&x->wait.lock);
-	timeout = do_wait_for_common(x, action, timeout, state);
-	spin_unlock_irq(&x->wait.lock);
-	return timeout;
-}
-
-static long __sched
-wait_for_common(struct completion *x, long timeout, int state)
-{
-	return __wait_for_common(x, schedule_timeout, timeout, state);
-}
-
-static long __sched
-wait_for_common_io(struct completion *x, long timeout, int state)
-{
-	return __wait_for_common(x, io_schedule_timeout, timeout, state);
-}
-
-/**
- * wait_for_completion: - waits for completion of a task
- * @x:  holds the state of this particular completion
- *
- * This waits to be signaled for completion of a specific task. It is NOT
- * interruptible and there is no timeout.
- *
- * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
- * and interrupt capability. Also see complete().
- */
-void __sched wait_for_completion(struct completion *x)
-{
-	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion);
-
-/**
- * wait_for_completion_timeout: - waits for completion of a task (w/timeout)
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be signaled or for a
- * specified timeout to expire. The timeout is in jiffies. It is not
- * interruptible.
- *
- * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
- * till timeout) if completed.
- */
-unsigned long __sched
-wait_for_completion_timeout(struct completion *x, unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_timeout);
-
-/**
- * wait_for_completion_io: - waits for completion of a task
- * @x:  holds the state of this particular completion
- *
- * This waits to be signaled for completion of a specific task. It is NOT
- * interruptible and there is no timeout. The caller is accounted as waiting
- * for IO.
- */
-void __sched wait_for_completion_io(struct completion *x)
-{
-	wait_for_common_io(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_io);
-
-/**
- * wait_for_completion_io_timeout: - waits for completion of a task (w/timeout)
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be signaled or for a
- * specified timeout to expire. The timeout is in jiffies. It is not
- * interruptible. The caller is accounted as waiting for IO.
- *
- * Return: 0 if timed out, and positive (at least 1, or number of jiffies left
- * till timeout) if completed.
- */
-unsigned long __sched
-wait_for_completion_io_timeout(struct completion *x, unsigned long timeout)
-{
-	return wait_for_common_io(x, timeout, TASK_UNINTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_io_timeout);
-
-/**
- * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
- * @x:  holds the state of this particular completion
- *
- * This waits for completion of a specific task to be signaled. It is
- * interruptible.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if completed.
- */
-int __sched wait_for_completion_interruptible(struct completion *x)
-{
-	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
-	if (t == -ERESTARTSYS)
-		return t;
-	return 0;
-}
-EXPORT_SYMBOL(wait_for_completion_interruptible);
-
-/**
- * wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be signaled or for a
- * specified timeout to expire. It is interruptible. The timeout is in jiffies.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
- * or number of jiffies left till timeout) if completed.
- */
-long __sched
-wait_for_completion_interruptible_timeout(struct completion *x,
-					  unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
-}
-EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
-
-/**
- * wait_for_completion_killable: - waits for completion of a task (killable)
- * @x:  holds the state of this particular completion
- *
- * This waits to be signaled for completion of a specific task. It can be
- * interrupted by a kill signal.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if completed.
- */
-int __sched wait_for_completion_killable(struct completion *x)
-{
-	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
-	if (t == -ERESTARTSYS)
-		return t;
-	return 0;
-}
-EXPORT_SYMBOL(wait_for_completion_killable);
-
-/**
- * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
- * @x:  holds the state of this particular completion
- * @timeout:  timeout value in jiffies
- *
- * This waits for either a completion of a specific task to be
- * signaled or for a specified timeout to expire. It can be
- * interrupted by a kill signal. The timeout is in jiffies.
- *
- * Return: -ERESTARTSYS if interrupted, 0 if timed out, positive (at least 1,
- * or number of jiffies left till timeout) if completed.
- */
-long __sched
-wait_for_completion_killable_timeout(struct completion *x,
-				     unsigned long timeout)
-{
-	return wait_for_common(x, timeout, TASK_KILLABLE);
-}
-EXPORT_SYMBOL(wait_for_completion_killable_timeout);
-
-/**
- *	try_wait_for_completion - try to decrement a completion without blocking
- *	@x:	completion structure
- *
- *	Return: 0 if a decrement cannot be done without blocking
- *		 1 if a decrement succeeded.
- *
- *	If a completion is being used as a counting completion,
- *	attempt to decrement the counter without blocking. This
- *	enables us to avoid waiting if the resource the completion
- *	is protecting is not available.
- */
-bool try_wait_for_completion(struct completion *x)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	if (!x->done)
-		ret = 0;
-	else
-		x->done--;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(try_wait_for_completion);
-
-/**
- *	completion_done - Test to see if a completion has any waiters
- *	@x:	completion structure
- *
- *	Return: 0 if there are waiters (wait_for_completion() in progress)
- *		 1 if there are no waiters.
- *
- */
-bool completion_done(struct completion *x)
-{
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	if (!x->done)
-		ret = 0;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(completion_done);
-
 static long __sched
 sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 {
