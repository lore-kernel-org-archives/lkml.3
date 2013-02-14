Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3BNINP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:13:15 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46642 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3BNINO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:13:14 -0500
Message-ID: <511C9C54.4090508@linux.vnet.ibm.com>
Date: Thu, 14 Feb 2013 13:42:04 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 05/18] sched: quicker balancing on fork/exec/wake
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <1358996820-23036-6-git-send-email-alex.shi@intel.com> <1360664565.4485.13.camel@laptop>
In-Reply-To: <1360664565.4485.13.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021408-4790-0000-0000-000006E8F970
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 02/12/2013 03:52 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> Guess the search cpu from bottom to up in domain tree come from
>> commit 3dbd5342074a1e sched: multilevel sbe sbf, the purpose is
>> balancing over tasks on all level domains.
>>
>> This balancing cost too much if there has many domain/groups in a
>> large system.
>>
>> If we remove this code, we will get quick fork/exec/wake with a
>> similar
>> balancing result amony whole system.
>>
>> This patch increases 10+% performance of hackbench on my 4 sockets
>> SNB machines and about 3% increasing on 2 sockets servers.
>>
>>
> Numbers be groovy.. still I'd like a little more on the behavioural
> change. Expand on what exactly is lost by this change so that if we
> later find a regression we have a better idea of what and how.
> 
> For instance, note how find_idlest_group() isn't symmetric wrt
> local_group. So by not doing the domain iteration we change things.
> 
> Now, it might well be that all this is somewhat overkill as it is, but
> should we then not replace all of it with a simple min search over all
> eligible cpus; that would be a real clean up.

Hi Peter,Alex,
If the eligible cpus happen to be all the cpus,then iterating over all the 
cpus for idlest would be much worse than iterating over sched domains right?
I am also wondering how important it is to bias the balancing of forked/woken up
task onto an idlest cpu at every iteration.

If biasing towards the idlest_cpu at every iteration is not really the criteria,
then we could cut down on the iterations in fork/exec/wake balancing.
Then the problem boils down to,is the option between biasing our search towards
the idlest_cpu or the idlest_group.If we are not really concerned about balancing
load across  groups,but ensuring we find the idlest cpu to run the task on,then
Alex's patch seems to have covered the criteria.

However if the concern is to distribute the load uniformly across groups,then
I have the following patch which might reduce the overhead of the search of an
eligible cpu for a forked/exec/woken up task.

Alex,if your patch does not show favourable behavioural changes,you could try
the below and check the same.

**************************START PATCH*************************************

sched:Improve balancing for fork/exec/wake tasks

As I see it,currently,we first find the idlest group,then the idlest cpu
within it.However the current code does not seem to get convinced that the
selected cpu in the current iteration,is in the correct child group and does
an iteration over all the groups yet again,
*taking the selected cpu as reference to point to the next level sched
domain.*

Why then find the idlest cpu at every iteration,if the concern is primarily
around the idlest group at each iteration? Why not find the idlest group in
every iteration and the idlest cpu in the final iteration? As a result:

1.We save time spent in going over all the cpus in a sched group in
find_idlest_cpu() at every iteration.
2.Functionality remains the same.We find the idlest group at every level,and
consider a cpu of the idlest group as a reference to get the next lower level
sched domain so as to find the idlest group there.
However instead of taking the idlest cpu as the reference,take
the first cpu as the reference.The resulting next level sched domain remains
the same.

*However this completely removes the bias towards the idlest cpu at every level.*

This patchset therefore tries to bias its find towards the right group to put
the task on,and not the idlest cpu.
---
 kernel/sched/fair.c |   53 ++++++++++++++-------------------------------------
 1 file changed, 15 insertions(+), 38 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8691b0d..90855dd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3190,16 +3190,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
  */
 static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
