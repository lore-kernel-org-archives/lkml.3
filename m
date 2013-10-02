Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JBJzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:55:48 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56736 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3JBJzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:55:45 -0400
Message-ID: <524BED9F.2040404@linaro.org>
Date: Wed, 02 Oct 2013 11:55:43 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] tick: make sleep length calculation more accurate
References: <1380279140-27728-1-git-send-email-daniel.lezcano@linaro.org> <524B3F14.5040001@codeaurora.org>
In-Reply-To: <524B3F14.5040001@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 11:31 PM, Stephen Boyd wrote:
> On 09/27/13 03:52, Daniel Lezcano wrote:
>> The sleep_length is computed in the tick_nohz_stop_sched_tick function but it
>> is used later in the code with in between the local irq enabled.
>>
>> cpu_idle_loop
>>    tick_nohz_idle_enter         [ exits with local irq enabled ]
>>     __tick_nohz_idle_enter
>>       tick_nohz_stop_sched_tick
>>    ...
>>
>>    arch_cpu_idle
>>       menu_select               [ uses here 'sleep_length' ]
>>    ...
>>
>> Between the computation of the sleep length and its usage, some interrupts
>> can occur, making the sleep length shorter than actually it is.
>>
>> This patch fixes that by moving the sleep_length computation in the
>> tick_nohz_get_sleep_length function and store the next_event for the device
>> instead of the sleep_length.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   include/linux/tick.h     |    2 +-
>>   kernel/time/tick-sched.c |    5 +++--
>>   2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/tick.h b/include/linux/tick.h
>> index 5128d33..4932004 100644
>> --- a/include/linux/tick.h
>> +++ b/include/linux/tick.h
>> @@ -67,7 +67,7 @@ struct tick_sched {
>>   	ktime_t				idle_exittime;
>>   	ktime_t				idle_sleeptime;
>>   	ktime_t				iowait_sleeptime;
>> -	ktime_t				sleep_length;
>> +	ktime_t				next_event;
>>   	unsigned long			last_jiffies;
>>   	unsigned long			next_jiffies;
>>   	ktime_t				idle_expires;
>
> Documentation update?
>
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index 3612fc7..2007a7f 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -673,7 +673,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>>   out:
>>   	ts->next_jiffies = next_jiffies;
>>   	ts->last_jiffies = last_jiffies;
>> -	ts->sleep_length = ktime_sub(dev->next_event, now);
>> +	ts->next_event = dev->next_event;
>>
>>   	return ret;
>>   }
>> @@ -837,8 +837,9 @@ void tick_nohz_irq_exit(void)
>>   ktime_t tick_nohz_get_sleep_length(void)
>>   {
>>   	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>> +	ktime_t now = ktime_get();
>>
>> -	return ts->sleep_length;
>> +	return ktime_sub(ts->next_event, now);
>>   }
>>
>>   static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
>
> What happens if the idling CPU's next_event is updated via that
> interrupt? Say if the interrupt handler schedules a timer to fire before
> the next timer on the CPU? It looks like we won't notice that.

Yes, or after.

It sounds like this issue also occurs with the current code, no ?

> Perhaps it's better to do this instead?
>
>   ktime_t tick_nohz_get_sleep_length(void)
>   {
>   	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> +	ktime_t now = ktime_get();
> +	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
>
> -	return ts->sleep_length;
> +	return ktime_sub(dev->next_event, now);
>   }

Yes, I agree.

Thanks for the review.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

