Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3FSNxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:53:48 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44061 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3FSNxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:53:44 -0400
Message-ID: <51C1B7ED.9020101@linaro.org>
Date: Wed, 19 Jun 2013 15:53:49 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] clockevents: Ignore C3STOP when CPUIdle is disabled
References: <20130618071756.22598.51046.sendpatchset@w520> <51C01A97.5000903@linaro.org> <CANqRtoS14fpHg=T0H3TzVVoB-Q0PnwJsUPkQ1PEOo2hkMkTjSw@mail.gmail.com>
In-Reply-To: <CANqRtoS14fpHg=T0H3TzVVoB-Q0PnwJsUPkQ1PEOo2hkMkTjSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 10:56 AM, Magnus Damm wrote:
> Hi Daniel,
> 
> On Tue, Jun 18, 2013 at 5:30 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> On 06/18/2013 09:17 AM, Magnus Damm wrote:
>>> From: Magnus Damm <damm@opensource.se>
>>>
>>> Introduce the function tick_device_may_c3stop() that
>>> ignores the C3STOP flag in case CPUIdle is disabled.
>>>
>>> The C3STOP flag tells the system that a clock event
>>> device may be stopped during deep sleep, but if this
>>> will happen or not depends on things like if CPUIdle
>>> is enabled and if a CPUIdle driver is available.
>>>
>>> This patch assumes that if CPUIdle is disabled then
>>> the sleep mode triggering C3STOP will never be entered.
>>> So by ignoring C3STOP when CPUIdle is disabled then it
>>> becomes possible to use high resolution timers with only
>>> per-cpu local timers - regardless if they have the
>>> C3STOP flag set or not.
>>>
>>> Observed on the r8a73a4 SoC that at this point only uses
>>> ARM architected timers for clock event and clock sources.
>>>
>>> Without this patch high resolution timers are run time
>>> disabled on the r8a73a4 SoC - this regardless of CPUIdle
>>> is disabled or not.
>>>
>>> The less short term fix is to add support for more timers
>>> on the r8a73a4 SoC, but until CPUIdle support is enabled
>>> it must be possible to use high resoultion timers without
>>> additional timers.
>>>
>>> I'd like to hear some feedback and also test this on more
>>> systems before merging the code, see the non-SOB below.
>>>
>>> Not-Yet-Signed-off-by: Magnus Damm <damm@opensource.se>
>>> ---
>>>
>>>  An earlier ARM arch timer specific version of this patch was
>>>  posted yesterday as:
>>>  "[PATCH/RFC] arm: arch_timer: Do not set C3STOP in case CPU_IDLE=n"
>>>
>>>  Many thanks to Mark Rutland for his kind feedback.
>>>
>>>  kernel/time/tick-broadcast.c |    8 ++++----
>>>  kernel/time/tick-common.c    |    2 +-
>>>  kernel/time/tick-internal.h  |   11 +++++++++++
>>>  3 files changed, 16 insertions(+), 5 deletions(-)
>>>
>>> --- 0001/kernel/time/tick-broadcast.c
>>> +++ work/kernel/time/tick-broadcast.c 2013-06-18 15:36:21.000000000 +0900
>>> @@ -71,7 +71,7 @@ int tick_check_broadcast_device(struct c
>>>       if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
>>>           (tick_broadcast_device.evtdev &&
>>>            tick_broadcast_device.evtdev->rating >= dev->rating) ||
>>> -          (dev->features & CLOCK_EVT_FEAT_C3STOP))
>>> +          tick_device_may_c3stop(dev))
>>>               return 0;
>>>
>>>       clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
>>> @@ -146,7 +146,7 @@ int tick_device_uses_broadcast(struct cl
>>>                * feature and the cpu is marked in the broadcast mask
>>>                * then clear the broadcast bit.
>>>                */
>>> -             if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
>>> +             if (!tick_device_may_c3stop(dev)) {
>>>                       int cpu = smp_processor_id();
>>>                       cpumask_clear_cpu(cpu, tick_broadcast_mask);
>>>                       tick_broadcast_clear_oneshot(cpu);
>>> @@ -270,7 +270,7 @@ static void tick_do_broadcast_on_off(uns
>>>       /*
>>>        * Is the device not affected by the powerstate ?
>>>        */
>>> -     if (!dev || !(dev->features & CLOCK_EVT_FEAT_C3STOP))
>>> +     if (!dev || !tick_device_may_c3stop(dev))
>>>               goto out;
>>>
>>>       if (!tick_device_is_functional(dev))
>>> @@ -568,7 +568,7 @@ void tick_broadcast_oneshot_control(unsi
>>>       td = &per_cpu(tick_cpu_device, cpu);
>>>       dev = td->evtdev;
>>>
>>> -     if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
>>> +     if (!tick_device_may_c3stop(dev))
>>>               return;
>>>
>>>       bc = tick_broadcast_device.evtdev;
>>> --- 0001/kernel/time/tick-common.c
>>> +++ work/kernel/time/tick-common.c    2013-06-18 15:36:29.000000000 +0900
>>> @@ -52,7 +52,7 @@ int tick_is_oneshot_available(void)
>>>
>>>       if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
>>>               return 0;
>>> -     if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
>>> +     if (!tick_device_may_c3stop(dev))
>>>               return 1;
>>>       return tick_broadcast_oneshot_available();
>>>  }
>>> --- 0001/kernel/time/tick-internal.h
>>> +++ work/kernel/time/tick-internal.h  2013-06-18 15:40:10.000000000 +0900
>>> @@ -141,6 +141,17 @@ static inline int tick_device_is_functio
>>>       return !(dev->features & CLOCK_EVT_FEAT_DUMMY);
>>>  }
>>>
>>> +/*
>>> + * Check, if the device has C3STOP behavior and CPU Idle is enabled
>>> + */
>>> +static inline bool tick_device_may_c3stop(struct clock_event_device *dev)
>>
>> I prefer tick_device_is_reliable(struct clock_event_device *dev).
> 
> Sure. I took the name from the flag, thought that made it easy to follow.
> 
> I wonder what the timekeeping maintainers prefer?

Personally, I would prefer tick_device_is_reliable function instead of
c3stop because this one is coming from the C-state Intel semantic. On
the other architectures, the C-state does not make sense and, especially
for ARM, you can have idle state corresponding to the index #1 where the
timer is shutdown. This comment also apply to CLOCK_EVT_FEAT_C3STOP ...
but this is diverging from the purpose of your patch.

>>> +{
>>> +     /* The C3 sleep mode can only trigger when CPU Idle is enabled,
>>> +      * so if CPU Idle is disabled then the C3STOP flag can be ignored */
>>> +     return (IS_ENABLED(CONFIG_CPU_IDLE) &&
>>> +             (dev->features & CLOCK_EVT_FEAT_C3STOP));
>>> +}
>>
>> Preferably you may use the format:
>>
>> #ifdef CONFIG_CPU_IDLE
>> static inline bool tick_device_is_reliable(struct clock_event_device *dev)
>> {
>>         return dev->features & CLOCK_EVT_FEAT_C3STOP;
>> }
>> #else
>> static inline bool tick_device_is_reliable(struct clock_event_device *dev)
>> {
>>         return true;
>> }
>> #endif
>>
>> to conform the header style format already present in the file.
> 
> I agree with  you about following the same style. Actually, I wrote
> the code to follow the code right above the function, but I decided to
> return bool instead of int. I don't mind so much in general though,
> except trying to keep the code at least half well-commented and
> relatively compact.
> 
> So regarding stylistic things, sure, we can move around things.
> Question is just if this is acceptable or not. =)


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

