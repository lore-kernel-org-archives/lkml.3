Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaGKN5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:57:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:56093 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaGKNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:20 -0400
Message-Id: <20140711133706.426549845@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 14/55] timekeeping: Provide internal ktime_t based data
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-provide-internal-ktime-based-data.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ktime_t based interfaces are used a lot in performance critical
code pathes. Add ktime_t based data so the interfaces don't have to
convert from the xtime/timespec based data.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |    3 +++
 kernel/time/timekeeping.c           |   25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

Index: tip/include/linux/timekeeper_internal.h
===================================================================
--- tip.orig/include/linux/timekeeper_internal.h
+++ tip/include/linux/timekeeper_internal.h
@@ -36,6 +36,9 @@ struct timekeeper {
 	/* Clock shifted nano seconds */
 	u64			xtime_nsec;
 
+	/* Monotonic base time */
+	ktime_t			base_mono;
+
 	/* Current CLOCK_REALTIME time in seconds */
 	u64			xtime_sec;
 	/* CLOCK_REALTIME to CLOCK_MONOTONIC offset */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -50,12 +50,30 @@ int __read_mostly timekeeping_suspended;
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
 
+/*
+ * The xtime based monotonic readout is:
+ *	nsec = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec + now();
+ * The ktime based monotonic readout is:
+ *	nsec = base_mono + now();
+ * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
+ */
+static inline void tk_update_ktime_base(struct timekeeper *tk)
+{
+	s64 nsec;
+
+	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
+	nsec *= NSEC_PER_SEC;
+	nsec += tk->wall_to_monotonic.tv_nsec;
+	tk->base_mono = ns_to_ktime(nsec);
+}
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
 		tk->xtime_nsec -= (u64)NSEC_PER_SEC << tk->shift;
 		tk->xtime_sec++;
 	}
+	tk_update_ktime_base(tk);
 }
 
 static inline struct timespec64 tk_xtime(struct timekeeper *tk)
@@ -71,6 +89,7 @@ static void tk_set_xtime(struct timekeep
 {
 	tk->xtime_sec = ts->tv_sec;
 	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
+	tk_update_ktime_base(tk);
 }
 
 static void tk_xtime_add(struct timekeeper *tk, const struct timespec64 *ts)
@@ -93,6 +112,7 @@ static void tk_set_wall_to_mono(struct t
 	WARN_ON_ONCE(tk->offs_real.tv64 != timespec64_to_ktime(tmp).tv64);
 	tk->wall_to_monotonic = wtm;
 	set_normalized_timespec64(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
+	tk_update_ktime_base(tk);
 	tk->offs_real = timespec64_to_ktime(tmp);
 	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tk->tai_offset, 0));
 }
@@ -329,6 +349,7 @@ static void timekeeping_forward_now(stru
 	/* If arch requires, add in get_arch_timeoffset() */
 	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
 
+	/* Updates tk->base_mono as well */
 	tk_normalize_xtime(tk);
 
 	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
@@ -1448,6 +1469,10 @@ void update_wall_time(void)
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
 	clock_set |= accumulate_nsecs_to_secs(tk);
+	/*
+	 * Update the monotonic base
+	 */
+	tk_update_ktime_base(tk);
 
 	write_seqcount_begin(&tk_core.seq);
 	/* Update clock->cycle_last with the new value */


