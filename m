Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaFXRJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:09:22 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:57307 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaFXRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <1403599872-26315-1-git-send-email-linus.walleij@linaro.org>
References: <1403599872-26315-1-git-send-email-linus.walleij@linaro.org>
Date: Tue, 24 Jun 2014 10:09:19 -0700
Message-ID: <CALAqxLVzGLYFQ4iDWEC2AQGjjHV4GRoVASS8Da-7-oBy_m_AYg@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: document some basic timekeeping concepts
From: John Stultz <john.stultz@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nico@fluxnic.net>, Colin Cross <ccross@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 1:51 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
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
>         - Build and link hpet_example
>  NO_HZ.txt
>         - Summary of the different methods for the scheduler clock-interrupts management.
> +timekeeping.txt
> +       - Clock sources, clock events, sched_clock() and delay timer notes
>  timers-howto.txt
>         - how to insert delays in the kernel the right (tm) way.
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
> +It will ideally NEVER stop ticking as long as the system is functional.

Minor nit: its ok if it stops ticking during suspend. With suspend
being a more normal state for a device to be in, "system is
functional" could be confusing here. Maybe "system is running" might
be slightly more clear (but not much, I admit).

> +
> +The clock source shall have as high resolution as possible, and shall be as

maybe "and the frequency shall be as stable and correct"

> +stable and correct as possible as compared to a real-world wall clock. It
> +should not move unpredictably back and forth in time or miss a few cycles
> +here and there.
> +
> +It must be immune to the kind of effects that occur in hardware where e.g.
> +the counter register is read in two phases on the bus lowest 16 bits first
> +and the higher 16 bits in a second bus cycle with the counter bits
> +potentially being updated inbetween leading to the risk of very strange
> +values from the counter.
> +
> +When the wall-clock accuracy of the clock source isn't satisfactory, there
> +are various quirks and layers in the timekeeping code for e.g. synchronizing
> +the user-visible time to RTC clocks in the system or against networked time
> +servers using NTP, but all they do is basically to update an offset against
> +the clock source, which provides the fundamental timeline for the system.
> +These measures does not affect the clock source per se, they only adapt the
> +system to the shortcomings of it.
> +
> +The clock source struct shall provide means to translate the provided counter
> +into a rough nanosecond value as an unsigned long long (unsigned 64 bit) number.

Maybe removing "rough" would good here. As it needs to be accurate.

> +Since this operation may be invoked very often, doing this in a strict
> +mathematical sense is not desireable: instead the number is taken as close as
> +possible to a nanosecond value using only the arithmetic operations
> +mult and shift, so in clocksource_cyc2ns() you find:
> +
> +  ns ~= (clocksource * mult) >> shift
> +
> +You will find a number of helper functions in the clock source code intended
> +to aid in providing these mult and shift values, such as
> +clocksource_khz2mult(), clocksource_hz2mult() that help determinining the
> +mult factor from a fixed shift, and clocksource_calc_mult_shift() and
> +clocksource_register_hz() which will help out assigning both shift and mult
> +factors using the frequency of the clock source and desirable minimum idle
> +time as the only input.

I'd suggest maybe only focusing on clocksource_register_hz/khz() here,
as we really would rather not have the clocksource determining its own
mult/shift values since these values can affect the longest idle time
as well as the granularity of ntp correction. The system will try to
balance these properly if you use the register functions.

(Personally, I'd like to eventually get the mult/shift moved out of
the clocksource driver and instead keep those values in each subsystem
that uses the clocksource - much as how the timekeeping code keeps its
own mult/shift copy for a clocksource). This would make it easier for
sched_clock to have a different choice then the timekeeping code for
its selection.


> +For real simple clock sources accessed from a single I/O memory location
> +there is nowadays even clocksource_mmio_init() which will take a memory
> +location, bit width, a parameter telling whether the counter in the
> +register counts up or down, and the timer clock rate, and then conjure all
> +necessary parameters.
> +
> +In the past, the timekeeping authors would come up with the shift and mult
> +values by hand, which is why you will sometimes find hard-coded shift and
> +mult values in the code.

I think I got rid of static assignment in all but the S390 and jiffies
clocksources (and those I have to keep since they are default boot
clocksources, which have to function before the normal registration
logic runs). So this might be able to be dropped here...


> +Since a 32 bit counter at say 100 MHz will wrap around to zero after some 43
> +seconds, the code handling the clock source will have to compensate for this.
> +That is the reason to why the clock source struct also contains a 'mask'
> +member telling how many bits of the source are valid. This way the timekeeping
> +code knows when the counter will wrap around and can insert the necessary
> +compensation code on both sides of the wrap point so that the system timeline
> +remains monotonic.


Overall looks good!

> +
> +
> +Clock events
> +------------
> +
> +Clock events are conceptually orthogonal to clock sources. The same hardware
> +and register range may be used for the clock event, but it is essentially
> +a different thing. The hardware driving clock events have to be able to
> +fire interrupts, so as to trigger events on the system timeline. On a SMP
> +system, it is ideal (and custom) to have one such event driving timer per
> +CPU core, so that each core can trigger events independently of any other
> +core.
> +
> +You will notice that the clock event device code is based on the same basic
> +idea about translating counters to nanoseconds using mult and shift

You might note that the clockevents code is usually focused in the
reverse direction of the clocksource code, usually taking time values
and calculating the correlating counter value where we want the
interrupt to fire.


Otherwise looks great to me! Sorry for not reviewing this earlier.

thanks
-john
