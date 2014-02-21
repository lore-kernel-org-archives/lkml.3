Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbaBUPE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:04:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbaBUPEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:04:55 -0500
Date: Fri, 21 Feb 2014 16:04:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: exclude memory less nodes from zone_reclaim
Message-ID: <20140221150455.GA27184@dhcp22.suse.cz>
References: <1392889904-18019-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392889904-18019-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-02-14 10:51:44, Michal Hocko wrote:
> We had a report about strange OOM killer strikes on a PPC machine
> although there was a lot of swap free and a tons of anonymous memory
> which could be swapped out. In the end it turned out that the OOM was
> a side effect of zone reclaim which wasn't doesn't unmap and swapp out
> and so the system was pushed to the OOM. Although this sounds like a bug
> somewhere in the kswapd vs. zone reclaim vs. direct reclaim interaction
> numactl on the said hardware suggests that the zone reclaim should

Hmm, not somehow got lost... It should read "suggests that the zone
reclaim should not have been set in the first place"

> have been set in the first place:
> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> node 0 size: 0 MB
> node 0 free: 0 MB
> node 2 cpus:
> node 2 size: 7168 MB
> node 2 free: 6019 MB
> node distances:
> node   0   2
> 0:  10  40
> 2:  40  10
> 
> So all the CPUs are associated with Node0 which doesn't have any memory
> while Node2 contains all the available memory. Node distances cause an
> automatic zone_reclaim_mode enabling.
> 
> Zone reclaim is intended to keep the allocations local but this doesn't
> make any sense on the memory less nodes. So let's exclude such nodes
> for init_zone_allows_reclaim which evaluates zone reclaim behavior and
> suitable reclaim_nodes.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> Tested-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> ---
>  mm/page_alloc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e953f07edb0..fafb9e24e87f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1855,7 +1855,7 @@ static void __paginginit init_zone_allows_reclaim(int nid)
>  {
>  	int i;
>  
> -	for_each_online_node(i)
> +	for_each_node_state(i, N_MEMORY)
>  		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
>  			node_set(i, NODE_DATA(nid)->reclaim_nodes);
>  		else
> @@ -4901,7 +4901,8 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
>  
>  	pgdat->node_id = nid;
>  	pgdat->node_start_pfn = node_start_pfn;
> -	init_zone_allows_reclaim(nid);
> +	if (node_state(nid, N_MEMORY))
> +		init_zone_allows_reclaim(nid);
>  #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>  	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
>  #endif
> -- 
> 1.9.0.rc3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
