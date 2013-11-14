Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3KNOux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:50:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab3KNOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:50:45 -0500
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCH RFC] timekeeping: Fix clock stability with nohz
Date: Thu, 14 Nov 2013 15:50:40 +0100
Message-Id: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 5eb6d205 the system clock is kept separately from NTP time
and it is synchronized by adjusting its multiplier in a feedback loop.
This works well when the updates are done regularly. With nohz and idle
system, however, the loop becomes unstable at a certain update interval.
The loop overcorrects and the frequency doesn't settle down. The clock
has a large error, which seems to grow quadratically with update
interval.

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

TODO:
- add forced update_wall_time() and call it after adjtimex() to improve
  accuracy of phase adjustments done by quickly changing NTP frequency
- check if there are any issues with suspend

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
---
 include/linux/timekeeper_internal.h |   4 +
 kernel/time/timekeeping.c           | 209 +++++-------------------------------
 2 files changed, 31 insertions(+), 182 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index c1825eb..b91ad4b 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -34,12 +34,16 @@ struct timekeeper {
 	/* Clock shifted nano seconds */
 	u64			xtime_nsec;
 
+	/* Tick used for calculation of NTP error. */
+	u64			ntp_tick;
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64			ntp_error;
 	/* Shift conversion between clock shifted nano seconds and
 	 * ntp shifted nano seconds. */
 	u32			ntp_error_shift;
+	/* Correction applied to mult to reduce the error. */
+	u32			mult_ntp_correction;
 
 	/*
 	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3abf534..6ee57f7 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -146,6 +146,9 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 	 * to counteract clock drifting.
 	 */
 	tk->mult = clock->mult;
+	/* zero frequency offset */
+	tk->ntp_tick = tk->xtime_interval << tk->ntp_error_shift;
+	tk->mult_ntp_correction = 0;
 }
 
 /* Timekeeper helper functions. */
@@ -1048,200 +1051,42 @@ static int __init timekeeping_init_ops(void)
 device_initcall(timekeeping_init_ops);
 
 /*
- * If the error is already larger, we look ahead even further
- * to compensate for late or lost adjustments.
+ * Adjust the multiplier according to current NTP tick.
  */
