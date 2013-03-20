Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3CTQSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:18:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab3CTQSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:18:51 -0400
Date: Wed, 20 Mar 2013 17:18:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd
 reclaims at each priority
Message-ID: <20130320161847.GD27375@dhcp22.suse.cz>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363525456-10448-2-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 17-03-13 13:04:07, Mel Gorman wrote:
[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 88c5fed..4835a7a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2593,6 +2593,32 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
>  }
>  
>  /*
> + * kswapd shrinks the zone by the number of pages required to reach
> + * the high watermark.
> + */
> +static void kswapd_shrink_zone(struct zone *zone,
> +			       struct scan_control *sc,
> +			       unsigned long lru_pages)
> +{
> +	unsigned long nr_slab;
> +	struct reclaim_state *reclaim_state = current->reclaim_state;
> +	struct shrink_control shrink = {
> +		.gfp_mask = sc->gfp_mask,
> +	};
> +
> +	/* Reclaim above the high watermark. */
> +	sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));

OK, so the cap is at high watermark which sounds OK to me, although I
would expect balance_gap being considered here. Is it not used
intentionally or you just wanted to have a reasonable upper bound?

I am not objecting to that it just hit my eyes.

> +	shrink_zone(zone, sc);
> +
> +	reclaim_state->reclaimed_slab = 0;
> +	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
> +	sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> +
> +	if (nr_slab == 0 && !zone_reclaimable(zone))
> +		zone->all_unreclaimable = 1;
> +}
> +
> +/*
>   * For kswapd, balance_pgdat() will work across all this node's zones until
>   * they are all at high_wmark_pages(zone).
>   *
-- 
Michal Hocko
SUSE Labs
