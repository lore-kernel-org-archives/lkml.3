Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab3DBMVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:21:45 -0400
Received: from mx2.parallels.com ([199.115.105.18]:40946 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759502Ab3DBMVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:21:43 -0400
Message-ID: <515ACD7F.3070009@parallels.com>
Date: Tue, 2 Apr 2013 16:22:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
References: <515A8A40.6020406@huawei.com> <20130402121600.GK24345@dhcp22.suse.cz>
In-Reply-To: <20130402121600.GK24345@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:16 PM, Michal Hocko wrote:
> On Tue 02-04-13 15:35:28, Li Zefan wrote:
> [...]
>> @@ -6247,16 +6247,7 @@ mem_cgroup_css_online(struct cgroup *cont)
>>  
>>  	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
>>  	mutex_unlock(&memcg_create_mutex);
>> -	if (error) {
>> -		/*
>> -		 * We call put now because our (and parent's) refcnts
>> -		 * are already in place. mem_cgroup_put() will internally
>> -		 * call __mem_cgroup_free, so return directly
>> -		 */
>> -		mem_cgroup_put(memcg);
>> -		if (parent->use_hierarchy)
>> -			mem_cgroup_put(parent);
>> -	}
>> +
>>  	return error;
>>  }
> 
> The mem_cgroup_put(parent) part is incorrect because mem_cgroup_put goes
> up the hierarchy already but I do not think mem_cgroup_put(memcg) should
> go away as well. Who is going to free the last reference then?
> 
> Maybe I am missing something but we have:
> cgroup_create
>   css = ss->css_alloc(cgrp)
>     mem_cgroup_css_alloc
>       atomic_set(&memcg->refcnt, 1)
>   online_css(ss, cgrp)
>     mem_cgroup_css_online
>       error = memcg_init_kmem		# fails
>   goto err_destroy
> err_destroy:
>   cgroup_destroy_locked(cgrp)
>     offline_css
>       mem_cgroup_css_offline
> 
> no mem_cgroup_put on the way.
> 

static void mem_cgroup_css_free(struct cgroup *cont)
{
        struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);

        kmem_cgroup_destroy(memcg);

        mem_cgroup_put(memcg);
}

kernel/cgroup.c:
err_free_all:
        for_each_subsys(root, ss) {
                if (cgrp->subsys[ss->subsys_id])
                        ss->css_free(cgrp);
        }

As I've said, this error path predates kmemcg for a long time. I wasn't
still able to identify precisely why it was working - assuming it was
indeed working (I remember having tested it with handcrafted manual
errors, but memory can always fail...).

But our best theory so far is that the cgroup rework started calling the
free function that wasn't called before.

