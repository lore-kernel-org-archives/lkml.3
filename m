Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaDOM1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:27:54 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52794 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOM1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:27:50 -0400
Message-ID: <534D25DC.4050400@linaro.org>
Date: Tue, 15 Apr 2014 14:28:12 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] clocksource: exynos_mct: Fix stall after CPU hotplugging
References: <1396011962-4467-1-git-send-email-k.kozlowski@samsung.com> <1397554445.29169.21.camel@AMDC1943>
In-Reply-To: <1397554445.29169.21.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 11:34 AM, Krzysztof Kozlowski wrote:
> On pią, 2014-03-28 at 14:06 +0100, Krzysztof Kozlowski wrote:
>> Fix stall after hotplugging CPU1. Affected are SoCs where Multi Core Timer
>> interrupts are shared (SPI), e.g. Exynos 4210. The stall was a result of
>> starting the CPU1 local timer not in L1 timer but in L0 (which is used
>> by CPU0).
>
> Hi,
>
> Do you have any comments on these 3 patches? They fix the CPU stall on
> Exynos4210 and also on Exynos3250 (Chanwoo Choi sent patches for it
> recently).

You describe this issue as impacting different SoC not only the exynos, 
right ?

Do you know what other SoCs are impacted by this ?

I guess this issue is not reproducible just with the line below, we need 
a timer to expire right at the moment CPU1 is hotplugged, right ?

