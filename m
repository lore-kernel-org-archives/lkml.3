Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3GBMJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:09:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53047 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3GBMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:09:04 -0400
Date: Tue, 2 Jul 2013 17:36:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130702120655.GA2959@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1372257487-9749-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070212-2876-0000-0000-00000A74841C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A preferred node is selected based on the node the most NUMA hinting
> faults was incurred on. There is no guarantee that the task is running
> on that node at the time so this patch rescheules the task to run on
> the most idle CPU of the selected node when selected. This avoids
> waiting for the balancer to make a decision.
> 

Should we be making this decisions just on the numa hinting faults alone? 

How are we making sure that the preferred node selection is persistent?
i.e due to memory accesses patterns, what if the preferred node
selection keeps moving.

If a large process having several threads were to allocate memory in one
node, then all threads will try to mark that node as their preferred
node. Till they get a chance those tasks will move pages over to the
local node. But if they get a chance to move to their preferred node
before moving enough number of pages, then it would have to fetch back
all the pages.

Can we look at using accumulating process weights and using the process
weights to consolidate tasks to one node?

> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  kernel/sched/core.c  | 18 +++++++++++++++--
>  kernel/sched/fair.c  | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/sched/sched.h |  2 +-
>  3 files changed, 70 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ba9470e..b4722d6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5717,11 +5717,25 @@ struct sched_domain_topology_level;
>  
>  #ifdef CONFIG_NUMA_BALANCING
>  
> -/* Set a tasks preferred NUMA node */
> -void sched_setnuma(struct task_struct *p, int nid)
> +/* Set a tasks preferred NUMA node and reschedule to it */
> +void sched_setnuma(struct task_struct *p, int nid, int idlest_cpu)
>  {
> +	int curr_cpu = task_cpu(p);
> +	struct migration_arg arg = { p, idlest_cpu };
> +
>  	p->numa_preferred_nid = nid;
>  	p->numa_migrate_seq = 0;
> +
> +	/* Do not reschedule if already running on the target CPU */
> +	if (idlest_cpu == curr_cpu)
> +		return;
> +
> +	/* Ensure the target CPU is eligible */
> +	if (!cpumask_test_cpu(idlest_cpu, tsk_cpus_allowed(p)))
> +		return;
> +
> +	/* Move current running task to idlest CPU on preferred node */
> +	stop_one_cpu(curr_cpu, migration_cpu_stop, &arg);

Here, moving tasks this way doesnt update the schedstats at all.
So task migrations from perf stat and schedstats dont match.
I know migration_cpu_stop was used this way before, but we are making
schedstats more unreliable. Also I dont think migration_cpu_stop was
used all that much. But now it gets used pretty persistently.
Probably we need to make migration_cpu_stop schedstats aware.

migration_cpu_stop has the other drawback that it doesnt check for
cpu_throttling. So we might move a task from the present cpu to a
different cpu and task might end up being throttled instead of being
run.

>  }
>  #endif /* CONFIG_NUMA_BALANCING */
>  
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5e7f728..99951a8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -800,6 +800,39 @@ unsigned int sysctl_numa_balancing_scan_delay = 1000;
>   */
>  unsigned int sysctl_numa_balancing_settle_count __read_mostly = 3;
>  
> +static unsigned long weighted_cpuload(const int cpu);
> +
> +static int
> +find_idlest_cpu_node(int this_cpu, int nid)
> +{
> +	unsigned long load, min_load = ULONG_MAX;
> +	int i, idlest_cpu = this_cpu;
> +
> +	BUG_ON(cpu_to_node(this_cpu) == nid);
> +
> +	for_each_cpu(i, cpumask_of_node(nid)) {
> +		load = weighted_cpuload(i);
> +
> +		if (load < min_load) {
> +			struct task_struct *p;
> +
> +			/* Do not preempt a task running on its preferred node */
> +			struct rq *rq = cpu_rq(i);
> +			local_irq_disable();
> +			raw_spin_lock(&rq->lock);
> +			p = rq->curr;
> +			if (p->numa_preferred_nid != nid) {
> +				min_load = load;
> +				idlest_cpu = i;
> +			}
> +			raw_spin_unlock(&rq->lock);
> +			local_irq_disable();
> +		}
> +	}
> +
> +	return idlest_cpu;

Here we are not checking the preferred node is already loaded. If the
preferred node is already loaded than the current local node, (either
because of task pinning, cpuset configurations,) pushing task to that
node might only end up with the task being pulled back in the next
balancing cycle.

-- 
Thanks and Regards
Srikar

