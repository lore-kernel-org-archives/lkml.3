Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaLWKQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:16:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaLWKQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:16:11 -0500
Date: Tue, 23 Dec 2014 11:16:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm, vmscan: prevent kswapd livelock due to
 pfmemalloc-throttled process being killed
Message-ID: <20141223101608.GB28549@dhcp22.suse.cz>
References: <1418994116-23665-1-git-send-email-vbabka@suse.cz>
 <20141219155747.GA31756@dhcp22.suse.cz>
 <20141219182815.GK18274@esperanza>
 <20141220104746.GB6306@dhcp22.suse.cz>
 <20141220141824.GM18274@esperanza>
 <20141222142435.GA2900@dhcp22.suse.cz>
 <20141222162558.GA21211@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222162558.GA21211@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-12-14 19:25:58, Vladimir Davydov wrote:
[...]
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: [PATCH] mm, vmscan: prevent kswapd livelock due to
>  pfmemalloc-throttled process being killed
> 
> Charles Shirron and Paul Cassella from Cray Inc have reported kswapd stuck
> in a busy loop with nothing left to balance, but kswapd_try_to_sleep() failing
> to sleep. Their analysis found the cause to be a combination of several
> factors:
> 
> 1. A process is waiting in throttle_direct_reclaim() on pgdat->pfmemalloc_wait
> 
> 2. The process has been killed (by OOM in this case), but has not yet been
>    scheduled to remove itself from the waitqueue and die.
> 
> 3. kswapd checks for throttled processes in prepare_kswapd_sleep() and
>    do not put itself to sleep if there are any:
> 
>         if (waitqueue_active(&pgdat->pfmemalloc_wait)) {
>                 wake_up(&pgdat->pfmemalloc_wait);
>                 return false;
>         }
> 
>    However, for a process that was already killed, wake_up() does not remove
>    the process from the waitqueue, since try_to_wake_up() checks its state
>    first and returns false when the process is no longer waiting.
> 
> 4. kswapd is running on the same CPU as the only CPU that the process is
>    allowed to run on (through cpus_allowed, or possibly single-cpu system).
> 
> 5. CONFIG_PREEMPT_NONE=y kernel is used. If there's nothing to balance, kswapd
>    encounters no voluntary preemption points and repeatedly fails
>    prepare_kswapd_sleep(), blocking the process from running and removing
>    itself from the waitqueue, which would let kswapd sleep.
> 
> So, the source of the problem is that we prevent kswapd from going to
> sleep until there are processes waiting on the pfmemalloc_wait queue,
> and a process waiting on a queue is guaranteed to be removed from the
> queue only when it gets scheduled. This was done to avoid the race
> between kswapd checking pfmemalloc_wait and a process getting throttled
> as the comment in prepare_kswapd_sleep() explains.
> 
> However, it isn't necessary to postpone kswapd sleep until the
> pfmemalloc_wait queue empties. To eliminate the race, it's actually
> enough to guarantee that all processes waiting on pfmemalloc_wait queue
> have been woken up by the time we put kswapd to sleep.
> 
> This patch therefore fixes this issue by substituting 'wake_up' with
> 'wake_up_all' and removing 'return false' in the code snippet from
> prepare_kswapd_sleep() above.
> 
> Also, it replaces wake_up with wake_up_all in balance_pgdat(), because:
>  - using wake_up there might leave processes waiting for longer than
>    necessary, until the check is reached in the next loop iteration;
>  - processes might also be left waiting even if zone was fully balanced
>    in single iteration;
>  - the comment says "wake them" so the author of the commit that
>    introduced pfmemalloc_wait seemed to mean wake_up_all;
>  - this corresponds to how we wake processes waiting on pfmemalloc_wait
>    in prepare_kswapd_sleep.

I would still separate this into a separate patch because it is not
directly related to the issue. It also doesn't need to be backported to
the stable tree AFAIU.

> Fixes: 5515061d22f0 ("mm: throttle direct reclaimers if PF_MEMALLOC reserves
>                       are low and swap is backed by network storage")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: <stable@vger.kernel.org>   # v3.6+
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Rik van Riel <riel@redhat.com>

Other than that the patch looks good to me.
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
> Changes in v2:
>  - instead of introducing yet another schedule() point in
>    kswapd_try_to_sleep(), allow kswapd to sleep even if the
>    pfmemalloc_wait queue is active, waking *all* throttled
>    processes before going to sleep
> 
>  mm/vmscan.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5e8772b2b9ef..65287944b2cf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2961,10 +2961,8 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
>  	 * so wake them now if necessary. If necessary, processes will wake
>  	 * kswapd and get throttled again
>  	 */
> -	if (waitqueue_active(&pgdat->pfmemalloc_wait)) {
> -		wake_up(&pgdat->pfmemalloc_wait);
> -		return false;
> -	}
> +	if (waitqueue_active(&pgdat->pfmemalloc_wait))
> +		wake_up_all(&pgdat->pfmemalloc_wait);
>  
>  	return pgdat_balanced(pgdat, order, classzone_idx);
>  }
> @@ -3205,7 +3203,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>  		 */
>  		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
>  				pfmemalloc_watermark_ok(pgdat))
> -			wake_up(&pgdat->pfmemalloc_wait);
> +			wake_up_all(&pgdat->pfmemalloc_wait);
>  
>  		/*
>  		 * Fragmentation may mean that the system cannot be rebalanced
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
