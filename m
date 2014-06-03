Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaFCLNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:13:17 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44224 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaFCLNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:13:16 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Nicolas Pitre <nico@fluxnic.net>,
        Colin Cross <ccross@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] clocksource: document some basic timekeeping concepts
Date: Tue,  3 Jun 2014 13:13:05 +0200
Message-Id: <1401793985-17650-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds some documentation about clock sources, clock events,
the weak sched_clock() function and delay timers that answers
questions that repeatedly arise on the mailing lists.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Colin Cross <ccross@google.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Began writing this documentation years ago, literally, posted,
fixed comments, then left it on a branch idling for kernel release
after kernel release. Let's just get this in shape, it's
information that people need.
---
 Documentation/timers/00-INDEX        |   2 +
 Documentation/timers/timekeeping.txt | 165 +++++++++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+)
 create mode 100644 Documentation/timers/timekeeping.txt

diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
index 6d042dc1cce0..ee212a27772f 100644
--- a/Documentation/timers/00-INDEX
+++ b/Documentation/timers/00-INDEX
@@ -12,6 +12,8 @@ Makefile
 	- Build and link hpet_example
 NO_HZ.txt
 	- Summary of the different methods for the scheduler clock-interrupts management.
+timekeeping.txt
+	- Clock sources, clock events, sched_clock() and delay timer notes
 timers-howto.txt
 	- how to insert delays in the kernel the right (tm) way.
 timer_stats.txt
