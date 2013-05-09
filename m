Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3EIXpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:45:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49148 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3EIXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 19:45:10 -0400
Message-ID: <518C3502.2040306@linaro.org>
Date: Fri, 10 May 2013 01:45:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lianwei Wang <lianwei.wang@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: don't wakeup processor when set a
 longer latency
References: <CAJFUiJiMMAgLGF3tiG1V59dx+KOpTBCEL3ctHUosjMDkBagbJg@mail.gmail.com> <518A324A.8000000@linaro.org> <CAJFUiJio8jHtGwGo=-FSm6_E9LATSkyUx_iWsuFddmA9+PXCJA@mail.gmail.com>
In-Reply-To: <CAJFUiJio8jHtGwGo=-FSm6_E9LATSkyUx_iWsuFddmA9+PXCJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 09:14 AM, Lianwei Wang wrote:
> Thank you very much. I have a quick updated patch based on your comments.
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 2f0083a..cd1af4b 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -18,6 +18,7 @@
>  #include <linux/ktime.h>
>  #include <linux/hrtimer.h>
>  #include <linux/module.h>
> +#include <linux/tick.h>
>  #include <trace/events/power.h>
> 
>  #include "cpuidle.h"
> @@ -466,7 +467,20 @@ static void smp_callback(void *v)
>  static int cpuidle_latency_notify(struct notifier_block *b,
>                 unsigned long l, void *v)
>  {
> -       smp_call_function(smp_callback, NULL, 1);
> +       int cpu, rcpu = smp_processor_id();
> +       s64 s;
> +       struct tick_device *td;
> +
> +       for_each_online_cpu(cpu) {
> +               if (cpu == rcpu)
> +                       continue;
> +               td = tick_get_device(cpu);
> +               s = ktime_us_delta(td->evtdev->next_event, ktime_get());
> +               if ((long)l < (long)s) {
> +                       smp_call_function_single(cpu, smp_callback, NULL, 1);
> +               }
> +       }
> +
>         return NOTIFY_OK;
>  }

The patch sounds reasonable. A comment and explicit names for the
variables would be nice.

eg.
l => latency
s => sleep

> Thanks,
> Lianwei
> 
> 2013/5/8 Daniel Lezcano <daniel.lezcano@linaro.org>:
>> On 05/08/2013 04:44 AM, Lianwei Wang wrote:
>>> When a PM-Qos is updated, the cpuidle driver will wakeup all the CPUs
>>> no matter what a latency is set. But actually it only need to wakeup
>>> the CPUs when a shorter latency is set. In this way we can reduce the
>>> cpu wakeup count and save battery.
>>
>> I am curious, how many times could the pm_qos be changed in a system
>> live cycle to measure an improvement with this patch ?
>>
>> Do you have a scenario where you measured a noticeable power saving ?
>>
> The PM-Qos is not updated most of time, especially for home idle case.
>  But for some specific case, the PM-Qos may update too frequently.
> (E.g. my measurement show that it is changed frequently between
> 2us/3us/200us/200s for bootup and usb case.) The battery current drain
> is measured from PMIC or battery eliminator. Although this is just a
> little saving, it is still reasonable to improve it.

Thanks for the information. Can you add this information in the changelog ?

>>> So we can pass the prev_value to the notifier callback and check the
>>> latency curr_value and prev_value in the cpuidle latency notifier
>>> callback. It modify a common interface(dummy --> prev_value) but shall
>>> be safe since no one use the dummy parameter currently.
>>>
>>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>>> index e1f6860..1e1758c 100644
>>> --- a/drivers/cpuidle/cpuidle.c
>>> +++ b/drivers/cpuidle/cpuidle.c
>>> @@ -498,7 +498,11 @@ static void smp_callback(void *v)
>>>  static int cpuidle_latency_notify(struct notifier_block *b,
>>>                 unsigned long l, void *v)
>>>  {
>>> -       smp_call_function(smp_callback, NULL, 1);
>>> +       unsigned long prev_value = (unsigned long) v;
>>> +
>>> +       /* Dont't waktup processor when set a longer latency */
>>
>>                     ^^^^^^
>>                     wakeup
>>
>> Instead of passing prev and curr, using the dummy variable, why don't
>> you pass the result of (curr - prev) ?
>>
>> A negative value means, the latency is smaller and positive is bigger.
>>
>> Also, may be the optimization could be more improved: if the latency is
>> bigger than the next wakeup event, it is not necessary to wakeup the cpus.
>>
> This is good idea. So it need to check the next_event on each CPU and
> wakeup the cpu if the requested latency is smaller than it. A quick
> patch is attached.

Yes, it sounds good.

>>> +       if (l < prev_value)
>>> +               smp_call_function(smp_callback, NULL, 1);
>>>         return NOTIFY_OK;
>>>  }
>>>
>>> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
>>> index 9322ff7..533b8bc 100644
>>> --- a/kernel/power/qos.c
>>> +++ b/kernel/power/qos.c
>>> @@ -205,7 +205,7 @@ int pm_qos_update_target(struct pm_qos_constraints
>>> *c, struct plist_node *node,
>>>         if (prev_value != curr_value) {
>>>                 blocking_notifier_call_chain(c->notifiers,
>>>                                              (unsigned long)curr_value,
>>> -                                            NULL);
>>> +                                            (void *)prev_value);
>>>                 return 1;
>>>         } else {
>>>                 return 0;
>>>
>>
>>
>> --
>>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog
>>


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

