Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3BGLj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:39:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41139 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab3BGLj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:39:26 -0500
Message-ID: <511392A8.9010905@ti.com>
Date: Thu, 7 Feb 2013 17:10:24 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com> <1358183124-28461-5-git-send-email-mark.rutland@arm.com> <5112C25F.6000508@wwwdotorg.org> <20130207100403.GD16987@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130207100403.GD16987@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Thursday 07 February 2013 03:34 PM, Mark Rutland wrote:
> Hi Stephen,
>
> Sorry about this; I'm to blame for the bug.
>
> On Wed, Feb 06, 2013 at 08:51:43PM +0000, Stephen Warren wrote:
>> On 01/14/2013 10:05 AM, Mark Rutland wrote:
>>> Implement timer_broadcast for the arm architecture, allowing for the use
>>> of clock_event_device_drivers decoupled from the timer tick broadcast
>>> mechanism.
>>
>> Mark, this patch is now in next-20130206 and causes a crash during boot
>> on Tegra. The reason appears to be because of:
>>
>>> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
>>
>>> @@ -524,7 +524,6 @@ static void __cpuinit percpu_timer_setup(void)
>>>   	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
>>>
>>>   	evt->cpumask = cpumask_of(cpu);
>>> -	evt->broadcast = smp_timer_broadcast;
>>
>> After that change, evt->broadcast is never assigned, and hence is NULL.
>> Yet elsewhere in kernel/time/tick-broadcast.c it's used unconditionally:
>>
>> static void tick_do_broadcast(struct cpumask *mask)
>> ...
>> 	if (!cpumask_empty(mask)) {
>> ...
>> 		td = &per_cpu(tick_cpu_device, cpumask_first(mask));
>> 		td->evtdev->broadcast(mask);
>>
>> Now perhaps the Tegra timer driver simply isn't being set up correctly,
>> so the bug is there... But the only other place I can find where
>> ->broadcast is assigned is in tick_device_uses_broadcast() which only
>> does it for "non-functional" timers, which doesn't apply to Tegra's timer.
>>
>
> The intent of 12ad100046: "clockevents: Add generic timer broadcast function"
> was to setup the broadcast function both for non-functional/dummy timers and
> those that stop in low-power states (CLOCK_EVT_FEAT_C3STOP). I missed the
> CLOCK_EVT_FEAT_C3STOP case.
>
I am not sure this exactly the case. Because in my testing, the C3STOP 
path was exercised already. And if the C3STOP is used then notifiers
calls are expected for switching of clock-events to broadcast mode.

And dummy broad-cast hook should come into picture only if the per CPU
local timer clock-event are not registered.

I just tried "next-20130207" on OMAP and I see the broad-cast mechanism
works and didn't observe any crash.

------------------------------
Tick Device: mode:     1
Broadcast device
Clock Event Device: gp_timer
  max_delta_ns:   131071523464981
  min_delta_ns:   91552
  mult:           70369
  shift:          31
  mode:           3
  next_event:     89984375000 nsecs
  set_next_event: omap2_gp_timer_set_next_event
  set_mode:       omap2_gp_timer_set_mode
  event_handler:  tick_handle_oneshot_broadcast
  retries:        0

tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: local_timer
  max_delta_ns:   10737418240
  min_delta_ns:   1000
  mult:           858993459
  shift:          31
  mode:           3
  next_event:     125250000000 nsecs
  set_next_event: twd_set_next_event
  set_mode:       twd_set_mode
  event_handler:  hrtimer_interrupt
  retries:        346

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: local_timer
  max_delta_ns:   10737418240
  min_delta_ns:   1000
  mult:           858993459
  shift:          31
  mode:           3
  next_event:     89921875000 nsecs
  set_next_event: twd_set_next_event
  set_mode:       twd_set_mode
  event_handler:  hrtimer_interrupt
  retries:        258

#

------------------------------

> I believe the patch below will fix this for Tegra and any other platforms where
> broadcast is required in low power states.
>
Am not sure you really need that patch unless and until am missing a
scenario in my test.

Stephan,

Do we have crash log seen on Tegra ? Which tegra CPUIDLE driver
is being used when crash is seen ?

Regards
Santosh

