Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3JDUov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:44:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3JDUou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:44:50 -0400
Date: Fri, 4 Oct 2013 22:44:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131004204438.GR26785@twins.programming.kicks-ass.net>
References: <20131002092217.784439754@infradead.org>
 <20131004204405.GU3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004204405.GU3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:44:05PM +0200, Peter Zijlstra wrote:
> 
> slightly related; do we want to do something like the following two
> patches?

and

---
Subject: sched: Move completion code
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri Oct  4 22:06:53 CEST 2013

Completions already have their own header file: linux/completion.h
Move the implementation out of kernel/sched/core.c and into its own
file: kernel/completion.c.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/Makefile     |    2 
 kernel/completion.c |  287 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c |  284 ---------------------------------------------------
 3 files changed, 288 insertions(+), 285 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,7 +11,7 @@ obj-y     = fork.o exec_domain.o panic.o
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o \
-	    rcusync.o
+	    rcusync.o completion.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
--- /dev/null
+++ b/kernel/completion.c
@@ -0,0 +1,287 @@
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
+	__wake_up_locked_key(&x->wait, TASK_NORMAL, NULL);
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
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2579,290 +2579,6 @@ int default_wake_function(wait_queue_t *
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
-	__wake_up_locked_key(&x->wait, TASK_NORMAL, NULL);
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
