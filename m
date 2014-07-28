Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaG1X7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:59:47 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43334 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaG1X7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:59:45 -0400
Date: Mon, 28 Jul 2014 16:59:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 02/14] mm, compaction: defer each zone individually
 instead of preferred zone
In-Reply-To: <1406553101-29326-3-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281649570.8998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-3-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index 01e3132..b2e4c92 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -2,14 +2,16 @@
>  #define _LINUX_COMPACTION_H
>  
>  /* Return values for compact_zone() and try_to_compact_pages() */
> +/* compaction didn't start as it was deferred due to past failures */
> +#define COMPACT_DEFERRED	0
>  /* compaction didn't start as it was not possible or direct reclaim was more suitable */
> -#define COMPACT_SKIPPED		0
> +#define COMPACT_SKIPPED		1
>  /* compaction should continue to another pageblock */
> -#define COMPACT_CONTINUE	1
> +#define COMPACT_CONTINUE	2
>  /* direct compaction partially compacted a zone and there are suitable pages */
> -#define COMPACT_PARTIAL		2
> +#define COMPACT_PARTIAL		3
>  /* The full zone was compacted */
> -#define COMPACT_COMPLETE	3
> +#define COMPACT_COMPLETE	4
>  
>  #ifdef CONFIG_COMPACTION
>  extern int sysctl_compact_memory;
> @@ -22,7 +24,8 @@ extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
>  extern int fragmentation_index(struct zone *zone, unsigned int order);
>  extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *mask,
> -			enum migrate_mode mode, bool *contended);
> +			enum migrate_mode mode, bool *contended,
> +			struct zone **candidate_zone);
>  extern void compact_pgdat(pg_data_t *pgdat, int order);
>  extern void reset_isolation_suitable(pg_data_t *pgdat);
>  extern unsigned long compaction_suitable(struct zone *zone, int order);
> @@ -91,7 +94,8 @@ static inline bool compaction_restarting(struct zone *zone, int order)
>  #else
>  static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
> -			enum migrate_mode mode, bool *contended)
> +			enum migrate_mode mode, bool *contended,
> +			struct zone **candidate_zone)
>  {
>  	return COMPACT_CONTINUE;
>  }
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 5175019..f3ae2ec 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1122,28 +1122,27 @@ int sysctl_extfrag_threshold = 500;
>   * @nodemask: The allowed nodes to allocate from
>   * @mode: The migration mode for async, sync light, or sync migration
>   * @contended: Return value that is true if compaction was aborted due to lock contention
> - * @page: Optionally capture a free page of the requested order during compaction

Never noticed this non-existant formal before.

