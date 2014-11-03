Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaKCIfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:35:10 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:40215 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKCIfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:35:03 -0500
MIME-Version: 1.0
In-Reply-To: <54573B3B.4070500@samsung.com>
References: <1414740330-4086-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1414740330-4086-3-git-send-email-iamjoonsoo.kim@lge.com> <54573B3B.4070500@samsung.com>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 3 Nov 2014 16:34:22 +0800
Message-ID: <CANFwon34x0JyLRXRH7yit_2BHbx-2u73tObB6GKQ-h8qgT+=pg@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/page_alloc: add freepage on isolate pageblock
 to correct buddy list
To: Heesub Shin <heesub.shin@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Gioh Kim <gioh.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 4:22 PM, Heesub Shin <heesub.shin@samsung.com> wrote:
> Hello,
>
>
> On 10/31/2014 04:25 PM, Joonsoo Kim wrote:
>>
>> In free_pcppages_bulk(), we use cached migratetype of freepage
>> to determine type of buddy list where freepage will be added.
>> This information is stored when freepage is added to pcp list, so
>> if isolation of pageblock of this freepage begins after storing,
>> this cached information could be stale. In other words, it has
>> original migratetype rather than MIGRATE_ISOLATE.
>>
>> There are two problems caused by this stale information. One is that
>> we can't keep these freepages from being allocated. Although this
>> pageblock is isolated, freepage will be added to normal buddy list
>> so that it could be allocated without any restriction. And the other
>> problem is incorrect freepage accounting. Freepages on isolate pageblock
>> should not be counted for number of freepage.
>>
>> Following is the code snippet in free_pcppages_bulk().
>>
>> /* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
>> __free_one_page(page, page_to_pfn(page), zone, 0, mt);
>> trace_mm_page_pcpu_drain(page, 0, mt);
>> if (likely(!is_migrate_isolate_page(page))) {
>>         __mod_zone_page_state(zone, NR_FREE_PAGES, 1);
>>         if (is_migrate_cma(mt))
>>                 __mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
>> }
>>
>> As you can see above snippet, current code already handle second problem,
>> incorrect freepage accounting, by re-fetching pageblock migratetype
>> through is_migrate_isolate_page(page). But, because this re-fetched
>> information isn't used for __free_one_page(), first problem would not be
>> solved. This patch try to solve this situation to re-fetch pageblock
>> migratetype before __free_one_page() and to use it for __free_one_page().
>>
>> In addition to move up position of this re-fetch, this patch use
>> optimization technique, re-fetching migratetype only if there is
>> isolate pageblock. Pageblock isolation is rare event, so we can
>> avoid re-fetching in common case with this optimization.
>>
>> This patch also correct migratetype of the tracepoint output.
>>
>> Cc: <stable@vger.kernel.org>
>> Acked-by: Minchan Kim <minchan@kernel.org>
>> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> ---
>>   mm/page_alloc.c |   13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index f7a867e..6df23fe 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -725,14 +725,17 @@ static void free_pcppages_bulk(struct zone *zone,
>> int count,
>>                         /* must delete as __free_one_page list manipulates
>> */
>>                         list_del(&page->lru);
>>                         mt = get_freepage_migratetype(page);
>> +                       if (unlikely(has_isolate_pageblock(zone))) {
>
>
> How about adding an additional check for 'mt == MIGRATE_MOVABLE' here? Then,
> most of get_pageblock_migratetype() calls could be avoided while the
> isolation is in progress. I am not sure this is the case on memory
> offlining. How do you think?

I think the reason is that this "mt" may be not the right value of this page.
It is set without zone->lock.

Thanks,
Hui

>
>> +                               mt = get_pageblock_migratetype(page);
>> +                               if (is_migrate_isolate(mt))
>> +                                       goto skip_counting;
>> +                       }
>> +                       __mod_zone_freepage_state(zone, 1, mt);
>> +
>> +skip_counting:
>>                         /* MIGRATE_MOVABLE list may include
>> MIGRATE_RESERVEs */
>>                         __free_one_page(page, page_to_pfn(page), zone, 0,
>> mt);
>>                         trace_mm_page_pcpu_drain(page, 0, mt);
>> -                       if (likely(!is_migrate_isolate_page(page))) {
>> -                               __mod_zone_page_state(zone, NR_FREE_PAGES,
>> 1);
>> -                               if (is_migrate_cma(mt))
>> -                                       __mod_zone_page_state(zone,
>> NR_FREE_CMA_PAGES, 1);
>> -                       }
>>                 } while (--to_free && --batch_free && !list_empty(list));
>>         }
>>         spin_unlock(&zone->lock);
>>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
