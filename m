Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966957Ab3DRPKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:10:40 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43358 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966458Ab3DRPKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:10:39 -0400
Date: Thu, 18 Apr 2013 08:09:42 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        dormando <dormando@rydia.net>, Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] mm: vmscan: Decide whether to compact the pgdat
 based on reclaim progress
Message-ID: <20130418150942.GF2018@cmpxchg.org>
References: <1365710278-6807-1-git-send-email-mgorman@suse.de>
 <1365710278-6807-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365710278-6807-5-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:57:52PM +0100, Mel Gorman wrote:
> @@ -2763,7 +2769,21 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>  		for (i = 0; i <= end_zone; i++) {
>  			struct zone *zone = pgdat->node_zones + i;
>  
> +			if (!populated_zone(zone))
> +				continue;
> +
>  			lru_pages += zone_reclaimable_pages(zone);
> +
> +			/*
> +			 * If any zone is currently balanced then kswapd will
> +			 * not call compaction as it is expected that the
> +			 * necessary pages are already available.
> +			 */
> +			if (pgdat_needs_compaction &&
> +					zone_watermark_ok(zone, order,
> +						low_wmark_pages(zone),
> +						*classzone_idx, 0))
> +				pgdat_needs_compaction = false;
>  		}
>  
>  		/*
> @@ -2832,7 +2852,8 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>  				 * already being scanned that high
>  				 * watermark would be met at 100% efficiency.
>  				 */
> -				if (kswapd_shrink_zone(zone, &sc, lru_pages))
> +				if (kswapd_shrink_zone(zone, &sc, lru_pages,
> +						       &nr_attempted))
>  					raise_priority = false;
>  			}

There is the odd chance that the watermark is met after reclaim, would
it make sense to defer the pgdat_needs_compaction check?  Not really a
big deal, though, so:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
