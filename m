Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbaFZRwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:52:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaFZRwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:52:53 -0400
Message-ID: <53AC5DF2.4090807@infradead.org>
Date: Thu, 26 Jun 2014 10:52:50 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
CC: Nicolas Pitre <nico@fluxnic.net>, Colin Cross <ccross@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] clocksource: document some basic timekeeping concepts
References: <1403599872-26315-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1403599872-26315-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/14 01:51, Linus Walleij wrote:
> This adds some documentation about clock sources, clock events,
> the weak sched_clock() function and delay timers that answers
> questions that repeatedly arise on the mailing lists.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Colin Cross <ccross@google.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Included paragraphs and minor edits to account for PeterZ's
>   comments on addressing SMP use cases, which makes especially
>   the semantics of sched_clock() much clearer.
> ---
>  Documentation/timers/00-INDEX        |   2 +
>  Documentation/timers/timekeeping.txt | 179 +++++++++++++++++++++++++++++++++++
>  2 files changed, 181 insertions(+)
>  create mode 100644 Documentation/timers/timekeeping.txt
> 
> diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
> index 6d042dc1cce0..ee212a27772f 100644
> --- a/Documentation/timers/00-INDEX
> +++ b/Documentation/timers/00-INDEX
> @@ -12,6 +12,8 @@ Makefile
>  	- Build and link hpet_example
>  NO_HZ.txt
>  	- Summary of the different methods for the scheduler clock-interrupts management.
> +timekeeping.txt
> +	- Clock sources, clock events, sched_clock() and delay timer notes
>  timers-howto.txt
>  	- how to insert delays in the kernel the right (tm) way.
>  timer_stats.txt
> diff --git a/Documentation/timers/timekeeping.txt b/Documentation/timers/timekeeping.txt
> new file mode 100644
> index 000000000000..89ff5c39edcc
> --- /dev/null
> +++ b/Documentation/timers/timekeeping.txt
> @@ -0,0 +1,179 @@
> +Clock sources, Clock events, sched_clock() and delay timers
> +-----------------------------------------------------------
> +
> +This document tries to briefly explain some basic kernel timekeeping
> +abstractions. It partly pertains to the drivers usually found in
> +drivers/clocksource in the kernel tree, but the code may be spread out
> +across the kernel.
> +
> +If you grep through the kernel source you will find a number of architecture-
> +specific implementations of clock sources, clockevents and several likewise
> +architecture-specific overrides of the sched_clock() function and some
> +delay timers.
> +
> +To provide timekeeping for your platform, the clock source provides
> +the basic timeline, whereas clock events shoot interrupts on certain points
> +on this timeline, providing facilities such as high-resolution timers.
> +sched_clock() is used for scheduling and timestamping, and delay timers
> +provide an accurate delay source using hardware counters.
> +
> +
> +Clock sources
> +-------------
> +
> +The purpose of the clock source is to provide a timeline for the system that
> +tells you where you are in time. For example issuing the command 'date' on
> +a Linux system will eventually read the clock source to determine exactly
> +what time it is.
> +
> +Typically the clock source is a monotonic, atomic counter which will provide
> +n bits which count from 0 to 2^(n-1) and then wraps around to 0 and start over.

                                                                       starts over.

> +It will ideally NEVER stop ticking as long as the system is functional.
> +
> +The clock source shall have as high resolution as possible, and shall be as
> +stable and correct as possible as compared to a real-world wall clock. It
> +should not move unpredictably back and forth in time or miss a few cycles
> +here and there.
> +
> +It must be immune to the kind of effects that occur in hardware where e.g.
> +the counter register is read in two phases on the bus lowest 16 bits first

                                                     bus, lower

> +and the higher 16 bits in a second bus cycle with the counter bits
> +potentially being updated inbetween leading to the risk of very strange

                             in between,
[I did find one source for "in-between" if you would prefer that.]

> +values from the counter.
> +
> +When the wall-clock accuracy of the clock source isn't satisfactory, there
> +are various quirks and layers in the timekeeping code for e.g. synchronizing
> +the user-visible time to RTC clocks in the system or against networked time
> +servers using NTP, but all they do is basically to update an offset against

                      but all they do basically is update an offset

