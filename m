Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaFDRcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:32:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33709 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaFDRb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:31:27 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3/5] sched,idle: Clear polling before descheduling the idle thread
Date: Wed,  4 Jun 2014 10:31:16 -0700
Message-Id: <b2059fcb4c613d520cb503b6fad6e47033c7c203.1401902905.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the only real guarantee provided by the polling bit is
that, if you hold rq->lock and the polling bit is set, then you can
set need_resched to force a reschedule.

The only reason the lock is needed is that the idle thread might not
be running at all when setting its need_resched bit, and rq->lock
keeps it pinned.

This is easy to fix: just clear the polling bit before scheduling.
Now the idle thread's polling bit is only ever set when
rq->curr == rq->idle.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/sched/idle.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 25b9423..1065347 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -67,6 +67,10 @@ void __weak arch_cpu_idle(void)
  * cpuidle_idle_call - the main idle function
  *
  * NOTE: no locks or semaphores should be used here
+ *
+ * On archs that support TIF_POLLING_NRFLAG, is called with polling
+ * set, and it returns with polling set.  If it ever stops polling, it
+ * must clear the polling bit.
  */
 static void cpuidle_idle_call(void)
 {
@@ -175,10 +179,22 @@ exit_idle:
 
 /*
  * Generic idle loop implementation
+ *
+ * Called with polling cleared.
  */
 static void cpu_idle_loop(void)
 {
 	while (1) {
+		/*
+		 * If the arch has a polling bit, we maintain an invariant:
+		 *
+		 * Our polling bit is clear if we're not scheduled (i.e. if
+		 * rq->curr != rq->idle).  This means that, if rq->idle has
+		 * the polling bit set, then setting need_resched is
+		 * guaranteed to cause the cpu to reschedule.
+		 */
+
+		__current_set_polling();
 		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
@@ -218,6 +234,15 @@ static void cpu_idle_loop(void)
 		 */
 		preempt_set_need_resched();
 		tick_nohz_idle_exit();
+		__current_clr_polling();
+
+		/*
+		 * We promise to reschedule if need_resched is set while
+		 * polling is set.  That means that clearing polling
+		 * needs to be visible before rescheduling.
+		 */
+		smp_mb__after_clear_bit();
+
 		schedule_preempt_disabled();
 	}
 }
@@ -239,7 +264,6 @@ void cpu_startup_entry(enum cpuhp_state state)
 	 */
 	boot_init_stack_canary();
 #endif
-	__current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
-- 
1.9.3

