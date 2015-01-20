Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbbATN0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:26:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbbATNZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:25:21 -0500
Date: Tue, 20 Jan 2015 14:25:19 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - high reclaim
Message-ID: <20150120132519.GH25342@dhcp22.suse.cz>
References: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 17-01-15 10:21:19, Johannes Weiner wrote:
> High limit reclaim can currently overscan in proportion to how many
> charges are happening concurrently.  Tone it down such that charges
> don't target the entire high-boundary excess, but instead only the
> pages they charged themselves when excess is detected.
> 
> Reported-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

I certainly agree with this approach.
Acked-by: Michal Hocko <mhocko@suse.cz>

Is this planned to be folded into the original patch or go on its own. I
am OK with both ways, maybe having it separate would be better from
documentation POV.

> ---
>  mm/memcontrol.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 323a01fa1833..7adccee9fecb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2348,19 +2348,13 @@ done_restock:
>  		refill_stock(memcg, batch - nr_pages);
>  	/*
>  	 * If the hierarchy is above the normal consumption range,
> -	 * make the charging task trim the excess.
> +	 * make the charging task trim their excess contribution.
>  	 */
>  	do {
> -		unsigned long nr_pages = page_counter_read(&memcg->memory);
> -		unsigned long high = ACCESS_ONCE(memcg->high);
> -
> -		if (nr_pages > high) {
> -			mem_cgroup_events(memcg, MEMCG_HIGH, 1);
> -
> -			try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> -						     gfp_mask, true);
> -		}
> -
> +		if (page_counter_read(&memcg->memory) <= memcg->high)
> +			continue;
> +		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
> +		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
>  	} while ((memcg = parent_mem_cgroup(memcg)));
>  done:
>  	return ret;
> -- 
> 2.2.0
> 

-- 
Michal Hocko
SUSE Labs
