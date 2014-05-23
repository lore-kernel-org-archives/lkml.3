Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaEWNUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:20:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaEWNUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:20:47 -0400
Date: Fri, 23 May 2014 15:20:43 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/9] mm: memcontrol: remove ordering between
 pc->mem_cgroup and PageCgroupUsed
Message-ID: <20140523132043.GB22135@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-7-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398889543-23671-7-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 16:25:40, Johannes Weiner wrote:
> There is a write barrier between setting pc->mem_cgroup and
> PageCgroupUsed, which was added to allow LRU operations to lookup the
> memcg LRU list of a page without acquiring the page_cgroup lock.  But
> ever since 38c5d72f3ebe ("memcg: simplify LRU handling by new rule"),
> pages are ensured to be off-LRU while charging, so nobody else is
> changing LRU state while pc->mem_cgroup is being written.

This is quite confusing. Why do we have the lrucare path then?
The code is quite tricky so this deserves a more detailed explanation
IMO.

There are only 3 paths which check both the flag and mem_cgroup (
without page_cgroup_lock) get_mctgt_type* and mem_cgroup_page_lruvec AFAICS.
None of them have rmb so there was no guarantee about ordering anyway.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Anyway, the change is welcome
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 34407d99262a..c528ae9ac230 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2823,14 +2823,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>  	}
>  
>  	pc->mem_cgroup = memcg;
> -	/*
> -	 * We access a page_cgroup asynchronously without lock_page_cgroup().
> -	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
> -	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
> -	 * before USED bit, we need memory barrier here.
> -	 * See mem_cgroup_add_lru_list(), etc.
> -	 */
> -	smp_wmb();
>  	SetPageCgroupUsed(pc);
>  
>  	if (lrucare) {
> @@ -3609,7 +3601,6 @@ void mem_cgroup_split_huge_fixup(struct page *head)
>  	for (i = 1; i < HPAGE_PMD_NR; i++) {
>  		pc = head_pc + i;
>  		pc->mem_cgroup = memcg;
> -		smp_wmb();/* see __commit_charge() */
>  		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
>  	}
>  	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
> -- 
> 1.9.2
> 

-- 
Michal Hocko
SUSE Labs
