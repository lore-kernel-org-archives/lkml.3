Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaGPVWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:22:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:59590 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaGPVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:03:54 -0400
Message-Id: <20140716205052.434915186@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 03/64] hrtimer: Cleanup hrtimer accessors to the
 timekepeing state
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=jstultz-tk-ed502d8.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Rather then having two similar but totally different implementations
that provide timekeeping state to the hrtimer code, try to unify the
two implementations to be more simliar.

Thus this clarifies ktime_get_update_offsets to
ktime_get_update_offsets_now and changes get_xtime...  to
ktime_get_update_offsets_tick.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/hrtimer.h   |    9 ++++++---
 include/linux/time.h      |    2 --
 kernel/time/hrtimer.c     |   23 ++++++++++-------------
 kernel/time/timekeeping.c |   36 +++++++++++++++++++++++-------------
 4 files changed, 39 insertions(+), 31 deletions(-)

Index: tip/include/linux/hrtimer.h
===================================================================
--- tip.orig/include/linux/hrtimer.h
+++ tip/include/linux/hrtimer.h
@@ -331,9 +331,12 @@ extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
 extern ktime_t ktime_get_clocktai(void);
-extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
-					 ktime_t *offs_tai);
-
+extern ktime_t ktime_get_update_offsets_tick(ktime_t *offs_real,
+						ktime_t *offs_boot,
+						ktime_t *offs_tai);
+extern ktime_t ktime_get_update_offsets_now(ktime_t *offs_real,
+						ktime_t *offs_boot,
+						ktime_t *offs_tai);
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
 
Index: tip/include/linux/time.h
===================================================================
--- tip.orig/include/linux/time.h
+++ tip/include/linux/time.h
@@ -133,8 +133,6 @@ unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
-void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
-				struct timespec *wtom, struct timespec *sleep);
 void timekeeping_inject_sleeptime(struct timespec *delta);
 
 #define CURRENT_TIME		(current_kernel_time())
Index: tip/kernel/time/hrtimer.c
===================================================================
--- tip.orig/kernel/time/hrtimer.c
+++ tip/kernel/time/hrtimer.c
@@ -114,21 +114,18 @@ static inline int hrtimer_clockid_to_bas
  */
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
-	ktime_t xtim, mono, boot;
-	struct timespec xts, tom, slp;
-	s32 tai_offset;
-
-	get_xtime_and_monotonic_and_sleep_offset(&xts, &tom, &slp);
-	tai_offset = timekeeping_get_tai_offset();
-
-	xtim = timespec_to_ktime(xts);
-	mono = ktime_add(xtim, timespec_to_ktime(tom));
-	boot = ktime_add(mono, timespec_to_ktime(slp));
+	ktime_t xtim, mono, boot, tai;
+	ktime_t off_real, off_boot, off_tai;
+
+	mono = ktime_get_update_offsets_tick(&off_real, &off_boot, &off_tai);
+	boot = ktime_add(mono, off_boot);
+	xtim = ktime_add(mono, off_real);
+	tai = ktime_add(xtim, off_tai);
+
 	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
 	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time = mono;
 	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time = boot;
-	base->clock_base[HRTIMER_BASE_TAI].softirq_time =
-				ktime_add(xtim,	ktime_set(tai_offset, 0));
+	base->clock_base[HRTIMER_BASE_TAI].softirq_time = tai;
 }
 
 /*
@@ -673,7 +670,7 @@ static inline ktime_t hrtimer_update_bas
 	ktime_t *offs_boot = &base->clock_base[HRTIMER_BASE_BOOTTIME].offset;
 	ktime_t *offs_tai = &base->clock_base[HRTIMER_BASE_TAI].offset;
 
-	return ktime_get_update_offsets(offs_real, offs_boot, offs_tai);
+	return ktime_get_update_offsets_now(offs_real, offs_boot, offs_tai);
 }
 
 /*
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -1581,29 +1581,39 @@ void do_timer(unsigned long ticks)
 }
 
 /**
- * get_xtime_and_monotonic_and_sleep_offset() - get xtime, wall_to_monotonic,
- *    and sleep offsets.
- * @xtim:	pointer to timespec to be set with xtime
- * @wtom:	pointer to timespec to be set with wall_to_monotonic
- * @sleep:	pointer to timespec to be set with time in suspend
+ * ktime_get_update_offsets_tick - hrtimer helper
+ * @offs_real:	pointer to storage for monotonic -> realtime offset
+ * @offs_boot:	pointer to storage for monotonic -> boottime offset
+ * @offs_tai:	pointer to storage for monotonic -> clock tai offset
+ *
+ * Returns monotonic time at last tick and various offsets
  */
-void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
-				struct timespec *wtom, struct timespec *sleep)
+ktime_t ktime_get_update_offsets_tick(ktime_t *offs_real, ktime_t *offs_boot,
+							ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	struct timespec ts;
+	ktime_t now;
+	unsigned int seq;
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
-		*xtim = tk_xtime(tk);
-		*wtom = tk->wall_to_monotonic;
-		*sleep = tk->total_sleep_time;
+
+		ts = tk_xtime(tk);
+
+		*offs_real = tk->offs_real;
+		*offs_boot = tk->offs_boot;
+		*offs_tai = tk->offs_tai;
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
+
+	now = ktime_set(ts.tv_sec, ts.tv_nsec);
+	now = ktime_sub(now, *offs_real);
+	return now;
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 /**
- * ktime_get_update_offsets - hrtimer helper
+ * ktime_get_update_offsets_now - hrtimer helper
  * @offs_real:	pointer to storage for monotonic -> realtime offset
  * @offs_boot:	pointer to storage for monotonic -> boottime offset
  * @offs_tai:	pointer to storage for monotonic -> clock tai offset
@@ -1611,7 +1621,7 @@ void get_xtime_and_monotonic_and_sleep_o
  * Returns current monotonic time and updates the offsets
  * Called from hrtimer_interrupt() or retrigger_next_event()
  */
-ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
+ktime_t ktime_get_update_offsets_now(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
 {
 	struct timekeeper *tk = &timekeeper;


