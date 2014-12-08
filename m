Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaLHDD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:03:56 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59887 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbaLHDDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:03:52 -0500
From: Shaohua Li <shli@fb.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <kernel-team@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/3] X86: add a generic API to let vdso code detect context switch
Date: Sun, 7 Dec 2014 19:03:47 -0800
Message-ID: <238c10795d7be218fea8d16ceb183e1e7450da0b.1418006970.git.shli@fb.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-07_02:2014-12-05,2014-12-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=514.84
 compositescore=0.98609165920913 urlsuspect_oldscore=0.98609165920913
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412080033
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vdso code can't disable preempt, so it can be preempted at any time.
This makes a challenge to implement specific features. This patch adds a
generic API to let vdso code detect context switch.

With this patch, every cpu maintains a context switch count. The upper
bits of the count is the logical cpu id, so the count can't be identical
for any cpu. The low bits of the count will be increased for each
context switch. For a x86_64 cpu with 4096 cpus, the context switch will
be overflowed for 2^(64 - 12) context switch, which is a long time and can be
ignored. The change of the count in giving time can be used to detect if
context switch occurs.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 arch/x86/Kconfig               |  4 ++++
 arch/x86/include/asm/vdso.h    | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/vvar.h    |  6 ++++++
 arch/x86/kernel/asm-offsets.c  |  6 ++++++
 arch/x86/vdso/vclock_gettime.c | 12 ++++++++++++
 arch/x86/vdso/vma.c            |  6 ++++++
 kernel/sched/core.c            |  5 +++++
 7 files changed, 73 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 41a503c..4978e31 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1920,6 +1920,10 @@ config COMPAT_VDSO
 	  If unsure, say N: if you are compiling your own kernel, you
 	  are unlikely to be using a buggy version of glibc.
 
+config VDSO_CS_DETECT
+	def_bool y
+	depends on X86_64
+
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	---help---
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 8021bd2..42d6d2c 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -4,6 +4,7 @@
 #include <asm/page_types.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <generated/bounds.h>
 
 #ifndef __ASSEMBLER__
 
@@ -49,6 +50,39 @@ extern const struct vdso_image *selected_vdso32;
 
 extern void __init init_vdso_image(const struct vdso_image *image);
 
+#ifdef CONFIG_VDSO_CS_DETECT
+struct vdso_percpu_data {
+	/* layout: | cpu ID | context switch count | */
+	unsigned long cpu_cs_count;
+} ____cacheline_aligned;
+
+struct vdso_data {
+	int dummy;
+	struct vdso_percpu_data vpercpu[0];
+};
+extern struct vdso_data vdso_data;
+
+#ifdef CONFIG_SMP
+#define VDSO_CS_COUNT_BITS \
+	(sizeof(unsigned long) * 8 - NR_CPUS_BITS)
+static inline void vdso_inc_cpu_cs_count(int cpu)
+{
+	unsigned long cs = vdso_data.vpercpu[cpu].cpu_cs_count;
+	cs++;
+	cs &= (1L << VDSO_CS_COUNT_BITS) - 1;
+	vdso_data.vpercpu[cpu].cpu_cs_count = cs |
+		(((unsigned long)cpu) << VDSO_CS_COUNT_BITS);
+	smp_wmb();
+}
+#else
+static inline void vdso_inc_cpu_cs_count(int cpu)
+{
+	vdso_data.vpercpu[cpu].cpu_cs_count++;
+	smp_wmb();
+}
+#endif
+#endif
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_X86_VDSO_H */
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index fcbe621..394ab65 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -47,6 +47,12 @@ extern char __vvar_page;
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
 DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
+#if defined(CONFIG_VDSO_CS_DETECT) && defined(CONFIG_X86_64)
+/*
+ * this one needs to be last because it ends with a per-cpu array.
+ */
+DECLARE_VVAR(320, struct vdso_data, vdso_data)
+#endif
 /*
  * you must update VVAR_TOTAL_SIZE to reflect all of the variables we're
  * stuffing into the vvar area.  Don't change any of the above without
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 0ab31a9..7321cdc 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -17,6 +17,7 @@
 #include <asm/bootparam.h>
 #include <asm/suspend.h>
 #include <asm/vgtod.h>
+#include <asm/vdso.h>
 
 #ifdef CONFIG_XEN
 #include <xen/interface/xen.h>
@@ -74,6 +75,11 @@ void common(void) {
 	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
 
 	BLANK();
+#ifdef CONFIG_VDSO_CS_DETECT
+	DEFINE(VVAR_TOTAL_SIZE, ALIGN(320 + sizeof(struct vdso_data)
+		+ sizeof(struct vdso_percpu_data) * CONFIG_NR_CPUS, PAGE_SIZE));
+#else
 	DEFINE(VVAR_TOTAL_SIZE,
 		ALIGN(128 + sizeof(struct vsyscall_gtod_data), PAGE_SIZE));
+#endif
 }
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 9793322..438b3be 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -17,6 +17,8 @@
 #include <asm/vvar.h>
 #include <asm/unistd.h>
 #include <asm/msr.h>
+#include <asm/vdso.h>
+#include <asm/vsyscall.h>
 #include <linux/math64.h>
 #include <linux/time.h>
 
@@ -289,6 +291,16 @@ notrace static void do_monotonic_coarse(struct timespec *ts)
 	} while (unlikely(gtod_read_retry(gtod, seq)));
 }
 
+#if defined(CONFIG_VDSO_CS_DETECT) && defined(CONFIG_X86_64)
+notrace unsigned long __vdso_get_context_switch_count(void)
+{
+	int cpu = __getcpu() & VGETCPU_CPU_MASK;
+
+	smp_rmb();
+	return VVAR(vdso_data).vpercpu[cpu].cpu_cs_count;
+}
+#endif
+
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	switch (clock) {
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index fc37067..400e454 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -22,6 +22,8 @@
 unsigned int __read_mostly vdso64_enabled = 1;
 
 extern unsigned short vdso_sync_cpuid;
+
+DEFINE_VVAR(struct vdso_data, vdso_data);
 #endif
 
 void __init init_vdso_image(const struct vdso_image *image)
@@ -42,6 +44,10 @@ void __init init_vdso_image(const struct vdso_image *image)
 #if defined(CONFIG_X86_64)
 static int __init init_vdso(void)
 {
+	int cpu;
+	for (cpu =0; cpu < CONFIG_NR_CPUS; cpu++)
+		vdso_inc_cpu_cs_count(cpu);
+
 	init_vdso_image(&vdso_image_64);
 
 #ifdef CONFIG_X86_X32_ABI
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 89e7283..5e4100a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2238,6 +2238,11 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 {
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
+#ifdef CONFIG_VDSO_CS_DETECT
+	int cpu = smp_processor_id();
+
+	vdso_inc_cpu_cs_count(cpu);
+#endif
 
 	rq->prev_mm = NULL;
 
-- 
1.8.1

