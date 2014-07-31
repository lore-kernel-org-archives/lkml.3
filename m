Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbaGaMa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:30:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGaMa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:30:28 -0400
Date: Thu, 31 Jul 2014 14:30:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] memcg, vmscan: Fix forced scan of anonymous pages
Message-ID: <20140731123026.GE13561@dhcp22.suse.cz>
References: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
 <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31-07-14 13:49:45, Jerome Marchand wrote:
> When memory cgoups are enabled, the code that decides to force to scan
> anonymous pages in get_scan_count() compares global values (free,
> high_watermark) to a value that is restricted to a memory cgroup
> (file). It make the code over-eager to force anon scan.

OK, I though this was about memcg reclaim according to the subject but
this is in fact global reclaim when there are multiple memcgs present.
Good. You are right that apples are compared to oranges here.

> For instance, it will force anon scan when scanning a memcg that is
> mainly populated by anonymous page, even when there is plenty of file
> pages to get rid of in others memcgs, even when swappiness == 0. It
> breaks user's expectation about swappiness and hurts performance. 
> 
> This patch make sure that forced anon scan only happens when there not
> enough file pages for the all zone, not just in one random memcg.

OK, makes sense to me.

> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Although I have never seen this before I can imagine specialized memcgs
running with mostly anon memory so I would even consider it a stable
material.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/vmscan.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 079918d..3ad2069 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1950,8 +1950,11 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
>  	 */
>  	if (global_reclaim(sc)) {
>  		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
> +		unsigned long zonefile =
> +			zone_page_state(zone, NR_LRU_BASE + LRU_ACTIVE_FILE) +
> +			zone_page_state(zone, NR_LRU_BASE + LRU_INACTIVE_FILE);
>  
> -		if (unlikely(file + free <= high_wmark_pages(zone))) {
> +		if (unlikely(zonefile + free <= high_wmark_pages(zone))) {
>  			scan_balance = SCAN_ANON;
>  			goto out;
>  		}

You could move file and anon further down when we actually use them.
-- 
Michal Hocko
SUSE Labs
