Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3L3NpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:45:02 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44951 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab3L3No7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:44:59 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 2/7] sched: pass struct rq to on_null_domain function
Date: Mon, 30 Dec 2013 14:44:48 +0100
Message-Id: <1388411093-3413-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
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