> + * @candidate_zone: Return the zone where we think allocation should succeed
>   *
>   * This is the main entry point for direct page compaction.
>   */
>  unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
> -			enum migrate_mode mode, bool *contended)
> +			enum migrate_mode mode, bool *contended,
> +			struct zone **candidate_zone)
>  {
>  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>  	int may_enter_fs = gfp_mask & __GFP_FS;
>  	int may_perform_io = gfp_mask & __GFP_IO;
>  	struct zoneref *z;
>  	struct zone *zone;
> -	int rc = COMPACT_SKIPPED;
> +	int rc = COMPACT_DEFERRED;
>  	int alloc_flags = 0;
>  
>  	/* Check if the GFP flags allow compaction */
>  	if (!order || !may_enter_fs || !may_perform_io)
>  		return rc;
>  

It doesn't seem right that if we called try_to_compact_pages() in a 
context where it is useless (order-0 or non-GFP_KERNEL allocation) that we 
would return COMPACT_DEFERRED.  I think the existing semantics before the 
patch, that is

 - deferred: compaction was tried but failed, so avoid subsequent calls in
   the near future that may be potentially expensive, and

 - skipped: compaction wasn't tried because it will be useless

is correct and deferred shouldn't take on another meaning, which now will 
set deferred_compaction == true in the page allocator.  It probably 
doesn't matter right now because the only check of deferred_compaction is 
effective for __GFP_NO_KSWAPD, i.e. it is both high-order and GFP_KERNEL, 
but it seems returning COMPACT_SKIPPED here would also work fine and be 
more appropriate.

> -	count_compact_event(COMPACTSTALL);
> -

I was originally going to object to moving this to the page allocator, but 
it does indeed seem correct given the new return values and since deferred 
compaction is now checked in memory compaction instead of the page 
allocator.

>  #ifdef CONFIG_CMA
>  	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
>  		alloc_flags |= ALLOC_CMA;
> @@ -1153,14 +1152,33 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  								nodemask) {
>  		int status;
>  
> +		if (compaction_deferred(zone, order))
> +			continue;
> +
>  		status = compact_zone_order(zone, order, gfp_mask, mode,
>  						contended);
>  		rc = max(status, rc);
>  
>  		/* If a normal allocation would succeed, stop compacting */
>  		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
> -				      alloc_flags))
> +				      alloc_flags)) {
> +			*candidate_zone = zone;
> +			/*
> +			 * We think the allocation will succeed in this zone,
> +			 * but it is not certain, hence the false. The caller
> +			 * will repeat this with true if allocation indeed
> +			 * succeeds in this zone.
> +			 */
> +			compaction_defer_reset(zone, order, false);
>  			break;
> +		} else if (mode != MIGRATE_ASYNC) {
> +			/*
> +			 * We think that allocation won't succeed in this zone
> +			 * so we defer compaction there. If it ends up
> +			 * succeeding after all, it will be reset.
> +			 */
> +			defer_compaction(zone, order);
> +		}
>  	}
>  
>  	return rc;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b99643d4..a14efeb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2299,21 +2299,24 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	bool *contended_compaction, bool *deferred_compaction,
>  	unsigned long *did_some_progress)
>  {
> -	if (!order)
> -		return NULL;
> +	struct zone *last_compact_zone = NULL;
>  
> -	if (compaction_deferred(preferred_zone, order)) {
> -		*deferred_compaction = true;
> +	if (!order)
>  		return NULL;
> -	}
>  
>  	current->flags |= PF_MEMALLOC;
>  	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
>  						nodemask, mode,
> -						contended_compaction);
> +						contended_compaction,
> +						&last_compact_zone);
>  	current->flags &= ~PF_MEMALLOC;
>  
> -	if (*did_some_progress != COMPACT_SKIPPED) {
> +	if (*did_some_progress > COMPACT_DEFERRED)
> +		count_vm_event(COMPACTSTALL);
> +	else
> +		*deferred_compaction = true;
> +
> +	if (*did_some_progress > COMPACT_SKIPPED) {
>  		struct page *page;
>  
>  		/* Page migration frees to the PCP lists but we want merging */
> @@ -2324,27 +2327,31 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  				order, zonelist, high_zoneidx,
>  				alloc_flags & ~ALLOC_NO_WATERMARKS,
>  				preferred_zone, classzone_idx, migratetype);
> +
>  		if (page) {
> -			preferred_zone->compact_blockskip_flush = false;
> -			compaction_defer_reset(preferred_zone, order, true);
> +			struct zone *zone = page_zone(page);
> +
> +			zone->compact_blockskip_flush = false;
> +			compaction_defer_reset(zone, order, true);
>  			count_vm_event(COMPACTSUCCESS);
>  			return page;
>  		}
>  
>  		/*
> +		 * last_compact_zone is where try_to_compact_pages thought
> +		 * allocation should succeed, so it did not defer compaction.
> +		 * But now we know that it didn't succeed, so we do the defer.
> +		 */
> +		if (last_compact_zone && mode != MIGRATE_ASYNC)
> +			defer_compaction(last_compact_zone, order);
> +
> +		/*
>  		 * It's bad if compaction run occurs and fails.
>  		 * The most likely reason is that pages exist,
>  		 * but not enough to satisfy watermarks.
>  		 */
>  		count_vm_event(COMPACTFAIL);
>  
> -		/*
> -		 * As async compaction considers a subset of pageblocks, only
> -		 * defer if the failure was a sync compaction failure.
> -		 */
> -		if (mode != MIGRATE_ASYNC)
> -			defer_compaction(preferred_zone, order);
> -
>  		cond_resched();
>  	}
>  
