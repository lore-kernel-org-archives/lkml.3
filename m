Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaAFLfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:35:00 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48455 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaAFLe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:34:56 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 2/8] sched: reduce nohz_kick_needed parameters
Date: Mon,  6 Jan 2014 12:34:39 +0100
Message-Id: <1389008085-9069-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu information is already stored in the struct rq, so no need to pass it
as parameter to the nohz_kick_needed function.

The caller of this function just called idle_cpu() before to fill the
rq->idle_balance field.

Use rq->cpu and rq->idle_balance.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 600301c..4cb414a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6781,14 +6781,14 @@ end:
  *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
  *     domain span are idle.
  */
-static inline int nohz_kick_needed(struct rq *rq, int cpu)
+static inline int nohz_kick_needed(struct rq *rq)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
 	struct sched_group_power *sgp;
-	int nr_busy;
+	int nr_busy, cpu = rq->cpu;
 
-	if (unlikely(idle_cpu(cpu)))
+	if (unlikely(rq->idle_balance))
 		return 0;
 
        /*
@@ -6878,7 +6878,7 @@ void trigger_load_balance(struct rq *rq)
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ_COMMON
-	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
-- 
1.7.9.5

