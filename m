Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaLPHp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:45:28 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:7120 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751124AbaLPHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:45:27 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45248678"
Message-ID: <548FE40D.5080400@cn.fujitsu.com>
Date: Tue, 16 Dec 2014 15:49:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 3/4] workqueue: Update workqueue's possible cpumask when
 a new node, coming up.
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com> <548EC1E2.1010101@jp.fujitsu.com> <548EC36C.5040402@jp.fujitsu.com>
In-Reply-To: <548EC36C.5040402@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 07:18 PM, Kamezawa Hiroyuki wrote:
> Workqueue keeps cpu<->node relationship including all possible cpus.
> The original information was made at boot but it may change when
> a new node is added.
> 
> Update information if a new node is ready with using node-hotplug callback.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/memory_hotplug.h |  2 ++
>  kernel/workqueue.c             | 28 +++++++++++++++++++++++++++-
>  mm/memory_hotplug.c            |  4 ++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 8f1a419..cd3cb67 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -270,4 +270,6 @@ extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
>  extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
>  					  unsigned long pnum);
>  
> +/* update for workqueues */
> +void workqueue_node_register(int node);
>  #endif /* __LINUX_MEMORY_HOTPLUG_H */
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 2fd0bd7..5499b76 100644
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
> @@ -4559,6 +4559,32 @@ static void restore_unbound_workers_cpumask(struct worker_pool *pool, int cpu)
>  		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
>  						  pool->attrs->cpumask) < 0);
>  }
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +
> +static void reflesh_wq_possible_mask(int cpu, int node)
> +{
> +	int oldnode;
> +	for_each_node_state(oldnode, N_POSSIBLE)
> +		cpumask_clear_cpu(cpu, wq_numa_possible_cpumask[oldnode]);

You need to check and update all the wq->numa_pwq_tbl[oldnode]

> +	cpumask_set_cpu(cpu, wq_numa_possible_cpumask[node]);
> +}
> +/*
> + * When a cpu is physically added, cpu<->node relationship is established.
> + * We can catch the whole view when a new NODE_DATA() coming up.
> + * Update cpumask used for sched affinity of workers.
> + */
> +void workqueue_node_register(int node)
> +{
> +	int cpu;
> +	mutex_lock(&wq_pool_mutex);
> +	for_each_possible_cpu(cpu) {
> +		if (node == cpu_to_node(cpu))
> +			reflesh_wq_possible_mask(cpu, node);
> +	}
> +	mutex_unlock(&wq_pool_mutex);
> +}
> +
> +#endif
>  
>  /*
>   * Workqueues should be brought up before normal priority CPU notifiers.
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 1bf4807..d0c1ebb 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1121,6 +1121,10 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
>  	 * online_pages() and offline_pages().
>  	 */
>  	reset_node_present_pages(pgdat);
> +	/*
> +	 * Update workqueue's cpu/node affinity info.
> +	 */
> +	workqueue_node_register(nid);
>  
>  	return pgdat;
>  }

