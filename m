Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaJAVNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:13:21 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:48112 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaJAVNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:13:18 -0400
X-CheckPoint: {542C6E6D-3-2100090A-C0000000}
Message-ID: <201410012113.s91LDHbr022727@farm-0039.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 1 Oct 2014 17:02:08 -0400
Subject: [PATCH v2 2/2] tile: add clock_gettime support to vDSO
To: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Henrik Austad <henrik@austad.us>
In-Reply-To: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
References: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
	<alpine.DEB.2.11.1410010004560.4455@nanos>
	<CALAqxLWHhmyDp-CeGzs6Jqzcrk-KDX_T4UQpTU79VDTL3oHdJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds support for clock_gettime with CLOCK_REALTIME
and CLOCK_MONOTONIC using vDSO.  It also updates the algorithm
used for the clocks to support sub-nanosecond times, using the
x86 architecture code as a model.

We also support the *_COARSE clockid_t, for apps that want speed
but aren't concerned about fine-grained timestamps; this saves
about 20 cycles per call (see http://lwn.net/Articles/342018/).

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
v2: use the x86 code as a model to address both John Stultz's
    observation about sub-nanosecond updates, as well as to address
    Thomas Gleixner's observation about minimizing time spent with
    the seqlock held.  Note that I kept the "unlikely" that Thomas
    doubted would help, just for parallelism with the x86 code.

 arch/tile/include/asm/vdso.h          |  15 ++--
 arch/tile/kernel/time.c               |  45 ++++++++---
 arch/tile/kernel/vdso/vgettimeofday.c | 145 +++++++++++++++++++++++++++++-----
 3 files changed, 170 insertions(+), 36 deletions(-)

diff --git a/arch/tile/include/asm/vdso.h b/arch/tile/include/asm/vdso.h
index d64b0d58a7e9..9b069692153f 100644
--- a/arch/tile/include/asm/vdso.h
+++ b/arch/tile/include/asm/vdso.h
@@ -29,13 +29,18 @@
 struct vdso_data {
 	seqcount_t tz_seq;	/* Timezone seqlock                   */
 	seqcount_t tb_seq;	/* Timebase seqlock                   */
-	__u64 xtime_tod_stamp;  /* TOD clock for xtime                */
-	__u64 xtime_clock_sec;  /* Kernel time second                 */
-	__u64 xtime_clock_nsec; /* Kernel time nanosecond             */
-	__u64 wtom_clock_sec;   /* Wall to monotonic clock second     */
-	__u64 wtom_clock_nsec;  /* Wall to monotonic clock nanosecond */
+	__u64 cycle_last;       /* TOD clock for xtime                */
+	__u64 mask;             /* Cycle mask                         */
 	__u32 mult;             /* Cycle to nanosecond multiplier     */
 	__u32 shift;            /* Cycle to nanosecond divisor (power of two) */
+	__u64 wall_time_sec;
+	__u64 wall_time_snsec;
+	__u64 monotonic_time_sec;
+	__u64 monotonic_time_snsec;
+	__u64 wall_time_coarse_sec;
+	__u64 wall_time_coarse_nsec;
+	__u64 monotonic_time_coarse_sec;
+	__u64 monotonic_time_coarse_nsec;
 	__u32 tz_minuteswest;   /* Minutes west of Greenwich          */
 	__u32 tz_dsttime;       /* Type of dst correction             */
 };
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 0661045f718d..2fdf4ebdb30e 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -257,22 +257,43 @@ void update_vsyscall_tz(void)
 
 void update_vsyscall(struct timekeeper *tk)
 {
-	struct timespec wall_time = tk_xtime(tk);
-	struct timespec *wtm = &tk->wall_to_monotonic;
-	struct clocksource *clock = tk->clock;
-
-	if (clock != &cycle_counter_cs)
+	if (tk->clock != &cycle_counter_cs)
 		return;
 
 	write_seqcount_begin(&vdso_data->tb_seq);
 
-	vdso_data->xtime_tod_stamp = clock->cycle_last;
-	vdso_data->xtime_clock_sec = wall_time.tv_sec;
-	vdso_data->xtime_clock_nsec = wall_time.tv_nsec;
-	vdso_data->wtom_clock_sec = wtm->tv_sec;
-	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
-	vdso_data->mult = clock->mult;
-	vdso_data->shift = clock->shift;
+	vdso_data->cycle_last		= tk->clock->cycle_last;
+	vdso_data->mask			= tk->clock->mask;
+	vdso_data->mult			= tk->mult;
+	vdso_data->shift		= tk->shift;
+
+	vdso_data->wall_time_sec	= tk->xtime_sec;
+	vdso_data->wall_time_snsec	= tk->xtime_nsec;
+
+	vdso_data->monotonic_time_sec	= tk->xtime_sec
+					+ tk->wall_to_monotonic.tv_sec;
+	vdso_data->monotonic_time_snsec	= tk->xtime_nsec
+					+ ((u64)tk->wall_to_monotonic.tv_nsec
+						<< tk->shift);
+	while (vdso_data->monotonic_time_snsec >=
+					(((u64)NSEC_PER_SEC) << tk->shift)) {
+		vdso_data->monotonic_time_snsec -=
+					((u64)NSEC_PER_SEC) << tk->shift;
+		vdso_data->monotonic_time_sec++;
+	}
+
+	vdso_data->wall_time_coarse_sec	= tk->xtime_sec;
+	vdso_data->wall_time_coarse_nsec = (long)(tk->xtime_nsec >> tk->shift);
+
+	vdso_data->monotonic_time_coarse_sec =
+		vdso_data->wall_time_coarse_sec + tk->wall_to_monotonic.tv_sec;
+	vdso_data->monotonic_time_coarse_nsec =
+		vdso_data->wall_time_coarse_nsec + tk->wall_to_monotonic.tv_nsec;
+
+	while (vdso_data->monotonic_time_coarse_nsec >= NSEC_PER_SEC) {
+		vdso_data->monotonic_time_coarse_nsec -= NSEC_PER_SEC;
+		vdso_data->monotonic_time_coarse_sec++;
+	}
 
 	write_seqcount_end(&vdso_data->tb_seq);
 }
diff --git a/arch/tile/kernel/vdso/vgettimeofday.c b/arch/tile/kernel/vdso/vgettimeofday.c
index efd00165d654..8bb21eda07d8 100644
--- a/arch/tile/kernel/vdso/vgettimeofday.c
+++ b/arch/tile/kernel/vdso/vgettimeofday.c
@@ -15,6 +15,7 @@
 #define VDSO_BUILD  /* avoid some shift warnings for -m32 in <asm/page.h> */
 #include <linux/time.h>
 #include <asm/timex.h>
+#include <asm/unistd.h>
 #include <asm/vdso.h>
 
 #if CHIP_HAS_SPLIT_CYCLE()
@@ -35,6 +36,11 @@ static inline cycles_t get_cycles_inline(void)
 #define get_cycles get_cycles_inline
 #endif
 
+struct syscall_return_value {
+	long value;
+	long error;
+};
+
 /*
  * Find out the vDSO data page address in the process address space.
  */
@@ -50,11 +56,82 @@ inline unsigned long get_datapage(void)
 	return ret;
 }
 
