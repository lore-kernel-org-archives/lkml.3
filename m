Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaG2JCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:02:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbaG2JCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:02:11 -0400
Message-ID: <53D76310.6000006@suse.cz>
Date: Tue, 29 Jul 2014 11:02:08 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 02/14] mm, compaction: defer each zone individually
 instead of preferred zone
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-3-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1407281649570.8998@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407281649570.8998@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 01:59 AM, David Rientjes wrote:
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1122,28 +1122,27 @@ int sysctl_extfrag_threshold = 500;
>>    * @nodemask: The allowed nodes to allocate from
>>    * @mode: The migration mode for async, sync light, or sync migration
>>    * @contended: Return value that is true if compaction was aborted due to lock contention
>> - * @page: Optionally capture a free page of the requested order during compaction
>
> Never noticed this non-existant formal before.

It's a leftover from the first Mel's page capture attempt that was 
partially reverted.

>> + * @candidate_zone: Return the zone where we think allocation should succeed
>>    *
>>    * This is the main entry point for direct page compaction.
>>    */
>>   unsigned long try_to_compact_pages(struct zonelist *zonelist,
>>   			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>> -			enum migrate_mode mode, bool *contended)
>> +			enum migrate_mode mode, bool *contended,
>> +			struct zone **candidate_zone)
>>   {
>>   	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>>   	int may_enter_fs = gfp_mask & __GFP_FS;
>>   	int may_perform_io = gfp_mask & __GFP_IO;
>>   	struct zoneref *z;
>>   	struct zone *zone;
>> -	int rc = COMPACT_SKIPPED;
>> +	int rc = COMPACT_DEFERRED;
>>   	int alloc_flags = 0;
>>
>>   	/* Check if the GFP flags allow compaction */
>>   	if (!order || !may_enter_fs || !may_perform_io)
>>   		return rc;
>>
>
> It doesn't seem right that if we called try_to_compact_pages() in a
> context where it is useless (order-0 or non-GFP_KERNEL allocation) that we
> would return COMPACT_DEFERRED.  I think the existing semantics before the
> patch, that is
>
>   - deferred: compaction was tried but failed, so avoid subsequent calls in
>     the near future that may be potentially expensive, and
>
>   - skipped: compaction wasn't tried because it will be useless
>
> is correct and deferred shouldn't take on another meaning, which now will
> set deferred_compaction == true in the page allocator.  It probably
> doesn't matter right now because the only check of deferred_compaction is
> effective for __GFP_NO_KSWAPD, i.e. it is both high-order and GFP_KERNEL,
> but it seems returning COMPACT_SKIPPED here would also work fine and be
> more appropriate.

You're right. That was an oversight, not intention. Thanks for catching 
that.

