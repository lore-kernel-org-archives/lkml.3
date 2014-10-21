Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaJUPhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:37:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbaJUPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:37:44 -0400
Date: Tue, 21 Oct 2014 17:37:41 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: remove mem_cgroup_reclaimable check from soft
 reclaim
Message-ID: <20141021153741.GI9415@dhcp22.suse.cz>
References: <1413897350-32553-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413897350-32553-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-10-14 17:15:50, Vladimir Davydov wrote:
> mem_cgroup_reclaimable() checks whether a cgroup has reclaimable pages
> on *any* NUMA node. However, the only place where it's called is
> mem_cgroup_soft_reclaim(), which tries to reclaim memory from a
> *specific* zone. So the way how it's used is incorrect - it will return
> true even if the cgroup doesn't have pages on the zone we're scanning.
> 
> I think we can get rid of this check completely, because
> mem_cgroup_shrink_node_zone(), which is called by
> mem_cgroup_soft_reclaim() if mem_cgroup_reclaimable() returns true, is
> equivalent to shrink_lruvec(), which exits almost immediately if the
> lruvec passed to it is empty. So there's no need to optimize anything
> here. Besides, we don't have such a check in the general scan path
> (shrink_zone) either.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

yeah, let's ditch it. It doesn't make any sense without checking the
target zone and even then it is dubious bevause get_scan_count will give
us 0 target on an empty lru list.

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks

> ---
>  mm/memcontrol.c |   43 -------------------------------------------
>  1 file changed, 43 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 53393e27ff03..833b6a696aab 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1799,52 +1799,11 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
>  	memcg->last_scanned_node = node;
>  	return node;
>  }
> -
> -/*
> - * Check all nodes whether it contains reclaimable pages or not.
> - * For quick scan, we make use of scan_nodes. This will allow us to skip
> - * unused nodes. But scan_nodes is lazily updated and may not cotain
> - * enough new information. We need to do double check.
> - */
> -static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
> -{
> -	int nid;
> -
> -	/*
> -	 * quick check...making use of scan_node.
> -	 * We can skip unused nodes.
> -	 */
> -	if (!nodes_empty(memcg->scan_nodes)) {
> -		for (nid = first_node(memcg->scan_nodes);
> -		     nid < MAX_NUMNODES;
> -		     nid = next_node(nid, memcg->scan_nodes)) {
> -
> -			if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
> -				return true;
> -		}
> -	}
> -	/*
> -	 * Check rest of nodes.
> -	 */
> -	for_each_node_state(nid, N_MEMORY) {
> -		if (node_isset(nid, memcg->scan_nodes))
> -			continue;
> -		if (test_mem_cgroup_node_reclaimable(memcg, nid, noswap))
> -			return true;
> -	}
> -	return false;
> -}
> -
>  #else
>  int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
>  {
>  	return 0;
>  }
> -
> -static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
> -{
> -	return test_mem_cgroup_node_reclaimable(memcg, 0, noswap);
> -}
>  #endif
>  
>  static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
> @@ -1888,8 +1847,6 @@ static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
>  			}
>  			continue;
>  		}
> -		if (!mem_cgroup_reclaimable(victim, false))
> -			continue;
>  		total += mem_cgroup_shrink_node_zone(victim, gfp_mask, false,
>  						     zone, &nr_scanned);
>  		*total_scanned += nr_scanned;
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
