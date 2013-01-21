Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3AUXtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:49:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51761 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3AUXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:49:24 -0500
Date: Mon, 21 Jan 2013 23:49:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Sealey <matt@genesi-usa.com>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121234908.GD23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <20130121211218.GX23505@n2100.arm.linux.org.uk> <CAKGA1bkZ4sN_eXAk1nUzvGE6cvvQ+b+jnTezTM863qFNL8NqWg@mail.gmail.com> <20130121224252.GY23505@n2100.arm.linux.org.uk> <CAKGA1b=AG_a=KCi6qoeoRoG+5bcYkn3gAVb4S2dbaFzu4ioJdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1b=AG_a=KCi6qoeoRoG+5bcYkn3gAVb4S2dbaFzu4ioJdQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 05:23:33PM -0600, Matt Sealey wrote:
> On Mon, Jan 21, 2013 at 4:42 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Jan 21, 2013 at 04:20:14PM -0600, Matt Sealey wrote:
> >> I am sorry it sounded if I was being high and mighty about not being
> >> able to select my own HZ (or being forced by Exynos to be 200 or by
> >> not being able to test an Exynos board, forced to default to 100). My
> >> real "grievance" here is we got a configuration item for the scheduler
> >> which is being left out of ARM configurations which *can* use high
> >> resolution timers, but I don't know if this is a real problem or not,
> >> hence asking about it, and that HZ=100 is the ARM default whether we
> >> might be able to select that or not.. which seems low.
> >
> > Well, I have a versatile platform here.  It's the inteligence behind
> > the power control system for booting the boards on the nightly tests
> > (currently disabled because I'm waiting for my main server to lock up
> > again, and I need to use one of the serial ports for that.)
> >
> > The point is, it talks via I2C to a load of power monitors to read
> > samples out.  It does this at sub-100Hz intervals.  Yet the kernel is
> > built with HZ=100.  NO_HZ=y and highres timers are enabled... works
> > fine.
> >
> > So, no, HZ=100 is not a limit in that scenario.  With NO_HZ=y and
> > highres timers, it all works with epoll() - you get the interval that
> > you're after.  I've verified this with calls to gettimeofday() and
> > the POSIX clocks.
> 
> Okay.
> 
> So, can you read this (it's short):
> 
> http://ck.kolivas.org/patches/bfs/bfs-configuration-faq.txt
> 
> And please tell me if he's batshit crazy and I should completely
> ignore any scheduler discussion that isn't ARM-specific, or maybe..
> and I can almost guarantee this, he doesn't have an ARM platform so
> he's just delightfully ill-informed about anything but his quad-core
> x86?

Well... my x86 laptop is... HZ=1000, NO_HZ, HIGH_RES enabled, ondemand...
doesn't really fit into any of those categories given there.  I'd suggest
that what's given there is a suggestion/opinion based on behaviours
observed on x86 platforms.

Whether it's appropriate for other architectures is not really a proven
point - is it worth running ARM at 1000Hz when the load from running at
100Hz is measurable as a definite error in loops_per_jiffy calibration?
Remember - the load from the interrupt handler at 1000Hz is 10x the load
at 100Hz.

Do you want to spend more cycles per second on the possibly multi-layer
IRQ servicing and timer servicing?

And what about the interrupt latency issue that we've hit several times
already with devices taking longer than 10ms to service their peripherals
because the driver doesn't make use of delayed works/tasklets/etc.

The lack of reasonable device DMA too has an impact for many drivers - the
CPU has to spend more time in interrupt handlers (which are now run to the
exclusion of any other interrupt in the system) performing PIO - or in the
case of those systems which _do_ have DMA, they may end up having to do
cache maintanence over large cache ranges from IRQ context which x86
doesn't have to do.

There's many factors here, and the choice of what the right HZ is for a
platform is not as clear cut as one may think.  Given all the additional
overheads we have on ARM because of the lack of memory coherency, the
generally bad DMA support, etc, I think what we currently have is still
right as an architecture default - 100Hz.

> I did test it.. whatever you define last, sticks, and it's down to the
> order they're parsed in the tree - luckily, arch/arm/Kconfig is
> sourced first, which sources the mach/plat stuff way down at  the
> bottom. As long as you have your "default" set somewhere, any further
> default just has to be sourced or added later in *one* of the
> Kconfigs, same as building any C file with "gcc -E" and spitting it
> out.
> 
> Someone, at the end of it all, has to set some default, and as long as
> the one you want is the last one, everything is shiny.

Actually, we're both wrong.  There seems to be two things which
inflence it, and it basically comes down to this:

- the value a particular symbol has comes from the _first_ declaration
  which a value is assigned to a symbol.

So:

config HZ
        int
        default 300

config HZ
        int
        default 100 if OPT1
        default 200 if OPT2
        default 400

takes on the value of 300 no matter what combination of OPT1 and OPT2
are enabled.

config HZ
        int
        default 100 if OPT1
        default 200 if OPT2
        default 400
           
config HZ
        int
        default 300

never takes the value 300, but 100, 200 or 400.

config HZ
        int
        default 100 if OPT1
        default 200 if OPT2
           
config HZ
        int
        default 300

Will now take 100, 200, or 300 depending on which of OPT1/OPT2 are enabled.

So, we _can_ use kernel/Kconfig.hz, but it's not very nice at all: we will
be presenting users with configutation options for the HZ value which will
be _silently_ ignored by Kconfig if we have a platform which overrides this.

Probably fine if you think that Kconfig is a developers tool and you edit
the configuration files (and therefore you expect them to know what they're
doing, and how this stuff works), but not if you think that Kconfig users
should be presented with meaningful options when configuring their kernel.
