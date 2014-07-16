Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaGPVJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:09:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:59881 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbaGPVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:12 -0400
Message-Id: <20140716205056.877063606@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 55/64] clocksource: Make delta calculation a function
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=clocksource-make-delta-calculation-a-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to move the TSC sanity check into core code to make NMI safe
accessors to clock monotonic[_raw] possible. For this we need to
sanity check the delta calculation. Create a helper function and
convert all sites to use it.

[ Build fix from jstultz ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c          |   12 +++++++-----
 kernel/time/timekeeping.c          |   26 ++++++++++++++------------
 kernel/time/timekeeping_internal.h |    6 ++++++
 3 files changed, 27 insertions(+), 17 deletions(-)

Index: tip/kernel/time/clocksource.c
===================================================================
--- tip.orig/kernel/time/clocksource.c
+++ tip/kernel/time/clocksource.c
@@ -32,6 +32,7 @@
 #include <linux/kthread.h>
 
 #include "tick-internal.h"
+#include "timekeeping_internal.h"
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -249,7 +250,7 @@ void clocksource_mark_unstable(struct cl
 static void clocksource_watchdog(unsigned long data)
 {
 	struct clocksource *cs;
-	cycle_t csnow, wdnow;
+	cycle_t csnow, wdnow, delta;
 	int64_t wd_nsec, cs_nsec;
 	int next_cpu, reset_pending;
 
@@ -282,11 +283,12 @@ static void clocksource_watchdog(unsigne
 			continue;
 		}
 
-		wd_nsec = clocksource_cyc2ns((wdnow - cs->wd_last) & watchdog->mask,
-					     watchdog->mult, watchdog->shift);
+		delta = clocksource_delta(wdnow, cs->wd_last, watchdog->mask);
+		wd_nsec = clocksource_cyc2ns(delta, watchdog->mult,
+					     watchdog->shift);
 
-		cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last) &
-					     cs->mask, cs->mult, cs->shift);
+		delta = clocksource_delta(csnow, cs->cs_last, cs->mask);
+		cs_nsec = clocksource_cyc2ns(delta, cs->mult, cs->shift);
 		cs->cs_last = csnow;
 		cs->wd_last = wdnow;
 
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -173,7 +173,7 @@ static inline u32 arch_gettimeoffset(voi
 
 static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 {
-	cycle_t cycle_now, cycle_delta;
+	cycle_t cycle_now, delta;
 	struct clocksource *clock;
 	s64 nsec;
 
@@ -182,9 +182,9 @@ static inline s64 timekeeping_get_ns(str
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
 
-	nsec = cycle_delta * tk->mult + tk->xtime_nsec;
+	nsec = delta * tk->mult + tk->xtime_nsec;
 	nsec >>= tk->shift;
 
 	/* If arch requires, add in get_arch_timeoffset() */
@@ -193,7 +193,7 @@ static inline s64 timekeeping_get_ns(str
 
 static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 {
-	cycle_t cycle_now, cycle_delta;
+	cycle_t cycle_now, delta;
 	struct clocksource *clock;
 	s64 nsec;
 
@@ -202,10 +202,10 @@ static inline s64 timekeeping_get_ns_raw
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
 
 	/* convert delta to nanoseconds. */
-	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
 
 	/* If arch requires, add in get_arch_timeoffset() */
 	return nsec + arch_gettimeoffset();
@@ -336,23 +336,23 @@ static void timekeeping_update(struct ti
  */
 static void timekeeping_forward_now(struct timekeeper *tk)
 {
-	cycle_t cycle_now, cycle_delta;
+	cycle_t cycle_now, delta;
 	struct clocksource *clock;
 	s64 nsec;
 
 	clock = tk->clock;
 	cycle_now = clock->read(clock);
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);
 	tk->cycle_last = clock->cycle_last = cycle_now;
 
-	tk->xtime_nsec += cycle_delta * tk->mult;
+	tk->xtime_nsec += delta * tk->mult;
 
 	/* If arch requires, add in get_arch_timeoffset() */
 	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
 
 	tk_normalize_xtime(tk);
 
-	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
 	timespec64_add_ns(&tk->raw_time, nsec);
 }
 
@@ -1026,7 +1026,8 @@ static void timekeeping_resume(void)
 		u32 shift = clock->shift;
 		s64 nsec = 0;
 
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		cycle_delta = clocksource_delta(cycle_now, clock->cycle_last,
+						clock->mask);
 
 		/*
 		 * "cycle_delta * mutl" may cause 64 bits overflow, if the
@@ -1432,7 +1433,8 @@ void update_wall_time(void)
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = real_tk->cycle_interval;
 #else
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
+	offset = clocksource_delta(clock->read(clock), clock->cycle_last,
+				   clock->mask);
 #endif
 
 	/* Check if there's really nothing to do */
Index: tip/kernel/time/timekeeping_internal.h
===================================================================
--- tip.orig/kernel/time/timekeeping_internal.h
+++ tip/kernel/time/timekeeping_internal.h
@@ -3,6 +3,7 @@
 /*
  * timekeeping debug functions
  */
+#include <linux/clocksource.h>
 #include <linux/time.h>
 
 #ifdef CONFIG_DEBUG_FS
@@ -11,4 +12,9 @@ extern void tk_debug_account_sleep_time(
 #define tk_debug_account_sleep_time(x)
 #endif
 
+static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
+{
+	return (now - last) & mask;
+}
+
 #endif /* _TIMEKEEPING_INTERNAL_H */


