Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbbAUKiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:38:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43603 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbbAUKip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:38:45 -0500
Message-ID: <54BF81A0.8030705@linux.vnet.ibm.com>
Date: Wed, 21 Jan 2015 16:08:24 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: peterz@infradead.org, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] idle/tick-broadcast: Exit cpu idle poll loop when cleared
 from tick_broadcast_force_mask
References: <20150119052754.20256.54721.stgit@preeti.in.ibm.com> <alpine.DEB.2.11.1501201216420.5526@nanos> <54BE3B0E.2050502@linux.vnet.ibm.com> <alpine.DEB.2.11.1501211045480.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501211045480.5526@nanos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0029-0000-0000-000001BF95E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 03:26 PM, Thomas Gleixner wrote:
> On Tue, 20 Jan 2015, Preeti U Murthy wrote:
>> On 01/20/2015 04:51 PM, Thomas Gleixner wrote:
>>> On Mon, 19 Jan 2015, Preeti U Murthy wrote:
>>>> An idle cpu enters cpu_idle_poll() if it is set in the tick_broadcast_force_mask.
>>>> This is so that it does not incur the overhead of entering idle states when it is expected
>>>> to be woken up anytime then through a broadcast IPI. The condition that forces an exit out
>>>> of the idle polling is the check on setting of the TIF_NEED_RESCHED flag for the idle thread.
>>>>
>>>> When the broadcast IPI does arrive, it is not guarenteed that the handler sets the
>>>> TIF_NEED_RESCHED flag. Hence although the cpu is cleared in the tick_broadcast_force_mask,
>>>> it continues to loop in cpu_idle_poll unnecessarily wasting power. Hence exit the idle
>>>> poll loop if the tick_broadcast_force_mask gets cleared and enter idle states.
>>>>
>>>> Of course if the cpu has entered cpu_idle_poll() on being asked to poll explicitly,
>>>> it continues to poll till it is asked to reschedule.
>>>>
>>>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>>>> ---
>>>>
>>>>  kernel/sched/idle.c |    3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
>>>> index c47fce7..aaf1c1d 100644
>>>> --- a/kernel/sched/idle.c
>>>> +++ b/kernel/sched/idle.c
>>>> @@ -47,7 +47,8 @@ static inline int cpu_idle_poll(void)
>>>>  	rcu_idle_enter();
>>>>  	trace_cpu_idle_rcuidle(0, smp_processor_id());
>>>>  	local_irq_enable();
>>>> -	while (!tif_need_resched())
>>>> +	while (!tif_need_resched() &&
>>>> +		(cpu_idle_force_poll || tick_check_broadcast_expired()))
>>>
>>> You explain the tick_check_broadcast_expired() bit, but what about the
>>> cpu_idle_force_poll part?
>>
>> The last few lines which say "Of course if the cpu has entered
>> cpu_idle_poll() on being asked to poll explicitly, it continues to poll
>> till it is asked to reschedule" explains the cpu_idle_force_poll part.
> 
> Well, I read it more than once and did not figure it out.
> 
> The paragraph describes some behaviour. Now I know it's the behaviour
> before the patch. So maybe something like this:
> 
>   cpu_idle_poll() is entered when cpu_idle_force_poll is set or
>   tick_check_broadcast_expired() returns true. The exit condition from
>   cpu_idle_poll() is tif_need_resched().
> 
>   But this does not take into account that cpu_idle_force_poll and
>   tick_check_broadcast_expired() can change without setting the
>   resched flag. So a cpu can be caught in cpu_idle_poll() needlessly
>   and thereby wasting power.
> 
>   Add an explicit check for cpu_idle_force_poll and
>   tick_check_broadcast_expired() to the exit condition of
>   cpu_idle_poll() to avoid this.
> 
> This explains the technical issue without confusing people with IPIs
> and other completely irrelevant information. Hmm?

Yep, much simpler, thanks! I will send out the next version with this
changelog.

Regards
Preeti U Murthy
> 
> Thanks,
> 
> 	tglx
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

