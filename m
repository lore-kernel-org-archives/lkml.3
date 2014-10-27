Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaJ0Frs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59940 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaJ0Frq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:46 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 10/12] time: Convert do_settimeofday() to use timespec64
Date: Mon, 27 Oct 2014 13:46:40 +0800
Message-Id: <1414388802-5866-9-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 safety for in-kernel uses, convert do_settimeofday()
to use the timespec64 structure, and modify all users of do_settimeofday() to
provide timespec64 structures (via timespec_to_timespec64() as needed).

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/x86/xen/time.c                 |   10 ++++++++--
 drivers/hv/hv_util.c                |    4 ++--
 drivers/rtc/hctosys.c               |    4 +---
 drivers/staging/android/alarm-dev.c |    8 +++++---
 include/linux/timekeeping.h         |    2 +-
 kernel/compat.c                     |    4 +++-
 kernel/time/time.c                  |   13 ++++++++++---
 kernel/time/timekeeping.c           |   15 +++++++--------
 8 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index a1d430b..cf1b591 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -486,6 +486,7 @@ static void __init xen_time_init(void)
 {
 	int cpu = smp_processor_id();
 	struct timespec tp;
+	struct timespec64 tp64;
 
 	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
 
@@ -496,9 +497,14 @@ static void __init xen_time_init(void)
 		xen_clockevent = &xen_vcpuop_clockevent;
 	}
 
-	/* Set initial system time with full resolution */
+	/*
+	 * Set initial system time with full resolution.
+	 * TODO: [2038 safety] xen_read_wallclock() should be changed to use
+	 * timespec64 for 2038 safety as soon as possible.
+	 */
 	xen_read_wallclock(&tp);
-	do_settimeofday(&tp);
+	tp64 = timespec_to_timespec64(tp);
+	do_settimeofday(&tp64);
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
 
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 3b9c9ef..73b0962 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -166,10 +166,10 @@ static void shutdown_onchannelcallback(void *context)
 static inline void do_adj_guesttime(u64 hosttime)
 {
 	s64 host_tns;
-	struct timespec host_ts;
+	struct timespec64 host_ts;
 
 	host_tns = (hosttime - WLTIMEDELTA) * 100;
-	host_ts = ns_to_timespec(host_tns);
+	host_ts = ns_to_timespec64(host_tns);
 
 	do_settimeofday(&host_ts);
 }
diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index c80723f..db71f47 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -29,7 +29,6 @@ static int __init rtc_hctosys(void)
 	struct timespec64 tv = {
 		.tv_nsec = NSEC_PER_SEC >> 1,
 	};
-	struct timespec ts32;
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 
 	if (rtc == NULL) {
@@ -55,8 +54,7 @@ static int __init rtc_hctosys(void)
 
 	rtc_tm_to_time(&tm, &tv.tv_sec);
 
-	ts32 = timespec64_to_timespec(tv);
-	err = do_settimeofday(&ts32);
+	err = do_settimeofday(&tv);
 
 	dev_info(rtc->dev.parent,
 		"setting system clock to "
diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index e2729c8..0385a38 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -154,7 +154,6 @@ static int alarm_wait(void)
 
 static int alarm_set_rtc(struct timespec64 *ts)
 {
-	struct timespec ts32;
 	struct rtc_time new_rtc_tm;
 	struct rtc_device *rtc_dev;
 	unsigned long flags;
@@ -162,8 +161,7 @@ static int alarm_set_rtc(struct timespec64 *ts)
 
 	rtc_time_to_tm(ts->tv_sec, &new_rtc_tm);
 	rtc_dev = alarmtimer_get_rtcdev();
-	ts32 = timespec64_to_timespec(*ts);
-	rv = do_settimeofday(&ts32);
+	rv = do_settimeofday(ts);
 	if (rv < 0)
 		return rv;
 	if (rtc_dev)
@@ -200,6 +198,10 @@ static int alarm_get_time(enum android_alarm_type alarm_type,
 	return rv;
 }
 
+/*
+ * TODO: [2038 safety] alarm_do_ioctl() should be fixed to use timespec64,
+ *  once timespec64 is promoted to userspace.
+ */
 static long alarm_do_ioctl(struct file *file, unsigned int cmd,
 							struct timespec *ts)
 {
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 64c9c77..6cb9a77 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -10,7 +10,7 @@ extern int timekeeping_suspended;
  * Get and set timeofday
  */
 extern void do_gettimeofday(struct timeval *tv);
-extern int do_settimeofday(const struct timespec *tv);
+extern int do_settimeofday(const struct timespec64 *ts);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
 
diff --git a/kernel/compat.c b/kernel/compat.c
index ebb3c36..4362578 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -1047,6 +1047,7 @@ COMPAT_SYSCALL_DEFINE1(time, compat_time_t __user *, tloc)
 COMPAT_SYSCALL_DEFINE1(stime, compat_time_t __user *, tptr)
 {
 	struct timespec tv;
+	struct timespec64 tv64;
 	int err;
 
 	if (get_user(tv.tv_sec, tptr))
@@ -1058,7 +1059,8 @@ COMPAT_SYSCALL_DEFINE1(stime, compat_time_t __user *, tptr)
 	if (err)
 		return err;
 
-	do_settimeofday(&tv);
+	tv64 = timespec_to_timespec64(tv);
+	do_settimeofday(&tv64);
 	return 0;
 }
 
diff --git a/kernel/time/time.c b/kernel/time/time.c
index f9521fa..d85fda9 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -82,6 +82,7 @@ SYSCALL_DEFINE1(time, time_t __user *, tloc)
 SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 {
 	struct timespec tv;
+	struct timespec64 tv64;
 	int err;
 
 	if (get_user(tv.tv_sec, tptr))
@@ -93,7 +94,8 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 	if (err)
 		return err;
 
-	do_settimeofday(&tv);
+	tv64 = timespec_to_timespec64(tv);
+	do_settimeofday(&tv64);
 	return 0;
 }
 
@@ -162,6 +164,7 @@ static inline void warp_clock(void)
 
 int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 {
+	struct timespec64 tv64;
 	static int firsttime = 1;
 	int error = 0;
 
@@ -181,8 +184,12 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
 				warp_clock();
 		}
 	}
-	if (tv)
-		return do_settimeofday(tv);
+
+	if (tv) {
+		tv64 = timespec_to_timespec64(*tv);
+		return do_settimeofday(&tv64);
+	}
+
 	return 0;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b58e7cf..fd03819 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -704,17 +704,17 @@ EXPORT_SYMBOL(do_gettimeofday);
 
 /**
  * do_settimeofday - Sets the time of day
- * @tv:		pointer to the timespec variable containing the new time
+ * @ts:		pointer to the timespec64 variable containing the new time
  *
  * Sets the time of day to the new time and update NTP and notify hrtimers
  */
-int do_settimeofday(const struct timespec *tv)
+int do_settimeofday(const struct timespec64 *ts)
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
 
-- 
1.7.9.5

