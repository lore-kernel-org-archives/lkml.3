Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaFXEx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaFXEx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:53:28 -0400
Date: Tue, 24 Jun 2014 00:52:52 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/13] mm, compaction: move pageblock checks up from
 isolate_migratepages_range()
Message-ID: <20140624045252.GA18289@nhori.bos.redhat.com>
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz>
 <1403279383-5862-5-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403279383-5862-5-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 05:49:34PM +0200, Vlastimil Babka wrote:
> isolate_migratepages_range() is the main function of the compaction scanner,
> called either on a single pageblock by isolate_migratepages() during regular
> compaction, or on an arbitrary range by CMA's __alloc_contig_migrate_range().
> It currently perfoms two pageblock-wide compaction suitability checks, and

(nit-picking) s/perfoms/performs/

> because of the CMA callpath, it tracks if it crossed a pageblock boundary in
> order to repeat those checks.
> 
> However, closer inspection shows that those checks are always true for CMA:
> - isolation_suitable() is true because CMA sets cc->ignore_skip_hint to true
> - migrate_async_suitable() check is skipped because CMA uses sync compaction
> 
> We can therefore move the checks to isolate_migratepages(), reducing variables
> and simplifying isolate_migratepages_range(). The update_pageblock_skip()
> function also no longer needs set_unsuitable parameter.
> 
> Furthermore, going back to compact_zone() and compact_finished() when pageblock
> is unsuitable is wasteful - the checks are meant to skip pageblocks quickly.
> The patch therefore also introduces a simple loop into isolate_migratepages()
> so that it does not return immediately on pageblock checks, but keeps going
> until isolate_migratepages_range() gets called once. Similarily to
> isolate_freepages(), the function periodically checks if it needs to reschedule
> or abort async compaction.

This looks to me a good direction.
One thing below ...

> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> ---
>  mm/compaction.c | 112 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 59 insertions(+), 53 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 3064a7f..ebe30c9 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
...
> @@ -840,34 +809,74 @@ typedef enum {
>  } isolate_migrate_t;
>  
>  /*
> - * Isolate all pages that can be migrated from the block pointed to by
> - * the migrate scanner within compact_control.
> + * Isolate all pages that can be migrated from the first suitable block,
> + * starting at the block pointed to by the migrate scanner pfn within
> + * compact_control.
>   */
>  static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  					struct compact_control *cc)
>  {
>  	unsigned long low_pfn, end_pfn;
> +	struct page *page;
>  
> -	/* Do not scan outside zone boundaries */
> -	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
> +	/* Start at where we last stopped, or beginning of the zone */
> +	low_pfn = cc->migrate_pfn;
>  
>  	/* Only scan within a pageblock boundary */
>  	end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
>  
> -	/* Do not cross the free scanner or scan within a memory hole */
> -	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
> -		cc->migrate_pfn = end_pfn;
> -		return ISOLATE_NONE;
> -	}
> +	/*
> +	 * Iterate over whole pageblocks until we find the first suitable.
> +	 * Do not cross the free scanner.
> +	 */
> +	for (; end_pfn <= cc->free_pfn;
> +			low_pfn = end_pfn, end_pfn += pageblock_nr_pages) {
> +
> +		/*
> +		 * This can potentially iterate a massively long zone with
> +		 * many pageblocks unsuitable, so periodically check if we
> +		 * need to schedule, or even abort async compaction.
> +		 */
> +		if (!(low_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
> +						&& compact_should_abort(cc))
> +			break;
>  
> -	/* Perform the isolation */
> -	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
> -	if (!low_pfn || cc->contended)
> -		return ISOLATE_ABORT;
> +		/* Do not scan within a memory hole */
> +		if (!pfn_valid(low_pfn))
> +			continue;
> +
> +		page = pfn_to_page(low_pfn);

Can we move (page_zone != zone) check here as isolate_freepages() does?

Thanks,
Naoya Horiguchi

> +		/* If isolation recently failed, do not retry */
> +		if (!isolation_suitable(cc, page))
> +			continue;
>  
> +		/*
> +		 * For async compaction, also only scan in MOVABLE blocks.
> +		 * Async compaction is optimistic to see if the minimum amount
> +		 * of work satisfies the allocation.
> +		 */
> +		if (cc->mode == MIGRATE_ASYNC &&
> +		    !migrate_async_suitable(get_pageblock_migratetype(page)))
> +			continue;
> +
> +		/* Perform the isolation */
> +		low_pfn = isolate_migratepages_range(zone, cc, low_pfn,
> +								end_pfn, false);
> +		if (!low_pfn || cc->contended)
> +			return ISOLATE_ABORT;
> +
> +		/*
> +		 * Either we isolated something and proceed with migration. Or
> +		 * we failed and compact_zone should decide if we should
> +		 * continue or not.
> +		 */
> +		break;
> +	}
> +
> +	/* Record where migration scanner will be restarted */
>  	cc->migrate_pfn = low_pfn;
>  
> -	return ISOLATE_SUCCESS;
> +	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
>  }
>  
>  static int compact_finished(struct zone *zone,
