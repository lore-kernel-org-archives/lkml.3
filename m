Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaFWH24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:28:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaFWH2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:28:55 -0400
Date: Mon, 23 Jun 2014 09:28:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mm: vmscan: rework compaction-ready signaling in
 direct reclaim
Message-ID: <20140623072850.GA9743@dhcp22.suse.cz>
References: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
 <1403282030-29915-2-git-send-email-hannes@cmpxchg.org>
 <53A467A3.1050008@suse.cz>
 <20140620202449.GA30849@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620202449.GA30849@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-06-14 16:24:49, Johannes Weiner wrote:
[...]
> From cd48b73fdca9e23aa21f65e9af1f850dbac5ab8e Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Wed, 11 Jun 2014 12:53:59 -0400
> Subject: [patch] mm: vmscan: rework compaction-ready signaling in direct
>  reclaim
> 
> Page reclaim for a higher-order page runs until compaction is ready,
> then aborts and signals this situation through the return value of
> shrink_zones().  This is an oddly specific signal to encode in the
> return value of shrink_zones(), though, and can be quite confusing.
> 
> Introduce sc->compaction_ready and signal the compactability of the
> zones out-of-band to free up the return value of shrink_zones() for
> actual zone reclaimability.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Very nice. It will help me to get rid off additional hacks for the
min_limit for memcg. Thanks!

One question below

[...]
> @@ -2500,12 +2492,15 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
>  				sc->priority);
>  		sc->nr_scanned = 0;
> -		aborted_reclaim = shrink_zones(zonelist, sc);
> +		shrink_zones(zonelist, sc);
>  
>  		total_scanned += sc->nr_scanned;
>  		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
>  			goto out;
>  
> +		if (sc->compaction_ready)
> +			goto out;
> +
>  		/*
>  		 * If we're getting trouble reclaiming, start doing
>  		 * writepage even in laptop mode.
> @@ -2526,7 +2521,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  						WB_REASON_TRY_TO_FREE_PAGES);
>  			sc->may_writepage = 1;
>  		}
> -	} while (--sc->priority >= 0 && !aborted_reclaim);
> +	} while (--sc->priority >= 0);
>  
>  out:
>  	delayacct_freepages_end();

It is not entirely clear to me why we do not need to check and wake up
flusher threads anymore?

-- 
Michal Hocko
SUSE Labs
