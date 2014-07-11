Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaGKNtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:49:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:56265 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaGKNpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:45:09 -0400
Message-Id: <20140711133709.168314737@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:45:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 46/55] timekeeping: Provide ktime_get_raw()
References: <20140711133623.530368377@linutronix.de>
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
 kernel/time/timekeeping.c           |   26 ++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -56,6 +56,9 @@ struct timekeeper {
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
@@ -354,6 +354,7 @@ static void timekeeping_forward_now(stru
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 	timespec64_add_ns(&tk->raw_time, nsec);
+	tk->base_raw = ktime_add_ns(tk->base_raw, nsec);
 }
 
 /**
@@ -470,6 +471,27 @@ ktime_t ktime_mono_to_any(ktime_t tmono,
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
@@ -912,6 +934,7 @@ void __init timekeeping_init(void)
 	tk_set_xtime(tk, &now);
 	tk->raw_time.tv_sec = 0;
 	tk->raw_time.tv_nsec = 0;
+	tk->base_raw.tv64 = 0;
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
 		boot = tk_xtime(tk);
 
@@ -1405,6 +1428,9 @@ static cycle_t logarithmic_accumulation(
 
 	/* Accumulate raw time */
 	raw_nsecs = (u64)tk->raw_interval << shift;
+	/* Update ktime_t base */
+	tk->base_raw = ktime_add_ns(tk->base_raw, raw_nsecs);
+	/* Update the timespec base */
 	raw_nsecs += tk->raw_time.tv_nsec;
 	if (raw_nsecs >= NSEC_PER_SEC) {
 		u64 raw_secs = raw_nsecs;


