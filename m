Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaIDDfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 23:35:44 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:38260 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaIDDfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 23:35:42 -0400
Message-ID: <5407DE02.8090805@huawei.com>
Date: Thu, 4 Sep 2014 11:35:30 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: Delay the clearing of cgrp->kn->priv
References: <5405A27A.3090605@huawei.com> <20140902153301.GA17424@htj.dyndns.org>
In-Reply-To: <20140902153301.GA17424@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/9/2 23:33, Tejun Heo 写道:
> Hello, Li.
> 
> On Tue, Sep 02, 2014 at 06:56:58PM +0800, Li Zefan wrote:
>>     for ((; ;))
>>     {
>>         echo $$ > /cgroup/sub/cgroup.procs
>>         ech $$ > /cgce 6f2e0c38c2108a74 ]---
>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>           copy & paste error?
> ...

oops

>> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>> ---
>>
>> Toralf, Thanks for reporting the bug. I'm not able to repy to your email,
>> because I was kicked out of the cgroup mailing list so didn't receive
>> emails from mailing list for a week.
>>
>> ---
>>  kernel/cgroup.c | 19 +++++++++----------
>>  1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 1c56924..e03fc62 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -4185,6 +4185,15 @@ static void css_release_work_fn(struct work_struct *work)
>>  
>>  	mutex_unlock(&cgroup_mutex);
>>  
>> +	/*
>> +	 * There are two control paths which try to determine cgroup from
>> +	 * dentry without going through kernfs - cgroupstats_build() and
>> +	 * css_tryget_online_from_dir().  Those are supported by RCU
>> +	 * protecting clearing of cgrp->kn->priv backpointer.
>> +	 */
>> +	if (!ss && cgroup_parent(cgrp))
>> +		RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
> 
> Can we move the above into the preceding else block?  I don't think
> holding cgroup_mutex or not makes any difference here. 

> Also, why do
> we need the cgroup_parent() check?  Do we deref root's kn->priv in the
> destruction path?  If so, can you please note that in the comment?
> 

I think the check is not necessary. I was trying to make smaller difference
than the original code, and RCU_INIT_POINTER() is in cgroup_rmdir() which
won't be called on root cgroup.

