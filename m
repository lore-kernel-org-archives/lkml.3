Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbaFCOus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:50:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaFCOur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:50:47 -0400
Date: Tue, 3 Jun 2014 16:50:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Nicolas Pitre <nico@fluxnic.net>,
        Colin Cross <ccross@google.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] clocksource: document some basic timekeeping concepts
Message-ID: <20140603145037.GR30445@twins.programming.kicks-ass.net>
References: <1401793985-17650-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bRe6i2dqfB5QRoX4"
Content-Disposition: inline
In-Reply-To: <1401793985-17650-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bRe6i2dqfB5QRoX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 01:13:05PM +0200, Linus Walleij wrote:
> +Clock events
> +------------
> +
> +Clock events are conceptually orthogonal to clock sources. The same hardware
> +and register range may be used for the clock event, but it is essentially
> +a different thing.
> +
> +You will notice that the clock event device code is based on the same basic
> +idea about translating counters to nanoseconds using mult and shift
> +arithmetics, and you find the same family of helper functions again for
> +assigning these values. The clock event driver does not need a 'mask'
> +attribute however: the system will not try to plan events beyond the time
> +horizon of the clock event.

This bit is missing that events are timers, so these things need to be
able to raise interrupts.

Also, it is beneficial if there is a timer per cpu.

However, clock_events do need to run in the same time 'space' as
clock_sources, which makes it all a little more expensive than one would
hope.

> +sched_clock()
> +-------------
> +
> +In addition to the clock sources and clock events there is a special weak
> +function in the kernel called sched_clock(). This function shall return the
> +number of nanoseconds since the system was started. An architecture may or
> +may not provide an implementation of sched_clock() on its own. If a local
> +implementation is not provided, the system jiffy counter will be used as
> +sched_clock().
> +
> +As the name suggests, sched_clock() is used for scheduling the system,
> +determining the absolute timeslice for a certain process in the CFS scheduler
> +for example. It is also used for printk timestamps when you have selected to
> +include time information in printk for things like bootcharts.
> +
> +Compared to clock sources, sched_clock() has to be very fast: it is called
> +much more often, especially by the scheduler. If you have to do trade-offs
> +between accuracy compared to the clock source, you may sacrifice accuracy
> +for speed in sched_clock(). It however require some of the same basic
> +characteristics as the clock source, i.e. it has to be monotonic.
> +
> +The sched_clock() function may wrap only on unsigned long long boundaries,
> +i.e. after 64 bits. Since this is a nanosecond value this will mean it wraps
> +after circa 585 years. (For most practical systems this means "never".)
> +
> +If an architecture does not provide its own implementation of this function,
> +it will fall back to using jiffies, making its maximum resolution 1/HZ of the
> +jiffy frequency for the architecture. This will affect scheduling accuracy
> +and will likely show up in system benchmarks.
> +
> +The clock driving sched_clock() may stop or reset to zero during system
> +suspend/sleep. This does not matter to the function it serves of scheduling
> +events on the system. However it may result in interesting timestamps in
> +printk().
> +
> +Some architectures may have a limited set of time sources and lack a nice
> +counter to derive a 64-bit nanosecond value, so for example on the ARM
> +architecture, special helper functions have been created to provide a
> +sched_clock() nanosecond base from a 16- or 32-bit counter. Sometimes the
> +same counter that is also used as clock source is used for this purpose.

This part misses the SMP aspect of sched_clock().

so the arch sched_clock() function is allowed to drift between CPUs,
when it has such hardware it must use CONFIG_HAVE_UNSTABLE_SCHED_CLOCK.

Typically for x86 this means we can use the TSC, even on crappy and
broken systems.

So while clock_sources have to be global clocks, which implies some sort
of serialization cost, sched_clock() can be a per-cpu clock without
synchronization.

As of this writing I'm only aware of two architectures that have such
hardware: x86 and ia64.

Furthermore, sched_clock() is assumed to be IRQ and NMI safe, that is,
one should be able to call it from any context and get a 'sane' value.

--bRe6i2dqfB5QRoX4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeC9AAoJEHZH4aRLwOS6gBcP/AzAxT5JB9Gy36a2LrhpoGmG
z8w+Ie4LjelM6UilcxL7UD2GEswTYit0noNMr5X+ZojWhBg/4FV8FTeOeYDvqcO1
nrDQuUirruN/yAi6cNXDC8x/FcVIAeN6xBUNb9BBNa2ugiysT26fOIuxdtgEiH4Q
oCCWxfCbcpJ8ePOlVqRH8zRgnNyJHDQfA7AUjK9knqTTEedEtqGFUwEALhirsyZw
UjDSbNFofDI9+vF04Yt0dd/VoOfTKLQVIDHCdRGOGt73RTakgzP1kj7CVhlGkzl3
+dPHjYc15gh5rq19JF36/oVli660BEa1uE/iYUD9aGnTK+SlrRIL6BP3WHFYXoxJ
FyXV91840ogcHPy/q8V3HjLsJpNBkABj00pcghOef9AjGnORbNmuCRc9VHETyD1Y
BSju/Pk798QAAtGyAnm2Ju1dFwNQu0gaAHmhRR/Ru/taIsdn+EWMa6uF8pW2BpuF
fDuViKSkUQ4PhwUY2gkVst5MdZoTSnTAOJ1P66I4mF1z6dNOV+Ov2izCLghp9qJ9
76oyGjOe7kG0W0YcNprf2X8X00wv6APzFCMx6VadP9Fj3fQhqwBQde5pZn0VDfhw
cqLPMp30Jlc4nbRC/kcUzy1cuja76fGF81OZZpanGhuEO5qPYqZnonwprV3hX8xb
hubcbXtbL7gWktimz/tl
=Gdf4
-----END PGP SIGNATURE-----

--bRe6i2dqfB5QRoX4--
