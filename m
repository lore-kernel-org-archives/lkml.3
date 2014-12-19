Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaLSXGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 18:06:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaLSXGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 18:06:00 -0500
Message-ID: <5494AF56.9070001@suse.cz>
Date: Sat, 20 Dec 2014 00:05:58 +0100
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
References: <1418994116-23665-1-git-send-email-vbabka@suse.cz> <20141219155747.GA31756@dhcp22.suse.cz> <20141219182815.GK18274@esperanza>
In-Reply-To: <20141219182815.GK18274@esperanza>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 141219-1, 12/19/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.2014 19:28, Vladimir Davydov wrote:
> Hi,
>
> On Fri, Dec 19, 2014 at 04:57:47PM +0100, Michal Hocko wrote:
>> On Fri 19-12-14 14:01:55, Vlastimil Babka wrote:
>>> Charles Shirron and Paul Cassella from Cray Inc have reported kswapd stuck
>>> in a busy loop with nothing left to balance, but kswapd_try_to_sleep() failing
>>> to sleep. Their analysis found the cause to be a combination of several
>>> factors:
>>>
>>> 1. A process is waiting in throttle_direct_reclaim() on pgdat->pfmemalloc_wait
>>>
>>> 2. The process has been killed (by OOM in this case), but has not yet been
>>>     scheduled to remove itself from the waitqueue and die.
>> pfmemalloc_wait is used as wait_event and that one uses
>> autoremove_wake_function for wake ups so the task shouldn't stay on the
>> queue if it was woken up. Moreover pfmemalloc_wait sleeps are killable
>> by the OOM killer AFAICS.
>>
>> $ git grep "wait_event.*pfmemalloc_wait"
>> mm/vmscan.c:
>> wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
>> mm/vmscan.c:    wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,))
>>
>> So OOM killer would wake it up already and kswapd shouldn't see this
>> task on the waitqueue anymore.
> OOM killer will wake up the process, but it won't remove it from the
> pfmemalloc_wait queue. Therefore, if kswapd gets scheduled before the
> dying process, it will see the wait queue being still active, but won't
> be able to wake anyone up, because the waiting process has already been
> woken by SIGKILL. I think this is what Vlastimil means.

Yes, that's exactly what I think happens.

> So AFAIU the problem does exist. However, I think it could be fixed by
> simply waking up all processes waiting on pfmemalloc_wait before putting
> kswapd to sleep:

Hm I don't see how it helps? If any of the waiting processes were killed
and wants to run on kswapd's CPU to remove itself from the waitqueue,
it will still remain on the waitqueue, no?

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 744e2b491527..2a123634c220 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2984,6 +2984,9 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
>   	if (remaining)
>   		return false;
>   
> +	if (!pgdat_balanced(pgdat, order, classzone_idx))
> +		return false;
> +
>   	/*
>   	 * There is a potential race between when kswapd checks its watermarks
>   	 * and a process gets throttled. There is also a potential race if
> @@ -2993,12 +2996,9 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
>   	 * so wake them now if necessary. If necessary, processes will wake
>   	 * kswapd and get throttled again
>   	 */
> -	if (waitqueue_active(&pgdat->pfmemalloc_wait)) {
> -		wake_up(&pgdat->pfmemalloc_wait);
> -		return false;
> -	}
> +	wake_up_all(&pgdat->pfmemalloc_wait);
>   
> -	return pgdat_balanced(pgdat, order, classzone_idx);
> +	return true;
>   }
>   
>   /*
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


---
This email has been checked for viruses by Avast antivirus software.
http://www.avast.com

