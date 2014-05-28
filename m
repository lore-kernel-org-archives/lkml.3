Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaE1XpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:45:09 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:45834 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbaE1XpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:45:07 -0400
Date: Wed, 28 May 2014 18:45:04 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v3)
In-Reply-To: <20140528224324.GA1132@amt.cnet>
Message-ID: <alpine.DEB.2.10.1405281838370.6096@gentwo.org>
References: <20140523193706.GA22854@amt.cnet> <20140526185344.GA19976@amt.cnet> <53858A06.8080507@huawei.com> <20140528224324.GA1132@amt.cnet>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Marcelo Tosatti wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5dba293..dfea3dc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2698,6 +2698,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  	unsigned int cpuset_mems_cookie;
>  	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
>  	struct mem_cgroup *memcg = NULL;
> +	nodemask_t *cpuset_mems_allowed = &cpuset_current_mems_allowed;

Why do you need this one?

>  	gfp_mask &= gfp_allowed_mask;
>
> @@ -2726,9 +2727,14 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  retry_cpuset:
>  	cpuset_mems_cookie = read_mems_allowed_begin();
>
> +#ifdef CONFIG_NUMA
> +	if (gfp_zone(gfp_mask) < policy_zone)
> +		cpuset_mems_allowed = NULL;

nodemask = &node_states[N_ONLINE];

> +#endif


> +
>  	/* The preferred zone is used for statistics later */
>  	first_zones_zonelist(zonelist, high_zoneidx,
> -				nodemask ? : &cpuset_current_mems_allowed,
> +				nodemask ? : cpuset_mems_allowed,

Skip this?

>  				&preferred_zone);
>  	if (!preferred_zone)
>  		goto out;
>

Why call __alloc_pages_nodemask at all if you want to skip the node
handling? Punt to alloc_pages()
