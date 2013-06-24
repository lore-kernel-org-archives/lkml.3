Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3FXTjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:39:10 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54013 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3FXTb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mundt <lethal@linux-sh.org>, <linux-sh@vger.kernel.org>
Subject: [PATCH 13/32] sh: delete __cpuinit usage from all sh files
Date: Mon, 24 Jun 2013 15:30:18 -0400
Message-ID: <1372102237-8757-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
are flagged as __cpuinit  -- so if we remove the __cpuinit from
arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
content into no-ops as early as possible, since that will get rid
of these warnings.  In any case, they are temporary and harmless.

This removes all the arch/sh uses of the __cpuinit macros from
all C files.  Currently sh does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/sh/kernel/cpu/init.c          | 18 +++++++++---------
 arch/sh/kernel/cpu/sh2/probe.c     |  2 +-
 arch/sh/kernel/cpu/sh2a/probe.c    |  2 +-
 arch/sh/kernel/cpu/sh3/probe.c     |  2 +-
 arch/sh/kernel/cpu/sh4/probe.c     |  2 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c |  6 +++---
 arch/sh/kernel/cpu/sh5/probe.c     |  2 +-
 arch/sh/kernel/perf_event.c        |  4 ++--
 arch/sh/kernel/process.c           |  2 +-
 arch/sh/kernel/setup.c             |  2 +-
 arch/sh/kernel/smp.c               |  8 ++++----
 arch/sh/kernel/traps_32.c          |  2 +-
 arch/sh/kernel/traps_64.c          |  2 +-
 arch/sh/mm/tlb-sh5.c               |  2 +-
 14 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/sh/kernel/cpu/init.c b/arch/sh/kernel/cpu/init.c
index 61a07da..ecf83cd 100644
--- a/arch/sh/kernel/cpu/init.c
+++ b/arch/sh/kernel/cpu/init.c
@@ -43,9 +43,9 @@
  * peripherals (nofpu, nodsp, and so forth).
  */
 #define onchip_setup(x)					\
-static int x##_disabled __cpuinitdata = !cpu_has_##x;	\
+static int x##_disabled = !cpu_has_##x;			\
 							\
