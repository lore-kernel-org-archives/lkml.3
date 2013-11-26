Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3KZK6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:58:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab3KZK6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:58:18 -0500
Date: Tue, 26 Nov 2013 10:58:15 +0000
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] mm: compaction: do not mark unmovable pageblocks as
 skipped in async compaction
Message-ID: <20131126105815.GI5285@suse.de>
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz>
 <1385389570-11393-5-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1385389570-11393-5-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 03:26:09PM +0100, Vlastimil Babka wrote:
> Compaction temporarily marks pageblocks where it fails to isolate pages as
> to-be-skipped in further compactions, in order to improve efficiency. One of
> the reasons to fail isolating pages is that isolation is not attempted in
> pageblocks that are not of MIGRATE_MOVABLE (or CMA) type.
> 
> The problem is that blocks skipped due to not being MIGRATE_MOVABLE in async
> compaction become skipped due to the temporary mark also in future sync
> compaction. Moreover, this may follow quite soon during __alloc_page_slowpath,
> without much time for kswapd to clear the pageblock skip marks. This goes
> against the idea that sync compaction should try to scan these blocks more
> thoroughly than the async compaction.
> 
> The fix is to ensure in async compaction that these !MIGRATE_MOVABLE blocks are
> not marked to be skipped. Note this should not affect performance or locking
> impact of further async compactions, as skipping a block due to being
> !MIGRATE_MOVABLE is done soon after skipping a block marked to be skipped, both
> without locking.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/compaction.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 0702bdf..f481193 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -455,6 +455,8 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  	unsigned long flags;
>  	bool locked = false;
>  	struct page *page = NULL, *valid_page = NULL;
> +	bool skipped_unmovable = false;
> +
>  

whitespace damage.

>  	/*
>  	 * Ensure that there are not too many pages isolated from the LRU
> @@ -530,6 +532,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
>  		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
>  			cc->finished_update_migrate = true;
> +			skipped_unmovable = true;
>  			goto next_pageblock;
>  		}
>  

Minor nitpick, but it's also unreclaimable and isolate blocks that are
being skipped here. If you do another revision, consider rephrasing
s/unmovable/unsuitable/ where appropriate. It's fairly obvious from
context so if you decide not to, that's fine too.

> @@ -624,7 +627,7 @@ next_pageblock:
>  		spin_unlock_irqrestore(&zone->lru_lock, flags);
>  
>  	/* Update the pageblock-skip if the whole pageblock was scanned */
> -	if (low_pfn == end_pfn)
> +	if (low_pfn == end_pfn && !skipped_unmovable)
>  		update_pageblock_skip(cc, valid_page, nr_isolated, true);
>  

This comment is now out of date. If the comment gets updated then feel
free to add

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
