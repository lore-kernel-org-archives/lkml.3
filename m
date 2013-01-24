Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3AXDNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:13:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:55789 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab3AXDNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:13:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="194551522"
Message-ID: <5100A6F7.4080109@intel.com>
Date: Thu, 24 Jan 2013 11:13:59 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, srikar@linux.vnet.ibm.com
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com> <1357114354.5586.39.camel@marge.simpson.net> <50E55F99.6090104@linux.vnet.ibm.com> <1357373590.5690.172.camel@marge.simpson.net> <1357489955.5717.21.camel@marge.simpson.net> <50EA5D41.4090502@linux.vnet.ibm.com> <1357544184.5792.140.camel@marge.simpson.net> <50EBDBB7.5060803@linux.vnet.ibm.com> <50F6B455.2040508@intel.com> <87k3rcl75q.fsf@sejong.aot.lge.com> <50F7FF79.6080603@intel.com>
In-Reply-To: <50F7FF79.6080603@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> Maybe we can skip local group since it's a bottom-up search so we know
>> there's no idle cpu in the lower domain from the prior iteration.
>>
> 
> I did this change but seems results are worse on my machines, guess start seeking idle cpu bottom up is a bad idea.
> The following is full version with above change.
> 

also tried to keep top-down seeking mode, and will return any idle cpu
instead of the first cpu in a idle group. But the result doesn't show
better on benchmark hackbench.

===
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..fb85094 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3169,6 +3169,7 @@ static int wake_affine(struct sched_domain *sd,
struct task_struct *p, int sync)
  		return 1;
 	}
+	/* bias toward prev cpu */
 	return 0;
 }
 @@ -3252,7 +3253,8 @@ find_idlest_cpu(struct sched_group *group, struct
task_struct *p, int this_cpu)
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
-static int select_idle_sibling(struct task_struct *p, int target)
+static int select_idle_sibling(struct task_struct *p,
+				struct sched_domain *affine_sd, int sync)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
@@ -3264,20 +3266,23 @@ static int select_idle_sibling(struct
task_struct *p, int target)
 	 * If the task is going to be woken-up on this cpu and if it is
 	 * already idle, then it is the right target.
 	 */
-	if (target == cpu && idle_cpu(cpu))
+	if (idle_cpu(cpu))
 		return cpu;
  	/*
 	 * If the task is going to be woken-up on the cpu where it previously
 	 * ran and if it is currently idle, then it the right target.
 	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
+	if (cpu != prev_cpu && idle_cpu(prev_cpu))
 		return prev_cpu;
 +	if (cpu != prev_cpu && !wake_affine(affine_sd, p, sync))
+		cpu = prev_cpu;
+
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	sd = rcu_dereference(per_cpu(sd_llc, target));
+	sd = rcu_dereference(per_cpu(sd_llc, cpu));
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
@@ -3290,7 +3295,7 @@ static int select_idle_sibling(struct task_struct
*p, int target)
 					goto next;
 			}
 -			target = cpumask_first_and(sched_group_cpus(sg),
+			cpu = cpumask_first_and(sched_group_cpus(sg),
 					tsk_cpus_allowed(p));
 			goto done;
 next:
@@ -3298,7 +3303,7 @@ next:
 		} while (sg != sd->groups);
 	}
 done:
-	return target;
+	return cpu;
 }
  /*
@@ -3351,10 +3356,7 @@ select_task_rq_fair(struct task_struct *p, int
sd_flag, int wake_flags)
 	}
  	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
-			prev_cpu = cpu;
-
-		new_cpu = select_idle_sibling(p, prev_cpu);
+		new_cpu = select_idle_sibling(p, affine_sd, sync);
 		goto unlock;
 	}

