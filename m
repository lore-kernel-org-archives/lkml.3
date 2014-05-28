Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaE1HC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:02:57 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:15377 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaE1HCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:02:55 -0400
Message-ID: <53858A06.8080507@huawei.com>
Date: Wed, 28 May 2014 15:02:30 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone allocations
 (v2)
References: <20140523193706.GA22854@amt.cnet> <20140526185344.GA19976@amt.cnet>
In-Reply-To: <20140526185344.GA19976@amt.cnet>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/27 2:53, Marcelo Tosatti wrote:
> 
> Zone specific allocations, such as GFP_DMA32, should not be restricted
> to cpusets allowed node list: the zones which such allocations demand
> might be contained in particular nodes outside the cpuset node list.
> 
> The alternative would be to not perform such allocations from
> applications which are cpuset restricted, which is unrealistic.
> 
> Fixes KVM's alloc_page(gfp_mask=GFP_DMA32) with cpuset as explained.
> 

Could you add the use case that you described in a previous email to
the changelog?

> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> v2: fix slowpath as well (David Rientjes)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 3d54c41..b70a336 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2392,6 +2392,10 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
>  

Add a comment accordingly?

	 *      in_interrupt - any node ok (current task context irrelevant)
	 *      GFP_ATOMIC   - any node ok
	 *      TIF_MEMDIE   - any node ok
	 *      GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
	 *      GFP_USER     - only nodes in current tasks mems allowed ok.

>  	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
>  		return 1;
> +#ifdef CONFIG_NUMA
> +	if (gfp_zone(gfp_mask) < policy_zone)
> +		return 1;
> +#endif
>  	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
>  	if (node_isset(node, current->mems_allowed))
>  		return 1;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5dba293..dfea3dc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2698,6 +2698,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  	unsigned int cpuset_mems_cookie;
>  	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
>  	struct mem_cgroup *memcg = NULL;
> +	nodemask_t *cpuset_mems_allowed = &cpuset_current_mems_allowed;
>  
>  	gfp_mask &= gfp_allowed_mask;
>  
> @@ -2726,9 +2727,14 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  retry_cpuset:
>  	cpuset_mems_cookie = read_mems_allowed_begin();
>  
> +#ifdef CONFIG_NUMA
> +	if (gfp_zone(gfp_mask) < policy_zone)
> +		cpuset_mems_allowed = NULL;
> +#endif
> +
>  	/* The preferred zone is used for statistics later */
>  	first_zones_zonelist(zonelist, high_zoneidx,
> -				nodemask ? : &cpuset_current_mems_allowed,
> +				nodemask ? : cpuset_mems_allowed,
>  				&preferred_zone);
>  	if (!preferred_zone)
>  		goto out;
> .
> 