-static int __cpuinit x##_setup(char *opts)			\
+static int x##_setup(char *opts)			\
 {							\
 	x##_disabled = 1;				\
 	return 1;					\
@@ -59,7 +59,7 @@ onchip_setup(dsp);
 #define CPUOPM		0xff2f0000
 #define CPUOPM_RABD	(1 << 5)
 
-static void __cpuinit speculative_execution_init(void)
+static void speculative_execution_init(void)
 {
 	/* Clear RABD */
 	__raw_writel(__raw_readl(CPUOPM) & ~CPUOPM_RABD, CPUOPM);
@@ -78,7 +78,7 @@ static void __cpuinit speculative_execution_init(void)
 #define EXPMASK_BRDSSLP		(1 << 1)
 #define EXPMASK_MMCAW		(1 << 4)
 
-static void __cpuinit expmask_init(void)
+static void expmask_init(void)
 {
 	unsigned long expmask = __raw_readl(EXPMASK);
 
@@ -217,7 +217,7 @@ static void detect_cache_shape(void)
 		l2_cache_shape = -1; /* No S-cache */
 }
 
-static void __cpuinit fpu_init(void)
+static void fpu_init(void)
 {
 	/* Disable the FPU */
 	if (fpu_disabled && (current_cpu_data.flags & CPU_HAS_FPU)) {
@@ -230,7 +230,7 @@ static void __cpuinit fpu_init(void)
 }
 
 #ifdef CONFIG_SH_DSP
-static void __cpuinit release_dsp(void)
+static void release_dsp(void)
 {
 	unsigned long sr;
 
@@ -244,7 +244,7 @@ static void __cpuinit release_dsp(void)
 	);
 }
 
-static void __cpuinit dsp_init(void)
+static void dsp_init(void)
 {
 	unsigned long sr;
 
@@ -276,7 +276,7 @@ static void __cpuinit dsp_init(void)
 	release_dsp();
 }
 #else
-static inline void __cpuinit dsp_init(void) { }
+static inline void dsp_init(void) { }
 #endif /* CONFIG_SH_DSP */
 
 /**
@@ -295,7 +295,7 @@ static inline void __cpuinit dsp_init(void) { }
  * Each processor family is still responsible for doing its own probing
  * and cache configuration in cpu_probe().
  */
-asmlinkage void __cpuinit cpu_init(void)
+asmlinkage void cpu_init(void)
 {
 	current_thread_info()->cpu = hard_smp_processor_id();
 
diff --git a/arch/sh/kernel/cpu/sh2/probe.c b/arch/sh/kernel/cpu/sh2/probe.c
index bab8e75..6c687ae 100644
--- a/arch/sh/kernel/cpu/sh2/probe.c
+++ b/arch/sh/kernel/cpu/sh2/probe.c
@@ -13,7 +13,7 @@
 #include <asm/processor.h>
 #include <asm/cache.h>
 
-void __cpuinit cpu_probe(void)
+void cpu_probe(void)
 {
 #if defined(CONFIG_CPU_SUBTYPE_SH7619)
 	boot_cpu_data.type			= CPU_SH7619;
diff --git a/arch/sh/kernel/cpu/sh2a/probe.c b/arch/sh/kernel/cpu/sh2a/probe.c
index 5170b6a..3f87971 100644
--- a/arch/sh/kernel/cpu/sh2a/probe.c
+++ b/arch/sh/kernel/cpu/sh2a/probe.c
@@ -13,7 +13,7 @@
 #include <asm/processor.h>
 #include <asm/cache.h>
 
-void __cpuinit cpu_probe(void)
+void cpu_probe(void)
 {
 	boot_cpu_data.family			= CPU_FAMILY_SH2A;
 
diff --git a/arch/sh/kernel/cpu/sh3/probe.c b/arch/sh/kernel/cpu/sh3/probe.c
index bf23c32..426e1e1 100644
--- a/arch/sh/kernel/cpu/sh3/probe.c
+++ b/arch/sh/kernel/cpu/sh3/probe.c
@@ -16,7 +16,7 @@
 #include <asm/cache.h>
 #include <asm/io.h>
 
-void __cpuinit cpu_probe(void)
+void cpu_probe(void)
 {
 	unsigned long addr0, addr1, data0, data1, data2, data3;
 
diff --git a/arch/sh/kernel/cpu/sh4/probe.c b/arch/sh/kernel/cpu/sh4/probe.c
index 0fbbd50..a521bcf 100644
--- a/arch/sh/kernel/cpu/sh4/probe.c
+++ b/arch/sh/kernel/cpu/sh4/probe.c
@@ -15,7 +15,7 @@
 #include <asm/processor.h>
 #include <asm/cache.h>
 
-void __cpuinit cpu_probe(void)
+void cpu_probe(void)
 {
 	unsigned long pvr, prr, cvr;
 	unsigned long size;
diff --git a/arch/sh/kernel/cpu/sh4a/smp-shx3.c b/arch/sh/kernel/cpu/sh4a/smp-shx3.c
index 03f2b55..4a29880 100644
--- a/arch/sh/kernel/cpu/sh4a/smp-shx3.c
+++ b/arch/sh/kernel/cpu/sh4a/smp-shx3.c
@@ -124,7 +124,7 @@ static void shx3_update_boot_vector(unsigned int cpu)
 	__raw_writel(STBCR_RESET, STBCR_REG(cpu));
 }
 
-static int __cpuinit
+static int
 shx3_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned int)hcpu;
@@ -143,11 +143,11 @@ shx3_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata shx3_cpu_notifier = {
+static struct notifier_block shx3_cpu_notifier = {
 	.notifier_call		= shx3_cpu_callback,
 };
 
-static int __cpuinit register_shx3_cpu_notifier(void)
+static int register_shx3_cpu_notifier(void)
 {
 	register_hotcpu_notifier(&shx3_cpu_notifier);
 	return 0;
diff --git a/arch/sh/kernel/cpu/sh5/probe.c b/arch/sh/kernel/cpu/sh5/probe.c
index 9e88240..eca427c 100644
--- a/arch/sh/kernel/cpu/sh5/probe.c
+++ b/arch/sh/kernel/cpu/sh5/probe.c
@@ -17,7 +17,7 @@
 #include <asm/cache.h>
 #include <asm/tlb.h>
 
-void __cpuinit cpu_probe(void)
+void cpu_probe(void)
 {
 	unsigned long long cir;
 
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 068b8a2..b9cefeb 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -367,7 +367,7 @@ static void sh_pmu_setup(int cpu)
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
 }
 
-static int __cpuinit
+static int
 sh_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
@@ -384,7 +384,7 @@ sh_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-int __cpuinit register_sh_pmu(struct sh_pmu *_pmu)
+int register_sh_pmu(struct sh_pmu *_pmu)
 {
 	if (sh_pmu)
 		return -EBUSY;
diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
index 055d91b..53bc6c4 100644
--- a/arch/sh/kernel/process.c
+++ b/arch/sh/kernel/process.c
@@ -65,7 +65,7 @@ void arch_task_cache_init(void)
 # define HAVE_SOFTFP	0
 #endif
 
-void __cpuinit init_thread_xstate(void)
+void init_thread_xstate(void)
 {
 	if (boot_cpu_data.flags & CPU_HAS_FPU)
 		xstate_size = sizeof(struct sh_fpu_hard_struct);
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index ebe7a7d..1cf90e9 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -172,7 +172,7 @@ disable:
 #endif
 }
 
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	struct clk *clk = clk_get(NULL, "cpu_clk");
 
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 4569645..86a7936 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -37,7 +37,7 @@ struct plat_smp_ops *mp_ops = NULL;
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-void __cpuinit register_smp_ops(struct plat_smp_ops *ops)
+void register_smp_ops(struct plat_smp_ops *ops)
 {
 	if (mp_ops)
 		printk(KERN_WARNING "Overriding previously set SMP ops\n");
@@ -45,7 +45,7 @@ void __cpuinit register_smp_ops(struct plat_smp_ops *ops)
 	mp_ops = ops;
 }
 
-static inline void __cpuinit smp_store_cpu_info(unsigned int cpu)
+static inline void smp_store_cpu_info(unsigned int cpu)
 {
 	struct sh_cpuinfo *c = cpu_data + cpu;
 
@@ -174,7 +174,7 @@ void native_play_dead(void)
 }
 #endif
 
-asmlinkage void __cpuinit start_secondary(void)
+asmlinkage void start_secondary(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct mm_struct *mm = &init_mm;
@@ -215,7 +215,7 @@ extern struct {
 	void *thread_info;
 } stack_start;
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tsk)
+int __cpu_up(unsigned int cpu, struct task_struct *tsk)
 {
 	unsigned long timeout;
 
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 5f513a6..68e99f0 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -741,7 +741,7 @@ asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
 	die_if_kernel("exception", regs, ex);
 }
 
-void __cpuinit per_cpu_trap_init(void)
+void per_cpu_trap_init(void)
 {
 	extern void *vbr_base;
 
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index f87d20d..112ea11 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -810,7 +810,7 @@ asmlinkage void do_debug_interrupt(unsigned long code, struct pt_regs *regs)
 	poke_real_address_q(DM_EXP_CAUSE_PHY, 0x0);
 }
 
-void __cpuinit per_cpu_trap_init(void)
+void per_cpu_trap_init(void)
 {
 	/* Nothing to do for now, VBR initialization later. */
 }
diff --git a/arch/sh/mm/tlb-sh5.c b/arch/sh/mm/tlb-sh5.c
index ff1c40a..e4bb2a8 100644
--- a/arch/sh/mm/tlb-sh5.c
+++ b/arch/sh/mm/tlb-sh5.c
@@ -17,7 +17,7 @@
 /**
  * sh64_tlb_init - Perform initial setup for the DTLB and ITLB.
  */
-int __cpuinit sh64_tlb_init(void)
+int sh64_tlb_init(void)
 {
 	/* Assign some sane DTLB defaults */
 	cpu_data->dtlb.entries	= 64;
-- 
1.8.1.2

