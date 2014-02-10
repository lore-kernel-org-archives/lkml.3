Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaBJOT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:19:59 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:46272 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaBJOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:19:58 -0500
Date: Mon, 10 Feb 2014 15:19:54 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] mm: memcg: remove mem_cgroup_move_account_page_stat()
Message-ID: <20140210141954.GH7117@dhcp22.suse.cz>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
 <1391792665-21678-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391792665-21678-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-02-14 12:04:19, Johannes Weiner wrote:
> It used to disable preemption and run sanity checks but now it's only
> taking a number out of one percpu counter and putting it into another.
> Do this directly in the callsite and save the indirection.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

OK, why not.
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index befb3dd9d46c..639cf58b2643 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3776,16 +3776,6 @@ void mem_cgroup_split_huge_fixup(struct page *head)
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> -static void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
> -					      struct mem_cgroup *to,
> -					      unsigned int nr_pages,
> -					      enum mem_cgroup_stat_index idx)
> -{
> -	/* Update stat data for mem_cgroup */
> -	__this_cpu_sub(from->stat->count[idx], nr_pages);
> -	__this_cpu_add(to->stat->count[idx], nr_pages);
> -}
> -
>  /**
>   * mem_cgroup_move_account - move account of the page
>   * @page: the page
> @@ -3831,13 +3821,19 @@ static int mem_cgroup_move_account(struct page *page,
>  
>  	move_lock_mem_cgroup(from, &flags);
>  
> -	if (!anon && page_mapped(page))
> -		mem_cgroup_move_account_page_stat(from, to, nr_pages,
> -			MEM_CGROUP_STAT_FILE_MAPPED);
> +	if (!anon && page_mapped(page)) {
> +		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
> +			       nr_pages);
> +		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
> +			       nr_pages);
> +	}
>  
> -	if (PageWriteback(page))
> -		mem_cgroup_move_account_page_stat(from, to, nr_pages,
> -			MEM_CGROUP_STAT_WRITEBACK);
> +	if (PageWriteback(page)) {
> +		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_WRITEBACK],
> +			       nr_pages);
> +		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_WRITEBACK],
> +			       nr_pages);
> +	}
>  
>  	mem_cgroup_charge_statistics(from, page, anon, -nr_pages);
>  
> -- 
> 1.8.5.3
> 

-- 
Michal Hocko
SUSE Labs
