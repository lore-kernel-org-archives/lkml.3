Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaJVQay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:30:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaJVQav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:30:51 -0400
Date: Wed, 22 Oct 2014 18:30:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: fix missed end-writeback accounting
Message-ID: <20141022163051.GH30802@dhcp22.suse.cz>
References: <1413915550-5651-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413915550-5651-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-10-14 14:19:10, Johannes Weiner wrote:
> 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") changed page
> migration to uncharge the old page right away.  The page is locked,
> unmapped, truncated, and off the LRU.  But it could race with a
> finishing writeback, which then doesn't get unaccounted properly:
> 
> test_clear_page_writeback()              migration
>   acquire pc->mem_cgroup->move_lock
>                                            wait_on_page_writeback()
>   TestClearPageWriteback()
>                                            mem_cgroup_migrate()
>                                              clear PCG_USED
>   if (PageCgroupUsed(pc))
>     decrease memcg pages under writeback
>   release pc->mem_cgroup->move_lock
> 
> One solution for this would be to simply remove the PageCgroupUsed()
> check, as RCU protects the memcg anyway.
> 
> However, it's more robust to acknowledge that migration is really
> modifying the charge state of alive pages in this case, and so it
> should participate in the protocol specifically designed for this.

It's been a long day so I might be missing something really obvious
here. But how can move_lock help here when the fast path (no task
migration is going on) takes only RCU read lock?

> Fixes: 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "3.17" <stable@vger.kernel.org>
> ---
>  mm/memcontrol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3a203c7ec6c7..b35a44e9cd37 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6148,6 +6148,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  			bool lrucare)
>  {
>  	struct page_cgroup *pc;
> +	unsigned long flags;
>  	int isolated;
>  
>  	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
> @@ -6177,7 +6178,14 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (lrucare)
>  		lock_page_lru(oldpage, &isolated);
>  
> +	/*
> +	 * The page is locked, unmapped, truncated, and off the LRU,
> +	 * but there might still be references, e.g. from finishing
> +	 * writeback.  Follow the charge moving protocol here.
> +	 */
> +	move_lock_mem_cgroup(pc->mem_cgroup, &flags);
>  	pc->flags = 0;
> +	move_unlock_mem_cgroup(pc->mem_cgroup, &flags);
>  
>  	if (lrucare)
>  		unlock_page_lru(oldpage, isolated);
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
