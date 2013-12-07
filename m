Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3LGBnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:43:51 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57799 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3LGBnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:43:49 -0500
Message-ID: <52A27D51.1040805@linaro.org>
Date: Fri, 06 Dec 2013 17:43:45 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com> <528A7C88.1030801@linaro.org> <20131120183900.GA25735@localhost> <529D2BA6.5020005@linaro.org> <529D5805.20903@linaro.org> <20131206142602.GH22878@localhost>
In-Reply-To: <20131206142602.GH22878@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 06:26 AM, Miroslav Lichvar wrote:
> This graph shows the value of tk->mult as it changes with clock
> updates:
> http://mlichvar.fedorapeople.org/tmp/tk_test1.png
>
> When the TSC frequency is set to 100 MHz, it becomes more pronounced:
> http://mlichvar.fedorapeople.org/tmp/tk_test2.png
>
> I'm worried about the artifacts in the response, is that a bug?

So now being able to reproduce this, I can see the jaggy
artifacts/discontinuities in the mult curve are basically where the
look_ahead logic is being adjusted.

My understanding is the lookahead bit is trying to evaluate the order of
magnitude in error and use that to dampen the adjustment. This means
when we have large errors, we adjust more slowly. When we have small
errors we can adjust more quickly.

So each discontinuity, you're basically seeing the dampening effect
decreased, causing the adjustment slope to increase.


Being that the bigadjust code, and specifically this lookahead bit, has
always been the most opaque logic to me, I figured I'd spend some time
looking at alternatives, and came up with one approach that tries to
mimic your patch, but tries to be more in line with the existing logic.

It seems to do fairly well in the simulator:
n: 30, slope: 1.00 (1.00 GHz), dev: 3.2 ns, max: 3.6 ns, freq: -99.95677 ppm

Basically in the big-error case, we calculate the adjustment from the
current tick error (and the assumption is that is where the majority of
the large error is coming from), leaving the normal +1/-1 adjustments to
the cumulative error.

But I'm a little worried its maybe too reactive, focusing really only on
the per-tick error magnitude, so I'm not sure how it will handle real
world ntp fluctuation or things like granularity error.

I also went through and removed some of the over-optimization that the
compiler should handle, so the code is a bit more readable.

Anyway, let me know what you think and I'll run some tests on it this
weekend.

thanks
-john


diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3abf534..bfb36fd 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1056,42 +1056,24 @@ static __always_inline int
timekeeping_bigadjust(struct timekeeper *tk,
                          s64 *offset)
 {
     s64 tick_error, i;
-    u32 look_ahead, adj;
-    s32 error2, mult;
+    u32 adj;
+    s32 mult = 1;
 
-    /*
-     * Use the current error value to determine how much to look ahead.
-     * The larger the error the slower we adjust for it to avoid problems
-     * with losing too many ticks, otherwise we would overadjust and
-     * produce an even larger error.  The smaller the adjustment the
-     * faster we try to adjust for it, as lost ticks can do less harm
-     * here.  This is tuned so that an error of about 1 msec is adjusted
-     * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
-     */
-    error2 = tk->ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
-    error2 = abs(error2);
-    for (look_ahead = 0; error2 > 0; look_ahead++)
-        error2 >>= 2;
+    /* Calculate current tick error */
+    tick_error = ntp_tick_length() >> (tk->ntp_error_shift );
+    tick_error -= tk->xtime_interval;
 
-    /*
-     * Now calculate the error in (1 << look_ahead) ticks, but first
-     * remove the single look ahead already included in the error.
-     */
-    tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
-    tick_error -= tk->xtime_interval >> 1;
-    error = ((error - tick_error) >> look_ahead) + tick_error;
-
-    /* Finally calculate the adjustment shift value.  */
-    i = *interval;
-    mult = 1;
-    if (error < 0) {
-        error = -error;
+    if (tick_error < 0) {
         *interval = -*interval;
         *offset = -*offset;
-        mult = -1;
+        mult = -mult;
     }
-    for (adj = 0; error > i; adj++)
-        error >>= 1;
+
+    /* Sort out the magnitude of the correction */
+    tick_error = abs(tick_error);
+    i = abs(*interval);
+    for (adj = 0; tick_error > i; adj++)
+        tick_error >>= 1;
 
     *interval <<= adj;
     *offset <<= adj;
@@ -1114,41 +1096,23 @@ static void timekeeping_adjust(struct timekeeper
*tk, s64 offset)
      *
      * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
      *
-     * Note we subtract one in the shift, so that error is really error*2.
-     * This "saves" dividing(shifting) interval twice, but keeps the
-     * (error > interval) comparison as still measuring if error is
-     * larger than half an interval.
-     *
-     * Note: It does not "save" on aggravation when reading the code.
+     * Then we meausre if error is larger than half an interval.
      */
-    error = tk->ntp_error >> (tk->ntp_error_shift - 1);
-    if (error > interval) {
-        /*
-         * We now divide error by 4(via shift), which checks if
-         * the error is greater than twice the interval.
-         * If it is greater, we need a bigadjust, if its smaller,
-         * we can adjust by 1.
-         */
-        error >>= 2;
+    error = tk->ntp_error >> (tk->ntp_error_shift);
+    if (error > interval/2) {
         /*
-         * XXX - In update_wall_time, we round up to the next
-         * nanosecond, and store the amount rounded up into
-         * the error. This causes the likely below to be unlikely.
-         *
-         * The proper fix is to avoid rounding up by using
-         * the high precision tk->xtime_nsec instead of
-         * xtime.tv_nsec everywhere. Fixing this will take some
-         * time.
+         * We now checks if the error is greater than twice the
+         * interval. If it is greater, we need a bigadjust, if its
+         * smaller, we can adjust by 1.
          */
-        if (likely(error <= interval))
+        if (likely(error <= interval*2))
             adj = 1;
         else
             adj = timekeeping_bigadjust(tk, error, &interval, &offset);
     } else {
-        if (error < -interval) {
+        if (error < -interval/2) {
             /* See comment above, this is just switched for the negative */
-            error >>= 2;
-            if (likely(error >= -interval)) {
+            if (likely(error >= -interval*2)) {
                 adj = -1;
                 interval = -interval;
                 offset = -offset;

