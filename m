Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaIXIi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:38:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:38745 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaIXI1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:12 -0400
Message-Id: <20140924082242.591637616@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 10/11] sched: Debug nested sleeps
References: <20140924081845.572814794@infradead.org>
Content-Disposition: inline; filename=peterz-might_sleep_nesting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Validate we call might_sleep() with TASK_RUNNING, which catches places
where we nest blocking primitives, eg. mutex usage in a wait loop.

Since all blocking is arranged through task_struct::state, nesting
this will cause the inner primitive to set TASK_RUNNING and the outer
will thus not block.

Another observed problem is calling a blocking function from
schedule()->sched_submit_work()->blk_schedule_flush_plug() which will
then destroy the task state for the actual __schedule() call that
comes after it.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/sched.h |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/core.c   |   13 +++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -242,6 +242,43 @@ extern char ___assert_task_state[1 - 2*!
 				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
 				 (task->flags & PF_FROZEN) == 0)
 
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+
+#define __set_task_state(tsk, state_value)			\
+	do {							\
+		(tsk)->task_state_change = _THIS_IP_;		\
+		(tsk)->state = (state_value);			\
+	} while (0)
+#define set_task_state(tsk, state_value)			\
+	do {							\
+		(tsk)->task_state_change = _THIS_IP_;		\
+		set_mb((tsk)->state, (state_value));		\
+	} while (0)
+
+/*
+ * set_current_state() includes a barrier so that the write of current->state
+ * is correctly serialised wrt the caller's subsequent test of whether to
+ * actually sleep:
+ *
+ *	set_current_state(TASK_UNINTERRUPTIBLE);
+ *	if (do_i_need_to_sleep())
+ *		schedule();
+ *
+ * If the caller does not need such serialisation then use __set_current_state()
+ */
+#define __set_current_state(state_value)			\
+	do {							\
+		current->task_state_change = _THIS_IP_;		\
+		current->state = (state_value);			\
+	} while (0)
+#define set_current_state(state_value)				\
+	do {							\
+		current->task_state_change = _THIS_IP_;		\
+		set_mb(current->state, (state_value));		\
+	} while (0)
+
+#else
+
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
 #define set_task_state(tsk, state_value)		\
@@ -258,11 +295,13 @@ extern char ___assert_task_state[1 - 2*!
  *
  * If the caller does not need such serialisation then use __set_current_state()
  */
-#define __set_current_state(state_value)			\
+#define __set_current_state(state_value)		\
 	do { current->state = (state_value); } while (0)
-#define set_current_state(state_value)		\
+#define set_current_state(state_value)			\
 	set_mb(current->state, (state_value))
 
+#endif
+
 /* Task command name length */
 #define TASK_COMM_LEN 16
 
@@ -1660,6 +1699,9 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+	unsigned long	task_state_change;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7143,6 +7143,19 @@ void __might_sleep(const char *file, int
 {
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
+	/*
+	 * Blocking primitives will set (and therefore destroy) current->state,
+	 * since we will exit with TASK_RUNNING make sure we enter with it,
+	 * otherwise we will destroy state.
+	 */
+	if (WARN(current->state != TASK_RUNNING,
+			"do not call blocking ops when !TASK_RUNNING; "
+			"state=%lx set at [<%p>] %pS\n",
+			current->state,
+			(void *)current->task_state_change,
+			(void *)current->task_state_change))
+		__set_current_state(TASK_RUNNING);
+
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
 	     !is_idle_task(current)) ||


