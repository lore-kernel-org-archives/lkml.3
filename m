Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3AUUCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:02:21 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48702 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3AUUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:02:20 -0500
MIME-Version: 1.0
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 14:01:57 -0600
Message-ID: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
Subject: One of these things (CONFIG_HZ) is not like the others..
To: Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Understanding that this is a bit of a digression, I have a related
nitpick to discussion of the patch "arm: kconfig: don't select TWD
with local timer for Armada 370/XP" which is allowing me to explain
myself a little better given Arnd's recommendation for it, since I was
looking for a really good way to describe it without seeming too
focused on a particular configuration item..

So, to recap, there is a discussion going on about where HAVE_ lives
and what ARCH_MULTIPLATFORM breakes when using HAVE_. I think this is
related, at least, to configuration reworks to make ARCH_MULTIPLATFORM
a truly "inclusive" place..

ARM seems to be the only "major" platform not using the
kernel/Kconfig.hz definitions, instead rolling it's own and setting
what could be described as both reasonable and unreasonable defaults
for platforms. If we're going wholesale for multiplatform on ARM then
having CONFIG_HZ be selected dependent on platform options seems
rather curious since building a kernel for Exynos, OMAP or so will
force the default to a value which is not truly desired by the
maintainers.

config HZ
        int
        default 200 if ARCH_EBSA110 || ARCH_S3C24XX || ARCH_S5P64X0 || \
                ARCH_S5PV210 || ARCH_EXYNOS4
        default OMAP_32K_TIMER_HZ if ARCH_OMAP && OMAP_32K_TIMER
        default AT91_TIMER_HZ if ARCH_AT91
        default SHMOBILE_TIMER_HZ if ARCH_SHMOBILE
        default 100

There is a patch floating around ("ARM: OMAP2+: timer: remove
CONFIG_OMAP_32K_TIMER")
which modifies the OMAP line, so I'll ignore that for my below
example, and I saw a patch for adding Exynos5 processors to the top
default somewhere around here.

So, based on those getting in, in my case here, I can see a situation where;

* I build multiplatform for i.MX6 and Exynos4/5 ARCH_MULTIPLATFORM, I
will get CONFIG_HZ=200.

* If I built for just i.MX6, I will get CONFIG_HZ=100.

Either way, if I boot a kernel on i.MX6, CONFIG_HZ depends on the
other ARM platforms I also want to boot on it.. this is not exactly
multiplatform compliant, right?

In fact, if I want any other value without meeting any of the other
defaults I am *forced* to have a CONFIG_HZ value of 100 (running
oldconfig will set any value back to this), because none of the
standard (100/300/1000 as I see on x86 and PPC) selection entries or
the override control are present or sourced in the main
arch/arm/Kconfig.

This seems infuriatingly inconsistent - and I am absolutely sure that
the default for Samsung platforms is basically totally unreasonable
(and definitely not multiplatform-aware) behavior in forcing some
default setting.

For AT91 and SHMOBILE, I am not sure at all.. given the need for the
OMAP platform to know what it's timer frequency is, maybe they can be
worked around the same way as the OMAP patch so the dependencies get
removed, but I also don't understand why the actual value CONFIG_HZ
would really matter in these cases (except that it would stop the
kernel trying to check or queue timer events more often than the timer
is capable of running.. surely this is a runtime issue and proper use
of the sched_clock implementation handles this?)

This could in theory be resolved by having the arch-specific Kconfigs
add for example CONFIG_HZ_MY_ARCH (similar to kernel/Kconfig.hz's
CONFIG_HZ_1000 which selects 1000 as the "default") and selecting it
if !ARCH_MULTIPLATFORM, which keeps these special little "my arch is
different to your arch" quirks out of a core configuration file. That
way Exynos-only kernels keep their 200, and AT91 keeps it's.. whatever
that config item resolves to (128 I think), and they would pop up in
the list with 100/300/1000. Also, on ARCH_MULTIPLATFORM kernels, the
default-setting behavior is turned off, so all you'd see is
100/300/1000 and an opportunity to set your own value.

This is, I think, what should be the case - that rather than
"magically" selecting CONFIG_HZ's value, it should be up to the
configurator (individual, maintainer shipping a defconfig,
distribution) of the kernel. And, why not document that "foo" arch
runs better with "CONFIG_HZ_MY_ARCH" and instruct configurators of the
kernel to do the right thing, or pick the average value, or specific
lowest-common-denominator value, instead of forcing the value to the
default for the highest/lowest/random arch that met the dependency of
the "default" directive? The Kconfig system isn't smart enough to
handle this automatically for multiplatform.

Additionally, using kernel/Kconfig.hz is a predicate for enabling
(forced enabling, even) CONFIG_SCHED_HRTICK which is defined nowhere
else. I don't know how many ARM systems here benefit from this, if
there is a benefit, or what this really means.. if you really have a
high resolution timer (and hrtimers enabled) that would assist the
scheduler this way, is it supposed to make a big difference to the way
the scheduler works for the better or worse? Is this actually
overridden by ARM sched_clock handling or so? Shouldn't there be a
help entry or some documentation for what this option does? I have
CC'd the scheduler maintainers because I'd really like to know what I
am doing here before I venture into putting patches out which could
potentially rip open spacetime and have us all sucked in..

And I guess I have one more question before I do attempt to open that
tear, what really is the effect of CONFIG_HZ vs. CONFIG_NO_HZ vs. ARM
sched_clock, and usage of the new hooks to register a real timer as
ARM delay_timer? I have patches I can modify for upstream that add
both device tree implementation and probing of i.MX highres
clocksources (GPT and EPIT) and registration of sched_clock and delay
timer implementations based on these clocks, but while the code
compiles and seems to work, the ACTUAL effect of these (and the
fundamental requirements for the clocks being used) seems to be
information only in the minds of the people who wrote the code. It's
not that obvious to me what the true effect of using a non-architected
ARM core timer for at least the delay_timer is, and I have some really
odd lpj values and very strange re-calibrations popping out (with
constant rate for the timer, lpj goes down.. when using the
delay_timer implementation, shouldn't lpj be still relative to the
timer rate and NOT cpu frequency?) when using cpufreq on i.MX5 when I
do it, and whether CONFIG_SCHED_HRTICK is a good or bad idea..

Apologies for the insane number of questions here, but fully
appreciative of any answers,

--
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
