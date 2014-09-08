Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaIHIbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:31:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaIHIbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:31:35 -0400
Message-ID: <540D6961.8060209@suse.cz>
Date: Mon, 08 Sep 2014 10:31:29 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/4] mm/page_alloc: fix incorrect isolation behavior
 by rechecking migratetype
References: <1409040498-10148-1-git-send-email-iamjoonsoo.kim@lge.com> <1409040498-10148-2-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1409040498-10148-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 10:08 AM, Joonsoo Kim wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f86023b..51e0d13 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -740,9 +740,15 @@ static void free_one_page(struct zone *zone,
>   	if (nr_scanned)
>   		__mod_zone_page_state(zone, NR_PAGES_SCANNED, -nr_scanned);
>
> +	if (unlikely(has_isolate_pageblock(zone))) {
> +		migratetype = get_pfnblock_migratetype(page, pfn);
> +		if (is_migrate_isolate(migratetype))
> +			goto skip_counting;
> +	}
> +	__mod_zone_freepage_state(zone, 1 << order, migratetype);
> +
> +skip_counting:

Here, wouldn't a simple 'else __mod_zone_freepage_state...' look better 
than goto + label? (same for the following 2 patches). Or does that 
generate worse code?

>   	__free_one_page(page, pfn, zone, order, migratetype);
> -	if (unlikely(!is_migrate_isolate(migratetype)))
> -		__mod_zone_freepage_state(zone, 1 << order, migratetype);
>   	spin_unlock(&zone->lock);
>   }
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index d1473b2..1fa4a4d 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -60,6 +60,7 @@ out:
>   		int migratetype = get_pageblock_migratetype(page);
>
>   		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
> +		zone->nr_isolate_pageblock++;
>   		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
>
>   		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
> @@ -83,6 +84,7 @@ void unset_migratetype_isolate(struct page *page, unsigned migratetype)
>   	nr_pages = move_freepages_block(zone, page, migratetype);
>   	__mod_zone_freepage_state(zone, nr_pages, migratetype);
>   	set_pageblock_migratetype(page, migratetype);
> +	zone->nr_isolate_pageblock--;
>   out:
>   	spin_unlock_irqrestore(&zone->lock, flags);
>   }
>

