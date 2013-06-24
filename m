Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3FXTeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:34:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54066 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3FXTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH 11/32] blackfin: delete __cpuinit usage from all blackfin files
Date: Mon, 24 Jun 2013 15:30:16 -0400
Message-ID: <1372102237-8757-12-git-send-email-paul.gortmaker@windriver.com>
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

This removes all the arch/blackfin uses of the __cpuinit macros from
all C files.  Currently blackfin does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Sonic Zhang <sonic.zhang@analog.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/blackfin/kernel/perf_event.c         | 2 +-
 arch/blackfin/kernel/setup.c              | 4 ++--
 arch/blackfin/mach-bf561/smp.c            | 6 +++---
 arch/blackfin/mach-common/cache-c.c       | 4 ++--
 arch/blackfin/mach-common/ints-priority.c | 2 +-
 arch/blackfin/mach-common/smp.c           | 8 ++++----
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/kernel/perf_event.c b/arch/blackfin/kernel/perf_event.c
index e47d19a..974e554 100644
--- a/arch/blackfin/kernel/perf_event.c
+++ b/arch/blackfin/kernel/perf_event.c
@@ -468,7 +468,7 @@ static void bfin_pmu_setup(int cpu)
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
 }
 
-static int __cpuinit
+static int
 bfin_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 107b306..19ad063 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -99,7 +99,7 @@ void __init generate_cplb_tables(void)
 }
 #endif
 
-void __cpuinit bfin_setup_caches(unsigned int cpu)
+void bfin_setup_caches(unsigned int cpu)
 {
 #ifdef CONFIG_BFIN_ICACHE
 	bfin_icache_init(icplb_tbl[cpu]);
@@ -165,7 +165,7 @@ void __cpuinit bfin_setup_caches(unsigned int cpu)
 #endif
 }
 
-void __cpuinit bfin_setup_cpudata(unsigned int cpu)
+void bfin_setup_cpudata(unsigned int cpu)
 {
 	struct blackfin_cpudata *cpudata = &per_cpu(cpu_data, cpu);
 
diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index ab1c617..7748b84 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -48,7 +48,7 @@ int __init setup_profiling_timer(unsigned int multiplier) /* not supported */
 	return -EINVAL;
 }
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+void platform_secondary_init(unsigned int cpu)
 {
 	/* Clone setup for peripheral interrupt sources from CoreA. */
 	bfin_write_SICB_IMASK0(bfin_read_SIC_IMASK0());
@@ -74,7 +74,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit platform_boot_secondary(unsigned int cpu, struct task_struct *idle)
+int platform_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 
@@ -155,7 +155,7 @@ void platform_clear_ipi(unsigned int cpu, int irq)
  * Setup core B's local core timer.
  * In SMP, core timer is used for clock event device.
  */
-void __cpuinit bfin_local_timer_setup(void)
+void bfin_local_timer_setup(void)
 {
 #if defined(CONFIG_TICKSOURCE_CORETMR)
 	struct irq_data *data = irq_get_irq_data(IRQ_CORETMR);
diff --git a/arch/blackfin/mach-common/cache-c.c b/arch/blackfin/mach-common/cache-c.c
index a60a24f..0e1e451 100644
--- a/arch/blackfin/mach-common/cache-c.c
+++ b/arch/blackfin/mach-common/cache-c.c
@@ -52,7 +52,7 @@ bfin_cache_init(struct cplb_entry *cplb_tbl, unsigned long cplb_addr,
 }
 
 #ifdef CONFIG_BFIN_ICACHE
-void __cpuinit bfin_icache_init(struct cplb_entry *icplb_tbl)
+void bfin_icache_init(struct cplb_entry *icplb_tbl)
 {
 	bfin_cache_init(icplb_tbl, ICPLB_ADDR0, ICPLB_DATA0, IMEM_CONTROL,
 		(IMC | ENICPLB));
@@ -60,7 +60,7 @@ void __cpuinit bfin_icache_init(struct cplb_entry *icplb_tbl)
 #endif
 
 #ifdef CONFIG_BFIN_DCACHE
-void __cpuinit bfin_dcache_init(struct cplb_entry *dcplb_tbl)
+void bfin_dcache_init(struct cplb_entry *dcplb_tbl)
 {
 	/*
 	 *  Anomaly notes:
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 6c0c681..d143fd8 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -1281,7 +1281,7 @@ static struct irq_chip bfin_gpio_irqchip = {
 	.irq_set_wake = bfin_gpio_set_wake,
 };
 
-void __cpuinit init_exception_vectors(void)
+void init_exception_vectors(void)
 {
 	/* cannot program in software:
 	 * evt0 - emulation (jtag)
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 1bc2ce6..e7c5d28 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -46,7 +46,7 @@ struct corelock_slot corelock __attribute__ ((__section__(".l2.bss")));
 unsigned long blackfin_iflush_l1_entry[NR_CPUS];
 #endif
 
-struct blackfin_initial_pda __cpuinitdata initial_pda_coreb;
+struct blackfin_initial_pda initial_pda_coreb;
 
 enum ipi_message_type {
 	BFIN_IPI_TIMER,
@@ -249,7 +249,7 @@ void smp_send_stop(void)
 	return;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
 
@@ -262,7 +262,7 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 	return ret;
 }
 
-static void __cpuinit setup_secondary(unsigned int cpu)
+static void setup_secondary(unsigned int cpu)
 {
 	unsigned long ilat;
 
@@ -280,7 +280,7 @@ static void __cpuinit setup_secondary(unsigned int cpu)
 	    IMASK_IVG10 | IMASK_IVG9 | IMASK_IVG8 | IMASK_IVG7 | IMASK_IVGHW;
 }
 
-void __cpuinit secondary_start_kernel(void)
+void secondary_start_kernel(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct mm_struct *mm = &init_mm;
-- 
1.8.1.2

