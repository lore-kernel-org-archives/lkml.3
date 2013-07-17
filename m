Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3GQQwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:52:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41928 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab3GQQoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 03/18] sched: Consolidate open coded preemptible() checks
Date: Wed, 17 Jul 2013 18:44:16 +0200
Message-Id: <1374079471-3129-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
References: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preempt_schedule() and preempt_schedule_context() open
code their preemptability checks.

Use the standard API instead for consolidation.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/context_tracking.c |    3 +--
 kernel/sched/core.c       |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 383f823..942835c 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -87,10 +87,9 @@ void user_enter(void)
  */
 void __sched notrace preempt_schedule_context(void)
 {
-	struct thread_info *ti = current_thread_info();
 	enum ctx_state prev_ctx;
 
-	if (likely(ti->preempt_count || irqs_disabled()))
+	if (likely(!preemptible()))
 		return;
 
 	/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d8eb45..0e2936d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2510,13 +2510,11 @@ void __sched schedule_preempt_disabled(void)
  */
 asmlinkage void __sched notrace preempt_schedule(void)
 {
-	struct thread_info *ti = current_thread_info();
-
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
 	 * we do not want to preempt the current task. Just return..
 	 */
-	if (likely(ti->preempt_count || irqs_disabled()))
+	if (likely(!preemptible()))
 		return;
 
 	do {
-- 
1.7.5.4

