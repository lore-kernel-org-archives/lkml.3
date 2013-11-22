Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3KVTPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:15:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44110 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3KVTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:15:51 -0500
Message-ID: <528FAD63.5030805@linaro.org>
Date: Fri, 22 Nov 2013 11:15:47 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
CC: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: Clock drift with GENERIC_TIME_VSYSCALL_OLD
References: <20131122163815.393ab1f2@mschwide>
In-Reply-To: <20131122163815.393ab1f2@mschwide>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 07:38 AM, Martin Schwidefsky wrote:
> Greetings,
>
> I just hunted down a time related bug which caused the Linux internal
> xtime to drift away from the precise hardware clock provided by the
> TOD clock found in the s390 architecture.
>
> After a long search I came along this lovely piece of code in
> kernel/time/timekeeping.c:
>
> #ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
> static inline void old_vsyscall_fixup(struct timekeeper *tk)
>
>         s64 remainder;
>
>         /*
>         * Store only full nanoseconds into xtime_nsec after rounding
>         * it up and add the remainder to the error difference.
>         * XXX - This is necessary to avoid small 1ns inconsistnecies caused
>         * by truncating the remainder in vsyscalls. However, it causes
>         * additional work to be done in timekeeping_adjust(). Once
>         * the vsyscall implementations are converted to use xtime_nsec
>         * (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
>         * users are removed, this can be killed.
>         */
>         remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
>         tk->xtime_nsec -= remainder;
>         tk->xtime_nsec += 1ULL << tk->shift;
>         tk->ntp_error += remainder << tk->ntp_error_shift;
>
> }
> #else
> #define old_vsyscall_fixup(tk)
> #endif
>
> The highly precise result of our TOD clock source ends up in
> tk->xtime_sec / tk->xtime_nsec where old_vsyscall_fixup just rounds
> it up to the next nano-second (booo). To add insult to injury an
> incorrect delta gets added to ntp_error, xtime has been forwarded by
> ((1ULL << tk->shift) - (tk->xtime_nsec & ((1ULL << tk->shift) - 1)))
> and not set back by (tk->xtime_nsec & ((1ULL << tk->shift) - 1)).
> xtime is too fast by one nano-second per tick. To verify that this
> is indeed the problem I removed the line that adds the nano-second
> to xtime_nsec and voila the clocks are in sync.

So first my apologies for the time you had to sink into this!

You're analysis looks correct, and apparently I introduced this problem
w/ 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1 (landed in v3.6)

-       /*
-        * Store full nanoseconds into xtime after rounding it up and
-        * add the remainder to the error difference.
-        */
-       timekeeper.xtime.tv_nsec = ((s64)timekeeper.xtime_nsec >>
-                                               timekeeper.shift) + 1;
-       timekeeper.xtime_nsec -= (s64)timekeeper.xtime.tv_nsec <<
-                                               timekeeper.shift;
-       timekeeper.ntp_error += timekeeper.xtime_nsec <<
-                               timekeeper.ntp_error_shift;
+       * Store only full nanoseconds into xtime_nsec after rounding
+       * it up and add the remainder to the error difference.
+       * XXX - This is necessary to avoid small 1ns inconsistnecies caused
+       * by truncating the remainder in vsyscalls. However, it causes
+       * additional work to be done in timekeeping_adjust(). Once
+       * the vsyscall implementations are converted to use xtime_nsec
+       * (shifted nanoseconds), this can be killed.
+       */
+       remainder = timekeeper.xtime_nsec & ((1 << timekeeper.shift) - 1);
+       timekeeper.xtime_nsec -= remainder;
+       timekeeper.xtime_nsec += 1 << timekeeper.shift;
+       timekeeper.ntp_error += remainder << timekeeper.ntp_error_shift;



I'm clearly missing the balancing adjustment to ntp_error for the
rounding up truncation.


> A possible patch to fix this would be:
>
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1347,6 +1347,7 @@ static inline void old_vsyscall_fixup(struct timekeeper *t
> k)
>         tk->xtime_nsec -= remainder;
>         tk->xtime_nsec += 1ULL << tk->shift;
>         tk->ntp_error += remainder << tk->ntp_error_shift;
> +       tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
>  
>  }
>  #else

So yes, this would restore the pre v3.6 behavior (that was at that time
used on all systems) for systems that use the old vsyscall method.  I'll
queue this fix and send it to stable.


> But that has the downside that it creates a negative ntp_error that
> can only be corrected with an adjustment of tk->mult which takes a
> long time.

So the time it would take depends on the clocksource details, but I'm
not sure it would be all that long (though the math is subtle and I just
drank my coffee, so I could be wrong): Assuming you're clocksource is
otherwise perfect, you're gaining only 1ns of error per tick. And we do
the adjustment once error(in shifted nanoseconds) > cycle_interval/2,
which I think works out to  error_in_nanoseconds > (cycle_interval >>
(shift+1)). S390 tod clocksource has a shift value of 12, and since mult
is 1000, I'm guessing a cycle_interval value for HZ=1000 is 4096000. So
with that, you'd need 500 ns of error before the mult adjustment occurs,
which would take about half a second.  If there were any other sources
of error, then you'd see the same range, but likely a faster or slower
period to the oscillation.

Is that about what you were seeing? Or am I way off?

And yes, these days a 500ns oscillation is problematic as PTP and other
sync methods are getting below that. Though the s390's clocksource is
rare in that its shift value is manually set and is using a fairly
coarse shift value (I can't recall, is there a reason for it being that
low? I know its manually set because you use it as the default
clocksource). So other clocksources using the register_khz/hz methods
will get calculated shift values that are usually a bit larger, allowing
for much finer grained adjustments and proportionally smaller oscillation.


> The fix I am going to use is to convert s390 to GENERIC_TIME_VSYSCALL,
> you might want to think about doing that for powerpc and ia64 as well.

So again, the old_vsyscall method (with your fix to the regression) is
probably not as problematic on other arches. None the less, I would love
to see that old code removed and powerpc and ia64 to be updated to the
new vsyscall method. Unfortunately in both cases, I'll likely need the
maintainers to do the transition, because I don't know ia64 asm, and the
powerpc vdso has a complicated legacy interface that has its own subtle
quirks.

thanks
-john

