Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaAFLfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:35:09 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:44061 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaAFLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:35:05 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        preeti.lkml@gmail.com
Subject: [PATCH V2 7/8] sched: pass struct rq to nohz_idle_balance function
Date: Mon,  6 Jan 2014 12:34:44 +0100
Message-Id: <1389008085-9069-8-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu information is stored in the struct rq. Pass the struct rq to
nohz_idle_balance, so all the functions called in run_rebalance_domains have
the same parameters and the 'this_cpu' variable becomes pointless.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0fbd8d0..59c57e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6733,9 +6733,9 @@ out:
  * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
-static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 {
-	struct rq *this_rq = cpu_rq(this_cpu);
+	int this_cpu = this_rq->cpu;
 	struct rq *rq;
 	int balance_cpu;
 
@@ -6846,8 +6846,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
  */
 static void run_rebalance_domains(struct softirq_action *h)
 {
-	int this_cpu = smp_processor_id();
-	struct rq *this_rq = cpu_rq(this_cpu);
+	struct rq *this_rq = this_rq();
 	enum cpu_idle_type idle = this_rq->idle_balance ?
 						CPU_IDLE : CPU_NOT_IDLE;
 
@@ -6858,7 +6857,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	nohz_idle_balance(this_cpu, idle);
+	nohz_idle_balance(this_rq, idle);
 }
 
 static inline int on_null_domain(struct rq *rq)
-- 
1.7.9.5

