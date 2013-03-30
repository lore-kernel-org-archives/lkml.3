Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3C3OgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:36:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab3C3OgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:36:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568299"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 13/21] sched: using avg_idle to detect bursty wakeup
Date: Sat, 30 Mar 2013 22:35:00 +0800
Message-Id: <1364654108-16307-14-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sleeping task has no utiliation, when they were bursty waked up, the
zero utilization make scheduler out of balance, like aim7 benchmark.

rq->avg_idle is 'to used to accommodate bursty loads in a dirt simple
dirt cheap manner' -- Mike Galbraith.

With this cheap and smart bursty indicator, we can find the wake up
burst, and use nr_running as instant utilization in this scenario.

For other scenarios, we still use the precise CPU utilization to
judage if a domain is eligible for power scheduling.

Thanks for Mike Galbraith's idea!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 83b2c39..ae07190 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3371,12 +3371,19 @@ static unsigned int max_rq_util(int cpu)
  * Try to collect the task running number and capacity of the group.
  */
 static void get_sg_power_stats(struct sched_group *group,
-	struct sched_domain *sd, struct sg_lb_stats *sgs)
+	struct sched_domain *sd, struct sg_lb_stats *sgs, int burst)
 {
 	int i;
 
-	for_each_cpu(i, sched_group_cpus(group))
-		sgs->group_util += max_rq_util(i);
+	for_each_cpu(i, sched_group_cpus(group)) {
+		struct rq *rq = cpu_rq(i);
+
+		if (burst && rq->nr_running > 1)
+			/* use nr_running as instant utilization */
+			sgs->group_util += rq->nr_running;
+		else
+			sgs->group_util += max_rq_util(i);
+	}
 
 	sgs->group_weight = group->group_weight;
 }
@@ -3390,6 +3397,8 @@ static int is_sd_full(struct sched_domain *sd,
 	struct sched_group *group;
 	struct sg_lb_stats sgs;
 	long sd_min_delta = LONG_MAX;
+	int cpu = task_cpu(p);
+	int burst = 0;
 	unsigned int putil;
 
 	if (p->se.load.weight == p->se.avg.load_avg_contrib)
@@ -3399,15 +3408,21 @@ static int is_sd_full(struct sched_domain *sd,
 		putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_POWER_SHIFT)
 				/ (p->se.avg.runnable_avg_period + 1);
 
+	if (cpu_rq(cpu)->avg_idle < sysctl_sched_burst_threshold)
+		burst = 1;
+
 	/* Try to collect the domain's utilization */
 	group = sd->groups;
 	do {
 		long g_delta;
 
 		memset(&sgs, 0, sizeof(sgs));
-		get_sg_power_stats(group, sd, &sgs);
+		get_sg_power_stats(group, sd, &sgs, burst);
 
-		g_delta = sgs.group_weight * FULL_UTIL - sgs.group_util;
+		if (burst)
+			g_delta = sgs.group_weight - sgs.group_util;
+		else
+			g_delta = sgs.group_weight * FULL_UTIL - sgs.group_util;
 
 		if (g_delta > 0 && g_delta < sd_min_delta) {
 			sd_min_delta = g_delta;
@@ -3417,8 +3432,12 @@ static int is_sd_full(struct sched_domain *sd,
 		sds->sd_util += sgs.group_util;
 	} while  (group = group->next, group != sd->groups);
 
-	if (sds->sd_util + putil < sd->span_weight * FULL_UTIL)
-		return 0;
+	if (burst) {
+		if (sds->sd_util < sd->span_weight)
+			return 0;
+	} else
+		if (sds->sd_util + putil < sd->span_weight * FULL_UTIL)
+			return 0;
 
 	/* can not hold one more task in this domain */
 	return 1;
-- 
1.7.12