diff --git a/Documentation/timers/timekeeping.txt b/Documentation/timers/timekeeping.txt
new file mode 100644
index 000000000000..2a137a646d66
--- /dev/null
+++ b/Documentation/timers/timekeeping.txt
@@ -0,0 +1,165 @@
+Clock sources, Clock events, sched_clock() and delay timers
+-----------------------------------------------------------
+
+This document tries to briefly explain some basic kernel timekeeping
+abstractions. It partly pertains to the drivers usually found in
+drivers/clocksource in the kernel tree, but the code may be spread out
+across the kernel.
+
+If you grep through the kernel source you will find a number of architecture-
+specific implementations of clock sources, clockevents and several likewise
+architecture-specific overrides of the sched_clock() function and some
+delay timers.
+
+To provide timekeeping for your platform, the clock source provides
+the basic timeline, whereas clock events shoot interrupts on certain points
+on this timeline, providing facilities such as high-resolution timers.
+sched_clock() is used for scheduling and timestamping, and delay timers
+provide an accurate delay source using hardware counters.
+
+
+Clock sources
+-------------
+
+The purpose of the clock source is to provide a timeline for the system that
+tells you where you are in time. For example issuing the command 'date' on
+a Linux system will eventually read the clock source to determine exactly
+what time it is.
+
+Typically the clock source is a monotonic, atomic counter which will provide
+n bits which count from 0 to 2^(n-1) and then wraps around to 0 and start over.
+It will ideally NEVER stop ticking as long as the system is functional.
+
+The clock source shall have as high resolution as possible, and shall be as
+stable and correct as possible as compared to a real-world wall clock. It
+should not move unpredictably back and forth in time or miss a few cycles
+here and there.
+
+It must be immune to the kind of effects that occur in hardware where e.g.
+the counter register is read in two phases on the bus lowest 16 bits first
+and the higher 16 bits in a second bus cycle with the counter bits
+potentially being updated inbetween leading to the risk of very strange
+values from the counter.
+
+When the wall-clock accuracy of the clock source isn't satisfactory, there
+are various quirks and layers in the timekeeping code for e.g. synchronizing
+the user-visible time to RTC clocks in the system or against networked time
+servers using NTP, but all they do is basically to update an offset against
+the clock source, which provides the fundamental timeline for the system.
+These measures does not affect the clock source per se, they only adapt the
+system to the shortcomings of it.
+
+The clock source struct shall provide means to translate the provided counter
+into a rough nanosecond value as an unsigned long long (unsigned 64 bit) number.
+Since this operation may be invoked very often, doing this in a strict
+mathematical sense is not desireable: instead the number is taken as close as
+possible to a nanosecond value using only the arithmetic operations
+mult and shift, so in clocksource_cyc2ns() you find:
+
+  ns ~= (clocksource * mult) >> shift
+
+You will find a number of helper functions in the clock source code intended
+to aid in providing these mult and shift values, such as
+clocksource_khz2mult(), clocksource_hz2mult() that help determinining the
+mult factor from a fixed shift, and clocksource_calc_mult_shift() and
+clocksource_register_hz() which will help out assigning both shift and mult
+factors using the frequency of the clock source and desirable minimum idle
+time as the only input.
+
+For real simple clock sources accessed from a single I/O memory location
+there is nowadays even clocksource_mmio_init() which will take a memory
+location, bit width, a parameter telling whether the counter in the
+register counts up or down, and the timer clock rate, and then conjure all
+necessary parameters.
+
+In the past, the timekeeping authors would come up with the shift and mult
+values by hand, which is why you will sometimes find hard-coded shift and
+mult values in the code.
+
+Since a 32 bit counter at say 100 MHz will wrap around to zero after some 43
+seconds, the code handling the clock source will have to compensate for this.
+That is the reason to why the clock source struct also contains a 'mask'
+member telling how many bits of the source are valid. This way the timekeeping
+code knows when the counter will wrap around and can insert the necessary
+compensation code on both sides of the wrap point so that the system timeline
+remains monotonic.
+
+
+Clock events
+------------
+
+Clock events are conceptually orthogonal to clock sources. The same hardware
+and register range may be used for the clock event, but it is essentially
+a different thing.
+
+You will notice that the clock event device code is based on the same basic
+idea about translating counters to nanoseconds using mult and shift
+arithmetics, and you find the same family of helper functions again for
+assigning these values. The clock event driver does not need a 'mask'
+attribute however: the system will not try to plan events beyond the time
+horizon of the clock event.
+
+
+sched_clock()
+-------------
+
+In addition to the clock sources and clock events there is a special weak
+function in the kernel called sched_clock(). This function shall return the
+number of nanoseconds since the system was started. An architecture may or
+may not provide an implementation of sched_clock() on its own. If a local
+implementation is not provided, the system jiffy counter will be used as
+sched_clock().
+
+As the name suggests, sched_clock() is used for scheduling the system,
+determining the absolute timeslice for a certain process in the CFS scheduler
+for example. It is also used for printk timestamps when you have selected to
+include time information in printk for things like bootcharts.
+
+Compared to clock sources, sched_clock() has to be very fast: it is called
+much more often, especially by the scheduler. If you have to do trade-offs
+between accuracy compared to the clock source, you may sacrifice accuracy
+for speed in sched_clock(). It however require some of the same basic
+characteristics as the clock source, i.e. it has to be monotonic.
+
+The sched_clock() function may wrap only on unsigned long long boundaries,
+i.e. after 64 bits. Since this is a nanosecond value this will mean it wraps
+after circa 585 years. (For most practical systems this means "never".)
+
+If an architecture does not provide its own implementation of this function,
+it will fall back to using jiffies, making its maximum resolution 1/HZ of the
+jiffy frequency for the architecture. This will affect scheduling accuracy
+and will likely show up in system benchmarks.
+
+The clock driving sched_clock() may stop or reset to zero during system
+suspend/sleep. This does not matter to the function it serves of scheduling
+events on the system. However it may result in interesting timestamps in
+printk().
+
+Some architectures may have a limited set of time sources and lack a nice
+counter to derive a 64-bit nanosecond value, so for example on the ARM
+architecture, special helper functions have been created to provide a
+sched_clock() nanosecond base from a 16- or 32-bit counter. Sometimes the
+same counter that is also used as clock source is used for this purpose.
+
+
+Delay timers (some architectures only)
+--------------------------------------
+
+On systems with variable CPU frequency, the various kernel delay() function
+will sometimes behave strangely. Basically these delays usually use a hard
+loop to delay a certain number of jiffy fractions using a "lpj" (loops per
+jiffy) value, calibrated on boot.
+
+Let's hope that your system is running on maximum frequency when this value
+is calibrated: as an effect when the frequency is geared down to half the
+full frequency, any delay() will be twice as long. Usually this does not
+hurt, as you're commonly requesting that amount of delay *or more*. But
+basically the sematics are quite unpredictable on such systems.
+
+Enter timer-based delays. Using these, a timer read may be used instead of
+a hard-coded loop for providing the desired delay.
+
+This is done by declaring a struct delay_timer and assigning the apropriate
+function pointers and rate settings for this delay timer.
+
+This is available on some architectures like OpenRISC or ARM.
-- 
1.9.3

