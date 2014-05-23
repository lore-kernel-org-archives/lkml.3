Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaEWPzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:55:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43385 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaEWPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:20 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 08/11] sched: get CPU's activity statistic
Date: Fri, 23 May 2014 17:53:02 +0200
Message-Id: <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monitor the activity level of each group of each sched_domain level. The
activity is the amount of cpu_power that is currently used on a CPU or group
of CPUs. We use the runnable_avg_sum and _period to evaluate this activity
level. In the special use case where the CPU is fully loaded by more than 1
task, the activity level is set above the cpu_power in order to reflect the
overload of the CPU

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b7c51be..c01d8b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4044,6 +4044,11 @@ static unsigned long power_of(int cpu)
 	return cpu_rq(cpu)->cpu_power;
 }
 
+static unsigned long power_orig_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_power_orig;
+}
+
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -4438,6 +4443,18 @@ done:
 	return target;
 }
 
+static int get_cpu_activity(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u32 sum = rq->avg.runnable_avg_sum;
+	u32 period = rq->avg.runnable_avg_period;
+
+	if (sum >= period)
+		return power_orig_of(cpu) + rq->nr_running - 1;
+
+	return (sum * power_orig_of(cpu)) / period;
+}
+
 /*
  * select_task_rq_fair: Select target runqueue for the waking task in domains
  * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
@@ -5518,6 +5535,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
 	unsigned long group_power;
+	unsigned long group_activity; /* Total activity of the group */
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
 	unsigned int group_capacity;
 	unsigned int idle_cpus;
@@ -5538,6 +5556,7 @@ struct sd_lb_stats {
 	struct sched_group *busiest;	/* Busiest group in this sd */
 	struct sched_group *local;	/* Local group in this sd */
 	unsigned long total_load;	/* Total load of all groups in sd */
+	unsigned long total_activity;  /* Total activity of all groups in sd */
 	unsigned long total_pwr;	/* Total power of all groups in sd */
 	unsigned long avg_load;	/* Average load across all groups in sd */
 
@@ -5557,6 +5576,7 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 		.busiest = NULL,
 		.local = NULL,
 		.total_load = 0UL,
+		.total_activity = 0UL,
 		.total_pwr = 0UL,
 		.busiest_stat = {
 			.avg_load = 0UL,
@@ -5876,6 +5896,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			load = source_load(i, load_idx);
 
 		sgs->group_load += load;
+		sgs->group_activity += get_cpu_activity(i);
 		sgs->sum_nr_running += rq->cfs.h_nr_running;
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
@@ -6034,6 +6055,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 next_group:
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
+		sds->total_activity += sgs->group_activity;
 		sds->total_pwr += sgs->group_power;
 
 		sg = sg->next;
-- 
1.9.1

