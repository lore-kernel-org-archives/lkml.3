Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161730Ab3DENjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:39:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161548Ab3DENjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:39:10 -0400
Date: Fri, 5 Apr 2013 15:39:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 1/7] memcg: use css_get in sock_update_memcg()
Message-ID: <20130405133909.GF31132@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <515BF249.50607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515BF249.50607@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-04-13 17:11:37, Li Zefan wrote:
> Use css_get/css_put instead of mem_cgroup_get/put.
> 
> Note, if at the same time someone is moving @current to a different
> cgroup and removing the old cgroup, css_tryget() may return false,
> and sock->sk_cgrp won't be initialized.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 23d0f6e..43ca91d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -536,15 +536,15 @@ void sock_update_memcg(struct sock *sk)
>  		 */
>  		if (sk->sk_cgrp) {
>  			BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
> -			mem_cgroup_get(sk->sk_cgrp->memcg);
> +			css_get(&sk->sk_cgrp->memcg->css);
>  			return;
>  		}
>  
>  		rcu_read_lock();
>  		memcg = mem_cgroup_from_task(current);
>  		cg_proto = sk->sk_prot->proto_cgroup(memcg);
> -		if (!mem_cgroup_is_root(memcg) && memcg_proto_active(cg_proto)) {
> -			mem_cgroup_get(memcg);
> +		if (!mem_cgroup_is_root(memcg) &&
> +		    memcg_proto_active(cg_proto) && css_tryget(&memcg->css)) {
>  			sk->sk_cgrp = cg_proto;
>  		}
>  		rcu_read_unlock();
> @@ -558,7 +558,7 @@ void sock_release_memcg(struct sock *sk)
>  		struct mem_cgroup *memcg;
>  		WARN_ON(!sk->sk_cgrp->memcg);
>  		memcg = sk->sk_cgrp->memcg;
> -		mem_cgroup_put(memcg);
> +		css_put(&sk->sk_cgrp->memcg->css);
>  	}
>  }
>  
> -- 
> 1.8.0.2

-- 
Michal Hocko
SUSE Labs
