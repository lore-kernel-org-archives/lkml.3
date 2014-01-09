Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaAIVKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:10:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33943 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbaAIVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:10:32 -0500
Message-ID: <52CF1045.30903@codeaurora.org>
Date: Thu, 09 Jan 2014 13:10:29 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, Andi Kleen <ak@linux.intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 2/7] mm/cma: fix cma free page accounting
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com> <1389251087-10224-3-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1389251087-10224-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2014 11:04 PM, Joonsoo Kim wrote:
> Cma pages can be allocated by not only order 0 request but also high order
> request. So, we should consider to account free cma page in the both
> places.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b36aa5a..1489c301 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1091,6 +1091,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>   							  start_migratetype,
>   							  migratetype);
>
> +			/* CMA pages cannot be stolen */
> +			if (is_migrate_cma(migratetype)) {
> +				__mod_zone_page_state(zone,
> +					NR_FREE_CMA_PAGES, -(1 << order));
> +			}
> +
>   			/* Remove the page from the freelists */
>   			list_del(&page->lru);
>   			rmv_page_order(page);
> @@ -1175,9 +1181,6 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>   		}
>   		set_freepage_migratetype(page, mt);
>   		list = &page->lru;
> -		if (is_migrate_cma(mt))
> -			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
> -					      -(1 << order));
>   	}
>   	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
>   	spin_unlock(&zone->lock);
>

Wouldn't this result in double counting? in the buffered_rmqueue non 
zero ordered request we call __mod_zone_freepage_state which already 
accounts for CMA pages if the migrate type is CMA so it seems like we 
would get hit twice:

buffered_rmqueue
    __rmqueue
        __rmqueue_fallback
            decrement
    __mod_zone_freepage_state
       decrement

Thanks,
Laura
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
