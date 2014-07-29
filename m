Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaG2Pen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:34:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaG2Pem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:34:42 -0400
Message-ID: <53D7BF0D.5050404@suse.cz>
Date: Tue, 29 Jul 2014 17:34:37 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 14/14] mm, compaction: try to capture the just-created
 high-order freepage
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-15-git-send-email-vbabka@suse.cz> <20140729073456.GC1610@js1304-P5Q-DELUXE>
In-Reply-To: <20140729073456.GC1610@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 09:34 AM, Joonsoo Kim wrote:
> I don't look at it in detail, but, it looks really duplicated and hard
> to maintain. From my experience, this is really error-prone. Please
> think of freepage counting bugs reported by my recent patchset.
> Freepage counting handles counting at different places for performance reason
> and finally bugs are there. IMHO, making common function and using it
> is better than this approach even if we touch the fastpath.

OK, so opposite opinion than Minchan's :)

> Could you separate this patch to this patchset?
> I think that this patch doesn't get much reviewed from other developers
> unlike other patches.

Yeah I will.

>> @@ -570,6 +572,14 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>   	unsigned long flags;
>>   	bool locked = false;
>>   	struct page *page = NULL, *valid_page = NULL;
>> +	unsigned long capture_pfn = 0;   /* current candidate for capturing */
>> +	unsigned long next_capture_pfn = 0; /* next candidate for capturing */
>> +
>> +	if (cc->order > 0 && cc->order <= pageblock_order && capture) {
>> +		/* This may be outside the zone, but we check that later */
>> +		capture_pfn = low_pfn & ~((1UL << cc->order) - 1);
>> +		next_capture_pfn = ALIGN(low_pfn + 1, (1UL << cc->order));
>> +	}
>
> Instead of inserting capture logic to common code (compaction and
> CMA), could you add it only to compaction code such as
> isolate_migratepages(). Capture logic needs too many hooks as you see
> on below snippets. And it makes code so much complicated.

Could do it in isolate_migratepages() for whole pageblocks only (as 
David's patch did), but that restricts the usefulness. Or maybe do it 
fine grained by calling isolate_migratepages_block() multiple times. But 
the overhead of multiple calls would probably suck even more for 
lower-order compactions. For CMA the added overhead is basically only 
checks for next_capture_pfn that will be always false, so predictable. 
And mostly just in branches where isolation is failing, which is not the 
CMA's "fast path" I guess?

But I see you're talking about "complicated", not overhead. Well it's 4 
hunks inside the isolate_migratepages_block() for loop. I don't think 
it's *that* bad, thanks to how the function was cleaned up by the 
previosu patches.
Hmm but you made me realize I could make it nicer by doing a "goto 
isolation_fail" which would handle the next_capture_pfn update at a 
single place.

>> +static bool compact_capture_page(struct compact_control *cc)
>> +{
>> +	struct page *page = *cc->capture_page;
>> +	int cpu;
>> +
>> +	if (!page)
>> +		return false;
>> +
>> +	/* Unsafe check if it's worth to try acquiring the zone->lock at all */
>> +	if (PageBuddy(page) && page_order_unsafe(page) >= cc->order)
>> +		goto try_capture;
>> +
>> +	/*
>> +	 * There's a good chance that we have just put free pages on this CPU's
>> +	 * lru cache and pcplists after the page migrations. Drain them to
>> +	 * allow merging.
>> +	 */
>> +	cpu = get_cpu();
>> +	lru_add_drain_cpu(cpu);
>> +	drain_local_pages(NULL);
>> +	put_cpu();
>
> Just for curiosity.
>
> If lru_add_drain_cpu() is cheap enough to capture high order page, why
> __alloc_pages_direct_compact() doesn't call it before
> get_page_from_freelist()?

No idea. I guess it wasn't noticed at the time that page migration uses 
putback_lru_page() on the page that was freed, which puts it into the 
lru_add cache, only to be freed. I think it would be better to free the 
page immediately in this case, and use lru_add cache only for pages that 
will really go to lru.

Heck, it could be even better to tell page migration to skip pcplists as 
well, to avoid drain_local_pages. Often you migrate because you want to 
use the original page for something. NUMA balancing migrations are 
different, I guess.

>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1489,9 +1489,11 @@ static int __isolate_free_page(struct page *page, unsigned int order)
>>   {
>>   	unsigned long watermark;
>>   	struct zone *zone;
>> +	struct free_area *area;
>>   	int mt;
>> +	unsigned int freepage_order = page_order(page);
>>
>> -	BUG_ON(!PageBuddy(page));
>> +	VM_BUG_ON_PAGE((!PageBuddy(page) || freepage_order < order), page);
>>
>>   	zone = page_zone(page);
>>   	mt = get_pageblock_migratetype(page);
>> @@ -1506,9 +1508,12 @@ static int __isolate_free_page(struct page *page, unsigned int order)
>>   	}
>>
>
> In __isolate_free_page(), we check zone_watermark_ok() with order 0.
> But normal allocation logic would check zone_watermark_ok() with requested
> order. Your capture logic uses __isolate_free_page() and it would
> affect compaction success rate significantly. And it means that
> capture logic allocates high order page on page allocator
> too aggressively compared to other component such as normal high order

It's either that, or the extra lru drain that makes the different. But 
the "aggressiveness" would in fact mean better accuracy. Watermark 
checking may be inaccurate. Especially when memory is close to the 
watermark and there is only a single high-order page that would satisfy 
the allocation.

> allocation. Could you test this patch again after changing order for
> zone_watermark_ok() in __isolate_free_page()?

I can do that. If that makes capture significantly worse, it just 
highlights the watermark checking inaccuracy.

> Thanks.
>

