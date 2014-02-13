Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBMQ5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbaBMQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:57:53 -0500
Message-ID: <52FCEE74.9010602@redhat.com>
Date: Thu, 13 Feb 2014 11:10:28 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>, "'Mel Gorman'" <mgorman@suse.de>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/vmscan: restore sc->gfp_mask after promoting it
 to __GFP_HIGHMEM
References: <000001cf2865$0aa2c0c0$1fe84240$%yang@samsung.com>
In-Reply-To: <000001cf2865$0aa2c0c0$1fe84240$%yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:39 PM, Weijie Yang wrote:

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2298,14 +2298,17 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  	unsigned long nr_soft_reclaimed;
>  	unsigned long nr_soft_scanned;
>  	bool aborted_reclaim = false;
> +	bool promoted_mask = false;
>  
>  	/*
>  	 * If the number of buffer_heads in the machine exceeds the maximum
>  	 * allowed level, force direct reclaim to scan the highmem zone as
>  	 * highmem pages could be pinning lowmem pages storing buffer_heads
>  	 */
> -	if (buffer_heads_over_limit)
> +	if (buffer_heads_over_limit) {

It took me a minute to figure out why you are doing things this way,
so maybe this could use a comment, or maybe it could be done in a
simpler way, by simply saving and restoring the original mask?

		orig_mask = sc->gfp_mask;

> +		promoted_mask = !(sc->gfp_mask & __GFP_HIGHMEM);
>  		sc->gfp_mask |= __GFP_HIGHMEM;
> +	}
>  
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  					gfp_zone(sc->gfp_mask), sc->nodemask) {
> @@ -2354,6 +2357,9 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  		shrink_zone(zone, sc);
>  	}
>  
> +	if (promoted_mask)
		sc->gfp_mask = orig_mask;

> +		sc->gfp_mask &= ~__GFP_HIGHMEM;
> +
>  	return aborted_reclaim;
>  }
>  
> 


-- 
All rights reversed
