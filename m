Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaGPVEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:59631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaGPVEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:06 -0400
Message-Id: <20140716205053.102591822@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 11/64] timekeeping: Provide timespec64 based interfaces
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-provide-ts64-interfaces.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To convert callers of the core code to timespec64 we need to provide
the proper interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |   66 ++++++++++++++++++++++++++++++++++++++++----
 kernel/time/ntp.c           |    7 ++--
 kernel/time/timekeeping.c   |   47 ++++++++++++++-----------------
 3 files changed, 87 insertions(+), 33 deletions(-)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -29,15 +29,71 @@ struct timespec get_monotonic_coarse(voi
 extern void getrawmonotonic(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 extern void get_monotonic_boottime(struct timespec *ts);
-extern void ktime_get_ts(struct timespec *ts);
+extern void ktime_get_ts64(struct timespec64 *ts);
+
+extern int __getnstimeofday64(struct timespec64 *tv);
+extern void getnstimeofday64(struct timespec64 *tv);
+
+#if BITS_PER_LONG == 64
+static inline int __getnstimeofday(struct timespec *ts)
+{
+	return __getnstimeofday64(ts);
+}
+
+static inline void getnstimeofday(struct timespec *ts)
+{
+	getnstimeofday64(ts);
+}
+
+static inline void ktime_get_ts(struct timespec *ts)
+{
+	ktime_get_ts64(ts);
+}
+
+static inline void ktime_get_real_ts(struct timespec *ts)
+{
+	getnstimeofday64(ts);
+}
+
+#else
+static inline int __getnstimeofday(struct timespec *ts)
+{
+	struct timespec64 ts64;
+	int ret = __getnstimeofday64(&ts64);
+
+	*ts = timespec64_to_timespec(ts64);
+	return ret;
+}
+
+static inline void getnstimeofday(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	getnstimeofday64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+
+static inline void ktime_get_ts(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	ktime_get_ts64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+
+static inline void ktime_get_real_ts(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	getnstimeofday64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+#endif
 
-extern int __getnstimeofday(struct timespec *tv);
-extern void getnstimeofday(struct timespec *tv);
 extern void getboottime(struct timespec *ts);
 
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-#define ktime_get_real_ts(ts)	getnstimeofday(ts)
-
+#define ktime_get_real_ts64(ts)	getnstimeofday64(ts)
 
 /*
  * ktime_t based interfaces
Index: tip/kernel/time/ntp.c
===================================================================
--- tip.orig/kernel/time/ntp.c
+++ tip/kernel/time/ntp.c
@@ -466,7 +466,8 @@ static DECLARE_DELAYED_WORK(sync_cmos_wo
 
 static void sync_cmos_clock(struct work_struct *work)
 {
-	struct timespec now, next;
+	struct timespec64 now;
+	struct timespec next;
 	int fail = 1;
 
 	/*
@@ -485,9 +486,9 @@ static void sync_cmos_clock(struct work_
 		return;
 	}
 
-	getnstimeofday(&now);
+	getnstimeofday64(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec * 5) {
-		struct timespec adjust = now;
+		struct timespec adjust = timespec64_to_timespec(now);
 
 		fail = -ENODEV;
 		if (persistent_clock_is_local)
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -285,13 +285,13 @@ static void timekeeping_forward_now(stru
 }
 
 /**
- * __getnstimeofday - Returns the time of day in a timespec.
+ * __getnstimeofday64 - Returns the time of day in a timespec64.
  * @ts:		pointer to the timespec to be set
  *
  * Updates the time of day in the timespec.
  * Returns 0 on success, or -ve when suspended (timespec will be undefined).
  */
-int __getnstimeofday(struct timespec *ts)
+int __getnstimeofday64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long seq;
@@ -306,7 +306,7 @@ int __getnstimeofday(struct timespec *ts
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
 	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsecs);
+	timespec64_add_ns(ts, nsecs);
 
 	/*
 	 * Do not bail out early, in case there were callers still using
@@ -316,19 +316,19 @@ int __getnstimeofday(struct timespec *ts
 		return -EAGAIN;
 	return 0;
 }
-EXPORT_SYMBOL(__getnstimeofday);
+EXPORT_SYMBOL(__getnstimeofday64);
 
 /**
- * getnstimeofday - Returns the time of day in a timespec.
+ * getnstimeofday64 - Returns the time of day in a timespec64.
  * @ts:		pointer to the timespec to be set
  *
  * Returns the time of day in a timespec (WARN if suspended).
  */
-void getnstimeofday(struct timespec *ts)
+void getnstimeofday64(struct timespec64 *ts)
 {
-	WARN_ON(__getnstimeofday(ts));
+	WARN_ON(__getnstimeofday64(ts));
 }
-EXPORT_SYMBOL(getnstimeofday);
+EXPORT_SYMBOL(getnstimeofday64);
 
 ktime_t ktime_get(void)
 {
@@ -350,17 +350,17 @@ ktime_t ktime_get(void)
 EXPORT_SYMBOL_GPL(ktime_get);
 
 /**
- * ktime_get_ts - get the monotonic clock in timespec format
+ * ktime_get_ts64 - get the monotonic clock in timespec64 format
  * @ts:		pointer to timespec variable
  *
  * The function calculates the monotonic clock from the realtime
  * clock and the wall_to_monotonic offset and stores the result
  * in normalized timespec format in the variable pointed to by @ts.
  */
-void ktime_get_ts(struct timespec *ts)
+void ktime_get_ts64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec64 ts64, tomono;
+	struct timespec64 tomono;
 	s64 nsec;
 	unsigned int seq;
 
@@ -368,18 +368,17 @@ void ktime_get_ts(struct timespec *ts)
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
-		ts64.tv_sec = tk->xtime_sec;
+		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 
-	ts64.tv_sec += tomono.tv_sec;
-	ts64.tv_nsec = 0;
-	timespec64_add_ns(&ts64, nsec + tomono.tv_nsec);
-	*ts = timespec64_to_timespec(ts64);
+	ts->tv_sec += tomono.tv_sec;
+	ts->tv_nsec = 0;
+	timespec64_add_ns(ts, nsec + tomono.tv_nsec);
 }
-EXPORT_SYMBOL_GPL(ktime_get_ts);
+EXPORT_SYMBOL_GPL(ktime_get_ts64);
 
 
 /**
@@ -473,9 +472,9 @@ EXPORT_SYMBOL(getnstime_raw_and_real);
  */
 void do_gettimeofday(struct timeval *tv)
 {
-	struct timespec now;
+	struct timespec64 now;
 
-	getnstimeofday(&now);
+	getnstimeofday64(&now);
 	tv->tv_sec = now.tv_sec;
 	tv->tv_usec = now.tv_nsec/1000;
 }
@@ -680,11 +679,11 @@ int timekeeping_notify(struct clocksourc
  */
 ktime_t ktime_get_real(void)
 {
-	struct timespec now;
+	struct timespec64 now;
 
-	getnstimeofday(&now);
+	getnstimeofday64(&now);
 
-	return timespec_to_ktime(now);
+	return timespec64_to_ktime(now);
 }
 EXPORT_SYMBOL_GPL(ktime_get_real);
 
@@ -1689,7 +1688,6 @@ int do_adjtimex(struct timex *txc)
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	struct timespec64 ts;
-	struct timespec tmp;
 	s32 orig_tai, tai;
 	int ret;
 
@@ -1709,8 +1707,7 @@ int do_adjtimex(struct timex *txc)
 			return ret;
 	}
 
-	getnstimeofday(&tmp);
-	ts = timespec_to_timespec64(tmp);
+	getnstimeofday64(&ts);
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);


