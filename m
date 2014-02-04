Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaBDKPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:15:25 -0500
Received: from www84.your-server.de ([213.133.104.84]:38133 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaBDKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:14:34 -0500
From: stefani@seibold.net
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v11 9/9] Add 32 bit VDSO time support for 64 bit kernel
Date: Tue,  4 Feb 2014 11:15:08 +0100
Message-Id: <1391508908-32239-10-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391508908-32239-1-git-send-email-stefani@seibold.net>
References: <1391508908-32239-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch add the VDSO time support for the IA32 Emulation Layer.

Due the nature of the kernel headers and the LP64 compiler where the
size of a long and a pointer differs against a 32 bit compiler, there
is a lot of type hacking necessary.

The vsyscall_gtod_data struture must be a little bit rearranged, to
serve for 32- and 64-bit code access.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/vgtod.h          | 23 +++++----
 arch/x86/kernel/vsyscall_gtod.c       | 10 ++--
 arch/x86/vdso/vclock_gettime.c        | 93 +++++++++++++++++++++++------------
 arch/x86/vdso/vdso32/vclock_gettime.c | 11 +++++
 include/uapi/linux/time.h             |  2 +-
 5 files changed, 92 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 46e24d3..3032eb8 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -4,16 +4,16 @@
 #include <asm/vsyscall.h>
 #include <linux/clocksource.h>
 
