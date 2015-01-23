Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbbAWAMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:12:40 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42216 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbbAWAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:35 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 02/12] clocksource: Simplify logic around clocksource wrapping saftey margins
Date: Thu, 22 Jan 2015 16:09:17 -0800
Message-Id: <1421971767-17707-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource logic has a number of places where we try to
include a safety margin. Most of these are 12% safety margins,
but they are inconsistently applied and sometimes are applied
on top of each other.

Additionally, in the previous patch, we corrected an issue
where we unintentionally in effect created a 50% saftey margin,
which these 12.5% margins where then added to.

So to siplify the logic here, this patch removes the various
12.5% margins, and consolidates adding the margin in one place:
clocks_calc_max_nsecs().

Addtionally, Linus prefers a 50% safety margin, as it allows
bad clock values to be more easily caught. This should really
have no net effect, due to the corrected issue earlier which
caused greater then 50% margins to be used w/o issue.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Stephen Boyd <sboyd@codeaurora.org> (for sched_clock.c bit)
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/clocksource.c | 26 ++++++++++++--------------
 kernel/time/sched_clock.c |  4 ++--
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c14cd03..e837ffd1 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -545,6 +545,9 @@ static u32 clocksource_max_adjustment(struct clocksource *cs)
  * @shift:	cycle to nanosecond divisor (power of two)
  * @maxadj:	maximum adjustment value to mult (~11%)
  * @mask:	bitmask for two's complement subtraction of non 64 bit counters
+ *
+ * NOTE: This function includes a saftey margin of 50%, so that bad clock values
+ * can be detected.
  */
 u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
 {
@@ -566,11 +569,14 @@ u64 clocks_calc_max_nsecs(u32 mult, u32 shift, u32 maxadj, u64 mask)
 	max_cycles = min(max_cycles, mask);
 	max_nsecs = clocksource_cyc2ns(max_cycles, mult - maxadj, shift);
 
+	/* Return 50% of the actual maximum, so we can detect bad values */
+	max_nsecs >>= 1;
+
 	return max_nsecs;
 }
 
 /**
- * clocksource_max_deferment - Returns max time the clocksource can be deferred
+ * clocksource_max_deferment - Returns max time the clocksource should be deferred
  * @cs:         Pointer to clocksource
  *
  */
@@ -580,13 +586,7 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 
 	max_nsecs = clocks_calc_max_nsecs(cs->mult, cs->shift, cs->maxadj,
 					  cs->mask);
-	/*
-	 * To ensure that the clocksource does not wrap whilst we are idle,
-	 * limit the time the clocksource can be deferred by 12.5%. Please
-	 * note a margin of 12.5% is used because this can be computed with
-	 * a shift, versus say 10% which would require division.
-	 */
-	return max_nsecs - (max_nsecs >> 3);
+	return max_nsecs;
 }
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
@@ -735,10 +735,9 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 	 * conversion precision. 10 minutes is still a reasonable
 	 * amount. That results in a shift value of 24 for a
 	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
-	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
-	 * margin as we do in clocksource_max_deferment()
+	 * ~ 0.06ppm granularity for NTP.
 	 */
-	sec = (cs->mask - (cs->mask >> 3));
+	sec = cs->mask;
 	do_div(sec, freq);
 	do_div(sec, scale);
 	if (!sec)
@@ -750,9 +749,8 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 			       NSEC_PER_SEC / scale, sec * scale);
 
 	/*
-	 * for clocksources that have large mults, to avoid overflow.
-	 * Since mult may be adjusted by ntp, add an safety extra margin
-	 *
+	 * Ensure clocksources that have large mults don't overflow
+	 * when adjusted.
 	 */
 	cs->maxadj = clocksource_max_adjustment(cs);
 	while ((cs->mult + cs->maxadj < cs->mult)
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 01d2d15..c794b84 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -125,9 +125,9 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 
 	new_mask = CLOCKSOURCE_MASK(bits);
 
-	/* calculate how many ns until we wrap */
+	/* calculate how many ns until we risk wrapping */
 	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
-	new_wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
+	new_wrap_kt = ns_to_ktime(wrap);
 
 	/* update epoch for new counter and update epoch_ns from old counter*/
 	new_epoch = read();
-- 
1.9.1

