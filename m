Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3IJNVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:21:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46860 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3IJNVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:21:25 -0400
Message-Id: <20130910132011.253147012@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Sep 2013 15:08:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/7] sched: Create more preempt_count accessors
References: <20130910130811.507933095@infradead.org>
Content-Disposition: inline; filename=peterz-task_preempt_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 include/asm-generic/preempt.h |   14 ++++++++++++++
 include/trace/events/sched.h  |    2 +-
 kernel/sched/core.c           |    7 +++----
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -18,6 +18,20 @@ static __always_inline int *preempt_coun
 }
 
 /*
+ * must be macros to avoid header recursion hell
+ */
+#define task_preempt_count(p) \
+	(task_thread_info(p)->preempt_count & ~PREEMPT_NEED_RESCHED)
+
+#define init_task_preempt_count(p) do { \
+	task_thread_info(p)->preempt_count = 1 | PREEMPT_NEED_RESCHED; \
+} while (0)
+
+#define init_idle_preempt_count(p, cpu) do { \
+	task_thread_info(p)->preempt_count = 0; \
+} while (0)
+
+/*
  * We fold the NEED_RESCHED bit into the preempt count such that
  * preempt_enable() can decrement and test for needing to reschedule with a
  * single instruction.
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
+	if (task_preempt_count(p) & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -996,7 +996,7 @@ void set_task_cpu(struct task_struct *p,
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
+			!(task_preempt_count(p) & PREEMPT_ACTIVE));
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1743,8 +1743,7 @@ void sched_fork(struct task_struct *p)
 	p->on_cpu = 0;
 #endif
 #ifdef CONFIG_PREEMPT_COUNT
-	/* Want to start with kernel preemption disabled. */
-	task_thread_info(p)->preempt_count = 1;
+	init_task_preempt_count(p);
 #endif
 #ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
@@ -4237,7 +4236,7 @@ void init_idle(struct task_struct *idle,
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-	task_thread_info(idle)->preempt_count = 0;
+	init_idle_preempt_count(idle, cpu);
 
 	/*
 	 * The idle tasks have their own, simple scheduling class:


