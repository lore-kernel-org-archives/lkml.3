Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaGPVEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:59627 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaGPVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:04 -0400
Message-Id: <20140716205053.029414464@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 10/64] time: Consolidate the time accessor prototypes
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=time-move-all-accessor-prototypes-into-separate-header.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we have time related prototypes in 3 different header
files. Move it to a single timekeeping header file and move the core
internal stuff into a core private header.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h     |   11 ------
 include/linux/ktime.h       |    8 +---
 include/linux/time.h        |   45 ++-----------------------
 include/linux/timekeeping.h |   78 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/time/hrtimer.c       |    2 +
 kernel/time/posix-timers.c  |    2 +
 kernel/time/tick-internal.h |    2 +
 kernel/time/time.c          |    1 
 kernel/time/timekeeping.h   |   20 +++++++++++
 9 files changed, 111 insertions(+), 58 deletions(-)

Index: tip/include/linux/hrtimer.h
===================================================================
--- tip.orig/include/linux/hrtimer.h
+++ tip/include/linux/hrtimer.h
@@ -326,17 +326,6 @@ static inline void timerfd_clock_was_set
 #endif
 extern void hrtimers_resume(void);
 
-extern ktime_t ktime_get(void);
-extern ktime_t ktime_get_real(void);
-extern ktime_t ktime_get_boottime(void);
-extern ktime_t ktime_get_monotonic_offset(void);
-extern ktime_t ktime_get_clocktai(void);
-extern ktime_t ktime_get_update_offsets_tick(ktime_t *offs_real,
-						ktime_t *offs_boot,
-						ktime_t *offs_tai);
-extern ktime_t ktime_get_update_offsets_now(ktime_t *offs_real,
-						ktime_t *offs_boot,
-						ktime_t *offs_tai);
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
 
Index: tip/include/linux/ktime.h
===================================================================
--- tip.orig/include/linux/ktime.h
+++ tip/include/linux/ktime.h
@@ -250,12 +250,6 @@ static inline __must_check bool ktime_to
 #define LOW_RES_NSEC		TICK_NSEC
 #define KTIME_LOW_RES		(ktime_t){ .tv64 = LOW_RES_NSEC }
 
-/* Get the monotonic time in timespec format: */
-extern void ktime_get_ts(struct timespec *ts);
-
-/* Get the real (wall-) time in timespec format: */
-#define ktime_get_real_ts(ts)	getnstimeofday(ts)
-
 static inline ktime_t ns_to_ktime(u64 ns)
 {
 	static const ktime_t ktime_zero = { .tv64 = 0 };
@@ -270,4 +264,6 @@ static inline ktime_t ms_to_ktime(u64 ms
 	return ktime_add_ms(ktime_zero, ms);
 }
 
+# include <linux/timekeeping.h>
+
 #endif
Index: tip/include/linux/time.h
===================================================================
--- tip.orig/include/linux/time.h
+++ tip/include/linux/time.h
@@ -99,25 +99,7 @@ static inline bool timespec_valid_strict
 	return true;
 }
 
