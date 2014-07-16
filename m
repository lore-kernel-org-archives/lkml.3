Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaGPVWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:22:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:59594 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaGPVDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:03:55 -0400
Message-Id: <20140716205052.508989785@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 04/64] ktime: Kill non-scalar ktime_t implementation for
 2038
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=jstultz-tk-d63a235.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

The non-scalar ktime_t implementation is basically a timespec
which has to be changed to support dates past 2038 on 32bit
systems.

This patch removes the non-scalar ktime_t implementation, forcing
the scalar s64 nanosecond version on all architectures.

This may have additional performance overhead on some 32bit
systems when converting between ktime_t and timespec structures,
however the majority of 32bit systems (arm and i386) were already
using scalar ktime_t, so no performance regressions will be seen
on those platforms.

On affected platforms, I'm open to finding optimizations, including
avoiding converting to timespecs where possible.

[ tglx: We can now cleanup the ktime_t.tv64 mess, but thats a
  different issue and we can throw a coccinelle script at it ]

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/Kconfig          |    1 
 arch/hexagon/Kconfig      |    1 
 arch/s390/Kconfig         |    1 
 arch/x86/Kconfig          |    1 
 include/linux/ktime.h     |  173 ----------------------------------------------
 include/linux/time.h      |   11 +-
 kernel/time/Kconfig       |    4 -
 kernel/time/hrtimer.c     |   54 --------------
 kernel/time/timekeeping.c |    7 -
 9 files changed, 7 insertions(+), 246 deletions(-)

Index: tip/arch/arm/Kconfig
===================================================================
--- tip.orig/arch/arm/Kconfig
+++ tip/arch/arm/Kconfig
@@ -64,7 +64,6 @@ config ARM
 	select HAVE_UID16
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select IRQ_FORCED_THREADING
-	select KTIME_SCALAR
 	select MODULES_USE_ELF_REL
 	select NO_BOOTMEM
 	select OLD_SIGACTION
Index: tip/arch/hexagon/Kconfig
===================================================================
--- tip.orig/arch/hexagon/Kconfig
+++ tip/arch/hexagon/Kconfig
@@ -23,7 +23,6 @@ config HEXAGON
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select STACKTRACE_SUPPORT
-	select KTIME_SCALAR
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select MODULES_USE_ELF_RELA
Index: tip/arch/s390/Kconfig
===================================================================
--- tip.orig/arch/s390/Kconfig
+++ tip/arch/s390/Kconfig
@@ -137,7 +137,6 @@ config S390
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16 if 32BIT
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select KTIME_SCALAR if 32BIT
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
 	select OLD_SIGACTION
Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -111,7 +111,6 @@ config X86
 	select ARCH_CLOCKSOURCE_DATA
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_TIME_VSYSCALL
-	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
Index: tip/include/linux/ktime.h
===================================================================
--- tip.orig/include/linux/ktime.h
+++ tip/include/linux/ktime.h
@@ -27,43 +27,19 @@
 /*
  * ktime_t:
  *
- * On 64-bit CPUs a single 64-bit variable is used to store the hrtimers
+ * A single 64-bit variable is used to store the hrtimers
  * internal representation of time values in scalar nanoseconds. The
  * design plays out best on 64-bit CPUs, where most conversions are
  * NOPs and most arithmetic ktime_t operations are plain arithmetic
  * operations.
  *
- * On 32-bit CPUs an optimized representation of the timespec structure
- * is used to avoid expensive conversions from and to timespecs. The
- * endian-aware order of the tv struct members is chosen to allow
- * mathematical operations on the tv64 member of the union too, which
- * for certain operations produces better code.
- *
- * For architectures with efficient support for 64/32-bit conversions the
- * plain scalar nanosecond based representation can be selected by the
- * config switch CONFIG_KTIME_SCALAR.
  */
 union ktime {
 	s64	tv64;
-#if BITS_PER_LONG != 64 && !defined(CONFIG_KTIME_SCALAR)
-	struct {
-# ifdef __BIG_ENDIAN
-	s32	sec, nsec;
-# else
-	s32	nsec, sec;
-# endif
-	} tv;
-#endif
 };
 
 typedef union ktime ktime_t;		/* Kill this */
 
-/*
- * ktime_t definitions when using the 64-bit scalar representation:
- */
-
-#if (BITS_PER_LONG == 64) || defined(CONFIG_KTIME_SCALAR)
-
 /**
  * ktime_set - Set a ktime_t variable from a seconds/nanoseconds value
  * @secs:	seconds to set
@@ -123,153 +99,6 @@ static inline ktime_t timeval_to_ktime(s
 /* Convert ktime_t to nanoseconds - NOP in the scalar storage format: */
 #define ktime_to_ns(kt)			((kt).tv64)
 
