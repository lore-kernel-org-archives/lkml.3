Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3LSNe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:34:26 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61188 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3LSNeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:34:23 -0500
Message-ID: <52B2F5D0.2050707@linaro.org>
Date: Thu, 19 Dec 2013 21:34:08 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org> <1386061556-28233-5-git-send-email-alex.shi@linaro.org> <20131217141012.GG10134@e103034-lin> <20131217153809.GP21999@twins.programming.kicks-ass.net>
In-Reply-To: <20131217153809.GP21999@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 11:38 PM, Peter Zijlstra wrote:
> On Tue, Dec 17, 2013 at 02:10:12PM +0000, Morten Rasmussen wrote:
>>> @@ -4135,7 +4141,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
>>>  			if (local_group)
>>>  				load = source_load(i);
>>>  			else
>>> -				load = target_load(i);
>>> +				load = target_load(i, sd->imbalance_pct);
>>
>> Don't you apply imbalance_pct twice here? Later on in
>> find_idlest_group() you have:
>>
>> 	if (!idlest || 100*this_load < imbalance*min_load)
>> 		return NULL;
>>
>> where min_load comes from target_load().
> 
> Yes! exactly! this doesn't make any sense.

Thanks a lot for review and comments!

I changed the patch to following shape. and push it under Fengguang's testing 
system monitor. Any testing are appreciated!

BTW, Seems lots of changes in scheduler come from kinds of scenarios/benchmarks
experience. But I still like to take any theoretical comments/suggestions.

-- 
Thanks
    Alex

===

>From 5cd67d975001edafe2ee820e0be5d86881a23bd6 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linaro.org>
Date: Sat, 23 Nov 2013 23:18:09 +0800
Subject: [PATCH 4/4] sched: bias to target cpu load to reduce task moving

Task migration happens when target just a bit less then source cpu load.
To reduce such situation happens, aggravate the target cpu load with
sd->imbalance_pct/100 in wake_affine.

In find_idlest/busiest_group, change the aggravate to local cpu only
from old group aggravation.

on my pandaboard ES.

	latest kernel 527d1511310a89		+ whole patchset
hackbench -T -g 10 -f 40
	23.25"					21.99"
	23.16"					21.20"
	24.24"					21.89"
hackbench -p -g 10 -f 40
	26.52"					21.46"
	23.89"					22.96"
	25.65"					22.73"
hackbench -P -g 10 -f 40
	20.14"					19.72"
	19.96"					19.10"
	21.76"					20.03"

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bccdd89..3623ba4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -978,7 +978,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 
 static unsigned long weighted_cpuload(const int cpu);
 static unsigned long source_load(int cpu);
-static unsigned long target_load(int cpu);
+static unsigned long target_load(int cpu, int imbalance_pct);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -3809,11 +3809,17 @@ static unsigned long source_load(int cpu)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static unsigned long target_load(int cpu)
+static unsigned long target_load(int cpu, int imbalance_pct)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
+	/*
+	 * without cpu_load decay, in most of time cpu_load is same as total
+	 * so we need to make target a bit heavier to reduce task migration
+	 */
+	total = total * imbalance_pct / 100;
+
 	if (!sched_feat(LB_BIAS))
 		return total;
 
@@ -4033,7 +4039,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
 	load	  = source_load(prev_cpu);
-	this_load = target_load(this_cpu);
+	this_load = target_load(this_cpu, 100);
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -4089,7 +4095,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu) <= tl_per_task)) {
+	     this_load + target_load(prev_cpu, 100) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -4112,7 +4118,6 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 {
 	struct sched_group *idlest = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
-	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
 	do {
 		unsigned long load, avg_load;
@@ -4132,10 +4137,10 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 
 		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
-			if (local_group)
+			if (i == this_cpu)
 				load = source_load(i);
 			else
-				load = target_load(i);
+				load = target_load(i, sd->imbalance_pct);
 
 			avg_load += load;
 		}
@@ -4151,7 +4156,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		}
 	} while (group = group->next, group != sd->groups);
 
-	if (!idlest || 100*this_load < imbalance*min_load)
+	if (!idlest || this_load < min_load)
 		return NULL;
 	return idlest;
 }
@@ -5476,9 +5481,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		nr_running = rq->nr_running;
 
-		/* Bias balancing toward cpus of our domain */
-		if (local_group)
-			load = target_load(i);
+		/* Bias balancing toward dst cpu */
+		if (env->dst_cpu == i)
+			load = target_load(i, env->sd->imbalance_pct);
 		else
 			load = source_load(i);
 
@@ -5918,14 +5923,6 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		if ((local->idle_cpus < busiest->idle_cpus) &&
 		    busiest->sum_nr_running <= busiest->group_weight)
 			goto out_balanced;
-	} else {
-		/*
-		 * In the CPU_NEWLY_IDLE, CPU_NOT_IDLE cases, use
-		 * imbalance_pct to be conservative.
-		 */
-		if (100 * busiest->avg_load <=
-				env->sd->imbalance_pct * local->avg_load)
-			goto out_balanced;
 	}
 
 force_balance:
-- 
1.8.1.2

