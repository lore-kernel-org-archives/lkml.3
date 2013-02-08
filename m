Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946726Ab3BHQdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:33:00 -0500
Received: from relay.parallels.com ([195.214.232.42]:43250 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab3BHQc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:32:59 -0500
From: Vladimir Davydov <VDavydov@parallels.com>
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "<devel@openvz.org>" <devel@openvz.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: initialize runtime to non-zero on cfs bw set
Thread-Topic: [PATCH] sched: initialize runtime to non-zero on cfs bw set
Thread-Index: AQHOBgsJSpvJ42NYRUOoH5TtjGIvuQ==
Date: Fri, 8 Feb 2013 16:32:43 +0000
Message-ID: <049D7A4CCB8B694CACDEEB03BE35F306112361EE@MSK-EXCH.sw.swsoft.com>
References: <1360307446-26978-1-git-send-email-vdavydov@parallels.com>
 <20130208144601.GA13327@google.com>
 <BEF8F492-C44F-43F1-AB39-EA498A0063EA@parallels.com>
In-Reply-To: <BEF8F492-C44F-43F1-AB39-EA498A0063EA@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [81.5.110.170]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D652D4DD2E8544F972225543E5AD066@sw.swsoft.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2013, at 7:26 PM, Vladimir Davydov <VDavydov@parallels.com> wrote:

> On Feb 8, 2013, at 6:46 PM, Paul Turner <pjt@google.com> wrote:
> 
>> On Fri, Feb 08, 2013 at 11:10:46AM +0400, Vladimir Davydov wrote:
>>> If cfs_rq->runtime_remaining is <= 0 then either
>>> - cfs_rq is throttled and waiting for quota redistribution, or
>>> - cfs_rq is currently executing and will be throttled on
>>> put_prev_entity, or
>>> - cfs_rq is not throttled and has not executed since its quota was set
>>> (runtime_remaining is set to 0 on cfs bandwidth reconfiguration).
>>> 
>>> It is obvious that the last case is rather an exception from the rule
>>> "runtime_remaining<=0 iff cfs_rq is throttled or will be throttled as
>>> soon as it finishes its execution". Moreover, it can lead to a task hang
>>> as follows. If put_prev_task is called immediately after first
>>> pick_next_task after quota was set, "immediately" meaning rq->clock in
>>> both functions is the same, then the corresponding cfs_rq will be
>>> throttled. Besides being unfair (the cfs_rq has not executed in fact),
>>> the quota refilling timer can be idle at that time and it won't be
>>> activated on put_prev_task because update_curr calls
>>> account_cfs_rq_runtime, which activates the timer, only if delta_exec is
>>> strictly positive. As a result we can get a task "running" inside a
>>> throttled cfs_rq which will probably never be unthrottled.
>>> 
>>> To avoid the problem, the patch makes tg_set_cfs_bandwidth initialize
>>> runtime_remaining of each cfs_rq to 1 instead of 0 so that the cfs_rq
>>> will be throttled only if it has executed for some positive number of
>>> nanoseconds.
>>> --
>>> Several times we had our customers encountered such hangs inside a VM
>>> (seems something is wrong or rather different in time accounting there).
>> 
>> Yeah, looks like!
>> 
>> It's not ultimately _super_ shocking; I can think of a few  places where such
>> gremlins could lurk if they caused enough problems for someone to really go
>> digging.
>> 
>>> Analyzing crash dumps revealed that hung tasks were running inside
>>> cfs_rq's, which had the following setup
>>> 
>>> cfs_rq->throttled=1
>>> cfs_rq->runtime_enabled=1
>>> cfs_rq->runtime_remaining=0
>>> cfs_rq->tg->cfs_bandwidth.idle=1
>>> cfs_rq->tg->cfs_bandwidth.timer_active=0
>>> 
>>> which conforms pretty nice to the explanation given above.
>>> 
>>> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
>>> ---
>>> kernel/sched/core.c |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>> 
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index 26058d0..c7a078f 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -7686,7 +7686,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>>> 
>>> 		raw_spin_lock_irq(&rq->lock);
>>> 		cfs_rq->runtime_enabled = runtime_enabled;
>>> -		cfs_rq->runtime_remaining = 0;
>>> +		cfs_rq->runtime_remaining = 1;
>> 
>> So I agree this is reasonably correct and would fix the issue identified.
>> However, one concern is that it would potentially grant a tick of execution
>> time on all cfs_rqs which could result in large quota violations on a many core
>> machine; one trick then would be to give them "expired" quota; which would be
>> safe against put_prev_entity->check_cfs_runtime, e.g.
> 

But wait, what "large quota violations" are you talking about? First, the granted
quota is rather ephemeral because it will be neglected during the next cfs bw period.
Second, we will actually grant NR_CPUS nanoseconds, is is only 1 ms for a 1000 cpus
host, because the task group will sleep in the throttled state for each nanosecond
consumed over the granted quota, i.e. it may be a spike in the load which the task
group will eventually pay for. Besides, I guess quota reconfiguration is rather a
rare event, so it should not be a concern.

Thanks

