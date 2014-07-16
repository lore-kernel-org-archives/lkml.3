Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaGPVII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:08:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:59901 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaGPVFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:17 -0400
Message-Id: <20140716205057.125218732@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 58/64] timekeeping: Restructure the timekeeper some more
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-restructure-some-more.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access to time requires to touch two cachelines at minimum

   1) The timekeeper data structure

   2) The clocksource data structure

The access to the clocksource data structure can be avoided as almost
all clocksource implementations ignore the argument to the read
callback, which is a pointer to the clocksource.

But the core needs to touch it to access the members @read and @mask.

So we are better off by copying the @read function pointer and the
@mask from the clocksource to the core data structure itself.

For the most used ktime_get() access all required data including the
@read and @mask copies fits together with the sequence counter into a
single 64 byte cacheline.

For the other time access functions we touch in the current code three
cache lines in the worst case. But with the clocksource data copies we
can reduce that to two adjacent cachelines, which is more efficient
than disjunct cache lines.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |    4 ++++
 kernel/time/timekeeping.c           |   35 +++++++++++++++--------------------
 2 files changed, 19 insertions(+), 20 deletions(-)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -29,6 +29,10 @@
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
 	struct clocksource	*clock;
+	/* Read function of @clock */
+	cycle_t			(*read)(struct clocksource *cs);
+	/* Bitmask for two's complement subtraction of non 64bit counters */
+	cycle_t			mask;
 	/* Last cycle value */
 	cycle_t			cycle_last;
 	/* NTP adjusted clock multiplier */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -121,7 +121,9 @@ static void tk_setup_internals(struct ti
 
 	old_clock = tk->clock;
 	tk->clock = clock;
-	tk->cycle_last = clock->read(clock);
+	tk->read = clock->read;
+	tk->mask = clock->mask;
+	tk->cycle_last = tk->read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -174,15 +176,13 @@ static inline u32 arch_gettimeoffset(voi
 static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 {
 	cycle_t cycle_now, delta;
-	struct clocksource *clock;
 	s64 nsec;
 
 	/* read clocksource: */
-	clock = tk->clock;
-	cycle_now = clock->read(clock);
+	cycle_now = tk->read(tk->clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tk->cycle_last, clock->mask);
+	delta = clocksource_delta(cycle_now, tk->cycle_last, tk->mask);
 
 	nsec = delta * tk->mult + tk->xtime_nsec;
 	nsec >>= tk->shift;
@@ -193,16 +193,15 @@ static inline s64 timekeeping_get_ns(str
 
 static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 {
+	struct clocksource *clock = tk->clock;
 	cycle_t cycle_now, delta;
-	struct clocksource *clock;
 	s64 nsec;
 
 	/* read clocksource: */
-	clock = tk->clock;
-	cycle_now = clock->read(clock);
+	cycle_now = tk->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	delta = clocksource_delta(cycle_now, tk->cycle_last, clock->mask);
+	delta = clocksource_delta(cycle_now, tk->cycle_last, tk->mask);
 
 	/* convert delta to nanoseconds. */
 	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
@@ -337,13 +336,12 @@ static void timekeeping_update(struct ti
  */
 static void timekeeping_forward_now(struct timekeeper *tk)
 {
+	struct clocksource *clock = tk->clock;
 	cycle_t cycle_now, delta;
-	struct clocksource *clock;
 	s64 nsec;
 
-	clock = tk->clock;
-	cycle_now = clock->read(clock);
-	delta = clocksource_delta(cycle_now, tk->cycle_last, clock->mask);
+	cycle_now = tk->read(clock);
+	delta = clocksource_delta(cycle_now, tk->cycle_last, tk->mask);
 	tk->cycle_last = cycle_now;
 
 	tk->xtime_nsec += delta * tk->mult;
@@ -1019,7 +1017,7 @@ static void timekeeping_resume(void)
 	 * The less preferred source will only be tried if there is no better
 	 * usable source. The rtc part is handled separately in rtc core code.
 	 */
-	cycle_now = clock->read(clock);
+	cycle_now = tk->read(clock);
 	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
 		cycle_now > tk->cycle_last) {
 		u64 num, max = ULLONG_MAX;
@@ -1028,7 +1026,7 @@ static void timekeeping_resume(void)
 		s64 nsec = 0;
 
 		cycle_delta = clocksource_delta(cycle_now, tk->cycle_last,
-						clock->mask);
+						tk->mask);
 
 		/*
 		 * "cycle_delta * mutl" may cause 64 bits overflow, if the
@@ -1415,7 +1413,6 @@ static cycle_t logarithmic_accumulation(
  */
 void update_wall_time(void)
 {
-	struct clocksource *clock;
 	struct timekeeper *real_tk = &tk_core.timekeeper;
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
@@ -1429,13 +1426,11 @@ void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = real_tk->clock;
-
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = real_tk->cycle_interval;
 #else
-	offset = clocksource_delta(clock->read(clock), tk->cycle_last,
-				   clock->mask);
+	offset = clocksource_delta(tk->read(tk->clock), tk->cycle_last,
+				   tk->mask);
 #endif
 
 	/* Check if there's really nothing to do */


