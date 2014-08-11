Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaHKLjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:39:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55560 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaHKLi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:38:57 -0400
Subject: [RFC PATCH V2 12/19] sched: using avg_idle to detect bursty wakeup
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:08:36 +0530
Message-ID: <20140811113826.31956.5306.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-1542-0000-0000-000003E83B3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

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
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e993f1c..3db77e8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4605,12 +4605,19 @@ struct sd_lb_stats {
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
@@ -4624,6 +4631,8 @@ static int is_sd_full(struct sched_domain *sd,
 	struct sched_group *group;
 	struct sg_lb_stats sgs;
 	long sd_min_delta = LONG_MAX;
+	int cpu = task_cpu(p);
+	int burst = 0;
 	unsigned int putil;
 
 	if (p->se.load.weight == p->se.avg.load_avg_contrib)
@@ -4633,15 +4642,21 @@ static int is_sd_full(struct sched_domain *sd,
 		putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_CAPACITY_SHIFT)
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
@@ -4651,8 +4666,12 @@ static int is_sd_full(struct sched_domain *sd,
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