-extern bool persistent_clock_exist;
-
-static inline bool has_persistent_clock(void)
-{
-	return persistent_clock_exist;
-}
-
-extern void read_persistent_clock(struct timespec *ts);
-extern void read_boot_clock(struct timespec *ts);
-extern int persistent_clock_is_local;
-extern int update_persistent_clock(struct timespec now);
-void timekeeping_init(void);
-extern int timekeeping_suspended;
-
-unsigned long get_seconds(void);
-struct timespec current_kernel_time(void);
-struct timespec __current_kernel_time(void); /* does not take xtime_lock */
-struct timespec get_monotonic_coarse(void);
-void timekeeping_inject_sleeptime(struct timespec *delta);
+extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -135,33 +117,14 @@ void timekeeping_inject_sleeptime(struct
 extern u32 (*arch_gettimeoffset)(void);
 #endif
 
-extern void do_gettimeofday(struct timeval *tv);
-extern int do_settimeofday(const struct timespec *tv);
-extern int do_sys_settimeofday(const struct timespec *tv,
-			       const struct timezone *tz);
-#define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
-extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
-extern int __getnstimeofday(struct timespec *tv);
-extern void getnstimeofday(struct timespec *tv);
-extern void getrawmonotonic(struct timespec *ts);
-extern void getnstime_raw_and_real(struct timespec *ts_raw,
-		struct timespec *ts_real);
-extern void getboottime(struct timespec *ts);
-extern void monotonic_to_bootbased(struct timespec *ts);
-extern void get_monotonic_boottime(struct timespec *ts);
 
-extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
-extern int timekeeping_valid_for_hres(void);
-extern u64 timekeeping_max_deferment(void);
-extern int timekeeping_inject_offset(struct timespec *ts);
-extern s32 timekeeping_get_tai_offset(void);
-extern void timekeeping_set_tai_offset(s32 tai_offset);
-extern void timekeeping_clocktai(struct timespec *ts);
+extern unsigned int alarm_setitimer(unsigned int seconds);
+
+extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 
 struct tms;
 extern void do_sys_times(struct tms *);
Index: tip/include/linux/timekeeping.h
===================================================================
--- /dev/null
+++ tip/include/linux/timekeeping.h
@@ -0,0 +1,78 @@
+#ifndef _LINUX_TIMEKEEPING_H
+#define _LINUX_TIMEKEEPING_H
+
+/* Included from linux/ktime.h */
+
+void timekeeping_init(void);
+extern int timekeeping_suspended;
+
+/*
+ * Get and set timeofday
+ */
+extern void do_gettimeofday(struct timeval *tv);
+extern int do_settimeofday(const struct timespec *tv);
+extern int do_sys_settimeofday(const struct timespec *tv,
+			       const struct timezone *tz);
+
+/*
+ * Kernel time accessors
+ */
+unsigned long get_seconds(void);
+struct timespec current_kernel_time(void);
+/* does not take xtime_lock */
+struct timespec __current_kernel_time(void);
+
+/*
+ * timespec based interfaces
+ */
+struct timespec get_monotonic_coarse(void);
+extern void getrawmonotonic(struct timespec *ts);
+extern void monotonic_to_bootbased(struct timespec *ts);
+extern void get_monotonic_boottime(struct timespec *ts);
+extern void ktime_get_ts(struct timespec *ts);
+
+extern int __getnstimeofday(struct timespec *tv);
+extern void getnstimeofday(struct timespec *tv);
+extern void getboottime(struct timespec *ts);
+
+#define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
+#define ktime_get_real_ts(ts)	getnstimeofday(ts)
+
+
+/*
+ * ktime_t based interfaces
+ */
+extern ktime_t ktime_get(void);
+extern ktime_t ktime_get_real(void);
+extern ktime_t ktime_get_boottime(void);
+extern ktime_t ktime_get_monotonic_offset(void);
+extern ktime_t ktime_get_clocktai(void);
+
+/*
+ * RTC specific
+ */
+extern void timekeeping_inject_sleeptime(struct timespec *delta);
+
+/*
+ * PPS accessor
+ */
+extern void getnstime_raw_and_real(struct timespec *ts_raw,
+				   struct timespec *ts_real);
+
+/*
+ * Persistent clock related interfaces
+ */
+extern bool persistent_clock_exist;
+extern int persistent_clock_is_local;
+
+static inline bool has_persistent_clock(void)
+{
+	return persistent_clock_exist;
+}
+
+extern void read_persistent_clock(struct timespec *ts);
+extern void read_boot_clock(struct timespec *ts);
+extern int update_persistent_clock(struct timespec now);
+
+
+#endif
Index: tip/kernel/time/hrtimer.c
===================================================================
--- tip.orig/kernel/time/hrtimer.c
+++ tip/kernel/time/hrtimer.c
@@ -54,6 +54,8 @@
 
 #include <trace/events/timer.h>
 
+#include "timekeeping.h"
+
 /*
  * The timer bases:
  *
Index: tip/kernel/time/posix-timers.c
===================================================================
--- tip.orig/kernel/time/posix-timers.c
+++ tip/kernel/time/posix-timers.c
@@ -49,6 +49,8 @@
 #include <linux/export.h>
 #include <linux/hashtable.h>
 
+#include "timekeeping.h"
+
 /*
  * Management arrays for POSIX timers. Timers are now kept in static hash table
  * with 512 entries.
Index: tip/kernel/time/tick-internal.h
===================================================================
--- tip.orig/kernel/time/tick-internal.h
+++ tip/kernel/time/tick-internal.h
@@ -4,6 +4,8 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
+#include "timekeeping.h"
+
 extern seqlock_t jiffies_lock;
 
 #define CS_NAME_LEN	32
Index: tip/kernel/time/time.c
===================================================================
--- tip.orig/kernel/time/time.c
+++ tip/kernel/time/time.c
@@ -42,6 +42,7 @@
 #include <asm/unistd.h>
 
 #include "timeconst.h"
+#include "timekeeping.h"
 
 /*
  * The timezone where the local system is located.  Used as a default by some
Index: tip/kernel/time/timekeeping.h
===================================================================
--- /dev/null
+++ tip/kernel/time/timekeeping.h
@@ -0,0 +1,20 @@
+#ifndef _KERNEL_TIME_TIMEKEEPING_H
+#define _KERNEL_TIME_TIMEKEEPING_H
+/*
+ * Internal interfaces for kernel/time/
+ */
+extern ktime_t ktime_get_update_offsets_tick(ktime_t *offs_real,
+						ktime_t *offs_boot,
+						ktime_t *offs_tai);
+extern ktime_t ktime_get_update_offsets_now(ktime_t *offs_real,
+						ktime_t *offs_boot,
+						ktime_t *offs_tai);
+
+extern int timekeeping_valid_for_hres(void);
+extern u64 timekeeping_max_deferment(void);
+extern int timekeeping_inject_offset(struct timespec *ts);
+extern s32 timekeeping_get_tai_offset(void);
+extern void timekeeping_set_tai_offset(s32 tai_offset);
+extern void timekeeping_clocktai(struct timespec *ts);
+
+#endif


