Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821Ab3DCM6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:58:20 -0400
Received: from mx2.parallels.com ([199.115.105.18]:36395 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572Ab3DCM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:58:19 -0400
Message-ID: <515C2788.90907@parallels.com>
Date: Wed, 3 Apr 2013 16:58:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 1/7] memcg: use css_get in sock_update_memcg()
References: <515BF233.6070308@huawei.com> <515BF249.50607@huawei.com>
In-Reply-To: <515BF249.50607@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 01:11 PM, Li Zefan wrote:
> Use css_get/css_put instead of mem_cgroup_get/put.
> 
> Note, if at the same time someone is moving @current to a different
> cgroup and removing the old cgroup, css_tryget() may return false,
> and sock->sk_cgrp won't be initialized.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
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

What happens if this tryget fails ? Won't we leak a reference here? We
will put regardless when the socket is released, and this may go
negative. No?

