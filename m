Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaESSQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaESSQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:16:40 -0400
Date: Mon, 19 May 2014 15:16:12 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, shli@kernel.org,
        minchan@kernel.org, riel@redhat.com, mgorman@suse.de,
        cmetcalf@tilera.com, mhocko@suse.cz, vdavydov@parallels.com,
        glommer@openvz.org, dchinner@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan.c: use DIV_ROUND_UP for calculation of zone's
 balance_gap and correct comments.
Message-ID: <20140519181611.GB10453@localhost.localdomain>
References: <1400472510-24375-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400472510-24375-1-git-send-email-nasa4836@gmail.com>
X-PGP-Key: http://people.redhat.com/~raquini/gpg-pubkey.asc
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:08:30PM +0800, Jianyu Zhan wrote:
> Currently, we use (zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
> KSWAPD_ZONE_BALANCE_GAP_RATIO to avoid a zero gap value. It's better to
> use DIV_ROUND_UP macro for neater code and clear meaning.
> 
> Besides, the gap value is calculated against the per-zone "managed pages",
> not "present pages". This patch also corrects the comment and do some
> rephrasing.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
Acked-by: Rafael Aquini <aquini@redhat.com>

>  include/linux/swap.h |  8 ++++----
>  mm/vmscan.c          | 10 ++++------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 5a14b92..58e1696 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -166,10 +166,10 @@ enum {
>  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
>  
>  /*
> - * Ratio between the present memory in the zone and the "gap" that
> - * we're allowing kswapd to shrink in addition to the per-zone high
> - * wmark, even for zones that already have the high wmark satisfied,
> - * in order to provide better per-zone lru behavior. We are ok to
> + * Ratio between zone->managed_pages and the "gap" that above the per-zone
> + * "high_wmark". While balancing nodes, We allow kswapd to shrink zones that
> + * do not meet the (high_wmark + gap) watermark, even which already met the
> + * high_wmark, in order to provide better per-zone lru behavior. We are ok to
>   * spend not more than 1% of the memory for this zone balancing "gap".
>   */
>  #define KSWAPD_ZONE_BALANCE_GAP_RATIO 100
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 32c661d..9ef9f6c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2268,9 +2268,8 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
>  	 * there is a buffer of free pages available to give compaction
>  	 * a reasonable chance of completing and allocating the page
>  	 */
> -	balance_gap = min(low_wmark_pages(zone),
> -		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
> -			KSWAPD_ZONE_BALANCE_GAP_RATIO);
> +	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
> +			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
>  	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
>  	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
>  
> @@ -2891,9 +2890,8 @@ static bool kswapd_shrink_zone(struct zone *zone,
>  	 * high wmark plus a "gap" where the gap is either the low
>  	 * watermark or 1% of the zone, whichever is smaller.
>  	 */
> -	balance_gap = min(low_wmark_pages(zone),
> -		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
> -		KSWAPD_ZONE_BALANCE_GAP_RATIO);
> +	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
> +			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
>  
>  	/*
>  	 * If there is no low memory pressure or the zone is balanced then no
> -- 
> 2.0.0-rc3
> 
