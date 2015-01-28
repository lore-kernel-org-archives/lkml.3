Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbbA1AYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:24:30 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42961 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbbA1AYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:24:25 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH 4/4] sched: Account PREEMPT_ACTIVE context as atomic
Date: Wed, 28 Jan 2015 01:24:12 +0100
Message-Id: <1422404652-29067-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_ACTIVE implies non-preemptible context and thus atomic context
despite what in_atomic*() APIs reports about it. These functions
shouldn't ignore this value like they are currently doing.

It appears that these APIs were ignoring PREEMPT_ACTIVE in order to
ease the check in schedule_debug(). Meanwhile it is sufficient to rely
on PREEMPT_ACTIVE in order to disable preemption in __schedule().

So lets fix the in_atomic*() APIs and simplify the preempt count ops
on __schedule() callers.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/preempt_mask.h |  4 ++--
 kernel/sched/core.c          | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/preempt_mask.h b/include/linux/preempt_mask.h
index dbeec4d..4b8c9b7 100644
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -99,14 +99,14 @@
  * used in the general case to determine whether sleeping is possible.
  * Do not use in_atomic() in driver code.
  */
-#define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != 0)
+#define in_atomic()	(preempt_count() != 0)
 
 /*
  * Check whether we were atomic before we did preempt_disable():
  * (used by the scheduler, *after* releasing the kernel lock)
  */
 #define in_atomic_preempt_off() \
-		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
+	(preempt_count() & ~(PREEMPT_ACTIVE | PREEMPT_CHECK_OFFSET))
 
 #ifdef CONFIG_PREEMPT_COUNT
 # define preemptible()	(preempt_count() == 0 && !irqs_disabled())
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1c0e5b1..c017a5f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2882,9 +2882,9 @@ void __sched schedule_preempt_disabled(void)
 static void preempt_schedule_common(void)
 {
 	do {
-		preempt_count_add(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);
+		preempt_count_add(PREEMPT_ACTIVE);
 		__schedule();
-		preempt_count_sub(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);
+		preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
@@ -2937,7 +2937,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_context(void)
 		return;
 
 	do {
-		preempt_count_add(PREEMPT_ACTIVE + PREEMPT_CHECK_OFFSET);
+		preempt_count_add(PREEMPT_ACTIVE);
 		/*
 		 * Needs preempt disabled in case user_exit() is traced
 		 * and the tracer calls preempt_enable_notrace() causing
@@ -2946,7 +2946,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_context(void)
 		prev_ctx = exception_enter();
 		__schedule();
 		exception_exit(prev_ctx);
-		preempt_count_sub(PREEMPT_ACTIVE  + PREEMPT_CHECK_OFFSET);
+		preempt_count_sub(PREEMPT_ACTIVE);
 		barrier();
 	} while (need_resched());
 }
@@ -2971,11 +2971,11 @@ asmlinkage __visible void __sched preempt_schedule_irq(void)
 	prev_state = exception_enter();
 
 	do {
-		preempt_count_add(PREEMPT_ACTIVE  + PREEMPT_CHECK_OFFSET);
+		preempt_count_add(PREEMPT_ACTIVE);
 		local_irq_enable();
 		__schedule();
 		local_irq_disable();
-		preempt_count_sub(PREEMPT_ACTIVE  + PREEMPT_CHECK_OFFSET);
+		preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
-- 
2.1.4

