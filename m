Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbaHGNtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:49:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbaHGNtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:49:21 -0400
Message-ID: <53E383DD.6090500@suse.cz>
Date: Thu, 07 Aug 2014 15:49:17 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
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
Subject: Re: [PATCH v2 2/8] mm/isolation: remove unstable check for isolated
 page
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com> <1407309517-3270-4-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1407309517-3270-4-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 09:18 AM, Joonsoo Kim wrote:
> The check '!PageBuddy(page) && page_count(page) == 0 &&
> migratetype == MIGRATE_ISOLATE' would mean the page on free processing.

What is "the page on free processing"? I thought this test means the 
page is on some CPU's pcplist?

> Although it could go into buddy allocator within a short time,
> futher operation such as isolate_freepages_range() in CMA, called after
> test_page_isolated_in_pageblock(), could be failed due to this unstability

By "unstability" you mean the page can be allocated again from the 
pcplist instead of being freed to buddy list?

> since it requires that the page is on buddy. I think that removing
> this unstability is good thing.
>
> And, following patch makes isolated freepage has new status matched with
> this condition and this check is the obstacle to that change. So remove
> it.

You could also say that pages from isolated pageblocks can no longer 
appear on pcplists after the later patches.

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>   mm/page_isolation.c |    6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index d1473b2..3100f98 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -198,11 +198,7 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
>   						MIGRATE_ISOLATE);
>   			}
>   			pfn += 1 << page_order(page);
> -		}
> -		else if (page_count(page) == 0 &&
> -			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
> -			pfn += 1;
> -		else if (skip_hwpoisoned_pages && PageHWPoison(page)) {
> +		} else if (skip_hwpoisoned_pages && PageHWPoison(page)) {
>   			/*
>   			 * The HWPoisoned page may be not in buddy
>   			 * system, and page_count() is not 0.
>

