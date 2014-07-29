Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaG2A7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:59:31 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:41031 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaG2A72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:59:28 -0400
Date: Mon, 28 Jul 2014 17:59:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
In-Reply-To: <1406553101-29326-8-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1407281748110.8998@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Vlastimil Babka wrote:

> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index b2e4c92..60bdf8d 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -13,6 +13,14 @@
>  /* The full zone was compacted */
>  #define COMPACT_COMPLETE	4
>  
> +/* Used to signal whether compaction detected need_sched() or lock contention */
> +/* No contention detected */
> +#define COMPACT_CONTENDED_NONE	0
> +/* Either need_sched() was true or fatal signal pending */
> +#define COMPACT_CONTENDED_SCHED	1
> +/* Zone lock or lru_lock was contended in async compaction */
> +#define COMPACT_CONTENDED_LOCK	2
> +

Make this an enum?

>  #ifdef CONFIG_COMPACTION
>  extern int sysctl_compact_memory;
>  extern int sysctl_compaction_handler(struct ctl_table *table, int write,
> @@ -24,7 +32,7 @@ extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
>  extern int fragmentation_index(struct zone *zone, unsigned int order);
>  extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *mask,
> -			enum migrate_mode mode, bool *contended,
> +			enum migrate_mode mode, int *contended,
>  			struct zone **candidate_zone);
>  extern void compact_pgdat(pg_data_t *pgdat, int order);
>  extern void reset_isolation_suitable(pg_data_t *pgdat);
> @@ -94,7 +102,7 @@ static inline bool compaction_restarting(struct zone *zone, int order)
>  #else
>  static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
> -			enum migrate_mode mode, bool *contended,
> +			enum migrate_mode mode, int *contended,
>  			struct zone **candidate_zone)
>  {
>  	return COMPACT_CONTINUE;
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 76a9775..2b8b6d8 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -223,9 +223,21 @@ static void update_pageblock_skip(struct compact_control *cc,
>  }
>  #endif /* CONFIG_COMPACTION */
>  
> -static inline bool should_release_lock(spinlock_t *lock)
> +static int should_release_lock(spinlock_t *lock)
>  {
> -	return need_resched() || spin_is_contended(lock);
> +	/*
> +	 * Sched contention has higher priority here as we may potentially
> +	 * have to abort whole compaction ASAP. Returning with lock contention
> +	 * means we will try another zone, and further decisions are
> +	 * influenced only when all zones are lock contended. That means
> +	 * potentially missing a lock contention is less critical.
> +	 */
> +	if (need_resched())
> +		return COMPACT_CONTENDED_SCHED;
> +	else if (spin_is_contended(lock))
> +		return COMPACT_CONTENDED_LOCK;
> +	else
> +		return COMPACT_CONTENDED_NONE;

I would avoid the last else statement and just return 
COMPACT_CONTENDED_NONE.

>  }
>  
>  /*
> @@ -240,7 +252,9 @@ static inline bool should_release_lock(spinlock_t *lock)
>  static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
>  				      bool locked, struct compact_control *cc)
>  {
> -	if (should_release_lock(lock)) {
> +	int contended = should_release_lock(lock);
> +
> +	if (contended) {
>  		if (locked) {
>  			spin_unlock_irqrestore(lock, *flags);
>  			locked = false;
> @@ -248,7 +262,7 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
>  
>  		/* async aborts if taking too long or contended */
>  		if (cc->mode == MIGRATE_ASYNC) {
> -			cc->contended = true;
> +			cc->contended = contended;
>  			return false;
>  		}
>  
> @@ -274,7 +288,7 @@ static inline bool compact_should_abort(struct compact_control *cc)
>  	/* async compaction aborts if contended */
>  	if (need_resched()) {
>  		if (cc->mode == MIGRATE_ASYNC) {
> -			cc->contended = true;
> +			cc->contended = COMPACT_CONTENDED_SCHED;
>  			return true;
>  		}
>  
> @@ -1139,7 +1153,7 @@ out:
>  }
>  
>  static unsigned long compact_zone_order(struct zone *zone, int order,
> -		gfp_t gfp_mask, enum migrate_mode mode, bool *contended)
> +		gfp_t gfp_mask, enum migrate_mode mode, int *contended)
>  {
>  	unsigned long ret;
>  	struct compact_control cc = {
> @@ -1154,11 +1168,11 @@ static unsigned long compact_zone_order(struct zone *zone, int order,
>  	INIT_LIST_HEAD(&cc.migratepages);
>  
>  	ret = compact_zone(zone, &cc);
> +	*contended = cc.contended;
>  
>  	VM_BUG_ON(!list_empty(&cc.freepages));
>  	VM_BUG_ON(!list_empty(&cc.migratepages));
>  
> -	*contended = cc.contended;

Not sure why, but ok :)

>  	return ret;
>  }
>  
> @@ -1171,14 +1185,15 @@ int sysctl_extfrag_threshold = 500;
>   * @gfp_mask: The GFP mask of the current allocation
>   * @nodemask: The allowed nodes to allocate from
>   * @mode: The migration mode for async, sync light, or sync migration
> - * @contended: Return value that is true if compaction was aborted due to lock contention
> + * @contended: Return value that determines if compaction was aborted due to
> + *	       need_resched() or lock contention
>   * @candidate_zone: Return the zone where we think allocation should succeed
>   *
>   * This is the main entry point for direct page compaction.
>   */
>  unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
> -			enum migrate_mode mode, bool *contended,
> +			enum migrate_mode mode, int *contended,
>  			struct zone **candidate_zone)
>  {
>  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> @@ -1188,6 +1203,9 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  	struct zone *zone;
>  	int rc = COMPACT_DEFERRED;
>  	int alloc_flags = 0;
> +	bool all_zones_lock_contended = true; /* init true for &= operation */
> +
> +	*contended = COMPACT_CONTENDED_NONE;
>  
>  	/* Check if the GFP flags allow compaction */
>  	if (!order || !may_enter_fs || !may_perform_io)
> @@ -1201,13 +1219,20 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
>  								nodemask) {
>  		int status;
> +		int zone_contended;
>  
>  		if (compaction_deferred(zone, order))
>  			continue;
>  
>  		status = compact_zone_order(zone, order, gfp_mask, mode,
> -						contended);
> +							&zone_contended);
>  		rc = max(status, rc);
> +		/*
> +		 * It takes at least one zone that wasn't lock contended
> +		 * to turn all_zones_lock_contended to false.
> +		 */
> +		all_zones_lock_contended &=
> +			(zone_contended == COMPACT_CONTENDED_LOCK);

