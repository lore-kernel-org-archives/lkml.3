Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab3CZHxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:53:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4801 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab3CZHw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:52:59 -0400
Message-ID: <515153C0.5070908@huawei.com>
Date: Tue, 26 Mar 2013 15:52:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
References: <514A60CD.60208@huawei.com> <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514EAC41.5050700@huawei.com> <20130325090629.GN2154@dhcp22.suse.cz>
In-Reply-To: <20130325090629.GN2154@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> >From 7ed7f53bb597e8cb40d9ac91ce16142fb60f1e93 Mon Sep 17 00:00:00 2001
>>> From: Michal Hocko <mhocko@suse.cz>
>>> Date: Fri, 22 Mar 2013 10:22:54 +0100
>>> Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
>>>
>>> As cgroup supports rename, it's unsafe to dereference dentry->d_name
>>> without proper vfs locks. Fix this by using cgroup_name() rather than
>>> dentry directly.
>>>
>>> Also open code memcg_cache_name because it is called only from
>>> kmem_cache_dup which frees the returned name right after
>>> kmem_cache_create_memcg makes a copy of it. Such a short-lived
>>> allocation doesn't make too much sense. So replace it by a static
>>> buffer as kmem_cache_dup is called with memcg_cache_mutex.
>>>
>>
>> I doubt it's a win to add 4K to kernel text size instead of adding
>> a few extra lines of code... but it's up to you.
> 
> I will leave the decision to Glauber. The updated version which uses
> kmalloc for the static buffer is bellow.
> 

I don't have strong preference. Glauber, what's your opinion?

...
>  static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
>  					 struct kmem_cache *s)
>  {
> -	char *name;
>  	struct kmem_cache *new;
> +	static char *tmp_name = NULL;

(minor nitpick) why not preserve the name "name"

