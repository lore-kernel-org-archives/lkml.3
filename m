Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaLPLy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:54:59 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:44422 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaLPLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:54:57 -0500
Message-ID: <54901D90.1080109@linaro.org>
Date: Tue, 16 Dec 2014 12:54:56 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP
 broadcast
References: <20141216094854.22639.69181.sendpatchset@w520>	<54901420.50403@linaro.org>	<1418731028.WfBPmyK53y@avalon> <CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
In-Reply-To: <CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 12:46 PM, Magnus Damm wrote:
> Hi Laurent,
>
> On Tue, Dec 16, 2014 at 8:20 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Daniel,
>>
>> On Tuesday 16 December 2014 12:14:40 Daniel Lezcano wrote:
>>> On 12/16/2014 10:48 AM, Magnus Damm wrote:
>>>> From: Magnus Damm <damm+renesas@opensource.se>
>>>>
>>>> Update the TMU driver to use cpu_possible_mask as cpumask to make
>>>> r8a7779 SMP work as expected with or without the ARM TWD timer.
>>>>
>>>> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
>>>
>>> Applied as a 3.18 fix.
>>
>> You're a bit too fast, I haven't had time to review the patch yet.
>>
>>> ps: May I suggest to use the CLOCK_EVT_FEAT_DYNIRQ flag for this driver ?
>>>
>>>> ---
>>>>
>>>>    drivers/clocksource/sh_tmu.c |    2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> --- 0001/drivers/clocksource/sh_tmu.c
>>>> +++ work/drivers/clocksource/sh_tmu.c       2014-12-16 17:49:49.000000000 +0900
>>>> @@ -428,7 +428,7 @@ static void sh_tmu_register_clockevent(s
>>>>
>>>>      ced->features = CLOCK_EVT_FEAT_PERIODIC;
>>>>      ced->features |= CLOCK_EVT_FEAT_ONESHOT;
>>>>      ced->rating = 200;
>>>> -   ced->cpumask = cpumask_of(0);
>>>> +   ced->cpumask = cpu_possible_mask;
>>
>> Magnus, how thoroughly have you tested this ? The TMU is indeed usable by all
>> CPUs, so setting the CPU mask to cpu_possible_mask makes sense, but last time
>> I've tried that it broke the broadcast timer due to the heuristics used by the
>> clock events core code.
>
> Uhm, so I've tested this particular patch on r8a7779 but I do agree
> that the TMU is used on a bunch of SoCs if that's what you mean. I
> don't see how it is different from any other of our timers though, and
> those got fixed like this earlier.
>
> I wonder if you may recall an earlier issue with incorrect clock event
> priorities and code somehow working-by-accident without the mask set
> as expected?

Could have been fixed with : ?

commit 70e5975d3a04be5479a28eec4a2fb10f98ad2785
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Thu Jun 13 11:39:50 2013 -0700

     clockevents: Prefer CPU local devices over global devices

     On an SMP system with only one global clockevent and a dummy
     clockevent per CPU we run into problems. We want the dummy
     clockevents to be registered as the per CPU tick devices, but
     we can only achieve that if we register the dummy clockevents
     before the global clockevent or if we artificially inflate the
     rating of the dummy clockevents to be higher than the rating
     of the global clockevent. Failure to do so leads to boot
     hangs when the dummy timers are registered on all other CPUs
     besides the CPU that accepted the global clockevent as its tick
     device and there is no broadcast timer to poke the dummy
     devices.

     If we're registering multiple clockevents and one clockevent is
     global and the other is local to a particular CPU we should
     choose to use the local clockevent regardless of the rating of
     the device. This way, if the clockevent is a dummy it will take
     the tick device duty as long as there isn't a higher rated tick
     device and any global clockevent will be bumped out into
     broadcast mode, fixing the problem described above.



>> Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and
>> CONFIG_PREEMPT with and without the ARM TWD times, and that you've booted to
>> userspace and tested timer broadcast on all CPUs ?
>
> No I have not. I've booted to user space in initramfs with DT-based
> TWD on Multiplatform for r8a7779. Without this fix (and other r8a7779
> TWD bits) I see a lot of breakage. For instance, TWD and SMP boot is
> broken on r8a7779 - both legacy and non-legacy. I have not gotten to
> sh73a0 yet, but I assume it is busted too.
>
> Can you please explain to me how the TMU is any different compared to
> the CMT, MTU2 or STI? =)
>
> And no, I don't have any r8a7740 board anymore. Can anyone else test?
>
> Cheers,
>
> / magnus
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

