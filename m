Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbbAWAJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:09:49 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56404 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbbAWAJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 08/12] time: Add warnings when overflows or underflows are observed
Date: Thu, 22 Jan 2015 16:09:23 -0800
Message-Id: <1421971767-17707-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was suggested that the underflow/overflow protection
should probably throw some sort of warning out, rather
then just silently fixing the issue.

So this patch adds some warnings here. The flag variables
used are not protected by locks, but since we can't print
from the reading functions, just being able to say we
saw an issue in the update interval is useful enough,
and can be slightly racy without real consequnece.

The big complication is that we're only under a read
seqlock, so the data could shift under us during
our calcualtion to see if there was a problem. This
patch avoids this issue by nesting another seqlock
which allows us to snapshot the just required values
atomically. So we shouldn't see false positives.

I also added some basic ratelimiting here, since
on one build machine w/ skewed TSCs it was fairly
noisy at bootup.

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
 kernel/time/timekeeping.c | 58 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 568186c..d216b0e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -119,11 +119,23 @@ static inline void tk_update_sleep_time(struct timekeeper *tk, ktime_t delta)
 }
 
 #ifdef CONFIG_DEBUG_TIMEKEEPING
+#define WARNINGFREQ (HZ*300) /* 5 minute rate-limiting */
+/*
+ * These simple flag variables are managed
+ * without locks, which is racy, but ok since
+ * we don't really care about being super
+ * precise about how many events were seen,
+ * just that a problem was observed.
+ */
+static int timekeeping_underflow_seen;
+static int timekeeping_overflow_seen;
+
 static void timekeeping_check_update(struct timekeeper *tk, cycle_t offset)
 {
 
 	cycle_t max_cycles = tk->tkr.clock->max_cycles;
 	const char *name = tk->tkr.clock->name;
+	static long last_warning; /* we always hold write on timekeeper lock */
 
 	if (offset > max_cycles)
 		printk_deferred("ERROR: cycle offset (%lld) is larger then"
@@ -133,28 +145,60 @@ static void timekeeping_check_update(struct timekeeper *tk, cycle_t offset)
 		printk_deferred("WARNING: cycle offset (%lld) is past"
 			" the %s 50%% safety margin (%lld)\n",
 			offset, name, max_cycles>>1);
+
+	if (timekeeping_underflow_seen) {
+		if (jiffies - last_warning > WARNINGFREQ) {
+			printk_deferred("WARNING: Clocksource underflow observed\n");
+			last_warning = jiffies;
+		}
+		timekeeping_underflow_seen = 0;
+	}
+	if (timekeeping_overflow_seen) {
+		if (jiffies - last_warning > WARNINGFREQ) {
+			printk_deferred("WARNING: Clocksource overflow observed\n");
+			last_warning = jiffies;
+		}
+		timekeeping_overflow_seen = 0;
+	}
+
 }
 
 static inline cycle_t timekeeping_get_delta(struct tk_read_base *tkr)
 {
-	cycle_t cycle_now, delta;
+	cycle_t now, last, mask, max, delta;
+	unsigned int seq;
 
-	/* read clocksource */
-	cycle_now = tkr->read(tkr->clock);
+	/*
+	 * Since we're called holding a seqlock, the data may shift
+	 * under us while we're doign the calculation. This can cause
+	 * false positives, since we'd note a problem but throw the
+	 * results away. So nest  another seqlock here to atomically
+	 * grab the points we are checking with.
+	 */
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		now = tkr->read(tkr->clock);
+		last = tkr->cycle_last;
+		mask = tkr->mask;
+		max = tkr->clock->max_cycles;
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	/* calculate the delta since the last update_wall_time */
-	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
+	delta = clocksource_delta(now, last, mask);
 
 	/*
 	 * Try to catch underflows by checking if we are seeing small
 	 * mask-relative negative values.
 	 */
-	if (unlikely((~delta & tkr->mask) < (tkr->mask >> 3)))
+	if (unlikely((~delta & mask) < (mask >> 3))) {
+		timekeeping_underflow_seen = 1;
 		delta = 0;
+	}
 
 	/* Cap delta value to the max_cycles values to avoid mult overflows */
-	if (unlikely(delta > tkr->clock->max_cycles))
+	if (unlikely(delta > max)) {
+		timekeeping_overflow_seen = 1;
 		delta = tkr->clock->max_cycles;
+	}
 
 	return delta;
 }
-- 
1.9.1