Eek, does this always work?  COMPACT_CONTENDED_LOCK is 0x2 and 
all_zones_lock_contended is a bool initialized to true.  I'm fairly 
certain you'd get better code generation if you defined 
all_zones_lock_contended as

	int all_zones_lock_contended = COMPACT_CONTENDED_LOCK

from the start and the source code would be more clear.

>  
>  		/* If a normal allocation would succeed, stop compacting */
>  		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
> @@ -1220,8 +1245,20 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			 * succeeds in this zone.
>  			 */
>  			compaction_defer_reset(zone, order, false);
> -			break;
> -		} else if (mode != MIGRATE_ASYNC) {
> +			/*
> +			 * It is possible that async compaction aborted due to
> +			 * need_resched() and the watermarks were ok thanks to
> +			 * somebody else freeing memory. The allocation can
> +			 * however still fail so we better signal the
> +			 * need_resched() contention anyway.
> +			 */

Makes sense because the page allocator still tries to allocate the page 
even if this is returned, but it's not very clear in the comment.

> +			if (zone_contended == COMPACT_CONTENDED_SCHED)
> +				*contended = COMPACT_CONTENDED_SCHED;
> +
> +			goto break_loop;
> +		}
> +
> +		if (mode != MIGRATE_ASYNC) {
>  			/*
>  			 * We think that allocation won't succeed in this zone
>  			 * so we defer compaction there. If it ends up
> @@ -1229,8 +1266,36 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			 */
>  			defer_compaction(zone, order);
>  		}
> +
> +		/*
> +		 * We might have stopped compacting due to need_resched() in
> +		 * async compaction, or due to a fatal signal detected. In that
> +		 * case do not try further zones and signal need_resched()
> +		 * contention.
> +		 */
> +		if ((zone_contended == COMPACT_CONTENDED_SCHED)
> +					|| fatal_signal_pending(current)) {
> +			*contended = COMPACT_CONTENDED_SCHED;
> +			goto break_loop;
> +		}
> +
> +		continue;
> +break_loop:
> +		/*
> +		 * We might not have tried all the zones, so  be conservative
> +		 * and assume they are not all lock contended.
> +		 */
> +		all_zones_lock_contended = false;
> +		break;
>  	}
>  
> +	/*
> +	 * If at least one zone wasn't deferred or skipped, we report if all
> +	 * zones that were tried were contended.
> +	 */
> +	if (rc > COMPACT_SKIPPED && all_zones_lock_contended)
> +		*contended = COMPACT_CONTENDED_LOCK;
> +
>  	return rc;
>  }
>  
> diff --git a/mm/internal.h b/mm/internal.h
> index 5a0738f..4c1d604 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -144,8 +144,8 @@ struct compact_control {
>  	int order;			/* order a direct compactor needs */
>  	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
>  	struct zone *zone;
> -	bool contended;			/* True if a lock was contended, or
> -					 * need_resched() true during async
> +	int contended;			/* Signal need_sched() or lock
> +					 * contention detected during
>  					 * compaction
>  					 */
>  };
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f424752..e3c633b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2296,7 +2296,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
>  	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
>  	int classzone_idx, int migratetype, enum migrate_mode mode,
> -	bool *contended_compaction, bool *deferred_compaction,
> +	int *contended_compaction, bool *deferred_compaction,
>  	unsigned long *did_some_progress)
>  {
>  	struct zone *last_compact_zone = NULL;
> @@ -2547,7 +2547,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	unsigned long did_some_progress;
>  	enum migrate_mode migration_mode = MIGRATE_ASYNC;
>  	bool deferred_compaction = false;
> -	bool contended_compaction = false;
> +	int contended_compaction = COMPACT_CONTENDED_NONE;
>  
>  	/*
>  	 * In the slowpath, we sanity check order to avoid ever trying to
> @@ -2660,15 +2660,36 @@ rebalance:
>  	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
>  		migration_mode = MIGRATE_SYNC_LIGHT;
>  
> -	/*
> -	 * If compaction is deferred for high-order allocations, it is because
> -	 * sync compaction recently failed. In this is the case and the caller
> -	 * requested a movable allocation that does not heavily disrupt the
> -	 * system then fail the allocation instead of entering direct reclaim.
> -	 */
> -	if ((deferred_compaction || contended_compaction) &&
> -						(gfp_mask & __GFP_NO_KSWAPD))
> -		goto nopage;

Hmm, this check will have unfortunately changed in the latest mmotm due to 
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch.

> +	/* Checks for THP-specific high-order allocations */
> +	if (gfp_mask & __GFP_NO_KSWAPD) {
> +		/*
> +		 * If compaction is deferred for high-order allocations, it is
> +		 * because sync compaction recently failed. If this is the case
> +		 * and the caller requested a THP allocation, we do not want
> +		 * to heavily disrupt the system, so we fail the allocation
> +		 * instead of entering direct reclaim.
> +		 */
> +		if (deferred_compaction)
> +			goto nopage;
> +
> +		/*
> +		 * In all zones where compaction was attempted (and not
> +		 * deferred or skipped), lock contention has been detected.
> +		 * For THP allocation we do not want to disrupt the others
> +		 * so we fallback to base pages instead.
> +		 */
> +		if (contended_compaction == COMPACT_CONTENDED_LOCK)
> +			goto nopage;
> +
> +		/*
> +		 * If compaction was aborted due to need_resched(), we do not
> +		 * want to further increase allocation latency, unless it is
> +		 * khugepaged trying to collapse.
> +		 */
> +		if (contended_compaction == COMPACT_CONTENDED_SCHED
> +			&& !(current->flags & PF_KTHREAD))
> +			goto nopage;
> +	}
>  
>  	/* Try direct reclaim and then allocating */
>  	page = __alloc_pages_direct_reclaim(gfp_mask, order,