-int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+static inline u64 vgetsns(struct vdso_data *vdso)
+{
+	return ((get_cycles() - vdso->cycle_last) & vdso->mask) * vdso->mult;
+}
+
+static inline int do_realtime(struct vdso_data *vdso, struct timespec *ts)
+{
+	unsigned count;
+	u64 ns;
+
+	do {
+		count = read_seqcount_begin(&vdso->tb_seq);
+		ts->tv_sec = vdso->wall_time_sec;
+		ns = vdso->wall_time_snsec;
+		ns += vgetsns(vdso);
+		ns >>= vdso->shift;
+	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
+
+	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
+	ts->tv_nsec = ns;
+
+	return 0;
+}
+
+static inline int do_monotonic(struct vdso_data *vdso, struct timespec *ts)
+{
+	unsigned count;
+	u64 ns;
+
+	do {
+		count = read_seqcount_begin(&vdso->tb_seq);
+		ts->tv_sec = vdso->monotonic_time_sec;
+		ns = vdso->monotonic_time_snsec;
+		ns += vgetsns(vdso);
+		ns >>= vdso->shift;
+	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
+
+	ts->tv_sec += __iter_div_u64_rem(ns, NSEC_PER_SEC, &ns);
+	ts->tv_nsec = ns;
+
+	return 0;
+}
+
+static inline int do_realtime_coarse(struct vdso_data *vdso,
+				     struct timespec *ts)
 {
-	cycles_t cycles;
 	unsigned count;
-	unsigned long sec, ns;
+
+	do {
+		count = read_seqcount_begin(&vdso->tb_seq);
+		ts->tv_sec = vdso->wall_time_coarse_sec;
+		ts->tv_nsec = vdso->wall_time_coarse_nsec;
+	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
+
+	return 0;
+}
+
+static inline int do_monotonic_coarse(struct vdso_data *vdso,
+				      struct timespec *ts)
+{
+	unsigned count;
+
+	do {
+		count = read_seqcount_begin(&vdso->tb_seq);
+		ts->tv_sec = vdso->monotonic_time_coarse_sec;
+		ts->tv_nsec = vdso->monotonic_time_coarse_nsec;
+	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
+
+	return 0;
+}
+
+struct syscall_return_value __vdso_gettimeofday(struct timeval *tv,
+						struct timezone *tz)
+{
+	struct syscall_return_value ret = { 0, 0 };
+	unsigned count;
 	struct vdso_data *vdso = (struct vdso_data *)get_datapage();
 
 	/* The use of the timezone is obsolete, normally tz is NULL. */
@@ -67,25 +144,55 @@ int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 	}
 
 	if (unlikely(tv == NULL))
-		return 0;
+		return ret;
 
-	do {
-		count = read_seqcount_begin(&vdso->tb_seq);
-		cycles = (get_cycles() - vdso->xtime_tod_stamp);
-		ns = (cycles * vdso->mult) >> vdso->shift;
-		sec = vdso->xtime_clock_sec;
-		ns += vdso->xtime_clock_nsec;
-		if (ns >= NSEC_PER_SEC) {
-			ns -= NSEC_PER_SEC;
-			sec += 1;
-		}
-	} while (unlikely(read_seqcount_retry(&vdso->tb_seq, count)));
-
-	tv->tv_sec = sec;
-	tv->tv_usec = ns / 1000;
+	do_realtime(vdso, (struct timespec *)tv);
+	tv->tv_usec /= 1000;
 
-	return 0;
+	return ret;
 }
 
 int gettimeofday(struct timeval *tv, struct timezone *tz)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
+
+static struct syscall_return_value vdso_fallback_gettime(long clock,
+							 struct timespec *ts)
+{
+	struct syscall_return_value ret;
+	__asm__ __volatile__ (
+		"swint1"
+		: "=R00" (ret.value), "=R01" (ret.error)
+		: "R10" (__NR_clock_gettime), "R00" (clock), "R01" (ts)
+		: "r2", "r3", "r4", "r5", "r6", "r7",
+		"r8",  "r9", "r11", "r12", "r13", "r14", "r15",
+		"r16", "r17", "r18", "r19", "r20", "r21", "r22", "r23",
+		"r24", "r25", "r26", "r27", "r28", "r29", "memory");
+	return ret;
+}
+
+struct syscall_return_value __vdso_clock_gettime(clockid_t clock,
+						 struct timespec *ts)
+{
+	struct vdso_data *vdso = (struct vdso_data *)get_datapage();
+	struct syscall_return_value ret = { 0, 0 };
+
+	switch (clock) {
+	case CLOCK_REALTIME:
+		do_realtime(vdso, ts);
+		return ret;
+	case CLOCK_MONOTONIC:
+		do_monotonic(vdso, ts);
+		return ret;
+	case CLOCK_REALTIME_COARSE:
+		do_realtime_coarse(vdso, ts);
+		return ret;
+	case CLOCK_MONOTONIC_COARSE:
+		do_monotonic_coarse(vdso, ts);
+		return ret;
+	default:
+		return vdso_fallback_gettime(clock, ts);
+	}
+}
+
+int clock_gettime(clockid_t clock, struct timespec *ts)
+	__attribute__((weak, alias("__vdso_clock_gettime")));
-- 
1.8.3.1

