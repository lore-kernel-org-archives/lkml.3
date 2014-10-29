Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaJ2KbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:31:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55367 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbaJ2KbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:31:22 -0400
Date: Wed, 29 Oct 2014 16:01:16 +0530
From: Heena Sirwani <heenasirwani@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        arnd@arndb.de
Subject: [PATCH v8 1/2] timekeeping: Added a function to return tv_sec
 portion of ktime_get_ts64()
Message-ID: <da0b63f4bdf3478909f92becb35861197da3a905.1414578445.git.heenasirwani@gmail.com>
References: <cover.1414578445.git.heenasirwani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414578445.git.heenasirwani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds a function to return tv_sec portion of
ktime_get_ts64() function in order to have a function that returns
seconds as 64-bit integers instead of 32-bit integers to address the
y2038 problem.

Since we are interested only in the seconds portion of ktime_get_ts64()
and require this to be as fast as possible, we take the implementation
of ktime_get_ts64() as it is and remove everything pertaining to the
nanoseconds portion. We only add to the seconds calculation if the
calculation of nanoseconds is more than one billion nanoseconds. For all
this calculation, we add a new field to the timekeeper struct,
ktime_sec. We update this field in the function tk_update_ktime_data()
by including the calculation of monotonic clock time in seconds and
including the tk_xtime() implementation that gives the nanoseconds value
of last timer click  instead of using timekeeping_get_ns() which is
expensive and we do not require such fine resolution for nanoseconds.

Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
---
 include/linux/timekeeper_internal.h |  2 ++
 include/linux/timekeeping.h         |  1 +
 kernel/time/timekeeping.c           | 22 +++++++++++++++++++---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 95640dc..05af9a3 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -42,6 +42,7 @@ struct tk_read_base {
  * struct timekeeper - Structure holding internal timekeeping values.
  * @tkr:		The readout base structure
  * @xtime_sec:		Current CLOCK_REALTIME time in seconds
+ * @ktime_sec:		Current CLOCK_MONOTONIC time in seconds
  * @wall_to_monotonic:	CLOCK_REALTIME to CLOCK_MONOTONIC offset
  * @offs_real:		Offset clock monotonic -> clock realtime
  * @offs_boot:		Offset clock monotonic -> clock boottime
@@ -77,6 +78,7 @@ struct tk_read_base {
 struct timekeeper {
 	struct tk_read_base	tkr;
 	u64			xtime_sec;
+	unsigned long		ktime_sec;
 	struct timespec64	wall_to_monotonic;
 	ktime_t			offs_real;
 	ktime_t			offs_boot;
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 1caa6b0..115d55e 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -28,6 +28,7 @@ struct timespec __current_kernel_time(void);
 struct timespec get_monotonic_coarse(void);
 extern void getrawmonotonic(struct timespec *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
+extern time64_t ktime_get_seconds(void);
 
 extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..e42da92 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -418,6 +418,8 @@ EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 static inline void tk_update_ktime_data(struct timekeeper *tk)
 {
 	s64 nsec;
+	u64 seconds;
+	u32 nsec_offset;
 
 	/*
 	 * The xtime based monotonic readout is:
@@ -426,13 +428,18 @@ static inline void tk_update_ktime_data(struct timekeeper *tk)
 	 *	nsec = base_mono + now();
 	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
 	 */
-	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
-	nsec *= NSEC_PER_SEC;
-	nsec += tk->wall_to_monotonic.tv_nsec;
+	seconds = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
+	nsec_offset = tk->wall_to_monotonic.tv_nsec;
+	nsec = seconds * NSEC_PER_SEC;
+	nsec += nsec_offset;
 	tk->tkr.base_mono = ns_to_ktime(nsec);
 
 	/* Update the monotonic raw base */
 	tk->base_raw = timespec64_to_ktime(tk->raw_time);
+
+	if (((long)(tk->tkr.xtime_nsec >> tk->tkr.shift) + nsec_offset) >= NSEC_PER_SEC)
+		seconds += 1;
+	tk->ktime_sec = seconds;
 }
 
 /* must hold timekeeper_lock */
@@ -648,6 +655,15 @@ void ktime_get_ts64(struct timespec64 *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts64);
 
+time64_t ktime_get_seconds(void)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+
+	WARN_ON(timekeeping_suspended);
+	return tk->ktime_sec;
+}
+EXPORT_SYMBOL_GPL(ktime_get_seconds);
+
 #ifdef CONFIG_NTP_PPS
 
 /**
-- 
1.9.1

