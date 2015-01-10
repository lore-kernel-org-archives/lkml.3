Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbbAJAg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:36:29 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56946 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbbAJAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:34:42 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/10] time: Cap clocksource reads to the clocksource max_cycles value
Date: Fri,  9 Jan 2015 16:34:24 -0800
Message-Id: <1420850068-27828-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating the current delta since the last tick, we
currently have no hard protections to prevent a multiplciation
overflow from ocurring.

This patch introduces such a cap that limits the read delta
value to the max_cycles value, which is where an overflow would
occur.

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
 kernel/time/timekeeping.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0dcceba..9740fd8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -202,6 +202,9 @@ static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
 	/* calculate the delta since the last update_wall_time: */
 	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
 
+	/* Cap delta value to the max_cycles values to avoid mult overflows */
+	delta = min(delta, tkr->clock->max_cycles);
+
 	nsec = delta * tkr->mult + tkr->xtime_nsec;
 	nsec >>= tkr->shift;
 
@@ -221,6 +224,9 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	/* calculate the delta since the last update_wall_time: */
 	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
 
+	/* Cap delta value to the max_cycles values to avoid mult overflows */
+	delta = min(delta, tk->tkr.clock->max_cycles);
+
 	/* convert delta to nanoseconds. */
 	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
 
@@ -482,6 +488,9 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
 	tk->tkr.cycle_last = cycle_now;
 
+	/* Cap delta value to the max_cycles values to avoid mult overflows */
+	delta = min(delta, tk->tkr.clock->max_cycles);
+
 	tk->tkr.xtime_nsec += delta * tk->tkr.mult;
 
 	/* If arch requires, add in get_arch_timeoffset() */
-- 
1.9.1

