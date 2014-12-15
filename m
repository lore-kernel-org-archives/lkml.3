Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaLOCYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:24:50 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35928 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaLOCYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:24:41 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] sched: Fix missing preemption check in cond_resched()
Date: Mon, 15 Dec 2014 03:24:31 +0100
Message-Id: <1418610272-21518-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418610272-21518-1-git-send-email-fweisbec@gmail.com>
References: <1418610272-21518-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an interrupt fires in cond_resched() between the call to __schedule()
and the PREEMPT_ACTIVE count decrementation with the interrupt having
set TIF_NEED_RESCHED, the call to preempt_schedule_irq() will be ignored
due to the PREEMPT_ACTIVE count. This kind of scenario, with irq preemption
being delayed because we are interrupting a preempt-disabled area, is
usually fixed up after preemption is re-enabled back with an explicit
call to preempt_schedule().

This is what preempt_enable() does but a raw preempt count decrement as
performed by __preempt_count_sub(PREEMPT_ACTIVE) doesn't handle delayed
preemption check. Therefore when such a race happens, the rescheduling
is going to be delayed until the next scheduler or preemption entrypoint.
This can be a problem for scheduler latency sensitive workloads.

Lets fix that by consolidating cond_resched() with preempt_schedule()
internals.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-and-inspired-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5797b7..069a2d8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2877,6 +2877,21 @@ void __sched schedule_preempt_disabled(void)
 	preempt_disable();
 }
 
+static void preempt_schedule_common(void)
+{
+	do {
+		__preempt_count_add(PREEMPT_ACTIVE);
+		__schedule();
+		__preempt_count_sub(PREEMPT_ACTIVE);
+
+		/*
+		 * Check again in case we missed a preemption opportunity
+		 * between schedule and now.
+		 */
+		barrier();
+	} while (need_resched());
+}
+
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
@@ -2892,17 +2907,7 @@ asmlinkage __visible void __sched notrace preempt_schedule(void)
 	if (likely(!preemptible()))
 		return;
 
-	do {
-		__preempt_count_add(PREEMPT_ACTIVE);
-		__schedule();
-		__preempt_count_sub(PREEMPT_ACTIVE);
-
-		/*
-		 * Check again in case we missed a preemption opportunity
-		 * between schedule and now.
-		 */
-		barrier();
-	} while (need_resched());
+	preempt_schedule_common();
 }
 NOKPROBE_SYMBOL(preempt_schedule);
 EXPORT_SYMBOL(preempt_schedule);
@@ -4202,17 +4207,10 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
 
-static void __cond_resched(void)
-{
-	__preempt_count_add(PREEMPT_ACTIVE);
-	__schedule();
-	__preempt_count_sub(PREEMPT_ACTIVE);
-}
-
 int __sched _cond_resched(void)
 {
 	if (should_resched()) {
-		__cond_resched();
+		preempt_schedule_common();
 		return 1;
 	}
 	return 0;
@@ -4237,7 +4235,7 @@ int __cond_resched_lock(spinlock_t *lock)
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
 		if (resched)
-			__cond_resched();
+			preempt_schedule_common();
 		else
 			cpu_relax();
 		ret = 1;
@@ -4253,7 +4251,7 @@ int __sched __cond_resched_softirq(void)
 
 	if (should_resched()) {
 		local_bh_enable();
-		__cond_resched();
+		preempt_schedule_common();
 		local_bh_disable();
 		return 1;
 	}
-- 
2.1.3

