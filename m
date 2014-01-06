Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaAFLe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:34:56 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:65503 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaAFLez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:34:55 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 1/8] sched: reduce trigger_load_balance parameters
Date: Mon,  6 Jan 2014 12:34:38 +0100
Message-Id: <1389008085-9069-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu information is already stored in the struct rq, so no need to pass it
as parameter to the trigger_load_balance function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/core.c  |    2 +-
 kernel/sched/fair.c  |    4 +++-
 kernel/sched/sched.h |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b21a63e..7007884 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2299,7 +2299,7 @@ void scheduler_tick(void)
 
 #ifdef CONFIG_SMP
 	rq->idle_balance = idle_cpu(cpu);
-	trigger_load_balance(rq, cpu);
+	trigger_load_balance(rq);
 #endif
 	rq_last_tick_reset(rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4316af2..600301c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6869,8 +6869,10 @@ static inline int on_null_domain(int cpu)
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
  */
-void trigger_load_balance(struct rq *rq, int cpu)
+void trigger_load_balance(struct rq *rq)
 {
+	int cpu = rq->cpu;
+
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b3b4a49..4f10d1a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1052,7 +1052,7 @@ extern const struct sched_class idle_sched_class;
 
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
-extern void trigger_load_balance(struct rq *rq, int cpu);
+extern void trigger_load_balance(struct rq *rq);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
-- 
1.7.9.5

