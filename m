Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936247AbaFJDAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:00:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4447 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaFJDAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:00:52 -0400
Message-ID: <53967465.7070908@huawei.com>
Date: Tue, 10 Jun 2014 10:58:45 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
References: <53902A44.50005@cn.fujitsu.com> <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org> <539192F1.7050308@cn.fujitsu.com> <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com> <539574F1.2060701@cn.fujitsu.com> <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/9 17:13, David Rientjes wrote:
> On Mon, 9 Jun 2014, Gu Zheng wrote:
> 
>>> I think your patch addresses the problem that you're reporting but misses 
>>> the larger problem with cpuset.mems rebinding on fork().  When the 
>>> forker's task_struct is duplicated (which includes ->mems_allowed) and it 
>>> races with an update to cpuset_being_rebound in update_tasks_nodemask() 
>>> then the task's mems_allowed doesn't get updated.
>>
>> Yes, you are right, this patch just wants to address the bug reported above.
>> The race condition you mentioned above inherently exists there, but it is yet
>> another issue, the rcu lock here makes no sense to it, and I think we need
>> additional sync-mechanisms if want to fix it.
> 
> Yes, the rcu lock is not providing protection for any critical section 
> here that requires (1) the forker's cpuset to be stored in 
> cpuset_being_rebound or (2) the forked thread's cpuset to be rebound by 
> the cpuset nodemask update, and no race involving the two.
>

Yes, this is a long-standing issue. Besides the race you described, the child
task's mems_allowed can be wrong if the cpuset's nodemask changes before the
child has been added to the cgroup's tasklist.

I remember Tejun once said he wanted to disallow task migration between
cgroups during fork, and that should fix this problem.
 
>> But thinking more, though the current implementation has flaw, but I worry
>> about the negative effect if we really want to fix it. Or maybe the fear
>> is unnecessary.:) 
>>
> 
> It needs to be slightly rewritten to work properly without negatively 
> impacting the latency of fork().  Do you have the cycles to do it?
> 

Sounds you have other idea?

