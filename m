Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3HAS70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:59:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47680 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3HAS7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:59:24 -0400
Message-ID: <51FAB000.9050407@linux.vnet.ibm.com>
Date: Thu, 01 Aug 2013 11:59:12 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Liujiang <jiang.liu@huawei.com>, Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        b.zolnierkie@samsung.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hotplug: fix a drain pcp bug when offline pages
References: <51FA2800.9070706@huawei.com>
In-Reply-To: <51FA2800.9070706@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080118-0320-0000-0000-00000084FC93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 02:18 AM, Xishi Qiu wrote:
> __offline_pages()
>     start_isolate_page_range()
>        set_migratetype_isolate()
>           set_pageblock_migratetype() -> this pageblock will be marked as MIGRATE_ISOLATE
>           move_freepages_block() -> pages in PageBuddy will be moved into MIGRATE_ISOLATE list
>           drain_all_pages() -> drain PCP
>              free_pcppages_bulk()
>                 mt = get_freepage_migratetype(page); -> PCP's migratetype is not MIGRATE_ISOLATE
>                 __free_one_page(page, zone, 0, mt); -> so PCP will not be freed into into MIGRATE_ISOLATE list
>
> In this case, the PCP may be allocated again, because they are not in
> PageBuddy's MIGRATE_ISOLATE list. This will cause offline_pages failed.
>
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>   mm/page_alloc.c     |   10 ++++++----
>   mm/page_isolation.c |   15 ++++++++++++++-
>   2 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b100255..d873471 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -965,11 +965,13 @@ int move_freepages(struct zone *zone,
>   		}
>
>   		order = page_order(page);
> -		list_move(&page->lru,
> -			  &zone->free_area[order].free_list[migratetype]);
> -		set_freepage_migratetype(page, migratetype);
> +		if (get_freepage_migratetype(page) != migratetype) {
> +			list_move(&page->lru,
> +				&zone->free_area[order].free_list[migratetype]);
> +			set_freepage_migratetype(page, migratetype);
> +			pages_moved += 1 << order;
> +		}
>   		page += 1 << order;
> -		pages_moved += 1 << order;

So this looks like it changes the return from move_freepages() to be the 
"pages moved" from "the pages now belonging to the passed migrate type".

The user of move_freepages_block()'s return value (and thus the return 
value of move_freepages()) in mm/page_alloc.c expects that it is the 
original meaning. The users in page_isolation.c expect it is the new 
meaning. Those need to be reconciled.

>   	}
>
>   	return pages_moved;
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 383bdbb..ba1afc9 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -65,8 +65,21 @@ out:
>   	}
>
>   	spin_unlock_irqrestore(&zone->lock, flags);
> -	if (!ret)
> +
> +	if (!ret) {
>   		drain_all_pages();
> +		/*
> +		 * When drain_all_pages() frees cached pages into the buddy
> +		 * system, it uses the stale migratetype cached in the
> +		 * page->index field, so try to move free pages to ISOLATE
> +		 * list again.
> +		 */
> +		spin_lock_irqsave(&zone->lock, flags);
> +		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
> +		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
> +		spin_unlock_irqrestore(&zone->lock, flags);
> +	}
> +

Could we teach drain_all_pages() to use the right migrate type instead 
(or add something similar that does)? (pages could be reallocated 
between the drain_all_pages() and move_freepages_block()).

>   	return ret;
>   }
>

