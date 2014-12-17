Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaLQXM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:12:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42474 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbaLQXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:12:31 -0500
From: Shaohua Li <shli@fb.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <Kernel-team@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Date: Wed, 17 Dec 2014 15:12:26 -0800
Message-ID: <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_07:2014-12-17,2014-12-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.3242130442469e-11 kscore.compositescore=0
 circleOfTrustscore=514.84 compositescore=0.98609165920913
 urlsuspect_oldscore=0.98609165920913 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412170232
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..). We
use the following method to compute the thread cpu time:

    t0 = process start
    t1 = most recent context switch time
    t2 = time at which the vsyscall is invoked

    thread_cpu_time = sum(time slices between t0 to t1) + (t2 - t1)
    		= current->se.sum_exec_runtime + now - sched_clock()

At context switch time We stash away

    adj_sched_time = sum_exec_runtime - sched_clock()

in a per-cpu struct in the VVAR page and then compute

    thread_cpu_time = adj_sched_time + now

All computations are done in nanosecs on systems where TSC is stable. If
TSC is unstable, we fallback to a regular syscall.
    Benchmark data:

    for (i = 0; i < 100000000; i++) {
	    clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
	    sum += ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
    }

    Baseline:
    real    1m3.428s
    user    0m5.190s
    sys     0m58.220s

    patched:
    real    0m4.912s
    user    0m4.910s
    sys     0m0.000s

This should speed up profilers that need to query thread cpu time a lot
to do fine-grained timestamps.

No statistically significant regression was detected on x86_64 context
switch code. Most archs that don't support vsyscalls will have this code
disabled via jump labels.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Kumar Sundararajan <kumar@fb.com>
Signed-off-by: Arun Sharma <asharma@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 arch/x86/include/asm/vdso.h    |  9 +++++-
 arch/x86/kernel/tsc.c          | 14 +++++++++
 arch/x86/vdso/vclock_gettime.c | 69 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vma.c            | 10 +++++-
 kernel/sched/core.c            |  3 ++
 5 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index d4556a3..fcdf611 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -52,14 +52,21 @@ extern void __init init_vdso_image(const struct vdso_image *image);
 #ifdef CONFIG_VDSO_CS_DETECT
 struct vdso_percpu_data {
 	u64 last_cs_timestamp;
+
+	u64 adj_sched_time;
+	u64 cyc2ns_offset;
+	u32 cyc2ns_mul;
 } ____cacheline_aligned;
 
 struct vdso_data {
-	int dummy;
+	unsigned int thread_cputime_disabled;
 	struct vdso_percpu_data vpercpu[0];
 };
 extern struct vdso_data vdso_data;
 
+struct static_key;
+extern struct static_key vcpu_thread_cputime_enabled;
+
 static inline void vdso_set_cpu_cs_timestamp(int cpu)
 {
 	rdtscll(vdso_data.vpercpu[cpu].last_cs_timestamp);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b7e50bb..dd3b281 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -21,6 +21,7 @@
 #include <asm/hypervisor.h>
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
+#include <asm/vdso.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -263,6 +264,11 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	data->cyc2ns_offset = ns_now -
 		mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
 
+#ifdef CONFIG_VDSO_CS_DETECT
+	vdso_data.vpercpu[cpu].cyc2ns_mul = data->cyc2ns_mul;
+	vdso_data.vpercpu[cpu].cyc2ns_offset = data->cyc2ns_offset;
+#endif
+
 	cyc2ns_write_end(cpu, data);
 
 done:
@@ -989,6 +995,10 @@ void mark_tsc_unstable(char *reason)
 		tsc_unstable = 1;
 		clear_sched_clock_stable();
 		disable_sched_clock_irqtime();
+#ifdef CONFIG_VDSO_CS_DETECT
+		vdso_data.thread_cputime_disabled = 1;
+		static_key_slow_dec(&vcpu_thread_cputime_enabled);
+#endif
 		pr_info("Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
@@ -1202,6 +1212,10 @@ void __init tsc_init(void)
 
 	tsc_disabled = 0;
 	static_key_slow_inc(&__use_tsc);
+#ifdef CONFIG_VDSO_CS_DETECT
+	vdso_data.thread_cputime_disabled = !cpu_has(&boot_cpu_data,
+			X86_FEATURE_RDTSCP);
+#endif
 
 	if (!no_sched_irq_time)
 		enable_sched_clock_irqtime();
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 9793322..0aa39b1 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -17,6 +17,7 @@
 #include <asm/vvar.h>
 #include <asm/unistd.h>
 #include <asm/msr.h>
+#include <asm/vdso.h>
 #include <linux/math64.h>
 #include <linux/time.h>
 
@@ -289,6 +290,62 @@ notrace static void do_monotonic_coarse(struct timespec *ts)
 	} while (unlikely(gtod_read_retry(gtod, seq)));
 }
 
