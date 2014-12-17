Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaLQMlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:41:25 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60399 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaLQMlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:41:23 -0500
From: Jianyu Zhan <nasa4836@gmail.com>
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] timekeeping: update raw_time with extra arch_gettimeoffset in timekeeping_forward_now
Date: Wed, 17 Dec 2014 20:40:28 +0800
Message-Id: <1418820028-16335-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, in timekeeping_forward_now, we just use delta nsecs from
clocksource to update raw_time; however, in getnstime_raw_and_real,
getrawmonotonic64, etc, raw_time has slightly diffrent meaning: it not
only counts the raw monotonic raw time, but also with arch_gettimeoffset,
by using the timekeeping_get_ns_raw helper.

This patch unifies the meaning of raw_time. Also, it cleanups the
timekeeping_get_ns_raw helper, to make timekeeping_get_ns and
timekeeping_forward_now based on it.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 kernel/time/timekeeping.c | 52 ++++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..1348c9c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -191,41 +191,32 @@ u32 (*arch_gettimeoffset)(void) = default_arch_gettimeoffset;
 static inline u32 arch_gettimeoffset(void) { return 0; }
 #endif
 
-static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
+static inline s64 timekeeping_get_ns_raw(struct tk_read_base *tkr,
+					bool update_cycle)
 {
+	struct clocksource *clock = tkr->clock;
 	cycle_t cycle_now, delta;
 	s64 nsec;
 
 	/* read clocksource: */
-	cycle_now = tkr->read(tkr->clock);
+	cycle_now = tkr->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
 	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
+	if (update_cycle)
+		tkr->cycle_last = cycle_now;
 
-	nsec = delta * tkr->mult + tkr->xtime_nsec;
-	nsec >>= tkr->shift;
+	/* convert delta to nanoseconds. */
+	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
 
-	/* If arch requires, add in get_arch_timeoffset() */
+	/* If arch requires, add in arch_gettimeoffset() */
 	return nsec + arch_gettimeoffset();
 }
 
-static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
+static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
 {
-	struct clocksource *clock = tk->tkr.clock;
-	cycle_t cycle_now, delta;
-	s64 nsec;
-
-	/* read clocksource: */
-	cycle_now = tk->tkr.read(clock);
-
-	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
-
-	/* convert delta to nanoseconds. */
-	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
-
-	/* If arch requires, add in get_arch_timeoffset() */
-	return nsec + arch_gettimeoffset();
+	return timekeeping_get_ns_raw(tkr, false) +
+		(tkr->xtime_nsec >> tkr->shift);
 }
 
 /**
@@ -474,22 +465,13 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
  */
 static void timekeeping_forward_now(struct timekeeper *tk)
 {
-	struct clocksource *clock = tk->tkr.clock;
-	cycle_t cycle_now, delta;
 	s64 nsec;
 
-	cycle_now = tk->tkr.read(clock);
-	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
-	tk->tkr.cycle_last = cycle_now;
-
-	tk->tkr.xtime_nsec += delta * tk->tkr.mult;
-
-	/* If arch requires, add in get_arch_timeoffset() */
-	tk->tkr.xtime_nsec += (u64)arch_gettimeoffset() << tk->tkr.shift;
+	nsec = timekeeping_get_ns_raw(&tk->tkr, true);
+	tk->tkr.xtime_nsec += nsec << tk->tkr.shift;
 
 	tk_normalize_xtime(tk);
 
-	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
 	timespec64_add_ns(&tk->raw_time, nsec);
 }
 
@@ -619,7 +601,7 @@ ktime_t ktime_get_raw(void)
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
 		base = tk->base_raw;
-		nsecs = timekeeping_get_ns_raw(tk);
+		nsecs = timekeeping_get_ns_raw(&tk->tkr, false);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
@@ -732,7 +714,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		ts_real->tv_sec = tk->xtime_sec;
 		ts_real->tv_nsec = 0;
 
-		nsecs_raw = timekeeping_get_ns_raw(tk);
+		nsecs_raw = timekeeping_get_ns_raw(&tk->tkr, false);
 		nsecs_real = timekeeping_get_ns(&tk->tkr);
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
@@ -966,7 +948,7 @@ void getrawmonotonic64(struct timespec64 *ts)
 
 	do {
 		seq = read_seqcount_begin(&tk_core.seq);
-		nsecs = timekeeping_get_ns_raw(tk);
+		nsecs = timekeeping_get_ns_raw(&tk->tkr, false);
 		ts64 = tk->raw_time;
 
 	} while (read_seqcount_retry(&tk_core.seq, seq));
-- 
2.0.0

