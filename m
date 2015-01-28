Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbbA1AYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:24:25 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:61571 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393AbbA1AYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:24:22 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH 2/4] sched: Use traced preempt count operations to toggle PREEMPT_ACTIVE
Date: Wed, 28 Jan 2015 01:24:10 +0100
Message-Id: <1422404652-29067-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d1f74e20b5b064a130cd0743a256c2d3cfe84010 turned PREEMPT_ACTIVE modifiers
to use raw untraced preempt count operations. Meanwhile this prevents
from debugging and tracing preemption disabled if we pull that
responsibility to schedule() callers (see following patches).

Is there anything we can do about that?

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bbef95d..89b165f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2883,9 +2883,9 @@ void __sched schedule_preempt_disabled(void)
 static void preempt_schedule_common(void)
 {
 	do {
-		__preempt_count_add(PREEMPT_ACTIVE);
+		preempt_count_add(PREEMPT_ACTIVE);
 		__schedule();
-		__preempt_count_sub(PREEMPT_ACTIVE);
+		preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
@@ -2938,7 +2938,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_context(void)
 		return;
 
 	do {
-		__preempt_count_add(PREEMPT_ACTIVE);
+		preempt_count_add(PREEMPT_ACTIVE);
 		/*
 		 * Needs preempt disabled in case user_exit() is traced
 		 * and the tracer calls preempt_enable_notrace() causing
@@ -2948,7 +2948,7 @@ asmlinkage __visible void __sched notrace preempt_schedule_context(void)
 		__schedule();
 		exception_exit(prev_ctx);
 
-		__preempt_count_sub(PREEMPT_ACTIVE);
+		preempt_count_sub(PREEMPT_ACTIVE);
 		barrier();
 	} while (need_resched());
 }
@@ -2973,11 +2973,11 @@ asmlinkage __visible void __sched preempt_schedule_irq(void)
 	prev_state = exception_enter();
 
 	do {
-		__preempt_count_add(PREEMPT_ACTIVE);
+		preempt_count_add(PREEMPT_ACTIVE);
 		local_irq_enable();
 		__schedule();
 		local_irq_disable();
-		__preempt_count_sub(PREEMPT_ACTIVE);
+		preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
-- 
2.1.4

