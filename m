Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab3DCDtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:49:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:5567 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab3DCDtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:49:50 -0400
Message-ID: <515BA6C9.2000704@huawei.com>
Date: Wed, 3 Apr 2013 11:49:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH -v2] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
References: <515A8A40.6020406@huawei.com> <20130402121600.GK24345@dhcp22.suse.cz> <20130402141646.GQ24345@dhcp22.suse.cz> <515AE948.1000704@parallels.com> <20130402142825.GA32520@dhcp22.suse.cz> <515AEC3A.2030401@parallels.com> <20130402150422.GB32520@dhcp22.suse.cz>
In-Reply-To: <20130402150422.GB32520@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes, indeed you are very right - and thanks for looking at such depth.
> 
> So what about the patch bellow? It seems that I provoked all this mess
> but my brain managed to push it away so I do not remember why I thought
> the parent needs reference drop... It is "only" 3.9 thing fortunately.
> ---
>>From 3aff5d958f1d0717795018f7d0d6b63d53ad1dd3 Mon Sep 17 00:00:00 2001
> From: Li Zefan <lizefan@huawei.com>
> Date: Tue, 2 Apr 2013 16:37:39 +0200
> Subject: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
>  fails
> 
> mem_cgroup_css_online is called with memcg with refcnt = 1 and it
> expects that mem_cgroup_css_free will drop this last reference.
> This doesn't hold when memcg_init_kmem fails though and a reference is
> dropped for both memcg and its parent explicitly if it returns with an
> error.
> 
> This is not correct for two reasons. Firstly mem_cgroup_put on parent is
> excessive because mem_cgroup_put is hierarchy aware and secondly only
> memcg_propagate_kmem takes an additional reference.
> 
> The first one is a real use-after-free bug introduced by e4715f01
> (memcg: avoid dangling reference count in creation failure)
> 
> The later one is non-issue right now because the only implementation
> of init_cgroup seems to be tcp_init_cgroup which doesn't fail
> but it is better to make the error handling saner and move the
> mem_cgroup_put(memcg) to memcg_propagate_kmem where it belongs.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/memcontrol.c |   13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f608546..cf9ba7e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5306,6 +5306,8 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
>  	ret = memcg_update_cache_sizes(memcg);
>  	mutex_unlock(&set_limit_mutex);
>  out:
> +	if (ret)
> +		mem_cgroup_put(memcg);

Correct me if I'm wrong, but I think:

When memcg_propagate_kmem() calls mem_cgroup_get(), it's because the kmemcg
is active by inheritance. Then when memcg_update_cache_sizes() fails, leading
to mem_cgroup_css_free() is called by cgroup core:

static void mem_cgroup_css_free(struct cgroup *cont)
{
        struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);

        kmem_cgroup_destroy(memcg);

        mem_cgroup_put(memcg);
}

static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
{
        mem_cgroup_sockets_destroy(memcg);

        memcg_kmem_mark_dead(memcg);

        if (res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0)
                return;

        if (memcg_kmem_test_and_clear_dead(memcg))
                mem_cgroup_put(memcg);    <------- !!!!!!!!!
}

>  	return ret;
>  }
>  #endif /* CONFIG_MEMCG_KMEM */
> @@ -6417,16 +6419,7 @@ mem_cgroup_css_online(struct cgroup *cont)
>  
>  	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
>  	mutex_unlock(&memcg_create_mutex);
> -	if (error) {
> -		/*
> -		 * We call put now because our (and parent's) refcnts
> -		 * are already in place. mem_cgroup_put() will internally
> -		 * call __mem_cgroup_free, so return directly
> -		 */
> -		mem_cgroup_put(memcg);
> -		if (parent->use_hierarchy)
> -			mem_cgroup_put(parent);
> -	}
> +
>  	return error;
>  }
>  
> 