-static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
-						 s64 error, s64 *interval,
-						 s64 *offset)
+static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 {
-	s64 tick_error, i;
-	u32 look_ahead, adj;
-	s32 error2, mult;
+	u32 new_mult;
 
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
+	/* Avoid division if the tick didn't change */
+	if (tk->ntp_tick == ntp_tick_length()) {
+		new_mult = tk->mult - tk->mult_ntp_correction;
+	} else {
+		tk->ntp_tick = ntp_tick_length();
+		new_mult = div64_u64(tk->ntp_tick, tk->cycle_interval) >>
+			tk->ntp_error_shift;
+	}
 
 	/*
-	 * Now calculate the error in (1 << look_ahead) ticks, but first
-	 * remove the single look ahead already included in the error.
+	 * Speed the clock up by 1 if it's behind NTP time. If there is no
+	 * remainder from the tick division, the clock will stay ahead of
+	 * NTP time until a non-divisible tick is encountered.
 	 */
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
+	tk->mult_ntp_correction = tk->ntp_error > 0 ? 1 : 0;
+	new_mult += tk->mult_ntp_correction;
 
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
-}
-
-/*
- * Adjust the multiplier to reduce the error value,
- * this is optimized for the most common adjustments of -1,0,1,
- * for other values we can do a bit more work.
- */
-static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
-{
-	s64 error, interval = tk->cycle_interval;
-	int adj;
+	if (new_mult == tk->mult)
+		return;
 
-	/*
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
-	 */
-	error = tk->ntp_error >> (tk->ntp_error_shift - 1);
-	if (error > interval) {
-		/*
-		 * We now divide error by 4(via shift), which checks if
-		 * the error is greater than twice the interval.
-		 * If it is greater, we need a bigadjust, if its smaller,
-		 * we can adjust by 1.
-		 */
-		error >>= 2;
-		/*
-		 * XXX - In update_wall_time, we round up to the next
-		 * nanosecond, and store the amount rounded up into
-		 * the error. This causes the likely below to be unlikely.
-		 *
-		 * The proper fix is to avoid rounding up by using
-		 * the high precision tk->xtime_nsec instead of
-		 * xtime.tv_nsec everywhere. Fixing this will take some
-		 * time.
-		 */
-		if (likely(error <= interval))
-			adj = 1;
-		else
-			adj = timekeeping_bigadjust(tk, error, &interval, &offset);
-	} else {
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
-	}
+	tk->mult = new_mult;
+	tk->xtime_interval = tk->cycle_interval * tk->mult;
 
 	if (unlikely(tk->clock->maxadj &&
-		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
+		(tk->mult > tk->clock->mult + tk->clock->maxadj))) {
 		printk_once(KERN_WARNING
 			"Adjusting %s more than 11%% (%ld vs %ld)\n",
-			tk->clock->name, (long)tk->mult + adj,
+			tk->clock->name, (long)tk->mult,
 			(long)tk->clock->mult + tk->clock->maxadj);
 	}
-	/*
-	 * So the following can be confusing.
-	 *
-	 * To keep things simple, lets assume adj == 1 for now.
-	 *
-	 * When adj != 1, remember that the interval and offset values
-	 * have been appropriately scaled so the math is the same.
-	 *
-	 * The basic idea here is that we're increasing the multiplier
-	 * by one, this causes the xtime_interval to be incremented by
-	 * one cycle_interval. This is because:
-	 *	xtime_interval = cycle_interval * mult
-	 * So if mult is being incremented by one:
-	 *	xtime_interval = cycle_interval * (mult + 1)
-	 * Its the same as:
-	 *	xtime_interval = (cycle_interval * mult) + cycle_interval
-	 * Which can be shortened to:
-	 *	xtime_interval += cycle_interval
-	 *
-	 * So offset stores the non-accumulated cycles. Thus the current
-	 * time (in shifted nanoseconds) is:
-	 *	now = (offset * adj) + xtime_nsec
-	 * Now, even though we're adjusting the clock frequency, we have
-	 * to keep time consistent. In other words, we can't jump back
-	 * in time, and we also want to avoid jumping forward in time.
-	 *
-	 * So given the same offset value, we need the time to be the same
-	 * both before and after the freq adjustment.
-	 *	now = (offset * adj_1) + xtime_nsec_1
-	 *	now = (offset * adj_2) + xtime_nsec_2
-	 * So:
-	 *	(offset * adj_1) + xtime_nsec_1 =
-	 *		(offset * adj_2) + xtime_nsec_2
-	 * And we know:
-	 *	adj_2 = adj_1 + 1
-	 * So:
-	 *	(offset * adj_1) + xtime_nsec_1 =
-	 *		(offset * (adj_1+1)) + xtime_nsec_2
-	 *	(offset * adj_1) + xtime_nsec_1 =
-	 *		(offset * adj_1) + offset + xtime_nsec_2
-	 * Canceling the sides:
-	 *	xtime_nsec_1 = offset + xtime_nsec_2
-	 * Which gives us:
-	 *	xtime_nsec_2 = xtime_nsec_1 - offset
-	 * Which simplfies to:
-	 *	xtime_nsec -= offset
-	 *
-	 * XXX - TODO: Doc ntp_error calculation.
-	 */
-	tk->mult += adj;
-	tk->xtime_interval += interval;
-	tk->xtime_nsec -= offset;
-	tk->ntp_error -= (interval - offset) << tk->ntp_error_shift;
-
-out_adjust:
-	/*
-	 * It may be possible that when we entered this function, xtime_nsec
-	 * was very small.  Further, if we're slightly speeding the clocksource
-	 * in the code above, its possible the required corrective factor to
-	 * xtime_nsec could cause it to underflow.
-	 *
-	 * Now, since we already accumulated the second, cannot simply roll
-	 * the accumulated second back, since the NTP subsystem has been
-	 * notified via second_overflow. So instead we push xtime_nsec forward
-	 * by the amount we underflowed, and add that amount into the error.
-	 *
-	 * We'll correct this error next time through this function, when
-	 * xtime_nsec is not as small.
-	 */
-	if (unlikely((s64)tk->xtime_nsec < 0)) {
-		s64 neg = -(s64)tk->xtime_nsec;
-		tk->xtime_nsec = 0;
-		tk->ntp_error += neg << tk->ntp_error_shift;
-	}
-
 }
 
 /**
@@ -1321,7 +1166,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	tk->ntp_error += ntp_tick_length() << shift;
+	tk->ntp_error += tk->ntp_tick << shift;
 	tk->ntp_error -= (tk->xtime_interval + tk->xtime_remainder) <<
 						(tk->ntp_error_shift + shift);
 
@@ -1406,7 +1251,7 @@ static void update_wall_time(void)
 			shift--;
 	}
 
-	/* correct the clock when NTP error is too big */
+	/* Update the multiplier */
 	timekeeping_adjust(tk, offset);
 
 	/*
-- 
1.8.3.1

