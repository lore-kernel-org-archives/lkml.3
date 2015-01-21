Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbbAUKBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:01:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbbAUKBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:01:12 -0500
Message-ID: <54BF78E3.7030303@suse.cz>
Date: Wed, 21 Jan 2015 11:01:07 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mgorman@suse.de, minchan@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com
Subject: Re: [PATCH] mm: compaction: fix the page state calculation in too_many_isolated
References: <1421832864-30643-1-git-send-email-vinmenon@codeaurora.org>
In-Reply-To: <1421832864-30643-1-git-send-email-vinmenon@codeaurora.org>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 10:34 AM, Vinayak Menon wrote:
> Commit "3611badc1baa" (mm: vmscan: fix the page state calculation in

That appears to be a -next commit ID, which won't be the same in Linus' tree, so
it shouldn't be in commit message, AFAIK.

> too_many_isolated) fixed an issue where a number of tasks were
> blocked in reclaim path for seconds, because of vmstat_diff not being
> synced in time. A similar problem can happen in isolate_migratepages_block,
> similar calculation is performed. This patch fixes that.

I guess it's not possible to fix the stats instantly and once in the safe
versions, so that future readings will be correct without safe, right?
So until it gets fixed, each reading will have to be safe and thus expensive?

I think in case of async compaction, we could skip the safe stuff and just
terminate it - it's already done when too_many_isolated returns true, and
there's no congestion waiting in that case.

So you could extend the too_many_isolated() with "safe" parameter (as you did
for vmscan) and pass it "cc->mode != MIGRATE_ASYNC" value from
isolate_migrate_block().

> Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
> ---
>  mm/compaction.c | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 546e571..2d9730d 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -537,21 +537,43 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
>  	mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
>  }
>  
> -/* Similar to reclaim, but different enough that they don't share logic */
> -static bool too_many_isolated(struct zone *zone)
> +static bool __too_many_isolated(struct zone *zone, int safe)
>  {
>  	unsigned long active, inactive, isolated;
>  
> -	inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
> +	if (safe) {
> +		inactive = zone_page_state_snapshot(zone, NR_INACTIVE_FILE) +
> +			zone_page_state_snapshot(zone, NR_INACTIVE_ANON);
> +		active = zone_page_state_snapshot(zone, NR_ACTIVE_FILE) +
> +			zone_page_state_snapshot(zone, NR_ACTIVE_ANON);
> +		isolated = zone_page_state_snapshot(zone, NR_ISOLATED_FILE) +
> +			zone_page_state_snapshot(zone, NR_ISOLATED_ANON);
> +	} else {
> +		inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
>  					zone_page_state(zone, NR_INACTIVE_ANON);

Nit: could you ident the line above (and the other 2 below) the same way as they
are in the if (safe) part?

Thanks!

> -	active = zone_page_state(zone, NR_ACTIVE_FILE) +
> +		active = zone_page_state(zone, NR_ACTIVE_FILE) +
>  					zone_page_state(zone, NR_ACTIVE_ANON);
> -	isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
> +		isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
>  					zone_page_state(zone, NR_ISOLATED_ANON);
> +	}
>  
>  	return isolated > (inactive + active) / 2;
>  }
>  
> +/* Similar to reclaim, but different enough that they don't share logic */
> +static bool too_many_isolated(struct zone *zone)
> +{
> +	/*
> +	 * __too_many_isolated(safe=0) is fast but inaccurate, because it
> +	 * doesn't account for the vm_stat_diff[] counters.  So if it looks
> +	 * like too_many_isolated() is about to return true, fall back to the
> +	 * slower, more accurate zone_page_state_snapshot().
> +	 */
> +	if (unlikely(__too_many_isolated(zone, 0)))
> +		return __too_many_isolated(zone, 1);
> +	return 0;
> +}
> +
>  /**
>   * isolate_migratepages_block() - isolate all migrate-able pages within
>   *				  a single pageblock
> 

