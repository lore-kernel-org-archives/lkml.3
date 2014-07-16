Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaGPVLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:11:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:59832 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaGPVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:58 -0400
Message-Id: <20140716205056.097335867@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 46/64] timekeeping: Use ktime_get_boottime() for
 get_monotonic_boottime()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-simplify-get-monotonic-boottime.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_monotonic_boottime() is not used in fast pathes, so the extra
timespec conversion is not problematic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |    9 ++++++++-
 kernel/time/timekeeping.c   |   34 ----------------------------------
 2 files changed, 8 insertions(+), 35 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -27,7 +27,6 @@ struct timespec __current_kernel_time(vo
  */
 struct timespec get_monotonic_coarse(void);
 extern void getrawmonotonic(struct timespec *ts);
-extern void get_monotonic_boottime(struct timespec *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
 
 extern int __getnstimeofday64(struct timespec64 *tv);
@@ -160,6 +159,14 @@ static inline u64 ktime_get_boot_ns(void
 }
 
 /*
+ * Timespec interfaces utilizing the ktime based ones
+ */
+static inline void get_monotonic_boottime(struct timespec *ts)
+{
+	*ts = ktime_to_timespec(ktime_get_boottime());
+}
+
+/*
  * RTC specific
  */
 extern void timekeeping_inject_sleeptime(struct timespec *delta);
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1536,40 +1536,6 @@ void getboottime(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(getboottime);
 
-/**
- * get_monotonic_boottime - Returns monotonic time since boot
- * @ts:		pointer to the timespec to be set
- *
- * Returns the monotonic time since boot in a timespec.
- *
- * This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
- * includes the time spent in suspend.
- */
-void get_monotonic_boottime(struct timespec *ts)
-{
-	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 tomono, sleep, ret;
-	s64 nsec;
-	unsigned int seq;
-
-	WARN_ON(timekeeping_suspended);
-
-	do {
-		seq = read_seqcount_begin(&tk_core.seq);
-		ret.tv_sec = tk->xtime_sec;
-		nsec = timekeeping_get_ns(tk);
-		tomono = tk->wall_to_monotonic;
-		sleep = tk->total_sleep_time;
-
-	} while (read_seqcount_retry(&tk_core.seq, seq));
-
-	ret.tv_sec += tomono.tv_sec + sleep.tv_sec;
-	ret.tv_nsec = 0;
-	timespec64_add_ns(&ret, nsec + tomono.tv_nsec + sleep.tv_nsec);
-	*ts = timespec64_to_timespec(ret);
-}
-EXPORT_SYMBOL_GPL(get_monotonic_boottime);
-
 unsigned long get_seconds(void)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;


