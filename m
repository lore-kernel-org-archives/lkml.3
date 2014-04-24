Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaDXXGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:06:23 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47203 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaDXXEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:04:48 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 1/3] [RFC] timekeeping: Rework frequency adjustments to work better w/ nohz
Date: Thu, 24 Apr 2014 16:04:35 -0700
Message-Id: <1398380677-8684-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing timekeeping_adjust logic has always been complicated
to understand. Further, since it was developed prior to NOHZ becoming
common, its not surprising it performs poorly when NOHZ is enabled.

Since Miroslav pointed out the problematic nature of the existing code
in the NOHZ case, I've tried to refactor the code to perform better.

The problem with the previous approach was that it tried to adjust
for the total cumulative error using a scaled dampening factor. This
resulted in large errors to be corrected slowly, while small errors
were corrected quickly. With NOHZ the timekeeping code doesn't know
how far out the next tick will be, so this results in bad
over-correction to small errors, and insufficient correction to large
errors.

Inspired by Miroslav's patch, I've refactored the code to try to
address the correction in two steps.

1) Check the future freq error for the next tick, and if the frequency
error is large, try to make sure we correct it so it doesn't cause
much accumulated error.

2) Then make a small single unit adjustment to correct any cumulative
error that has collected over time.

This method performs fairly well in the simulator Miroslav created.

Major credit to Miroslav for pointing out the issue, providing the
original patch to resolve this, a simulator for testing, as well as
helping debug and resolve issues in my implementation so that it
performed closer to his original implementation.

I'd be very interested in feedback, thoughts, and testing.

Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Reported-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 194 ++++++++++++++++++++--------------------------
 1 file changed, 85 insertions(+), 109 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f7df8ea..9aa8ccf 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1052,122 +1052,31 @@ static int __init timekeeping_init_ops(void)
 
 device_initcall(timekeeping_init_ops);
 
-/*
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
 
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
-}
 
-/*
- * Adjust the multiplier to reduce the error value,
- * this is optimized for the most common adjustments of -1,0,1,
- * for other values we can do a bit more work.
- */
-static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
+static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
+							 s64 offset,
+							 bool negative,
+							 int adj_scale)
 {
-	s64 error, interval = tk->cycle_interval;
-	int adj;
+	s64 interval = tk->cycle_interval;
+	s32 mult_adj = 1;
 
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
+	if (negative) {
+		mult_adj = -mult_adj;
+		interval = -interval;
+		offset  = -offset;
 	}
+	mult_adj <<= adj_scale;
+	interval <<= adj_scale;
+	offset <<= adj_scale;
 
-	if (unlikely(tk->clock->maxadj &&
-		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
-		printk_once(KERN_WARNING
-			"Adjusting %s more than 11%% (%ld vs %ld)\n",
-			tk->clock->name, (long)tk->mult + adj,
-			(long)tk->clock->mult + tk->clock->maxadj);
-	}
 	/*
 	 * So the following can be confusing.
 	 *
-	 * To keep things simple, lets assume adj == 1 for now.
+	 * To keep things simple, lets assume mult_adj == 1 for now.
 	 *
-	 * When adj != 1, remember that the interval and offset values
+	 * When mult_adj != 1, remember that the interval and offset values
 	 * have been appropriately scaled so the math is the same.
 	 *
 	 * The basic idea here is that we're increasing the multiplier
@@ -1211,12 +1120,80 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
-	tk->mult += adj;
+	tk->mult += mult_adj;
 	tk->xtime_interval += interval;
 	tk->xtime_nsec -= offset;
 	tk->ntp_error -= (interval - offset) << tk->ntp_error_shift;
+}
+
+/*
+ * Calculate the future error caused by incorrect freq value
+ * and adjust the timekeeper to correct that.
+ */
+static __always_inline void timekeeping_freqadjust(struct timekeeper *tk,
+						 s64 interval,
+						 s64 offset)
+{
+	s64 tick_error, i;
+	bool negative;
+	u32 adj;
+
+	/* Calculate current error per tick */
+	tick_error = ntp_tick_length() >> tk->ntp_error_shift;
+	tick_error -= (tk->xtime_interval + tk->xtime_remainder);
+
+	/* Don't worry about correcting it if its small */
+	if (likely(abs(tick_error) < interval/2) && (tick_error > 0))
+		return;
+
+	/* preserve the direction of correction */
+	negative = (tick_error < 0);
+
+	/* Sort out the magnitude of the correction */
+	tick_error = abs(tick_error);
+	i = abs(interval);
+	for (adj = 0; tick_error > i; adj++)
+		tick_error >>= 1;
+
+	/* scale the corrections */
+	timekeeping_apply_adjustment(tk, offset, negative, adj);
+}
+
+
+/*
+ * Adjust the multiplier to reduce the error value,
+ * this is optimized for the most common adjustments of -1,0,1,
+ * for other values we can do a bit more work.
+ */
+static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
+{
+
+	s64 interval = tk->cycle_interval;
+	static int tk_erradj;
+
+	/* Undo any existing error adjustment */
+	if (tk_erradj) {
+		timekeeping_apply_adjustment(tk, offset, 1, 0);
+		tk_erradj = 0;
+	}
+
+	/* Correct for the current frequency error */
+	timekeeping_freqadjust(tk, interval, offset);
+
+	/* Next make a small adjustment to fix any cumulative error */
+	if (tk->ntp_error > 0) {
+		tk_erradj = 1;
+		timekeeping_apply_adjustment(tk, offset, 0, 0);
+	}
+
+	if (unlikely(tk->clock->maxadj &&
+		(tk->mult > tk->clock->mult + tk->clock->maxadj))) {
+		printk_once(KERN_WARNING
+			"Adjusting %s more than 11%% (%ld vs %ld)\n",
+			tk->clock->name, (long)tk->mult,
+			(long)tk->clock->mult + tk->clock->maxadj);
+	}
 
-out_adjust:
 	/*
 	 * It may be possible that when we entered this function, xtime_nsec
 	 * was very small.  Further, if we're slightly speeding the clocksource
@@ -1236,7 +1213,6 @@ out_adjust:
 		tk->xtime_nsec = 0;
 		tk->ntp_error += neg << tk->ntp_error_shift;
 	}
-
 }
 
 /**
-- 
1.8.3.2

