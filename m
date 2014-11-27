Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaK0KZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:25:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaK0KZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:25:50 -0500
Date: Thu, 27 Nov 2014 11:25:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, oom: remove gfp helper function
Message-ID: <20141127102547.GA18833@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-11-14 14:17:32, David Rientjes wrote:
> Commit b9921ecdee66 ("mm: add a helper function to check may oom
> condition") was added because the gfp criteria for oom killing was
> checked in both the page allocator and memcg.
> 
> That was true for about nine months, but then commit 0029e19ebf84 ("mm:
> memcontrol: remove explicit OOM parameter in charge path") removed the
> memcg usecase.
> 
> Fold the implementation into its only caller.

I don't care much whether the check is open coded or hidden behind the
helper but I would really appreciate a comment explaining why we care
about these two particular gfp flags. The code is like that since ages
- excavation work would lead us back to 2002 resp. 2003. Let's save
other others people time and do not repeat the same exercise again.

What about a comment like the following?

> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/oom.h | 5 -----
>  mm/page_alloc.c     | 2 +-
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
[...]
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2706,7 +2706,7 @@ rebalance:
>  	 * running out of options and have to consider going OOM
>  	 */
>  	if (!did_some_progress) {
> -		if (oom_gfp_allowed(gfp_mask)) {
		/*
		 * Do not attempt to trigger OOM killer for !__GFP_FS
		 * allocations because it would be premature to kill
		 * anything just because the reclaim is stuck on
		 * dirty/writeback pages.
		 * __GFP_NORETRY allocations might fail and so the OOM
		 * would be more harmful than useful.
		 */
> +		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
>  			if (oom_killer_disabled)
>  				goto nopage;
>  			/* Coredumps can quickly deplete all memory reserves */

-- 
Michal Hocko
SUSE Labs
