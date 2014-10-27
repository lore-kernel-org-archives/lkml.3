Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaJ0KeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:34:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaJ0KeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:34:14 -0400
Message-ID: <544E1FA3.4000505@suse.cz>
Date: Mon, 27 Oct 2014 11:34:11 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/4] mm/page_alloc: add freepage on isolate pageblock
 to correct buddy list
References: <1414051821-12769-1-git-send-email-iamjoonsoo.kim@lge.com> <1414051821-12769-3-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1414051821-12769-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 10:10 AM, Joonsoo Kim wrote:
> In free_pcppages_bulk(), we use cached migratetype of freepage
> to determine type of buddy list where freepage will be added.
> This information is stored when freepage is added to pcp list, so
> if isolation of pageblock of this freepage begins after storing,
> this cached information could be stale. In other words, it has
> original migratetype rather than MIGRATE_ISOLATE.
> 
> There are two problems caused by this stale information. One is that
> we can't keep these freepages from being allocated. Although this
> pageblock is isolated, freepage will be added to normal buddy list
> so that it could be allocated without any restriction. And the other
> problem is incorrect freepage accounting. Freepages on isolate pageblock
> should not be counted for number of freepage.
> 
> Following is the code snippet in free_pcppages_bulk().
> 
> /* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
> __free_one_page(page, page_to_pfn(page), zone, 0, mt);
> trace_mm_page_pcpu_drain(page, 0, mt);
> if (likely(!is_migrate_isolate_page(page))) {
> 	__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
> 	if (is_migrate_cma(mt))
> 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
> }
> 
> As you can see above snippet, current code already handle second problem,
> incorrect freepage accounting, by re-fetching pageblock migratetype
> through is_migrate_isolate_page(page). But, because this re-fetched
> information isn't used for __free_one_page(), first problem would not be
> solved. This patch try to solve this situation to re-fetch pageblock
> migratetype before __free_one_page() and to use it for __free_one_page().
> 
> In addition to move up position of this re-fetch, this patch use
> optimization technique, re-fetching migratetype only if there is
> isolate pageblock. Pageblock isolation is rare event, so we can
> avoid re-fetching in common case with this optimization.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4a5d8e5..5d2f807 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -725,14 +725,17 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  			/* must delete as __free_one_page list manipulates */
>  			list_del(&page->lru);
>  			mt = get_freepage_migratetype(page);
> +			if (unlikely(has_isolate_pageblock(zone))) {
> +				mt = get_pageblock_migratetype(page);
> +				if (is_migrate_isolate(mt))
> +					goto skip_counting;
> +			}
> +			__mod_zone_freepage_state(zone, 1, mt);
> +
> +skip_counting:
>  			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
>  			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
>  			trace_mm_page_pcpu_drain(page, 0, mt);
> -			if (likely(!is_migrate_isolate_page(page))) {
> -				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
> -				if (is_migrate_cma(mt))
> -					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
> -			}
>  		} while (--to_free && --batch_free && !list_empty(list));
>  	}
>  	spin_unlock(&zone->lock);
> 

