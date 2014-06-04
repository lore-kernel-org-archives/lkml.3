Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaFDRbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:31:36 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47920 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaFDRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:31:29 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 4/5] sched,idle: Simplify wake_up_idle_cpu
Date: Wed,  4 Jun 2014 10:31:17 -0700
Message-Id: <922f00761445a830ebb23d058e2ae53956ce2d73.1401902905.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that rq->idle's polling bit is a reliable indication that the cpu is
polling, use it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/sched/core.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a002be7..f6e4621 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -628,26 +628,7 @@ static void wake_up_idle_cpu(int cpu)
 	if (cpu == smp_processor_id())
 		return;
 
-	/*
-	 * This is safe, as this function is called with the timer
-	 * wheel base lock of (cpu) held. When the CPU is on the way
-	 * to idle and has not yet set rq->curr to idle then it will
-	 * be serialized on the timer wheel base lock and take the new
-	 * timer into account automatically.
-	 */
-	if (rq->curr != rq->idle)
-		return;
-
-	/*
-	 * We can set TIF_RESCHED on the idle task of the other CPU
-	 * lockless. The worst case is that the other CPU runs the
-	 * idle task through an additional NOOP schedule()
-	 */
-	set_tsk_need_resched(rq->idle);
-
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(rq->idle))
+	if (set_nr_and_not_polling(rq->idle))
 		smp_send_reschedule(cpu);
 	else
 		trace_sched_wake_idle_without_ipi(cpu);
-- 
1.9.3

