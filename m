Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaLVTdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:33:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbaLVTdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:33:33 -0500
Message-ID: <5498720D.5030702@suse.cz>
Date: Mon, 22 Dec 2014 20:33:33 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>, Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled
 process being killed
References: <1418994116-23665-1-git-send-email-vbabka@suse.cz> <20141219155747.GA31756@dhcp22.suse.cz> <20141219182815.GK18274@esperanza> <20141220104746.GB6306@dhcp22.suse.cz> <20141220141824.GM18274@esperanza> <20141222142435.GA2900@dhcp22.suse.cz> <20141222162558.GA21211@esperanza>
In-Reply-To: <20141222162558.GA21211@esperanza>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.12.2014 17:25, Vladimir Davydov wrote:
>
>>> E.g. suppose processes are
>>> governed by FIFO and kswapd happens to have a higher prio than the
>>> process killed by OOM. Then after cond_resched kswapd will be picked for
>>> execution again, and the killing process won't have a chance to remove
>>> itself from the wait queue.
>> Except that kswapd runs as SCHED_NORMAL with 0 priority.
>>
>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>> index 744e2b491527..2a123634c220 100644
>>>>> --- a/mm/vmscan.c
>>>>> +++ b/mm/vmscan.c
>>>>> @@ -2984,6 +2984,9 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
>>>>>   	if (remaining)
>>>>>   		return false;
>>>>>   
>>>>> +	if (!pgdat_balanced(pgdat, order, classzone_idx))
>>>>> +		return false;
>>>>> +
>>>> What would be consequences of not waking up pfmemalloc waiters while the
>>>> node is not balanced?
>>> They will get woken up a bit later in balanced_pgdat. This might result
>>> in latency spikes though. In order not to change the original behaviour
>>> we could always wake all pfmemalloc waiters no matter if we are going to
>>> sleep or not:
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 744e2b491527..a21e0bd563c3 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -2993,10 +2993,7 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
>>>   	 * so wake them now if necessary. If necessary, processes will wake
>>>   	 * kswapd and get throttled again
>>>   	 */
>>> -	if (waitqueue_active(&pgdat->pfmemalloc_wait)) {
>>> -		wake_up(&pgdat->pfmemalloc_wait);
>>> -		return false;
>>> -	}
>>> +	wake_up_all(&pgdat->pfmemalloc_wait);
>>>   
>>>   	return pgdat_balanced(pgdat, order, classzone_idx);
>> So you are relying on scheduling points somewhere down the
>> balance_pgdat. That should be sufficient. I am still quite surprised
>> that we have an OOM victim still on the queue and balanced pgdat here
>> because OOM victim didn't have chance to free memory. So somebody else
>> must have released a lot of memory after OOM.
>>
>> This patch seems better than the one from Vlastimil. Care to post it
>> with the full changelog, please?
> Attached below (merged with 2/2). I haven't checked that it does fix the
> issue, because I don't have the reproducer, so it should be committed
> only if Vlastimil approves it.

I agree it's the right fix, thanks a lot. We only have a synthetic 
reproducer,
as the real scenario would be hard to trigger reliably. I can test it 
later, but
I think it's reasonably clear the patch will help.
I would just personaly keep the comment clarification in the patch, but it's
not a critical issue.

Vlastimil
