Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaBMOX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:23:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaBMOXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:23:55 -0500
Date: Thu, 13 Feb 2014 15:23:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: fix endless loop in __mem_cgroup_iter_next
Message-ID: <20140213142355.GB11986@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1402121717420.5917@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402121717420.5917@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-02-14 17:26:46, Hugh Dickins wrote:
> Commit 0eef615665ed ("memcg: fix css reference leak and endless loop in
> mem_cgroup_iter") got the interaction with the commit a few before it
> d8ad30559715 ("mm/memcg: iteration skip memcgs not yet fully initialized")
> slightly wrong, and we didn't notice at the time.
> 
> It's elusive, and harder to get than the original, but for a couple of
> days before rc1, I several times saw a endless loop similar to that
> supposedly being fixed.
> 
> This time it was a tighter loop in __mem_cgroup_iter_next(): because we
> can get here when our root has already been offlined, and the ordering
> of conditions was such that we then just cycled around forever.
> 
> Fixes: 0eef615665ed ("memcg: fix css reference leak and endless loop in mem_cgroup_iter")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org # 3.12+

You are right of course. This is really embarrassing. I should have
noticed this when porting my original patch on top of yours.

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
> Of course I'd have preferred to send this before that commit went through
> to -stable, but priorities kept preempting; I did wonder whether to ask
> GregKH to delay it, but decided it's not serious enough to trouble him,
> just go with the flow of stable fixing stable.
> 
>  mm/memcontrol.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- 3.14-rc2/mm/memcontrol.c	2014-02-02 18:49:07.897302115 -0800
> +++ linux/mm/memcontrol.c	2014-02-12 11:55:02.836035004 -0800
> @@ -1127,8 +1127,8 @@ skip_node:
>  	 * skipping css reference should be safe.
>  	 */
>  	if (next_css) {
> -		if ((next_css->flags & CSS_ONLINE) &&
> -				(next_css == &root->css || css_tryget(next_css)))
> +		if ((next_css == &root->css) ||
> +		    ((next_css->flags & CSS_ONLINE) && css_tryget(next_css)))
>  			return mem_cgroup_from_css(next_css);
>  
>  		prev_css = next_css;

-- 
Michal Hocko
SUSE Labs
