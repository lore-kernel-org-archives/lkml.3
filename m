Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaIVJxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:53:31 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33400 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaIVJxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:53:30 -0400
Date: Mon, 22 Sep 2014 13:53:21 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch v2] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Message-ID: <20140922095321.GA20398@esperanza>
References: <1411161059-16552-1-git-send-email-hannes@cmpxchg.org>
 <20140919212843.GA23861@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140919212843.GA23861@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 05:28:43PM -0400, Johannes Weiner wrote:
> The memcg reclaim iterators use a complicated weak reference scheme to
> prevent pinning cgroups indefinitely in the absence of memory pressure.
> 
> However, during the ongoing cgroup core rework, css lifetime has been
> decoupled such that a pinned css no longer interferes with removal of
> the user-visible cgroup, and all this complexity is now unnecessary.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 201 ++++++++++----------------------------------------------
>  1 file changed, 34 insertions(+), 167 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
[...]
> -static void mem_cgroup_iter_invalidate(struct mem_cgroup *root)
> -{
> -	/*
> -	 * When a group in the hierarchy below root is destroyed, the
> -	 * hierarchy iterator can no longer be trusted since it might
> -	 * have pointed to the destroyed group.  Invalidate it.
> -	 */
> -	atomic_inc(&root->dead_count);

After your patch is applied, mem_cgroup->dead_count is not used any
more. Please remove it.

[...]
> @@ -1300,8 +1183,11 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  				   struct mem_cgroup *prev,
>  				   struct mem_cgroup_reclaim_cookie *reclaim)
>  {
> +	struct mem_cgroup_per_zone *uninitialized_var(mz);
> +	struct cgroup_subsys_state *css = NULL;
> +	int uninitialized_var(priority);
>  	struct mem_cgroup *memcg = NULL;
> -	struct mem_cgroup *last_visited = NULL;
> +	struct mem_cgroup *pos = NULL;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
> @@ -1310,50 +1196,51 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  		root = root_mem_cgroup;
>  
>  	if (prev && !reclaim)
> -		last_visited = prev;
> +		pos = prev;
>  
>  	if (!root->use_hierarchy && root != root_mem_cgroup) {
>  		if (prev)
> -			goto out_css_put;
> +			goto out;
>  		return root;
>  	}
>  
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

Again, you are removing all generation checks, but leaving
mem_cgroup_reclaim_cookie->generation defined. Please remove it too.

BTW, don't we still need the generation check to eliminate the
possibility of a process iterating infinitely over a memory cgroup tree
in case of concurrent reclaim?

Thanks,
Vladimir
