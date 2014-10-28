Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbaJ1LNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:13:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbaJ1LMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:12:51 -0400
Date: Tue, 28 Oct 2014 04:11:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8eb23b9f35aae413140d3fda766a98092c21e9b0@git.kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Reply-To: hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, peterz@infradead.org,
        torvalds@linux-foundation.org
In-Reply-To: <20140924082242.591637616@infradead.org>
References: <20140924082242.591637616@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Debug nested sleeps
Git-Commit-ID: 8eb23b9f35aae413140d3fda766a98092c21e9b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eb23b9f35aae413140d3fda766a98092c21e9b0
Gitweb:     http://git.kernel.org/tip/8eb23b9f35aae413140d3fda766a98092c21e9b0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:55 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:56:52 +0100

sched: Debug nested sleeps

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
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: oleg@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140924082242.591637616@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/core.c   | 13 +++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 320a977..4648e07 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -243,6 +243,43 @@ extern char ___assert_task_state[1 - 2*!!(
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
@@ -259,11 +296,13 @@ extern char ___assert_task_state[1 - 2*!!(
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
 
@@ -1661,6 +1700,9 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+	unsigned long	task_state_change;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0456a55..5b4b96b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7298,6 +7298,19 @@ void __might_sleep(const char *file, int line, int preempt_offset)
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
