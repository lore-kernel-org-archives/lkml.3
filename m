Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaJ2JN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:13:29 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44937 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaJ2JNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:13:23 -0400
Date: Wed, 29 Oct 2014 14:43:17 +0530
From: Heena Sirwani <heenasirwani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, tglx@linutronix.de, arnd@arndb.de
Subject: [PATCH v7] timekeeping: Added a function to return tv_sec portion of
 ktime_get_ts64()
Message-ID: <20141029091317.GA1138@heena-HP-Compaq-8200-Elite-MT-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch replaces all instances of time_t with time64_t i.e.
change the type used for representing time from 32-bit to 64-bit. All
32-bit kernels to date use a signed 32-bit time_t type, which can only
represent time until January 2038. Since embedded systems running 32-bit
Linux are going to survive beyond that date, we have to change all
current uses, in a backwards compatible way.

The patch also changes the function get_seconds() that returns a 32-bit
integer to ktime_get_seconds() that returns seconds as 64-bit integer.

The patch changes the type of ticks from time_t to u32. We keep ticks as
32-bits as the function uses 32-bit arithmetic which would prove less
expensive than 64-bit arithmetic and the function is expected to be
called atleast once every 32 seconds.

Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
---
Changes in v7:
	- Reordered assignments in tk_update_ktime_data() to improve
	  readability.

 include/linux/timekeeper_internal.h |  2 ++
 include/linux/timekeeping.h         |  1 +
 kernel/time/timekeeping.c           | 31 ++++++++++++++++++++++++++++---
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 95640dc..92e5e9d 100644
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
+	u64			ktime_sec;
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
index ec1791f..7136a33 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -418,6 +418,8 @@ EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 static inline void tk_update_ktime_data(struct timekeeper *tk)
 {
 	s64 nsec;
+	u64 seconds;
+	s64 nsec_offset;
 
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
@@ -648,6 +655,24 @@ void ktime_get_ts64(struct timespec64 *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts64);
 
+time64_t ktime_get_seconds(void)
+{
+	time64_t seconds;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	unsigned int seq;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		seconds = tk->ktime_sec;
+
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return seconds;
+}
+EXPORT_SYMBOL_GPL(ktime_get_seconds);
+
 #ifdef CONFIG_NTP_PPS
 
 /**
-- 
1.9.1

