Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3FXTk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:40:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47196 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3FXTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>
Subject: [PATCH 08/32] sparc: delete __cpuinit/__CPUINIT usage from all users
Date: Mon, 24 Jun 2013 15:30:13 -0400
Message-ID: <1372102237-8757-9-git-send-email-paul.gortmaker@windriver.com>
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

This removes all the arch/sparc uses of the __cpuinit macros from
C files and removes __CPUINIT from assembly files.  Note that even
though arch/sparc/kernel/trampoline_64.S has instances of ".previous"
in it, they are all paired off against explicit ".section" directives,
and not implicitly paired with __CPUINIT (unlike mips and arm were).

[1] https://lkml.org/lkml/2013/5/20/589

Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[I worry - that any trampoline code that was __cpuinit might possibly
 end up linked at a different place now.   The concern there being that
 implicit address expectations now get violated, and silent boot failures
 result (as a worst case).  Compile tested but not boot tested.]

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/sparc/kernel/ds.c            | 11 ++++-------
 arch/sparc/kernel/entry.h         |  2 +-
 arch/sparc/kernel/hvtramp.S       |  1 -
 arch/sparc/kernel/irq_64.c        |  5 +++--
 arch/sparc/kernel/leon_smp.c      | 10 +++++-----
 arch/sparc/kernel/mdesc.c         | 34 +++++++++++++++++-----------------
 arch/sparc/kernel/smp_32.c        | 20 ++++++++++----------
 arch/sparc/kernel/smp_64.c        |  9 +++++----
 arch/sparc/kernel/sun4d_smp.c     |  6 +++---
 arch/sparc/kernel/sun4m_smp.c     |  6 +++---
 arch/sparc/kernel/sysfs.c         |  4 ++--
 arch/sparc/kernel/trampoline_32.S |  3 ---
 arch/sparc/kernel/trampoline_64.S |  2 --
 arch/sparc/mm/init_64.c           |  2 +-
 arch/sparc/mm/srmmu.c             | 12 ++++++------
 15 files changed, 60 insertions(+), 67 deletions(-)

diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 5ef48da..92dbf79 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -528,10 +528,8 @@ static void dr_cpu_mark(struct ds_data *resp, int cpu, int ncpus,
 	}
 }
 
