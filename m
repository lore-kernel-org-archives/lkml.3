Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaBJOXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:23:52 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:35379 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaBJOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:23:48 -0500
Date: Mon, 10 Feb 2014 15:23:44 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] memcg: update comment about charge reparenting on
 cgroup exit
Message-ID: <20140210142344.GI7117@dhcp22.suse.cz>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
 <1391792665-21678-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391792665-21678-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-02-14 12:04:20, Johannes Weiner wrote:
> Reparenting memory charges in the css_free() callback was meant as a
> temporary fix for charges that race with offlining, but after some
> follow-up discussion, it turns out that this is really the right place
> to reparent charges because it guarantees none are in-flight.
> 
> Make clear that the reparenting in css_offline() is an optimistic
> sweep of established charges because swapout records might hold up
> css_free() indefinitely, but that in fact the css_free() reparenting
> is the properly synchronized one.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

OK, I am still thinking about 2 stage reparenting. LRU drain part called
from css_offline and charge drain from css_free. But this is a
sufficient for now.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 52 +++++++++++++++-------------------------------------
>  1 file changed, 15 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 639cf58b2643..b8a96c7d1167 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6600,51 +6600,29 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	kmem_cgroup_css_offline(memcg);
>  
>  	mem_cgroup_invalidate_reclaim_iterators(memcg);
> -	mem_cgroup_reparent_charges(memcg);
>  	mem_cgroup_destroy_all_caches(memcg);
>  	vmpressure_cleanup(&memcg->vmpressure);
> +	/*
> +	 * Memcg gets css references while charging the res_counter,
> +	 * so we reparent charges in .css_free() when the references
> +	 * are gone and we know there are no in-flight charges.
> +	 *
> +	 * However, at this time, swapout records also hold css refs
> +	 * indefinitely beyond offlining, which prevent .css_free()
> +	 * from being called.  But after offlining, css_tryget() is
> +	 * disabled, which means that all the left-over page cache in
> +	 * the group would be stuck without being reclaimable.  Clear
> +	 * out all those already established charges optimistically
> +	 * here, and catch any raced charges in .css_free() later on.
> +	 */
> +	mem_cgroup_reparent_charges(memcg);
>  }
>  
>  static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> -	/*
> -	 * XXX: css_offline() would be where we should reparent all
> -	 * memory to prepare the cgroup for destruction.  However,
> -	 * memcg does not do css_tryget() and res_counter charging
> -	 * under the same RCU lock region, which means that charging
> -	 * could race with offlining.  Offlining only happens to
> -	 * cgroups with no tasks in them but charges can show up
> -	 * without any tasks from the swapin path when the target
> -	 * memcg is looked up from the swapout record and not from the
> -	 * current task as it usually is.  A race like this can leak
> -	 * charges and put pages with stale cgroup pointers into
> -	 * circulation:
> -	 *
> -	 * #0                        #1
> -	 *                           lookup_swap_cgroup_id()
> -	 *                           rcu_read_lock()
> -	 *                           mem_cgroup_lookup()
> -	 *                           css_tryget()
> -	 *                           rcu_read_unlock()
> -	 * disable css_tryget()
> -	 * call_rcu()
> -	 *   offline_css()
> -	 *     reparent_charges()
> -	 *                           res_counter_charge()
> -	 *                           css_put()
> -	 *                             css_free()
> -	 *                           pc->mem_cgroup = dead memcg
> -	 *                           add page to lru
> -	 *
> -	 * The bulk of the charges are still moved in offline_css() to
> -	 * avoid pinning a lot of pages in case a long-term reference
> -	 * like a swapout record is deferring the css_free() to long
> -	 * after offlining.  But this makes sure we catch any charges
> -	 * made after offlining:
> -	 */
> -	mem_cgroup_reparent_charges(memcg);
>  
> +	mem_cgroup_reparent_charges(memcg);
>  	memcg_destroy_kmem(memcg);
>  	__mem_cgroup_free(memcg);
>  }
> -- 
> 1.8.5.3
> 

-- 
Michal Hocko
SUSE Labs
