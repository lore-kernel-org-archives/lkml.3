Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaDVTbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:31:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDVTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:31:50 -0400
Date: Tue, 22 Apr 2014 12:31:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: vmscan: Do not throttle based on pfmemalloc
 reserves if node has no ZONE_NORMAL
Message-Id: <20140422123149.d406e5cbef5c01eb6dc5c89b@linux-foundation.org>
In-Reply-To: <20140422083852.GB23991@suse.de>
References: <20140422083852.GB23991@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 09:38:52 +0100 Mel Gorman <mgorman@suse.de> wrote:

> throttle_direct_reclaim() is meant to trigger during swap-over-network
> during which the min watermark is treated as a pfmemalloc reserve. It
> throttes on the first node in the zonelist but this is flawed.
> 
> On a NUMA machine running a 32-bit kernel (I know) allocation requests
> freom CPUs on node 1 would detect no pfmemalloc reserves and the process
> gets throttled. This patch adjusts throttling of direct reclaim to throttle
> based on the first node in the zonelist that has a usable ZONE_NORMAL or
> lower zone.

I'm unable to determine from the above whether we should backport this
fix.  Please don't forget to describe the end-user visible effects of
a bug when that isn't obvious.  

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2507,10 +2507,17 @@ static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
>  
>  	for (i = 0; i <= ZONE_NORMAL; i++) {
>  		zone = &pgdat->node_zones[i];
> +		if (!populated_zone(zone))
> +			continue;

What's this?  Performance tweak?  Or does min_wmark_pages() return
non-zero for an unpopulated zone, which seems odd.

>  		pfmemalloc_reserve += min_wmark_pages(zone);
>  		free_pages += zone_page_state(zone, NR_FREE_PAGES);
>  	}
>  
> +	/* If there are no reserves (unexpected config) then do not throttle */
> +	if (!pfmemalloc_reserve)
> +		return true;
> +
>  	wmark_ok = free_pages > pfmemalloc_reserve / 2;
>  
>  	/* kswapd must be awake if processes are being throttled */
> @@ -2535,9 +2542,9 @@ static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
>  static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  					nodemask_t *nodemask)
>  {
> +	struct zoneref *z;
>  	struct zone *zone;
> -	int high_zoneidx = gfp_zone(gfp_mask);
> -	pg_data_t *pgdat;
> +	pg_data_t *pgdat = NULL;
>  
>  	/*
>  	 * Kernel threads should not be throttled as they may be indirectly
> @@ -2556,10 +2563,24 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  	if (fatal_signal_pending(current))
>  		goto out;
>  
> -	/* Check if the pfmemalloc reserves are ok */
> -	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
> -	pgdat = zone->zone_pgdat;
> -	if (pfmemalloc_watermark_ok(pgdat))
> +	/*
> +	 * Check if the pfmemalloc reserves are ok by finding the first node
> +	 * with a usable ZONE_NORMAL or lower zone
> +	 */

That comment tells us what the code does but not why it does it.

- Why do we ignore zones >= ZONE_NORMAL?

- Why do we throttle when there may be as-yet-unexamined nodes which
  have reclaimable pages?


> +        for_each_zone_zonelist_nodemask(zone, z, zonelist,
> +                                        gfp_mask, nodemask) {

Those two lines have spaces-instead-of-tabs.

> +		if (zone_idx(zone) > ZONE_NORMAL)
> +			continue;
> +
> +		/* Throttle based on the first usable node */
> +		pgdat = zone->zone_pgdat;
> +		if (pfmemalloc_watermark_ok(pgdat))
> +			goto out;
> +		break;
> +	}
> +
> +	/* If no zone was usable by the allocation flags then do not throttle */
> +	if (!pgdat)
>  		goto out;

