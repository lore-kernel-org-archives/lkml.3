Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaK0Lgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:36:50 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63352 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaK0Lgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:36:48 -0500
Message-ID: <54770CBF.3040309@gmail.com>
Date: Thu, 27 Nov 2014 19:36:31 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com> <20140514154459.GE4570@linux.vnet.ibm.com> <20140514191100.GA24155@windriver.com>
In-Reply-To: <20140514191100.GA24155@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,
On 5/15/14, 3:11 AM, Paul Gortmaker wrote:
> [Added Frederic to Cc: since we are now talking nohz stuff]
>
> [Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is futile] On 14/05/2014 (Wed 08:44) Paul E. McKenney wrote:
>
>> On Wed, May 14, 2014 at 11:08:35AM -0400, Paul Gortmaker wrote:
>>> As of the old commit ac086bc22997a2be24fc40fc8d46522fe7e03d11
>>> ("sched: rt-group: smp balancing") the concept of borrowing per
>>> cpu rt_runtime from one core to another was introduced.
>>>
>>> However, this prevents the RT throttling message from ever being
>>> emitted when someone does a common (but mistaken) attempt at
>>> using too much CPU in RT context.  Consider the following test:
>>>
>>>    echo "main() {for(;;);}" > full_load.c
>>>    gcc full_load.c -o full_load
>>>    taskset -c 1 ./full_load &
>>>    chrt -r -p 80 `pidof full_load`
>>>
>>> When run on x86_64 defconfig, what happens is as follows:
>>>
>>> -task runs on core1 for 95% of an rt_period as documented in
>>>   the file Documentation/scheduler/sched-rt-group.txt
>>>
>>> -at 95%, the code in balance_runtime sees this threshold and
>>>   calls do_balance_runtime()
>>>
>>> -do_balance_runtime sees that core 1 is in need, and does this:
>>> 	---------------
>>>          if (rt_rq->rt_runtime + diff > rt_period)
>>>                  diff = rt_period - rt_rq->rt_runtime;
>>>          iter->rt_runtime -= diff;
>>>          rt_rq->rt_runtime += diff;
>>> 	---------------
>>>   which extends core1's rt_runtime by 5%, making it 100% of rt_period
>>>   by stealing 5% from core0 (or possibly some other core).
>>>
>>> However, the next time core1's rt_rq enters sched_rt_runtime_exceeded(),
>>> we hit this near the top of that function:
>>> 	---------------
>>>          if (runtime >= sched_rt_period(rt_rq))
>>>                  return 0;
>>> 	---------------
>>> and hence we'll _never_ look at/set any of the throttling checks and
>>> messages in sched_rt_runtime_exceeded().  Instead, we will happily
>>> plod along for CONFIG_RCU_CPU_STALL_TIMEOUT seconds, at which point
>>> the RCU subsystem will get angry and trigger an NMI in response to
>>> what it rightly sees as a WTF situation.
>> In theory, one way of making RCU OK with an RT usermode CPU hog is to
>> build with Frederic's CONFIG_NO_HZ_FULL=y.  This will cause RCU to see
>> CPUs having a single runnable usermode task as idle, preventing the RCU
>> CPU stall warning.  This does work well for mainline kernel in the lab.
> Agreed; wanting to test that locally for myself meant moving to a more
> modern machine, as the older PentiumD doesn't support NO_HZ_FULL.  But

Could you point out which hw feature support NO_HZ_FULL? How to check it 
through cpuid?

Regards,
Wanpeng Li

> on the newer box (dual socket six cores in each) I found the stall
> harder to trigger w/o going back to using the threadirqs boot arg as
> used in the earlier lkml post referenced below. (Why?  Not sure...)
>
> Once I did that though (boot vanilla linux-next with threadirqs) I
> confirmed what you said; i.e. that we would reliably get a stall with
> the defconfig of NOHZ_IDLE=y but not with NOHZ_FULL=y (and hence also
> RCU_USER_QS=y).
>
>> In practice, not sure how much testing CONFIG_NO_HZ_FULL=y has received
>> for -rt kernels in production environments.
>>
>> But leaving practice aside for the moment...
>>
> [...]
>
>>> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
>>> index ea4d500..698aac9 100644
>>> --- a/kernel/sched/rt.c
>>> +++ b/kernel/sched/rt.c
>>> @@ -774,6 +774,15 @@ static int balance_runtime(struct rt_rq *rt_rq)
>>>   	if (!sched_feat(RT_RUNTIME_SHARE))
>>>   		return more;
>>>
>>> +	/*
>>> +	 * Stealing from another core won't help us at all if
>>> +	 * we have nothing to migrate over there, or only one
>>> +	 * task that is running up all the rt_time.  In fact it
>>> +	 * will just inhibit the throttling message in that case.
>>> +	 */
>>> +	if (!rt_rq->rt_nr_migratory || rt_rq->rt_nr_total == 1)
>> How about something like the following to take NO_HZ_FULL into account?
>>
>> +	if ((!rt_rq->rt_nr_migratory || rt_rq->rt_nr_total == 1) &&
>> +	    !tick_nohz_full_cpu(cpu))
> Yes, I think special casing nohz_full can make sense, but maybe not
> exactly here in balance_runtime?  Since the underlying reasoning doesn't
> change on nohz_full ; if only one task is present, or nothing can
> migrate, then the call to do_balance_runtime is largely useless - we'll
> walk possibly all cpus in search of an rt_rq to steal from, and what we
> steal, we can't use - so we've artificially crippled the other rt_rq for
> nothing other than to artifically inflate our rt_runtime and thus allow
> 100% usage.
>
> Given that, perhaps a separate change to sched_rt_runtime_exceeded()
> that works out the CPU from the rt_rq, and returns zero if it is a
> nohz_full cpu?  Does that make sense?  Then the nohz_full people won't
> get the throttling message even if they go 100%.
>
> Paul.
> --
>
>> 							Thanx, Paul
>>
>>> +		return more;
>>> +
>>>   	if (rt_rq->rt_time > rt_rq->rt_runtime) {
>>>   		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>>>   		more = do_balance_runtime(rt_rq);
>>> -- 
>>> 1.8.2.3
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

