Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbaFQNxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:53:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbaFQNxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:53:46 -0400
Date: Tue, 17 Jun 2014 15:53:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 04/12] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Message-ID: <20140617135344.GC19886@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-5-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402948472-8175-5-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-06-14 15:54:24, Johannes Weiner wrote:
> There is no reason why oom-disabled and __GFP_NOFAIL charges should
> try to reclaim only once when every other charge tries several times
> before giving up.  Make them all retry the same number of times.

OK, this makes sense for oom-disabled and __GFP_NOFAIL but does it make
sense to do additional reclaim for tasks with fatal_signal_pending?

It is little bit unexpected, because we bypass if the condition happens
before the reclaim but then we ignore it.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e946f7439b16..52550bbff1ef 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2566,7 +2566,7 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
>  				 bool oom)
>  {
>  	unsigned int batch = max(CHARGE_BATCH, nr_pages);
> -	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>  	struct mem_cgroup *mem_over_limit;
>  	struct res_counter *fail_res;
>  	unsigned long nr_reclaimed;
> @@ -2638,6 +2638,9 @@ retry:
>  	if (mem_cgroup_wait_acct_move(mem_over_limit))
>  		goto retry;
>  
> +	if (nr_retries--)
> +		goto retry;
> +
>  	if (gfp_mask & __GFP_NOFAIL)
>  		goto bypass;
>  
> @@ -2647,9 +2650,6 @@ retry:
>  	if (!oom)
>  		goto nomem;
>  
> -	if (nr_oom_retries--)
> -		goto retry;
> -
>  	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
>  nomem:
>  	if (!(gfp_mask & __GFP_NOFAIL))
> -- 
> 2.0.0
> 

-- 
Michal Hocko
SUSE Labs
