Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbbAXBoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:44:18 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33172 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbbAXBoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/8] time: Expose getboottime64 for in-kernel uses
Date: Fri, 23 Jan 2015 17:43:54 -0800
Message-Id: <1422063840-2837-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
References: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a timespec64 based getboottime64() implementation
that can be used as we convert internal users of
getboottime away from using timespecs.

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timekeeping.h | 16 ++++++++++++++--
 kernel/time/timekeeping.c   | 12 ++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 9b63d13..9148013 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -33,6 +33,7 @@ extern time64_t ktime_get_real_seconds(void);
 
 extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
+extern void getboottime64(struct timespec64 *ts);
 
 #if BITS_PER_LONG == 64
 /**
@@ -72,6 +73,11 @@ static inline struct timespec get_monotonic_coarse(void)
 {
 	return get_monotonic_coarse64();
 }
+
+static inline void getboottime(struct timespec *ts)
+{
+	return getboottime64(ts);
+}
 #else
 /**
  * Deprecated. Use do_settimeofday64().
@@ -129,9 +135,15 @@ static inline struct timespec get_monotonic_coarse(void)
 {
 	return timespec64_to_timespec(get_monotonic_coarse64());
 }
-#endif
 
-extern void getboottime(struct timespec *ts);
+static inline void getboottime(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	getboottime64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+#endif
 
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 #define ktime_get_real_ts64(ts)	getnstimeofday64(ts)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..b124af2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1659,24 +1659,24 @@ out:
 }
 
 /**
- * getboottime - Return the real time of system boot.
- * @ts:		pointer to the timespec to be set
+ * getboottime64 - Return the real time of system boot.
+ * @ts:		pointer to the timespec64 to be set
  *
- * Returns the wall-time of boot in a timespec.
+ * Returns the wall-time of boot in a timespec64.
  *
  * This is based on the wall_to_monotonic offset and the total suspend
  * time. Calls to settimeofday will affect the value returned (which
  * basically means that however wrong your real time clock is at boot time,
  * you get the right time here).
  */
-void getboottime(struct timespec *ts)
+void getboottime64(struct timespec64 *ts)
 {
 	struct timekeeper *tk = &tk_core.timekeeper;
 	ktime_t t = ktime_sub(tk->offs_real, tk->offs_boot);
 
-	*ts = ktime_to_timespec(t);
+	*ts = ktime_to_timespec64(t);
 }
-EXPORT_SYMBOL_GPL(getboottime);
+EXPORT_SYMBOL_GPL(getboottime64);
 
 unsigned long get_seconds(void)
 {
-- 
1.9.1