-static int __cpuinit dr_cpu_configure(struct ds_info *dp,
-				      struct ds_cap_state *cp,
-				      u64 req_num,
-				      cpumask_t *mask)
+static int dr_cpu_configure(struct ds_info *dp, struct ds_cap_state *cp,
+			    u64 req_num, cpumask_t *mask)
 {
 	struct ds_data *resp;
 	int resp_len, ncpus, cpu;
@@ -627,9 +625,8 @@ static int dr_cpu_unconfigure(struct ds_info *dp,
 	return 0;
 }
 
-static void __cpuinit dr_cpu_data(struct ds_info *dp,
-				  struct ds_cap_state *cp,
-				  void *buf, int len)
+static void dr_cpu_data(struct ds_info *dp, struct ds_cap_state *cp, void *buf,
+			int len)
 {
 	struct ds_data *data = buf;
 	struct dr_cpu_tag *tag = (struct dr_cpu_tag *) (data + 1);
diff --git a/arch/sparc/kernel/entry.h b/arch/sparc/kernel/entry.h
index cc3c5cb..9c179fb 100644
--- a/arch/sparc/kernel/entry.h
+++ b/arch/sparc/kernel/entry.h
@@ -250,7 +250,7 @@ extern struct ino_bucket *ivector_table;
 extern unsigned long ivector_table_pa;
 
 extern void init_irqwork_curcpu(void);
-extern void __cpuinit sun4v_register_mondo_queues(int this_cpu);
+extern void sun4v_register_mondo_queues(int this_cpu);
 
 #endif /* CONFIG_SPARC32 */
 #endif /* _ENTRY_H */
diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index 605c960..4eb1a5a 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -16,7 +16,6 @@
 #include <asm/asi.h>
 #include <asm/pil.h>
 
-	__CPUINIT
 	.align		8
 	.globl		hv_cpu_startup, hv_cpu_startup_end
 
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 9bcbbe2..d4840ce 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -835,7 +835,8 @@ void notrace init_irqwork_curcpu(void)
  * Therefore you cannot make any OBP calls, not even prom_printf,
  * from these two routines.
  */
-static void __cpuinit notrace register_one_mondo(unsigned long paddr, unsigned long type, unsigned long qmask)
+static void notrace register_one_mondo(unsigned long paddr, unsigned long type,
+				       unsigned long qmask)
 {
 	unsigned long num_entries = (qmask + 1) / 64;
 	unsigned long status;
@@ -848,7 +849,7 @@ static void __cpuinit notrace register_one_mondo(unsigned long paddr, unsigned l
 	}
 }
 
-void __cpuinit notrace sun4v_register_mondo_queues(int this_cpu)
+void notrace sun4v_register_mondo_queues(int this_cpu)
 {
 	struct trap_per_cpu *tb = &trap_block[this_cpu];
 
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index d7aa524..6edf955 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -54,7 +54,7 @@ extern ctxd_t *srmmu_ctx_table_phys;
 static int smp_processors_ready;
 extern volatile unsigned long cpu_callin_map[NR_CPUS];
 extern cpumask_t smp_commenced_mask;
-void __cpuinit leon_configure_cache_smp(void);
+void leon_configure_cache_smp(void);
 static void leon_ipi_init(void);
 
 /* IRQ number of LEON IPIs */
@@ -69,12 +69,12 @@ static inline unsigned long do_swap(volatile unsigned long *ptr,
 	return val;
 }
 
-void __cpuinit leon_cpu_pre_starting(void *arg)
+void leon_cpu_pre_starting(void *arg)
 {
 	leon_configure_cache_smp();
 }
 
-void __cpuinit leon_cpu_pre_online(void *arg)
+void leon_cpu_pre_online(void *arg)
 {
 	int cpuid = hard_smp_processor_id();
 
@@ -106,7 +106,7 @@ void __cpuinit leon_cpu_pre_online(void *arg)
 
 extern struct linux_prom_registers smp_penguin_ctable;
 
-void __cpuinit leon_configure_cache_smp(void)
+void leon_configure_cache_smp(void)
 {
 	unsigned long cfg = sparc_leon3_get_dcachecfg();
 	int me = smp_processor_id();
@@ -186,7 +186,7 @@ void __init leon_boot_cpus(void)
 
 }
 
-int __cpuinit leon_boot_one_cpu(int i, struct task_struct *idle)
+int leon_boot_one_cpu(int i, struct task_struct *idle)
 {
 	int timeout;
 
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 831c001..b90bf23 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -571,9 +571,7 @@ static void __init report_platform_properties(void)
 	mdesc_release(hp);
 }
 
-static void __cpuinit fill_in_one_cache(cpuinfo_sparc *c,
-					struct mdesc_handle *hp,
-					u64 mp)
+static void fill_in_one_cache(cpuinfo_sparc *c, struct mdesc_handle *hp, u64 mp)
 {
 	const u64 *level = mdesc_get_property(hp, mp, "level", NULL);
 	const u64 *size = mdesc_get_property(hp, mp, "size", NULL);
@@ -616,7 +614,7 @@ static void __cpuinit fill_in_one_cache(cpuinfo_sparc *c,
 	}
 }
 
-static void __cpuinit mark_core_ids(struct mdesc_handle *hp, u64 mp, int core_id)
+static void mark_core_ids(struct mdesc_handle *hp, u64 mp, int core_id)
 {
 	u64 a;
 
@@ -649,7 +647,7 @@ static void __cpuinit mark_core_ids(struct mdesc_handle *hp, u64 mp, int core_id
 	}
 }
 
-static void __cpuinit set_core_ids(struct mdesc_handle *hp)
+static void set_core_ids(struct mdesc_handle *hp)
 {
 	int idx;
 	u64 mp;
@@ -674,7 +672,7 @@ static void __cpuinit set_core_ids(struct mdesc_handle *hp)
 	}
 }
 
-static void __cpuinit mark_proc_ids(struct mdesc_handle *hp, u64 mp, int proc_id)
+static void mark_proc_ids(struct mdesc_handle *hp, u64 mp, int proc_id)
 {
 	u64 a;
 
@@ -693,7 +691,7 @@ static void __cpuinit mark_proc_ids(struct mdesc_handle *hp, u64 mp, int proc_id
 	}
 }
 
-static void __cpuinit __set_proc_ids(struct mdesc_handle *hp, const char *exec_unit_name)
+static void __set_proc_ids(struct mdesc_handle *hp, const char *exec_unit_name)
 {
 	int idx;
 	u64 mp;
@@ -714,14 +712,14 @@ static void __cpuinit __set_proc_ids(struct mdesc_handle *hp, const char *exec_u
 	}
 }
 
-static void __cpuinit set_proc_ids(struct mdesc_handle *hp)
+static void set_proc_ids(struct mdesc_handle *hp)
 {
 	__set_proc_ids(hp, "exec_unit");
 	__set_proc_ids(hp, "exec-unit");
 }
 
-static void __cpuinit get_one_mondo_bits(const u64 *p, unsigned int *mask,
-					 unsigned long def, unsigned long max)
+static void get_one_mondo_bits(const u64 *p, unsigned int *mask,
+			       unsigned long def, unsigned long max)
 {
 	u64 val;
 
@@ -742,8 +740,8 @@ use_default:
 	*mask = ((1U << def) * 64U) - 1U;
 }
 
-static void __cpuinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
-				     struct trap_per_cpu *tb)
+static void get_mondo_data(struct mdesc_handle *hp, u64 mp,
+			   struct trap_per_cpu *tb)
 {
 	static int printed;
 	const u64 *val;
@@ -769,7 +767,7 @@ static void __cpuinit get_mondo_data(struct mdesc_handle *hp, u64 mp,
 	}
 }
 
-static void * __cpuinit mdesc_iterate_over_cpus(void *(*func)(struct mdesc_handle *, u64, int, void *), void *arg, cpumask_t *mask)
+static void *mdesc_iterate_over_cpus(void *(*func)(struct mdesc_handle *, u64, int, void *), void *arg, cpumask_t *mask)
 {
 	struct mdesc_handle *hp = mdesc_grab();
 	void *ret = NULL;
@@ -799,7 +797,8 @@ out:
 	return ret;
 }
 
-static void * __cpuinit record_one_cpu(struct mdesc_handle *hp, u64 mp, int cpuid, void *arg)
+static void *record_one_cpu(struct mdesc_handle *hp, u64 mp, int cpuid,
+			    void *arg)
 {
 	ncpus_probed++;
 #ifdef CONFIG_SMP
@@ -808,7 +807,7 @@ static void * __cpuinit record_one_cpu(struct mdesc_handle *hp, u64 mp, int cpui
 	return NULL;
 }
 
-void __cpuinit mdesc_populate_present_mask(cpumask_t *mask)
+void mdesc_populate_present_mask(cpumask_t *mask)
 {
 	if (tlb_type != hypervisor)
 		return;
@@ -841,7 +840,8 @@ void __init mdesc_get_page_sizes(cpumask_t *mask, unsigned long *pgsz_mask)
 	mdesc_iterate_over_cpus(check_one_pgsz, pgsz_mask, mask);
 }
 
-static void * __cpuinit fill_in_one_cpu(struct mdesc_handle *hp, u64 mp, int cpuid, void *arg)
+static void *fill_in_one_cpu(struct mdesc_handle *hp, u64 mp, int cpuid,
+			     void *arg)
 {
 	const u64 *cfreq = mdesc_get_property(hp, mp, "clock-frequency", NULL);
 	struct trap_per_cpu *tb;
@@ -890,7 +890,7 @@ static void * __cpuinit fill_in_one_cpu(struct mdesc_handle *hp, u64 mp, int cpu
 	return NULL;
 }
 
-void __cpuinit mdesc_fill_in_cpu_data(cpumask_t *mask)
+void mdesc_fill_in_cpu_data(cpumask_t *mask)
 {
 	struct mdesc_handle *hp;
 
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index e3f2b81..a102bfb 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -39,7 +39,7 @@
 #include "kernel.h"
 #include "irq.h"
 
-volatile unsigned long cpu_callin_map[NR_CPUS] __cpuinitdata = {0,};
+volatile unsigned long cpu_callin_map[NR_CPUS] = {0,};
 
 cpumask_t smp_commenced_mask = CPU_MASK_NONE;
 
@@ -53,7 +53,7 @@ const struct sparc32_ipi_ops *sparc32_ipi_ops;
  * instruction which is much better...
  */
 
-void __cpuinit smp_store_cpu_info(int id)
+void smp_store_cpu_info(int id)
 {
 	int cpu_node;
 	int mid;
@@ -120,7 +120,7 @@ void cpu_panic(void)
 	panic("SMP bolixed\n");
 }
 
-struct linux_prom_registers smp_penguin_ctable __cpuinitdata = { 0 };
+struct linux_prom_registers smp_penguin_ctable = { 0 };
 
 void smp_send_reschedule(int cpu)
 {
@@ -259,10 +259,10 @@ void __init smp_prepare_boot_cpu(void)
 	set_cpu_possible(cpuid, true);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	extern int __cpuinit smp4m_boot_one_cpu(int, struct task_struct *);
-	extern int __cpuinit smp4d_boot_one_cpu(int, struct task_struct *);
+	extern int smp4m_boot_one_cpu(int, struct task_struct *);
+	extern int smp4d_boot_one_cpu(int, struct task_struct *);
 	int ret=0;
 
 	switch(sparc_cpu_model) {
@@ -297,7 +297,7 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
-void __cpuinit arch_cpu_pre_starting(void *arg)
+void arch_cpu_pre_starting(void *arg)
 {
 	local_ops->cache_all();
 	local_ops->tlb_all();
@@ -317,7 +317,7 @@ void __cpuinit arch_cpu_pre_starting(void *arg)
 	}
 }
 
-void __cpuinit arch_cpu_pre_online(void *arg)
+void arch_cpu_pre_online(void *arg)
 {
 	unsigned int cpuid = hard_smp_processor_id();
 
@@ -344,7 +344,7 @@ void __cpuinit arch_cpu_pre_online(void *arg)
 	}
 }
 
-void __cpuinit sparc_start_secondary(void *arg)
+void sparc_start_secondary(void *arg)
 {
 	unsigned int cpu;
 
@@ -375,7 +375,7 @@ void __cpuinit sparc_start_secondary(void *arg)
 	BUG();
 }
 
-void __cpuinit smp_callin(void)
+void smp_callin(void)
 {
 	sparc_start_secondary(NULL);
 }
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 77539ed..e142545 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -87,7 +87,7 @@ extern void setup_sparc64_timer(void);
 
 static volatile unsigned long callin_flag = 0;
 
-void __cpuinit smp_callin(void)
+void smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
 
@@ -281,7 +281,8 @@ static unsigned long kimage_addr_to_ra(void *p)
 	return kern_base + (val - KERNBASE);
 }
 
-static void __cpuinit ldom_startcpu_cpuid(unsigned int cpu, unsigned long thread_reg, void **descrp)
+static void ldom_startcpu_cpuid(unsigned int cpu, unsigned long thread_reg,
+				void **descrp)
 {
 	extern unsigned long sparc64_ttable_tl0;
 	extern unsigned long kern_locked_tte_data;
@@ -342,7 +343,7 @@ extern unsigned long sparc64_cpu_startup;
  */
 static struct thread_info *cpu_new_thread = NULL;
 
-static int __cpuinit smp_boot_one_cpu(unsigned int cpu, struct task_struct *idle)
+static int smp_boot_one_cpu(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long entry =
 		(unsigned long)(&sparc64_cpu_startup);
@@ -1266,7 +1267,7 @@ void smp_fill_in_sib_core_maps(void)
 	}
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret = smp_boot_one_cpu(cpu, tidle);
 
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index c9eb82f..d5c3195 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -50,7 +50,7 @@ static inline void show_leds(int cpuid)
 			      "i" (ASI_M_CTL));
 }
 
-void __cpuinit sun4d_cpu_pre_starting(void *arg)
+void sun4d_cpu_pre_starting(void *arg)
 {
 	int cpuid = hard_smp_processor_id();
 
@@ -62,7 +62,7 @@ void __cpuinit sun4d_cpu_pre_starting(void *arg)
 	cc_set_imsk((cc_get_imsk() & ~0x8000) | 0x4000);
 }
 
-void __cpuinit sun4d_cpu_pre_online(void *arg)
+void sun4d_cpu_pre_online(void *arg)
 {
 	unsigned long flags;
 	int cpuid;
@@ -118,7 +118,7 @@ void __init smp4d_boot_cpus(void)
 	local_ops->cache_all();
 }
 
-int __cpuinit smp4d_boot_one_cpu(int i, struct task_struct *idle)
+int smp4d_boot_one_cpu(int i, struct task_struct *idle)
 {
 	unsigned long *entry = &sun4d_cpu_startup;
 	int timeout;
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 8a65f15..d3408e7 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -34,11 +34,11 @@ swap_ulong(volatile unsigned long *ptr, unsigned long val)
 	return val;
 }
 
-void __cpuinit sun4m_cpu_pre_starting(void *arg)
+void sun4m_cpu_pre_starting(void *arg)
 {
 }
 
-void __cpuinit sun4m_cpu_pre_online(void *arg)
+void sun4m_cpu_pre_online(void *arg)
 {
 	int cpuid = hard_smp_processor_id();
 
@@ -75,7 +75,7 @@ void __init smp4m_boot_cpus(void)
 	local_ops->cache_all();
 }
 
-int __cpuinit smp4m_boot_one_cpu(int i, struct task_struct *idle)
+int smp4m_boot_one_cpu(int i, struct task_struct *idle)
 {
 	unsigned long *entry = &sun4m_cpu_startup;
 	int timeout;
diff --git a/arch/sparc/kernel/sysfs.c b/arch/sparc/kernel/sysfs.c
index 654e8aa..c21c673 100644
--- a/arch/sparc/kernel/sysfs.c
+++ b/arch/sparc/kernel/sysfs.c
@@ -246,7 +246,7 @@ static void unregister_cpu_online(unsigned int cpu)
 }
 #endif
 
-static int __cpuinit sysfs_cpu_notify(struct notifier_block *self,
+static int sysfs_cpu_notify(struct notifier_block *self,
 				      unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned int)(long)hcpu;
@@ -266,7 +266,7 @@ static int __cpuinit sysfs_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata sysfs_cpu_nb = {
+static struct notifier_block sysfs_cpu_nb = {
 	.notifier_call	= sysfs_cpu_notify,
 };
 
diff --git a/arch/sparc/kernel/trampoline_32.S b/arch/sparc/kernel/trampoline_32.S
index 6cdb08c..76dcbd3 100644
--- a/arch/sparc/kernel/trampoline_32.S
+++ b/arch/sparc/kernel/trampoline_32.S
@@ -18,7 +18,6 @@
 	.globl sun4m_cpu_startup
 	.globl sun4d_cpu_startup
 
-	__CPUINIT
 	.align 4
 
 /* When we start up a cpu for the first time it enters this routine.
@@ -94,7 +93,6 @@ smp_panic:
 /* CPUID in bootbus can be found at PA 0xff0140000 */
 #define SUN4D_BOOTBUS_CPUID	0xf0140000
 
-	__CPUINIT
 	.align	4
 
 sun4d_cpu_startup:
@@ -146,7 +144,6 @@ sun4d_cpu_startup:
 
 	b,a	smp_panic
 
-	__CPUINIT
 	.align	4
         .global leon_smp_cpu_startup, smp_penguin_ctable
 
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index 2e973a2..e0b1e13 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -32,13 +32,11 @@ itlb_load:
 dtlb_load:
 	.asciz	"SUNW,dtlb-load"
 
-	/* XXX __cpuinit this thing XXX */
 #define TRAMP_STACK_SIZE	1024
 	.align	16
 tramp_stack:
 	.skip	TRAMP_STACK_SIZE
 
-	__CPUINIT
 	.align		8
 	.globl		sparc64_cpu_startup, sparc64_cpu_startup_end
 sparc64_cpu_startup:
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index a9c42a7..ed82eda 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1694,7 +1694,7 @@ static void __init sun4v_ktsb_init(void)
 #endif
 }
 
-void __cpuinit sun4v_ktsb_register(void)
+void sun4v_ktsb_register(void)
 {
 	unsigned long pa, ret;
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 036c279..5d721df 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -858,7 +858,7 @@ static void __init map_kernel(void)
 	}
 }
 
-void (*poke_srmmu)(void) __cpuinitdata = NULL;
+void (*poke_srmmu)(void) = NULL;
 
 extern unsigned long bootmem_init(unsigned long *pages_avail);
 
@@ -1055,7 +1055,7 @@ static void __init init_vac_layout(void)
 	       (int)vac_cache_size, (int)vac_line_size);
 }
 
-static void __cpuinit poke_hypersparc(void)
+static void poke_hypersparc(void)
 {
 	volatile unsigned long clear;
 	unsigned long mreg = srmmu_get_mmureg();
@@ -1107,7 +1107,7 @@ static void __init init_hypersparc(void)
 	hypersparc_setup_blockops();
 }
 
-static void __cpuinit poke_swift(void)
+static void poke_swift(void)
 {
 	unsigned long mreg;
 
@@ -1287,7 +1287,7 @@ static void turbosparc_flush_tlb_page(struct vm_area_struct *vma, unsigned long
 }
 
 
-static void __cpuinit poke_turbosparc(void)
+static void poke_turbosparc(void)
 {
 	unsigned long mreg = srmmu_get_mmureg();
 	unsigned long ccreg;
@@ -1350,7 +1350,7 @@ static void __init init_turbosparc(void)
 	poke_srmmu = poke_turbosparc;
 }
 
-static void __cpuinit poke_tsunami(void)
+static void poke_tsunami(void)
 {
 	unsigned long mreg = srmmu_get_mmureg();
 
@@ -1391,7 +1391,7 @@ static void __init init_tsunami(void)
 	tsunami_setup_blockops();
 }
 
-static void __cpuinit poke_viking(void)
+static void poke_viking(void)
 {
 	unsigned long mreg = srmmu_get_mmureg();
 	static int smp_catch;
-- 
1.8.1.2

