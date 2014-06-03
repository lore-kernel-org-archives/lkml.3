Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaFCNXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbaFCNW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:22:58 -0400
Date: Tue, 3 Jun 2014 15:22:55 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 05/10] mm: memcontrol: catch root bypass in move precharge
Message-ID: <20140603132255.GJ1321@dhcp22.suse.cz>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
 <1401380162-24121-6-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401380162-24121-6-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-05-14 12:15:57, Johannes Weiner wrote:
> When mem_cgroup_try_charge() returns -EINTR, it bypassed the charge to
> the root memcg.  But move precharging does not catch this and treats
> this case as if no charge had happened, thus leaking a charge against
> root.  Because of an old optimization, the root memcg's res_counter is
> not actually charged right now, but it's still an imbalance and
> subsequent patches will charge the root memcg again.
> 
> Catch those bypasses to the root memcg and properly cancel them before
> giving up the move.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8957d6c945b8..184e67cce4e4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6485,8 +6485,15 @@ one_by_one:
>  			cond_resched();
>  		}
>  		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
> +		/*
> +		 * In case of failure, any residual charges against
> +		 * mc.to will be dropped by mem_cgroup_clear_mc()
> +		 * later on.  However, cancel any charges that are
> +		 * bypassed to root right away or they'll be lost.
> +		 */
> +		if (ret == -EINTR)
> +			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
>  		if (ret)
> -			/* mem_cgroup_clear_mc() will do uncharge later */
>  			return ret;
>  		mc.precharge++;
>  	}
> -- 
> 1.9.3
> 

-- 
Michal Hocko
SUSE Labs
