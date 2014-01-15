Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaAOIVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:21:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaAOIVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:21:40 -0500
Date: Wed, 15 Jan 2014 09:21:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/memcg: iteration skip memcgs not yet fully
 initialized
Message-ID: <20140115082138.GB8782@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
 <alpine.LSU.2.11.1401131752360.2229@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401131752360.2229@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13-01-14 17:54:04, Hugh Dickins wrote:
> It is surprising that the mem_cgroup iterator can return memcgs which
> have not yet been fully initialized.  By accident (or trial and error?)
> this appears not to present an actual problem; but it may be better to
> prevent such surprises, by skipping memcgs not yet online.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

This makes a perfect sense now after Tejun pointed out that I was wrong
assuming css_online is called before cgroup is made visible.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
> Decide for yourself whether to take this or not.  I spent quite a while
> digging into a mysterious "trying to register non-static key" issue from
> lockdep, which originated from the iterator returning a vmalloc'ed memcg
> a moment before the res_counter_init()s had done their spin_lock_init()s.
> But the backtrace was an odd one of our own mis-devising, not a charge or
> reclaim or stats trace, so probably it's never been a problem for vanilla.
> 
>  mm/memcontrol.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> --- mmotm/mm/memcontrol.c	2014-01-10 18:25:02.236448954 -0800
> +++ linux/mm/memcontrol.c	2014-01-12 22:21:10.700570471 -0800
> @@ -1119,10 +1119,8 @@ skip_node:
>  	 * protected by css_get and the tree walk is rcu safe.
>  	 */
>  	if (next_css) {
> -		struct mem_cgroup *mem = mem_cgroup_from_css(next_css);
> -
> -		if (css_tryget(&mem->css))
> -			return mem;
> +		if ((next_css->flags & CSS_ONLINE) && css_tryget(next_css))
> +			return mem_cgroup_from_css(next_css);
>  		else {
>  			prev_css = next_css;
>  			goto skip_node;

-- 
Michal Hocko
SUSE Labs
