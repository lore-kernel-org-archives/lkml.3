Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaF3Hgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:36:54 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52625 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaF3Hgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:36:52 -0400
Message-ID: <53B11387.9020001@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2014 15:36:39 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com>
In-Reply-To: <53A11A89.5000602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063007-1618-0000-0000-0000007B18E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 12:50 PM, Michael wang wrote:
> By testing we found that after put benchmark (dbench) in to deep cpu-group,
> tasks (dbench routines) start to gathered on one CPU, which lead to that the
> benchmark could only get around 100% CPU whatever how big it's task-group's
> share is, here is the link of the way to reproduce the issue:

Hi, Peter

We thought that involved too much factors will make things too
complicated, we are trying to start over and get rid of the concepts of
'deep-group' and 'GENTLE_FAIR_SLEEPERS' in the idea, wish this could
make things more easier...

Let's put down the prev-discussions, for now we just want to proposal a
cpu-group feature which could help dbench to gain enough CPU while
stress is running, in a gentle way which hasn't yet been provided by
current scheduler.

I'll post a new patch on that later, we're looking forward your comments
on it :)

Regards,
Michael Wang

> 
> 	https://lkml.org/lkml/2014/5/16/4
> 
> Please note that our comparison was based on the same workload, the only
> difference is we put the workload one level deeper, and dbench could only
> got 1/3 of the CPU% it used to have, the throughput dropped to half.
> 
> The dbench got less CPU since all it's instances start to gathering on the
> same CPU more often than before, and in such cases, whatever how big their
> share is, only one CPU they could occupy.
> 
> This is caused by that when dbench is in deep-group, the balance between
> it's gathering speed (depends on wake-affine) and spreading speed (depends
> on load-balance) was broken, that is more gathering chances while less
> spreading chances.
> 
> Since after put dbench into deep group, it's representive load in root-group
> become less, which make it harder to break the load balance of system, this
> is a comparison between dbench root-load and system-tasks (besides dbench)
> load, for eg:
> 
> 	sg0					sg1
> 	cpu0		cpu1			cpu2		cpu3
> 
> 	kworker/0:0	kworker/1:0		kworker/2:0	kworker/3:0
> 	kworker/0:1	kworker/1:1		kworker/2:1	kworker/3:1
> 	dbench
> 	dbench
> 	dbench
> 	dbench
> 	dbench
> 	dbench
> 
> Here without dbench, the load between sg is already balanced, which is:
> 
> 	4096:4096
> 
> When dbench is in one of the three cpu-cgroups on level 1, it's root-load
> is 1024/6, so we have:
> 
> 	sg0
> 		4096 + 6 * (1024 / 6)
> 	sg1
> 		4096
> 
> 	sg0 : sg1 == 5120 : 4096 == 125%
> 
> 	bigger than imbalance-pct (117% for eg), dbench spread to sg1
> 
> 
> When dbench is in one of the three cpu-cgroups on level 2, it's root-load
> is 1024/18, now we have:
> 
> 	sg0
> 		4096 + 6 * (1024 / 18)
> 	sg1
> 		4096
> 
> 	sg0 : sg1 ~= 4437 : 4096 ~= 108%
> 
> 	smaller than imbalance-pct (same the 117%), dbench keep gathering in sg0
> 
> Thus load-balance routine become inactively on spreading dbench to other CPU,
> and it's routine keep gathering on CPU more longer than before.
> 
> This patch try to select 'idle' cfs_rq inside task's cpu-group when there is no
> idle CPU located by select_idle_sibling(), instead of return the 'target'
> arbitrarily, this recheck help us to reserve the effect of load-balance longer,
> and help to make the system more balance.
> 
> Like in the example above, the fix now will make things as:
> 	1. dbench instances will be 'balanced' inside tg, ideally each cpu will
> 	   have one instance.
> 	2. if 1 do make the load become imbalance, load-balance routine will do
> 	   it's job and move instances to proper CPU.
> 	3. after 2 was done, the target CPU will always be preferred as long as
> 	   it only got one instance.
> 
> Although for tasks like dbench, 2 is rarely happened, while combined with 3, we
> will finally locate a good CPU for each instance which make both internal and
> external balanced.
> 
> After applied this patch, the behaviour of dbench in deep cpu-group become
> normal, the dbench throughput was back.
> 
> Tested benchmarks like ebizzy, kbench, dbench on X86 12-CPU server, the patch
> works well and no regression showup.
> 
> Highlight:
> 	With out a fix, any similar workload like dbench will face the same
> 	issue that the cpu-cgroup share lost it's effect
> 
> 	This may not just be an issue of cgroup, whenever we have tasks which
> 	with small-load, play quick flip on each other, they may gathering.
> 
> Please let me know if you have any questions on whatever the issue or the fix,
> comments are welcomed ;-)
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fea7d33..e1381cd 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4409,6 +4409,62 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  	return idlest;
>  }
>  
> +static inline int tg_idle_cpu(struct task_group *tg, int cpu)
> +{
> +	return !tg->cfs_rq[cpu]->nr_running;
> +}
> +
> +/*
> + * Try and locate an idle CPU in the sched_domain from tg's view.
> + *
> + * Although gathered on same CPU and spread accross CPUs could make
> + * no difference from highest group's view, this will cause the tasks
> + * starving, even they have enough share to fight for CPU, they only
> + * got one battle filed, which means whatever how big their weight is,
> + * they totally got one CPU at maximum.
> + *
> + * Thus when system is busy, we filtered out those tasks which couldn't
> + * gain help from balance routine, and try to balance them internally
> + * by this func, so they could stand a chance to show their power.
> + *
> + */
> +static int tg_idle_sibling(struct task_struct *p, int target)
> +{
> +	struct sched_domain *sd;
> +	struct sched_group *sg;
> +	int i = task_cpu(p);
> +	struct task_group *tg = task_group(p);
> +
> +	if (tg_idle_cpu(tg, target))
> +		goto done;
> +
> +	sd = rcu_dereference(per_cpu(sd_llc, target));
> +	for_each_lower_domain(sd) {
> +		sg = sd->groups;
> +		do {
> +			if (!cpumask_intersects(sched_group_cpus(sg),
> +						tsk_cpus_allowed(p)))
> +				goto next;
> +
> +			for_each_cpu(i, sched_group_cpus(sg)) {
> +				if (i == target || !tg_idle_cpu(tg, i))
> +					goto next;
> +			}
> +
> +			target = cpumask_first_and(sched_group_cpus(sg),
> +					tsk_cpus_allowed(p));
> +
> +			goto done;
> +next:
> +			sg = sg->next;
> +		} while (sg != sd->groups);
> +	}
> +
> +done:
> +
> +	return target;
> +}
> +
>  /*
>   * Try and locate an idle CPU in the sched_domain.
>   */
> @@ -4417,6 +4473,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  	struct sched_domain *sd;
>  	struct sched_group *sg;
>  	int i = task_cpu(p);
> +	struct sched_entity *se = task_group(p)->se[i];
>  
>  	if (idle_cpu(target))
>  		return target;
> @@ -4451,6 +4508,30 @@ next:
>  		} while (sg != sd->groups);
>  	}
>  done:
> +
> +	if (!idle_cpu(target)) {
> +		/*
> +		 * No idle cpu located imply the system is somewhat busy,
> +		 * usually we count on load balance routine's help and
> +		 * just pick the target whatever how busy it is.
> +		 *
> +		 * However, when task belong to a deep group (harder to
> +		 * make root imbalance) and flip frequently (harder to be
> +		 * caught during balance), load balance routine could help
> +		 * nothing, and these tasks will eventually gathered on same
> +		 * cpu when they wakeup each other, that is the chance of
> +		 * gathered stand far more higher than the chance of spread.
> +		 *
> +		 * Thus for such tasks, we need to handle them carefully
> +		 * during wakeup, since it's the very rarely chance for
> +		 * them to spread.
> +		 *
> +		 */
> +		if (se && se->depth &&
> +				p->wakee_flips > this_cpu_read(sd_llc_size))
> +			return tg_idle_sibling(p, target);
> +	}
> +
>  	return target;
>  }
>  
> 

