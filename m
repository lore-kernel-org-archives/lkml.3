Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3AZBu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:50:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:39598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab3AZBtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,542,1355126400"; 
   d="scan'208";a="276820888"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [RFC patch v2 7/7] sched: consider runnable load average in effective_load
Date: Sat, 26 Jan 2013 09:49:24 +0800
Message-Id: <1359164964-29052-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
References: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

effective_load calculates the load change as seen from the
root_task_group. It needs to engage the runnable average
of changed task.

Thanks for Morten Rasmussen's reminder of this.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84bb3f7..8066a61 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2981,7 +2981,8 @@ static void task_waking_fair(struct task_struct *p)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
- * effective_load() calculates the load change as seen from the root_task_group
+ * effective_load() calculates the runnable load average change as seen from
+ * the root_task_group
  *
  * Adding load to a group doesn't make a group heavier, but can cause movement
  * of group shares between cpus. Assuming the shares were perfectly aligned one
@@ -3029,6 +3030,9 @@ static void task_waking_fair(struct task_struct *p)
  * Therefore the effective change in loads on CPU 0 would be 5/56 (3/8 - 2/7)
  * times the weight of the group. The effect on CPU 1 would be -4/56 (4/8 -
  * 4/7) times the weight of the group.
+ *
+ * After get effective_load of the load moving, will engaged the sched entity's
+ * runnable avg.
  */
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
@@ -3103,6 +3107,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
+	int runnable_avg;
 
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
@@ -3118,13 +3123,19 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
+		runnable_avg = current->se.avg.runnable_avg_sum * NICE_0_LOAD
+				/ (current->se.avg.runnable_avg_period + 1);
 
-		this_load += effective_load(tg, this_cpu, -weight, -weight);
-		load += effective_load(tg, prev_cpu, 0, -weight);
+		this_load += effective_load(tg, this_cpu, -weight, -weight)
+				* runnable_avg >> NICE_0_SHIFT;
+		load += effective_load(tg, prev_cpu, 0, -weight)
+				* runnable_avg >> NICE_0_SHIFT;
 	}
 
 	tg = task_group(p);
 	weight = p->se.load.weight;
+	runnable_avg = p->se.avg.runnable_avg_sum * NICE_0_LOAD
+				/ (p->se.avg.runnable_avg_period + 1);
 
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
@@ -3136,16 +3147,18 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * task to be woken on this_cpu.
 	 */
 	if (this_load > 0) {
-		s64 this_eff_load, prev_eff_load;
+		s64 this_eff_load, prev_eff_load, tmp_eff_load;
 
 		this_eff_load = 100;
 		this_eff_load *= power_of(prev_cpu);
-		this_eff_load *= this_load +
-			effective_load(tg, this_cpu, weight, weight);
+		tmp_eff_load = effective_load(tg, this_cpu, weight, weight)
+				* runnable_avg >> NICE_0_SHIFT;
+		this_eff_load *= this_load + tmp_eff_load;
 
 		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
 		prev_eff_load *= power_of(this_cpu);
-		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+		prev_eff_load *= load + (effective_load(tg, prev_cpu, 0, weight)
+						* runnable_avg >> NICE_0_SHIFT);
 
 		balanced = this_eff_load <= prev_eff_load;
 	} else
-- 
1.7.12

