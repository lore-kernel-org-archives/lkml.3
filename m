Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaIWQMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:12:52 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62787 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbaIWQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:09:30 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v6 1/6] sched: add per rq cpu_capacity_orig
Date: Tue, 23 Sep 2014 18:08:00 +0200
Message-Id: <1411488485-10025-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new field cpu_capacity_orig reflects the original capacity of a CPU
before being altered by frequency scaling, rt tasks and/or IRQ

The cpu_capacity_orig  will be used in several places to detect when the
capapcity of a CPU has been noticeably reduced so we can trig load balance
to look for a CPU with better capacity.
As an example, we can detect when a CPU handles a significant amount of irq
(with CONFIG_IRQ_TIME_ACCOUNTING) but this CPU is seen as an idle CPU by
scheduler whereas CPUs, which are really idle, are available

In addition, this new cpu_capacity_orig will be used to evaluate the usage of
a the CPU by CFS tasks

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/core.c  | 2 +-
 kernel/sched/fair.c  | 8 +++++++-
 kernel/sched/sched.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2a93b87..e20f203 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7056,7 +7056,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_capacity = SCHED_CAPACITY_SCALE;
+		rq->cpu_capacity = rq->cpu_capacity_orig = SCHED_CAPACITY_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a1e6ac..622f8b0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4092,6 +4092,11 @@ static unsigned long capacity_of(int cpu)
 	return cpu_rq(cpu)->cpu_capacity;
 }
 
+static unsigned long capacity_orig_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_capacity_orig;
+}
+
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -5765,6 +5770,7 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 
 	capacity >>= SCHED_CAPACITY_SHIFT;
 
+	cpu_rq(cpu)->cpu_capacity_orig = capacity;
 	sdg->sgc->capacity_orig = capacity;
 
 	if (sched_feat(ARCH_CAPACITY))
@@ -5826,7 +5832,7 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
 			 * Runtime updates will correct capacity_orig.
 			 */
 			if (unlikely(!rq->sd)) {
-				capacity_orig += capacity_of(cpu);
+				capacity_orig += capacity_orig_of(cpu);
 				capacity += capacity_of(cpu);
 				continue;
 			}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1bc6aad..f332e45 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -575,6 +575,7 @@ struct rq {
 	struct sched_domain *sd;
 
 	unsigned long cpu_capacity;
+	unsigned long cpu_capacity_orig;
 
 	unsigned char idle_balance;
 	/* For active balancing */
-- 
1.9.1

