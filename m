Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaFXC2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:28:34 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50995 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFXC2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:28:32 -0400
Message-ID: <53A8E23C.4050103@huawei.com>
Date: Tue, 24 Jun 2014 10:28:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
References: <53902A44.50005@cn.fujitsu.com> <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org> <539192F1.7050308@cn.fujitsu.com> <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com> <539574F1.2060701@cn.fujitsu.com> <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com> <53967465.7070908@huawei.com> <20140620210137.GA2059@mtj.dyndns.org>
In-Reply-To: <20140620210137.GA2059@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/21 5:01, Tejun Heo wrote:
> Hello, Li.
> 
> Sorry about the long delay.
> 
> On Tue, Jun 10, 2014 at 10:58:45AM +0800, Li Zefan wrote:
>> Yes, this is a long-standing issue. Besides the race you described, the child
>> task's mems_allowed can be wrong if the cpuset's nodemask changes before the
>> child has been added to the cgroup's tasklist.
>>
>> I remember Tejun once said he wanted to disallow task migration between
>> cgroups during fork, and that should fix this problem.
> 
> I'm having trouble remembering but yeah enforcing stricter behavior
> across fork could be beneficial.  Hmmm... the problem with making
> forks exclusive against migrations is that we'll end up adding more
> locking to the fork path which isn't too nice.
> 
> Hmmm... other controllers (cgroup_freezer) can reliably synchronize
> the child's state to the cgroup it belongs to.  Why can't cpuset?  Is
> there something fundamentally missing in the cgroup API?
> 

cgroup_freezer uses the fork callback. We can also do this for cpuset as
suggested by David, which adds a little bit overhead to the fork path.

David, care to send out a patch?

>>> It needs to be slightly rewritten to work properly without negatively 
>>> impacting the latency of fork().  Do you have the cycles to do it?
>>>
>>
>> Sounds you have other idea?
> 
> I don't think the suggested patch breaks anything more than it was
> broken before and we should probably apply it for the time being.  Li?
> 

Yeah, we should apply Gu Zheng's patch any way.

