Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab3LGWQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 17:16:48 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37037 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759176Ab3LGWQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:16:44 -0500
Message-ID: <52A39E49.6040501@linaro.org>
Date: Sat, 07 Dec 2013 14:16:41 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Miroslav Lichvar <mlichvar@redhat.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com> <528A7C88.1030801@linaro.org> <20131120183900.GA25735@localhost> <529D2BA6.5020005@linaro.org> <529D5805.20903@linaro.org> <20131206142602.GH22878@localhost> <52A27D51.1040805@linaro.org> <20131207175610.GA7198@netboy>
In-Reply-To: <20131207175610.GA7198@netboy>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------030509040108020001000106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030509040108020001000106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/07/2013 09:56 AM, Richard Cochran wrote:
> On Fri, Dec 06, 2013 at 05:43:45PM -0800, John Stultz wrote:
>> Anyway, let me know what you think and I'll run some tests on it this
>> weekend.
>>
>> thanks
>> -john
>>
>>
>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index 3abf534..bfb36fd 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -1056,42 +1056,24 @@ static __always_inline int
>> timekeeping_bigadjust(struct timekeeper *tk,
>>                           s64 *offset)
> John,
>
> Any chance of posting this against a normal kernel?  I am preparing
> "real" tests comparing the three different patches in this thread on
> v3.12.3, but this one does not apply.

Sorry about that. :(  About half the time I try pasting in a patch,
thunderbird seems to decide to ignore the preformat setting and corrupts
whitespace in the patch.

Anyway, patch is attached. Many thanks for the additional testing and
review!

thanks
-john

--------------030509040108020001000106
Content-Type: text/x-diff;
 name="0001-reworking-bigadjust-for-nohz.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-reworking-bigadjust-for-nohz.patch"

>From 3fbbd9ade38419245af22902a98ea221e7b36c94 Mon Sep 17 00:00:00 2001
From: John Stultz <john.stultz@linaro.org>
Date: Fri, 6 Dec 2013 17:25:21 -0800
Subject: [PATCH] my first attempt at reworking bigadjust for nohz

Takes a similar approach as Miroslav's but using the bigadjust method.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 80 +++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 58 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 947ba25..46f4bd2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1056,42 +1056,24 @@ static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
 						 s64 *offset)
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
+	/* Calculate current tick error */
+	tick_error = ntp_tick_length() >> (tk->ntp_error_shift );
+	tick_error -= tk->xtime_interval;
 
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
+	if (tick_error < 0) {
 		*interval = -*interval;
 		*offset = -*offset;
-		mult = -1;
+		mult = -mult;
 	}
-	for (adj = 0; error > i; adj++)
-		error >>= 1;
+
+	/* Sort out the magnitude of the correction */
+	tick_error = abs(tick_error);
+	i = abs(*interval);
+	for (adj = 0; tick_error > i; adj++)
+		tick_error >>= 1;
 
 	*interval <<= adj;
 	*offset <<= adj;
@@ -1114,41 +1096,23 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	 *
 	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
 	 *
-	 * Note we subtract one in the shift, so that error is really error*2.
-	 * This "saves" dividing(shifting) interval twice, but keeps the
-	 * (error > interval) comparison as still measuring if error is
-	 * larger than half an interval.
-	 *
-	 * Note: It does not "save" on aggravation when reading the code.
+	 * Then we meausre if error is larger than half an interval.
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
+	error = tk->ntp_error >> (tk->ntp_error_shift);
+	if (error > interval/2) {
 		/*
-		 * XXX - In update_wall_time, we round up to the next
-		 * nanosecond, and store the amount rounded up into
-		 * the error. This causes the likely below to be unlikely.
-		 *
-		 * The proper fix is to avoid rounding up by using
-		 * the high precision tk->xtime_nsec instead of
-		 * xtime.tv_nsec everywhere. Fixing this will take some
-		 * time.
+		 * We now checks if the error is greater than twice the
+		 * interval. If it is greater, we need a bigadjust, if its
+		 * smaller, we can adjust by 1.
 		 */
-		if (likely(error <= interval))
+		if (likely(error <= interval*2))
 			adj = 1;
 		else
 			adj = timekeeping_bigadjust(tk, error, &interval, &offset);
 	} else {
-		if (error < -interval) {
+		if (error < -interval/2) {
 			/* See comment above, this is just switched for the negative */
-			error >>= 2;
-			if (likely(error >= -interval)) {
+			if (likely(error >= -interval*2)) {
 				adj = -1;
 				interval = -interval;
 				offset = -offset;
-- 
1.8.3.2


--------------030509040108020001000106--