-struct vsyscall_gtod_data {
-	seqcount_t	seq;
-
-	struct { /* extract of a clocksource struct */
-		int vclock_mode;
-		cycle_t	cycle_last;
-		cycle_t	mask;
-		u32	mult;
-		u32	shift;
-	} clock;
+/*
+ * vsyscall_gtod_data will be accessed by 32 and 64 bit code at the same time
+ * so the structure must be packed
+ */
+struct __attribute__((packed)) vsyscall_gtod_data {
+	int vclock_mode;
+	cycle_t	cycle_last;
+	cycle_t	mask;
+	u32	mult;
+	u32	shift;
 
 	/* open coded 'struct timespec' */
 	time_t		wall_time_sec;
@@ -24,6 +24,9 @@ struct vsyscall_gtod_data {
 	struct timezone sys_tz;
 	struct timespec wall_time_coarse;
 	struct timespec monotonic_time_coarse;
+
+	/* must be at the end, because the size depends on the kernel config */
+	seqcount_t	seq;
 };
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
index 91862a4..319dd55 100644
--- a/arch/x86/kernel/vsyscall_gtod.c
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -28,11 +28,11 @@ void update_vsyscall(struct timekeeper *tk)
 	write_seqcount_begin(&vdata->seq);
 
 	/* copy vsyscall data */
-	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->clock.cycle_last		= tk->clock->cycle_last;
-	vdata->clock.mask		= tk->clock->mask;
-	vdata->clock.mult		= tk->mult;
-	vdata->clock.shift		= tk->shift;
+	vdata->vclock_mode	= tk->clock->archdata.vclock_mode;
+	vdata->cycle_last	= tk->clock->cycle_last;
+	vdata->mask		= tk->clock->mask;
+	vdata->mult		= tk->mult;
+	vdata->shift		= tk->shift;
 
 	vdata->wall_time_sec		= tk->xtime_sec;
 	vdata->wall_time_snsec		= tk->xtime_nsec;
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 469e57b..187dac9 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -31,12 +31,24 @@
 
 #ifndef BUILD_VDSO32
 
+struct api_timeval {
+	long	tv_sec;		/* seconds */
+	long	tv_usec;	/* microseconds */
+};
+
+struct api_timespec {
+	long	tv_sec;		/* seconds */
+	long	tv_nsec;	/* nanoseconds */
+};
+
+typedef long api_time_t;
+
 static notrace cycle_t vread_hpet(void)
 {
 	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
 }
 
-notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+notrace static long vdso_fallback_gettime(long clock, struct api_timespec *ts)
 {
 	long ret;
 	asm("syscall" : "=a" (ret) :
@@ -44,7 +56,8 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	return ret;
 }
 
-notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
+notrace static long vdso_fallback_gtod(struct api_timeval *tv,
+		struct timezone *tz)
 {
 	long ret;
 
@@ -57,6 +70,18 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 u8 hpet_page
 	__attribute__((visibility("hidden")));
 
+struct api_timeval {
+	s32	tv_sec;		/* seconds */
+	s32	tv_usec;	/* microseconds */
+};
+
+struct api_timespec {
+	s32	tv_sec;		/* seconds */
+	s32	tv_nsec;	/* microseconds */
+};
+
+typedef s32 api_time_t;
+
 #ifdef CONFIG_HPET_TIMER
 static notrace cycle_t vread_hpet(void)
 {
@@ -64,7 +89,7 @@ static notrace cycle_t vread_hpet(void)
 }
 #endif
 
-notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+notrace static long vdso_fallback_gettime(long clock, struct api_timespec *ts)
 {
 	long ret;
 
@@ -74,12 +99,12 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 		"call VDSO32_vsyscall \n"
 		"pop %%ebx \n"
 		: "=a" (ret)
-		: "0" (__NR_clock_gettime), "d" (clock), "c" (ts)
+		: "0" (__NR_ia32_clock_gettime), "d" (clock), "c" (ts)
 		: "memory");
 	return ret;
 }
 
-notrace static long vdso_fallback_gtod(struct timeval *tv,
+notrace static long vdso_fallback_gtod(struct api_timeval *tv,
 		struct timezone *tz)
 {
 	long ret;
@@ -90,7 +115,7 @@ notrace static long vdso_fallback_gtod(struct timeval *tv,
 		"call VDSO32_vsyscall \n"
 		"pop %%ebx \n"
 		: "=a" (ret)
-		: "0" (__NR_gettimeofday), "d" (tv), "c" (tz)
+		: "0" (__NR_ia32_gettimeofday), "d" (tv), "c" (tz)
 		: "memory");
 	return ret;
 }
@@ -157,7 +182,7 @@ static notrace cycle_t vread_pvclock(int *mode)
 		*mode = VCLOCK_NONE;
 
 	/* refer to tsc.c read_tsc() comment for rationale */
-	last = gtod->clock.cycle_last;
+	last = gtod->cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -181,7 +206,7 @@ notrace static cycle_t vread_tsc(void)
 	rdtsc_barrier();
 	ret = (cycle_t)vget_cycles();
 
-	last = gtod->clock.cycle_last;
+	last = gtod->cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -202,20 +227,20 @@ notrace static inline u64 vgetsns(int *mode)
 {
 	u64 v;
 	cycles_t cycles;
-	if (gtod->clock.vclock_mode == VCLOCK_TSC)
+	if (gtod->vclock_mode == VCLOCK_TSC)
 		cycles = vread_tsc();
 #ifdef CONFIG_HPET_TIMER
-	else if (gtod->clock.vclock_mode == VCLOCK_HPET)
+	else if (gtod->vclock_mode == VCLOCK_HPET)
 		cycles = vread_hpet();
 #endif
 #ifdef CONFIG_PARAVIRT_CLOCK
-	else if (gtod->clock.vclock_mode == VCLOCK_PVCLOCK)
+	else if (gtod->vclock_mode == VCLOCK_PVCLOCK)
 		cycles = vread_pvclock(mode);
 #endif
 	else
 		return 0;
-	v = (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
-	return v * gtod->clock.mult;
+	v = (cycles - gtod->cycle_last) & gtod->mask;
+	return v * gtod->mult;
 }
 
 /* Code size doesn't matter (vdso is 4k anyway) and this is faster. */
@@ -228,11 +253,11 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 	ts->tv_nsec = 0;
 	do {
 		seq = raw_read_seqcount_begin(&gtod->seq);
-		mode = gtod->clock.vclock_mode;
+		mode = gtod->vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ns = gtod->wall_time_snsec;
 		ns += vgetsns(&mode);
-		ns >>= gtod->clock.shift;
+		ns >>= gtod->shift;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 
 	timespec_add_ns(ts, ns);
@@ -248,11 +273,11 @@ notrace static int do_monotonic(struct timespec *ts)
 	ts->tv_nsec = 0;
 	do {
 		seq = raw_read_seqcount_begin(&gtod->seq);
-		mode = gtod->clock.vclock_mode;
+		mode = gtod->vclock_mode;
 		ts->tv_sec = gtod->monotonic_time_sec;
 		ns = gtod->monotonic_time_snsec;
 		ns += vgetsns(&mode);
-		ns >>= gtod->clock.shift;
+		ns >>= gtod->shift;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	timespec_add_ns(ts, ns);
 
@@ -279,42 +304,48 @@ notrace static void do_monotonic_coarse(struct timespec *ts)
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 }
 
-notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+notrace int __vdso_clock_gettime(clockid_t clock, struct api_timespec *ts)
 {
+	struct timespec tmp;
+
 	switch (clock) {
 	case CLOCK_REALTIME:
-		if (do_realtime(ts) == VCLOCK_NONE)
+		if (do_realtime(&tmp) == VCLOCK_NONE)
 			goto fallback;
 		break;
 	case CLOCK_MONOTONIC:
-		if (do_monotonic(ts) == VCLOCK_NONE)
+		if (do_monotonic(&tmp) == VCLOCK_NONE)
 			goto fallback;
 		break;
 	case CLOCK_REALTIME_COARSE:
-		do_realtime_coarse(ts);
+		do_realtime_coarse(&tmp);
 		break;
 	case CLOCK_MONOTONIC_COARSE:
-		do_monotonic_coarse(ts);
+		do_monotonic_coarse(&tmp);
 		break;
 	default:
 		goto fallback;
 	}
 
+	ts->tv_sec = tmp.tv_sec;
+	ts->tv_nsec = tmp.tv_nsec;
+
 	return 0;
 fallback:
 	return vdso_fallback_gettime(clock, ts);
 }
-int clock_gettime(clockid_t, struct timespec *)
+int clock_gettime(clockid_t, struct api_timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
-notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+notrace int __vdso_gettimeofday(struct api_timeval *tv, struct timezone *tz)
 {
+	struct timespec tmp;
+
 	if (likely(tv != NULL)) {
-		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-			     offsetof(struct timespec, tv_nsec) ||
-			     sizeof(*tv) != sizeof(struct timespec));
 		if (unlikely(do_realtime(&tmp) == VCLOCK_NONE))
 			return vdso_fallback_gtod(tv, tz);
+		tv->tv_sec = tmp.tv_sec;
+		tv->tv_usec = tmp.tv_nsec;
 		tv->tv_usec /= 1000;
 	}
 	if (unlikely(tz != NULL)) {
@@ -325,21 +356,21 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 
 	return 0;
 }
-int gettimeofday(struct timeval *, struct timezone *)
+int gettimeofday(struct api_timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
 
 /*
  * This will break when the xtime seconds get inaccurate, but that is
  * unlikely
  */
-notrace time_t __vdso_time(time_t *t)
+notrace api_time_t __vdso_time(api_time_t *t)
 {
 	/* This is atomic on x86 so we don't need any locks. */
-	time_t result = ACCESS_ONCE(gtod->wall_time_sec);
+	api_time_t result = ACCESS_ONCE(gtod->wall_time_sec);
 
 	if (t)
 		*t = result;
 	return result;
 }
-int time(time_t *t)
+int time(api_time_t *t)
 	__attribute__((weak, alias("__vdso_time")));
diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
index fab4ec6..b8a3b22 100644
--- a/arch/x86/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -2,6 +2,12 @@
 
 #ifdef CONFIG_X86_64
 
+typedef signed long long	__kernel_long_t;
+typedef unsigned long long	__kernel_ulong_t;
+#define __kernel_long_t __kernel_long_t
+
+#include <generated/asm/unistd_32_ia32.h>
+
 #define _ASM_X86_PAGE_H
 
 #define __pa(x)                0
@@ -10,6 +16,11 @@
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #define CONFIG_ILLEGAL_POINTER_VALUE   0
 
+#else
+
+#define __NR_ia32_clock_gettime	__NR_clock_gettime
+#define __NR_ia32_gettimeofday	__NR_gettimeofday
+
 #endif
 
 #include "../vclock_gettime.c"
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index e75e1b6..ebf3734 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -8,7 +8,7 @@
 #define _STRUCT_TIMESPEC
 struct timespec {
 	__kernel_time_t	tv_sec;			/* seconds */
-	long		tv_nsec;		/* nanoseconds */
+	__kernel_long_t	tv_nsec;		/* nanoseconds */
 };
 #endif
 
-- 
1.8.5.3

