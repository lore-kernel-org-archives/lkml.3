Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaGPVVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:21:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:59637 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaGPVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:07 -0400
Message-Id: <20140716205053.190013055@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 12/64] timekeeper: Move tk_xtime to core code
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeper-move-tk-xtime-to-core.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users outside of the core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |   18 ---------
 kernel/time/timekeeping.c           |   70 ++++++++++++++++++++++--------------
 2 files changed, 43 insertions(+), 45 deletions(-)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -71,16 +71,6 @@ struct timekeeper {
 
 };
 
-static inline struct timespec64 tk_xtime(struct timekeeper *tk)
-{
-	struct timespec64 ts;
-
-	ts.tv_sec = tk->xtime_sec;
-	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
-	return ts;
-}
-
-
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 
 extern void update_vsyscall(struct timekeeper *tk);
@@ -92,14 +82,6 @@ extern void update_vsyscall_old(struct t
 				struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 
-static inline void update_vsyscall(struct timekeeper *tk)
-{
-	struct timespec xt;
-
-	xt = tk_xtime(tk);
-	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
-}
-
 #else
 
 static inline void update_vsyscall(struct timekeeper *tk)
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -51,6 +51,15 @@ static inline void tk_normalize_xtime(st
 	}
 }
 
+static inline struct timespec64 tk_xtime(struct timekeeper *tk)
+{
+	struct timespec64 ts;
+
+	ts.tv_sec = tk->xtime_sec;
+	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
+	return ts;
+}
+
 static void tk_set_xtime(struct timekeeper *tk, const struct timespec64 *ts)
 {
 	tk->xtime_sec = ts->tv_sec;
@@ -199,6 +208,40 @@ static inline s64 timekeeping_get_ns_raw
 	return nsec + arch_gettimeoffset();
 }
 
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
+
+static inline void update_vsyscall(struct timekeeper *tk)
+{
+	struct timespec xt;
+
+	xt = tk_xtime(tk);
+	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
+}
+
+static inline void old_vsyscall_fixup(struct timekeeper *tk)
+{
+	s64 remainder;
+
+	/*
+	* Store only full nanoseconds into xtime_nsec after rounding
+	* it up and add the remainder to the error difference.
+	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
+	* by truncating the remainder in vsyscalls. However, it causes
+	* additional work to be done in timekeeping_adjust(). Once
+	* the vsyscall implementations are converted to use xtime_nsec
+	* (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
+	* users are removed, this can be killed.
+	*/
+	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
+	tk->xtime_nsec -= remainder;
+	tk->xtime_nsec += 1ULL << tk->shift;
+	tk->ntp_error += remainder << tk->ntp_error_shift;
+	tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
+}
+#else
+#define old_vsyscall_fixup(tk)
+#endif
+
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
 static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
@@ -1330,33 +1373,6 @@ static cycle_t logarithmic_accumulation(
 	return offset;
 }
 
-#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
-static inline void old_vsyscall_fixup(struct timekeeper *tk)
-{
-	s64 remainder;
-
-	/*
-	* Store only full nanoseconds into xtime_nsec after rounding
-	* it up and add the remainder to the error difference.
-	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
-	* by truncating the remainder in vsyscalls. However, it causes
-	* additional work to be done in timekeeping_adjust(). Once
-	* the vsyscall implementations are converted to use xtime_nsec
-	* (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
-	* users are removed, this can be killed.
-	*/
-	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
-	tk->xtime_nsec -= remainder;
-	tk->xtime_nsec += 1ULL << tk->shift;
-	tk->ntp_error += remainder << tk->ntp_error_shift;
-	tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
-}
-#else
-#define old_vsyscall_fixup(tk)
-#endif
-
-
-
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *


