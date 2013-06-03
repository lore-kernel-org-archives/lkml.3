Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3FCCTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:19:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:63406 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3FCCTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:19:14 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <richardcochran@gmail.com>, <prarit@redhat.com>
Subject: [PATCH] ntp: Move do_adjtimex() and hardpps() functions to timekeeping.c
Date: Mon, 3 Jun 2013 10:18:48 +0800
Message-ID: <1370225928-17792-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

In preparation for changing the ntp locking rules, move
do_adjtimex and hardpps accessor functions to timekeeping.c,
but keep the code logic in ntp.c.

This patch also introduces a ntp_internal.h file so timekeeping
specific interfaces of ntp.c can be more limitedly shared with
timekeeping.c.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timex.h      |    7 -------
 kernel/time/ntp.c          |    9 ++++-----
 kernel/time/ntp_internal.h |   11 +++++++++++
 kernel/time/timekeeping.c  |   21 +++++++++++++++++++++
 4 files changed, 36 insertions(+), 12 deletions(-)
 create mode 100644 kernel/time/ntp_internal.h

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 5ec87c6..b3726e6 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -125,9 +125,6 @@
 extern unsigned long tick_usec;		/* USER_HZ period (usec) */
 extern unsigned long tick_nsec;		/* SHIFTED_HZ period (nsec) */
 
-extern void ntp_init(void);
-extern void ntp_clear(void);
-
 /* Required to safely shift negative values */
 #define shift_right(x, s) ({	\
 	__typeof__(x) __x = (x);	\
@@ -140,10 +137,6 @@ extern void ntp_clear(void);
 #define NTP_INTERVAL_FREQ  (HZ)
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
-/* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
-extern u64 ntp_tick_length(void);
-
-extern int second_overflow(unsigned long secs);
 extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 457d2ba..8b10706 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -18,6 +18,7 @@
 #include <linux/rtc.h>
 
 #include "tick-internal.h"
+#include "ntp_internal.h"
 
 /*
  * NTP timekeeping variables:
@@ -661,7 +662,7 @@ int ntp_validate_timex(struct timex *txc)
  * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
-int do_adjtimex(struct timex *txc)
+int __do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
 	u32 time_tai, orig_tai;
@@ -911,7 +912,7 @@ static void hardpps_update_phase(long error)
 }
 
 /*
- * hardpps() - discipline CPU clock oscillator to external PPS signal
+ * __hardpps() - discipline CPU clock oscillator to external PPS signal
  *
  * This routine is called at each PPS signal arrival in order to
  * discipline the CPU clock oscillator to the PPS signal. It takes two
@@ -922,7 +923,7 @@ static void hardpps_update_phase(long error)
  * This code is based on David Mills's reference nanokernel
  * implementation. It was mostly rewritten but keeps the same idea.
  */
-void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
+void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
 	struct pps_normtime pts_norm, freq_norm;
 	unsigned long flags;
@@ -976,8 +977,6 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	raw_spin_unlock_irqrestore(&ntp_lock, flags);
 }
-EXPORT_SYMBOL(hardpps);
-
 #endif	/* CONFIG_NTP_PPS */
 
 static int __init ntp_tick_adj_setup(char *str)
diff --git a/kernel/time/ntp_internal.h b/kernel/time/ntp_internal.h
new file mode 100644
index 0000000..fdee80c
--- /dev/null
+++ b/kernel/time/ntp_internal.h
@@ -0,0 +1,11 @@
+#ifndef _LINUX_NTP_INTERNAL_H
+#define _LINUX_NTP_INTERNAL_H
+
+extern void ntp_init(void);
+extern void ntp_clear(void);
+/* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
+extern u64 ntp_tick_length(void);
+extern int second_overflow(unsigned long secs);
+extern int __do_adjtimex(struct timex *);
+extern void __hardpps(const struct timespec *, const struct timespec *);
+#endif /* _LINUX_NTP_INTERNAL_H */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c5feb7a..a138ec2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -24,6 +24,7 @@
 #include <linux/pvclock_gtod.h>
 
 #include "tick-internal.h"
+#include "ntp_internal.h"
 
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
@@ -1613,6 +1614,26 @@ ktime_t ktime_get_monotonic_offset(void)
 EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
 
 /**
+ * do_adjtimex() - Accessor function to NTP __do_adjtimex function
+ */
+int do_adjtimex(struct timex *txc)
+{
+	return __do_adjtimex(txc);
+}
+
+
+#ifdef CONFIG_NTP_PPS
+/**
+ * hardpps() - Accessor function to NTP __hardpps function
+ */
+void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
+{
+	__hardpps(phase_ts, raw_ts);
+}
+EXPORT_SYMBOL(hardpps);
+#endif
+
+/**
  * xtime_update() - advances the timekeeping infrastructure
  * @ticks:	number of ticks, that have elapsed since the last call.
  *
-- 
1.7.9.5

