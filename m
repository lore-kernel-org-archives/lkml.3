Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaG2H2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:28:14 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49486 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaG2H2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:28:07 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 29 Jul 2014 16:34:57 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 14/14] mm, compaction: try to capture the just-created
 high-order freepage
Message-ID: <20140729073456.GC1610@js1304-P5Q-DELUXE>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
 <1406553101-29326-15-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406553101-29326-15-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 03:11:41PM +0200, Vlastimil Babka wrote:
> Compaction uses watermark checking to determine if it succeeded in creating
> a high-order free page. My testing has shown that this is quite racy and it
> can happen that watermark checking in compaction succeeds, and moments later
> the watermark checking in page allocation fails, even though the number of
> free pages has increased meanwhile.
> 
> It should be more reliable if direct compaction captured the high-order free
> page as soon as it detects it, and pass it back to allocation. This would
> also reduce the window for somebody else to allocate the free page.
> 
> Capture has been implemented before by 1fb3f8ca0e92 ("mm: compaction: capture
> a suitable high-order page immediately when it is made available"), but later
> reverted by 8fb74b9f ("mm: compaction: partially revert capture of suitable
> high-order page") due to a bug.
> 
> This patch differs from the previous attempt in two aspects:
> 
> 1) The previous patch scanned free lists to capture the page. In this patch,
>    only the cc->order aligned block that the migration scanner just finished
>    is considered, but only if pages were actually isolated for migration in
>    that block. Tracking cc->order aligned blocks also has benefits for the
>    following patch that skips blocks where non-migratable pages were found.
> 
> 2) The operations done in buffered_rmqueue() and get_page_from_freelist() are
>    closely followed so that page capture mimics normal page allocation as much
>    as possible. This includes operations such as prep_new_page() and
>    page->pfmemalloc setting (that was missing in the previous attempt), zone
>    statistics are updated etc. Due to subtleties with IRQ disabling and
>    enabling this cannot be simply factored out from the normal allocation
>    functions without affecting the fastpath.

I don't look at it in detail, but, it looks really duplicated and hard
to maintain. From my experience, this is really error-prone. Please
think of freepage counting bugs reported by my recent patchset.
Freepage counting handles counting at different places for performance reason
and finally bugs are there. IMHO, making common function and using it
is better than this approach even if we touch the fastpath.

> 
> This patch has tripled compaction success rates (as recorded in vmstat) in
> stress-highalloc mmtests benchmark, although allocation success rates increased
> only by a few percent. Closer inspection shows that due to the racy watermark
> checking and lack of lru_add_drain(), the allocations that resulted in direct
> compactions were often failing, but later allocations succeeeded in the fast
> path. So the benefit of the patch to allocation success rates may be limited,
> but it improves the fairness in the sense that whoever spent the time
> compacting has a higher change of benefitting from it, and also can stop
> compacting sooner, as page availability is detected immediately. With better
> success detection, the contribution of compaction to high-order allocation
> success success rates is also no longer understated by the vmstats.

Could you separate this patch to this patchset?
I think that this patch doesn't get much reviewed from other developers
unlike other patches.

> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Acked-by: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> ---
>  include/linux/compaction.h |   8 ++-
>  mm/compaction.c            | 134 +++++++++++++++++++++++++++++++++++++++++----
>  mm/internal.h              |   4 +-
>  mm/page_alloc.c            |  81 +++++++++++++++++++++++----
>  4 files changed, 201 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index 60bdf8d..b83c142 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -12,6 +12,8 @@
>  #define COMPACT_PARTIAL		3
>  /* The full zone was compacted */
>  #define COMPACT_COMPLETE	4
> +/* Captured a high-order free page in direct compaction */
> +#define COMPACT_CAPTURED	5
>  
>  /* Used to signal whether compaction detected need_sched() or lock contention */
>  /* No contention detected */
> @@ -33,7 +35,8 @@ extern int fragmentation_index(struct zone *zone, unsigned int order);
>  extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *mask,
>  			enum migrate_mode mode, int *contended,
> -			struct zone **candidate_zone);
> +			struct zone **candidate_zone,
> +			struct page **captured_page);
>  extern void compact_pgdat(pg_data_t *pgdat, int order);
>  extern void reset_isolation_suitable(pg_data_t *pgdat);
>  extern unsigned long compaction_suitable(struct zone *zone, int order);
> @@ -103,7 +106,8 @@ static inline bool compaction_restarting(struct zone *zone, int order)
>  static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>  			enum migrate_mode mode, int *contended,
> -			struct zone **candidate_zone)
> +			struct zone **candidate_zone,
> +			struct page **captured_page);
>  {
>  	return COMPACT_CONTINUE;
>  }
> diff --git a/mm/compaction.c b/mm/compaction.c
> index dd3e4db..bfe56ee 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -548,6 +548,7 @@ static bool too_many_isolated(struct zone *zone)
>   * @low_pfn:	The first PFN to isolate
>   * @end_pfn:	The one-past-the-last PFN to isolate, within same pageblock
>   * @isolate_mode: Isolation mode to be used.
> + * @capture:    True if page capturing is allowed
>   *
>   * Isolate all pages that can be migrated from the range specified by
>   * [low_pfn, end_pfn). The range is expected to be within same pageblock.
> @@ -561,7 +562,8 @@ static bool too_many_isolated(struct zone *zone)
>   */
>  static unsigned long
>  isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
> -			unsigned long end_pfn, isolate_mode_t isolate_mode)
> +			unsigned long end_pfn, isolate_mode_t isolate_mode,
> +			bool capture)
>  {
>  	struct zone *zone = cc->zone;
>  	unsigned long nr_scanned = 0, nr_isolated = 0;
> @@ -570,6 +572,14 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  	unsigned long flags;
>  	bool locked = false;
>  	struct page *page = NULL, *valid_page = NULL;
> +	unsigned long capture_pfn = 0;   /* current candidate for capturing */
> +	unsigned long next_capture_pfn = 0; /* next candidate for capturing */
> +
> +	if (cc->order > 0 && cc->order <= pageblock_order && capture) {
> +		/* This may be outside the zone, but we check that later */
> +		capture_pfn = low_pfn & ~((1UL << cc->order) - 1);
> +		next_capture_pfn = ALIGN(low_pfn + 1, (1UL << cc->order));
> +	}

Instead of inserting capture logic to common code (compaction and
CMA), could you add it only to compaction code such as
isolate_migratepages(). Capture logic needs too many hooks as you see
on below snippets. And it makes code so much complicated.

>  
>  	/*
>  	 * Ensure that there are not too many pages isolated from the LRU
> @@ -591,7 +601,27 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  		return 0;
>  
>  	/* Time to isolate some pages for migration */
> -	for (; low_pfn < end_pfn; low_pfn++) {
> +	for (; low_pfn <= end_pfn; low_pfn++) {
> +		if (low_pfn == next_capture_pfn) {
> +			/*
> +			 * We have a capture candidate if we isolated something
> +			 * during the last cc->order aligned block of pages.
> +			 */
> +			if (nr_isolated &&
> +					capture_pfn >= zone->zone_start_pfn) {
> +				*cc->capture_page = pfn_to_page(capture_pfn);
> +				break;
> +			}
> +
> +			/* Prepare for a new capture candidate */
> +			capture_pfn = next_capture_pfn;
> +			next_capture_pfn += (1UL << cc->order);
> +		}
> +
> +		/* We check that here, in case low_pfn == next_capture_pfn */
> +		if (low_pfn == end_pfn)
> +			break;
> +
>  		/*
>  		 * Periodically drop the lock (if held) regardless of its
>  		 * contention, to give chance to IRQs. Abort async compaction
> @@ -625,8 +655,12 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  			 * a valid page order. Consider only values in the
>  			 * valid order range to prevent low_pfn overflow.
>  			 */
> -			if (freepage_order > 0 && freepage_order < MAX_ORDER)
> +			if (freepage_order > 0 && freepage_order < MAX_ORDER) {
>  				low_pfn += (1UL << freepage_order) - 1;
> +				if (next_capture_pfn)
> +					next_capture_pfn = ALIGN(low_pfn + 1,
> +							(1UL << cc->order));
> +			}
>  			continue;
>  		}
>  
> @@ -662,6 +696,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  			else
>  				low_pfn += (1 << compound_order(page)) - 1;
>  
> +			if (next_capture_pfn)
> +				next_capture_pfn =
> +					ALIGN(low_pfn + 1, (1UL << cc->order));
>  			continue;
>  		}
>  
> @@ -686,6 +723,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  				continue;
>  			if (PageTransHuge(page)) {
>  				low_pfn += (1 << compound_order(page)) - 1;
> +				if (next_capture_pfn)
> +					next_capture_pfn = ALIGN(low_pfn + 1,
> +							(1UL << cc->order));
>  				continue;
>  			}
>  		}
> @@ -770,7 +810,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
>  			continue;
>  
>  		pfn = isolate_migratepages_block(cc, pfn, block_end_pfn,
> -							ISOLATE_UNEVICTABLE);
> +						ISOLATE_UNEVICTABLE, false);
>  
>  		/*
>  		 * In case of fatal failure, release everything that might
> @@ -958,7 +998,7 @@ typedef enum {
>   * compact_control.
>   */
>  static isolate_migrate_t isolate_migratepages(struct zone *zone,
> -					struct compact_control *cc)
> +			struct compact_control *cc, const int migratetype)
>  {
>  	unsigned long low_pfn, end_pfn;
>  	struct page *page;
> @@ -981,6 +1021,9 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  	for (; end_pfn <= cc->free_pfn;
>  			low_pfn = end_pfn, end_pfn += pageblock_nr_pages) {
>  
> +		int pageblock_mt;
> +		bool capture;
> +
>  		/*
>  		 * This can potentially iterate a massively long zone with
>  		 * many pageblocks unsuitable, so periodically check if we
> @@ -1003,13 +1046,22 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  		 * Async compaction is optimistic to see if the minimum amount
>  		 * of work satisfies the allocation.
>  		 */
> +		pageblock_mt = get_pageblock_migratetype(page);
>  		if (cc->mode == MIGRATE_ASYNC &&
> -		    !migrate_async_suitable(get_pageblock_migratetype(page)))
> +					!migrate_async_suitable(pageblock_mt))
>  			continue;
>  
> +		/*
> +		 * Capture page only if the caller requested it, and either the
> +		 * pageblock has our desired migratetype, or we would take it
> +		 * completely.
> +		 */
> +		capture = cc->capture_page && ((pageblock_mt == migratetype)
> +					|| (cc->order == pageblock_order));
> +
>  		/* Perform the isolation */
>  		low_pfn = isolate_migratepages_block(cc, low_pfn, end_pfn,
> -								isolate_mode);
> +							isolate_mode, capture);
>  
>  		if (!low_pfn || cc->contended)
>  			return ISOLATE_ABORT;
> @@ -1028,6 +1080,48 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
>  }
>  
> +/*
> + * When called, cc->capture_page must be non-NULL. Then *cc->capture_page is
> + * just a candidate, or NULL (no candidate). This function will either
> + * successfully capture the page, or reset *cc->capture_page to NULL.
> + */
> +static bool compact_capture_page(struct compact_control *cc)
> +{
> +	struct page *page = *cc->capture_page;
> +	int cpu;
> +
> +	if (!page)
> +		return false;
> +
> +	/* Unsafe check if it's worth to try acquiring the zone->lock at all */
> +	if (PageBuddy(page) && page_order_unsafe(page) >= cc->order)
> +		goto try_capture;
> +
> +	/*
> +	 * There's a good chance that we have just put free pages on this CPU's
> +	 * lru cache and pcplists after the page migrations. Drain them to
> +	 * allow merging.
> +	 */
> +	cpu = get_cpu();
> +	lru_add_drain_cpu(cpu);
> +	drain_local_pages(NULL);
> +	put_cpu();

Just for curiosity.

If lru_add_drain_cpu() is cheap enough to capture high order page, why
__alloc_pages_direct_compact() doesn't call it before
get_page_from_freelist()?

> +
> +	/* Did the draining help? */
> +	if (PageBuddy(page) && page_order_unsafe(page) >= cc->order)
> +		goto try_capture;
> +
> +	goto fail;
> +
> +try_capture:
> +	if (capture_free_page(page, cc->order))
> +		return true;
> +
> +fail:
> +	*cc->capture_page = NULL;
> +	return false;
> +}
> +
>  static int compact_finished(struct zone *zone, struct compact_control *cc,
>  			    const int migratetype)
>  {
> @@ -1056,6 +1150,10 @@ static int compact_finished(struct zone *zone, struct compact_control *cc,
>  		return COMPACT_COMPLETE;
>  	}
>  
> +	/* Did we just finish a pageblock that was capture candidate? */
> +	if (cc->capture_page && compact_capture_page(cc))
> +		return COMPACT_CAPTURED;
> +
>  	/*
>  	 * order == -1 is expected when compacting via
>  	 * /proc/sys/vm/compact_memory
> @@ -1188,7 +1286,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>  						COMPACT_CONTINUE) {
>  		int err;
>  
> -		switch (isolate_migratepages(zone, cc)) {
> +		switch (isolate_migratepages(zone, cc, migratetype)) {
>  		case ISOLATE_ABORT:
>  			ret = COMPACT_PARTIAL;
>  			putback_movable_pages(&cc->migratepages);
> @@ -1227,13 +1325,18 @@ out:
>  	cc->nr_freepages -= release_freepages(&cc->freepages);
>  	VM_BUG_ON(cc->nr_freepages != 0);
>  
> +	/* Remove any candidate page if it was not captured */
> +	if (cc->capture_page && ret != COMPACT_CAPTURED)
> +		*cc->capture_page = NULL;
> +
>  	trace_mm_compaction_end(ret);
>  
>  	return ret;
>  }
>  
>  static unsigned long compact_zone_order(struct zone *zone, int order,
> -		gfp_t gfp_mask, enum migrate_mode mode, int *contended)
> +		gfp_t gfp_mask, enum migrate_mode mode, int *contended,
> +						struct page **captured_page)
>  {
>  	unsigned long ret;
>  	struct compact_control cc = {
> @@ -1243,6 +1346,7 @@ static unsigned long compact_zone_order(struct zone *zone, int order,
>  		.gfp_mask = gfp_mask,
>  		.zone = zone,
>  		.mode = mode,
> +		.capture_page = captured_page,
>  	};
>  	INIT_LIST_HEAD(&cc.freepages);
>  	INIT_LIST_HEAD(&cc.migratepages);
> @@ -1268,13 +1372,15 @@ int sysctl_extfrag_threshold = 500;
>   * @contended: Return value that determines if compaction was aborted due to
>   *	       need_resched() or lock contention
>   * @candidate_zone: Return the zone where we think allocation should succeed
> + * @captured_page: If successful, return the page captured during compaction
>   *
>   * This is the main entry point for direct page compaction.
>   */
>  unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>  			enum migrate_mode mode, int *contended,
> -			struct zone **candidate_zone)
> +			struct zone **candidate_zone,
> +			struct page **captured_page)
>  {
>  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>  	int may_enter_fs = gfp_mask & __GFP_FS;
> @@ -1305,7 +1411,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			continue;
>  
>  		status = compact_zone_order(zone, order, gfp_mask, mode,
> -							&zone_contended);
> +					&zone_contended, captured_page);
>  		rc = max(status, rc);
>  		/*
>  		 * It takes at least one zone that wasn't lock contended
> @@ -1314,6 +1420,12 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  		all_zones_lock_contended &=
>  			(zone_contended == COMPACT_CONTENDED_LOCK);
>  
> +		/* If we captured a page, stop compacting */
> +		if (*captured_page) {
> +			*candidate_zone = zone;
> +			break;
> +		}
> +
>  		/* If a normal allocation would succeed, stop compacting */
>  		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
>  				      alloc_flags)) {
> diff --git a/mm/internal.h b/mm/internal.h
> index 8293040..f2d625f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -110,6 +110,7 @@ extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>   */
>  extern void __free_pages_bootmem(struct page *page, unsigned int order);
>  extern void prep_compound_page(struct page *page, unsigned long order);
> +extern bool capture_free_page(struct page *page, unsigned int order);
>  #ifdef CONFIG_MEMORY_FAILURE
>  extern bool is_free_buddy_page(struct page *page);
>  #endif
> @@ -148,6 +149,7 @@ struct compact_control {
>  					 * contention detected during
>  					 * compaction
>  					 */
> +	struct page **capture_page;	/* Free page captured by compaction */
>  };
>  
>  unsigned long
> @@ -155,7 +157,7 @@ isolate_freepages_range(struct compact_control *cc,
>  			unsigned long start_pfn, unsigned long end_pfn);
>  unsigned long
>  isolate_migratepages_range(struct compact_control *cc,
> -			   unsigned long low_pfn, unsigned long end_pfn);
> +			unsigned long low_pfn, unsigned long end_pfn);
>  
>  #endif
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bbdb10f..af9ed36 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1489,9 +1489,11 @@ static int __isolate_free_page(struct page *page, unsigned int order)
>  {
>  	unsigned long watermark;
>  	struct zone *zone;
> +	struct free_area *area;
>  	int mt;
> +	unsigned int freepage_order = page_order(page);
>  
> -	BUG_ON(!PageBuddy(page));
> +	VM_BUG_ON_PAGE((!PageBuddy(page) || freepage_order < order), page);
>  
>  	zone = page_zone(page);
>  	mt = get_pageblock_migratetype(page);
> @@ -1506,9 +1508,12 @@ static int __isolate_free_page(struct page *page, unsigned int order)
>  	}
>  

In __isolate_free_page(), we check zone_watermark_ok() with order 0.
But normal allocation logic would check zone_watermark_ok() with requested
order. Your capture logic uses __isolate_free_page() and it would
affect compaction success rate significantly. And it means that
capture logic allocates high order page on page allocator
too aggressively compared to other component such as normal high order
allocation. Could you test this patch again after changing order for
zone_watermark_ok() in __isolate_free_page()?

Thanks.
