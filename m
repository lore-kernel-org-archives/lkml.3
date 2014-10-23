Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaJWPJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:09:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaJWPJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:09:47 -0400
Date: Thu, 23 Oct 2014 17:09:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: inline memcg->move_lock locking
Message-ID: <20141023150940.GL23011@dhcp22.suse.cz>
References: <1414074782-14340-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414074782-14340-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-10-14 10:33:02, Johannes Weiner wrote:
> The wrappers around taking and dropping the memcg->move_lock spinlock
> add nothing of value.  Inline the spinlock calls into the callsites.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 28 ++++++----------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 09fece0eb9f1..a5c9aa4688e8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1522,23 +1522,6 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
>  	return false;
>  }
>  
> -/*
> - * Take this lock when
> - * - a code tries to modify page's memcg while it's USED.
> - * - a code tries to modify page state accounting in a memcg.
> - */
> -static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
> -				  unsigned long *flags)
> -{
> -	spin_lock_irqsave(&memcg->move_lock, *flags);
> -}
> -
> -static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
> -				unsigned long *flags)
> -{
> -	spin_unlock_irqrestore(&memcg->move_lock, *flags);
> -}
> -
>  #define K(x) ((x) << (PAGE_SHIFT-10))
>  /**
>   * mem_cgroup_print_oom_info: Print OOM information relevant to memory controller.
> @@ -2156,9 +2139,9 @@ again:
>  	if (atomic_read(&memcg->moving_account) <= 0)
>  		return memcg;
>  
> -	move_lock_mem_cgroup(memcg, flags);
> +	spin_lock_irqsave(&memcg->move_lock, *flags);
>  	if (memcg != pc->mem_cgroup) {
> -		move_unlock_mem_cgroup(memcg, flags);
> +		spin_unlock_irqrestore(&memcg->move_lock, *flags);
>  		goto again;
>  	}
>  	*locked = true;
> @@ -2176,7 +2159,7 @@ void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
>  			      unsigned long flags)
>  {
>  	if (memcg && locked)
> -		move_unlock_mem_cgroup(memcg, &flags);
> +		spin_unlock_irqrestore(&memcg->move_lock, flags);
>  
>  	rcu_read_unlock();
>  }
> @@ -3219,7 +3202,7 @@ static int mem_cgroup_move_account(struct page *page,
>  	if (pc->mem_cgroup != from)
>  		goto out_unlock;
>  
> -	move_lock_mem_cgroup(from, &flags);
> +	spin_lock_irqsave(&from->move_lock, flags);
>  
>  	if (!PageAnon(page) && page_mapped(page)) {
>  		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
> @@ -3243,7 +3226,8 @@ static int mem_cgroup_move_account(struct page *page,
>  
>  	/* caller should have done css_get */
>  	pc->mem_cgroup = to;
> -	move_unlock_mem_cgroup(from, &flags);
> +	spin_unlock_irqrestore(&from->move_lock, flags);
> +
>  	ret = 0;
>  
>  	local_irq_disable();
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
