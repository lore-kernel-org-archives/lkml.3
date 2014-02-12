Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaBLPm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:42:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaBLPm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:42:26 -0500
Date: Wed, 12 Feb 2014 16:42:21 +0100
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
Message-ID: <20140212154221.GG666@localhost>
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2014 at 07:57:03PM -0800, John Stultz wrote:
> Got a few cycles to take another look at this, and tried to address
> Miroslav's latest comments. Please let me know if you have further
> thoughts!

In the simulations this version of the patch does indeed work better
than the previous one. I tested it with the ntp_error correction added
back as per your previous mail. It converges, the measured frequency
matches the value set by adjtimex and the ntp error stays close to
zero. I'm concerned about two things now and I'm not sure if they can
be fixed easily.

One is that the convergence still seems too slow to me.

./tk_test -t 500 -n 4000
samples: 1-500 reg: 1-500 slope: 1.00 dev: 1947.5 max: 36940.9 freq: -100.08081
samples: 501-1000 reg: 501-1000 slope: 1.00 dev: 430.7 max: 1669.6 freq: -100.07168
samples: 1001-1500 reg: 1001-1500 slope: 1.00 dev: 675.3 max: 3172.9 freq: -100.07393
samples: 1501-2000 reg: 1501-2000 slope: 1.00 dev: 453.9 max: 2223.4 freq: -100.07177
samples: 2001-2500 reg: 2001-2500 slope: 1.00 dev: 2601.2 max: 10875.4 freq: -100.03978
samples: 2501-3000 reg: 2501-3000 slope: 1.00 dev: 185.6 max: 1251.6 freq: -99.99987
samples: 3001-3500 reg: 3001-3500 slope: 1.00 dev: 160.1 max: 1181.7 freq: -99.99996
samples: 3501-4000 reg: 3501-4000 slope: 1.00 dev: 150.7 max: 1103.2 freq: -99.99990

You can see in this test it takes about 2500 updates to correct the
initial ntp error and settle down. That's with 1GHz clocksource. In
some tests I did with smaller clock frequencies or different frequency
offsets it took much longer than that.

$ ./tk_test -s 2500 -n 5000
samples: 1-5000 reg: 2501-5000 slope: 1.00 dev: 135942.4 max: 390761.8 freq: -100.00000

Here the regression line is calculated only through the latter half of
the samples (where it was already settled down) and we can see the
total ntp error corrected since the first update is around 390
microseconds.

I'm not saying ntpd or linuxptp can't work with this. The PLL and PI
controllers seem to handle this slowness in the frequency adjustment
well. I'm more worried about designs that may change the frequency
quickly and rely on accurate prediction of the clock in their feedback
loop.

The other thing I'm concerned about is that the multiplier doesn't
change only between two closest values when the loop has settled down,
but in a larger range. With the 1GHz clock I see the multiplier is
moving in range of 8387767-8387772, which makes the ntp error several
times larger than it would be if the multiplier switched just between
8387769 and 8387770.

Let's make a comparison between the current kernel (A), your patch
(B), and my patch (C). The script used for these tests is in the
tktest git as test1.sh. The first two columns are errors in the
measured frequency offsets (in ppm) from the first 10 and 100 samples. The
other two columns are time error deviation and maximum (in
nanoseconds) when the loop has converged. Both nohz and nohz off are
tested. The tests are repeated with 100 slightly different frequencies
and the mean value or stddev is presented.

                freq10       freq100      dev          max
A, nohz on      38.38368     2.72579      1468940.9    9846788.2
B, nohz on      1.37940      0.15085      298.5        1312.5  
C, nohz on      0.00601      0.00028      74.0         279.4
A, nohz off     3.89181      0.10436      0.2          0.6
B, nohz off     1.29396      0.14372      0.2          0.6
C, nohz off     0.05867      0.00204      0.2          0.6

In these tests A with nohz is really bad. C is much better than B in
the frequency control with both nohz enabled and disabled. As for the
time error, with nohz disabled all perform similarly, with nohz
enabled C is about 4 times better than B.

I've attached the latest version of my patch. Some bugfixes and
optimizations were made, but that division is still used in the code.
I've noticed there is a division in logarithmic_accumulation(), which
is used as a workaround for an older compiler bug. Perhaps it could be
removed now, so there is more space for this one?

Please reconsider.

Thanks,

-- 
Miroslav Lichvar

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-timekeeping-Fix-clock-stability-with-nohz.patch"

>From 150e7c8ed96d078d025f154c219c0a4367a401fc Mon Sep 17 00:00:00 2001
From: Miroslav Lichvar <mlichvar@redhat.com>
Date: Thu, 14 Nov 2013 11:06:02 +0100
Subject: [PATCHv2] timekeeping: Fix clock stability with nohz

Since commit 5eb6d205, NTP corrections are accumulated independently
from the system clock and the clock multiplier is adjusted in a feedback
loop according to the current error between the system time and NTP
time.

