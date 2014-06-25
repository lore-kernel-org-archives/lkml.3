Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaFYIoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:44:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:15882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbaFYIk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:40:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="449717514"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [RFC PATCH 6/9 v4] Implement Workload Consolidation in wakeup/fork/exec
Date: Wed, 25 Jun 2014 08:36:05 +0800
Message-Id: <1403656568-32445-7-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
References: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In WAKE_AFFINE, if the target (in wakee and waker order) is not idle, but the
the target is capable of handling the wakee task according to CC, we also
select it.

When to find the idlest sched_group, we first try to find the consolidated group.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched/sysctl.h |    4 ++++
 kernel/sched/fair.c          |   52 +++++++++++++++++++++++++++++++++++++++---
 kernel/sysctl.c              |    9 ++++++++
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 596a0e0..78acbd7 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -40,6 +40,10 @@ extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
 
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_sched_cc_wakeup_threshold;
+#endif
+
 enum sched_tunable_scaling {
 	SCHED_TUNABLESCALING_NONE,
 	SCHED_TUNABLESCALING_LOG,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7f80058..008cbc9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2606,6 +2606,9 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 }
 
 static inline void update_cpu_concurrency(struct rq *rq);
+static struct sched_group *wc_find_group(struct sched_domain *sd,
+	struct task_struct *p, int this_cpu);
+static int cpu_cc_capable(int cpu);
 
 /*
  * Update the rq's load with the elapsed running time before entering
@@ -4421,7 +4424,19 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_group *sg;
 	int i = task_cpu(p);
 
-	if (idle_cpu(target))
+	/*
+	 * We prefer wakee to waker CPU. For each of them, if it is idle, then
+	 * select it, but if not, we lower down the bar to use a threshold of CC
+	 * to determine whether it is capable of handling the wakee task
+	 */
+	if (sysctl_sched_cc_wakeup_threshold) {
+		if (idle_cpu(i) || cpu_cc_capable(i))
+			return i;
+
+		if (i != target && (idle_cpu(target) || cpu_cc_capable(target)))
+			return target;
+	}
+	else if (idle_cpu(target))
 		return target;
 
 	/*
@@ -4515,7 +4530,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	}
 
 	while (sd) {
-		struct sched_group *group;
+		struct sched_group *group = NULL;
 		int weight;
 
 		if (!(sd->flags & sd_flag)) {
@@ -4523,7 +4538,12 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			continue;
 		}
 
-		group = find_idlest_group(sd, p, cpu, sd_flag);
+		if (sd->flags & SD_WORKLOAD_CONSOLIDATION)
+			group = wc_find_group(sd, p, cpu);
+
+		if (!group)
+			group = find_idlest_group(sd, p, cpu, sd_flag);
+
 		if (!group) {
 			sd = sd->child;
 			continue;
@@ -7834,6 +7854,12 @@ __init void init_sched_fair_class(void)
  */
 
 /*
+ * concurrency lower than this threshold percentage of cc 1
+ * is capable of running wakee task, otherwise make it 0
+ */
+unsigned int sysctl_sched_cc_wakeup_threshold = 60UL;
+
+/*
  * we update cpu concurrency at:
  * 1) enqueue task, which increases concurrency
  * 2) dequeue task, which decreases concurrency
@@ -7860,6 +7886,26 @@ static inline unsigned long get_cpu_concurrency(int cpu)
 	return cpu_rq(cpu)->avg.load_avg_contrib;
 }
 
+/*
+ * whether cpu is capable of having more concurrency
+ */
+static int cpu_cc_capable(int cpu)
+{
+	u64 cpu_cc = get_cpu_concurrency(cpu);
+	u64 threshold = cc_weight(1);
+
+	cpu_cc *= 100;
+	cpu_cc *= capacity_of(cpu);
+
+	threshold *= sysctl_sched_cc_wakeup_threshold;
+	threshold <<= SCHED_CAPACITY_SHIFT;
+
+	if (cpu_cc <= threshold)
+		return 1;
+
+	return 0;
+}
+
 static inline u64 sched_group_cc(struct sched_group *sg)
 {
 	u64 sg_cc = 0;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7de6555..987557b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1102,6 +1102,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_SMP
+	{
+		.procname	= "sched_cc_wakeup_threshold",
+		.data		= &sysctl_sched_cc_wakeup_threshold,
+		.maxlen		= sizeof(sysctl_sched_cc_wakeup_threshold),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 	{ }
 };
 
-- 
1.7.9.5

