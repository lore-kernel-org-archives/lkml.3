Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbaIBVmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:42:20 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50183 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaIBVmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:42:17 -0400
Date: Tue, 2 Sep 2014 14:42:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: clean up zone flags
In-Reply-To: <1409668074-16875-1-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1409021437160.28054@chino.kir.corp.google.com>
References: <1409668074-16875-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Johannes Weiner wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 318df7051850..48bf12ef6620 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -521,13 +521,13 @@ struct zone {
>  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
>  } ____cacheline_internodealigned_in_smp;
>  
> -typedef enum {
> +enum zone_flags {
>  	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
>  	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
>  	ZONE_CONGESTED,			/* zone has many dirty pages backed by
>  					 * a congested BDI
>  					 */
> -	ZONE_TAIL_LRU_DIRTY,		/* reclaim scanning has recently found
> +	ZONE_DIRTY,			/* reclaim scanning has recently found
>  					 * many dirty file pages at the tail
>  					 * of the LRU.
>  					 */
> @@ -535,52 +535,7 @@ typedef enum {
>  					 * many pages under writeback
>  					 */
>  	ZONE_FAIR_DEPLETED,		/* fair zone policy batch depleted */
> -} zone_flags_t;
> -
> -static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
> -{
> -	set_bit(flag, &zone->flags);
> -}
> -
> -static inline int zone_test_and_set_flag(struct zone *zone, zone_flags_t flag)
> -{
> -	return test_and_set_bit(flag, &zone->flags);
> -}
> -
> -static inline void zone_clear_flag(struct zone *zone, zone_flags_t flag)
> -{
> -	clear_bit(flag, &zone->flags);
> -}
> -
> -static inline int zone_is_reclaim_congested(const struct zone *zone)
> -{
> -	return test_bit(ZONE_CONGESTED, &zone->flags);
> -}
> -
> -static inline int zone_is_reclaim_dirty(const struct zone *zone)
> -{
> -	return test_bit(ZONE_TAIL_LRU_DIRTY, &zone->flags);
> -}
> -
> -static inline int zone_is_reclaim_writeback(const struct zone *zone)
> -{
> -	return test_bit(ZONE_WRITEBACK, &zone->flags);
> -}
> -
> -static inline int zone_is_reclaim_locked(const struct zone *zone)
> -{
> -	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
> -}
> -
> -static inline int zone_is_fair_depleted(const struct zone *zone)
> -{
> -	return test_bit(ZONE_FAIR_DEPLETED, &zone->flags);
> -}
> -
> -static inline int zone_is_oom_locked(const struct zone *zone)
> -{
> -	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
> -}
> +};
>  
>  static inline unsigned long zone_end_pfn(const struct zone *zone)
>  {
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 1706cbbdf5f0..d7a9051a6db5 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -631,7 +631,7 @@ long wait_iff_congested(struct zone *zone, int sync, long timeout)
>  	 * of sleeping on the congestion queue
>  	 */
>  	if (atomic_read(&nr_bdi_congested[sync]) == 0 ||
> -			!zone_is_reclaim_congested(zone)) {
> +	    test_bit(ZONE_CONGESTED, &zone->flags)) {
>  		cond_resched();
>  
>  		/* In case we scheduled, work out time remaining */

That's not equivalent.

[snip]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2836b5373b2e..590a92bec6a4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -920,7 +920,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  			/* Case 1 above */
>  			if (current_is_kswapd() &&
>  			    PageReclaim(page) &&
> -			    zone_is_reclaim_writeback(zone)) {
> +			    test_bit(ZONE_WRITEBACK, &zone->flags)) {
>  				nr_immediate++;
>  				goto keep_locked;
>  
> @@ -1002,7 +1002,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  			 */
>  			if (page_is_file_cache(page) &&
>  					(!current_is_kswapd() ||
> -					 !zone_is_reclaim_dirty(zone))) {
> +					 test_bit(ZONE_DIRTY, &zone->flags))) {
>  				/*
>  				 * Immediately reclaim when written back.
>  				 * Similar in principal to deactivate_page()

Nor is this.

After fixed, for the oom killer bits:

	Acked-by: David Rientjes <rientjes@google.com>

since this un-obscurification is most welcome.
