Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab3BTFzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:55:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:36815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab3BTFzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:55:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="288050395"
Message-ID: <5124654E.8040001@intel.com>
Date: Wed, 20 Feb 2013 13:55:26 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 10/15] sched: packing transitory tasks in wake/exec
 power balancing
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-11-git-send-email-alex.shi@intel.com> <20130218084439.GB10009@lge.com> <5121ECD9.3020300@intel.com>
In-Reply-To: <5121ECD9.3020300@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 04:56 PM, Alex Shi wrote:
> On 02/18/2013 04:44 PM, Joonsoo Kim wrote:
>> Hello, Alex.
>>
>> On Mon, Feb 18, 2013 at 01:07:37PM +0800, Alex Shi wrote:
>>> If the waked/execed task is transitory enough, it will has a chance to be
>>> packed into a cpu which is busy but still has time to care it.
>>> For powersaving policy, only the history util < 25% task has chance to
>>> be packed, and for balance policy, only histroy util < 12.5% has chance.
>>> If there is no cpu eligible to handle it, will use a idlest cpu in
>>> leader group.
>>
>> After exec(), task's behavior may be changed, and history util may be
>> changed, too. So, IMHO, exec balancing by history util is not good idea.
>> How do you think about it?
>>
> 
> sounds make sense. are there any objections?
> 

New patch without exec balance packing:

==============
>From 7ed6c68dbd34e40b70c1b4f2563a5af172e289c3 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 14 Feb 2013 22:46:02 +0800
Subject: [PATCH 09/14] sched: packing transitory tasks in wakeup power
 balancing

If the waked task is transitory enough, it will has a chance to be
packed into a cpu which is busy but still has time to care it.

For powersaving policy, only the history util < 25% task has chance to
be packed, and for balance policy, only histroy util < 12.5% has chance.
If there is no cpu eligible to handle it, will use a idlest cpu in
leader group.

Morten Rasmussen catch a type bug and suggest using different criteria
for different policy, thanks!

Joonsoo Kim suggests not packing exec task, since the old task utils is
possibly unuseable.

Inspired-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c2a65f9..24a68af 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3452,19 +3452,72 @@ static inline int get_sd_sched_balance_policy(struct sched_domain *sd,
 }
 
 /*
+ * find_leader_cpu - find the busiest but still has enough leisure time cpu
+ * among the cpus in group.
+ */
+static int
+find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
+		int policy)
+{
+	/* percentage of the task's util */
+	unsigned putil = p->se.avg.runnable_avg_sum * 100
+				/ (p->se.avg.runnable_avg_period + 1);
+
+	struct rq *rq = cpu_rq(this_cpu);
+	int nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
+	int vacancy, min_vacancy = INT_MAX, max_util;
+	int leader_cpu = -1;
+	int i;
+
+	if (policy == SCHED_POLICY_POWERSAVING)
+		max_util = FULL_UTIL;
+	else
+		/* maximum allowable util is 60% */
+		max_util = 60;
+
+	/* bias toward local cpu */
+	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) &&
+		max_util - (rq->util * nr_running + (putil << 2)) > 0)
+			return this_cpu;
+
+	/* Traverse only the allowed CPUs */
+	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
+		if (i == this_cpu)
+			continue;
+
+		rq = cpu_rq(i);
+		nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
+
+		/* only light task allowed, like putil < 25% for powersaving */
+		vacancy = max_util - (rq->util * nr_running + (putil << 2));
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
 
@@ -3515,14 +3568,15 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
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

