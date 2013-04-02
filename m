Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab3DBIe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:34:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:55117 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286Ab3DBIe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:34:56 -0400
Message-ID: <515A9819.5090603@huawei.com>
Date: Tue, 2 Apr 2013 16:34:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
References: <515A8A40.6020406@huawei.com> <515A90ED.7010208@huawei.com> <515A91B4.3090607@parallels.com>
In-Reply-To: <515A91B4.3090607@parallels.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/2 16:07, Glauber Costa wrote:
> On 04/02/2013 12:03 PM, Li Zefan wrote:
>> On 2013/4/2 15:35, Li Zefan wrote:
>>> If memcg_init_kmem() returns -errno when a memcg is being created,
>>> mem_cgroup_css_online() will decrement memcg and its parent's refcnt,
>>
>>> (but strangely there's no mem_cgroup_put() for mem_cgroup_get() called
>>> in memcg_propagate_kmem()).
>>
>> The comment in memcg_propagate_kmem() suggests it knows mem_cgroup_css_free()
>> will be called in failure, while mem_cgroup_css_online() doesn't know.
>>
> This is a bit suspicious. At first your analysis seems fair, but I've
> extensively tested memcg teardown process with kmemcg (and even
> uncovered some bugs at that), and it works when and how expected.
> 

Because this bug is in a failure path, and seems the only way to get into
this path is -ENOMEM.

> Also, note that this teardown code long predates kmemcg.
> 

Maybe this bug was introduced when ss->create() was changed to ss->css_alloc()
and ss->css_online(), and before that change ss->destroy() won't be called
if ss->create() failed.

> I am not saying your are wrong - on the contrary, you seem to be right,
> but I think this one needs to be handled with extra care. I will run
> some tests, take a look, and get back to you.
> 

