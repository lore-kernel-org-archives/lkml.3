Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaG2JMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:12:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbaG2JMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:12:53 -0400
Message-ID: <53D76592.10105@suse.cz>
Date: Tue, 29 Jul 2014 11:12:50 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 02/14] mm, compaction: defer each zone individually
 instead of preferred zone
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-3-git-send-email-vbabka@suse.cz> <20140729063840.GA1610@js1304-P5Q-DELUXE>
In-Reply-To: <20140729063840.GA1610@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 08:38 AM, Joonsoo Kim wrote:
>>   /* Return values for compact_zone() and try_to_compact_pages() */
>> +/* compaction didn't start as it was deferred due to past failures */
>> +#define COMPACT_DEFERRED	0
>>   /* compaction didn't start as it was not possible or direct reclaim was more suitable */
>> -#define COMPACT_SKIPPED		0
>> +#define COMPACT_SKIPPED		1
>
> Hello,
>
> This change makes some users of compaction_suitable() failed
> unintentionally, because they assume that COMPACT_SKIPPED is 0.
> Please fix them according to this change.

Oops, good catch. Thanks!

>> @@ -2324,27 +2327,31 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>>   				order, zonelist, high_zoneidx,
>>   				alloc_flags & ~ALLOC_NO_WATERMARKS,
>>   				preferred_zone, classzone_idx, migratetype);
>> +
>>   		if (page) {
>> -			preferred_zone->compact_blockskip_flush = false;
>> -			compaction_defer_reset(preferred_zone, order, true);
>> +			struct zone *zone = page_zone(page);
>> +
>> +			zone->compact_blockskip_flush = false;
>> +			compaction_defer_reset(zone, order, true);
>>   			count_vm_event(COMPACTSUCCESS);
>>   			return page;
>>   		}
>>
>>   		/*
>> +		 * last_compact_zone is where try_to_compact_pages thought
>> +		 * allocation should succeed, so it did not defer compaction.
>> +		 * But now we know that it didn't succeed, so we do the defer.
>> +		 */
>> +		if (last_compact_zone && mode != MIGRATE_ASYNC)
>> +			defer_compaction(last_compact_zone, order);
>
> I still don't understand why defer_compaction() is needed here.
> defer_compaction() is intended for not struggling doing compaction on
> the zone where we already have tried compaction and found that it
> isn't suitable for compaction. Allocation failure doesn't tell us
> that we have tried compaction for all the zone range so we shouldn't
> make a decision here to defer compaction on this zone carelessly.

OK I can remove that, it should make the code nicer anyway. I also agree 
with the argument "for all the zone range" and I also realized that it's 
not (both before and after this patch) really the case. I planned to fix 
that in the future, but I can probably do it now.
The plan is to call defer_compaction() only when compaction returned 
COMPACT_COMPLETE (and not COMPACT_PARTIAL) as it means the whole zone 
was scanned. Otherwise there will be bias towards the beginning of the 
zone in the migration scanner - compaction will be deferred half-way and 
then cached pfn's might be reset when it restarts, and the rest of the 
zone won't be scanned at all.

> Thanks.
>

