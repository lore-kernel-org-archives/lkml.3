Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaLRCS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:18:28 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:24672 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751452AbaLRCS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:18:26 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45388869"
Message-ID: <54923A63.3010701@cn.fujitsu.com>
Date: Thu, 18 Dec 2014 10:22:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/5] workqueue: update wq_numa_possible_cpumask
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <1418379595-6281-3-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1418379595-6281-3-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 06:19 PM, Lai Jiangshan wrote:
> Yasuaki Ishimatsu hit a allocation failure bug when the numa mapping
> between CPU and node is changed. This was the last scene:
>  SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
>   cache: kmalloc-192, object size: 192, buffer size: 192, default order: 1, min order: 0
>   node 0: slabs: 6172, objs: 259224, free: 245741
>   node 1: slabs: 3261, objs: 136962, free: 127656
> 
> Yasuaki Ishimatsu investigated that it happened in the following situation:
> 
> 1) System Node/CPU before offline/online:
> 	       | CPU
> 	------------------------
> 	node 0 |  0-14, 60-74
> 	node 1 | 15-29, 75-89
> 	node 2 | 30-44, 90-104
> 	node 3 | 45-59, 105-119
> 
> 2) A system-board (contains node2 and node3) is offline:
> 	       | CPU
> 	------------------------
> 	node 0 |  0-14, 60-74
> 	node 1 | 15-29, 75-89
> 
> 3) A new system-board is online, two new node IDs are allocated
>    for the two node of the SB, but the old CPU IDs are allocated for
>    the SB, here the NUMA mapping between node and CPU is changed.
>    (the node of CPU#30 is changed from node#2 to node#4, for example)
> 	       | CPU
> 	------------------------
> 	node 0 |  0-14, 60-74
> 	node 1 | 15-29, 75-89
> 	node 4 | 30-59
> 	node 5 | 90-119
> 
> 4) now, the NUMA mapping is changed, but wq_numa_possible_cpumask
>    which is the convenient NUMA mapping cache in workqueue.c is still outdated.
>    thus pool->node calculated by get_unbound_pool() is incorrect.
> 
> 5) when the create_worker() is called with the incorrect offlined
>     pool->node, it is failed and the pool can't make any progress.
> 
> To fix this bug, we need to fixup the wq_numa_possible_cpumask and the
> pool->node, the fix is so complicated that we split it into two patches,
> this patch fix the wq_numa_possible_cpumask and the next fix the pool->node.
> 
> To fix the wq_numa_possible_cpumask, we only update the cpumasks of
> the orig_node and the new_node of the onlining @cpu.  we con't touch
> other unrelated nodes since the wq subsystem haven't seen the changed.
> 
> After this fix the new pool->node of new pools are correct.
> and existing wq's affinity is fixed up by wq_update_unbound_numa()
> after wq_update_numa_mapping().
> 
> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
> Cc: tangchen <tangchen@cn.fujitsu.com>
> Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   42 +++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 41 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index a6fd2b8..4c88b61 100644
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
> @@ -3949,6 +3949,44 @@ out_unlock:
>  	put_pwq_unlocked(old_pwq);
>  }
>  
> +static void wq_update_numa_mapping(int cpu)
> +{
> +	int node, orig_node = NUMA_NO_NODE, new_node = cpu_to_node(cpu);
> +
> +	lockdep_assert_held(&wq_pool_mutex);
> +
> +	if (!wq_numa_enabled)
> +		return;
> +
> +	/* the node of onlining CPU is not NUMA_NO_NODE */
> +	if (WARN_ON(new_node == NUMA_NO_NODE))
> +		return;
> +
> +	/* test whether the NUMA node mapping is changed. */
> +	if (cpumask_test_cpu(cpu, wq_numa_possible_cpumask[new_node]))
> +		return;
> +
> +	/* find the origin node */
> +	for_each_node(node) {
> +		if (cpumask_test_cpu(cpu, wq_numa_possible_cpumask[node])) {
> +			orig_node = node;
> +			break;
> +		}
> +	}
> +
> +	/* there may be multi mappings changed, re-initial. */
> +	cpumask_clear(wq_numa_possible_cpumask[new_node]);
> +	if (orig_node != NUMA_NO_NODE)
> +		cpumask_clear(wq_numa_possible_cpumask[orig_node]);
> +	for_each_possible_cpu(cpu) {
> +		node = cpu_to_node(node);

Hi, Yasuaki Ishimatsu

The bug is here.  It should be
		node = cpu_to_node(cpu);

> +		if (node == new_node)
> +			cpumask_set_cpu(cpu, wq_numa_possible_cpumask[new_node]);
> +		else if (orig_node != NUMA_NO_NODE && node == orig_node)
> +			cpumask_set_cpu(cpu, wq_numa_possible_cpumask[orig_node]);
> +	}
> +}
> +
>  static int alloc_and_link_pwqs(struct workqueue_struct *wq)
>  {
>  	bool highpri = wq->flags & WQ_HIGHPRI;
> @@ -4584,6 +4622,8 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
>  			mutex_unlock(&pool->attach_mutex);
>  		}
>  
> +		wq_update_numa_mapping(cpu);
> +
>  		/* update NUMA affinity of unbound workqueues */
>  		list_for_each_entry(wq, &workqueues, list)
>  			wq_update_unbound_numa(wq, cpu, true);

