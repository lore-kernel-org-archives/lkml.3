Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941AbaLPF0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:26:41 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:30584 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820AbaLPF0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:26:39 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45241019"
Message-ID: <548FC378.6060809@cn.fujitsu.com>
Date: Tue, 16 Dec 2014 13:30:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 1/4] workqueue:Fix unbound workqueue's node affinity detection
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com> <548EC1E2.1010101@jp.fujitsu.com> <548EC29A.5080008@jp.fujitsu.com>
In-Reply-To: <548EC29A.5080008@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 07:14 PM, Kamezawa Hiroyuki wrote:
> Unbound wq pool's node attribute is calculated at its allocation.
> But it's now calculated based on possible cpu<->node information
> which can be wrong after cpu hotplug/unplug.
> 
> If wrong pool->node is set, following allocation error will happen.
> ==
>  SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
>   cache: kmalloc-192, object size: 192, buffer size: 192, default order:
> 1, min order: 0
>   node 0: slabs: 6172, objs: 259224, free: 245741
>   node 1: slabs: 3261, objs: 136962, free: 127656
> ==
> 
> This patch fixes the node detection by making use of online cpu info.
> Unlike cpumask, the best node can be calculated by degree of overlap
> between attr->cpumask and numanode->online_cpumask.
> This change doesn't corrupt original purpose of the old calculation.
> 
> Note: it's expected that this function is called as
>       pool_detect_best_node
>       get_unbound_pool
>       alloc_unbound_pwq
>       wq_update_unbound_numa
>       called at CPU_ONLINE/CPU_DOWN_PREPARE
> and the latest online cpu info can be applied to a new wq pool,
> which replaces old one.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  kernel/workqueue.c | 38 ++++++++++++++++++++++++++------------
>  1 file changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 09b685d..7809154 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3440,6 +3440,31 @@ static void put_unbound_pool(struct worker_pool *pool)
>  }
>  
>  /**
> + * pool_detect_best_node - detect a node which contains specified cpumask.
> + * Should be called with wq_pool_mutex held.
> + * Returns a online node where the most of given cpus are tied to. 
> + */
> +static int pool_detect_best_node(const struct cpumask *cpumask)
> +{
> +	int node, best, match, selected = NUMA_NO_NODE;
> +	static struct cpumask andmask; /* under wq_pool_mutex */
> +
> +	if (!wq_numa_enabled ||
> +		cpumask_subset(cpu_online_mask, cpumask))
> +		goto out;
> +	best = 0;
> +	/* select a node which contains the most number of cpu */
> +	for_each_node_state(node, N_ONLINE) {
> +		cpumask_and(&andmask, cpumask, cpumask_of_node(node));
> +		match = cpumask_weight(&andmask);
> +		if (match > best)
> +			selected = best;
> +	}
> +out:
> +	return selected;
> +}


This is a mixture of fix and development.  Why not just keep the original calculation?

if the mask cover multiple nodes, NUMA_NO_NODE is the best for pool->node
after the pool was created. The memory allocation will select the best node
for manage_workers(), from which CPU that the worker actually is running on.

> +
> +/**
>   * get_unbound_pool - get a worker_pool with the specified attributes
>   * @attrs: the attributes of the worker_pool to get
>   *
> @@ -3457,7 +3482,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
>  {
>  	u32 hash = wqattrs_hash(attrs);
>  	struct worker_pool *pool;
> -	int node;
>  
>  	lockdep_assert_held(&wq_pool_mutex);
>  
> @@ -3482,17 +3506,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
>  	 * 'struct workqueue_attrs' comments for detail.
>  	 */
>  	pool->attrs->no_numa = false;
> -
> -	/* if cpumask is contained inside a NUMA node, we belong to that node */
> -	if (wq_numa_enabled) {
> -		for_each_node(node) {
> -			if (cpumask_subset(pool->attrs->cpumask,
> -					   wq_numa_possible_cpumask[node])) {
> -				pool->node = node;
> -				break;
> -			}
> -		}
> -	}
> +	pool->node = pool_detect_best_node(pool->attrs->cpumask);
>  
>  	if (worker_pool_assign_id(pool) < 0)
>  		goto fail;

