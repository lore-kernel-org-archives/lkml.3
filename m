Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3AUVCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:02:37 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:48667 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3AUVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:02:36 -0500
MIME-Version: 1.0
In-Reply-To: <201301212041.17951.arnd@arndb.de>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 15:02:14 -0600
Message-ID: <CAKGA1bn0-83d+BFRMGZDZ9MZ2nnx8e8wh-VS3XoG5UQJDC0npg@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, Ben Dooks <ben@simtec.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 2:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 21 January 2013, Matt Sealey wrote:
>>
>> ARM seems to be the only "major" platform not using the
>> kernel/Kconfig.hz definitions, instead rolling it's own and setting
>> what could be described as both reasonable and unreasonable defaults
>> for platforms. If we're going wholesale for multiplatform on ARM then
>> having CONFIG_HZ be selected dependent on platform options seems
>> rather curious since building a kernel for Exynos, OMAP or so will
>> force the default to a value which is not truly desired by the
>> maintainers.
>
> Agreed 100%.
>
> (adding John Stultz to Cc, he's the local time expert)

Hi, John! Welcome to the fray :)

>> config HZ
>>         int
>>         default 200 if ARCH_EBSA110 || ARCH_S3C24XX || ARCH_S5P64X0 || \
>>                 ARCH_S5PV210 || ARCH_EXYNOS4
>>         default OMAP_32K_TIMER_HZ if ARCH_OMAP && OMAP_32K_TIMER
>>         default AT91_TIMER_HZ if ARCH_AT91
>>         default SHMOBILE_TIMER_HZ if ARCH_SHMOBILE
>>         default 100
>>

[snip]

>> Either way, if I boot a kernel on i.MX6, CONFIG_HZ depends on the
>> other ARM platforms I also want to boot on it.. this is not exactly
>> multiplatform compliant, right?
>
> Right. It's pretty clear that the above logic does not work
> with multiplatform.  Maybe we should just make ARCH_MULTIPLATFORM
> select NO_HZ to make the question much less interesting.
>
> Regarding the defaults, I would suggest putting them into all the
> defaults into the defconfig files and removing the other hardcoding
> otherwise. Ben Dooks and Russell are probably the best to know
> what triggered the 200 HZ for s3c24xx and for ebsa110. My guess
> is that the other samsung ones are the result of cargo cult
> programming.
>
> at91 and omap set the HZ value to something that is derived
> from their hardware timer, but we have also forever had logic
> to calculate the exact time when that does not match. This code
> has very recently been moved into the new register_refined_jiffies()
> function. John can probably tell is if this solves all the problems
> for these platforms.

I would be very interested. My plan would be then (providing John
responds in the affirmative) to basically submit a patch to remove the
8 lines pasted above and source kernel/Kconfig.hz instead. I'm doing
this now on a local kernel tree and I can't see any real problem with
it.

It would then be up to the above-mentioned maintainers to decide if
they are part of the cargo cult and don't need it or refine their
board files to match the New World Order of using Kconfig.hz. The
unconfigured kernel default is 100 anyway which is lower than all the
above default setting, so I would technically be causing a regression
on those platforms... do I want to be responsible for that? Probably
not, but as I said, it's not affecting (in fact, it may be
*improving*) the platforms I care about.

>> Additionally, using kernel/Kconfig.hz is a predicate for enabling
>> (forced enabling, even) CONFIG_SCHED_HRTICK which is defined nowhere
>> else. I don't know how many ARM systems here benefit from this, if
>> there is a benefit, or what this really means.. if you really have a
>> high resolution timer (and hrtimers enabled) that would assist the
>> scheduler this way, is it supposed to make a big difference to the way
>> the scheduler works for the better or worse? Is this actually
>> overridden by ARM sched_clock handling or so? Shouldn't there be a
>> help entry or some documentation for what this option does? I have
>> CC'd the scheduler maintainers because I'd really like to know what I
>> am doing here before I venture into putting patches out which could
>> potentially rip open spacetime and have us all sucked in..
>
> Yes, that sounds like yet another bug.

So is that a bug in that it is not available to ARM right now, a bug
in that it would be impossible for anyone on ARM to have ever tested
this code, or a bug in that it should NEVER be enabled for ARM for
some reason? John? Ingo? :)

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
