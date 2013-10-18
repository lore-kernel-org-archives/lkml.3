Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3JRLyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:11 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62335 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3JRLxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:53 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 07/14] sched: get CPU's activity statistic
Date: Fri, 18 Oct 2013 13:52:20 +0200
Message-Id: <1382097147-30088-7-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monitor the activity level of each group of each sched_domain level. The
activity is the amount of cpu_power that is currently used on a CPU. We use
the runnable_avg_sum and _period to evaluate this activity level. In the
special use case where the CPU is fully loaded by more than 1 task, the
activity level is set above the cpu_power in order to reflect the overload of
The cpu

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index db9b871..7e26f65 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -179,6 +179,11 @@ void sched_init_granularity(void)
 }
 
 #ifdef CONFIG_SMP
+static unsigned long available_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_available;
+}
+
 #ifdef CONFIG_SCHED_PACKING_TASKS
 /*
  * Save the id of the optimal CPU that should be used to pack small tasks
@@ -3549,6 +3554,22 @@ done:
 	return target;
 }
 
+static int get_cpu_activity(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u32 sum = rq->avg.runnable_avg_sum;
+	u32 period = rq->avg.runnable_avg_period;
+
+	sum = min(sum, period);
+
+	if (sum == period) {
+		u32 overload = rq->nr_running > 1 ? 1 : 0;
+		return available_of(cpu) + overload;
+	}
+
+	return (sum * available_of(cpu)) / period;
+}
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -4430,6 +4451,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
 	unsigned long group_power;
+	unsigned long group_activity; /* Total activity of the group */
 	unsigned int sum_nr_running; /* Nr tasks running in the group */
 	unsigned int group_capacity;
 	unsigned int idle_cpus;
@@ -4446,6 +4468,7 @@ struct sd_lb_stats {
 	struct sched_group *busiest;	/* Busiest group in this sd */
 	struct sched_group *local;	/* Local group in this sd */
 	unsigned long total_load;	/* Total load of all groups in sd */
+	unsigned long total_activity;  /* Total activity of all groups in sd */
 	unsigned long total_pwr;	/* Total power of all groups in sd */
 	unsigned long avg_load;	/* Average load across all groups in sd */
 
@@ -4465,6 +4488,7 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 		.busiest = NULL,
 		.local = NULL,
 		.total_load = 0UL,
+		.total_activity = 0UL,
 		.total_pwr = 0UL,
 		.busiest_stat = {
 			.avg_load = 0UL,
@@ -4771,6 +4795,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		}
 
 		sgs->group_load += load;
+		sgs->group_activity += get_cpu_activity(i);
 		sgs->sum_nr_running += nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
@@ -4894,6 +4919,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
+		sds->total_activity += sgs->group_activity;
 		sds->total_pwr += sgs->group_power;
 
 		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
-- 
1.7.9.5

