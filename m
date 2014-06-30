Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaF3QIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:08:24 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40964 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbaF3QHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:07:04 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 10/12] sched: get CPU's utilization statistic
Date: Mon, 30 Jun 2014 18:05:41 +0200
Message-Id: <1404144343-18720-11-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monitor the utilization level of each group of each sched_domain level. The
utilization is the amount of cpu_power that is currently used on a CPU or group
of CPUs. We use the runnable_avg_sum and _period to evaluate this utilization
level. In the special use case where the CPU is fully loaded by more than 1
task, the activity level is set above the cpu_power in order to reflect the
overload of the CPU

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bdc5cb9..a6b4b25 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4047,6 +4047,11 @@ static unsigned long capacity_of(int cpu)
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
@@ -4437,6 +4442,18 @@ done:
 	return target;
 }
 
+static int get_cpu_utilization(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u32 sum = rq->avg.runnable_avg_sum;
+	u32 period = rq->avg.runnable_avg_period;
+
+	if (sum >= period)
+		return capacity_orig_of(cpu) + 1;
+
+	return (sum * capacity_orig_of(cpu)) / period;
+}
+
 /*
  * select_task_rq_fair: Select target runqueue for the waking task in domains
  * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
@@ -5517,6 +5534,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
 	unsigned long group_capacity;
+	unsigned long group_utilization; /* Total utilization of the group */
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
 	unsigned int group_capacity_factor;
 	unsigned int idle_cpus;
@@ -5876,6 +5894,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
+		sgs->group_utilization += get_cpu_utilization(i);
 		sgs->sum_nr_running += rq->cfs.h_nr_running;
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
@@ -6043,7 +6062,6 @@ next_group:
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
 		sds->total_capacity += sgs->group_capacity;
-
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 
-- 
1.9.1

