Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3LJNYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:24:40 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43149 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3LJNYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:24:36 -0500
Message-ID: <52A71605.5090509@arm.com>
Date: Tue, 10 Dec 2013 13:24:21 +0000
From: Chris Redpath <chris.redpath@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "pjt@google.com" <pjt@google.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bsegall@google.com
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com> <1386593950-26475-3-git-send-email-chris.redpath@arm.com> <20131210114825.GF12849@twins.programming.kicks-ass.net>
In-Reply-To: <20131210114825.GF12849@twins.programming.kicks-ass.net>
X-OriginalArrivalTime: 10 Dec 2013 13:24:31.0308 (UTC) FILETIME=[28CD50C0:01CEF5AB]
X-MC-Unique: 113121013243301301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/13 11:48, Peter Zijlstra wrote:
> On Mon, Dec 09, 2013 at 12:59:10PM +0000, Chris Redpath wrote:
>> If we migrate a sleeping task away from a CPU which has the
>> tick stopped, then both the clock_task and decay_counter will
>> be out of date for that CPU and we will not decay load correctly
>> regardless of how often we update the blocked load.
>>
>> This is only an issue for tasks which are not on a runqueue
>> (because otherwise that CPU would be awake) and simultaneously
>> the CPU the task previously ran on has had the tick stopped.
>
> OK, so the idiot in a hurry (me) isn't quite getting the issue.
>

Sorry Peter, I will expand a little. We are using runnable_avg_sum to 
drive task placement in a much more aggressive way than usual in our 
big.LITTLE MP scheduler patches. I spend a lot of time looking at 
individual task load signals.

What happens is that if you have a task which sleeps for a while and 
wakes on a different CPU and the previous CPU hasn't had a tick for a 
while, then that sleep time is lost. If the sleep time is short relative 
to the runtime the impact is small but we have tasks on Android where 
the runtime is small relative to the sleep. These tasks look much bigger 
than they really are. Everything works, but we can use more energy than 
we need to to meet the compute requirements. I guess load balancing 
could also be mislead for a while.

I fully appreciate that it isn't so visible the way that load averages 
are used in the mainline scheduler, but its definitely there.

> Normally we update the blocked averages from the tick; clearly when no
> tick, no update. So far so good.
>
> Now, we also update blocked load from idle balance -- which would
> include the CPUs without tick through nohz_idle_balance() -- however
> this only appears to be done for CONFIG_FAIR_GROUP_SCHED.
>
> Are you running without cgroup muck? If so should we make this
> unconditional?
>
> If you have cgroup muck enabled; what's the problem? Don't we run
> nohz_idle_balance() frequently enough to be effective for updating the
> blocked load?
>

I have to check this out a bit more, but yes I do have the muck enabled 
:/ I will investigate how often we idle balance on this platform however 
to be correct wouldn't we need an idle balance event to happen during 
sleep every time an entity was dequeued? And then we'd still lose the 
sleep time if we happen to wake between idle balance events?

> You also seem to have overlooked NO_HZ_FULL, that can stop a tick even
> when there's a running task and makes the situation even more fun.

You are right, I haven't considered NO_HZ_FULL at all but I guess its 
also going to have an impact. I'll look closer at it.

>
>> @@ -4343,6 +4344,25 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>>   	 * be negative here since on-rq tasks have decay-count == 0.
>>   	 */
>>   	if (se->avg.decay_count) {
>> +		/*
>> +		 * If we migrate a sleeping task away from a CPU
>> +		 * which has the tick stopped, then both the clock_task
>> +		 * and decay_counter will be out of date for that CPU
>> +		 * and we will not decay load correctly.
>> +		 */
>> +		if (!se->on_rq && nohz_test_cpu(task_cpu(p))) {
>> +			struct rq *rq = cpu_rq(task_cpu(p));
>> +			unsigned long flags;
>> +			/*
>> +			 * Current CPU cannot be holding rq->lock in this
>> +			 * circumstance, but another might be. We must hold
>> +			 * rq->lock before we go poking around in its clocks
>> +			 */
>> +			raw_spin_lock_irqsave(&rq->lock, flags);
>> +			update_rq_clock(rq);
>> +			update_cfs_rq_blocked_load(cfs_rq, 0);
>> +			raw_spin_unlock_irqrestore(&rq->lock, flags);
>> +		}
>>   		se->avg.decay_count = -__synchronize_entity_decay(se);
>>   		atomic_long_add(se->avg.load_avg_contrib,
>>   						&cfs_rq->removed_load);
>
> Right, as Ben already said; taking a rq->lock there is unfortunate at
> best.
>

You're both being very polite. I hate it too :) The only reason for 
taking the lock is to be sure the decay_counter is updated, normal sleep 
accounting doesn't need all this and is always correct.

This stuff only exists in the first place so that the blocked load 
doesn't get out of whack when we are moving entities. Maybe I can 
separate entity load decay due to sleep from blocked load accounting. It 
will leave blocked load subject to rq clock updates but that might be 
OK. It's only a half-formed idea at the moment, I will ponder a bit longer.

> So normally we 'throttle' the expense of decaying the blocked load to
> ticks. But the above does it on every (suitable) task migration which
> might be far more often.
>
> So ideally we'd get it all sorted through the nohz_idle_balance() path;
> what exactly are the problems with that?
>

What I want is for se.avg.runnable_avg_sum to correctly incorporate the 
sleep time. I care much less about runqueue blocked averages being 
instantaneously correct so long as they don't get out of sync when 
entities move around. If it's possible to do it in the idle balance path 
that is great - if you have any suggestions I'd be glad to have a look.

