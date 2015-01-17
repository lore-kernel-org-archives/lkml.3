Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbbAQQ3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 11:29:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53663 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbbAQQ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 11:29:40 -0500
Message-ID: <54BA8DEC.1080508@codeaurora.org>
Date: Sat, 17 Jan 2015 21:59:32 +0530
From: Vinayak Menon <vinmenon@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        vdavydov@parallels.com, mhocko@suse.cz, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in too_many_isolated
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150115171728.ebc77a48.akpm@linux-foundation.org>
In-Reply-To: <20150115171728.ebc77a48.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 06:47 AM, Andrew Morton wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix
>
> Move the zone_page_state_snapshot() fallback logic into
> too_many_isolated(), so shrink_inactive_list() doesn't incorrectly call
> congestion_wait().
>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Vinayak Menon <vinmenon@codeaurora.org>
> Cc: Vladimir Davydov <vdavydov@parallels.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   mm/vmscan.c |   23 +++++++++++------------
>   1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff -puN mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix mm/vmscan.c
> --- a/mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix
> +++ a/mm/vmscan.c
> @@ -1402,7 +1402,7 @@ int isolate_lru_page(struct page *page)
>   }
>
>   static int __too_many_isolated(struct zone *zone, int file,
> -	struct scan_control *sc, int safe)
> +			       struct scan_control *sc, int safe)
>   {
>   	unsigned long inactive, isolated;
>
> @@ -1435,7 +1435,7 @@ static int __too_many_isolated(struct zo
>    * unnecessary swapping, thrashing and OOM.
>    */
>   static int too_many_isolated(struct zone *zone, int file,
> -		struct scan_control *sc, int safe)
> +			     struct scan_control *sc)
>   {
>   	if (current_is_kswapd())
>   		return 0;
> @@ -1443,12 +1443,14 @@ static int too_many_isolated(struct zone
>   	if (!global_reclaim(sc))
>   		return 0;
>
> -	if (unlikely(__too_many_isolated(zone, file, sc, 0))) {
> -		if (safe)
> -			return __too_many_isolated(zone, file, sc, safe);
> -		else
> -			return 1;
> -	}
> +	/*
> +	 * __too_many_isolated(safe=0) is fast but inaccurate, because it
> +	 * doesn't account for the vm_stat_diff[] counters.  So if it looks
> +	 * like too_many_isolated() is about to return true, fall back to the
> +	 * slower, more accurate zone_page_state_snapshot().
> +	 */
> +	if (unlikely(__too_many_isolated(zone, file, sc, 0)))
> +		return __too_many_isolated(zone, file, sc, safe);

Just noticed now that, in the above statement it should be "1", instead 
of "safe". "safe" is not declared.



-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
