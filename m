Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946621Ab3BHP0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:26:24 -0500
Received: from relay.parallels.com ([195.214.232.42]:60295 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946070Ab3BHP0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:26:23 -0500
From: Vladimir Davydov <VDavydov@parallels.com>
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "<devel@openvz.org>" <devel@openvz.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: initialize runtime to non-zero on cfs bw set
Thread-Topic: [PATCH] sched: initialize runtime to non-zero on cfs bw set
Thread-Index: AQHOBgsJSpvJ42NYRUOoH5TtjGIvuZhv0hSA
Date: Fri, 8 Feb 2013 15:26:07 +0000
Message-ID: <049D7A4CCB8B694CACDEEB03BE35F30611234898@MSK-EXCH.sw.swsoft.com>
References: <1360307446-26978-1-git-send-email-vdavydov@parallels.com>
 <20130208144601.GA13327@google.com>
In-Reply-To: <20130208144601.GA13327@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.39.174]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29D0F9A4B88216478DFD07C20129F99E@sw.swsoft.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2013, at 6:46 PM, Paul Turner <pjt@google.com> wrote:

> On Fri, Feb 08, 2013 at 11:10:46AM +0400, Vladimir Davydov wrote:
>> If cfs_rq->runtime_remaining is <= 0 then either
>> - cfs_rq is throttled and waiting for quota redistribution, or
>> - cfs_rq is currently executing and will be throttled on
>>  put_prev_entity, or
>> - cfs_rq is not throttled and has not executed since its quota was set
>>  (runtime_remaining is set to 0 on cfs bandwidth reconfiguration).
>> 
>> It is obvious that the last case is rather an exception from the rule
>> "runtime_remaining<=0 iff cfs_rq is throttled or will be throttled as
>> soon as it finishes its execution". Moreover, it can lead to a task hang
>> as follows. If put_prev_task is called immediately after first
>> pick_next_task after quota was set, "immediately" meaning rq->clock in
>> both functions is the same, then the corresponding cfs_rq will be
>> throttled. Besides being unfair (the cfs_rq has not executed in fact),
>> the quota refilling timer can be idle at that time and it won't be
>> activated on put_prev_task because update_curr calls
>> account_cfs_rq_runtime, which activates the timer, only if delta_exec is
>> strictly positive. As a result we can get a task "running" inside a
>> throttled cfs_rq which will probably never be unthrottled.
>> 
>> To avoid the problem, the patch makes tg_set_cfs_bandwidth initialize
>> runtime_remaining of each cfs_rq to 1 instead of 0 so that the cfs_rq
>> will be throttled only if it has executed for some positive number of
>> nanoseconds.
>> --
>> Several times we had our customers encountered such hangs inside a VM
>> (seems something is wrong or rather different in time accounting there).
> 
> Yeah, looks like!
> 
> It's not ultimately _super_ shocking; I can think of a few  places where such
> gremlins could lurk if they caused enough problems for someone to really go
> digging.
> 
>> Analyzing crash dumps revealed that hung tasks were running inside
>> cfs_rq's, which had the following setup
>> 
>> cfs_rq->throttled=1
>> cfs_rq->runtime_enabled=1
>> cfs_rq->runtime_remaining=0
>> cfs_rq->tg->cfs_bandwidth.idle=1
>> cfs_rq->tg->cfs_bandwidth.timer_active=0
>> 
>> which conforms pretty nice to the explanation given above.
>> 
>> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
>> ---
>> kernel/sched/core.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 26058d0..c7a078f 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -7686,7 +7686,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>> 
>> 		raw_spin_lock_irq(&rq->lock);
>> 		cfs_rq->runtime_enabled = runtime_enabled;
>> -		cfs_rq->runtime_remaining = 0;
>> +		cfs_rq->runtime_remaining = 1;
> 
> So I agree this is reasonably correct and would fix the issue identified.
> However, one concern is that it would potentially grant a tick of execution
> time on all cfs_rqs which could result in large quota violations on a many core
> machine; one trick then would be to give them "expired" quota; which would be
> safe against put_prev_entity->check_cfs_runtime, e.g.

Yeah, I missed that. Thank you for the update.

> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1dff78a..4369231 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7687,7 +7687,17 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
> 
> 		raw_spin_lock_irq(&rq->lock);
> 		cfs_rq->runtime_enabled = runtime_enabled;
> -		cfs_rq->runtime_remaining = 0;
> +		/*
> +		 * On re-definition of bandwidth values we allocate a trivial
> +		 * amount of already expired quota.  This guarantees that
> +		 * put_prev_entity() cannot lead to a throttle event before we
> +		 * have seen a call to account_cfs_runtime(); while not being
> +		 * usable by newly waking, or set_curr_task_fair-ing, cpus
> +		 * since it would be immediately expired, requiring
> +		 * reassignment.
> +		 */
> +		cfs_rq->runtime_remaining = 1;
> +		cfs_rq->runtime_expires = rq_of(cfs_rq)->clock - 1;
> 
> 		if (cfs_rq->throttled)
> 			unthrottle_cfs_rq(cfs_rq);
> 
> A perhaps more explicit approach that should be more consistent would be to
> properly allocate bandwidth in the first place.  Something like (compile
> tested):

I may be mistaken, but I think it isn't quite right. The point is that the task
group can be idle when its quota is reconfigured, i.e. no cfs_rq is throttled,
no cfs_rq is being executed. Then the hunk added by your second patch is skipped,
and if a task is enqueued onto this group's cfs_rq and yields before any clock
update, we will face exactly same situation: running task in a throttled group.

Anyway, I vote for your first patch. IMO, it should work fine, and it definitely
looks much clearer.

Would you mind if I added you to the 'signed-off-by' field and resent the patch?

Thank you again for the comment.

> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1dff78a..9646c01 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7682,6 +7682,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
> 	raw_spin_unlock_irq(&cfs_b->lock);
> 
> 	for_each_possible_cpu(i) {
> +		bool exhausted = false;
> 		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
> 		struct rq *rq = cfs_rq->rq;
> 
> @@ -7689,9 +7690,27 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
> 		cfs_rq->runtime_enabled = runtime_enabled;
> 		cfs_rq->runtime_remaining = 0;
> 
> +		/*
> +		 * We know there's bandwidth remaining (since this loop would
> +		 * have otherwise terminated) we can unthrottle up-front.
> +		 */
> 		if (cfs_rq->throttled)
> 			unthrottle_cfs_rq(cfs_rq);
> +
> +		if (cfs_rq->curr) {
> +			/* cfs_rq is currently running, force an update */
> +			account_cfs_rq_runtime(cfs_rq, 0);
> +			/* If we were unable to allocate runtime then:
> +			 * (a) We've sent a reschedule against cpu i
> +			 * (b) There is no point in visiting further cpus as we
> +			 *     have exhausted our new quota.
> +			 */
> +			if (!cfs_rq->runtime_remaining)
> +				exhausted = true;
> +		}
> 		raw_spin_unlock_irq(&rq->lock);
> +		if (exhausted)
> +			break;
> 	}
> out_unlock:
> 	mutex_unlock(&cfs_constraints_mutex);
> 
> 
> That said I actually thought of the first patch (e.g. explicitly using expired
> quota) after I wrote the second.  It's perhaps more subtle; but not
> unreasonable.  Any thoughts?
> 
> Thanks for the report,
> 
> - Paul
>> 		if (cfs_rq->throttled)
>> 			unthrottle_cfs_rq(cfs_rq);
>> -- 
>> 1.7.1
>> 
> 

