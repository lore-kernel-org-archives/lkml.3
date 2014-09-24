Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaIXQrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:47:46 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60706 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaIXQrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:43 -0400
Date: Wed, 24 Sep 2014 18:47:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Message-ID: <20140924164739.GA15897@dhcp22.suse.cz>
References: <1411161059-16552-1-git-send-email-hannes@cmpxchg.org>
 <20140919212843.GA23861@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919212843.GA23861@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19-09-14 17:28:43, Johannes Weiner wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Fri, 19 Sep 2014 12:39:18 -0400
> Subject: [patch v2] mm: memcontrol: convert reclaim iterator to simple css
>  refcounting
> 
> The memcg reclaim iterators use a complicated weak reference scheme to
> prevent pinning cgroups indefinitely in the absence of memory pressure.
> 
> However, during the ongoing cgroup core rework, css lifetime has been
> decoupled such that a pinned css no longer interferes with removal of
> the user-visible cgroup, and all this complexity is now unnecessary.

I very much welcome simplification in this area but I would also very much
appreciate more details why some checks are no longer needed. Why don't
we need ->generation or (next_css->flags & CSS_ONLINE) check anymore?

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 201 ++++++++++----------------------------------------------
>  1 file changed, 34 insertions(+), 167 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dfd3b15a57e8..154161bb7d4c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
>  	rcu_read_lock();
> -	while (!memcg) {
> -		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
> -		int uninitialized_var(seq);
>  
> -		if (reclaim) {
> -			struct mem_cgroup_per_zone *mz;
> +	if (reclaim) {
> +		mz = mem_cgroup_zone_zoneinfo(root, reclaim->zone);
> +		priority = reclaim->priority;
>  
> -			mz = mem_cgroup_zone_zoneinfo(root, reclaim->zone);
> -			iter = &mz->reclaim_iter[reclaim->priority];
> -			if (prev && reclaim->generation != iter->generation) {
> -				iter->last_visited = NULL;
> -				goto out_unlock;
> -			}
> -
> -			last_visited = mem_cgroup_iter_load(iter, root, &seq);
> -		}
> -
> -		memcg = __mem_cgroup_iter_next(root, last_visited);
> +		do {
> +			pos = ACCESS_ONCE(mz->reclaim_iter[priority]);
> +		} while (pos && !css_tryget(&pos->css));

This is a bit confusing. AFAIU css_tryget fails only when the current
ref count is zero already. When do we keep cached memcg with zero count
behind? We always do css_get after cmpxchg.

Hmm, there is a small window between cmpxchg and css_get when we store
the current memcg into the reclaim_iter[priority]. If the current memcg
is root then we do not take any css reference before cmpxchg and so it
might drop down to zero in the mean time so other CPU might see zero I
guess. But I do not see how css_get after cmpxchg on such css works.
I guess I should go and check the css reference counting again.

Anyway this would deserve a comment.

> +	}
>  
> -		if (reclaim) {
> -			mem_cgroup_iter_update(iter, last_visited, memcg, root,
> -					seq);
> +	if (pos)
> +		css = &pos->css;
>  
> -			if (!memcg)
> -				iter->generation++;
> -			else if (!prev && memcg)
> -				reclaim->generation = iter->generation;
> +	for (;;) {
> +		css = css_next_descendant_pre(css, &root->css);
> +		if (!css) {
> +			if (prev)
> +				goto out_unlock;
> +			continue;
> +		}
> +		if (css == &root->css || css_tryget_online(css)) {
> +			memcg = mem_cgroup_from_css(css);
> +			break;
>  		}
> +	}
>  
> -		if (prev && !memcg)
> -			goto out_unlock;
> +	if (reclaim) {
> +		if (cmpxchg(&mz->reclaim_iter[priority], pos, memcg) == pos)
> +			css_get(&memcg->css);
> +		if (pos)
> +			css_put(&pos->css);
>  	}
> +
>  out_unlock:
>  	rcu_read_unlock();
> -out_css_put:
> +out:
>  	if (prev && prev != root)
>  		css_put(&prev->css);
>  
[...]
-- 
Michal Hocko
SUSE Labs