+#if defined(CONFIG_VDSO_CS_DETECT) && defined(CONFIG_X86_64)
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+notrace static inline u64 __cycles_2_ns(u64 cyc, u64 scale, u64 offset)
+{
+	u64 ns = offset;
+	ns += mul_u64_u32_shr(cyc, scale, CYC2NS_SCALE_FACTOR);
+	return ns;
+}
+
+notrace static inline u64 vdso_get_cpu_cs_timestamp(int cpu)
+{
+	return VVAR(vdso_data).vpercpu[cpu].last_cs_timestamp;
+}
+
+#define THREAD_CPU_TIME_MAX_LOOP 20
+notrace static u64 do_thread_cpu_time(void)
+{
+	unsigned int p;
+	u64 tscval;
+	u64 adj_sched_time;
+	u64 scale;
+	u64 offset;
+	const struct vdso_data *vp = &VVAR(vdso_data);
+	int cpuo, cpun;
+	int loop = 0;
+
+	do {
+		loop++;
+		if (loop > THREAD_CPU_TIME_MAX_LOOP)
+			return -1LL;
+
+		rdtscpll(tscval, p);
+		cpuo = p & VGETCPU_CPU_MASK;
+		adj_sched_time = vp->vpercpu[cpuo].adj_sched_time;
+		scale = vp->vpercpu[cpuo].cyc2ns_mul;
+		offset = vp->vpercpu[cpuo].cyc2ns_offset;
+
+		cpun = __getcpu() & VGETCPU_CPU_MASK;
+		/*
+		 * The CPU check goarantees this runs in the same cpu, so no
+		 * barrier required
+		 */
+	} while (unlikely(cpuo != cpun ||
+			tscval <= vdso_get_cpu_cs_timestamp(cpun)));
+
+	return __cycles_2_ns(tscval, scale, offset) + adj_sched_time;
+}
+
+notrace static inline void ns_to_ts(u64 ns, struct timespec *ts)
+{
+	u32 rem;
+	ts->tv_sec = div_u64_rem(ns, NSEC_PER_SEC, &rem);
+	ts->tv_nsec = rem;
+}
+#endif
+
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	switch (clock) {
@@ -306,6 +363,18 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 	case CLOCK_MONOTONIC_COARSE:
 		do_monotonic_coarse(ts);
 		break;
+#if defined(CONFIG_VDSO_CS_DETECT) && defined(CONFIG_X86_64)
+	case CLOCK_THREAD_CPUTIME_ID: {
+		u64 time;
+		if (VVAR(vdso_data).thread_cputime_disabled)
+			goto fallback;
+		time = do_thread_cpu_time();
+		if (time == -1LL)
+			goto fallback;
+		ns_to_ts(time, ts);
+		break;
+	}
+#endif
 	default:
 		goto fallback;
 	}
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 22b1a69..237b3af 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -12,6 +12,8 @@
 #include <linux/random.h>
 #include <linux/elf.h>
 #include <linux/cpu.h>
+#include <linux/jump_label.h>
+#include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
 #include <asm/vdso.h>
@@ -23,7 +25,11 @@
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
-DEFINE_VVAR(struct vdso_data, vdso_data);
+
+DEFINE_VVAR(struct vdso_data, vdso_data) = {
+	.thread_cputime_disabled = 1,
+};
+struct static_key vcpu_thread_cputime_enabled;
 #endif
 
 void __init init_vdso_image(const struct vdso_image *image)
@@ -275,6 +281,8 @@ static int __init init_vdso(void)
 	init_vdso_image(&vdso_image_x32);
 #endif
 
+	if (!vdso_data.thread_cputime_disabled)
+		static_key_slow_inc(&vcpu_thread_cputime_enabled);
 	cpu_notifier_register_begin();
 
 	on_each_cpu(vgetcpu_cpu_init, NULL, 1);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d8e882d..03e6175 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2236,6 +2236,9 @@ static struct rq *finish_task_switch(struct task_struct *prev)
 	int cpu = smp_processor_id();
 
 	vdso_set_cpu_cs_timestamp(cpu);
+	if (static_key_false(&vcpu_thread_cputime_enabled))
+		vdso_data.vpercpu[cpu].adj_sched_time =
+			current->se.sum_exec_runtime - sched_clock();
 #endif
 
 	rq->prev_mm = NULL;
-- 
1.8.1

