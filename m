Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaHEMYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:24:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbaHEMYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:24:39 -0400
Date: Tue, 5 Aug 2014 14:24:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: avoid charge statistics churn during
 page migration
Message-ID: <20140805122434.GD15908@dhcp22.suse.cz>
References: <1407184469-20741-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407184469-20741-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 04-08-14 16:34:29, Johannes Weiner wrote:
> Charge migration currently disables IRQs twice to update the charge
> statistics for the old page and then again for the new page.
> 
> But migration is a seemless transition of a charge from one physical
> page to another one of the same size, so this should be a non-event
> from an accounting point of view.  Leave the statistics alone.

Moving stats to mem_cgroup_commit_charge sounds logical to me but does
this work properly even for the fuse replace page cache case when old
and new pages can already live in different memcgs?

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 35 ++++++++++-------------------------
>  1 file changed, 10 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 475ecadd9646..8d65dadeec1b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2728,7 +2728,7 @@ static void unlock_page_lru(struct page *page, int isolated)
>  }
>  
>  static void commit_charge(struct page *page, struct mem_cgroup *memcg,
> -			  unsigned int nr_pages, bool lrucare)
> +			  bool lrucare)
>  {
>  	struct page_cgroup *pc = lookup_page_cgroup(page);
>  	int isolated;
> @@ -2765,16 +2765,6 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
>  
>  	if (lrucare)
>  		unlock_page_lru(page, isolated);
> -
> -	local_irq_disable();
> -	mem_cgroup_charge_statistics(memcg, page, nr_pages);
> -	/*
> -	 * "charge_statistics" updated event counter. Then, check it.
> -	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
> -	 * if they exceeds softlimit.
> -	 */
> -	memcg_check_events(memcg, page);
> -	local_irq_enable();
>  }
>  
>  static DEFINE_MUTEX(set_limit_mutex);
> @@ -6460,12 +6450,17 @@ void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
>  	if (!memcg)
>  		return;
>  
> +	commit_charge(page, memcg, lrucare);
> +
>  	if (PageTransHuge(page)) {
>  		nr_pages <<= compound_order(page);
>  		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
>  	}
>  
> -	commit_charge(page, memcg, nr_pages, lrucare);
> +	local_irq_disable();
> +	mem_cgroup_charge_statistics(memcg, page, nr_pages);
> +	memcg_check_events(memcg, page);
> +	local_irq_enable();
>  
>  	if (do_swap_account && PageSwapCache(page)) {
>  		swp_entry_t entry = { .val = page_private(page) };
> @@ -6651,7 +6646,6 @@ void mem_cgroup_uncharge_list(struct list_head *page_list)
>  void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  			bool lrucare)
>  {
> -	unsigned int nr_pages = 1;
>  	struct page_cgroup *pc;
>  	int isolated;
>  
> @@ -6660,6 +6654,8 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	VM_BUG_ON_PAGE(!lrucare && PageLRU(oldpage), oldpage);
>  	VM_BUG_ON_PAGE(!lrucare && PageLRU(newpage), newpage);
>  	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
> +	VM_BUG_ON_PAGE(PageTransHuge(oldpage) != PageTransHuge(newpage),
> +		       newpage);
>  
>  	if (mem_cgroup_disabled())
>  		return;
> @@ -6677,12 +6673,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
>  	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
>  
> -	if (PageTransHuge(oldpage)) {
> -		nr_pages <<= compound_order(oldpage);
> -		VM_BUG_ON_PAGE(!PageTransHuge(oldpage), oldpage);
> -		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
> -	}
> -
>  	if (lrucare)
>  		lock_page_lru(oldpage, &isolated);
>  
> @@ -6691,12 +6681,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (lrucare)
>  		unlock_page_lru(oldpage, isolated);
>  
> -	local_irq_disable();
> -	mem_cgroup_charge_statistics(pc->mem_cgroup, oldpage, -nr_pages);
> -	memcg_check_events(pc->mem_cgroup, oldpage);
> -	local_irq_enable();
> -
> -	commit_charge(newpage, pc->mem_cgroup, nr_pages, lrucare);
> +	commit_charge(newpage, pc->mem_cgroup, lrucare);
>  }
>  
>  /*
> -- 
> 2.0.3
> 

-- 
Michal Hocko
SUSE Labs
