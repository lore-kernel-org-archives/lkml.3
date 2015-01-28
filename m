Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbbA1AYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:24:22 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38992 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbbA1AYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:24:20 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/4] sched: Pull resched loop to __schedule() callers
Date: Wed, 28 Jan 2015 01:24:09 +0100
Message-Id: <1422404652-29067-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__schedule() disables preemption during its job and re-enables it
afterward without doing a preemption check to avoid recursion.

But if an event happens after the context switch which requires
rescheduling, we need to check again if a task of a higher priority
needs the CPU. A preempt irq can raise such a situation. To handle that,
__schedule() loops on need_resched().

But preempt_schedule_*() functions, which call __schedule(), also loop
on need_resched() to handle missed preempt irqs. Hence we end up with
the same loop happening twice.

Lets simplify that by attributing the need_resched() loop responsability
to all __schedule() callers.

There is a risk that the outer loop now handles reschedules that used
to be handled by the inner loop with the added overhead of caller details
(inc/dec of PREEMPT_ACTIVE, irq save/restore) but assuming those inner
rescheduling loop weren't too frequent, this shouldn't matter. Especially
since the whole preemption path is now loosing one loop in any case.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7ed25d..bbef95d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2748,6 +2748,10 @@ again:
  *          - explicit schedule() call
  *          - return from syscall or exception to user-space
  *          - return from interrupt-handler to user-space
+ *
+ * WARNING: all callers must re-check need_resched() afterward and reschedule
+ * accordingly in case an event triggered the need for rescheduling (such as
+ * an interrupt waking up a task) while preemption was disabled in __schedule().
  */
 static void __sched __schedule(void)
 {
@@ -2756,7 +2760,6 @@ static void __sched __schedule(void)
 	struct rq *rq;
 	int cpu;
 
-need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
@@ -2821,8 +2824,6 @@ need_resched:
 	post_schedule(rq);
 
 	sched_preempt_enable_no_resched();
-	if (need_resched())
-		goto need_resched;
 }
 
 static inline void sched_submit_work(struct task_struct *tsk)
@@ -2842,7 +2843,9 @@ asmlinkage __visible void __sched schedule(void)
 	struct task_struct *tsk = current;
 
 	sched_submit_work(tsk);
-	__schedule();
+	do {
+		__schedule();
+	} while (need_resched());
 }
 EXPORT_SYMBOL(schedule);
 
-- 
2.1.4

