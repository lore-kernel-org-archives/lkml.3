Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaH2QyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbaH2QyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:54:13 -0400
Date: Fri, 29 Aug 2014 12:52:44 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/4] mm/page_alloc: restrict max order of merging
 on isolated pageblock
Message-ID: <20140829165244.GA27127@nhori.bos.redhat.com>
References: <1409040498-10148-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1409040498-10148-5-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409040498-10148-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On Tue, Aug 26, 2014 at 05:08:18PM +0900, Joonsoo Kim wrote:
> Current pageblock isolation logic could isolate each pageblock
> individually. This causes freepage accounting problem if freepage with
> pageblock order on isolate pageblock is merged with other freepage on
> normal pageblock. We can prevent merging by restricting max order of
> merging to pageblock order if freepage is on isolate pageblock.
> 
> Side-effect of this change is that there could be non-merged buddy
> freepage even if finishing pageblock isolation, because undoing pageblock
> isolation is just to move freepage from isolate buddy list to normal buddy
> list rather than to consider merging. But, I think it doesn't matter
> because 1) almost allocation request are for equal or below pageblock
> order, 2) caller of pageblock isolation will use this freepage so
> freepage will split in any case and 3) merge would happen soon after
> some alloc/free on this and buddy pageblock.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  mm/page_alloc.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 809bfd3..8ba9fb0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -570,6 +570,7 @@ static inline void __free_one_page(struct page *page,
>  	unsigned long combined_idx;
>  	unsigned long uninitialized_var(buddy_idx);
>  	struct page *buddy;
> +	int max_order = MAX_ORDER;
>  
>  	VM_BUG_ON(!zone_is_initialized(zone));
>  
> @@ -580,18 +581,26 @@ static inline void __free_one_page(struct page *page,
>  	VM_BUG_ON(migratetype == -1);
>  	if (unlikely(has_isolate_pageblock(zone))) {
>  		migratetype = get_pfnblock_migratetype(page, pfn);
> -		if (is_migrate_isolate(migratetype))
> +		if (is_migrate_isolate(migratetype)) {
> +			/*
> +			 * We restrict max order of merging to prevent merge
> +			 * between freepages on isolate pageblock and normal
> +			 * pageblock. Without this, pageblock isolation
> +			 * could cause incorrect freepage accounting.
> +			 */
> +			max_order = pageblock_order + 1;

When pageblock_order >= max_order, order in the while loop below could
go beyond MAX_ORDER - 1. Or does it never happen?

Thanks,
Naoya Horiguchi

>  			goto skip_counting;
> +		}
>  	}
>  	__mod_zone_freepage_state(zone, 1 << order, migratetype);
>  
>  skip_counting:
> -	page_idx = pfn & ((1 << MAX_ORDER) - 1);
> +	page_idx = pfn & ((1 << max_order) - 1);
>  
>  	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
>  	VM_BUG_ON_PAGE(bad_range(zone, page), page);
>  
> -	while (order < MAX_ORDER-1) {
> +	while (order < max_order - 1) {
>  		buddy_idx = __find_buddy_index(page_idx, order);
>  		buddy = page + (buddy_idx - page_idx);
>  		if (!page_is_buddy(page, buddy, order))
> -- 
> 1.7.9.5
> 
> 
