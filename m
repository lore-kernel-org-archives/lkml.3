Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab3CEC2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:28:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:20408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab3CEC20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:28:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="scan'208";a="293621023"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [RFC PATCH v2 4/4] timekeeping: utilize the suspend-nonstop clocksource to count suspended time
Date: Tue,  5 Mar 2013 10:27:06 +0800
Message-Id: <1362450426-4232-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some new processors whose TSC clocksource won't stop during
suspend. Currently, after system resumes, kernel will use persistent
clock or RTC to compensate the sleep time, but for those new types of
clocksources, we could skip the special compensation from external
sources, and just use current clocksource for time recounting.

This can solve some time drift bugs caused by some not-so-accurate or
error-prone RTC devices.

The current way to count suspened time is first try to use the persistent
clock, and then try the rtc if persistent clock can't be used. This
patch will change the trying order to:
	suspend-nonstop clocksource -> persistent clock -> rtc

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/time/timekeeping.c |   57 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 9a0bc98..15cc086 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -788,22 +788,63 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 static void timekeeping_resume(void)
 {
 	struct timekeeper *tk = &timekeeper;
+	struct clocksource *clock = tk->clock;
 	unsigned long flags;
-	struct timespec ts;
+	struct timespec ts_new, ts_delta;
+	cycle_t cycle_now, cycle_delta;
+	s64 nsec;
 
-	read_persistent_clock(&ts);
+	ts_delta.tv_sec = 0;
+	read_persistent_clock(&ts_new);
 
 	clockevents_resume();
 	clocksource_resume();
 
 	write_seqlock_irqsave(&tk->lock, flags);
 
-	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
-		ts = timespec_sub(ts, timekeeping_suspend_time);
-		__timekeeping_inject_sleeptime(tk, &ts);
-	}
-	/* re-base the last cycle value */
-	tk->clock->cycle_last = tk->clock->read(tk->clock);
+	/*
+	 * After system resumes, we need to calculate the suspended time and
+	 * compensate it for the OS time. There are 3 sources that could be
+	 * used: Nonstop clocksource during suspend, persistent clock and rtc
+	 * device.
+	 *
+	 * One specific platform may have 1 or 2 or all of them, and the
+	 * preference will be:
+	 *	suspend-nonstop clocksource > persistent clock > rtc
+	 * The less preferred source will only be tried if there is no better
+	 * usable source. The rtc part is handled separately in rtc core code.
+	 */
+	cycle_now = clock->read(clock);
+	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NOTSTOP) &&
+		cycle_now > clock->cycle_last) {
+
+		u64 max_cycles;
+		u32 mult = clock->mult;
+		u32 shift = clock->shift;
+
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		/*
+		 * The system suspended time and the delta cycles may be very
+		 * long, so we can't call clocksource_cyc2ns() directly with
+		 * clocksource's default mult and shift to avoid overflow.
+		 */
+		max_cycles = 1ULL << (63 - (ilog2(mult) + 1));
+		while (cycle_delta > max_cycles) {
+			max_cycles <<= 1;
+			mult >>= 1;
+			shift--;
+		}
+
+		nsec = clocksource_cyc2ns(cycle_delta, mult, shift);
+		ts_delta = ns_to_timespec(nsec);
+	} else if (timespec_compare(&ts_new, &timekeeping_suspend_time) > 0)
+		ts_delta = timespec_sub(ts_new, timekeeping_suspend_time);
+
+	if (ts_delta.tv_sec >= 1)
+		__timekeeping_inject_sleeptime(tk, &ts_delta);
+
+	/* Re-base the last cycle value */
+	clock->cycle_last = clock->read(clock);
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, false);
-- 
1.7.0.4

