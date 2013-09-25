Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3IYQjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:39:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3IYQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:39:37 -0400
Date: Wed, 25 Sep 2013 09:39:00 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-jf5swrio8l78j37d06fzmo4r@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Create more preempt_count accessors
Git-Commit-ID: 01028747559ac6c6f642a7bbd2875cc4f66b2feb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:39:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01028747559ac6c6f642a7bbd2875cc4f66b2feb
Gitweb:     http://git.kernel.org/tip/01028747559ac6c6f642a7bbd2875cc4f66b2feb
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 14 Aug 2013 14:55:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 14:07:52 +0200

sched: Create more preempt_count accessors

We need a few special preempt_count accessors:
 - task_preempt_count() for when we're interested in the preemption
   count of another (non-running) task.
 - init_task_preempt_count() for properly initializing the preemption
   count.
 - init_idle_preempt_count() a special case of the above for the idle
   threads.

With these no generic code ever touches thread_info::preempt_count
anymore and architectures could choose to remove it.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-jf5swrio8l78j37d06fzmo4r@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/asm-generic/preempt.h | 14 ++++++++++++++
 include/trace/events/sched.h  |  2 +-
 kernel/sched/core.c           |  7 +++----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index a1fc659..8100b1e 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -28,6 +28,20 @@ static __always_inline void preempt_count_set(int pc)
 }
 
 /*
+ * must be macros to avoid header recursion hell
+ */
+#define task_preempt_count(p) \
+	(task_thread_info(p)->preempt_count & ~PREEMPT_NEED_RESCHED)
+
+#define init_task_preempt_count(p) do { \
+	task_thread_info(p)->preempt_count = PREEMPT_DISABLED; \
+} while (0)
+
+#define init_idle_preempt_count(p, cpu) do { \
+	task_thread_info(p)->preempt_count = PREEMPT_ENABLED; \
+} while (0)
+
+/*
  * We fold the NEED_RESCHED bit into the preempt count such that
  * preempt_enable() can decrement and test for needing to reschedule with a
  * single instruction.
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 2e7d994..613381b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
+	if (task_preempt_count(p) & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee61f5a..0ba4e41 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -983,7 +983,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
+			!(task_preempt_count(p) & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1723,8 +1723,7 @@ void sched_fork(struct task_struct *p)
 	p->on_cpu = 0;
 #endif
 #ifdef CONFIG_PREEMPT_COUNT
-	/* Want to start with kernel preemption disabled. */
-	task_thread_info(p)->preempt_count = PREEMPT_DISABLED;
+	init_task_preempt_count(p);
 #endif
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
@@ -4217,7 +4216,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-	task_thread_info(idle)->preempt_count = PREEMPT_ENABLED;
+	init_idle_preempt_count(idle, cpu);
 
 	/*
 	 * The idle tasks have their own, simple scheduling class:
