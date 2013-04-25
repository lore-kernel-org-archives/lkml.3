Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab3DYR0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:26:46 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62631 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab3DYRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:25:09 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net,
        l.majewski@samsung.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 09/14] sched: evaluate the activity level of the system
Date: Thu, 25 Apr 2013 19:23:25 +0200
Message-Id: <1366910611-20048-10-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We evaluate the activity level of CPUs, groups and domains in order to define
how many CPUs are required to handle the current activity.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 954adfd..234ecdd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3465,7 +3465,22 @@ static int check_pack_buddy(int cpu, struct task_struct *p)
 		return true;
 
 	return false;
+}
+
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
+		return power_of(cpu) + overload;
+	}
 
+	return (sum * power_of(cpu)) / period;
 }
 
 /*
@@ -4355,6 +4370,7 @@ struct sd_lb_stats {
 	struct sched_group *busiest; /* Busiest group in this sd */
 	struct sched_group *this;  /* Local group in this sd */
 	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_activity;  /* Total activity of all groups in sd */
 	unsigned long total_pwr;   /*	Total power of all groups in sd */
 	unsigned long avg_load;	   /* Average load across all groups in sd */
 
@@ -4383,6 +4399,7 @@ struct sd_lb_stats {
 struct sg_lb_stats {
 	unsigned long avg_load; /*Avg load across the CPUs of the group */
 	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long group_activity; /* Total activity of the group */
 	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
@@ -4629,6 +4646,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		}
 
 		sgs->group_load += load;
+		sgs->group_activity += get_cpu_activity(i);
 		sgs->sum_nr_running += nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
 		if (idle_cpu(i))
@@ -4752,6 +4770,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			return;
 
 		sds->total_load += sgs.group_load;
+		sds->total_activity += sgs.group_activity;
 		sds->total_pwr += sg->sgp->power;
 
 		/*
-- 
1.7.9.5

