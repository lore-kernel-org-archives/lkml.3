Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaG2J1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:27:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaG2J1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:27:43 -0400
Message-ID: <53D7690D.5070307@suse.cz>
Date: Tue, 29 Jul 2014 11:27:41 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 05/14] mm, compaction: move pageblock checks up from
 isolate_migratepages_range()
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-6-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1407281709050.8998@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407281709050.8998@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:29 AM, David Rientjes wrote:
> On Mon, 28 Jul 2014, Vlastimil Babka wrote:
>
>> isolate_migratepages_range() is the main function of the compaction scanner,
>> called either on a single pageblock by isolate_migratepages() during regular
>> compaction, or on an arbitrary range by CMA's __alloc_contig_migrate_range().
>> It currently perfoms two pageblock-wide compaction suitability checks, and
>> because of the CMA callpath, it tracks if it crossed a pageblock boundary in
>> order to repeat those checks.
>>
>> However, closer inspection shows that those checks are always true for CMA:
>> - isolation_suitable() is true because CMA sets cc->ignore_skip_hint to true
>> - migrate_async_suitable() check is skipped because CMA uses sync compaction
>>
>> We can therefore move the compaction-specific checks to isolate_migratepages()
>> and simplify isolate_migratepages_range(). Furthermore, we can mimic the
>> freepage scanner family of functions, which has isolate_freepages_block()
>> function called both by compaction from isolate_freepages() and by CMA from
>> isolate_freepages_range(), where each use-case adds own specific glue code.
>> This allows further code simplification.
>>
>> Therefore, we rename isolate_migratepages_range() to isolate_freepages_block()
>
> s/isolate_freepages_block/isolate_migratepages_block/
>
> I read your commit description before looking at the patch and was very
> nervous about the direction you were going if that was true :)  I'm
> relieved to see it was just a typo.

Ah, thanks :)

>> @@ -601,8 +554,11 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>>   		 */
>>   		if (PageTransHuge(page)) {
>>   			if (!locked)
>> -				goto next_pageblock;
>> -			low_pfn += (1 << compound_order(page)) - 1;
>> +				low_pfn = ALIGN(low_pfn + 1,
>> +						pageblock_nr_pages) - 1;
>> +			else
>> +				low_pfn += (1 << compound_order(page)) - 1;
>> +
>
> Hmm, any reason not to always advance and align low_pfn to
> pageblock_nr_pages?  I don't see how pageblock_order > HPAGE_PMD_ORDER
> would make sense if encountering thp.

I think PageTransHuge() might be true even for non-THP compound pages 
which might be actually of lower order and we wouldn't want to skip the 
whole pageblock.

>> @@ -680,15 +630,61 @@ next_pageblock:
>>   	return low_pfn;
>>   }
>>
>> +/**
>> + * isolate_migratepages_range() - isolate migrate-able pages in a PFN range
>> + * @start_pfn: The first PFN to start isolating.
>> + * @end_pfn:   The one-past-last PFN.
>
> Need to specify @cc?

OK.

>>
>>   /*
>> - * Isolate all pages that can be migrated from the block pointed to by
>> - * the migrate scanner within compact_control.
>> + * Isolate all pages that can be migrated from the first suitable block,
>> + * starting at the block pointed to by the migrate scanner pfn within
>> + * compact_control.
>>    */
>>   static isolate_migrate_t isolate_migratepages(struct zone *zone,
>>   					struct compact_control *cc)
>>   {
>>   	unsigned long low_pfn, end_pfn;
>> +	struct page *page;
>> +	const isolate_mode_t isolate_mode =
>> +		(cc->mode == MIGRATE_ASYNC ? ISOLATE_ASYNC_MIGRATE : 0);
>>
>> -	/* Do not scan outside zone boundaries */
>> -	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
>> +	/*
>> +	 * Start at where we last stopped, or beginning of the zone as
>> +	 * initialized by compact_zone()
>> +	 */
>> +	low_pfn = cc->migrate_pfn;
>>
>>   	/* Only scan within a pageblock boundary */
>>   	end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
>>
>> -	/* Do not cross the free scanner or scan within a memory hole */
>> -	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
>> -		cc->migrate_pfn = end_pfn;
>> -		return ISOLATE_NONE;
>> -	}
>> +	/*
>> +	 * Iterate over whole pageblocks until we find the first suitable.
>> +	 * Do not cross the free scanner.
>> +	 */
>> +	for (; end_pfn <= cc->free_pfn;
>> +			low_pfn = end_pfn, end_pfn += pageblock_nr_pages) {
>> +
>> +		/*
>> +		 * This can potentially iterate a massively long zone with
>> +		 * many pageblocks unsuitable, so periodically check if we
>> +		 * need to schedule, or even abort async compaction.
>> +		 */
>> +		if (!(low_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
>> +						&& compact_should_abort(cc))
>> +			break;
>> +
>> +		/* Skip whole pageblock in case of a memory hole */
>> +		if (!pfn_valid(low_pfn))
>> +			continue;
>> +
>> +		page = pfn_to_page(low_pfn);
>> +
>> +		/* If isolation recently failed, do not retry */
>> +		if (!isolation_suitable(cc, page))
>> +			continue;
>> +
>> +		/*
>> +		 * For async compaction, also only scan in MOVABLE blocks.
>> +		 * Async compaction is optimistic to see if the minimum amount
>> +		 * of work satisfies the allocation.
>> +		 */
>> +		if (cc->mode == MIGRATE_ASYNC &&
>> +		    !migrate_async_suitable(get_pageblock_migratetype(page)))
>> +			continue;
>> +
>> +		/* Perform the isolation */
>> +		low_pfn = isolate_migratepages_block(cc, low_pfn, end_pfn,
>> +								isolate_mode);
>
> Hmm, why would we want to unconditionally set pageblock_skip if no pages
> could be isolated from a pageblock when
> isolate_mode == ISOLATE_ASYNC_MIGRATE?  It seems like it erroneously skip
> pageblocks for cases when isolate_mode == 0.

Well pageblock_skip is a single bit and you don't know if the next 
attempt will be async or sync. So now you would maybe skip needlessly if 
the next attempt would be sync. If we changed that, you wouldn't skip if 
the next attempt would be async again. Could be that one way is better 
than other but I'm not sure, and would consider it separately.
The former patch 15 (quick skip pageblock that won't be fully migrated) 
could perhaps change the balance here.

But I hope this patch doesn't change this particular thing, right?

