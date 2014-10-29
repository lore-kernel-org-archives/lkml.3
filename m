Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbaJ2OTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:19:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60612 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbaJ2OTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:19:03 -0400
Date: Wed, 29 Oct 2014 07:18:30 -0700
From: tip-bot for Heena Sirwani <tipbot@zytor.com>
Message-ID: <tip-9e3680b1750b9a62680b0262c9f438de98b77655@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        tglx@linutronix.de, heenasirwani@gmail.com, arnd@arndb.de,
        mingo@kernel.org
Reply-To: arnd@arndb.de, heenasirwani@gmail.com, mingo@kernel.org,
        john.stultz@linaro.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        tglx@linutronix.de
In-Reply-To: <da0b63f4bdf3478909f92becb35861197da3a905.1414578445.git.heenasirwani@gmail.com>
References: <da0b63f4bdf3478909f92becb35861197da3a905.1414578445.git.heenasirwani@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/2038] timekeeping:
  Provide fast accessor to the seconds part of CLOCK_MONOTONIC
Git-Commit-ID: 9e3680b1750b9a62680b0262c9f438de98b77655
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e3680b1750b9a62680b0262c9f438de98b77655
Gitweb:     http://git.kernel.org/tip/9e3680b1750b9a62680b0262c9f438de98b77655
Author:     Heena Sirwani <heenasirwani@gmail.com>
AuthorDate: Wed, 29 Oct 2014 16:01:16 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 Oct 2014 15:15:40 +0100

timekeeping: Provide fast accessor to the seconds part of CLOCK_MONOTONIC

This is the counterpart to get_seconds() based on CLOCK_MONOTONIC. The
use case for this interface are kernel internal coarse grained
timestamps which do neither require the nanoseconds fraction of
current time nor the CLOCK_REALTIME properties. Such timestamps can
currently only retrieved by calling ktime_get_ts64() and using the
tv_sec field of the returned timespec64. That's inefficient as it
involves the read of the clocksource, math operations and must be
protected by the timekeeper sequence counter.

To avoid the sequence counter protection we restrict the return value
to unsigned 32bit on 32bit machines. This covers ~136 years of uptime
and therefor an overflow is not expected to hit anytime soon.

To avoid math in the function we calculate the current seconds portion
of CLOCK_MONOTONIC when the timekeeper gets updated in
tk_update_ktime_data() similar to the CLOCK_REALTIME counterpart
xtime_sec.

[ tglx: Massaged changelog, simplified and commented the update
  	function, added docbook comment ]

Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
Reviewed-by: Arnd Bergman <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: opw-kernel@googlegroups.com
Link: http://lkml.kernel.org/r/da0b63f4bdf3478909f92becb35861197da3a905.1414578445.git.heenasirwani@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |  2 ++
 include/linux/timekeeping.h         |  1 +
 kernel/time/timekeeping.c           | 38 ++++++++++++++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 5 deletions(-)

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
index ec1791f..a693270 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -417,7 +417,8 @@ EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
  */
 static inline void tk_update_ktime_data(struct timekeeper *tk)
 {
-	s64 nsec;
+	u64 seconds;
+	u32 nsec;
 
 	/*
 	 * The xtime based monotonic readout is:
@@ -426,13 +427,22 @@ static inline void tk_update_ktime_data(struct timekeeper *tk)
 	 *	nsec = base_mono + now();
 	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
 	 */
-	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
-	nsec *= NSEC_PER_SEC;
-	nsec += tk->wall_to_monotonic.tv_nsec;
-	tk->tkr.base_mono = ns_to_ktime(nsec);
+	seconds = (u64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
+	nsec = (u32) tk->wall_to_monotonic.tv_nsec;
+	tk->tkr.base_mono = ns_to_ktime(seconds * NSEC_PER_SEC + nsec);
 
 	/* Update the monotonic raw base */
 	tk->base_raw = timespec64_to_ktime(tk->raw_time);
+
+	/*
+	 * The sum of the nanoseconds portions of xtime and
+	 * wall_to_monotonic can be greater/equal one second. Take
+	 * this into account before updating tk->ktime_sec.
+	 */
+	nsec += (u32)(tk->tkr.xtime_nsec >> tk->tkr.shift);
+	if (nsec >= NSEC_PER_SEC)
+		seconds++;
+	tk->ktime_sec = seconds;
 }
 
 /* must hold timekeeper_lock */
@@ -648,6 +658,24 @@ void ktime_get_ts64(struct timespec64 *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts64);
 
+/**
+ * ktime_get_seconds - Get the seconds portion of CLOCK_MONOTONIC
+ *
+ * Returns the seconds portion of CLOCK_MONOTONIC with a single non
+ * serialized read. tk->ktime_sec is of type 'unsigned long' so this
+ * works on both 32 and 64 bit systems. On 32 bit systems the readout
+ * covers ~136 years of uptime which should be enough to prevent
+ * premature wrap arounds.
+ */
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
