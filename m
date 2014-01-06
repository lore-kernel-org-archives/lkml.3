Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaAFLhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:37:31 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:42620 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaAFLe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:34:59 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 3/8] sched: pass struct rq to on_null_domain function
Date: Mon,  6 Jan 2014 12:34:40 +0100
Message-Id: <1389008085-9069-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The on_null_domain function is getting the cpu to retrieve the struct rq
associated with it.

Pass the struct rq directly to the function as the caller has already the info.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4cb414a..82dd145 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6861,9 +6861,9 @@ static void run_rebalance_domains(struct softirq_action *h)
 	nohz_idle_balance(this_cpu, idle);
 }
 
-static inline int on_null_domain(int cpu)
+static inline int on_null_domain(struct rq *rq)
 {
-	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(rq->sd);
 }
 
 /*
@@ -6875,10 +6875,10 @@ void trigger_load_balance(struct rq *rq)
 
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
-	    likely(!on_null_domain(cpu)))
+	    likely(!on_null_domain(rq)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ_COMMON
-	if (nohz_kick_needed(rq) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq) && likely(!on_null_domain(rq)))
 		nohz_balancer_kick(cpu);
 #endif
 }
-- 
1.7.9.5

