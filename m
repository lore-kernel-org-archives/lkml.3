Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaFXKh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:37:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:52126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaFXKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:37:54 -0400
Date: Tue, 24 Jun 2014 12:37:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Nicolas Pitre <nico@fluxnic.net>,
        Colin Cross <ccross@google.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] clocksource: document some basic timekeeping concepts
Message-ID: <20140624103751.GJ19860@laptop.programming.kicks-ass.net>
References: <1403599872-26315-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403599872-26315-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:51:12AM +0200, Linus Walleij wrote:
> +Clock events
> +------------
> +
> +Clock events are conceptually orthogonal to clock sources. The same hardware
> +and register range may be used for the clock event, but it is essentially
> +a different thing. The hardware driving clock events have to be able to
> +fire interrupts, so as to trigger events on the system timeline. On a SMP
> +system, it is ideal (and custom) to have one such event driving timer per

customary?

> +CPU core, so that each core can trigger events independently of any other
> +core.
> +
> +You will notice that the clock event device code is based on the same basic
> +idea about translating counters to nanoseconds using mult and shift
> +arithmetics, and you find the same family of helper functions again for
> +assigning these values. The clock event driver does not need a 'mask'
> +attribute however: the system will not try to plan events beyond the time
> +horizon of the clock event.
> +
> +
> +sched_clock()
> +-------------
> +
> +In addition to the clock sources and clock events there is a special weak
> +function in the kernel called sched_clock(). This function shall return the
> +number of nanoseconds since the system was started. 

Strictly speaking the scheduler doesn't care about the 0 offset; but as
you mention below, printk() uses this time and people tend to notice and
complain if its not 0 at boot.

> An architecture may or
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

We can deal with the occasional weirdness; but yes, we very much prefer
a strictly monotonic clock.

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

Right, on x86 we explicitly save/restore the offset to compensate for
this.

> +The sched_clock() function should be callable in any context, IRQ- and
> +NMI-safe and return a sane value in any context.
> +
> +Some architectures may have a limited set of time sources and lack a nice
> +counter to derive a 64-bit nanosecond value, so for example on the ARM
> +architecture, special helper functions have been created to provide a
> +sched_clock() nanosecond base from a 16- or 32-bit counter. Sometimes the
> +same counter that is also used as clock source is used for this purpose.
> +
> +On SMP systems, it is crucial for performance that sched_clock() can be called
> +independently on each CPU without any synchronization performance hits.
> +Some hardware (such as the x86 TSC) will cause the sched_clock() function to
> +drift between the CPUs on the system. The kernel can work around this by
> +enabling the CONFIG_HAVE_UNSTABLE_SCHED_CLOCK option. This is another aspect
> +that makes sched_clock() different from the ordinary clock source.


Other than that this version does look good.

Thanks for doing this.

