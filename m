Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3FDFBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:01:07 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49150 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3FDFBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:01:06 -0400
X-AuditID: 9c93017d-b7c04ae00000207d-dd-51ad748faf7b
Date: Tue, 4 Jun 2013 14:01:03 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v5][PATCH 5/6] mm: vmscan: batch shrink_page_list() locking
 operations
Message-ID: <20130604050103.GC14719@blaptop>
References: <20130603200202.7F5FDE07@viggo.jf.intel.com>
 <20130603200208.6F71D31F@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603200208.6F71D31F@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:02:08PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> changes for v2:
>  * remove batch_has_same_mapping() helper.  A local varible makes
>    the check cheaper and cleaner
>  * Move batch draining later to where we already know
>    page_mapping().  This probably fixes a truncation race anyway
>  * rename batch_for_mapping_removal -> batch_for_mapping_rm.  It
>    caused a line over 80 chars and needed shortening anyway.
>  * Note: we only set 'batch_mapping' when there are pages in the
>    batch_for_mapping_rm list
> 
> --
> 
> We batch like this so that several pages can be freed with a
> single mapping->tree_lock acquisition/release pair.  This reduces
> the number of atomic operations and ensures that we do not bounce
> cachelines around.
> 
> Tim Chen's earlier version of these patches just unconditionally
> created large batches of pages, even if they did not share a
> page_mapping().  This is a bit suboptimal for a few reasons:
> 1. if we can not consolidate lock acquisitions, it makes little
>    sense to batch
> 2. The page locks are held for long periods of time, so we only
>    want to do this when we are sure that we will gain a
>    substantial throughput improvement because we pay a latency
>    cost by holding the locks.
> 
> This patch makes sure to only batch when all the pages on
> 'batch_for_mapping_rm' continue to share a page_mapping().
> This only happens in practice in cases where pages in the same
> file are close to each other on the LRU.  That seems like a
> reasonable assumption.
> 
> In a 128MB virtual machine doing kernel compiles, the average
> batch size when calling __remove_mapping_batch() is around 5,
> so this does seem to do some good in practice.
> 
> On a 160-cpu system doing kernel compiles, I still saw an
> average batch length of about 2.8.  One promising feature:
> as the memory pressure went up, the average batches seem to
> have gotten larger.
> 
> It has shown some substantial performance benefits on
> microbenchmarks.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Mel Gorman <mgorman@suse.de>

Look at below comment, otherwise, looks good to me.

Reviewed-by: Minchan Kim <minchan@kernel.org>

> ---
> 
>  linux.git-davehans/mm/vmscan.c |   95 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 86 insertions(+), 9 deletions(-)
> 
> diff -puN mm/vmscan.c~create-remove_mapping_batch mm/vmscan.c
> --- linux.git/mm/vmscan.c~create-remove_mapping_batch	2013-06-03 12:41:31.408751324 -0700
> +++ linux.git-davehans/mm/vmscan.c	2013-06-03 12:41:31.412751500 -0700
> @@ -550,6 +550,61 @@ int remove_mapping(struct address_space
>  	return 0;
>  }
>  
> +/*
> + * pages come in here (via remove_list) locked and leave unlocked
> + * (on either ret_pages or free_pages)
> + *
> + * We do this batching so that we free batches of pages with a
> + * single mapping->tree_lock acquisition/release.  This optimization
> + * only makes sense when the pages on remove_list all share a
> + * page_mapping().  If this is violated you will BUG_ON().
> + */
> +static int __remove_mapping_batch(struct list_head *remove_list,
> +				  struct list_head *ret_pages,
> +				  struct list_head *free_pages)
> +{
> +	int nr_reclaimed = 0;
> +	struct address_space *mapping;
> +	struct page *page;
> +	LIST_HEAD(need_free_mapping);
> +
> +	if (list_empty(remove_list))
> +		return 0;
> +
> +	mapping = page_mapping(lru_to_page(remove_list));
> +	spin_lock_irq(&mapping->tree_lock);
> +	while (!list_empty(remove_list)) {
> +		page = lru_to_page(remove_list);
> +		BUG_ON(!PageLocked(page));
> +		BUG_ON(page_mapping(page) != mapping);
> +		list_del(&page->lru);
> +
> +		if (!__remove_mapping(mapping, page)) {
> +			unlock_page(page);
> +			list_add(&page->lru, ret_pages);
> +			continue;
> +		}
> +		list_add(&page->lru, &need_free_mapping);

Why do we need new lru list instead of using @free_pages?

> +	}
> +	spin_unlock_irq(&mapping->tree_lock);
> +
> +	while (!list_empty(&need_free_mapping)) {
> +		page = lru_to_page(&need_free_mapping);
> +		list_move(&page->list, free_pages);
> +		mapping_release_page(mapping, page);
> +		/*
> +		 * At this point, we have no other references and there is
> +		 * no way to pick any more up (removed from LRU, removed
> +		 * from pagecache). Can use non-atomic bitops now (and
> +		 * we obviously don't have to worry about waking up a process
> +		 * waiting on the page lock, because there are no references.
> +		 */
> +		__clear_page_locked(page);
> +		nr_reclaimed++;
> +	}
> +	return nr_reclaimed;
> +}
> +

-- 
Kind regards,
Minchan Kim
