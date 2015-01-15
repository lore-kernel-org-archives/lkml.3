Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbbAOKQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:16:51 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52091 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbAOKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:12:43 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH RESEND v9 06/10] sched: add per rq cpu_capacity_orig
Date: Thu, 15 Jan 2015 11:09:26 +0100
Message-Id: <1421316570-23097-7-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
References: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new field cpu_capacity_orig reflects the original capacity of a CPU
before being altered by rt tasks and/or IRQ

The cpu_capacity_orig will be used:
- to detect when the capacity of a CPU has been noticeably reduced so we can
  trig load balance to look for a CPU with better capacity. As an example, we
  can detect when a CPU handles a significant amount of irq
  (with CONFIG_IRQ_TIME_ACCOUNTING) but this CPU is seen as an idle CPU by
  scheduler whereas CPUs, which are really idle, are available.
- evaluate the available capacity for CFS tasks

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/core.c  | 2 +-
 kernel/sched/fair.c  | 8 +++++++-
 kernel/sched/sched.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c84bdc0..45ae52d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7087,7 +7087,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_capacity = SCHED_CAPACITY_SCALE;
+		rq->cpu_capacity = rq->cpu_capacity_orig = SCHED_CAPACITY_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b37c27b..4782733 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4141,6 +4141,11 @@ static unsigned long capacity_of(int cpu)
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
@@ -5821,6 +5826,7 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 
 	capacity >>= SCHED_CAPACITY_SHIFT;
 
+	cpu_rq(cpu)->cpu_capacity_orig = capacity;
 	sdg->sgc->capacity_orig = capacity;
 
 	capacity *= scale_rt_capacity(cpu);
@@ -5875,7 +5881,7 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
 			 * Runtime updates will correct capacity_orig.
 			 */
 			if (unlikely(!rq->sd)) {
-				capacity_orig += capacity_of(cpu);
+				capacity_orig += capacity_orig_of(cpu);
 				capacity += capacity_of(cpu);
 				continue;
 			}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc5b152..aaaa3e4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -585,6 +585,7 @@ struct rq {
 	struct sched_domain *sd;
 
 	unsigned long cpu_capacity;
+	unsigned long cpu_capacity_orig;
 
 	unsigned char idle_balance;
 	/* For active balancing */
-- 
1.9.1