>> Trigger:
>> $ echo 0 > /sys/bus/cpu/devices/cpu1/online && echo 1 > /sys/bus/cpu/devices/cpu1/online
>>
>> Stall information:
>> [  530.045259] INFO: rcu_preempt detected stalls on CPUs/tasks:
>> [  530.045618]  1: (6 GPs behind) idle=6d0/0/0 softirq=369/369
>> [  530.050987]  (detected by 0, t=6589 jiffies, g=33, c=32, q=0)
>> [  530.056721] Task dump for CPU 1:
>> [  530.059928] swapper/1       R running      0     0      1 0x00001000
>> [  530.066377] [<c0524e14>] (__schedule+0x414/0x9b4) from [<c00b6610>] (rcu_idle_enter+0x18/0x38)
>> [  530.074955] [<c00b6610>] (rcu_idle_enter+0x18/0x38) from [<c0079a18>] (cpu_startup_entry+0x60/0x3bc)
>> [  530.084069] [<c0079a18>] (cpu_startup_entry+0x60/0x3bc) from [<c0517d34>] (secondary_start_kernel+0x164/0x1a0)
>> [  530.094029] [<c0517d34>] (secondary_start_kernel+0x164/0x1a0) from [<40517244>] (0x40517244)
>>
>> The timers for CPU1 were missed:
>> [  591.668436] cpu: 1
>> [  591.670430]  clock 0:
>> [  591.672691]   .base:       c0ab7750
>> [  591.676160]   .index:      0
>> [  591.679025]   .resolution: 1 nsecs
>> [  591.682404]   .get_time:   ktime_get
>> [  591.685970]   .offset:     0 nsecs
>> [  591.689349] active timers:
>> [  591.692045]  #0: <dfb51f40>, hrtimer_wakeup, S:01
>> [  591.696759]  # expires at 454687834257-454687884257 nsecs [in -136770537232 to -136770487232 nsecs]
>>
>> And the event_handler for next event was wrong:
>> [  591.917120] Tick Device: mode:     1
>> [  591.920676] Per CPU device: 0
>> [  591.923621] Clock Event Device: mct_tick0
>> [  591.927623]  max_delta_ns:   178956969027
>> [  591.931613]  min_delta_ns:   1249
>> [  591.934913]  mult:           51539608
>> [  591.938557]  shift:          32
>> [  591.941681]  mode:           3
>> [  591.944724]  next_event:     595025000000 nsecs
>> [  591.949227]  set_next_event: exynos4_tick_set_next_event
>> [  591.954522]  set_mode:       exynos4_tick_set_mode
>> [  591.959296]  event_handler:  hrtimer_interrupt
>> [  591.963730]  retries:        0
>> [  591.966761]
>> [  591.968245] Tick Device: mode:     0
>> [  591.971801] Per CPU device: 1
>> [  591.974746] Clock Event Device: mct_tick1
>> [  591.978750]  max_delta_ns:   178956969027
>> [  591.982739]  min_delta_ns:   1249
>> [  591.986037]  mult:           51539608
>> [  591.989681]  shift:          32
>> [  591.992806]  mode:           3
>> [  591.995848]  next_event:     453685000000 nsecs
>> [  592.000353]  set_next_event: exynos4_tick_set_next_event
>> [  592.005648]  set_mode:       exynos4_tick_set_mode
>> [  592.010421]  event_handler:  tick_handle_periodic
>> [  592.015115]  retries:        0
>> [  592.018145]
>>
>> After turning off the CPU1, the MCT L1 local timer was disabled but the
>> interrupt was not cleared. Turning on the CPU1 enabled the IRQ
>> with setup_irq() but, before setting affinity to CPU1, the pending L1 timer
>> interrupt was processed by CPU0 in exynos4_mct_tick_isr().
>>
>> The ISR then called event handler which set up the next timer event for
>> current CPU (CPU0). Therefore the MCT L1 timer wasn't actually started.
>>
>> Fix the stall by:
>> 1. Setting next timer event not on current CPU but on the CPU indicated
>>     by cpumask in 'clock_event_device'.
>> 2. Clearing the timer interrupt upon stopping the local timer.
>>
>> The patch also moves around the call to exynos4_mct_tick_stop() but this
>> is done only for the code readability as it is not essential for the fix.
>>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   drivers/clocksource/exynos_mct.c |   33 ++++++++++++++++++++-------------
>>   1 file changed, 20 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
>> index 48f76bc05da0..0b49b09dd1a9 100644
>> --- a/drivers/clocksource/exynos_mct.c
>> +++ b/drivers/clocksource/exynos_mct.c
>> @@ -339,7 +339,14 @@ static void exynos4_mct_tick_start(unsigned long cycles,
>>   static int exynos4_tick_set_next_event(unsigned long cycles,
>>   				       struct clock_event_device *evt)
>>   {
>> -	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
>> +	/*
>> +	 * In case of hotplugging non-boot CPU, the set_next_event could be
>> +	 * called on CPU0 by ISR before IRQ affinity is set to proper CPU.
>> +	 * Thus for accessing proper MCT Lx timer, 'per_cpu' for cpumask
>> +	 * in event must be used instead of 'this_cpu_ptr'.
>> +	 */
>> +	struct mct_clock_event_device *mevt = &per_cpu(percpu_mct_tick,
>> +			cpumask_first(evt->cpumask));
>>
>>   	exynos4_mct_tick_start(cycles, mevt);
>>
>> @@ -371,23 +378,13 @@ static inline void exynos4_tick_set_mode(enum clock_event_mode mode,
>>
>>   static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
>>   {
>> -	struct clock_event_device *evt = &mevt->evt;
>> -
>> -	/*
>> -	 * This is for supporting oneshot mode.
>> -	 * Mct would generate interrupt periodically
>> -	 * without explicit stopping.
>> -	 */
>> -	if (evt->mode != CLOCK_EVT_MODE_PERIODIC)
>> -		exynos4_mct_tick_stop(mevt);
>> -
>>   	/* Clear the MCT tick interrupt */
>>   	if (__raw_readl(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
>>   		exynos4_mct_write(0x1, mevt->base + MCT_L_INT_CSTAT_OFFSET);
>>   		return 1;
>> -	} else {
>> -		return 0;
>>   	}
>> +
>> +	return 0;
>>   }
>>
>>   static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
>> @@ -395,6 +392,13 @@ static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
>>   	struct mct_clock_event_device *mevt = dev_id;
>>   	struct clock_event_device *evt = &mevt->evt;
>>
>> +	/*
>> +	 * This is for supporting oneshot mode.
>> +	 * Mct would generate interrupt periodically
>> +	 * without explicit stopping.
>> +	 */
>> +	if (evt->mode != CLOCK_EVT_MODE_PERIODIC)
>> +		exynos4_mct_tick_stop(mevt);
>>   	exynos4_mct_tick_clear(mevt);
>>
>>   	evt->event_handler(evt);
>> @@ -441,7 +445,10 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
>>
>>   static void exynos4_local_timer_stop(struct clock_event_device *evt)
>>   {
>> +	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
>> +
>>   	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
>> +	exynos4_mct_tick_clear(mevt);
>>   	if (mct_int_type == MCT_INT_SPI)
>>   		free_irq(evt->irq, this_cpu_ptr(&percpu_mct_tick));
>>   	else
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

