Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaDWCOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:14:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:54671 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547AbaDWCNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:13:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,907,1389715200"; 
   d="scan'208";a="29602468"
Message-ID: <53572299.4070000@cn.fujitsu.com>
Date: Wed, 23 Apr 2014 10:16:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] workqueue: allow changing attributions of ordered workqueue
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com> <534D02B0.1000801@cn.fujitsu.com> <20140423000443.GC18483@localhost.localdomain>
In-Reply-To: <20140423000443.GC18483@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 08:04 AM, Frederic Weisbecker wrote:
> Hi Lai,
> 
> So actually I'll need to use apply_workqueue_attr() on the next patchset. So
> I'm considering this patch.
> 
> Some comments below:
> 
> On Tue, Apr 15, 2014 at 05:58:08PM +0800, Lai Jiangshan wrote:
>> From 534f1df8a5a03427b0fc382150fbd34e05648a28 Mon Sep 17 00:00:00 2001
>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>> Date: Tue, 15 Apr 2014 17:52:19 +0800
>> Subject: [PATCH] workqueue: allow changing attributions of ordered workqueue
>>
>> Allow changing ordered workqueue's cpumask
>> Allow changing ordered workqueue's nice value
>> Allow registering ordered workqueue to SYSFS
>>
>> Still disallow changing ordered workqueue's max_active which breaks ordered guarantee
>> Still disallow changing ordered workqueue's no_numa which breaks ordered guarantee
>>
>> Changing attributions will introduce new pwqs in a given workqueue, and
>> old implement doesn't have any solution to handle multi-pwqs on ordered workqueues,
>> so changing attributions for ordered workqueues is disallowed.
>>
>> After I investigated several solutions which try to handle multi-pwqs on ordered workqueues,
>> I found the solution which reuse max_active are the simplest.
>> In this solution, the new introduced pwq's max_active is kept as *ZERO* until it become
>> the oldest pwq.
> 
> I don't see where this zero value is enforced. Do you mean 1? That's the initial value of
> ordered max_active pools.

pwq's max_active is force zero in pwq_adjust_max_active().
If the older pwq is still existed, the newer one's max_active is forced zero.

> 
>> Thus only one (the oldest) pwq is active, and ordered is guarantee.
>>
>> This solution forces ordered on higher level while the non-reentrancy is also
>> forced. so we don't need to queue any work to its previous pool. And we shouldn't
>> do it. we must disallow any work repeatedly requeues itself back-to-back
>> which keeps the oldest pwq stay and make newest(if have) pwq starvation(non-active for ever).
>>
>> Build test only.
>> This patch depends on previous patch:
>> workqueue: add __WQ_FREEZING and remove POOL_FREEZING
>>
>> Frederic:
>> 	You can pick this patch to your updated patchset before
>> 	TJ apply it.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/workqueue.c |   66 ++++++++++++++++++++++++++++++---------------------
>>  1 files changed, 39 insertions(+), 27 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 92c9ada..fadcc4a 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -1350,8 +1350,14 @@ retry:
>>  	 * If @work was previously on a different pool, it might still be
>>  	 * running there, in which case the work needs to be queued on that
>>  	 * pool to guarantee non-reentrancy.
>> +	 *
>> +	 * pwqs are guaranteed active orderly for ordered workqueue, and
>> +	 * it guarantees non-reentrancy for works. So any work doesn't need
>> +	 * to be queued on previous pool. And the works shouldn't be queued
>> +	 * on previous pool, since we need to guarantee the prevous pwq
>> +	 * releasable to avoid work-stavation on the newest pool.
> 
> BTW, who needs this reentrancy guarantee? Is this an implicit guarantee for
> all workqueues that is there for backward compatibility? I've seen some
> patches dealing with that lately but I don't recall the details.
> 

dbf2576e37da0fcc7aacbfbb9fd5d3de7888a3c1

>>  	 */
>> -	last_pool = get_work_pool(work);
>> +	last_pool = wq->flags & __WQ_ORDERED ? NULL : get_work_pool(work);
> 
> Does it hurt performance to do this old worker recovery? It seems to
> when I look at get_work_pool() and find_worker_executing_pool().
> 
> Perhaps we can generalize this check to all wqs which have only one
> worker?
> 
> Anyway that's just optimizations. Nothing that needs to be done in this
> patch.
> 
[...]
> 
> So I have mixed feelings with this patch given the complication. But it's probably
> better to take that direction.

Any feeling is welcome to share here.

> 
> I just wish we had some way to automatically detect situations where a work
> mistakenly runs through re-entrancy. Because if it ever happens randomly,
> it's going to be a hell to debug.

dbf2576e37da0fcc7aacbfbb9fd5d3de7888a3c1 has forced non-reentrant and
is well reviewed. Any additional automatically detect is also welcome
for debugging. But I don't think it is required for your aim or this patch.

> 
> Thanks.
> 
>> -- 
>> 1.7.4.4
>>
> .
> 

