Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3AVKNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:13:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36085 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab3AVKN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:13:28 -0500
Message-ID: <50FE666B.10902@ti.com>
Date: Tue, 22 Jan 2013 15:44:03 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <20130121232322.GK15361@atomide.com> <50FE307F.9000701@ti.com> <201301220931.24570.arnd@arndb.de>
In-Reply-To: <201301220931.24570.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013 03:01 PM, Arnd Bergmann wrote:
> On Tuesday 22 January 2013, Santosh Shilimkar wrote:
>> On Tuesday 22 January 2013 04:53 AM, Tony Lindgren wrote:
>>> * Russell King - ARM Linux <linux@arm.linux.org.uk> [130121 13:07]:
>>>>
>>>> As for Samsung and the rest I can't comment.  The original reason OMAP
>>>> used this though was because the 32768Hz counter can't produce 100Hz
>>>> without a .1% error - too much error under pre-clocksource
>>>> implementations for timekeeping.  Whether that's changed with the
>>>> clocksource/clockevent support needs to be checked.
>>>
>>> Yes that's why HZ was originally set to 128. That value (or some multiple)
>>> still makes sense when the 32 KiHZ clock source is being used. Of course
>>> we should rely on the local timer when running for the SoCs that have
>>> them.
>>>
>> This is right. It was only because of the drift associated when clocked
>> with 32KHz. Even on SOCs where local timers are available for power
>> management reasons we need to switch to 32KHz clocked device in
>> low power states. Hence the HZ value should be multiple of 32 on
>> OMAP.
>
> I need some help understanding what the two of you are saying, because
> it sounds to me that you imply we cannot have a multiplatform kernel
> that includes OMAP and another platform that needs (or wants) a different
> HZ value.
>
Sorry for not being clear enough. On OMAP, 32KHz is the only clock which
is always running(even during low power states) and hence the clock
source and clock event have been clocked using 32KHz clock. As mentioned
by RMK, with 32768 Hz clock and HZ = 100, there will be always an
error of 0.1 %. This accuracy also impacts the timer tick interval.
This was the reason, OMAP has been using the HZ = 128.

There is a hardware feature to implement 1 ms correction on the timer
to overcome such an issue but it was not supported on OMAP2 devices.
OMAP3/4/5 does support it. Though one attempt [1] was made to support
it in kernel. This will ofcourse will address the tick interval
corrections.

> However, I also thought that when using a proper clocksource driver,
> the HZ setting has absolutely no impact on the drift of the wall clock,
> because those two are decoupled.
>
I am not too sure about this. I was under impression that tick (clock
event) ticking accuracy does impact the kernel time keeping as well.

> Even when using the HZ based clocksource (for whatever reason you
> would want to do that), I thought there should be no drift as long
> as the CLOCK_TICK_RATE (in older kernels) or the register_refined_jiffies()
> (in older kernels) setting matches the hardware timer frequency.
>
> What am I missing?
>
The issue is with hardware timer frequency itself since with HZ = 100 or
200, the timer tick will not be accurate. Hope this gives bit more info.

Regards,
Santosh
[1] https://patchwork.kernel.org/patch/107364/
