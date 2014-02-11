Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaBKVwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:52:23 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50047 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaBKVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:52:21 -0500
Message-ID: <52FA9B92.5000705@linaro.org>
Date: Tue, 11 Feb 2014 22:52:18 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] idle: Add more comments to the code
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org> <1392131491-5265-5-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.11.1402111245400.17677@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1402111245400.17677@knanqh.ubzr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 06:51 PM, Nicolas Pitre wrote:
> On Tue, 11 Feb 2014, Daniel Lezcano wrote:
>
>> The idle main function is a complex and a critical function. Added more
>> comments to the code.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> Few questions below.  In any case,:
>
> Acked-by: Nicolas Pitre <nico@linaro.org>

Thanks for the review Nico !

Answer below.

>> ---
>>   kernel/sched/idle.c |   37 +++++++++++++++++++++++++++++++++----
>>   1 file changed, 33 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
>> index 72b5926..36ff1a7 100644
>> --- a/kernel/sched/idle.c
>> +++ b/kernel/sched/idle.c
>> @@ -86,19 +86,34 @@ static int cpuidle_idle_call(void)
>>   	if (cpu_idle_force_poll || tick_check_broadcast_expired())
>>   		return cpu_idle_poll();
>>
>> +	/*
>> +	 * Check if the idle task must rescheduled. If it is the case,
>
> s/must/must be/
>
>> +	 * exit the function after re-enabling the local irq and set
>> +	 * again the polling flag
>> +	 */
>>   	if (current_clr_polling_and_test()) {
>>   		local_irq_enable();
>>   		__current_set_polling();
>>   		return 0;
>>   	}
>>
>> +	/*
>> +	 * During the idle period, stop measuring the disabled irqs
>> +	 * critical sections latencies
>> +	 */
>>   	stop_critical_timings();
>> +
>> +	/*
>> +	 * Tell the RCU framework we are entering an idle section,
>> +	 * so no more rcu read side critical sections and one more
>> +	 * step to the grace period
>> +	 */
>>   	rcu_idle_enter();
>>
>> -	/* Ask the governor for the next state, this call can fail for
>> -	 * different reasons: cpuidle is not enabled or an idle state
>> -	 * fulfilling the constraints was not found. In this case, we fall
>> -	 * back to the default idle function
>> +	/*
>> +	 * Ask the governor to choose an idle state it thinks it is
>> +	 * convenient to go to. There is *always* a convenient idle
>> +	 * state but the call could fail if cpuidle is not enabled
>>   	 */
>>   	next_state = cpuidle_select(drv, dev);
>>   	if (next_state < 0) {
>> @@ -106,6 +121,10 @@ static int cpuidle_idle_call(void)
>>   		goto out;
>>   	}
>>
>> +	/*
>> +	 * The idle task must be scheduled, it is pointless to go to idle,
>> +	 * just update no idle residency and get out of this function
>> +	 */
>>   	if (need_resched()) {
>>   		dev->last_residency = 0;
>>   		/* give the governor an opportunity to reflect on the outcome */
>
> Is this if block really necessary?  We already have need_resched() being
> monitored in the outer loop.  Are cpuidle_select() or rcu_idle_enter()
> likely to spend a significant amount of time justifying a recheck here?

That's a question I have been always asking myself.

The cpuidle_select function could spend some time for:

1. reflecting the idle time for the statistics of the previous idle 
period. This processing is post-poned when exiting an idle state via the 
'need_update' field in the cpuidle structure. I guess, this is because 
it can take a while and we want to exit asap to reduce the wakeup latency.

2. there are some processing to choose the idle state.

I don't know what is the rational here to use need_resched at this place 
except to 'abort' an idle state arbitrarily after some experimentation 
for better reactivity. I am wondering if the multiple need_resched() we 
find in the call stack for some idle states makes really sense and 
doesn't denote a lack of control of what is happening in the idle path 
vs system activity or a lack of confidence in the idle duration prediction.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

