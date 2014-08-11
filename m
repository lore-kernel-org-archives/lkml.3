Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaHKLib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:38:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51823 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHKLi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:38:26 -0400
Subject: [RFC PATCH V2 11/19] sched: add power aware scheduling in
 fork/exec/wake
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
Date: Mon, 11 Aug 2014 17:08:05 +0530
Message-ID: <20140811113755.31956.11197.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-9332-0000-0000-000001A6A327
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

This patch add power aware scheduling in fork/exec/wake. It try to
select cpu from the busiest while still has utilization group. That's
will save power since it leaves more groups idle in system.

The trade off is adding a power aware statistics collection in group
seeking. But since the collection just happened in power scheduling
eligible condition, the worst case of hackbench testing just drops
about 2% with powersaving policy. No clear change for performance
policy.

The main function in this patch is get_cpu_for_power_policy(), that
will try to get a idlest cpu from the busiest while still has
utilization group, if the system is using power aware policy and
has such group.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 20e2414..e993f1c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4600,6 +4600,103 @@ struct sd_lb_stats {
 #endif
 };
 
+#ifdef CONFIG_SCHED_POWER
+/*
+ * Try to collect the task running number and capacity of the group.
+ */
+static void get_sg_power_stats(struct sched_group *group,
+	struct sched_domain *sd, struct sg_lb_stats *sgs)
+{
+	int i;
+
+	for_each_cpu(i, sched_group_cpus(group))
+		sgs->group_util += max_rq_util(i);
+
+	sgs->group_weight = group->group_weight;
+}
+
+/*
+ * Is this domain full of utilization with the task?
+ */
+static int is_sd_full(struct sched_domain *sd,
+		struct task_struct *p, struct sd_lb_stats *sds)
+{
+	struct sched_group *group;
+	struct sg_lb_stats sgs;
+	long sd_min_delta = LONG_MAX;
+	unsigned int putil;
+
+	if (p->se.load.weight == p->se.avg.load_avg_contrib)
+		/* p maybe a new forked task */
+		putil = FULL_UTIL;
+	else
+		putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_CAPACITY_SHIFT)
+				/ (p->se.avg.runnable_avg_period + 1);
+
+	/* Try to collect the domain's utilization */
+	group = sd->groups;
+	do {
+		long g_delta;
+
+		memset(&sgs, 0, sizeof(sgs));
+		get_sg_power_stats(group, sd, &sgs);
+
+		g_delta = sgs.group_weight * FULL_UTIL - sgs.group_util;
+
+		if (g_delta > 0 && g_delta < sd_min_delta) {
+			sd_min_delta = g_delta;
+			sds->group_leader = group;
+		}
+
+		sds->sd_util += sgs.group_util;
+	} while  (group = group->next, group != sd->groups);
+
+	if (sds->sd_util + putil < sd->span_weight * FULL_UTIL)
+		return 0;
+
+	/* can not hold one more task in this domain */
+	return 1;
+}
+
+/*
+ * Execute power policy if this domain is not full.
+ */
+static inline int get_sd_sched_balance_policy(struct sched_domain *sd,
+	int cpu, struct task_struct *p, struct sd_lb_stats *sds)
+{
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE)
+		return SCHED_POLICY_PERFORMANCE;
+
+	memset(sds, 0, sizeof(*sds));
+	if (is_sd_full(sd, p, sds))
+		return SCHED_POLICY_PERFORMANCE;
+	return sched_balance_policy;
+}
+
+/*
+ * If power policy is eligible for this domain, and it has task allowed cpu.
+ * we will select CPU from this domain.
+ */
+static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
+		struct task_struct *p, struct sd_lb_stats *sds)
+{
+	int policy;
+	int new_cpu = -1;
+
+	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
+	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader)
+		new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
+
+	return new_cpu;
+}
+#else
+static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
+		struct task_struct *p, struct sd_lb_stats *sds)
+{
+	return -1;
+}
+#endif /* CONFIG_SCHED_POWER */
+
 /*
  * select_task_rq_fair: Select target runqueue for the waking task in domains
  * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
@@ -4608,6 +4705,9 @@ struct sd_lb_stats {
  * Balances load by selecting the idlest cpu in the idlest group, or under
  * certain conditions an idle sibling cpu if the domain has SD_WAKE_AFFINE set.
  *
+ * If CONFIG_SCHED_POWER is set and SCHED_POLICY_POWERSAVE is enabled, the power
+ * aware scheduler kicks in. It returns a cpu appropriate for power savings.
+ *
  * Returns the target cpu number.
  *
  * preempt must be disabled.
@@ -4620,6 +4720,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	int new_cpu = cpu;
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
+	struct sd_lb_stats sds;
 
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
@@ -4645,12 +4746,22 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			break;
 		}
 
-		if (tmp->flags & sd_flag)
+		if (tmp->flags & sd_flag) {
 			sd = tmp;
+
+			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds);
+			if (new_cpu != -1)
+				goto unlock;
+		}
 	}
+	if (affine_sd) {
+		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds);
+		if (new_cpu != -1)
+			goto unlock;
 
-	if (affine_sd && cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-		prev_cpu = cpu;
+ 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
+ 			prev_cpu = cpu;
+	}
 
 	if (sd_flag & SD_BALANCE_WAKE) {
 		new_cpu = select_idle_sibling(p, prev_cpu);

