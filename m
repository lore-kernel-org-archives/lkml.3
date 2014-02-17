Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaBQAy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:54:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51765 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaBQAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:54:23 -0500
Date: Sun, 16 Feb 2014 16:53:59 -0800
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-249adfe2c86766eaa739d342525e55a96bf9efa7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392587568-7325-10-git-send-email-stefani@seibold.net>
References: <1392587568-7325-10-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Add 32-bit VDSO time support for the 64-bit kernel
Git-Commit-ID: 249adfe2c86766eaa739d342525e55a96bf9efa7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 16 Feb 2014 16:54:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  249adfe2c86766eaa739d342525e55a96bf9efa7
Gitweb:     http://git.kernel.org/tip/249adfe2c86766eaa739d342525e55a96bf9efa7
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Sun, 16 Feb 2014 22:52:47 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 Feb 2014 15:08:29 -0800

x86, vdso: Add 32-bit VDSO time support for the 64-bit kernel

This patch add the VDSO time support for the IA32 Emulation Layer.

Due the nature of the kernel headers and the LP64 compiler where the
size of a long and a pointer differs against a 32 bit compiler, there
is some type hacking necessary for optimal performance.

The vsyscall_gtod_data struture must be a rearranged to serve 32- and
64-bit code access at the same time:

- The seqcount_t was replaced by an unsigned, this makes the
  vsyscall_gtod_data intedepend of kernel configuration and internal functions.
- All kernel internal structures are replaced by fix size elements
  which works for 32- and 64-bit access
- The inner struct clock was removed to pack the whole struct.

The "unsigned seq" would be handled by functions derivated from seqcount_t.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1392587568-7325-10-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/vgtod.h          | 69 ++++++++++++++++++++++++++++-------
 arch/x86/include/asm/vvar.h           |  5 +++
 arch/x86/kernel/vsyscall_gtod.c       | 34 +++++++++++------
 arch/x86/vdso/vclock_gettime.c        | 68 +++++++++++++++++-----------------
 arch/x86/vdso/vdso32/vclock_gettime.c | 33 +++++++++++++++++
 5 files changed, 149 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 46e24d3..abb9e45 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -4,27 +4,70 @@
 #include <asm/vsyscall.h>
 #include <linux/clocksource.h>
 
