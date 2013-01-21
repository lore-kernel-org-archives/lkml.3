Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab3AUXX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:23:56 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53198 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3AUXXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:23:54 -0500
MIME-Version: 1.0
In-Reply-To: <20130121224252.GY23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
 <20130121211218.GX23505@n2100.arm.linux.org.uk> <CAKGA1bkZ4sN_eXAk1nUzvGE6cvvQ+b+jnTezTM863qFNL8NqWg@mail.gmail.com>
 <20130121224252.GY23505@n2100.arm.linux.org.uk>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 17:23:33 -0600
Message-ID: <CAKGA1b=AG_a=KCi6qoeoRoG+5bcYkn3gAVb4S2dbaFzu4ioJdQ@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 4:42 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jan 21, 2013 at 04:20:14PM -0600, Matt Sealey wrote:
>> I am sorry it sounded if I was being high and mighty about not being
>> able to select my own HZ (or being forced by Exynos to be 200 or by
>> not being able to test an Exynos board, forced to default to 100). My
>> real "grievance" here is we got a configuration item for the scheduler
>> which is being left out of ARM configurations which *can* use high
>> resolution timers, but I don't know if this is a real problem or not,
>> hence asking about it, and that HZ=100 is the ARM default whether we
>> might be able to select that or not.. which seems low.
>
> Well, I have a versatile platform here.  It's the inteligence behind
> the power control system for booting the boards on the nightly tests
> (currently disabled because I'm waiting for my main server to lock up
> again, and I need to use one of the serial ports for that.)
>
> The point is, it talks via I2C to a load of power monitors to read
> samples out.  It does this at sub-100Hz intervals.  Yet the kernel is
> built with HZ=100.  NO_HZ=y and highres timers are enabled... works
> fine.
>
> So, no, HZ=100 is not a limit in that scenario.  With NO_HZ=y and
> highres timers, it all works with epoll() - you get the interval that
> you're after.  I've verified this with calls to gettimeofday() and
> the POSIX clocks.

Okay.

So, can you read this (it's short):

http://ck.kolivas.org/patches/bfs/bfs-configuration-faq.txt

And please tell me if he's batshit crazy and I should completely
ignore any scheduler discussion that isn't ARM-specific, or maybe..
and I can almost guarantee this, he doesn't have an ARM platform so
he's just delightfully ill-informed about anything but his quad-core
x86?

>> HZ=250 is the "current" kernel default if you don't touch anything, it
>> seems, apologies for thinking it was HZ=100.
>
> Actually, it always used to be 100Hz on everything, including x86.
> It got upped when there were interactivity issues... which haven't
> been reported on ARM - so why change something that we know works and
> everyone is happy with?

I don't know. I guess this is why I included Ingo and Peter as they
seem to be responsible for core HZ-related things; why have HZ=250 on
x86 when CONFIG_NO_HZ and HZ=100 would work just as effectively? Isn't
CONFIG_NO_HZ the default on x86 and PPC and.. pretty much everything
else?

I know Con K. has been accused many times of peddling snake-oil... but
he has pretty graphs and benchmarks that kind of bear him out on most
things even if the results do not get his work upstream. I can't fault
the statistical significance of his results.. but even a placebo
effect can be graphed, correlation is not causation, etc, etc. - I
don't know if anything real filters down into the documentation
though.

>> And that is too high for
>> EBSA110 and a couple of other boards, especially where HZ must equal
>> some exact divisor being pumped right into some timer unit.
>
> EBSA110 can do 250Hz, but it'll mean manually recalculating the timer
> arithmetic - because it's not a "reloading" counter - software has to
> manually reload it, and you have to take account of how far it's
> rolled over to get anything close to a regular interrupt rate which
> NTP is happy with.  And believe me, it used to be one of two main NTP
> broadcasting servers on my network, so I know it works.

A-ha...

>> Anyway, a patch for ARM could perhaps end up like this:
>>
>> ~~
>> if ARCH_MULTIPLATFORM
>> source kernel/Kconfig.hz
>> else
>> HZ
>>     default 100
>> endif
>>
>> HZ
>>     default 200 if ARCH_EBSA110 || ARCH_ETC_ETC || ARCH_UND_SO_WEITER
>>     # any previous platform definitions where *really* required here.
>>     # but not default 100 since it would override kernel/Kconfig.hz every time
>
> That doesn't work - if you define the same symbol twice, one definition
> takes priority over the other (I don't remember which way it works).
> They don't accumulate.

Well I did some testing.. a couple days of poking around, and they
don't need to accumulate.

> Because... it simply doesn't work like that.  Try it and check to see
> what Kconfig produces.

I did test it.. whatever you define last, sticks, and it's down to the
order they're parsed in the tree - luckily, arch/arm/Kconfig is
sourced first, which sources the mach/plat stuff way down at  the
bottom. As long as you have your "default" set somewhere, any further
default just has to be sourced or added later in *one* of the
Kconfigs, same as building any C file with "gcc -E" and spitting it
out.

Someone, at the end of it all, has to set some default, and as long as
the one you want is the last one, everything is shiny.

> We know this, because our FRAME_POINTER config overrides the generic
> one - not partially, but totally and utterly in every way.

But for something as simple as CONFIG_HZ getting a value.. it works
okay. If Kconfig.hz sets CONFIG_HZ=250 because CONFIG_HZ_250 is
default yes, and it CONFIG_HZ defaults to 250 if it's set, and then
you put

HZ
   default 100

Right after it, or right after it's source in arch/x86/Kconfig, or
whatever, that "default" is what sticks and what ends up in CONFIG_HZ
in the local .config.

> I just don't see how that's remotely possible.

Maybe I tested it wrong, you'd know better than I exactly how (and I
would appreciate knowing how so I can go back and test it again :)

--
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
