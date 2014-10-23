Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaJWPNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:13:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbaJWPNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:13:20 -0400
Date: Thu, 23 Oct 2014 17:13:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: don't pass a NULL memcg to
 mem_cgroup_end_move()
Message-ID: <20141023151318.GM23011@dhcp22.suse.cz>
References: <1414074830-14623-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414074830-14623-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-10-14 10:33:50, Johannes Weiner wrote:
> mem_cgroup_end_move() checks if the passed memcg is NULL, along with a
> lengthy comment to explain why this seemingly non-sensical situation
> is even possible.
> 
> Check in cancel_attach() itself whether can_attach() set up the move
> context or not, it's a lot more obvious from there.  Then remove the
> check and comment in mem_cgroup_end_move().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a5c9aa4688e8..3cd4f1e0bfb3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1469,12 +1469,7 @@ static void mem_cgroup_start_move(struct mem_cgroup *memcg)
>  
>  static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>  {
> -	/*
> -	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
> -	 * We check NULL in callee rather than caller.
> -	 */
> -	if (memcg)
> -		atomic_dec(&memcg->moving_account);
> +	atomic_dec(&memcg->moving_account);
>  }
>  
>  /*
> @@ -5489,7 +5484,8 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
>  static void mem_cgroup_cancel_attach(struct cgroup_subsys_state *css,
>  				     struct cgroup_taskset *tset)
>  {
> -	mem_cgroup_clear_mc();
> +	if (mc.to)
> +		mem_cgroup_clear_mc();
>  }
>  
>  static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
