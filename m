Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaG2JpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:45:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaG2JpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:45:22 -0400
Message-ID: <53D76D30.3000106@suse.cz>
Date: Tue, 29 Jul 2014 11:45:20 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1407281748110.8998@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407281748110.8998@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:59 AM, David Rientjes wrote:
> On Mon, 28 Jul 2014, Vlastimil Babka wrote:
>
>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>> index b2e4c92..60bdf8d 100644
>> --- a/include/linux/compaction.h
>> +++ b/include/linux/compaction.h
>> @@ -13,6 +13,14 @@
>>   /* The full zone was compacted */
>>   #define COMPACT_COMPLETE	4
>>
>> +/* Used to signal whether compaction detected need_sched() or lock contention */
>> +/* No contention detected */
>> +#define COMPACT_CONTENDED_NONE	0
>> +/* Either need_sched() was true or fatal signal pending */
>> +#define COMPACT_CONTENDED_SCHED	1
>> +/* Zone lock or lru_lock was contended in async compaction */
>> +#define COMPACT_CONTENDED_LOCK	2
>> +
>
> Make this an enum?

I tried originally, but then I would have to define it elsewhere 
(mm/internal.h I think) together with compact_control. I didn't think it 
was worth the extra pollution of shared header, when the return codes 
are also #define and we might still get rid of need_resched() one day.

>> @@ -223,9 +223,21 @@ static void update_pageblock_skip(struct compact_control *cc,
>>   }
>>   #endif /* CONFIG_COMPACTION */
>>
>> -static inline bool should_release_lock(spinlock_t *lock)
>> +static int should_release_lock(spinlock_t *lock)
>>   {
>> -	return need_resched() || spin_is_contended(lock);
>> +	/*
>> +	 * Sched contention has higher priority here as we may potentially
>> +	 * have to abort whole compaction ASAP. Returning with lock contention
>> +	 * means we will try another zone, and further decisions are
>> +	 * influenced only when all zones are lock contended. That means
>> +	 * potentially missing a lock contention is less critical.
>> +	 */
>> +	if (need_resched())
>> +		return COMPACT_CONTENDED_SCHED;
>> +	else if (spin_is_contended(lock))
>> +		return COMPACT_CONTENDED_LOCK;
>> +	else
>> +		return COMPACT_CONTENDED_NONE;
>
> I would avoid the last else statement and just return
> COMPACT_CONTENDED_NONE.

OK, checkpatch agrees.

>> @@ -1154,11 +1168,11 @@ static unsigned long compact_zone_order(struct zone *zone, int order,
>>   	INIT_LIST_HEAD(&cc.migratepages);
>>
>>   	ret = compact_zone(zone, &cc);
>> +	*contended = cc.contended;
>>
>>   	VM_BUG_ON(!list_empty(&cc.freepages));
>>   	VM_BUG_ON(!list_empty(&cc.migratepages));
>>
>> -	*contended = cc.contended;
>
> Not sure why, but ok :)

Oversight due to how this patch evolved :)

>>   	return ret;
>>   }
>>
>> @@ -1171,14 +1185,15 @@ int sysctl_extfrag_threshold = 500;
>>    * @gfp_mask: The GFP mask of the current allocation
>>    * @nodemask: The allowed nodes to allocate from
>>    * @mode: The migration mode for async, sync light, or sync migration
>> - * @contended: Return value that is true if compaction was aborted due to lock contention
>> + * @contended: Return value that determines if compaction was aborted due to
>> + *	       need_resched() or lock contention
>>    * @candidate_zone: Return the zone where we think allocation should succeed
>>    *
>>    * This is the main entry point for direct page compaction.
>>    */
>>   unsigned long try_to_compact_pages(struct zonelist *zonelist,
>>   			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>> -			enum migrate_mode mode, bool *contended,
>> +			enum migrate_mode mode, int *contended,
>>   			struct zone **candidate_zone)
>>   {
>>   	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>> @@ -1188,6 +1203,9 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>>   	struct zone *zone;
>>   	int rc = COMPACT_DEFERRED;
>>   	int alloc_flags = 0;
>> +	bool all_zones_lock_contended = true; /* init true for &= operation */
>> +
>> +	*contended = COMPACT_CONTENDED_NONE;
>>
>>   	/* Check if the GFP flags allow compaction */
>>   	if (!order || !may_enter_fs || !may_perform_io)
>> @@ -1201,13 +1219,20 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>>   	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
>>   								nodemask) {
>>   		int status;
>> +		int zone_contended;
>>
>>   		if (compaction_deferred(zone, order))
>>   			continue;
>>
>>   		status = compact_zone_order(zone, order, gfp_mask, mode,
>> -						contended);
>> +							&zone_contended);
>>   		rc = max(status, rc);
>> +		/*
>> +		 * It takes at least one zone that wasn't lock contended
>> +		 * to turn all_zones_lock_contended to false.
>> +		 */
>> +		all_zones_lock_contended &=
>> +			(zone_contended == COMPACT_CONTENDED_LOCK);
>
> Eek, does this always work?  COMPACT_CONTENDED_LOCK is 0x2 and

