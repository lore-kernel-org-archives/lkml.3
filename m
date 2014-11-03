Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaKCIMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:12:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaKCIMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:12:38 -0500
Message-ID: <545738F1.4010307@suse.cz>
Date: Mon, 03 Nov 2014 09:12:33 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/5] mm, compaction: more focused lru and pcplists draining
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-6-git-send-email-vbabka@suse.cz> <20141027074112.GC23379@js1304-P5Q-DELUXE>
In-Reply-To: <20141027074112.GC23379@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 08:41 AM, Joonsoo Kim wrote:
> On Tue, Oct 07, 2014 at 05:33:39PM +0200, Vlastimil Babka wrote:
>> The goal of memory compaction is to create high-order freepages through page
>> migration. Page migration however puts pages on the per-cpu lru_add cache,
>> which is later flushed to per-cpu pcplists, and only after pcplists are
>> drained the pages can actually merge. This can happen due to the per-cpu
>> caches becoming full through further freeing, or explicitly.
>>
>> During direct compaction, it is useful to do the draining explicitly so that
>> pages merge as soon as possible and compaction can detect success immediately
>> and keep the latency impact at minimum. However the current implementation is
>> far from ideal. Draining is done only in  __alloc_pages_direct_compact(),
>> after all zones were already compacted, and the decisions to continue or stop
>> compaction in individual zones was done without the last batch of migrations
>> being merged. It is also missing the draining of lru_add cache before the
>> pcplists.
>>
>> This patch moves the draining for direct compaction into compact_zone(). It
>> adds the missing lru_cache draining and uses the newly introduced single zone
>> pcplists draining to reduce overhead and avoid impact on unrelated zones.
>> Draining is only performed when it can actually lead to merging of a page of
>> desired order (passed by cc->order). This means it is only done when migration
>> occurred in the previously scanned cc->order aligned block(s) and the
>> migration scanner is now pointing to the next cc->order aligned block.
>>
>> The patch has been tested with stress-highalloc benchmark from mmtests.
>> Although overal allocation success rates of the benchmark were not affected,
>> the number of detected compaction successes has doubled. This suggests that
>> allocations were previously successful due to implicit merging caused by
>> background activity, making a later allocation attempt succeed immediately,
>> but not attributing the success to compaction. Since stress-highalloc always
>> tries to allocate almost the whole memory, it cannot show the improvement in
>> its reported success rate metric. However after this patch, compaction should
>> detect success and terminate earlier, reducing the direct compaction latencies
>> in a real scenario.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
>> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: David Rientjes <rientjes@google.com>
>> ---
>>   mm/compaction.c | 41 ++++++++++++++++++++++++++++++++++++++++-
>>   mm/page_alloc.c |  4 ----
>>   2 files changed, 40 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 8fa888d..41b49d7 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1179,6 +1179,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>>   	while ((ret = compact_finished(zone, cc, migratetype)) ==
>>   						COMPACT_CONTINUE) {
>>   		int err;
>> +		unsigned long last_migrated_pfn = 0;
>
> I think that this definition looks odd.
> In every iteration, last_migrated_pfn is re-defined as 0.
> Maybe, it is on outside of the loop.

Oops you're right, that's a mistake and it makes the code miss some of 
the drain points (a minority I think but anyway).

>>
>>   		switch (isolate_migratepages(zone, cc)) {
>>   		case ISOLATE_ABORT:
>> @@ -1187,7 +1188,12 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>>   			cc->nr_migratepages = 0;
>>   			goto out;
>>   		case ISOLATE_NONE:
>> -			continue;
>> +			/*
>> +			 * We haven't isolated and migrated anything, but
>> +			 * there might still be unflushed migrations from
>> +			 * previous cc->order aligned block.
>> +			 */
>> +			goto check_drain;
>>   		case ISOLATE_SUCCESS:
>>   			;
>>   		}
>> @@ -1212,6 +1218,39 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>>   				goto out;
>>   			}
>>   		}
>> +
>> +		/*
>> +		 * Record where we have freed pages by migration and not yet
>> +		 * flushed them to buddy allocator. Subtract 1, because often
>> +		 * we finish a pageblock and migrate_pfn points to the first
>> +		 * page* of the next one. In that case we want the drain below
>> +		 * to happen immediately.
>> +		 */
>> +		if (!last_migrated_pfn)
>> +			last_migrated_pfn = cc->migrate_pfn - 1;
>
> And, I wonder why last_migrated_pfn is set after isolate_migratepages().

Not sure I understand your question. With the mistake above, it cannot 
currently be set at the point isolate_migratepages() is called, so you 
might question the goto check_drain in the ISOLATE_NONE case, if that's 
what you are wondering about.

When I correct that, it might be set when COMPACT_CLUSTER_MAX pages are 
isolated and migrated the middle of a pageblock, and then the rest of 
the pageblock contains no pages that could be isolated, so the last 
isolate_migratepages() attempt in the pageblock returns with 
ISOLATE_NONE. Still there were some migrations that produced free pages 
that should be drained at that point.

>
> Thanks.
>

