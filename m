Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3AUWyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:54:54 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:59497 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3AUWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:54:53 -0500
MIME-Version: 1.0
In-Reply-To: <50FDC2DD.7090406@linaro.org>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
 <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 16:54:31 -0600
Message-ID: <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 4:36 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 01/21/2013 01:14 PM, Matt Sealey wrote:
>>
>> On Mon, Jan 21, 2013 at 3:00 PM, John Stultz <john.stultz@linaro.org>
>> wrote:
>>>
>>> On 01/21/2013 12:41 PM, Arnd Bergmann wrote:
>>>>
>>>> Right. It's pretty clear that the above logic does not work
>>>> with multiplatform.  Maybe we should just make ARCH_MULTIPLATFORM
>>>> select NO_HZ to make the question much less interesting.
>>>
>>> Although, even with NO_HZ, we still have some sense of HZ.
>>
>> In this case, no matter whether CONFIG_HZ=1000 or CONFIG_HZ=250 (for
>> example) combined with CONFIG_NO_HZ and less than e.g. 250 things
>> happening per second will wake up "exactly" the same number of times?
>
> Ideally, if both systems are completely idle, they may see similar number of
> actual interrupts.
>
> But when the cpus are running processes, the HZ=1000 system will see more
> frequent interrupts, since the timer/scheduler interrupt will jump in 4
> times more frequently.

Understood..

>> CONFIG_HZ=1000 with CONFIG_NO_HZ would be an effective, all-round
>> solution here, then, and CONFIG_HZ=100 should be a reasonable default
>> (as it is anyway with an otherwise-unconfigured kernel on any other
>> platform) for !CONFIG_NO_HZ.
>
> Eeehhh... I'm not sure this is follows.

Okay, I'm happy to be wrong on this...

>> As above, or "not select anything at all" since HZ=100 if you don't
>> touch anything, right?
>
> Well, Russell brought up a case that doesn't handle this. If a system
> *can't* do HZ=100, but can do HZ=200.
>
> Though there are hacks, of course, that might get around this (skip every
> other interrupt at 200HZ).

Hmm, I think it might be appreciated for people looking at this stuff
(same as I stumbled into it) for a little comment on WHY the default
is 200. That way you don't wonder even if you know why EBSA110 has a
HZ=200 default, why Exynos is lumped in there too (to reduce the
number of interrupts firing? Maybe the Exynos timer interrupt is kind
of a horrid core NMI kind of thing and it's desirable for it not to be
every millisecond, or maybe it has the same restrictions as EBSA110,
but where would anyone go to find out this information?)

>> If someone picks HZ=1000 and their platform can't support it, then
>> that's their own damn problem (don't touch things you don't
>> understand, right? ;)
>
> Well, ideally with kconfig we try to add proper dependencies so impossible
> options aren't left to the user.
> HZ is a common enough knob to turn on most systems, I don't know if leaving
> the user rope to hang himself is a great idea.

I think then the default 100 at the end of the arch/arm/Kconfig is
saying "you are not allowed to know that such a thing as rope even
exists," when in fact what we should be doing is just making sure they
can't swing it over the rafters.. am I taking the analogy too far? :)

>> My question really has to be is CONFIG_SCHED_HRTICK useful, what
>> exactly is it going to do on ARM here since nobody can ever have
>> enabled it? Is it going to keel over and explode if nobody registers a
>> non-jiffies sched_clock (since the jiffies clock is technically
>> reporting itself as a ridiculously high resolution clocksource..)?
>
> ??? Not following this at all.  jiffies is the *MOST* coarse resolution
> clocksource there is (at least that I'm aware of.. I recall someone wanting
> to do a 60Hz clocksource, but I don't think that ever happened).

Is that based on it's clocksource rating (probably worse than a real
hrtimer) or it's reported resolution? Because on i.MX51 if I force it
to use the jiffies clock the debug on the kernel log is telling me it
has a higher resolution (it TELLS me that it ticks "as fast" as the
CPU frequency and wraps less than my real timer).

I know where the 60Hz clocksource might come from, the old Amiga
platforms have one based on the PSU frequency (50Hz in Europe, 60Hz
US/Japan). Even a 60Hz clocksource is useful though (on the Amiga, at
least, it is precisely the vsync clock for synchronizing your display
output on TV-out, which makes it completely useful for the framebuffer
driver), but.. you just won't expect to assign it as sched_clock or
your delay timer. And if anyone does I'd expect they'd know full well
it'd not run so well.

>> Or is this one of those things that if your platform doesn't have a
>> real high resolution timer, you shouldn't enable HRTIMERS and
>> therefore not enable SCHED_HRTICK as a result? That affects
>> ARCH_MULTIPLATFORM here. Is the solution as simple as
>> ARCH_MULTIPLATFORM compliant platforms kind of have to have a high
>> resolution timer? Documentation to that effect?
>
> SO HRITMERS was designed to be be build time enabled, while still giving you
> a functioning system if it was booted on a system that didn't support
> clockevents.  We boot with standard HZ, and only switch over to HRT mode if
> we have a proper clocksource and clockevent driver.

Okay. I'm still a little confused as to what SCHED_HRTICK actually
makes a difference to, though.

>From that description, we are booting with standard HZ on ARM, and the
core sched_clock (as in we can call setup_sched_clock)
and/or/both/optionally using a real delay_timer switch to HRT mode if
we have the right equipment available in the kernel and at runtime on
the SoC.. but the process scheduler isn't compiled with the means to
actually take advantage of us being in HRT mode?

> However, HRTIMERS or NOHZ doesn't fix the case of having a system boot with
> HZ=1000 or HZ=100 if the system can *only* do HZ=200.

A simple BUILD_BUG_ON and a BUG_ON right after each other in the
appropriate clocksource driver solves that.. if there's an insistence
on having at least some rope, we can put them in a field and tell them
they have to use the moon to actually hang themselves...

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
