Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaLQBc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:32:29 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:21929 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821AbaLQBc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:32:27 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45301306"
Message-ID: <5490DE23.9000602@cn.fujitsu.com>
Date: Wed, 17 Dec 2014 09:36:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?IklzaGltYXRzdSwgWWFzdWFraS/nn7Pmnb4g6Z2W56ugIg==?= 
	<isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: update numa affinity info at node hotplug
References: <54905F87.2030302@jp.fujitsu.com> <549061BD.3040802@jp.fujitsu.com>
In-Reply-To: <549061BD.3040802@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 12:45 AM, Kamezawa Hiroyuki wrote:
> With node online/offline, cpu<->node relationship is established.
> Workqueue uses a info which was established at boot time but
> it may be changed by node hotpluging.
> 
> Once pool->node points to a stale node, following allocation failure
> happens.
>   ==
>      SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
>       cache: kmalloc-192, object size: 192, buffer size: 192, default
> order:
>     1, min order: 0
>       node 0: slabs: 6172, objs: 259224, free: 245741
>       node 1: slabs: 3261, objs: 136962, free: 127656
>     ==
> This patch updates per cpu workqueue pool's node affinity and
> updates wq_numa_possible_cpumask at node online/offline event.
> This update of mask is very important because it affects cpumasks
> and preferred node detection.
> 
> Unbound workqueue's per node pool are updated by
> by wq_update_unbound_numa() at CPU_DOWN_PREPARE of the last cpu, by existing code.
> What important here is to avoid wrong node detection when a cpu get onlined.
> And it's handled by wq_numa_possible_cpumask update introduced by this patch.
> 
> Changelog v3->v4:
>  - added workqueue_node_unregister
>  - clear wq_numa_possible_cpumask at node offline.
>  - merged a patch which handles per cpu pools.
>  - clear per-cpu-pool's pool->node at node offlining.
>  - set per-cpu-pool's pool->node at node onlining.
>  - dropped modification to get_unbound_pool()
>  - dropped per-cpu-pool handling at cpu online/offline.
> 
> Reported-by:  Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/memory_hotplug.h |  3 +++
>  kernel/workqueue.c             | 58 +++++++++++++++++++++++++++++++++++++++++-
>  mm/memory_hotplug.c            |  6 ++++-
>  3 files changed, 65 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 8f1a419..7b4a292 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -270,4 +270,7 @@ extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
>  extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
>  					  unsigned long pnum);
>  
> +/* update for workqueues */
> +void workqueue_node_register(int node);
> +void workqueue_node_unregister(int node);
>  #endif /* __LINUX_MEMORY_HOTPLUG_H */
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 6202b08..f6ad05a 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -266,7 +266,7 @@ struct workqueue_struct {
>  static struct kmem_cache *pwq_cache;
>  
>  static cpumask_var_t *wq_numa_possible_cpumask;
> -					/* possible CPUs of each node */
> +					/* PL: possible CPUs of each node */
>  
>  static bool wq_disable_numa;
>  module_param_named(disable_numa, wq_disable_numa, bool, 0444);
> @@ -4563,6 +4563,62 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
>  		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
>  						  pool->attrs->cpumask) < 0);
>  }
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +
> +static void workqueue_update_cpu_numa_affinity(int cpu, int node)
> +{
> +	struct worker_pool *pool;
> +
> +	if (node != cpu_to_node(cpu))
> +		return;
> +	cpumask_set_cpu(cpu, wq_numa_possible_cpumask[node]);
> +	for_each_cpu_worker_pool(pool, cpu)
> +		pool->node = node;

Again, You need to check and update all the wq->numa_pwq_tbl[oldnode],
but in this patchset, the required information is lost and we can't find out oldnode.


cpus of oldnode, 16-31(online),48,56,64,72(offline,randomly assigned to the oldnode by numa_init_array())

and then cpu#48 is allocated for newnode and online

Now, the wq->numa_pwq_tbl[oldnode]'s cpumask still have cpu#48, and it may be scheduled to cpu#48.
See the information of my patch 4/5


> +}
> +
> +/*
> + * When a cpu is physically added, cpu<->node relationship is established
> + * based on firmware info. We can catch the whole view when a new NODE_DATA()
> + * coming up (a node is added).
> + * If we don't update the info, pool->node will points to a not-online node
> + * and the kernel will have allocation failure.
> + *
> + * Update wp_numa_possible_mask at online and clear it at offline.
> + */
> +void workqueue_node_register(int node)
> +{
> +	int cpu;
> +
> +	mutex_lock(&wq_pool_mutex);
> +	for_each_possible_cpu(cpu)
> +		workqueue_update_cpu_numa_affinity(cpu, node);
> +	/* unbound workqueue will be updated when the 1st cpu comes up.*/
> +	mutex_unlock(&wq_pool_mutex);
> +}
> +
> +void workqueue_node_unregister(int node)
> +{
> +	struct worker_pool *pool;
> +	int cpu;
> +
> +	mutex_lock(&wq_pool_mutex);
> +	cpumask_clear(wq_numa_possible_cpumask[node]);
> +	for_each_possible_cpu(cpu) {
> +		if (node == cpu_to_node(cpu))
> +			for_each_cpu_worker_pool(pool, cpu)
> +				pool->node = NUMA_NO_NODE;
> +	}
> +	/*
> +	 * unbound workqueue's per-node pwqs are already refleshed
> +	 * by wq_update_unbound_numa() at CPU_DOWN_PREPARE of the last cpu
> +	 * on this node, because all cpus of this node went down.
> +	 * (see wq_calc_node_cpumask()). per-node unbound pwqs has been replaced
> +	 * with wq->dfl_pwq, already.
> +	 */
> +	mutex_unlock(&wq_pool_mutex);
> +}
> +
> +#endif
>  
>  /*
>   * Workqueues should be brought up before normal priority CPU notifiers.
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 9fab107..a0cb5c1 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1122,6 +1122,9 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
>  	 */
>  	reset_node_present_pages(pgdat);
>  
> +	/* Update workqueue's numa affinity info. */
> +	workqueue_node_register(nid);
> +
>  	return pgdat;
>  }
>  
> @@ -1958,7 +1961,8 @@ void try_offline_node(int nid)
>  
>  	if (check_and_unmap_cpu_on_node(pgdat))
>  		return;
> -
> +	/* update workqueue's numa affinity info. */
> +	workqueue_node_unregister(nid);
>  	/*
>  	 * all memory/cpu of this node are removed, we can offline this
>  	 * node now.

