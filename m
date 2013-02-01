Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3BAImu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:42:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab3BAIms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:42:48 -0500
Date: Fri, 1 Feb 2013 09:42:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: refactor inactive_file_is_low() to use get_lru_size()
Message-ID: <20130201084245.GA21516@dhcp22.suse.cz>
References: <1359699116-7277-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359699116-7277-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 01-02-13 01:11:56, Johannes Weiner wrote:
> An inactive file list is considered low when the its active
> counter-part is bigger, regardless of whether it is a global zone LRU
> list or a memcg zone LRU list.  The only difference is in how the LRU
> size is assessed.
> 
> get_lru_size() does the right thing for both global and memcg reclaim
> situations.
> 
> Get rid of inactive_file_is_low_global() and
> mem_cgroup_inactive_file_is_low() by using get_lru_size() and compare
> the numbers in common code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Looks good to me
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/memcontrol.h |  7 -------
>  mm/memcontrol.c            | 11 -----------
>  mm/vmscan.c                | 19 ++++++-------------
>  3 files changed, 6 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0108a56..d21ddbf 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -116,7 +116,6 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
>   * For memory reclaim.
>   */
>  int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec);
> -int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec);
>  int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
>  unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
>  void mem_cgroup_update_lru_size(struct lruvec *, enum lru_list, int);
> @@ -321,12 +320,6 @@ mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
>  	return 1;
>  }
>  
> -static inline int
> -mem_cgroup_inactive_file_is_low(struct lruvec *lruvec)
> -{
> -	return 1;
> -}
> -
>  static inline unsigned long
>  mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7c8d449..6682553 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1445,17 +1445,6 @@ int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
>  	return inactive * inactive_ratio < active;
>  }
>  
> -int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec)
> -{
> -	unsigned long active;
> -	unsigned long inactive;
> -
> -	inactive = mem_cgroup_get_lru_size(lruvec, LRU_INACTIVE_FILE);
> -	active = mem_cgroup_get_lru_size(lruvec, LRU_ACTIVE_FILE);
> -
> -	return (active > inactive);
> -}
> -
>  #define mem_cgroup_from_res_counter(counter, member)	\
>  	container_of(counter, struct mem_cgroup, member)
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1b4c9e6..506388b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1581,16 +1581,6 @@ static inline int inactive_anon_is_low(struct lruvec *lruvec)
>  }
>  #endif
>  
> -static int inactive_file_is_low_global(struct zone *zone)
> -{
> -	unsigned long active, inactive;
> -
> -	active = zone_page_state(zone, NR_ACTIVE_FILE);
> -	inactive = zone_page_state(zone, NR_INACTIVE_FILE);
> -
> -	return (active > inactive);
> -}
> -
>  /**
>   * inactive_file_is_low - check if file pages need to be deactivated
>   * @lruvec: LRU vector to check
> @@ -1607,10 +1597,13 @@ static int inactive_file_is_low_global(struct zone *zone)
>   */
>  static int inactive_file_is_low(struct lruvec *lruvec)
>  {
> -	if (!mem_cgroup_disabled())
> -		return mem_cgroup_inactive_file_is_low(lruvec);
> +	unsigned long inactive;
> +	unsigned long active;
> +
> +	inactive = get_lru_size(lruvec, LRU_INACTIVE_FILE);
> +	active = get_lru_size(lruvec, LRU_ACTIVE_FILE);
>  
> -	return inactive_file_is_low_global(lruvec_zone(lruvec));
> +	return active > inactive;
>  }
>  
>  static int inactive_list_is_low(struct lruvec *lruvec, enum lru_list lru)
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
