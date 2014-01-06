Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaAFLgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:36:24 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51046 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaAFLfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:35:03 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 6/8] sched: pass struct rq to rebalance_domains function
Date: Mon,  6 Jan 2014 12:34:43 +0100
Message-Id: <1389008085-9069-7-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu information is stored in the struct rq and the caller of the
rebalance_domains function pass the cpu to retrieve the struct rq but
it already has the struct rq info. Replace the cpu parameter with the
struct rq.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c647c45..0fbd8d0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6633,10 +6633,10 @@ void update_max_interval(void)
  *
  * Balancing parameters are set up in init_sched_domains.
  */
-static void rebalance_domains(int cpu, enum cpu_idle_type idle)
+static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
 {
 	int continue_balancing = 1;
-	struct rq *rq = cpu_rq(cpu);
+	int cpu = rq->cpu;
 	unsigned long interval;
 	struct sched_domain *sd;
 	/* Earliest time when we have to do rebalance again */
@@ -6762,7 +6762,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		update_idle_cpu_load(rq);
 		raw_spin_unlock_irq(&rq->lock);
 
-		rebalance_domains(balance_cpu, CPU_IDLE);
+		rebalance_domains(rq, CPU_IDLE);
 
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
@@ -6851,7 +6851,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
-	rebalance_domains(this_cpu, idle);
+	rebalance_domains(this_rq, idle);
 
 	/*
 	 * If this cpu has a pending nohz_balance_kick, then do the
-- 
1.7.9.5

