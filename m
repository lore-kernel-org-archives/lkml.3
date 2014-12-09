Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaLIOxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:53:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:48982 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaLIOxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:53:06 -0500
Date: Tue, 9 Dec 2014 15:52:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergman <arnd@arndb.de>
Subject: [GIT pull] More 2038 timer work for 3.19
Message-ID: <alpine.DEB.2.11.1412091534320.16275@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-2038-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-2038-for-linus

Two more patches for the ongoing 2038 work:
   - New accessors to clock MONOTONIC and REALTIME seconds

This is a seperate branch as Arnd has follow up work depending on
this.

Thanks,

	tglx

------------------>
Heena Sirwani (2):
      timekeeping: Provide fast accessor to the seconds part of CLOCK_MONOTONIC
      timekeeping: Provide y2038 safe accessor to the seconds portion of CLOCK_REALTIME


 include/linux/timekeeper_internal.h |  2 ++
 include/linux/timekeeping.h         |  2 ++
 kernel/time/timekeeping.c           | 68 ++++++++++++++++++++++++++++++++++---
 3 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 95640dcd1899..05af9a334893 100644
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
index 1caa6b04fdc5..91454dea2bc6 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -28,6 +28,8 @@ struct timespec __current_kernel_time(void);
 struct timespec get_monotonic_coarse(void);
 extern void getrawmonotonic(struct timespec *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
+extern time64_t ktime_get_seconds(void);
+extern time64_t ktime_get_real_seconds(void);
 
 extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791fae965..0aef92a0a701 100644
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
@@ -648,6 +658,54 @@ void ktime_get_ts64(struct timespec64 *ts)
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
+/**
+ * ktime_get_real_seconds - Get the seconds portion of CLOCK_REALTIME
+ *
+ * Returns the wall clock seconds since 1970. This replaces the
+ * get_seconds() interface which is not y2038 safe on 32bit systems.
+ *
+ * For 64bit systems the fast access to tk->xtime_sec is preserved. On
+ * 32bit systems the access must be protected with the sequence
+ * counter to provide "atomic" access to the 64bit tk->xtime_sec
+ * value.
+ */
+time64_t ktime_get_real_seconds(void)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+	time64_t seconds;
+	unsigned int seq;
+
+	if (IS_ENABLED(CONFIG_64BIT))
+		return tk->xtime_sec;
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		seconds = tk->xtime_sec;
+
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return seconds;
+}
+EXPORT_SYMBOL_GPL(ktime_get_real_seconds);
+
 #ifdef CONFIG_NTP_PPS
 
 /**