-#else	/* !((BITS_PER_LONG == 64) || defined(CONFIG_KTIME_SCALAR)) */
-
-/*
- * Helper macros/inlines to get the ktime_t math right in the timespec
- * representation. The macros are sometimes ugly - their actual use is
- * pretty okay-ish, given the circumstances. We do all this for
- * performance reasons. The pure scalar nsec_t based code was nice and
- * simple, but created too many 64-bit / 32-bit conversions and divisions.
- *
- * Be especially aware that negative values are represented in a way
- * that the tv.sec field is negative and the tv.nsec field is greater
- * or equal to zero but less than nanoseconds per second. This is the
- * same representation which is used by timespecs.
- *
- *   tv.sec < 0 and 0 >= tv.nsec < NSEC_PER_SEC
- */
-
-/* Set a ktime_t variable to a value in sec/nsec representation: */
-static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
-{
-	return (ktime_t) { .tv = { .sec = secs, .nsec = nsecs } };
-}
-
-/**
- * ktime_sub - subtract two ktime_t variables
- * @lhs:	minuend
- * @rhs:	subtrahend
- *
- * Return: The remainder of the subtraction.
- */
-static inline ktime_t ktime_sub(const ktime_t lhs, const ktime_t rhs)
-{
-	ktime_t res;
-
-	res.tv64 = lhs.tv64 - rhs.tv64;
-	if (res.tv.nsec < 0)
-		res.tv.nsec += NSEC_PER_SEC;
-
-	return res;
-}
-
-/**
- * ktime_add - add two ktime_t variables
- * @add1:	addend1
- * @add2:	addend2
- *
- * Return: The sum of @add1 and @add2.
- */
-static inline ktime_t ktime_add(const ktime_t add1, const ktime_t add2)
-{
-	ktime_t res;
-
-	res.tv64 = add1.tv64 + add2.tv64;
-	/*
-	 * performance trick: the (u32) -NSEC gives 0x00000000Fxxxxxxx
-	 * so we subtract NSEC_PER_SEC and add 1 to the upper 32 bit.
-	 *
-	 * it's equivalent to:
-	 *   tv.nsec -= NSEC_PER_SEC
-	 *   tv.sec ++;
-	 */
-	if (res.tv.nsec >= NSEC_PER_SEC)
-		res.tv64 += (u32)-NSEC_PER_SEC;
-
-	return res;
-}
-
-/**
- * ktime_add_ns - Add a scalar nanoseconds value to a ktime_t variable
- * @kt:		addend
- * @nsec:	the scalar nsec value to add
- *
- * Return: The sum of @kt and @nsec in ktime_t format.
- */
-extern ktime_t ktime_add_ns(const ktime_t kt, u64 nsec);
-
-/**
- * ktime_sub_ns - Subtract a scalar nanoseconds value from a ktime_t variable
- * @kt:		minuend
- * @nsec:	the scalar nsec value to subtract
- *
- * Return: The subtraction of @nsec from @kt in ktime_t format.
- */
-extern ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec);
-
-/**
- * timespec_to_ktime - convert a timespec to ktime_t format
- * @ts:		the timespec variable to convert
- *
- * Return: A ktime_t variable with the converted timespec value.
- */
-static inline ktime_t timespec_to_ktime(const struct timespec ts)
-{
-	return (ktime_t) { .tv = { .sec = (s32)ts.tv_sec,
-			   	   .nsec = (s32)ts.tv_nsec } };
-}
-
-/**
- * timeval_to_ktime - convert a timeval to ktime_t format
- * @tv:		the timeval variable to convert
- *
- * Return: A ktime_t variable with the converted timeval value.
- */
-static inline ktime_t timeval_to_ktime(const struct timeval tv)
-{
-	return (ktime_t) { .tv = { .sec = (s32)tv.tv_sec,
-				   .nsec = (s32)(tv.tv_usec *
-						 NSEC_PER_USEC) } };
-}
-
-/**
- * ktime_to_timespec - convert a ktime_t variable to timespec format
- * @kt:		the ktime_t variable to convert
- *
- * Return: The timespec representation of the ktime value.
- */
-static inline struct timespec ktime_to_timespec(const ktime_t kt)
-{
-	return (struct timespec) { .tv_sec = (time_t) kt.tv.sec,
-				   .tv_nsec = (long) kt.tv.nsec };
-}
-
-/**
- * ktime_to_timeval - convert a ktime_t variable to timeval format
- * @kt:		the ktime_t variable to convert
- *
- * Return: The timeval representation of the ktime value.
- */
-static inline struct timeval ktime_to_timeval(const ktime_t kt)
-{
-	return (struct timeval) {
-		.tv_sec = (time_t) kt.tv.sec,
-		.tv_usec = (suseconds_t) (kt.tv.nsec / NSEC_PER_USEC) };
-}
-
-/**
- * ktime_to_ns - convert a ktime_t variable to scalar nanoseconds
- * @kt:		the ktime_t variable to convert
- *
- * Return: The scalar nanoseconds representation of @kt.
- */
-static inline s64 ktime_to_ns(const ktime_t kt)
-{
-	return (s64) kt.tv.sec * NSEC_PER_SEC + kt.tv.nsec;
-}
-
-#endif	/* !((BITS_PER_LONG == 64) || defined(CONFIG_KTIME_SCALAR)) */
 
 /**
  * ktime_equal - Compares two ktime_t variables to see if they are equal
Index: tip/include/linux/time.h
===================================================================
--- tip.orig/include/linux/time.h
+++ tip/include/linux/time.h
@@ -19,6 +19,10 @@ extern struct timezone sys_tz;
 
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
 
+/* Located here for timespec_valid_strict */
+#define KTIME_MAX			((s64)~((u64)1 << 63))
+#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+
 static inline int timespec_equal(const struct timespec *a,
                                  const struct timespec *b)
 {
@@ -84,13 +88,6 @@ static inline struct timespec timespec_s
 	return ts_delta;
 }
 
