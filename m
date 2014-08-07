Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaHGNI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:08:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbaHGNI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:08:26 -0400
Date: Thu, 7 Aug 2014 15:08:22 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mm: memcontrol: reduce reclaim invocations for
 higher order requests
Message-ID: <20140807130822.GB12730@dhcp22.suse.cz>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
 <1407186897-21048-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407186897-21048-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 04-08-14 17:14:54, Johannes Weiner wrote:
> Instead of passing the request size to direct reclaim, memcg just
> manually loops around reclaiming SWAP_CLUSTER_MAX pages until the
> charge can succeed.  That potentially wastes scan progress when huge
> page allocations require multiple invocations, which always have to
> restart from the default scan priority.
> 
> Pass the request size as a reclaim target to direct reclaim and leave
> it to that code to reach the goal.

THP charge then will ask for 512 pages to be (direct) reclaimed. That
is _a lot_ and I would expect long stalls to achieve this target. I
would also expect quick priority drop down and potential over-reclaim
for small and moderately sized memcgs (e.g. memcg with 1G worth of pages
would need to drop down below DEF_PRIORITY-2 to have a chance to scan
that many pages). All that done for a charge which can fallback to a
single page charge.

The current code is quite hostile to THP when we are close to the limit
but solving this by introducing long stalls instead doesn't sound like a
proper approach to me.

> Charging will still have to loop in case concurrent allocations steal
> reclaim effort, but at least it doesn't have to loop to meet even the
> basic request size.  This also prepares the memcg reclaim API for use
> with the planned high limit, to reclaim excess with a single call.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/swap.h |  3 ++-
>  mm/memcontrol.c      | 15 +++++++++------
>  mm/vmscan.c          |  3 ++-
>  3 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1b72060f093a..473a3ae4cdd6 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -327,7 +327,8 @@ extern void lru_cache_add_active_or_unevictable(struct page *page,
>  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  					gfp_t gfp_mask, nodemask_t *mask);
>  extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
> -extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
> +extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> +						  unsigned long nr_pages,
>  						  gfp_t gfp_mask, bool noswap);
>  extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>  						gfp_t gfp_mask, bool noswap,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ec4dcf1b9562..ddffeeda2d52 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1793,6 +1793,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  }
>  
>  static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
> +					unsigned long nr_pages,
>  					gfp_t gfp_mask,
>  					unsigned long flags)
>  {
> @@ -1808,7 +1809,8 @@ static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
>  	for (loop = 0; loop < MEM_CGROUP_MAX_RECLAIM_LOOPS; loop++) {
>  		if (loop)
>  			drain_all_stock_async(memcg);
> -		total += try_to_free_mem_cgroup_pages(memcg, gfp_mask, noswap);
> +		total += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> +						      gfp_mask, noswap);
>  		/*
>  		 * Allow limit shrinkers, which are triggered directly
>  		 * by userspace, to catch signals and stop reclaim
> @@ -1816,7 +1818,7 @@ static unsigned long mem_cgroup_reclaim(struct mem_cgroup *memcg,
>  		 */
>  		if (total && (flags & MEM_CGROUP_RECLAIM_SHRINK))
>  			break;
> -		if (mem_cgroup_margin(memcg))
> +		if (mem_cgroup_margin(memcg) >= nr_pages)
>  			break;
>  		/*
>  		 * If nothing was reclaimed after two attempts, there
> @@ -2572,7 +2574,8 @@ retry:
>  	if (!(gfp_mask & __GFP_WAIT))
>  		goto nomem;
>  
> -	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
> +	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, nr_pages,
> +					  gfp_mask, flags);
>  
>  	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
>  		goto retry;
> @@ -3718,7 +3721,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		mem_cgroup_reclaim(memcg, GFP_KERNEL,
> +		mem_cgroup_reclaim(memcg, 1, GFP_KERNEL,
>  				   MEM_CGROUP_RECLAIM_SHRINK);
>  		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
>  		/* Usage is reduced ? */
> @@ -3777,7 +3780,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		mem_cgroup_reclaim(memcg, GFP_KERNEL,
> +		mem_cgroup_reclaim(memcg, 1, GFP_KERNEL,
>  				   MEM_CGROUP_RECLAIM_NOSWAP |
>  				   MEM_CGROUP_RECLAIM_SHRINK);
>  		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
> @@ -4028,7 +4031,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
>  		if (signal_pending(current))
>  			return -EINTR;
>  
> -		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL,
> +		progress = try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
>  						false);
>  		if (!progress) {
>  			nr_retries--;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d698f4f7b0f2..7db33f100db4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2747,6 +2747,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
>  }
>  
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> +					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
>  					   bool noswap)
>  {
> @@ -2754,7 +2755,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  	unsigned long nr_reclaimed;
>  	int nid;
>  	struct scan_control sc = {
> -		.nr_to_reclaim = SWAP_CLUSTER_MAX,
> +		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
>  		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
>  				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
>  		.target_mem_cgroup = memcg,
> -- 
> 2.0.3
> 

-- 
Michal Hocko
SUSE Labs
