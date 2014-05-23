Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaEWPyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:54:16 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45852 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaEWPyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:11 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 03/11] sched: fix avg_load computation
Date: Fri, 23 May 2014 17:52:57 +0200
Message-Id: <1400860385-14555-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The computation of avg_load and avg_load_per_task should only takes into
account the number of cfs tasks. The non cfs task are already taken into
account by decreasing the cpu's capacity (cpu_power) and they will be tracked
in the CPU's utilization (group_activity) of the next patches

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 30240ab..6a84114 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4048,7 +4048,7 @@ static unsigned long power_of(int cpu)
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long nr_running = ACCESS_ONCE(rq->cfs.h_nr_running);
 	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
@@ -5868,7 +5868,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
-		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_nr_running += rq->cfs.h_nr_running;
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
-- 
1.9.1

