Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3AUGjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:39:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:39002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3AUGjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:39:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="scan'208";a="193316359"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [RFC PATCH 5/5] timekeeping: Add support for clocksource which doesn't stop during suspend
Date: Mon, 21 Jan 2013 14:38:45 +0800
Message-Id: <1358750325-21217-6-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some new processors whose TSC clocksource won't stop during
suspend. Currently, after system resumes from sleep state, kernel will
use persistent clock or RTC to compensate the sleep time, but for those
new types of clocksources, we could skip the special compensation from
external sources, and just use current clocksource for recounting.

This can solve some time drift bugs caused by the not-so-accurate RTC
devices.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/time/timekeeping.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cbc6acb..628c9ba 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -749,22 +749,36 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 static void timekeeping_resume(void)
 {
 	struct timekeeper *tk = &timekeeper;
+	struct clocksource *clock = tk->clock;
 	unsigned long flags;
 	struct timespec ts;
+	cycle_t cycle_now, cycle_delta;
+	s64 nsec;
 
 	read_persistent_clock(&ts);
-
 	clockevents_resume();
 	clocksource_resume();
 
 	write_seqlock_irqsave(&tk->lock, flags);
 
-	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
+	if (clock->flags & CLOCK_SOURCE_SUSPEND_NOTSTOP) {
+		cycle_now = clock->read(clock);
+		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		clock->cycle_last = cycle_now;
+
+		nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+		ts = ns_to_timespec(nsec);
+	} else if (timespec_compare(&ts, &timekeeping_suspend_time) > 0)
 		ts = timespec_sub(ts, timekeeping_suspend_time);
-		__timekeeping_inject_sleeptime(tk, &ts);
+	else {
+		ts.tv_sec = 0;
+		ts.tv_nsec = 0;
 	}
+
+	__timekeeping_inject_sleeptime(tk, &ts);
+
 	/* re-base the last cycle value */
-	tk->clock->cycle_last = tk->clock->read(tk->clock);
+	clock->cycle_last = clock->read(clock);
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, false);
@@ -1134,7 +1148,6 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
 #endif
 
 
-
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
-- 
1.7.9.5