This works well when the multiplier is updated often and regularly. With
nohz and idle system, however, the update interval is so long that the
loop becomes unstable. The frequency of the clock doesn't settle down
and there is a large time error, which seems to grow quadratically with
update interval.

If the constants used in the loop were modified for a maximum update
interval, it would be stable, but too slow to keep up with NTP. Without
knowing when will be the next update it's difficult to implement a loop
that is both fast and stable.

This patch fixes the problem by postponing update of NTP tick length in
the clock and setting the multiplier directly without feedback loop by
dividing the tick length with clock cycles. Previously, a change in tick
length was applied immediately to all ticks since last update, which
caused a jump in the NTP error proportional to the change and the update
interval and which had to be corrected later by the loop.

The only source of the accounted NTP error is now lack of resolution in
the clock multiplier. The error is corrected by adding 0 or 1 to the
calculated multiplier. With a constant tick length, the multiplier will
be switching between the two values. The loop is greatly simplified and
there is no problem with stability. The maximum error is limited by the
update interval.

In a simulation with 1GHz TSC clock and 10Hz clock update the maximum
error went down from 4.7 microseconds to 5.5 nanoseconds. With 1Hz
update the maximum error went down from 480 microseconds to 55
nanoseconds.

In a real test on idle machine comparing raw TSC and clock_gettime()
time stamps, the maximum error went down from microseconds to tens of
nanoseconds. A test with clock synchronized to a PTP hardware clock by
phc2sys from linuxptp now shows no difference when running with nohz
enabled and disabled, the clock seems to be stable to few tens of
nanoseconds.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
---
 include/linux/timekeeper_internal.h |   6 ++
 kernel/time/timekeeping.c           | 156 ++++++++++++------------------------
 2 files changed, 58 insertions(+), 104 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index c1825eb..d55a12a 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -34,12 +34,18 @@ struct timekeeper {
 	/* Clock shifted nano seconds */
 	u64			xtime_nsec;
 
+	/* Tick length used in calculation of NTP error. */
+	u64			ntp_tick;
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64			ntp_error;
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
 	u32			ntp_error_shift;
+	/* Correction applied to mult to reduce the error. */
+	s32			mult_ntp_correction;
+	/* Flag used to avoid updating NTP twice with same second */
+	u32			skip_second_overflow;
 
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..b94f1df 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -147,6 +147,10 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 	 * to counteract clock drifting.
 	 */
 	tk->mult = clock->mult;
+
+	tk->ntp_tick = ntpinterval << tk->ntp_error_shift;
+	tk->mult_ntp_correction = 0;
+	tk->skip_second_overflow = 0;
 }
 
 /* Timekeeper helper functions. */
@@ -1052,106 +1056,49 @@ static int __init timekeeping_init_ops(void)
 device_initcall(timekeeping_init_ops);
 
 /*
- * If the error is already larger, we look ahead even further
- * to compensate for late or lost adjustments.
- */
-static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
-						 s64 error, s64 *interval,
-						 s64 *offset)
-{
-	s64 tick_error, i;
-	u32 look_ahead, adj;
-	s32 error2, mult;
-
-	/*
-	 * Use the current error value to determine how much to look ahead.
-	 * The larger the error the slower we adjust for it to avoid problems
-	 * with losing too many ticks, otherwise we would overadjust and
-	 * produce an even larger error.  The smaller the adjustment the
-	 * faster we try to adjust for it, as lost ticks can do less harm
-	 * here.  This is tuned so that an error of about 1 msec is adjusted
-	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
-	 */
-	error2 = tk->ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
-	error2 = abs(error2);
-	for (look_ahead = 0; error2 > 0; look_ahead++)
-		error2 >>= 2;
-
-	/*
-	 * Now calculate the error in (1 << look_ahead) ticks, but first
-	 * remove the single look ahead already included in the error.
-	 */
-	tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
-	tick_error -= tk->xtime_interval >> 1;
-	error = ((error - tick_error) >> look_ahead) + tick_error;
-
-	/* Finally calculate the adjustment shift value.  */
-	i = *interval;
-	mult = 1;
-	if (error < 0) {
-		error = -error;
-		*interval = -*interval;
-		*offset = -*offset;
-		mult = -1;
-	}
-	for (adj = 0; error > i; adj++)
-		error >>= 1;
-
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
-}
-
-/*
  * Adjust the multiplier to reduce the error value,
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
 static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 {
-	s64 error, interval = tk->cycle_interval;
+	s64 interval = tk->cycle_interval;
+	u32 mult;
 	int adj;
 
 	/*
-	 * The point of this is to check if the error is greater than half
-	 * an interval.
-	 *
-	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
-	 *
-	 * Note we subtract one in the shift, so that error is really error*2.
-	 * This "saves" dividing(shifting) interval twice, but keeps the
-	 * (error > interval) comparison as still measuring if error is
-	 * larger than half an interval.
-	 *
-	 * Note: It does not "save" on aggravation when reading the code.
+	 * Get multiplier matching the current NTP tick length. Use division
+	 * only when the tick length has changed (normally once per second
+	 * with active NTP PLL).
 	 */
