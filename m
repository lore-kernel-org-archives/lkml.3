Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3FXTkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:40:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:47230 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3FXTbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 10/32] arc: delete __cpuinit usage from all arc files
Date: Mon, 24 Jun 2013 15:30:15 -0400
Message-ID: <1372102237-8757-11-git-send-email-paul.gortmaker@windriver.com>
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

This removes all the arch/arc uses of the __cpuinit macros from
all C files.  Currently arc does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/arc/include/asm/irq.h |  2 +-
 arch/arc/kernel/irq.c      |  2 +-
 arch/arc/kernel/setup.c    | 10 +++++-----
 arch/arc/kernel/smp.c      |  4 ++--
 arch/arc/kernel/time.c     |  6 +++---
 arch/arc/mm/cache_arc700.c |  4 ++--
 arch/arc/mm/tlb.c          |  4 ++--
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index 57898a1..c0a7210 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -21,6 +21,6 @@
 extern void __init arc_init_IRQ(void);
 extern int __init get_hw_config_num_irq(void);
 
-void __cpuinit arc_local_timer_setup(unsigned int cpu);
+void arc_local_timer_setup(unsigned int cpu);
 
 #endif
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index 4918a66..305b3f8 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -28,7 +28,7 @@
  * -Disable all IRQs (on CPU side)
  * -Optionally, setup the High priority Interrupts as Level 2 IRQs
  */
-void __cpuinit arc_init_IRQ(void)
+void arc_init_IRQ(void)
 {
 	int level_mask = 0;
 
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 5b6ee41..6b08345 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -31,14 +31,14 @@
 int running_on_hw = 1;	/* vs. on ISS */
 
 char __initdata command_line[COMMAND_LINE_SIZE];
-struct machine_desc *machine_desc __cpuinitdata;
+struct machine_desc *machine_desc;
 
 struct task_struct *_current_task[NR_CPUS];	/* For stack switching */
 
 struct cpuinfo_arc cpuinfo_arc700[NR_CPUS];
 
 
-void __cpuinit read_arc_build_cfg_regs(void)
+void read_arc_build_cfg_regs(void)
 {
 	struct bcr_perip uncached_space;
 	struct cpuinfo_arc *cpu = &cpuinfo_arc700[smp_processor_id()];
@@ -237,7 +237,7 @@ char *arc_extn_mumbojumbo(int cpu_id, char *buf, int len)
 	return buf;
 }
 
-void __cpuinit arc_chk_ccms(void)
+void arc_chk_ccms(void)
 {
 #if defined(CONFIG_ARC_HAS_DCCM) || defined(CONFIG_ARC_HAS_ICCM)
 	struct cpuinfo_arc *cpu = &cpuinfo_arc700[smp_processor_id()];
@@ -272,7 +272,7 @@ void __cpuinit arc_chk_ccms(void)
  * hardware has dedicated regs which need to be saved/restored on ctx-sw
  * (Single Precision uses core regs), thus kernel is kind of oblivious to it
  */
-void __cpuinit arc_chk_fpu(void)
+void arc_chk_fpu(void)
 {
 	struct cpuinfo_arc *cpu = &cpuinfo_arc700[smp_processor_id()];
 
@@ -293,7 +293,7 @@ void __cpuinit arc_chk_fpu(void)
  *    such as only for boot CPU etc
  */
 
-void __cpuinit setup_processor(void)
+void setup_processor(void)
 {
 	char str[512];
 	int cpu_id = smp_processor_id();
diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index 5c7fd60..bca3052 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -117,7 +117,7 @@ const char *arc_platform_smp_cpuinfo(void)
  * Called from asm stub in head.S
  * "current"/R25 already setup by low level boot code
  */
-void __cpuinit start_kernel_secondary(void)
+void start_kernel_secondary(void)
 {
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu = smp_processor_id();
@@ -154,7 +154,7 @@ void __cpuinit start_kernel_secondary(void)
  *
  * Essential requirements being where to run from (PC) and stack (SP)
 */
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long wait_till;
 
diff --git a/arch/arc/kernel/time.c b/arch/arc/kernel/time.c
index 32afa54..0e51e69 100644
--- a/arch/arc/kernel/time.c
+++ b/arch/arc/kernel/time.c
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_ARC_HAS_RTSC
 
-int __cpuinit arc_counter_setup(void)
+int arc_counter_setup(void)
 {
 	/* RTSC insn taps into cpu clk, needs no setup */
 
@@ -116,7 +116,7 @@ static bool is_usable_as_clocksource(void)
 /*
  * set 32bit TIMER1 to keep counting monotonically and wraparound
  */
-int __cpuinit arc_counter_setup(void)
+int arc_counter_setup(void)
 {
 	write_aux_reg(ARC_REG_TIMER1_LIMIT, ARC_TIMER_MAX);
 	write_aux_reg(ARC_REG_TIMER1_CNT, 0);
@@ -223,7 +223,7 @@ static struct irqaction arc_timer_irq = {
  * Setup the local event timer for @cpu
  * N.B. weak so that some exotic ARC SoCs can completely override it
  */
-void __attribute__((weak)) __cpuinit arc_local_timer_setup(unsigned int cpu)
+void __attribute__((weak)) arc_local_timer_setup(unsigned int cpu)
 {
 	struct clock_event_device *clk = &per_cpu(arc_clockevent_device, cpu);
 
diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
index 66c75ee..f415d85 100644
--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -129,7 +129,7 @@ char *arc_cache_mumbojumbo(int cpu_id, char *buf, int len)
  * the cpuinfo structure for later use.
  * No Validation done here, simply read/convert the BCRs
  */
-void __cpuinit read_decode_cache_bcr(void)
+void read_decode_cache_bcr(void)
 {
 	struct cpuinfo_arc_cache *p_ic, *p_dc;
 	unsigned int cpu = smp_processor_id();
@@ -167,7 +167,7 @@ void __cpuinit read_decode_cache_bcr(void)
  * 3. Enable the Caches, setup default flush mode for D-Cache
  * 3. Calculate the SHMLBA used by user space
  */
-void __cpuinit arc_cache_init(void)
+void arc_cache_init(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct cpuinfo_arc_cache *ic = &cpuinfo_arc700[cpu].icache;
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index d44ae33..7957dc4 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -469,7 +469,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long vaddr_unaligned,
  * the cpuinfo structure for later use.
  * No Validation is done here, simply read/convert the BCRs
  */
-void __cpuinit read_decode_mmu_bcr(void)
+void read_decode_mmu_bcr(void)
 {
 	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
 	unsigned int tmp;
@@ -530,7 +530,7 @@ char *arc_mmu_mumbojumbo(int cpu_id, char *buf, int len)
 	return buf;
 }
 
-void __cpuinit arc_mmu_init(void)
+void arc_mmu_init(void)
 {
 	char str[256];
 	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
-- 
1.8.1.2

