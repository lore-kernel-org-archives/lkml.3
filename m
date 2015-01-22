Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbbAVPYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:24:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbbAVPYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:24:30 -0500
Message-ID: <54C1162C.8090802@suse.cz>
Date: Thu, 22 Jan 2015 16:24:28 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 4/5] mm, compaction: allow scanners to start at any
 pfn within the zone
References: <1421661920-4114-1-git-send-email-vbabka@suse.cz> <1421661920-4114-5-git-send-email-vbabka@suse.cz> <54BE71B6.8060709@gmail.com>
In-Reply-To: <54BE71B6.8060709@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 04:18 PM, Zhang Yanfei wrote:
> Hello Vlastimil
>
> 在 2015/1/19 18:05, Vlastimil Babka 写道:
>> Compaction employs two page scanners - migration scanner isolates pages to be
>> the source of migration, free page scanner isolates pages to be the target of
>> migration. Currently, migration scanner starts at the zone's first pageblock
>> and progresses towards the last one. Free scanner starts at the last pageblock
>> and progresses towards the first one. Within a pageblock, each scanner scans
>> pages from the first to the last one. When the scanners meet within the same
>> pageblock, compaction terminates.
>>
>> One consequence of the current scheme, that turns out to be unfortunate, is
>> that the migration scanner does not encounter the pageblocks which were
>> scanned by the free scanner. In a test with stress-highalloc from mmtests,
>> the scanners were observed to meet around the middle of the zone in first two
>> phases (with background memory pressure) of the test when executed after fresh
>> reboot. On further executions without reboot, the meeting point shifts to
>> roughly third of the zone, and compaction activity as well as allocation
>> success rates deteriorates compared to the run after fresh reboot.
>>
>> It turns out that the deterioration is indeed due to the migration scanner
>> processing only a small part of the zone. Compaction also keeps making this
>> bias worse by its activity - by moving all migratable pages towards end of the
>> zone, the free scanner has to scan a lot of full pageblocks to find more free
>> pages. The beginning of the zone contains pageblocks that have been compacted
>> as much as possible, but the free pages there cannot be further merged into
>> larger orders due to unmovable pages. The rest of the zone might contain more
>> suitable pageblocks, but the migration scanner will not reach them. It also
>> isn't be able to move movable pages out of unmovable pageblocks there, which
>> affects fragmentation.
>>
>> This patch is the first step to remove this bias. It allows the compaction
>> scanners to start at arbitrary pfn (aligned to pageblock for practical
>> purposes), called pivot, within the zone. The migration scanner starts at the
>> exact pfn, the free scanner starts at the pageblock preceding the pivot. The
>> direction of scanning is unaffected, but when the migration scanner reaches
>> the last pageblock of the zone, or the free scanner reaches the first
>> pageblock, they wrap and continue with the first or last pageblock,
>> respectively. Compaction terminates when any of the scanners wrap and both
>> meet within the same pageblock.
>>
>> For easier bisection of potential regressions, this patch always uses the
>> first zone's pfn as the pivot. That means the free scanner immediately wraps
>> to the last pageblock and the operation of scanners is thus unchanged. The
>> actual pivot changing is done by the next patch.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>
> I read through the whole patch, and you can feel free to add:
>
> Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Thanks.

> I agree with you and the approach to improve the current scheme. One thing
> I think should be carefully treated is how to avoid migrating back and forth
> since the pivot pfn can be changed. I see patch 5 has introduced a policy to
> change the pivot so we can have a careful observation on it.
>
> (The changes in the patch make the code more difficult to understand now...
> and I just find a tiny mistake, please see below)
>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
>> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: David Rientjes <rientjes@google.com>
>> ---
>>   include/linux/mmzone.h |   2 +
>>   mm/compaction.c        | 204 +++++++++++++++++++++++++++++++++++++++++++------
>>   mm/internal.h          |   1 +
>>   3 files changed, 182 insertions(+), 25 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 2f0856d..47aa181 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -503,6 +503,8 @@ struct zone {
>>   	unsigned long percpu_drift_mark;
>>
>>   #if defined CONFIG_COMPACTION || defined CONFIG_CMA
>> +	/* pfn where compaction scanners have initially started last time */
>> +	unsigned long		compact_cached_pivot_pfn;
>>   	/* pfn where compaction free scanner should start */
>>   	unsigned long		compact_cached_free_pfn;
>>   	/* pfn where async and sync compaction migration scanner should start */
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 5626220..abae89a 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -123,11 +123,16 @@ static inline bool isolation_suitable(struct compact_control *cc,
>>   	return !get_pageblock_skip(page);
>>   }
>>
>> +/*
>> + * Invalidate cached compaction scanner positions, so that compact_zone()
>> + * will reinitialize them on the next compaction.
>> + */
>>   static void reset_cached_positions(struct zone *zone)
>>   {
>> -	zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
>> -	zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
>> -	zone->compact_cached_free_pfn = zone_end_pfn(zone);
>> +	/* Invalid values are re-initialized in compact_zone */
>> +	zone->compact_cached_migrate_pfn[0] = 0;
>> +	zone->compact_cached_migrate_pfn[1] = 0;
>> +	zone->compact_cached_free_pfn = 0;
>>   }
>>
>>   /*
>> @@ -172,11 +177,35 @@ void reset_isolation_suitable(pg_data_t *pgdat)
>>   		/* Only flush if a full compaction finished recently */
>>   		if (zone->compact_blockskip_flush) {
>>   			__reset_isolation_suitable(zone);
>> -			reset_cached_positions(zone);
>> +			reset_cached_positions(zone, false);
>
> The second argument should be in patch 5 instead of here, right? ^-^

Yes, a mistake with some last-minute rebasing :)

> Thanks.
>

