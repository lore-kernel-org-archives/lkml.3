Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161591Ab3DGDdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 23:33:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30820 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161375Ab3DGDdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 23:33:15 -0400
Message-ID: <5160E8E0.2050602@huawei.com>
Date: Sun, 7 Apr 2013 11:32:48 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@parallels.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC][PATCH 2/7] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
References: <515BF233.6070308@huawei.com> <515BF275.5080408@huawei.com> <20130403153133.GM16471@dhcp22.suse.cz> <515EA73C.8050602@parallels.com> <20130405134557.GG31132@dhcp22.suse.cz>
In-Reply-To: <20130405134557.GG31132@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> You are putting references but I do not see any single css_{try}get
>>> here. /me puzzled.
>>>
>>
>> There are two things being done in this code:
>> First, we acquired a css_ref to make sure that the underlying cgroup
>> would not go away. That is a short lived reference, and it is put as
>> soon as the cache is created.
>> At this point, we acquire a long-lived per-cache memcg reference count
>> to guarantee that the memcg will still be alive.
>>
>> so it is:
>>
>> enqueue: css_get
>> create : memcg_get, css_put
>> destroy: css_put
>>
>> If I understand Li's patch correctly, he is not touching the first
>> css_get, only turning that into the long lived reference (which was not
>> possible before, since that would prevent rmdir).
>>
>> Then he only needs to get rid of the memcg_get, change the memcg_put to
>> css_put, and get rid of the now extra css_put.
>>
>> He is issuing extra css_puts in memcg_create_kmem_cache, but only in
>> failure paths. So the code reads as:
>> * css_get on enqueue (already done, so not shown in patch)
>> * if it fails, css_put
>> * if it succeeds, don't do anything. This is already the long-lived
>> reference count. put it at release time.
> 
> OK, this makes more sense now. It is __memcg_create_cache_enqueue which
> takes the reference and it is not put after this because it replaced
> mem_cgroup reference counting.
> Li, please put something along these lines into the changelog. This is
> really tricky and easy to get misunderstand.
> 

Yeah, I think I'll just steal Glauber's explanation as the changelog.

> You can put my Acked-by then.
> 

Thanks!

>> The code looks correct, and of course, extremely simpler due to the
>> use of a single reference.
>>
>> Li, am I right in my understanding that this is your intention?
>>


