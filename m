Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3BZKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 05:25:58 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:15786 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3BZKZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 05:25:57 -0500
Message-ID: <512C8D84.7090707@huawei.com>
Date: Tue, 26 Feb 2013 18:25:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org>
In-Reply-To: <20130226022703.GA13837@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/26 10:27, Tejun Heo wrote:
> On Mon, Feb 25, 2013 at 02:17:49PM +0800, Li Zefan wrote:
>> cgroup_name() returns the name of a cgroup and it must be called with
>> rcu_read_lock() held.
>>
>> This will be used by cpuset.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ...
>>  /**
>> + * cgroup_name - get the name of a cgroup
>> + * @cgrp: the cgroup in question
>> + *
>> + * Must be called with rcu_read_lock() held.
>> + */
>> +char *cgroup_name(const struct cgroup *cgrp)
>> +{
>> +	if (!cgrp->parent)
>> +		return "/";
>> +	else
>> +		return rcu_dereference(cgrp->name)->name;
>> +}
> 
> Can't we initialize ->name of root cgroup to "/" and lose the
> conditional? 

Sure we can. We'll have to allocate cgrp->name in cgroup_remount() and
cgroup_init(), and free cgrp->name in cgroup_kill_sb(). It looks to me
the current version is a bit simpler.

That said, I don't have strong preference. I'll revise the patchset if
you still prefer to init root_cgrp->name.

> We can lose the wrapper altogether but if you're worried
> that sparse check isn't enough, we can have trivial inline wrapper,
> but in that case it probably would help to rename cgrp->name to, say,
> cgrp->__name and put a comment directing people to the accessing
> wrapper which should probably return const char *.
> 

I do expect people always use cgroup_name(). Should anyone access
cgrp->name directly and doesn't notice cgrp->name can be NULL, he'll
get NULL ptr crash and turn to cgroup_name(), and a comment to guide
people to cgroup_name() is helpful too.

