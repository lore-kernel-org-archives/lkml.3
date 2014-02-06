Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaBFXKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:10:47 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38294 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaBFXKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:10:45 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: alex.shi@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH V2 1/3] sched: Remove cpu parameter for idle_balance()
Date: Thu,  6 Feb 2014 23:10:35 +0000
Message-Id: <1391728237-4441-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu parameter passed to idle_balance is not needed as it could
be retrieved from the struct rq.

Cc: alex.shi@linaro.org
Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c  |    2 +-
 kernel/sched/fair.c  |    3 ++-
 kernel/sched/sched.h |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 210a12a..16b97dd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2705,7 +2705,7 @@ need_resched:
 	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
+		idle_balance(rq);
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4caa803..428bc9d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6531,12 +6531,13 @@ out:
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
-void idle_balance(int this_cpu, struct rq *this_rq)
+void idle_balance(struct rq *this_rq)
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
 	u64 curr_cost = 0;
+	int this_cpu = this_rq->cpu;
 
 	this_rq->idle_stamp = rq_clock(this_rq);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2119fd..1436219 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1176,14 +1176,14 @@ extern const struct sched_class idle_sched_class;
 extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
-extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void idle_balance(struct rq *this_rq);
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
 #else	/* CONFIG_SMP */
 
-static inline void idle_balance(int cpu, struct rq *rq)
+static inline void idle_balance(struct rq *rq)
 {
 }
 
-- 
1.7.9.5

