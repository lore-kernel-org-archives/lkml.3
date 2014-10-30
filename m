Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbaJ3LQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:16:54 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47498 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759182AbaJ3LQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:16:53 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 01/11] time: Add do_settimeofday64() safe version(using timespec64)
Date: Thu, 30 Oct 2014 19:15:35 +0800
Message-Id: <1414667745-7703-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds elapsed
1970-01-01:00:00:00, thus it will overflow at 2038-01-19 03:14:08
on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 saftey for in-kernel uses, this patch
adds safe do_settimeofday64() using timespec64. After this patch,
do_settimeofday() should be replaced by do_settimeofday64() one
by one. Eventually, do_settimeofday() will be removed from the
kernel when it has no users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 include/linux/timekeeping.h |    1 +
 kernel/time/timekeeping.c   |   34 +++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 1caa6b0..afc61c3 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -10,6 +10,7 @@ extern int timekeeping_suspended;
  * Get and set timeofday
  */
 extern void do_gettimeofday(struct timeval *tv);
+extern int do_settimeofday64(const struct timespec64 *ts);
 extern int do_settimeofday(const struct timespec *tv);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..f0dcbc0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -703,18 +703,19 @@ void do_gettimeofday(struct timeval *tv)
 EXPORT_SYMBOL(do_gettimeofday);
 
 /**
- * do_settimeofday - Sets the time of day
- * @tv:		pointer to the timespec variable containing the new time
+ * do_settimeofday64 - Sets the time of day
+ * @ts:     pointer to the timespec64 variable containing the new time
  *
  * Sets the time of day to the new time and update NTP and notify hrtimers
+ * Safe version for 2038 safety.
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
@@ -723,13 +724,12 @@ int do_settimeofday(const struct timespec *tv)
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
 
@@ -741,6 +741,22 @@ int do_settimeofday(const struct timespec *tv)
 
 	return 0;
 }
+EXPORT_SYMBOL(do_settimeofday64);
+
+/**
+ * do_settimeofday - Sets the time of day
+ * @tv:		pointer to the timespec variable containing the new time
+ *
+ * Sets the time of day to the new time and update NTP and notify hrtimers
+ * TODO: [2038 safety] should be replaced by do_settimeofday64().
+ */
+int do_settimeofday(const struct timespec *tv)
+{
+	struct timespec64 ts64;
+
+	ts64 = timespec_to_timespec64(*tv);
+	return do_settimeofday64(&ts64);
+}
 EXPORT_SYMBOL(do_settimeofday);
 
 /**
-- 
1.7.9.5

