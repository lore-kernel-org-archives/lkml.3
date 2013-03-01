Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3CAQKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:10:14 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55577 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3CAQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:09:34 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] context_tracking: Restore preempted context state after preempt_schedule_irq()
Date: Fri,  1 Mar 2013 17:08:57 +0100
Message-Id: <1362154139-1139-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
References: <1362154139-1139-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the context tracking POV, preempt_schedule_irq() behaves pretty much
like an exception: It can be called anytime and schedule another task.

But currently it doesn't restore the context tracking state of the preempted
code on preempt_schedule_irq() return.

As a result, if preempt_schedule_irq() is called in the tiny frame between
user_enter() and the actual return to userspace, we resume userspace with
the wrong context tracking state.

Fix this by using exception_enter/exit() which are a perfect fit for this
kind of issue.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mats Liljegren <mats.liljegren@enea.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7b03cd..db36e11 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3074,11 +3074,13 @@ EXPORT_SYMBOL(preempt_schedule);
 asmlinkage void __sched preempt_schedule_irq(void)
 {
 	struct thread_info *ti = current_thread_info();
+	enum ctx_state prev_state;
 
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
-	user_exit();
+	prev_state = exception_enter();
+
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
@@ -3092,6 +3094,8 @@ asmlinkage void __sched preempt_schedule_irq(void)
 		 */
 		barrier();
 	} while (need_resched());
+
+	exception_exit(prev_state);
 }
 
 #endif /* CONFIG_PREEMPT */
-- 
1.7.5.4