+#ifdef CONFIG_X86_64
+typedef u64 gtod_long_t;
+#else
+typedef u32 gtod_long_t;
+#endif
+/*
+ * vsyscall_gtod_data will be accessed by 32 and 64 bit code at the same time
+ * so be carefull by modifying this structure.
+ */
 struct vsyscall_gtod_data {
-	seqcount_t	seq;
+	unsigned seq;
 
-	struct { /* extract of a clocksource struct */
-		int vclock_mode;
-		cycle_t	cycle_last;
-		cycle_t	mask;
-		u32	mult;
-		u32	shift;
-	} clock;
+	int vclock_mode;
+	cycle_t	cycle_last;
+	cycle_t	mask;
+	u32	mult;
+	u32	shift;
 
 	/* open coded 'struct timespec' */
-	time_t		wall_time_sec;
 	u64		wall_time_snsec;
+	gtod_long_t	wall_time_sec;
+	gtod_long_t	monotonic_time_sec;
 	u64		monotonic_time_snsec;
-	time_t		monotonic_time_sec;
+	gtod_long_t	wall_time_coarse_sec;
+	gtod_long_t	wall_time_coarse_nsec;
+	gtod_long_t	monotonic_time_coarse_sec;
+	gtod_long_t	monotonic_time_coarse_nsec;
 
-	struct timezone sys_tz;
-	struct timespec wall_time_coarse;
-	struct timespec monotonic_time_coarse;
+	int		tz_minuteswest;
+	int		tz_dsttime;
 };
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
+static inline unsigned gtod_read_begin(const struct vsyscall_gtod_data *s)
+{
+	unsigned ret;
+
+repeat:
+	ret = ACCESS_ONCE(s->seq);
+	if (unlikely(ret & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+	smp_rmb();
+	return ret;
+}
+
+static inline int gtod_read_retry(const struct vsyscall_gtod_data *s,
+					unsigned start)
+{
+	smp_rmb();
+	return unlikely(s->seq != start);
+}
+
+static inline void gtod_write_begin(struct vsyscall_gtod_data *s)
+{
+	++s->seq;
+	smp_wmb();
+}
+
+static inline void gtod_write_end(struct vsyscall_gtod_data *s)
+{
+	smp_wmb();
+	++s->seq;
+}
+
 #endif /* _ASM_X86_VGTOD_H */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 52c79ff..081d909 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -16,6 +16,9 @@
  * you mess up, the linker will catch it.)
  */
 
+#ifndef _ASM_X86_VVAR_H
+#define _ASM_X86_VVAR_H
+
 #if defined(__VVAR_KERNEL_LDS)
 
 /* The kernel linker script defines its own magic to put vvars in the
@@ -64,3 +67,5 @@ DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
 
 #undef DECLARE_VVAR
+
+#endif
diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
index b5a943d..973dcc4 100644
--- a/arch/x86/kernel/vsyscall_gtod.c
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -4,6 +4,7 @@
  *
  *  Modified for x86 32 bit architecture by
  *  Stefani Seibold <stefani@seibold.net>
+ *  sponsored by Rohde & Schwarz GmbH & Co. KG Munich/Germany
  *
  *  Thanks to hpa@transmeta.com for some useful hint.
  *  Special thanks to Ingo Molnar for his early experience with
@@ -18,21 +19,22 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
 
 void update_vsyscall_tz(void)
 {
-	vsyscall_gtod_data.sys_tz = sys_tz;
+	vsyscall_gtod_data.tz_minuteswest = sys_tz.tz_minuteswest;
+	vsyscall_gtod_data.tz_dsttime = sys_tz.tz_dsttime;
 }
 
 void update_vsyscall(struct timekeeper *tk)
 {
 	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
 
-	write_seqcount_begin(&vdata->seq);
+	gtod_write_begin(vdata);
 
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
@@ -49,11 +51,19 @@ void update_vsyscall(struct timekeeper *tk)
 		vdata->monotonic_time_sec++;
 	}
 
-	vdata->wall_time_coarse.tv_sec	= tk->xtime_sec;
-	vdata->wall_time_coarse.tv_nsec	= (long)(tk->xtime_nsec >> tk->shift);
+	vdata->wall_time_coarse_sec	= tk->xtime_sec;
+	vdata->wall_time_coarse_nsec	= (long)(tk->xtime_nsec >> tk->shift);
 
-	vdata->monotonic_time_coarse	= timespec_add(vdata->wall_time_coarse,
-							tk->wall_to_monotonic);
+	vdata->monotonic_time_coarse_sec =
+		vdata->wall_time_coarse_sec + tk->wall_to_monotonic.tv_sec;
+	vdata->monotonic_time_coarse_nsec =
+		vdata->wall_time_coarse_nsec + tk->wall_to_monotonic.tv_nsec;
 
-	write_seqcount_end(&vdata->seq);
+	while (vdata->monotonic_time_coarse_nsec >= NSEC_PER_SEC) {
+		vdata->monotonic_time_coarse_nsec -= NSEC_PER_SEC;
+		vdata->monotonic_time_coarse_sec++;
+	}
+
+	gtod_write_end(vdata);
 }
+
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index fcbc974..b2c5d39 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -116,7 +116,7 @@ static notrace cycle_t vread_pvclock(int *mode)
 		*mode = VCLOCK_NONE;
 
 	/* refer to tsc.c read_tsc() comment for rationale */
-	last = gtod->clock.cycle_last;
+	last = gtod->cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -147,7 +147,7 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 		"call VDSO32_vsyscall \n"
 		"mov %%edx, %%ebx \n"
 		: "=a" (ret)
-		: "0" (__NR_clock_gettime), "g" (clock), "c" (ts)
+		: "0" (__NR_ia32_clock_gettime), "g" (clock), "c" (ts)
 		: "memory", "edx");
 	return ret;
 }
@@ -162,7 +162,7 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 		"call VDSO32_vsyscall \n"
 		"mov %%edx, %%ebx \n"
 		: "=a" (ret)
-		: "0" (__NR_gettimeofday), "g" (tv), "c" (tz)
+		: "0" (__NR_ia32_gettimeofday), "g" (tv), "c" (tz)
 		: "memory", "edx");
 	return ret;
 }
@@ -193,7 +193,7 @@ notrace static cycle_t vread_tsc(void)
 	rdtsc_barrier();
 	ret = (cycle_t)__native_read_tsc();
 
-	last = gtod->clock.cycle_last;
+	last = gtod->cycle_last;
 
 	if (likely(ret >= last))
 		return ret;
