Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3AUW0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:26:04 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:49576 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab3AUW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:26:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130121211218.GX23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <20130121211218.GX23505@n2100.arm.linux.org.uk>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 16:20:14 -0600
Message-ID: <CAKGA1bkZ4sN_eXAk1nUzvGE6cvvQ+b+jnTezTM863qFNL8NqWg@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Ben Dooks <ben@simtec.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 3:12 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jan 21, 2013 at 01:00:15PM -0800, John Stultz wrote:
>> So if you can not get actual timer ticks any faster then 200 HZ on that
>> hardware, setting HZ higher could cause some jiffies related timer
>> trouble
>
> Err, no John.  It's the other way around - especially on some platforms
> which are incapable of being converted to the clock source support.
>
> EBSA110 has _one_ counter.  It counts down at a certain rate, and when
> it rolls over from 0 to FFFF, it produces an interrupt and continues
> counting down from FFFF.
>
> To produce anything close to a reasonable regular tick rate from that,
> the only way to do it is - with interrupts disabled - read the current
> value to find out how far the timer has rolled over, and set it so that
> the next event will expire as close as possible to the desired HZ rate.
>
> So, none of the clcokevent stuff can be used; and we rely _purely_ on
> counting interrupts in jiffy based increments to provide any reference
> of time.
>
> Moreover, because the counter is only 16-bit, and it's clocked from
> something around 7MHz, well, maths will tell you why 200Hz had to be
> chosen rather than 100Hz.

I am sorry it sounded if I was being high and mighty about not being
able to select my own HZ (or being forced by Exynos to be 200 or by
not being able to test an Exynos board, forced to default to 100). My
real "grievance" here is we got a configuration item for the scheduler
which is being left out of ARM configurations which *can* use high
resolution timers, but I don't know if this is a real problem or not,
hence asking about it, and that HZ=100 is the ARM default whether we
might be able to select that or not.. which seems low.

HZ=250 is the "current" kernel default if you don't touch anything, it
seems, apologies for thinking it was HZ=100. And that is too high for
EBSA110 and a couple of other boards, especially where HZ must equal
some exact divisor being pumped right into some timer unit.
Understood. Surely the correct divisor should be *derived* from HZ and
not just dumped into the timer though, so HZ being set to an exact
divisor (but a round-down-to-acceptable-value) is kind of a hacky
concept..?

For the global kernel guys, I'd ask what is the reasoning for using
HZ=250 by default, I wonder? It seems like this number is from the
dark ages (pre-git, pre-bitkeeper, maybe pre-recorded history ;) and
the reason is lost. Why not HZ=100 or HZ=300 (if the help text is to
be believed, and it is probably older than God, HZ=300 is great for
playing back NTSC-format video.. :)? I can side with you on the
premise that in actual fact, defining a default HZ value in the
non-arch-specific kernel proper is a little quirky and it should be
something the arches do themselves (i.e. move the default-setting
stuff at the end into the arch/*/Kconfig - I would expect that now
i386 CPU support is gone from arch/x86, there's potentially a better
value than HZ=250 for the default?).

Anyway, a patch for ARM could perhaps end up like this:

~~
if ARCH_MULTIPLATFORM
source kernel/Kconfig.hz
else
HZ
    default 100
endif

HZ
    default 200 if ARCH_EBSA110 || ARCH_ETC_ETC || ARCH_UND_SO_WEITER
    # any previous platform definitions where *really* required here.
    # but not default 100 since it would override kernel/Kconfig.hz every time
~~

Which preserves all previous behaviors on all possible ARM arch
combinations, but where no reasonable override is set.. Kconfig.hz is
king. I cannot imagine any situation except for AT91 or OMAP could not
do this in their own {mach,plat}-*/Kconfigs and not in the core
config, which cleans up the extra HZ block.

We can agree that the "default 200 if.." list is unwieldy and Arnd is
right in that there is some cargo-cult programming going on here,
right?

Even if we assume EBSA110 and a couple others are really affected by
having such timer setups, therefore "reasonable", I'd challenge anyone
to tell me Exynos4 or the S5P platforms do not have high resolution
timers capable of handling more than HZ=200 (or the default HZ=250)
which I would class as "unreasonable".. this is why I said it was
possibly both. I am not one to judge some of these platforms I've
never even heard of, that is why I am *asking* about it before I even
think of doing anything about it.

I tested this a few weeks ago with a *few* defconfigs (by sourcing
Kconfig.hz above the existing HZ definitions) and it does effectively
override the value I went in and stabbed into menuconfig, in the
resultant generated local .config file - if they themselves are
sourced AFTER the source kernel/Kconfig.hz (which they pretty much
are) in arch/arm/Kconfig.

Could we also at least agree that if EBSA110 can handle HZ=200 with a
16-bit timer, or HZ=128 for OMAP and that AT91 will override it to 100
on it's own, then that "default 100" is overly restrictive and we
could remove it, allowing each {mach,plat}-*/Kconfig owner to
investigate and find the correct HZ value and implement an override or
selection, or just allow free configuration?

As far as I can tell AT91 and SHMOBILE only supply defaults because HZ
*must* meet some exact timer divisor (OMAP says "Kernel internal timer
frequency should be a divisor of 32768") in which case their timer
drivers should not be so stupid and instead round down to the nearest
acceptable timer divisor or WARN_ON if the compile-time values are
unacceptable at runtime before anyone sees any freakish behavior. Is
it a hard requirement for the ARM architecture that a woefully
mis-configured kernel MUST boot completely to userspace?

--
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
