Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaHKLkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:40:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53920 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbaHKLkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:40:21 -0400
Subject: [RFC PATCH V2 13/19] sched: packing transitory tasks in wakeup
 power balancing
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
Date: Mon, 11 Aug 2014 17:09:12 +0530
Message-ID: <20140811113856.31956.15383.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-7182-0000-0000-0000002BA18E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

If the waked task is transitory enough, it will has a chance to be
packed into a cpu which is busy but still has time to care it.

For powersaving policy, only the history util < 25% task has chance to
be packed. If there is no cpu eligible to handle it, will use a idlest
cpu in leader group.

Morten Rasmussen catch a type bug. And PeterZ reminder to consider
rt_util. thanks you!

Inspired-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |   56 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3db77e8..e7a677e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4693,24 +4693,65 @@ static inline int get_sd_sched_balance_policy(struct sched_domain *sd,
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
+	unsigned putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_CAPACITY_SHIFT)
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
 #else
 static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
-		struct task_struct *p, struct sd_lb_stats *sds)
+		struct task_struct *p, struct sd_lb_stats *sds, int wakeup)
 {
 	return -1;
 }
@@ -4768,13 +4809,14 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
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
 

