Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbaFDAaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 20:30:14 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64579 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbaFDAaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 20:30:04 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/6] sched,idle: Clear polling before descheduling the idle thread
Date: Tue,  3 Jun 2014 17:29:50 -0700
Message-Id: <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
In-Reply-To: <cover.1401841482.git.luto@amacapital.net>
References: <cover.1401841482.git.luto@amacapital.net>
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
Now the polling bit is only ever set when rq->curr == rq->idle.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/sched/idle.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 2ec9f47..4de3a24 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -179,17 +179,22 @@ exit_idle:
 
 /*
  * Generic idle loop implementation
+ *
+ * Called with polling cleared.
  */
 static void cpu_idle_loop(void)
 {
-	__current_set_polling();
-
 	while (1) {
 		/*
-		 * Invariant: polling is set here (assuming that the arch
-		 * has a polling bit.
+		 * If the arch has a polling bit, we maintain an invariant:
+		 *
+		 * The polling bit is clear if we're not scheduled (i.e. if
+		 * rq->curr != rq->idle).  This means that, if rq->idle has
+		 * the polling bit set, then setting need_resched is
+		 * guaranteed to cause the cpu to reschedule.
 		 */
 
+		__current_set_polling();
 		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
@@ -229,6 +234,8 @@ static void cpu_idle_loop(void)
 		 */
 		preempt_set_need_resched();
 		tick_nohz_idle_exit();
+		__current_clr_polling();
+		smp_mb__after_clear_bit();
 		schedule_preempt_disabled();
 	}
 }
-- 
1.9.3

