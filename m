Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaFJHLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:11:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbaFJHLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:11:10 -0400
Message-ID: <5396AF88.4060703@suse.cz>
Date: Tue, 10 Jun 2014 09:11:04 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 02/10] mm, compaction: report compaction as contended
 only due to lock contention
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-2-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406091647140.17705@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406091647140.17705@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 01:50 AM, David Rientjes wrote:
> On Mon, 9 Jun 2014, Vlastimil Babka wrote:
>
>> Async compaction aborts when it detects zone lock contention or need_resched()
>> is true. David Rientjes has reported that in practice, most direct async
>> compactions for THP allocation abort due to need_resched(). This means that a
>> second direct compaction is never attempted, which might be OK for a page
>> fault, but hugepaged is intended to attempt a sync compaction in such case and
>> in these cases it won't.
>>
>> This patch replaces "bool contended" in compact_control with an enum that
>> distinguieshes between aborting due to need_resched() and aborting due to lock
>> contention. This allows propagating the abort through all compaction functions
>> as before, but declaring the direct compaction as contended only when lock
>> contantion has been detected.
>>
>> As a result, hugepaged will proceed with second sync compaction as intended,
>> when the preceding async compaction aborted due to need_resched().
>>
>
> s/hugepaged/khugepaged/ on the changelog.
>
>> Reported-by: David Rientjes <rientjes@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
>> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> ---
>>   mm/compaction.c | 20 ++++++++++++++------
>>   mm/internal.h   | 15 +++++++++++----
>>   2 files changed, 25 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index b73b182..d37f4a8 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -185,9 +185,14 @@ static void update_pageblock_skip(struct compact_control *cc,
>>   }
>>   #endif /* CONFIG_COMPACTION */
>>
>> -static inline bool should_release_lock(spinlock_t *lock)
>> +enum compact_contended should_release_lock(spinlock_t *lock)
>>   {
>> -	return need_resched() || spin_is_contended(lock);
>> +	if (need_resched())
>> +		return COMPACT_CONTENDED_SCHED;
>> +	else if (spin_is_contended(lock))
>> +		return COMPACT_CONTENDED_LOCK;
>> +	else
>> +		return COMPACT_CONTENDED_NONE;
>>   }
>>
>>   /*
>
> I think eventually we're going to remove the need_resched() heuristic
> entirely and so enum compact_contended might be overkill, but do we need
> to worry about spin_is_contended(lock) && need_resched() reporting
> COMPACT_CONTENDED_SCHED here instead of COMPACT_CONTENDED_LOCK?

Hm right, maybe I should reorder the two tests.

>> @@ -202,7 +207,9 @@ static inline bool should_release_lock(spinlock_t *lock)
>>   static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
>>   				      bool locked, struct compact_control *cc)
>>   {
>> -	if (should_release_lock(lock)) {
>> +	enum compact_contended contended = should_release_lock(lock);
>> +
>> +	if (contended) {
>>   		if (locked) {
>>   			spin_unlock_irqrestore(lock, *flags);
>>   			locked = false;
>> @@ -210,7 +217,7 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
>>
>>   		/* async aborts if taking too long or contended */
>>   		if (cc->mode == MIGRATE_ASYNC) {
>> -			cc->contended = true;
>> +			cc->contended = contended;
>>   			return false;
>>   		}
>>
>> @@ -236,7 +243,7 @@ static inline bool compact_should_abort(struct compact_control *cc)
>>   	/* async compaction aborts if contended */
>>   	if (need_resched()) {
>>   		if (cc->mode == MIGRATE_ASYNC) {
>> -			cc->contended = true;
>> +			cc->contended = COMPACT_CONTENDED_SCHED;
>>   			return true;
>>   		}
>>
>> @@ -1095,7 +1102,8 @@ static unsigned long compact_zone_order(struct zone *zone, int order,
>>   	VM_BUG_ON(!list_empty(&cc.freepages));
>>   	VM_BUG_ON(!list_empty(&cc.migratepages));
>>
>> -	*contended = cc.contended;
>> +	/* We only signal lock contention back to the allocator */
>> +	*contended = cc.contended == COMPACT_CONTENDED_LOCK;
>>   	return ret;
>>   }
>>
>
> Hmm, since the only thing that matters for cc->contended is
> COMPACT_CONTENDED_LOCK, it may make sense to just leave this as a bool
> within struct compact_control instead of passing the actual reason around
> when it doesn't matter.

That's what I thought first. But we set cc->contended in 
isolate_freepages_block() and then check it in isolate_freepages() and 
compaction_alloc() to make sure we don't continue the free scanner once 
contention (or need_resched()) is detected. And introducing an enum, 
even if temporary measure, seemed simpler than making that checking more 
complex. This way it can stay the same once we get rid of need_resched().

>> diff --git a/mm/internal.h b/mm/internal.h
>> index 7f22a11f..4659e8e 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -117,6 +117,13 @@ extern int user_min_free_kbytes;
>>
>>   #if defined CONFIG_COMPACTION || defined CONFIG_CMA
>>
>> +/* Used to signal whether compaction detected need_sched() or lock contention */
>> +enum compact_contended {
>> +	COMPACT_CONTENDED_NONE = 0, /* no contention detected */
>> +	COMPACT_CONTENDED_SCHED,    /* need_sched() was true */
>> +	COMPACT_CONTENDED_LOCK,     /* zone lock or lru_lock was contended */
>> +};
>> +
>>   /*
>>    * in mm/compaction.c
>>    */
>> @@ -144,10 +151,10 @@ struct compact_control {
>>   	int order;			/* order a direct compactor needs */
>>   	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
>>   	struct zone *zone;
>> -	bool contended;			/* True if a lock was contended, or
>> -					 * need_resched() true during async
>> -					 * compaction
>> -					 */
>> +	enum compact_contended contended; /* Signal need_sched() or lock
>> +					   * contention detected during
>> +					   * compaction
>> +					   */
>>   };
>>
>>   unsigned long

