Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaAGD5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:57:13 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41297 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaAGD5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:57:11 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work better w/ nohz
Date: Mon,  6 Jan 2014 19:57:03 -0800
Message-Id: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got a few cycles to take another look at this, and tried to address
Miroslav's latest comments. Please let me know if you have further
thoughts!

thanks
-john


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
error is large, try to make sure we correct that error as best we can.

2) Then make a small single unit adjustment to correct any cumulative
error that we've collected.

This method performs fairly well in the simulator Miroslav created.

I also dropped the tk->ntp_error adjustments, as I've never quite
been able to recall how that was correct, and it doesn't seem to 
have any affect in the simulator. Will have to proceed carefully
with testing here.

I still think this is probably 3.15 or later material, but I'd be
very interested in feedback, thoughts, and testing.

Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Reported-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 163 +++++++++++++++++-----------------------------
 1 file changed, 61 insertions(+), 102 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 87b4f00..15354d4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1048,54 +1048,50 @@ static int __init timekeeping_init_ops(void)
 device_initcall(timekeeping_init_ops);
 
 /*
- * If the error is already larger, we look ahead even further
- * to compensate for late or lost adjustments.
+ * Calculate the future error caused by incorrect freq value
+ * and adjust the timekeeper to correct that.
  */
-static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
-						 s64 error, s64 *interval,
-						 s64 *offset)
+static __always_inline void timekeeping_freqadjust(struct timekeeper *tk,
+						 s64 interval,
+						 s64 offset)
 {
 	s64 tick_error, i;
-	u32 look_ahead, adj;
-	s32 error2, mult;
+	u32 adj;
+	s32 mult = 1;
 
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
+	/* Calculate current error per tick */
+	tick_error = ntp_tick_length() >> tk->ntp_error_shift;
+	tick_error -= tk->xtime_interval;
 
-	/*
-	 * Now calculate the error in (1 << look_ahead) ticks, but first
-	 * remove the single look ahead already included in the error.
-	 */
-	tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
-	tick_error -= tk->xtime_interval >> 1;
-	error = ((error - tick_error) >> look_ahead) + tick_error;
+	/* Don't worry about correcting it if its small */
+	if (likely(abs(tick_error) < 2*interval))
+		return;
 
-	/* Finally calculate the adjustment shift value.  */
-	i = *interval;
-	mult = 1;
-	if (error < 0) {
-		error = -error;
-		*interval = -*interval;
-		*offset = -*offset;
-		mult = -1;
+	if (tick_error < 0) {
+		interval = -interval;
+		offset = -offset;
+		mult = -mult;
 	}
-	for (adj = 0; error > i; adj++)
-		error >>= 1;
 
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
+	/* Sort out the magnitude of the correction */
+	tick_error = abs(tick_error);
+	i = abs(interval);
+	for (adj = 0; tick_error > i; adj++)
+		tick_error >>= 1;
+
+	/* scale the corrections */
+	interval <<= adj;
+	offset <<= adj;
+	mult <<= adj;
+
+	/*
+	 * Apply the correction to the timekeeper.
+	 * See long comment in timekeeping_adjust to explain the math.
+	 */
+	tk->mult += mult;
+	tk->xtime_interval += interval;
+	tk->xtime_nsec -= offset;
+
 }
 
 /*
@@ -1108,65 +1104,23 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	s64 error, interval = tk->cycle_interval;
 	int adj;
 
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
+	/* First correct for the current frequency error */
+	timekeeping_freqadjust(tk, interval, offset);
+
+
+	/* Next make a small adjustment to fix any cumulative error */
+	error = tk->ntp_error >> tk->ntp_error_shift;
+	if (likely(abs(error) <= interval/2))
+		goto out_adjust;
+
+	if (error < 0) {
+		adj = -1;
+		interval = -interval;
+		offset = -offset;
+	} else
+		adj = 1;
+
 
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
@@ -1213,15 +1167,21 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
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
+
+	if (unlikely(tk->clock->maxadj &&
+		(tk->mult > tk->clock->mult + tk->clock->maxadj))) {
+		printk_once(KERN_WARNING
+			"Adjusting %s more than 11%% (%ld vs %ld)\n",
+			tk->clock->name, (long)tk->mult,
+			(long)tk->clock->mult + tk->clock->maxadj);
+	}
+
 	/*
 	 * It may be possible that when we entered this function, xtime_nsec
 	 * was very small.  Further, if we're slightly speeding the clocksource
@@ -1241,7 +1201,6 @@ out_adjust:
 		tk->xtime_nsec = 0;
 		tk->ntp_error += neg << tk->ntp_error_shift;
 	}
-
 }
 
 /**
-- 
1.8.3.2

