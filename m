Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3FFMX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:23:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933437Ab3FFMXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:23:24 -0400
Date: Thu, 6 Jun 2013 14:23:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: clean up memcg->nodeinfo
Message-ID: <20130606122321.GF7909@dhcp22.suse.cz>
References: <1370487934-4547-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370487934-4547-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-06-13 23:05:34, Johannes Weiner wrote:
> Remove struct mem_cgroup_lru_info and fold its single member, the
> variably sized nodeinfo[0], directly into struct mem_cgroup.  This
> should make it more obvious why it has to be the last member there.
> 
> Also move the comment that's above that special last member below it,
> so it is more visible to somebody that considers appending to the
> struct mem_cgroup.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

It would be better to make this a regular array in the long term. But
this is definitely an improvement

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!
> ---
>  mm/memcontrol.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ff7b40d..d169a8d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -187,10 +187,6 @@ struct mem_cgroup_per_node {
>  	struct mem_cgroup_per_zone zoneinfo[MAX_NR_ZONES];
>  };
>  
> -struct mem_cgroup_lru_info {
> -	struct mem_cgroup_per_node *nodeinfo[0];
> -};
> -
>  /*
>   * Cgroups above their limits are maintained in a RB-Tree, independent of
>   * their hierarchy representation
> @@ -384,14 +380,9 @@ struct mem_cgroup {
>  #endif
>  	/* when kmem shrinkers can sleep but can't proceed due to context */
>  	struct work_struct kmemcg_shrink_work;
> -	/*
> -	 * Per cgroup active and inactive list, similar to the
> -	 * per zone LRU lists.
> -	 *
> -	 * WARNING: This has to be the last element of the struct. Don't
> -	 * add new fields after this point.
> -	 */
> -	struct mem_cgroup_lru_info info;
> +
> +	struct mem_cgroup_per_node *nodeinfo[0];
> +	/* WARNING: nodeinfo has to be the last member here */
>  };
>  
>  static size_t memcg_size(void)
> @@ -777,7 +768,7 @@ static struct mem_cgroup_per_zone *
>  mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
>  {
>  	VM_BUG_ON((unsigned)nid >= nr_node_ids);
> -	return &memcg->info.nodeinfo[nid]->zoneinfo[zid];
> +	return &memcg->nodeinfo[nid]->zoneinfo[zid];
>  }
>  
>  struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
> @@ -6595,13 +6586,13 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>  		mz->on_tree = false;
>  		mz->memcg = memcg;
>  	}
> -	memcg->info.nodeinfo[node] = pn;
> +	memcg->nodeinfo[node] = pn;
>  	return 0;
>  }
>  
>  static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>  {
> -	kfree(memcg->info.nodeinfo[node]);
> +	kfree(memcg->nodeinfo[node]);
>  }
>  
>  static struct mem_cgroup *mem_cgroup_alloc(void)
> -- 
> 1.8.2.3
> 

-- 
Michal Hocko
SUSE Labs
