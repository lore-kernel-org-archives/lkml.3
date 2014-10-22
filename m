Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaJVGw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:52:26 -0400
Received: from mx2.parallels.com ([199.115.105.18]:44030 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJVGwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:52:25 -0400
Date: Wed, 22 Oct 2014 10:52:17 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] mm: memcontrol: don't pass a NULL memcg to
 mem_cgroup_end_move()
Message-ID: <20141022065217.GS16496@esperanza>
References: <1413922896-29042-1-git-send-email-hannes@cmpxchg.org>
 <1413922896-29042-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1413922896-29042-2-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:21:34PM -0400, Johannes Weiner wrote:
> mem_cgroup_end_move() checks if the passed memcg is NULL, along with a
> lengthy comment to explain why this seemingly non-sensical situation
> is even possible.
> 
> Check in cancel_attach() itself whether can_attach() set up the move
> context or not, it's a lot more obvious from there.  Then remove the
> check and comment in mem_cgroup_end_move().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov@parallels.com>

> ---
>  mm/memcontrol.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1ff125d2a427..c1fe774d712a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1452,14 +1452,8 @@ static void mem_cgroup_start_move(struct mem_cgroup *memcg)
>  
>  static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>  {
> -	/*
> -	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
> -	 * We check NULL in callee rather than caller.
> -	 */
> -	if (memcg) {
> -		atomic_dec(&memcg_moving);
> -		atomic_dec(&memcg->moving_account);
> -	}
> +	atomic_dec(&memcg_moving);
> +	atomic_dec(&memcg->moving_account);
>  }
>  
>  /*
> @@ -5383,7 +5377,8 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
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
