Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbbAWALr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:11:47 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34126 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbbAWAJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:40 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/12] time: Add infrastructure to cap clocksource reads to the max_cycles value
Date: Thu, 22 Jan 2015 16:09:21 -0800
Message-Id: <1421971767-17707-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating the current delta since the last tick, we
currently have no hard protections to prevent a multiplciation
overflow from ocurring.

This patch introduces infrastructure to allow a capp that
limits the read delta value to the max_cycles value, which is
where an overflow would occur.

Since this is in the hotpath, it adds the extra checking under
CONFIG_DEBUG_TIMEKEEPING.

There was some concern that capping time like this could cause
problems as we may stop expiring timers, which could go circular
if the timer that triggers time accumulation were misscheduled
too far in the future, which would cause time to stop.

However, since the mult overflow would result in a smaller time
value, we would effectively have the same problem there.

Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index daa0d43..ae3945d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -134,8 +134,31 @@ static void timekeeping_check_update(struct timekeeper *tk, cycle_t offset)
 			" the %s 50%% safety margin (%lld)\n",
 			offset, name, max_cycles>>1);
 }
+
+static inline cycle_t timekeeping_get_delta(struct tk_read_base *tkr)
+{
+	cycle_t cycle_now, delta;
+
+	/* read clocksource */
+	cycle_now = tkr->read(tkr->clock);
+
+	/* calculate the delta since the last update_wall_time */
+	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
+
+	/* Cap delta value to the max_cycles values to avoid mult overflows */
+	if (unlikely(delta > tkr->clock->max_cycles))
+		delta = tkr->clock->max_cycles;
+
+	return delta;
+}
 #else
 #define timekeeping_check_update(x, y)
+static inline cycle_t timekeeping_get_delta(struct tk_read_base *tkr)
+{
+	/* calculate the delta since the last update_wall_time */
+	return clocksource_delta(tkr->read(tkr->clock), tkr->cycle_last,
+								tkr->mask);
+}
 #endif
 
 /**
@@ -213,14 +236,10 @@ static inline u32 arch_gettimeoffset(void) { return 0; }
 
 static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
 {
-	cycle_t cycle_now, delta;
+	cycle_t delta;
 	s64 nsec;
 
-	/* read clocksource: */
-	cycle_now = tkr->read(tkr->clock);
-
-	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
+	delta = timekeeping_get_delta(tkr);
 
 	nsec = delta * tkr->mult + tkr->xtime_nsec;
 	nsec >>= tkr->shift;
@@ -232,14 +251,10 @@ static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
 static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 {
 	struct clocksource *clock = tk->tkr.clock;
-	cycle_t cycle_now, delta;
+	cycle_t delta;
 	s64 nsec;
 
-	/* read clocksource: */
-	cycle_now = tk->tkr.read(clock);
-
-	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
+	delta = timekeeping_get_delta(&tk->tkr);
 
 	/* convert delta to nanoseconds. */
 	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
-- 
1.9.1