> +the clock source, which provides the fundamental timeline for the system.
> +These measures does not affect the clock source per se, they only adapt the
> +system to the shortcomings of it.
> +
> +The clock source struct shall provide means to translate the provided counter
> +into a rough nanosecond value as an unsigned long long (unsigned 64 bit) number.
> +Since this operation may be invoked very often, doing this in a strict
> +mathematical sense is not desireable: instead the number is taken as close as

                             desirable:

> +possible to a nanosecond value using only the arithmetic operations
> +mult and shift, so in clocksource_cyc2ns() you find:

   multiply

> +
> +  ns ~= (clocksource * mult) >> shift
> +
> +You will find a number of helper functions in the clock source code intended
> +to aid in providing these mult and shift values, such as
> +clocksource_khz2mult(), clocksource_hz2mult() that help determinining the

preferred:                                       that help determine
or
                                                 that help in determining

> +mult factor from a fixed shift, and clocksource_calc_mult_shift() and
> +clocksource_register_hz() which will help out assigning both shift and mult
> +factors using the frequency of the clock source and desirable minimum idle
> +time as the only input.
> +
> +For real simple clock sources accessed from a single I/O memory location
> +there is nowadays even clocksource_mmio_init() which will take a memory
> +location, bit width, a parameter telling whether the counter in the
> +register counts up or down, and the timer clock rate, and then conjure all
> +necessary parameters.
> +
> +In the past, the timekeeping authors would come up with the shift and mult
> +values by hand, which is why you will sometimes find hard-coded shift and
> +mult values in the code.
> +
> +Since a 32 bit counter at say 100 MHz will wrap around to zero after some 43

           32-bit

> +seconds, the code handling the clock source will have to compensate for this.
> +That is the reason to why the clock source struct also contains a 'mask'

               reason why

> +member telling how many bits of the source are valid. This way the timekeeping
> +code knows when the counter will wrap around and can insert the necessary
> +compensation code on both sides of the wrap point so that the system timeline
> +remains monotonic.
> +
> +
> +Clock events
> +------------
> +
> +Clock events are conceptually orthogonal to clock sources. The same hardware
> +and register range may be used for the clock event, but it is essentially
> +a different thing. The hardware driving clock events have to be able to

                                                        has

> +fire interrupts, so as to trigger events on the system timeline. On a SMP

                                                                       an SMP

> +system, it is ideal (and custom) to have one such event driving timer per

           I like Peter's   customary    here.

> +CPU core, so that each core can trigger events independently of any other
> +core.
> +
> +You will notice that the clock event device code is based on the same basic
> +idea about translating counters to nanoseconds using mult and shift
> +arithmetics, and you find the same family of helper functions again for

I would say "arithmetic", but I see some Europeans adding the 's' to it,
so either way must be OK.

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

                                          requires

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
> +
> +
> +Delay timers (some architectures only)
> +--------------------------------------
> +
> +On systems with variable CPU frequency, the various kernel delay() function

                                                                      functions

> +will sometimes behave strangely. Basically these delays usually use a hard
> +loop to delay a certain number of jiffy fractions using a "lpj" (loops per
> +jiffy) value, calibrated on boot.
> +
> +Let's hope that your system is running on maximum frequency when this value
> +is calibrated: as an effect when the frequency is geared down to half the
> +full frequency, any delay() will be twice as long. Usually this does not
> +hurt, as you're commonly requesting that amount of delay *or more*. But
> +basically the sematics are quite unpredictable on such systems.

                 semantics

> +
> +Enter timer-based delays. Using these, a timer read may be used instead of
> +a hard-coded loop for providing the desired delay.
> +
> +This is done by declaring a struct delay_timer and assigning the apropriate

                                                                    appropriate

> +function pointers and rate settings for this delay timer.
> +
> +This is available on some architectures like OpenRISC or ARM.
> 


-- 
~Randy
