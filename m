Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaBSRSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:18:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40085 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbaBSRSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:18:50 -0500
Date: Wed, 19 Feb 2014 09:16:28 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm: exclude memory less nodes from zone_reclaim
Message-ID: <20140219171628.GE27108@linux.vnet.ibm.com>
References: <20140219082313.GB14783@dhcp22.suse.cz>
 <1392829383-4125-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392829383-4125-1-git-send-email-mhocko@suse.cz>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021917-7182-0000-0000-000009DEC79E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.02.2014 [18:03:03 +0100], Michal Hocko wrote:
> We had a report about strange OOM killer strikes on a PPC machine
> although there was a lot of swap free and a tons of anonymous memory
> which could be swapped out. In the end it turned out that the OOM was
> a side effect of zone reclaim which wasn't doesn't unmap and swapp out
> and so the system was pushed to the OOM. Although this sounds like a bug
> somewhere in the kswapd vs. zone reclaim vs. direct reclaim interaction
> numactl on the said hardware suggests that the zone reclaim should
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
> make any sense on the memory less nodes. So let's exlcude such nodes
> for init_zone_allows_reclaim which evaluates zone reclaim behavior and
> suitable reclaim_nodes.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
> I haven't got to testing this so I am sending this as an RFC for now.
> But does this look reasonable?
> 
>  mm/page_alloc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3e953f07edb0..4a44bdc7a8cf 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1855,7 +1855,7 @@ static void __paginginit init_zone_allows_reclaim(int nid)
>  {
>  	int i;
> 
> -	for_each_online_node(i)
> +	for_each_node_state(i, N_HIGH_MEMORY)
>  		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
>  			node_set(i, NODE_DATA(nid)->reclaim_nodes);
>  		else
> @@ -4901,7 +4901,8 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
> 
>  	pgdat->node_id = nid;
>  	pgdat->node_start_pfn = node_start_pfn;
> -	init_zone_allows_reclaim(nid);
> +	if (node_state(nid, N_HIGH_MEMORY))
> +		init_zone_allows_reclaim(nid);

I don't think this will work, because what sets N_HIGH_MEMORY (and
shouldn't it be N_MEMORY?) is check_for_memory() (free_area_init_nodes()
for N_MEMORY), which is run *after* init_zone_allows_reclaim(). Further,
the for_each_node_state() loop doesn't make sense at this point, becuase
we are actually setting up the nids as we go. So node 0, will only see
node 0 in the N_HIGH_MEMORY mask (if any). Node 1, will only see nodes 0
and 1, etc.

I'm working on testing a patch that reorders some of this in hopefully a
safe way.

Thanks,
Nish

>  #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>  	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
>  #endif
> -- 
> 1.9.0.rc3
> 