-#define KTIME_MAX			((s64)~((u64)1 << 63))
-#if (BITS_PER_LONG == 64)
-# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-#else
-# define KTIME_SEC_MAX			LONG_MAX
-#endif
-
 /*
  * Returns true if the timespec is norm, false if denorm:
  */
Index: tip/kernel/time/Kconfig
===================================================================
--- tip.orig/kernel/time/Kconfig
+++ tip/kernel/time/Kconfig
@@ -20,10 +20,6 @@ config GENERIC_TIME_VSYSCALL
 config GENERIC_TIME_VSYSCALL_OLD
 	bool
 
-# ktime_t scalar 64bit nsec representation
-config KTIME_SCALAR
-	bool
-
 # Old style timekeeping
 config ARCH_USES_GETTIMEOFFSET
 	bool
Index: tip/kernel/time/hrtimer.c
===================================================================
--- tip.orig/kernel/time/hrtimer.c
+++ tip/kernel/time/hrtimer.c
@@ -261,60 +261,6 @@ lock_hrtimer_base(const struct hrtimer *
  * too large for inlining:
  */
 #if BITS_PER_LONG < 64
-# ifndef CONFIG_KTIME_SCALAR
-/**
- * ktime_add_ns - Add a scalar nanoseconds value to a ktime_t variable
- * @kt:		addend
- * @nsec:	the scalar nsec value to add
- *
- * Returns the sum of kt and nsec in ktime_t format
- */
-ktime_t ktime_add_ns(const ktime_t kt, u64 nsec)
-{
-	ktime_t tmp;
-
-	if (likely(nsec < NSEC_PER_SEC)) {
-		tmp.tv64 = nsec;
-	} else {
-		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
-
-		/* Make sure nsec fits into long */
-		if (unlikely(nsec > KTIME_SEC_MAX))
-			return (ktime_t){ .tv64 = KTIME_MAX };
-
-		tmp = ktime_set((long)nsec, rem);
-	}
-
-	return ktime_add(kt, tmp);
-}
-
-EXPORT_SYMBOL_GPL(ktime_add_ns);
-
-/**
- * ktime_sub_ns - Subtract a scalar nanoseconds value from a ktime_t variable
- * @kt:		minuend
- * @nsec:	the scalar nsec value to subtract
- *
- * Returns the subtraction of @nsec from @kt in ktime_t format
- */
-ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
-{
-	ktime_t tmp;
-
-	if (likely(nsec < NSEC_PER_SEC)) {
-		tmp.tv64 = nsec;
-	} else {
-		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
-
-		tmp = ktime_set((long)nsec, rem);
-	}
-
-	return ktime_sub(kt, tmp);
-}
-
-EXPORT_SYMBOL_GPL(ktime_sub_ns);
-# endif /* !CONFIG_KTIME_SCALAR */
-
 /*
  * Divide a ktime value by a nanosecond value
  */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -344,11 +344,8 @@ ktime_t ktime_get(void)
 		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
 
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
-	/*
-	 * Use ktime_set/ktime_add_ns to create a proper ktime on
-	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
-	 */
-	return ktime_add_ns(ktime_set(secs, 0), nsecs);
+
+	return ktime_set(secs, nsecs);
 }
 EXPORT_SYMBOL_GPL(ktime_get);
 


