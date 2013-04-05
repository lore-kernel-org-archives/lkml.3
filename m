Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161617Ab3DEFv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:51:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33264 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161162Ab3DEFv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:51:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <515E664E.5060005@jp.fujitsu.com>
Date: Fri, 05 Apr 2013 14:51:10 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 2/7] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
References: <515BF233.6070308@huawei.com> <515BF275.5080408@huawei.com>
In-Reply-To: <515BF275.5080408@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/03 18:12), Li Zefan wrote:
> Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>   mm/memcontrol.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 43ca91d..dafacb8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3191,7 +3191,7 @@ void memcg_release_cache(struct kmem_cache *s)
>   	list_del(&s->memcg_params->list);
>   	mutex_unlock(&memcg->slab_caches_mutex);
>   
> -	mem_cgroup_put(memcg);
> +	css_put(&memcg->css);
>   out:
>   	kfree(s->memcg_params);
>   }
> @@ -3350,16 +3350,18 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>   
>   	mutex_lock(&memcg_cache_mutex);
>   	new_cachep = cachep->memcg_params->memcg_caches[idx];
> -	if (new_cachep)
> +	if (new_cachep) {
> +		css_put(&memcg->css);
>   		goto out;
> +	}

Where css_get() against this is done ?

Thanks,
-Kame