-		  int this_cpu, int load_idx)
+		  int this_cpu)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
-	struct sched_group *this_group = NULL;
-	u64 min_load = ~0ULL, this_load = 0;
-	int imbalance = 100 + (sd->imbalance_pct-100)/2;
+	struct sched_group;
+	u64 min_load = ~0ULL;
 
 	do {
 		u64 load, avg_load;
-		int local_group;
 		int i;
 
 		/* Skip over this group if it has no CPUs allowed */
@@ -3207,18 +3205,11 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 					tsk_cpus_allowed(p)))
 			continue;
 
-		local_group = cpumask_test_cpu(this_cpu,
-					       sched_group_cpus(group));
-
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
 		for_each_cpu(i, sched_group_cpus(group)) {
-			/* Bias balancing toward cpus of our domain */
-			if (local_group)
-				load = source_load(i, load_idx);
-			else
-				load = target_load(i, load_idx);
+			load = weighted_cpuload(i);
 
 			avg_load += load;
 		}
@@ -3227,20 +3218,12 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		avg_load = (avg_load * SCHED_POWER_SCALE);
 		do_div(avg_load, group->sgp->power);
 
-		if (local_group) {
-			this_load = avg_load;
-			this_group = group;
-		} else if (avg_load < min_load) {
+		if (avg_load < min_load) {
 			min_load = avg_load;
 			idlest = group;
 		}
 	} while (group = group->next, group != sd->groups);
 
-	if (this_group && idlest!= this_group) {
-		/* Bias towards our group again */
-		if (!idlest || 100*this_load < imbalance*min_load)
-			return this_group;
-	}
 	return idlest;
 }
 
@@ -3248,7 +3231,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
  * find_idlest_cpu - find the idlest cpu among the cpus in group.
  */
 static int
-find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
+find_idlest_cpu(struct sched_group *group, struct task_struct *p)
 {
 	u64 load, min_load = ~0ULL;
 	int idlest = -1;
@@ -3258,7 +3241,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
 		load = weighted_cpuload(i);
 
-		if (load < min_load || (load == min_load && i == this_cpu)) {
+		if (load < min_load) {
 			min_load = load;
 			idlest = i;
 		}
@@ -3325,6 +3308,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
+	struct sched_group *group;
 	int want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
 
@@ -3367,8 +3351,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	while (sd) {
-		int load_idx = sd->forkexec_idx;
-		struct sched_group *group;
 		int weight;
 
 		if (!(sd->flags & sd_flag)) {
@@ -3376,15 +3358,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			continue;
 		}
 
-		if (sd_flag & SD_BALANCE_WAKE)
-			load_idx = sd->wake_idx;
-
-		group = find_idlest_group(sd, p, cpu, load_idx);
-		if (!group) {
-			goto unlock;
-		}
+		group = find_idlest_group(sd, p, cpu);
 
-		new_cpu = find_idlest_cpu(group, p, cpu);
+		new_cpu = group_first_cpu(group);
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
@@ -3398,6 +3374,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		}
 		/* while loop will break here if sd == NULL */
 	}
+	new_cpu = find_idlest_cpu(group, p);
 unlock:
 	rcu_read_unlock();
 
@@ -4280,15 +4257,15 @@ static inline void update_sd_lb_power_stats(struct lb_env *env,
 	if (sgs->sum_nr_running + 1 >  sgs->group_capacity)
 		return;
 	if (sgs->group_util > sds->leader_util ||
-		sgs->group_util == sds->leader_util &&
-		group_first_cpu(group) < group_first_cpu(sds->group_leader)) {
+		(sgs->group_util == sds->leader_util &&
+		group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
 		sds->group_leader = group;
 		sds->leader_util = sgs->group_util;
 	}
 	/* Calculate the group which is almost idle */
 	if (sgs->group_util < sds->min_util ||
-		sgs->group_util == sds->min_util &&
-		group_first_cpu(group) > group_first_cpu(sds->group_leader)) {
+		(sgs->group_util == sds->min_util &&
+		group_first_cpu(group) > group_first_cpu(sds->group_leader))) {
 		sds->group_min = group;
 		sds->min_util = sgs->group_util;
 		sds->min_load_per_task = sgs->sum_weighted_load;

> 
> 
Regards
Preeti U Murthy

