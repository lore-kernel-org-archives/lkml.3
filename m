Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbbA1AYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:24:54 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65172 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbbA1AYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:24:23 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/4] sched: Pull preemption disablement to __schedule() caller
Date: Wed, 28 Jan 2015 01:24:11 +0100
Message-Id: <1422404652-29067-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets factorize all preempt_count operations to the __schedule()
callers. This way we spare two preempt count changes in __schedule()
when it's called by preemption APIs.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 89b165f..1c0e5b1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2760,7 +2760,6 @@ static void __sched __schedule(void)
 	struct rq *rq;
 	int cpu;
 
-	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	rcu_note_context_switch();
@@ -2822,8 +2821,6 @@ static void __sched __schedule(void)
 		raw_spin_unlock_irq(&rq->lock);
 
 	post_schedule(rq);
-
-	sched_preempt_enable_no_resched();
 }
 
 static inline void sched_submit_work(struct task_struct *tsk)
@@ -2844,7 +2841,9 @@ asmlinkage __visible void __sched schedule(void)
 
 	sched_submit_work(tsk);
 	do {
+		preempt_disable();
 		__schedule();
+		sched_preempt_enable_no_resched();
 	} while (need_resched());
 }
 EXPORT_SYMBOL(schedule);
@@ -2883,9 +2882,9 @@ void __sched schedule_preempt_disabled(void)
 static void preempt_schedule_common(void)
 {
 	do {
-		preempt_count_add(PREEMPT_ACTIVE);
+		preempt_count_add(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);
 		__schedule();
-		preempt_count_sub(PREEMPT_ACTIVE);
+		preempt_count_sub(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
@@ -2938,7 +2937,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_context(void)
 		return;
 
 	do {
-		preempt_count_add(PREEMPT_ACTIVE);
+		preempt_count_add(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);
 		/*
 		 * Needs preempt disabled in case user_exit() is traced
 		 * and the tracer calls preempt_enable_notrace() causing
@@ -2947,8 +2946,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_context(void)
 		prev_ctx = exception_enter();
 		__schedule();
 		exception_exit(prev_ctx);
-
-		preempt_count_sub(PREEMPT_ACTIVE);
+		preempt_count_sub(PREEMPT_ACTIVE  + PREEMPT_CHECK_OFFSET);
 		barrier();
 	} while (need_resched());
 }
@@ -2973,11 +2971,11 @@ asmlinkage __visible void __sched preempt_schedule_irq(void)
 	prev_state = exception_enter();
 
 	do {
-		preempt_count_add(PREEMPT_ACTIVE);
+		preempt_count_add(PREEMPT_ACTIVE  + PREEMPT_CHECK_OFFSET);
 		local_irq_enable();
 		__schedule();
 		local_irq_disable();
-		preempt_count_sub(PREEMPT_ACTIVE);
+		preempt_count_sub(PREEMPT_ACTIVE  + PREEMPT_CHECK_OFFSET);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
-- 
2.1.4

