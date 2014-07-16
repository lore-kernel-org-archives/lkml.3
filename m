Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaGPVJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:09:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:59859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaGPVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:06 -0400
Message-Id: <20140716205056.541291177@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 51/64] timekeeping: Provide ktime_get_raw()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-provide-ktime-get-raw.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a ktime_t based interface for raw monotonic time.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |    3 +++
 include/linux/timekeeping.h         |    6 ++++++
 kernel/time/timekeeping.c           |   25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -54,6 +54,9 @@ struct timekeeper {
 	/* The current UTC to TAI offset in seconds */
 	s32			tai_offset;
 
+	/* Monotonic raw base time */
+	ktime_t			base_raw;
+
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec64	raw_time;
 
Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -107,6 +107,7 @@ enum tk_offsets {
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_with_offset(enum tk_offsets offs);
 extern ktime_t ktime_mono_to_any(ktime_t tmono, enum tk_offsets offs);
+extern ktime_t ktime_get_raw(void);
 
 /**
  * ktime_get_real - get the real (wall-) time in ktime_t format
@@ -158,6 +159,11 @@ static inline u64 ktime_get_boot_ns(void
 	return ktime_to_ns(ktime_get_boottime());
 }
 
+static inline u64 ktime_get_raw_ns(void)
+{
+	return ktime_to_ns(ktime_get_raw());
+}
+
 /*
  * Timespec interfaces utilizing the ktime based ones
  */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -305,6 +305,9 @@ static inline void tk_update_ktime_data(
 	nsec *= NSEC_PER_SEC;
 	nsec += tk->wall_to_monotonic.tv_nsec;
 	tk->base_mono = ns_to_ktime(nsec);
+
+	/* Update the monotonic raw base */
+	tk->base_raw = timespec64_to_ktime(tk->raw_time);
 }
 
 /* must hold timekeeper_lock */
@@ -467,6 +470,27 @@ ktime_t ktime_mono_to_any(ktime_t tmono,
 EXPORT_SYMBOL_GPL(ktime_mono_to_any);
 
 /**
+ * ktime_get_raw - Returns the raw monotonic time in ktime_t format
+ */
+ktime_t ktime_get_raw(void)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+	unsigned int seq;
+	ktime_t base;
+	s64 nsecs;
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		base = tk->base_raw;
+		nsecs = timekeeping_get_ns_raw(tk);
+
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return ktime_add_ns(base, nsecs);
+}
+EXPORT_SYMBOL_GPL(ktime_get_raw);
+
+/**
  * ktime_get_ts64 - get the monotonic clock in timespec64 format
  * @ts:		pointer to timespec variable
  *
@@ -878,6 +902,7 @@ void __init timekeeping_init(void)
 	tk_set_xtime(tk, &now);
 	tk->raw_time.tv_sec = 0;
 	tk->raw_time.tv_nsec = 0;
+	tk->base_raw.tv64 = 0;
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
 		boot = tk_xtime(tk);
 