@@ -214,20 +214,20 @@ notrace static inline u64 vgetsns(int *mode)
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
@@ -237,17 +237,18 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 	u64 ns;
 	int mode;
 
-	ts->tv_nsec = 0;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		mode = gtod->clock.vclock_mode;
+		seq = gtod_read_begin(gtod);
+		mode = gtod->vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ns = gtod->wall_time_snsec;
 		ns += vgetsns(&mode);
-		ns >>= gtod->clock.shift;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		ns >>= gtod->shift;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
+
+	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
+	ts->tv_nsec = ns;
 
-	timespec_add_ns(ts, ns);
 	return mode;
 }
 
@@ -257,16 +258,17 @@ notrace static int do_monotonic(struct timespec *ts)
 	u64 ns;
 	int mode;
 
-	ts->tv_nsec = 0;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		mode = gtod->clock.vclock_mode;
+		seq = gtod_read_begin(gtod);
+		mode = gtod->vclock_mode;
 		ts->tv_sec = gtod->monotonic_time_sec;
 		ns = gtod->monotonic_time_snsec;
 		ns += vgetsns(&mode);
-		ns >>= gtod->clock.shift;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-	timespec_add_ns(ts, ns);
+		ns >>= gtod->shift;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
+
+	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
+	ts->tv_nsec = ns;
 
 	return mode;
 }
@@ -275,20 +277,20 @@ notrace static void do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
-		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		seq = gtod_read_begin(gtod);
+		ts->tv_sec = gtod->wall_time_coarse_sec;
+		ts->tv_nsec = gtod->wall_time_coarse_nsec;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
 }
 
 notrace static void do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = raw_read_seqcount_begin(&gtod->seq);
-		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
-		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
-	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+		seq = gtod_read_begin(gtod);
+		ts->tv_sec = gtod->monotonic_time_coarse_sec;
+		ts->tv_nsec = gtod->monotonic_time_coarse_nsec;
+	} while (unlikely(gtod_read_retry(gtod, seq)));
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
@@ -322,17 +324,13 @@ int clock_gettime(clockid_t, struct timespec *)
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	if (likely(tv != NULL)) {
-		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-			     offsetof(struct timespec, tv_nsec) ||
-			     sizeof(*tv) != sizeof(struct timespec));
 		if (unlikely(do_realtime((struct timespec *)tv) == VCLOCK_NONE))
 			return vdso_fallback_gtod(tv, tz);
 		tv->tv_usec /= 1000;
 	}
 	if (unlikely(tz != NULL)) {
-		/* Avoid memcpy. Some old compilers fail to inline it */
-		tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
-		tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
+		tz->tz_minuteswest = gtod->tz_minuteswest;
+		tz->tz_dsttime = gtod->tz_dsttime;
 	}
 
 	return 0;
diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
index 1034dea..5de5057 100644
--- a/arch/x86/vdso/vdso32/vclock_gettime.c
+++ b/arch/x86/vdso/vdso32/vclock_gettime.c
@@ -2,6 +2,8 @@
 
 #ifdef CONFIG_X86_64
 
+#include <asm/unistd_32_ia32.h>
+
 /*
  * Due the -m32 compilation, there will be a lot of
  * "warning: integer constant is too large for 'unsigned long' type",
@@ -24,12 +26,43 @@
 #define __va(x)                0
 
 /*
+ * function load_cr3() in x86/include/asm/processor.h depends on __pa().
+ * Replace by a dummy is save since not used
+ */
+#define __pa(x)                0
+
+/*
+ * Prevents the include of arch/x86/include/asm/spinlock.h, which will generate
+ * a lot of warnings with make C=1.
+ * It is imposible not to include spinlock.h since most kernel headers does
+ * include it.
+ */
+#define _ASM_X86_SPINLOCK_H
+
+/*
+ * dummys for unneeded arck_spin functions
+ */
+static inline void arch_spin_unlock_wait(void *p)
+{
+}
+
+static inline int arch_spin_is_locked(void *p)
+{
+	return 0;
+}
+
+/*
  * The define of CONFIG_ILLEGAL_POINTER_VALUE is also to prevent the
  * "warning: integer constant is too large..."
  */
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #define CONFIG_ILLEGAL_POINTER_VALUE   0
 
+#else
+
+#define __NR_ia32_clock_gettime	__NR_clock_gettime
+#define __NR_ia32_gettimeofday	__NR_gettimeofday
+
 #endif
 
 #include "../vclock_gettime.c"