(zone_contended == COMPACT_CONTENDED_LOCK) is a bool so it should work?

> all_zones_lock_contended is a bool initialized to true.  I'm fairly
> certain you'd get better code generation if you defined
> all_zones_lock_contended as
>
> 	int all_zones_lock_contended = COMPACT_CONTENDED_LOCK
>
> from the start and the source code would be more clear.

Yeah that would look nicer, thanks for the suggestion.

>>
>>   		/* If a normal allocation would succeed, stop compacting */
>>   		if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0,
>> @@ -1220,8 +1245,20 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>>   			 * succeeds in this zone.
>>   			 */
>>   			compaction_defer_reset(zone, order, false);
>> -			break;
>> -		} else if (mode != MIGRATE_ASYNC) {
>> +			/*
>> +			 * It is possible that async compaction aborted due to
>> +			 * need_resched() and the watermarks were ok thanks to
>> +			 * somebody else freeing memory. The allocation can
>> +			 * however still fail so we better signal the
>> +			 * need_resched() contention anyway.
>> +			 */
>
> Makes sense because the page allocator still tries to allocate the page
> even if this is returned, but it's not very clear in the comment.

OK

>> @@ -2660,15 +2660,36 @@ rebalance:
>>   	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
>>   		migration_mode = MIGRATE_SYNC_LIGHT;
>>
>> -	/*
>> -	 * If compaction is deferred for high-order allocations, it is because
>> -	 * sync compaction recently failed. In this is the case and the caller
>> -	 * requested a movable allocation that does not heavily disrupt the
>> -	 * system then fail the allocation instead of entering direct reclaim.
>> -	 */
>> -	if ((deferred_compaction || contended_compaction) &&
>> -						(gfp_mask & __GFP_NO_KSWAPD))
>> -		goto nopage;
>
> Hmm, this check will have unfortunately changed in the latest mmotm due to
> mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch.

I think you were changing (and moving around) a different check so there 
would be merge conflicts but no semantic problem.

>> +	/* Checks for THP-specific high-order allocations */
>> +	if (gfp_mask & __GFP_NO_KSWAPD) {
>> +		/*
>> +		 * If compaction is deferred for high-order allocations, it is
>> +		 * because sync compaction recently failed. If this is the case
>> +		 * and the caller requested a THP allocation, we do not want
>> +		 * to heavily disrupt the system, so we fail the allocation
>> +		 * instead of entering direct reclaim.
>> +		 */
>> +		if (deferred_compaction)
>> +			goto nopage;
>> +
>> +		/*
>> +		 * In all zones where compaction was attempted (and not
>> +		 * deferred or skipped), lock contention has been detected.
>> +		 * For THP allocation we do not want to disrupt the others
>> +		 * so we fallback to base pages instead.
>> +		 */
>> +		if (contended_compaction == COMPACT_CONTENDED_LOCK)
>> +			goto nopage;
>> +
>> +		/*
>> +		 * If compaction was aborted due to need_resched(), we do not
>> +		 * want to further increase allocation latency, unless it is
>> +		 * khugepaged trying to collapse.
>> +		 */
>> +		if (contended_compaction == COMPACT_CONTENDED_SCHED
>> +			&& !(current->flags & PF_KTHREAD))
>> +			goto nopage;
>> +	}
>>
>>   	/* Try direct reclaim and then allocating */
>>   	page = __alloc_pages_direct_reclaim(gfp_mask, order,

