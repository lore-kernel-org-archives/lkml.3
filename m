Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaKUTol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:44:41 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43667 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKUToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:38 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 04/12] time: Provide y2038 safe do_settimeofday() replacement
Date: Fri, 21 Nov 2014 11:44:10 -0800
Message-Id: <1416599058-13836-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "pang.xunlei" <pang.xunlei@linaro.org>

The kernel uses 32-bit signed value(time_t) for seconds elapsed
1970-01-01:00:00:00, thus it will overflow at 2038-01-19 03:14:08
on 32-bit systems. This is widely known as the y2038 problem.

As part of addressing "y2038 problem" for in-kernel uses, this patch
adds safe do_settimeofday64() using timespec64.

After this patch, do_settimeofday() is deprecated and all its call
sites will be fixed using do_settimeofday64(), after that it can be
removed.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeping.h | 21 ++++++++++++++++++++-
 kernel/time/timekeeping.c   | 19 +++++++++----------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 1caa6b0..071ad7e 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -10,7 +10,7 @@ extern int timekeeping_suspended;
  * Get and set timeofday
  */
 extern void do_gettimeofday(struct timeval *tv);
-extern int do_settimeofday(const struct timespec *tv);
+extern int do_settimeofday64(const struct timespec64 *ts);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
 
@@ -33,6 +33,14 @@ extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
 
 #if BITS_PER_LONG == 64
+/**
+ * Deprecated. Use do_settimeofday64().
+ */
+static inline int do_settimeofday(const struct timespec *ts)
+{
+	return do_settimeofday64(ts);
+}
+
 static inline int __getnstimeofday(struct timespec *ts)
 {
 	return __getnstimeofday64(ts);
@@ -54,6 +62,17 @@ static inline void ktime_get_real_ts(struct timespec *ts)
 }
 
 #else
+/**
+ * Deprecated. Use do_settimeofday64().
+ */
+static inline int do_settimeofday(const struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	ts64 = timespec_to_timespec64(*ts);
+	return do_settimeofday64(&ts64);
+}
+
 static inline int __getnstimeofday(struct timespec *ts)
 {
 	struct timespec64 ts64;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..1d33550 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -703,18 +703,18 @@ void do_gettimeofday(struct timeval *tv)
 EXPORT_SYMBOL(do_gettimeofday);
 
 /**
- * do_settimeofday - Sets the time of day
- * @tv:		pointer to the timespec variable containing the new time
+ * do_settimeofday64 - Sets the time of day.
+ * @ts:     pointer to the timespec64 variable containing the new time
  *
  * Sets the time of day to the new time and update NTP and notify hrtimers
  */
-int do_settimeofday(const struct timespec *tv)
+int do_settimeofday64(const struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
-	struct timespec64 ts_delta, xt, tmp;
+	struct timespec64 ts_delta, xt;
 	unsigned long flags;
 
-	if (!timespec_valid_strict(tv))
+	if (!timespec64_valid_strict(ts))
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -723,13 +723,12 @@ int do_settimeofday(const struct timespec *tv)
 	timekeeping_forward_now(tk);
 
 	xt = tk_xtime(tk);
-	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
-	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
+	ts_delta.tv_sec = ts->tv_sec - xt.tv_sec;
+	ts_delta.tv_nsec = ts->tv_nsec - xt.tv_nsec;
 
 	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
 
-	tmp = timespec_to_timespec64(*tv);
-	tk_set_xtime(tk, &tmp);
+	tk_set_xtime(tk, ts);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
@@ -741,7 +740,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	return 0;
 }
-EXPORT_SYMBOL(do_settimeofday);
+EXPORT_SYMBOL(do_settimeofday64);
 
 /**
  * timekeeping_inject_offset - Adds or subtracts from the current time.
-- 
1.9.1

