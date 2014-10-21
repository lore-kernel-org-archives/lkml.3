Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaJUIKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:10:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbaJUIKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:10:11 -0400
Date: Tue, 21 Oct 2014 10:10:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: simplify unreclaimable groups handling in soft
 limit reclaim
Message-ID: <20141021081009.GB9415@dhcp22.suse.cz>
References: <1413820554-15611-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413820554-15611-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-10-14 19:55:54, Vladimir Davydov wrote:
> If we fail to reclaim anything from a cgroup during a soft reclaim pass
> we want to get the next largest cgroup exceeding its soft limit. To
> achieve this, we should obviously remove the current group from the tree
> and then pick the largest group. Currently we have a weird loop instead.
> Let's simplify it.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |   26 ++++----------------------
>  1 file changed, 4 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e957f0c80c6e..53393e27ff03 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3507,34 +3507,16 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>  		nr_reclaimed += reclaimed;
>  		*total_scanned += nr_scanned;
>  		spin_lock_irq(&mctz->lock);
> +		__mem_cgroup_remove_exceeded(mz, mctz);
>  
>  		/*
>  		 * If we failed to reclaim anything from this memory cgroup
>  		 * it is time to move on to the next cgroup
>  		 */
>  		next_mz = NULL;
> -		if (!reclaimed) {
> -			do {
> -				/*
> -				 * Loop until we find yet another one.
> -				 *
> -				 * By the time we get the soft_limit lock
> -				 * again, someone might have aded the
> -				 * group back on the RB tree. Iterate to
> -				 * make sure we get a different mem.
> -				 * mem_cgroup_largest_soft_limit_node returns
> -				 * NULL if no other cgroup is present on
> -				 * the tree
> -				 */
> -				next_mz =
> -				__mem_cgroup_largest_soft_limit_node(mctz);
> -				if (next_mz == mz)
> -					css_put(&next_mz->memcg->css);
> -				else /* next_mz == NULL or other memcg */
> -					break;
> -			} while (1);
> -		}
> -		__mem_cgroup_remove_exceeded(mz, mctz);
> +		if (!reclaimed)
> +			next_mz = __mem_cgroup_largest_soft_limit_node(mctz);
> +
>  		excess = soft_limit_excess(mz->memcg);
>  		/*
>  		 * One school of thought says that we should not add
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
