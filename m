Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab3CVBWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:22:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32650 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab3CVBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:22:22 -0400
Message-ID: <514BB23E.70908@huawei.com>
Date: Fri, 22 Mar 2013 09:22:06 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
References: <514A60CD.60208@huawei.com> <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz>
In-Reply-To: <20130321102257.GH6094@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/21 18:22, Michal Hocko wrote:
> On Thu 21-03-13 10:08:49, Michal Hocko wrote:
>> On Thu 21-03-13 09:22:21, Li Zefan wrote:
>>> As cgroup supports rename, it's unsafe to dereference dentry->d_name
>>> without proper vfs locks. Fix this by using cgroup_name().
>>>
>>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>>> ---
>>>
>>> This patch depends on "cgroup: fix cgroup_path() vs rename() race",
>>> which has been queued for 3.10.
>>>
>>> ---
>>>  mm/memcontrol.c | 15 +++++++--------
>>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 53b8201..72be5c9 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -3217,17 +3217,16 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
>>>  static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
>>>  {
>>>  	char *name;
>>> -	struct dentry *dentry;
>>> +
>>> +	name = (char *)__get_free_page(GFP_TEMPORARY);
>>
>> Ouch. Can we use a static temporary buffer instead?
> 
>> This is called from workqueue context so we do not have to be afraid
>> of the deep call chain.
> 
> Bahh, I was thinking about two things at the same time and that is how
> it ends... I meant a temporary buffer on the stack. But a separate
> allocation sounds even easier.
> 

Actually I don't care much about which way to take. Use on-stack buffer (if stack
usage is not a concern) or local static buffer (caller already held memcg_cache_mutex)
is simplest.

But why it's bad to allocate a page for temp use?

>> It is also not a hot path AFAICS.
>>
>> Even GFP_ATOMIC for kasprintf would be an improvement IMO.
> 
> What about the following (not even compile tested because I do not have
> cgroup_name in my tree yet):

No, it won't compile. ;)

> ---
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f608546..ede0382 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3370,13 +3370,18 @@ static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
>  	struct dentry *dentry;
>  
>  	rcu_read_lock();
> -	dentry = rcu_dereference(memcg->css.cgroup->dentry);
> +	name = kasprintf(GFP_ATOMIC, "%s(%d:%s)", s->name,
> +			 memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
>  	rcu_read_unlock();
>  
> -	BUG_ON(dentry == NULL);
> -
> -	name = kasprintf(GFP_KERNEL, "%s(%d:%s)", s->name,
> -			 memcg_cache_id(memcg), dentry->d_name.name);
> +	if (!name) {
> +		name = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		rcu_read_lock();
> +		name = snprintf(name, PAGE_SIZE, "%s(%d:%s)", s->name,
> +				memcg_cache_id(memcg),
> +				cgroup_name(memcg->css.cgroup));
> +		rcu_read_unlock();
> +	}
>  
>  	return name;
>  }
> 

