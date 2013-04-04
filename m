Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab3DDCCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:29715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab3DDCCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534469"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 13/21] sched: packing transitory tasks in wakeup power balancing
Date: Thu,  4 Apr 2013 10:00:54 +0800
Message-Id: <1365040862-8390-14-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the waked task is transitory enough, it will has a chance to be
packed into a cpu which is busy but still has time to care it.

For powersaving policy, only the history util < 25% task has chance to
be packed. If there is no cpu eligible to handle it, will use a idlest
cpu in leader group.

Morten Rasmussen catch a type bug. And PeterZ reminder to consider
rt_util. thanks you!

Inspired-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a729939..6145ed2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3449,19 +3449,60 @@ static inline int get_sd_sched_balance_policy(struct sched_domain *sd,
 }
 
 /*
+ * find_leader_cpu - find the busiest but still has enough free time cpu
+ * among the cpus in group.
+ */
+static int
+find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
+		int policy)
+{
+	int vacancy, min_vacancy = INT_MAX;
+	int leader_cpu = -1;
+	int i;
+	/* percentage of the task's util */
+	unsigned putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_POWER_SHIFT)
+				/ (p->se.avg.runnable_avg_period + 1);
+
+	/* bias toward local cpu */
+	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) &&
+			FULL_UTIL - max_rq_util(this_cpu) - (putil << 2) > 0)
+		return this_cpu;
+
+	/* Traverse only the allowed CPUs */
+	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
+		if (i == this_cpu)
+			continue;
+
+		/* only light task allowed, putil < 25% */
+		vacancy = FULL_UTIL - max_rq_util(i) - (putil << 2);
+
+		if (vacancy > 0 && vacancy < min_vacancy) {
+			min_vacancy = vacancy;
+			leader_cpu = i;
+		}
+	}
+	return leader_cpu;
+}
+
+/*
  * If power policy is eligible for this domain, and it has task allowed cpu.
  * we will select CPU from this domain.
  */
 static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
-		struct task_struct *p, struct sd_lb_stats *sds)
+		struct task_struct *p, struct sd_lb_stats *sds, int wakeup)
 {
 	int policy;
 	int new_cpu = -1;
 
 	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
-	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader)
-		new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
-
+	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
+		if (wakeup)
+			new_cpu = find_leader_cpu(sds->group_leader,
+							p, cpu, policy);
+		/* for fork balancing and a little busy task */
+		if (new_cpu == -1)
+			new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
+	}
 	return new_cpu;
 }
 
@@ -3512,14 +3553,15 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 		if (tmp->flags & sd_flag) {
 			sd = tmp;
 
-			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds);
+			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds,
+						sd_flag & SD_BALANCE_WAKE);
 			if (new_cpu != -1)
 				goto unlock;
 		}
 	}
 
 	if (affine_sd) {
-		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds);
+		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 1);
 		if (new_cpu != -1)
 			goto unlock;
 
-- 
1.7.12

