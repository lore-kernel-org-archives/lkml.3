Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaBBVlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:41:18 -0500
Received: from www84.your-server.de ([213.133.104.84]:36723 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaBBVk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:56 -0500
From: stefani@seibold.net
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v9 8/8] Add 32 bit VDSO time support for 64 bit kernel
Date: Sun,  2 Feb 2014 22:41:33 +0100
Message-Id: <1391377293-9458-9-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391377293-9458-1-git-send-email-stefani@seibold.net>
References: <1391377293-9458-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch add the VDSO time support for the IA32 Emulation Layer.

Due the nature of the kernel headers and the LP64 compiler where the
size of a long and a pointer differs against a 32 bit compiler, there
is a lot of type hacking necessary.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vclock_gettime.c        | 109 +++++++++++++++++++++++++++-------
 arch/x86/vdso/vdso32/vclock_gettime.c |   7 +++
 2 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 42f641c..cd33f05 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -31,12 +31,24 @@
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
+struct api_timeval {
+	long	tv_sec;		/* seconds */
+	long	tv_usec;	/* microseconds */
+};
+
+struct api_timespec {
+	long	tv_sec;		/* seconds */
+	long	tv_nsec;	/* microseconds */
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
 
@@ -54,14 +67,62 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 }
 #else
 
+#ifdef CONFIG_IA32_EMULATION
+typedef s64	arch_time_t;
+
+struct arch_timespec {
+	s64	tv_sec;
+	s64	tv_nsec;
+};
+
+#define ALIGN8 __attribute__ ((aligned (8)))
+
+struct arch_vsyscall_gtod_data {
+	seqcount_t	seq ALIGN8;
+
+	struct { /* extract of a clocksource struct */
+		int vclock_mode ALIGN8;
+		cycle_t	cycle_last ALIGN8;
+		cycle_t	mask ALIGN8;
+		u32	mult;
+		u32	shift;
+	} clock;
+
+	/* open coded 'struct timespec' */
+	arch_time_t	wall_time_sec;
+	u64		wall_time_snsec;
+	u64		monotonic_time_snsec;
+	arch_time_t	monotonic_time_sec;
+
+	struct timezone sys_tz;
+	struct arch_timespec wall_time_coarse;
+	struct arch_timespec monotonic_time_coarse;
+};
+
+struct arch_vsyscall_gtod_data vvar_vsyscall_gtod_data
+	__attribute__((visibility("hidden")));
+#else
 struct vsyscall_gtod_data vvar_vsyscall_gtod_data
 	__attribute__((visibility("hidden")));
+#endif
 
 u8 hpet_page
 	__attribute__((visibility("hidden")));
 
 #define gtod (&vvar_vsyscall_gtod_data)
 
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
@@ -69,7 +130,7 @@ static notrace cycle_t vread_hpet(void)
 }
 #endif
 
-notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+notrace static long vdso_fallback_gettime(long clock, struct api_timespec *ts)
 {
 	long ret;
 
@@ -79,12 +140,12 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
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
@@ -95,7 +156,7 @@ notrace static long vdso_fallback_gtod(struct timeval *tv,
 		"call VDSO32_vsyscall \n"
 		"pop %%ebx \n"
 		: "=a" (ret)
-		: "0" (__NR_gettimeofday), "d" (tv), "c" (tz)
+		: "0" (__NR_ia32_gettimeofday), "d" (tv), "c" (tz)
 		: "memory");
 	return ret;
 }
@@ -284,42 +345,48 @@ notrace static void do_monotonic_coarse(struct timespec *ts)
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
-		if (do_realtime((struct timespec *)tv) == VCLOCK_NONE)
+		if (do_realtime(&tmp) == VCLOCK_NONE)
 			return vdso_fallback_gtod(tv, tz);
+		tv->tv_sec = tmp.tv_sec;
+		tv->tv_usec = tmp.tv_nsec;
 		tv->tv_usec /= 1000;
 	}
 	if (unlikely(tz != NULL)) {
@@ -330,21 +397,21 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 
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
index fab4ec6..b6df952 100644
--- a/arch/x86/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -2,6 +2,8 @@
 
 #ifdef CONFIG_X86_64
 
+#include <generated/asm/unistd_32_ia32.h>
+
 #define _ASM_X86_PAGE_H
 
 #define __pa(x)                0
@@ -10,6 +12,11 @@
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #define CONFIG_ILLEGAL_POINTER_VALUE   0
 
+#else
+
+#define __NR_ia32_clock_gettime	__NR_clock_gettime
+#define __NR_ia32_gettimeofday	__NR_gettimeofday
+
 #endif
 
 #include "../vclock_gettime.c"
-- 
1.8.5.3

