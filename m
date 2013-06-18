Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab3FRIYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:24:30 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:52258 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3FRIYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:24:22 -0400
Message-ID: <51C0193A.40607@linaro.org>
Date: Tue, 18 Jun 2013 10:24:26 +0200
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
References: <20130618071756.22598.51046.sendpatchset@w520> <51C00D08.3080406@linaro.org> <CANqRtoR-f6SXE0HFw_giJj3PMas-WZA_WvmkTL2rA-jVj_2QCA@mail.gmail.com>
In-Reply-To: <CANqRtoR-f6SXE0HFw_giJj3PMas-WZA_WvmkTL2rA-jVj_2QCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 09:39 AM, Magnus Damm wrote:
> On Tue, Jun 18, 2013 at 4:32 PM, Daniel Lezcano
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
>>
>> Do we need a broadcast timer when cpuidle is not compiled in the kernel ?
> 
> Yes, if there is no per-cpu timer available. It depends on what the
> SMP support code for a particular SoC or architecture happen to
> enable.

Ok thanks for the information.

There is here a multiple occurrence of the information "the timer will
stop when power is saved": CLOCK_EVT_FEAT_C3STOP and
CPUIDLE_FLAG_TIMER_STOP, so I am wondering if some code simplification
couldn't be done before your patch.

The function:

tick_broadcast_oneshot_control is called from clockevents_notify. This
one is called from the cpuidle framework or the back-end cpuidle driver.
The caller knows the timer will be stop and this is why it is switching
to the broadcast mode. But we have a sanity check in
tick_broadcast_oneshot_control function:

        if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
                return;

In other words, CPUIDLE_FLAG_TIMER_STOP will tell the framework to call
clockevents_notify and the tick broadcast code will re-check the device
will effectively go down. IMHO, we can get rid of this check.

The same happens for the tick_do_broadcast_on_off function.

That reduces the number of C3STOP usage.

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