-	error = tk->ntp_error >> (tk->ntp_error_shift - 1);
-	if (error > interval) {
-		/*
-		 * We now divide error by 4(via shift), which checks if
-		 * the error is greater than twice the interval.
-		 * If it is greater, we need a bigadjust, if its smaller,
-		 * we can adjust by 1.
-		 */
-		error >>= 2;
-		if (likely(error <= interval))
-			adj = 1;
-		else
-			adj = timekeeping_bigadjust(tk, error, &interval, &offset);
+	if (tk->ntp_tick == ntp_tick_length()) {
+		mult = tk->mult - tk->mult_ntp_correction;
 	} else {
-		if (error < -interval) {
-			/* See comment above, this is just switched for the negative */
-			error >>= 2;
-			if (likely(error >= -interval)) {
-				adj = -1;
-				interval = -interval;
-				offset = -offset;
-			} else {
-				adj = timekeeping_bigadjust(tk, error, &interval, &offset);
-			}
-		} else {
-			goto out_adjust;
-		}
+		tk->ntp_tick = ntp_tick_length();
+		mult = div64_u64((tk->ntp_tick >> tk->ntp_error_shift) -
+				 tk->xtime_remainder, tk->cycle_interval);
+	}
+
+	/*
+	 * Speed the clock up by 1 if it's behind NTP time. If there is no
+	 * remainder from the tick division, the clock will stay ahead
+	 * of NTP time until a non-divisible tick length is encountered.
+	 * (slowing the clock by 1 would increase the frequency error)
+	 */
+	tk->mult_ntp_correction = tk->ntp_error > 0 ? 1 : 0;
+	mult += tk->mult_ntp_correction;
+	adj = mult - tk->mult;
+
+	if (adj == 0)
+		goto out_adjust;
+
+	/* Multiply offset and interval by adj */
+	if (adj == -1) {
+		interval = -interval;
+		offset = -offset;
+	} else if (adj != 1) {
+		interval *= adj;
+		offset *= adj;
 	}
 
 	if (unlikely(tk->clock->maxadj &&
@@ -1207,13 +1154,10 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	 *	xtime_nsec_2 = xtime_nsec_1 - offset
 	 * Which simplfies to:
 	 *	xtime_nsec -= offset
-	 *
-	 * XXX - TODO: Doc ntp_error calculation.
 	 */
 	tk->mult += adj;
 	tk->xtime_interval += interval;
 	tk->xtime_nsec -= offset;
-	tk->ntp_error -= (interval - offset) << tk->ntp_error_shift;
 
 out_adjust:
 	/*
@@ -1222,18 +1166,13 @@ out_adjust:
 	 * in the code above, its possible the required corrective factor to
 	 * xtime_nsec could cause it to underflow.
 	 *
-	 * Now, since we already accumulated the second, cannot simply roll
-	 * the accumulated second back, since the NTP subsystem has been
-	 * notified via second_overflow. So instead we push xtime_nsec forward
-	 * by the amount we underflowed, and add that amount into the error.
-	 *
-	 * We'll correct this error next time through this function, when
-	 * xtime_nsec is not as small.
+	 * Now, since we already accumulated the second and the NTP subsystem has
+	 * been notified via second_overflow(), we need to skip the next update.
 	 */
 	if (unlikely((s64)tk->xtime_nsec < 0)) {
-		s64 neg = -(s64)tk->xtime_nsec;
-		tk->xtime_nsec = 0;
-		tk->ntp_error += neg << tk->ntp_error_shift;
+		tk->xtime_nsec += (u64)NSEC_PER_SEC << tk->shift;
+		tk->xtime_sec--;
+		tk->skip_second_overflow = 1;
 	}
 
 }
@@ -1257,6 +1196,15 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 		tk->xtime_nsec -= nsecps;
 		tk->xtime_sec++;
 
+		/*
+		 * Skip NTP update if this second was accumulated before,
+		 * i.e. xtime_nsec underflowed in timekeeping_adjust()
+		 */
+		if (unlikely(tk->skip_second_overflow)) {
+			tk->skip_second_overflow = 0;
+			continue;
+		}
+
 		/* Figure out if its a leap sec and apply if needed */
 		leap = second_overflow(tk->xtime_sec);
 		if (unlikely(leap)) {
@@ -1315,7 +1263,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	tk->ntp_error += ntp_tick_length() << shift;
+	tk->ntp_error += tk->ntp_tick << shift;
 	tk->ntp_error -= (tk->xtime_interval + tk->xtime_remainder) <<
 						(tk->ntp_error_shift + shift);
 
@@ -1401,7 +1349,7 @@ void update_wall_time(void)
 			shift--;
 	}
 
-	/* correct the clock when NTP error is too big */
+	/* Update the multiplier */
 	timekeeping_adjust(tk, offset);
 
 	/*
-- 
1.8.4.2


--h31gzZEtNLTqOjlF--
