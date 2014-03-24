Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaCXRfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbaCXRfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:35:16 -0400
Message-ID: <53306C73.9030808@redhat.com>
Date: Mon, 24 Mar 2014 13:33:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] vmscan: Age anonymous memory even when swap is off.
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <1395436655-21670-6-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1395436655-21670-6-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 05:17 PM, John Stultz wrote:
> Currently we don't shrink/scan the anonymous lrus when swap is off.
> This is problematic for volatile range purging on swapless systems/
>
> This patch naievely changes the vmscan code to continue scanning
> and shrinking the lrus even when there is no swap.
>
> It obviously has performance issues.
>
> Thoughts on how best to implement this would be appreciated.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Robert Love <rlove@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Dave Hansen <dave@sr71.net>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mike Hommey <mh@glandium.org>
> Cc: Taras Glek <tglek@mozilla.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: linux-mm@kvack.org <linux-mm@kvack.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>   mm/vmscan.c | 26 ++++----------------------
>   1 file changed, 4 insertions(+), 22 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 34f159a..07b0a8c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -155,9 +155,8 @@ static unsigned long zone_reclaimable_pages(struct zone *zone)
>   	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
>   	     zone_page_state(zone, NR_INACTIVE_FILE);
>
> -	if (get_nr_swap_pages() > 0)
> -		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
> -		      zone_page_state(zone, NR_INACTIVE_ANON);
> +	nr += zone_page_state(zone, NR_ACTIVE_ANON) +
> +	      zone_page_state(zone, NR_INACTIVE_ANON);
>
>   	return nr;

Not all of the anonymous pages will be reclaimable.

Is there some counter that keeps track of how many
volatile range pages there are in each zone?


> @@ -1764,13 +1763,6 @@ static int inactive_anon_is_low_global(struct zone *zone)
>    */
>   static int inactive_anon_is_low(struct lruvec *lruvec)
>   {
> -	/*
> -	 * If we don't have swap space, anonymous page deactivation
> -	 * is pointless.
> -	 */
> -	if (!total_swap_pages)
> -		return 0;
> -
>   	if (!mem_cgroup_disabled())
>   		return mem_cgroup_inactive_anon_is_low(lruvec);

This part is correct, and needed.

> @@ -1880,12 +1872,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>   	if (!global_reclaim(sc))
>   		force_scan = true;
>
> -	/* If we have no swap space, do not bother scanning anon pages. */
> -	if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
> -		scan_balance = SCAN_FILE;
> -		goto out;
> -	}
> -
>   	/*

This part is too.

> @@ -2181,8 +2166,8 @@ static inline bool should_continue_reclaim(struct zone *zone,
>   	 */
>   	pages_for_compaction = (2UL << sc->order);
>   	inactive_lru_pages = zone_page_state(zone, NR_INACTIVE_FILE);
> -	if (get_nr_swap_pages() > 0)
> -		inactive_lru_pages += zone_page_state(zone, NR_INACTIVE_ANON);
> +	inactive_lru_pages += zone_page_state(zone, NR_INACTIVE_ANON);
> +
>   	if (sc->nr_reclaimed < pages_for_compaction &&
>   			inactive_lru_pages > pages_for_compaction)

Not sure this is a good idea, since the pages may not actually
be reclaimable, and the inactive list will continue to be
refilled indefinitely...

If there was a counter of the number of volatile range pages
in a zone, this would be easier.

Of course, the overhead of keeping such a counter might be
too high for what volatile ranges are designed for...

>   		return true;
> @@ -2726,9 +2711,6 @@ static void age_active_anon(struct zone *zone, struct scan_control *sc)
>   {
>   	struct mem_cgroup *memcg;
>
> -	if (!total_swap_pages)
> -		return;
> -

This bit is correct and needed.

