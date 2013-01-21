Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3AUWsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:48:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51700 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3AUWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:48:08 -0500
Date: Mon, 21 Jan 2013 22:42:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Sealey <matt@genesi-usa.com>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121224252.GY23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <20130121211218.GX23505@n2100.arm.linux.org.uk> <CAKGA1bkZ4sN_eXAk1nUzvGE6cvvQ+b+jnTezTM863qFNL8NqWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bkZ4sN_eXAk1nUzvGE6cvvQ+b+jnTezTM863qFNL8NqWg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 04:20:14PM -0600, Matt Sealey wrote:
> I am sorry it sounded if I was being high and mighty about not being
> able to select my own HZ (or being forced by Exynos to be 200 or by
> not being able to test an Exynos board, forced to default to 100). My
> real "grievance" here is we got a configuration item for the scheduler
> which is being left out of ARM configurations which *can* use high
> resolution timers, but I don't know if this is a real problem or not,
> hence asking about it, and that HZ=100 is the ARM default whether we
> might be able to select that or not.. which seems low.

Well, I have a versatile platform here.  It's the inteligence behind
the power control system for booting the boards on the nightly tests
(currently disabled because I'm waiting for my main server to lock up
again, and I need to use one of the serial ports for that.)

The point is, it talks via I2C to a load of power monitors to read
samples out.  It does this at sub-100Hz intervals.  Yet the kernel is
built with HZ=100.  NO_HZ=y and highres timers are enabled... works
fine.

So, no, HZ=100 is not a limit in that scenario.  With NO_HZ=y and
highres timers, it all works with epoll() - you get the interval that
you're after.  I've verified this with calls to gettimeofday() and
the POSIX clocks.

> HZ=250 is the "current" kernel default if you don't touch anything, it
> seems, apologies for thinking it was HZ=100.

Actually, it always used to be 100Hz on everything, including x86.
It got upped when there were interactivity issues... which haven't
been reported on ARM - so why change something that we know works and
everyone is happy with?

> And that is too high for
> EBSA110 and a couple of other boards, especially where HZ must equal
> some exact divisor being pumped right into some timer unit.

EBSA110 can do 250Hz, but it'll mean manually recalculating the timer
arithmetic - because it's not a "reloading" counter - software has to
manually reload it, and you have to take account of how far it's
rolled over to get anything close to a regular interrupt rate which
NTP is happy with.  And believe me, it used to be one of two main NTP
broadcasting servers on my network, so I know it works.

> Understood. Surely the correct divisor should be *derived* from HZ and
> not just dumped into the timer though, so HZ being set to an exact
> divisor (but a round-down-to-acceptable-value) is kind of a hacky
> concept..?

No.  See above.  It's not a simple bit of maths.  You need to know how
fast the CPU runs, and how many instructions it takes to read the
current value, modify it, write it back and factor that into the
calculation.  Get it wrong - by even as little as one count - and the
error is too large, and NTP fails to sync.

> For the global kernel guys, I'd ask what is the reasoning for using
> HZ=250 by default, I wonder? It seems like this number is from the
> dark ages (pre-git, pre-bitkeeper, maybe pre-recorded history ;) and
> the reason is lost. Why not HZ=100 or HZ=300 (if the help text is to
> be believed, and it is probably older than God, HZ=300 is great for
> playing back NTSC-format video.. :)? I can side with you on the
> premise that in actual fact, defining a default HZ value in the
> non-arch-specific kernel proper is a little quirky and it should be
> something the arches do themselves (i.e. move the default-setting
> stuff at the end into the arch/*/Kconfig - I would expect that now
> i386 CPU support is gone from arch/x86, there's potentially a better
> value than HZ=250 for the default?).

>From what I remember, the history is that HZ used to be 100.  Then it
became 1000 as an experiment to do with desktop interactivity.  That
was found to be too heavy, so it was then dropped by a factor of 4 as
a compromise.

That's why kernel/Kconfig.hz has 100, 250 and 1000 - those are the
values which were tried on x86 many years ago.

> 
> Anyway, a patch for ARM could perhaps end up like this:
> 
> ~~
> if ARCH_MULTIPLATFORM
> source kernel/Kconfig.hz
> else
> HZ
>     default 100
> endif
> 
> HZ
>     default 200 if ARCH_EBSA110 || ARCH_ETC_ETC || ARCH_UND_SO_WEITER
>     # any previous platform definitions where *really* required here.
>     # but not default 100 since it would override kernel/Kconfig.hz every time

That doesn't work - if you define the same symbol twice, one definition
takes priority over the other (I don't remember which way it works).
They don't accumulate.

> Which preserves all previous behaviors on all possible ARM arch
> combinations, but where no reasonable override is set.. Kconfig.hz is
> king. I cannot imagine any situation except for AT91 or OMAP could not
> do this in their own {mach,plat}-*/Kconfigs and not in the core
> config, which cleans up the extra HZ block.

Because... it simply doesn't work like that.  Try it and check to see
what Kconfig produces.

We know this, because our FRAME_POINTER config overrides the generic
one - not partially, but totally and utterly in every way.

> Could we also at least agree that if EBSA110 can handle HZ=200 with a
> 16-bit timer, or HZ=128 for OMAP and that AT91 will override it to 100
> on it's own, then that "default 100" is overly restrictive and we
> could remove it, allowing each {mach,plat}-*/Kconfig owner to
> investigate and find the correct HZ value and implement an override or
> selection, or just allow free configuration?

I just don't see how that's remotely possible.
