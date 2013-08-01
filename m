Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab3HAHK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:10:26 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53160 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3HAHKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:10:23 -0400
Date: Thu, 1 Aug 2013 12:40:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] sched: Avoid overloading CPUs on a preferred NUMA
 node
Message-ID: <20130801071013.GG4880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-17-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1373901620-2021-17-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080107-3620-0000-0000-000003C5F9E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int task_numa_find_cpu(struct task_struct *p, int nid)
> +{
> +	int node_cpu = cpumask_first(cpumask_of_node(nid));
> +	int cpu, src_cpu = task_cpu(p), dst_cpu = src_cpu;
> +	unsigned long src_load, dst_load;
> +	unsigned long min_load = ULONG_MAX;
> +	struct task_group *tg = task_group(p);
> +	s64 src_eff_load, dst_eff_load;
> +	struct sched_domain *sd;
> +	unsigned long weight;
> +	bool balanced;
> +	int imbalance_pct, idx = -1;
> 
> +	/* No harm being optimistic */
> +	if (idle_cpu(node_cpu))
> +		return node_cpu;

Cant this lead to lot of imbalance across nodes? Wont this lead to lot
of ping-pong of tasks between different nodes resulting in performance
hit? Lets say the system is not fully loaded, something like a numa01
but with far lesser number of threads probably nr_cpus/2 or nr_cpus/4,
then all threads will try to move to single node as we can keep seeing
idle threads. No? Wont it lead all load moving to one node and load
balancer spreading it out...

> 
> -static int
> -find_idlest_cpu_node(int this_cpu, int nid)
> -{
> -	unsigned long load, min_load = ULONG_MAX;
> -	int i, idlest_cpu = this_cpu;
> +	/*
> +	 * Find the lowest common scheduling domain covering the nodes of both
> +	 * the CPU the task is currently running on and the target NUMA node.
> +	 */
> +	rcu_read_lock();
> +	for_each_domain(src_cpu, sd) {
> +		if (cpumask_test_cpu(node_cpu, sched_domain_span(sd))) {
> +			/*
> +			 * busy_idx is used for the load decision as it is the
> +			 * same index used by the regular load balancer for an
> +			 * active cpu.
> +			 */
> +			idx = sd->busy_idx;
> +			imbalance_pct = sd->imbalance_pct;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> 
> -	BUG_ON(cpu_to_node(this_cpu) == nid);
> +	if (WARN_ON_ONCE(idx == -1))
> +		return src_cpu;
> 
> -	rcu_read_lock();
> -	for_each_cpu(i, cpumask_of_node(nid)) {
> -		load = weighted_cpuload(i);
> +	/*
> +	 * XXX the below is mostly nicked from wake_affine(); we should
> +	 * see about sharing a bit if at all possible; also it might want
> +	 * some per entity weight love.
> +	 */
> +	weight = p->se.load.weight;
> 
> -		if (load < min_load) {
> -			min_load = load;
> -			idlest_cpu = i;
> +	src_load = source_load(src_cpu, idx);
> +
> +	src_eff_load = 100 + (imbalance_pct - 100) / 2;
> +	src_eff_load *= power_of(src_cpu);
> +	src_eff_load *= src_load + effective_load(tg, src_cpu, -weight, -weight);
> +
> +	for_each_cpu(cpu, cpumask_of_node(nid)) {
> +		dst_load = target_load(cpu, idx);
> +
> +		/* If the CPU is idle, use it */
> +		if (!dst_load)
> +			return dst_cpu;
> +
> +		/* Otherwise check the target CPU load */
> +		dst_eff_load = 100;
> +		dst_eff_load *= power_of(cpu);
> +		dst_eff_load *= dst_load + effective_load(tg, cpu, weight, weight);
> +
> +		/*
> +		 * Destination is considered balanced if the destination CPU is
> +		 * less loaded than the source CPU. Unfortunately there is a
> +		 * risk that a task running on a lightly loaded CPU will not
> +		 * migrate to its preferred node due to load imbalances.
> +		 */
> +		balanced = (dst_eff_load <= src_eff_load);
> +		if (!balanced)
> +			continue;
> +

Okay same case as above, the cpu could be lightly loaded, but the
destination node could be heavier than the source node. No?

> +		if (dst_load < min_load) {
> +			min_load = dst_load;
> +			dst_cpu = cpu;
>  		}
>  	}
> -	rcu_read_unlock();
> 
> -	return idlest_cpu;
> +	return dst_cpu;
>  }
> 

-- 
Thanks and Regards
Srikar Dronamraju

