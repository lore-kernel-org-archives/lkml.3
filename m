Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab3ERCci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:32:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3ERCc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:32:27 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=lsOAZZS9LaMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=zNXoGfytzK0A:10 a=20KFwNOVAAAA:8 a=dl-d6mStAAAA:8 a=W5mFZgEbAAAA:8 a=clPLZDdZ9Wy-auGLfrwA:9 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=6Nygb_p3FCgYtyVo:21 a=w2dWbKMFuykZqInI:21 a=-mn_r0ZoJGfHtT3W:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368844343.6828.108.camel@gandalf.local.home>
Subject: Re: [ 000/136 ] 3.6.11.4-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Date: Fri, 17 May 2013 22:32:23 -0400
In-Reply-To: <20130518021557.139113314@goodmis.org>
References: <20130518021557.139113314@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 8be9655..982b2b4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 6
 SUBLEVEL = 11
-EXTRAVERSION = .3
+EXTRAVERSION = .4
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index 606d48f..8aab786 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -173,7 +173,6 @@ CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_SDIO_UART=m
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 41dc31f..cc5e50f 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -61,6 +61,15 @@ extern void __pgd_error(const char *file, int line, pgd_t);
 #define FIRST_USER_ADDRESS	PAGE_SIZE
 
 /*
+ * Use TASK_SIZE as the ceiling argument for free_pgtables() and
+ * free_pgd_range() to avoid freeing the modules pmd when LPAE is enabled (pmd
+ * page shared between user and kernel).
+ */
+#ifdef CONFIG_ARM_LPAE
+#define USER_PGTABLES_CEILING	TASK_SIZE
+#endif
+
+/*
  * The pgprot_* and protection_map entries will be fixed up in runtime
  * to include the cachable and bufferable bits based on memory policy,
  * as well as any architecture dependent bits like global/ASID and SMP
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index bd0e88c..7255726 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -330,7 +330,7 @@ static void at91_dt_rstc(void)
 
 	of_id = of_match_node(rstc_ids, np);
 	if (!of_id)
-		panic("AT91: rtsc no restart function availlable\n");
+		panic("AT91: rtsc no restart function available\n");
 
 	arm_pm_restart = of_id->data;
 
diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index f2a49a4..6fa5ac4 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -265,8 +265,9 @@ static int omap3_enter_idle_bm(struct cpuidle_device *dev,
 DEFINE_PER_CPU(struct cpuidle_device, omap3_idle_dev);
 
 struct cpuidle_driver omap3_idle_driver = {
-	.name = 	"omap3_idle",
-	.owner = 	THIS_MODULE,
+	.name             = "omap3_idle",
+	.owner            = THIS_MODULE,
+	.en_core_tk_irqen = 1,
 	.states = {
 		{
 			.enter		  = omap3_enter_idle_bm,
diff --git a/arch/arm/mach-u300/include/mach/u300-regs.h b/arch/arm/mach-u300/include/mach/u300-regs.h
index 65f87c5..cacb2af 100644
--- a/arch/arm/mach-u300/include/mach/u300-regs.h
+++ b/arch/arm/mach-u300/include/mach/u300-regs.h
@@ -101,7 +101,7 @@
 
 #ifdef CONFIG_MACH_U300_BS335
 /* Fast UART1 on U335 only */
-#define U300_UART1_BASE			(U300_SLOW_PER_PHYS_BASE+0x7000)
+#define U300_UART1_BASE			(U300_FAST_PER_PHYS_BASE+0x7000)
 #endif
 
 /*
diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
index 19973b0..59e4cc9 100644
--- a/arch/avr32/configs/favr-32_defconfig
+++ b/arch/avr32/configs/favr-32_defconfig
@@ -122,7 +122,6 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_USB_CDC_COMPOSITE=m
 CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
diff --git a/arch/avr32/configs/merisc_defconfig b/arch/avr32/configs/merisc_defconfig
index 3befab9..65de443 100644
--- a/arch/avr32/configs/merisc_defconfig
+++ b/arch/avr32/configs/merisc_defconfig
@@ -102,7 +102,6 @@ CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
 CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=y
diff --git a/arch/ia64/include/asm/futex.h b/arch/ia64/include/asm/futex.h
index d2bf1fd..76acbcd 100644
--- a/arch/ia64/include/asm/futex.h
+++ b/arch/ia64/include/asm/futex.h
@@ -106,16 +106,15 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		return -EFAULT;
 
 	{
-		register unsigned long r8 __asm ("r8");
+		register unsigned long r8 __asm ("r8") = 0;
 		unsigned long prev;
 		__asm__ __volatile__(
 			"	mf;;					\n"
-			"	mov %0=r0				\n"
 			"	mov ar.ccv=%4;;				\n"
 			"[1:]	cmpxchg4.acq %1=[%2],%3,ar.ccv		\n"
 			"	.xdata4 \"__ex_table\", 1b-., 2f-.	\n"
 			"[2:]"
-			: "=r" (r8), "=r" (prev)
+			: "+r" (r8), "=&r" (prev)
 			: "r" (uaddr), "r" (newval),
 			  "rO" ((long) (unsigned) oldval)
 			: "memory");
diff --git a/arch/ia64/include/asm/mca.h b/arch/ia64/include/asm/mca.h
index 43f96ab..8c70961 100644
--- a/arch/ia64/include/asm/mca.h
+++ b/arch/ia64/include/asm/mca.h
@@ -143,6 +143,7 @@ extern unsigned long __per_cpu_mca[NR_CPUS];
 extern int cpe_vector;
 extern int ia64_cpe_irq;
 extern void ia64_mca_init(void);
+extern void ia64_mca_irq_init(void);
 extern void ia64_mca_cpu_init(void *);
 extern void ia64_os_mca_dispatch(void);
 extern void ia64_os_mca_dispatch_end(void);
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index ad69606..f2c41828 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -23,6 +23,8 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 
+#include <asm/mca.h>
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -83,6 +85,12 @@ bool is_affinity_mask_valid(const struct cpumask *cpumask)
 
 #endif /* CONFIG_SMP */
 
+int __init arch_early_irq_init(void)
+{
+	ia64_mca_irq_init();
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 unsigned int vectors_in_migration[NR_IRQS];
 
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 65bf9cd..d7396db 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -2074,22 +2074,16 @@ ia64_mca_init(void)
 	printk(KERN_INFO "MCA related initialization done\n");
 }
 
+
 /*
- * ia64_mca_late_init
- *
- *	Opportunity to setup things that require initialization later
- *	than ia64_mca_init.  Setup a timer to poll for CPEs if the
- *	platform doesn't support an interrupt driven mechanism.
- *
- *  Inputs  :   None
- *  Outputs :   Status
+ * These pieces cannot be done in ia64_mca_init() because it is called before
+ * early_irq_init() which would wipe out our percpu irq registrations. But we
+ * cannot leave them until ia64_mca_late_init() because by then all the other
+ * processors have been brought online and have set their own CMC vectors to
+ * point at a non-existant action. Called from arch_early_irq_init().
  */
-static int __init
-ia64_mca_late_init(void)
+void __init ia64_mca_irq_init(void)
 {
-	if (!mca_init)
-		return 0;
-
 	/*
 	 *  Configure the CMCI/P vector and handler. Interrupts for CMC are
 	 *  per-processor, so AP CMC interrupts are setup in smp_callin() (smpboot.c).
@@ -2108,6 +2102,23 @@ ia64_mca_late_init(void)
 	/* Setup the CPEI/P handler */
 	register_percpu_irq(IA64_CPEP_VECTOR, &mca_cpep_irqaction);
 #endif
+}
+
+/*
+ * ia64_mca_late_init
+ *
+ *	Opportunity to setup things that require initialization later
+ *	than ia64_mca_init.  Setup a timer to poll for CPEs if the
+ *	platform doesn't support an interrupt driven mechanism.
+ *
+ *  Inputs  :   None
+ *  Outputs :   Status
+ */
+static int __init
+ia64_mca_late_init(void)
+{
+	if (!mca_init)
+		return 0;
 
 	register_hotcpu_notifier(&mca_cpu_notifier);
 
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 4332f7e..a7869f8 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -256,7 +256,7 @@ u64 guest_vhpt_lookup(u64 iha, u64 *pte)
 			"srlz.d;;"
 			"ssm psr.i;;"
 			"srlz.d;;"
-			: "=r"(ret) : "r"(iha), "r"(pte):"memory");
+			: "=&r"(ret) : "r"(iha), "r"(pte) : "memory");
 
 	return ret;
 }
diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 4c25319..d486ec3 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -111,6 +111,10 @@
 #define PPC_INST_MFSPR_DSCR_MASK	0xfc1fffff
 #define PPC_INST_MTSPR_DSCR		0x7c1103a6
 #define PPC_INST_MTSPR_DSCR_MASK	0xfc1fffff
+#define PPC_INST_MFSPR_DSCR_USER	0x7c0302a6
+#define PPC_INST_MFSPR_DSCR_USER_MASK	0xfc1fffff
+#define PPC_INST_MTSPR_DSCR_USER	0x7c0303a6
+#define PPC_INST_MTSPR_DSCR_USER_MASK	0xfc1fffff
 #define PPC_INST_SLBFEE			0x7c0007a7
 
 #define PPC_INST_STRING			0x7c00042a
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 58bddee..8dd1841 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -489,6 +489,7 @@ _GLOBAL(copy_and_flush)
 	sync
 	addi	r5,r5,8
 	addi	r6,r6,8
+	isync
 	blr
 
 .align 8
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index ae0843f..3bb7197 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -960,7 +960,10 @@ static int emulate_instruction(struct pt_regs *regs)
 
 #ifdef CONFIG_PPC64
 	/* Emulate the mfspr rD, DSCR. */
-	if (((instword & PPC_INST_MFSPR_DSCR_MASK) == PPC_INST_MFSPR_DSCR) &&
+	if ((((instword & PPC_INST_MFSPR_DSCR_USER_MASK) ==
+		PPC_INST_MFSPR_DSCR_USER) ||
+	     ((instword & PPC_INST_MFSPR_DSCR_MASK) ==
+		PPC_INST_MFSPR_DSCR)) &&
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mfdscr, regs);
 		rd = (instword >> 21) & 0x1f;
@@ -968,7 +971,10 @@ static int emulate_instruction(struct pt_regs *regs)
 		return 0;
 	}
 	/* Emulate the mtspr DSCR, rD. */
-	if (((instword & PPC_INST_MTSPR_DSCR_MASK) == PPC_INST_MTSPR_DSCR) &&
+	if ((((instword & PPC_INST_MTSPR_DSCR_USER_MASK) ==
+		PPC_INST_MTSPR_DSCR_USER) ||
+	     ((instword & PPC_INST_MTSPR_DSCR_MASK) ==
+		PPC_INST_MTSPR_DSCR)) &&
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mtdscr, regs);
 		rd = (instword >> 21) & 0x1f;
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 59213cf..d53fa78 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -201,7 +201,7 @@ int __node_distance(int a, int b)
 	int distance = LOCAL_DISTANCE;
 
 	if (!form1_affinity)
-		return distance;
+		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
 	for (i = 0; i < distance_ref_points_depth; i++) {
 		if (distance_lookup_table[a][i] == distance_lookup_table[b][i])
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index dba1ce2..506dc9f 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -99,6 +99,7 @@ spufs_new_inode(struct super_block *sb, umode_t mode)
 	if (!inode)
 		goto out;
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6bd7d74..fb433eb 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -65,6 +65,10 @@ static inline int is_zero_pfn(unsigned long pfn)
 
 #define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
+/* TODO: s390 cannot support io_remap_pfn_range... */
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) 	       \
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index da02e9c..d978353 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -310,7 +310,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
+		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		mask |= X86_BR_KERNEL;
+	}
 
 	/* we ignore BRANCH_HV here */
 
@@ -339,6 +342,8 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
+
+	return 0;
 }
 
 /*
@@ -386,7 +391,9 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	intel_pmu_setup_sw_lbr_filter(event);
+	ret = intel_pmu_setup_sw_lbr_filter(event);
+	if (ret)
+		return ret;
 
 	/*
 	 * setup HW LBR filter, if any
@@ -442,8 +449,18 @@ static int branch_type(unsigned long from, unsigned long to)
 			return X86_BR_NONE;
 
 		addr = buf;
-	} else
-		addr = (void *)from;
+	} else {
+		/*
+		 * The LBR logs any address in the IP, even if the IP just
+		 * faulted. This means userspace can control the from address.
+		 * Ensure we don't blindy read any address by validating it is
+		 * a known text address.
+		 */
+		if (kernel_text_address(from))
+			addr = (void *)from;
+		else
+			return X86_BR_NONE;
+	}
 
 	/*
 	 * decoder needs to know the ABI especially
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 38e4894..0c0957d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2398,7 +2398,7 @@ static void __init uncore_types_exit(struct intel_uncore_type **types)
 static int __init uncore_type_init(struct intel_uncore_type *type)
 {
 	struct intel_uncore_pmu *pmus;
-	struct attribute_group *events_group;
+	struct attribute_group *attr_group;
 	struct attribute **attrs;
 	int i, j;
 
@@ -2425,19 +2425,19 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 		while (type->event_descs[i].attr.attr.name)
 			i++;
 
-		events_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
-					sizeof(*events_group), GFP_KERNEL);
-		if (!events_group)
+		attr_group = kzalloc(sizeof(struct attribute *) * (i + 1) +
+					sizeof(*attr_group), GFP_KERNEL);
+		if (!attr_group)
 			goto fail;
 
-		attrs = (struct attribute **)(events_group + 1);
-		events_group->name = "events";
-		events_group->attrs = attrs;
+		attrs = (struct attribute **)(attr_group + 1);
+		attr_group->name = "events";
+		attr_group->attrs = attrs;
 
 		for (j = 0; j < i; j++)
 			attrs[j] = &type->event_descs[j].attr.attr;
 
-		type->attr_groups[1] = events_group;
+		type->attr_groups[1] = attr_group;
 	}
 
 	type->pmus = pmus;
@@ -2820,6 +2820,7 @@ static int __init uncore_cpu_init(void)
 		msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
+	case 58: /* Ivy Bridge */
 		if (snb_uncore_cbox.num_boxes > max_cores)
 			snb_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snb_msr_uncores;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d44f782..e62cf16 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -165,10 +165,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 u64 arch_irq_stat(void)
 {
 	u64 sum = atomic_read(&irq_err_count);
-
-#ifdef CONFIG_X86_IO_APIC
-	sum += atomic_read(&irq_mis_count);
-#endif
 	return sum;
 }
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a3b57a2..2386209 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3970,6 +3970,10 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		break;
 	case OpMem8:
 		ctxt->memop.bytes = 1;
+		if (ctxt->memop.type == OP_REG) {
+			ctxt->memop.addr.reg = decode_register(ctxt, ctxt->modrm_rm, 1);
+			fetch_register_operand(&ctxt->memop);
+		}
 		goto mem_common;
 	case OpMem16:
 		ctxt->memop.bytes = 2;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d7aea41..7d7a36d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -45,11 +45,15 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	int i;
 	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
 	unsigned long start = 0, good_end;
+	unsigned long pgd_extra = 0;
 	phys_addr_t base;
 
 	for (i = 0; i < nr_range; i++) {
 		unsigned long range, extra;
 
+		if ((mr[i].end >> PGDIR_SHIFT) - (mr[i].start >> PGDIR_SHIFT))
+			pgd_extra++;
+
 		range = mr[i].end - mr[i].start;
 		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
@@ -74,6 +78,7 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+	tables += (pgd_extra * PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
 	/* for fixmap */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c1461de..0dc16d6 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1553,8 +1553,11 @@ static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_UP_PREPARE:
 		xen_vcpu_setup(cpu);
-		if (xen_have_vector_callback)
+		if (xen_have_vector_callback) {
 			xen_init_lock_cpu(cpu);
+			if (xen_feature(XENFEAT_hvm_safe_pvclock))
+				xen_setup_timer(cpu);
+		}
 		break;
 	default:
 		break;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index f58dca7..641c91e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -667,6 +667,8 @@ static void xen_hvm_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_uninit_lock_cpu(cpu);
+	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0296a95..054cc01 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -497,7 +497,11 @@ static void xen_hvm_setup_cpu_clockevents(void)
 {
 	int cpu = smp_processor_id();
 	xen_setup_runstate_info(cpu);
-	xen_setup_timer(cpu);
+	/*
+	 * xen_setup_timer(cpu) - snprintf is bad in atomic context. Hence
+	 * doing it xen_hvm_cpu_notify (which gets called by smp_init during
+	 * early bootup and also during CPU hotplug events).
+	 */
 	xen_setup_cpu_clockevents();
 }
 
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 72a2c98..ef0690e 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -247,8 +247,8 @@ static acpi_status acpi_pci_query_osc(struct acpi_pci_root *root,
 		*control &= OSC_PCI_CONTROL_MASKS;
 		capbuf[OSC_CONTROL_TYPE] = *control | root->osc_control_set;
 	} else {
-		/* Run _OSC query for all possible controls. */
-		capbuf[OSC_CONTROL_TYPE] = OSC_PCI_CONTROL_MASKS;
+		/* Run _OSC query only with existing controls. */
+		capbuf[OSC_CONTROL_TYPE] = root->osc_control_set;
 	}
 
 	status = acpi_pci_run_osc(root->device->handle, capbuf, &result);
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 5b0ba3f..926c9f5 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -60,7 +60,8 @@ acpi_handle ata_ap_acpi_handle(struct ata_port *ap)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return NULL;
 
-	return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev), ap->port_no);
+	return ap->scsi_host ?
+		DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev) : NULL;
 }
 EXPORT_SYMBOL(ata_ap_acpi_handle);
 
@@ -236,28 +237,15 @@ void ata_acpi_dissociate(struct ata_host *host)
 	}
 }
 
-/**
- * ata_acpi_gtm - execute _GTM
- * @ap: target ATA port
- * @gtm: out parameter for _GTM result
- *
- * Evaluate _GTM and store the result in @gtm.
- *
- * LOCKING:
- * EH context.
- *
- * RETURNS:
- * 0 on success, -ENOENT if _GTM doesn't exist, -errno on failure.
- */
-int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
+static int __ata_acpi_gtm(struct ata_port *ap, acpi_handle handle,
+			  struct ata_acpi_gtm *gtm)
 {
 	struct acpi_buffer output = { .length = ACPI_ALLOCATE_BUFFER };
 	union acpi_object *out_obj;
 	acpi_status status;
 	int rc = 0;
 
-	status = acpi_evaluate_object(ata_ap_acpi_handle(ap), "_GTM", NULL,
-				      &output);
+	status = acpi_evaluate_object(handle, "_GTM", NULL, &output);
 
 	rc = -ENOENT;
 	if (status == AE_NOT_FOUND)
@@ -291,6 +279,27 @@ int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
 	return rc;
 }
 
+/**
+ * ata_acpi_gtm - execute _GTM
+ * @ap: target ATA port
+ * @gtm: out parameter for _GTM result
+ *
+ * Evaluate _GTM and store the result in @gtm.
+ *
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * 0 on success, -ENOENT if _GTM doesn't exist, -errno on failure.
+ */
+int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
+{
+	if (ata_ap_acpi_handle(ap))
+		return __ata_acpi_gtm(ap, ata_ap_acpi_handle(ap), gtm);
+	else
+		return -EINVAL;
+}
+
 EXPORT_SYMBOL_GPL(ata_acpi_gtm);
 
 /**
@@ -1091,7 +1100,7 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
-	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
+	if (__ata_acpi_gtm(ap, *handle, &ap->__acpi_init_gtm) == 0)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 
 	return 0;
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 4dc8024..8a3a5fb 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -35,6 +35,7 @@ enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
 	TPM_BUFSIZE = 4096,
 	TPM_NUM_DEVICES = 256,
+	TPM_RETRY = 50,		/* 5 seconds */
 };
 
 enum tpm_duration {
@@ -1293,7 +1294,7 @@ int tpm_pm_suspend(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct tpm_cmd_t cmd;
-	int rc;
+	int rc, try;
 
 	u8 dummy_hash[TPM_DIGEST_SIZE] = { 0 };
 
@@ -1311,9 +1312,32 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 	/* now do the actual savestate */
-	cmd.header.in = savestate_header;
-	rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE,
-			  "sending savestate before suspend");
+	for (try = 0; try < TPM_RETRY; try++) {
+		cmd.header.in = savestate_header;
+		rc = transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, NULL);
+
+		/*
+		 * If the TPM indicates that it is too busy to respond to
+		 * this command then retry before giving up.  It can take
+		 * several seconds for this TPM to be ready.
+		 *
+		 * This can happen if the TPM has already been sent the
+		 * SaveState command before the driver has loaded.  TCG 1.2
+		 * specification states that any communication after SaveState
+		 * may cause the TPM to invalidate previously saved state.
+		 */
+		if (rc != TPM_WARN_RETRY)
+			break;
+		msleep(TPM_TIMEOUT_RETRY);
+	}
+
+	if (rc)
+		dev_err(chip->dev,
+			"Error (%d) sending savestate before suspend\n", rc);
+	else if (try > 0)
+		dev_warn(chip->dev, "TPM savestate took %dms\n",
+			 try * TPM_TIMEOUT_RETRY);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 917f727..7ccb3ec 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -30,6 +30,7 @@
 
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
+	TPM_TIMEOUT_RETRY = 100 /* msecs */
 };
 
 /* TPM addresses */
@@ -38,6 +39,7 @@ enum tpm_addr {
 	TPM_ADDR = 0x4E,
 };
 
+#define TPM_WARN_RETRY          0x800
 #define TPM_WARN_DOING_SELFTEST 0x802
 #define TPM_ERR_DEACTIVATED     0x6
 #define TPM_ERR_DISABLED        0x7
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index d4af9ed..85a6eeb 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -240,6 +240,8 @@ struct ast_fbdev {
 	void *sysram;
 	int size;
 	struct ttm_bo_kmap_obj mapping;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 #define to_ast_crtc(x) container_of(x, struct ast_crtc, base)
diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 2fc8e9e..853f831 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -53,16 +53,52 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	int bpp = (afbdev->afb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = afbdev->afb.obj;
 	bo = gem_to_ast_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = ast_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
+
+		store_for_later = true;
+	}
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+	spin_lock_irqsave(&afbdev->dirty_lock, flags);
+
+	if (afbdev->y1 < y)
+		y = afbdev->y1;
+	if (afbdev->y2 > y2)
+		y2 = afbdev->y2;
+	if (afbdev->x1 < x)
+		x = afbdev->x1;
+	if (afbdev->x2 > x2)
+		x2 = afbdev->x2;
+
+	if (store_for_later) {
+		afbdev->x1 = x;
+		afbdev->x2 = x2;
+		afbdev->y1 = y;
+		afbdev->y2 = y2;
+		spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
 		return;
 	}
 
+	afbdev->x1 = afbdev->y1 = INT_MAX;
+	afbdev->x2 = afbdev->y2 = 0;
+	spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -72,10 +108,10 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 		}
 		unmap = true;
 	}
-	for (i = y; i < y + height; i++) {
+	for (i = y; i <= y2; i++) {
 		/* assume equal stride for now */
 		src_offset = dst_offset = i * afbdev->afb.base.pitches[0] + (x * bpp);
-		memcpy_toio(bo->kmap.virtual + src_offset, afbdev->sysram + src_offset, width * bpp);
+		memcpy_toio(bo->kmap.virtual + src_offset, afbdev->sysram + src_offset, (x2 - x + 1) * bpp);
 
 	}
 	if (unmap)
@@ -306,6 +342,7 @@ int ast_fbdev_init(struct drm_device *dev)
 
 	ast->fbdev = afbdev;
 	afbdev->helper.funcs = &ast_fb_helper_funcs;
+	spin_lock_init(&afbdev->dirty_lock);
 	ret = drm_fb_helper_init(dev, &afbdev->helper,
 				 1, 1);
 	if (ret) {
diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 6cf2ade..2a6027c 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -316,7 +316,7 @@ int ast_bo_reserve(struct ast_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
 			DRM_ERROR("reserve failed %p\n", bo);
 		return ret;
 	}
diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.h b/drivers/gpu/drm/cirrus/cirrus_drv.h
index 64ea597..9f29a90 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.h
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.h
@@ -155,6 +155,8 @@ struct cirrus_fbdev {
 	struct list_head fbdev_list;
 	void *sysram;
 	int size;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 struct cirrus_bo {
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 9a276a5..774bade 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -27,16 +27,51 @@ static void cirrus_dirty_update(struct cirrus_fbdev *afbdev,
 	int bpp = (afbdev->gfb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = afbdev->gfb.obj;
 	bo = gem_to_cirrus_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
+		store_for_later = true;
+	}
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+	spin_lock_irqsave(&afbdev->dirty_lock, flags);
+
+	if (afbdev->y1 < y)
+		y = afbdev->y1;
+	if (afbdev->y2 > y2)
+		y2 = afbdev->y2;
+	if (afbdev->x1 < x)
+		x = afbdev->x1;
+	if (afbdev->x2 > x2)
+		x2 = afbdev->x2;
+
+	if (store_for_later) {
+		afbdev->x1 = x;
+		afbdev->x2 = x2;
+		afbdev->y1 = y;
+		afbdev->y2 = y2;
+		spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
 		return;
 	}
 
+	afbdev->x1 = afbdev->y1 = INT_MAX;
+	afbdev->x2 = afbdev->y2 = 0;
+	spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -283,6 +318,7 @@ int cirrus_fbdev_init(struct cirrus_device *cdev)
 
 	cdev->mode_info.gfbdev = gfbdev;
 	gfbdev->helper.funcs = &cirrus_fb_helper_funcs;
+	spin_lock_init(&gfbdev->dirty_lock);
 
 	ret = drm_fb_helper_init(cdev->dev, &gfbdev->helper,
 				 cdev->num_crtc, CIRRUSFB_CONN_LIMIT);
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 50e170f..d4b1b1d 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -321,7 +321,7 @@ int cirrus_bo_reserve(struct cirrus_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
 			DRM_ERROR("reserve failed %p\n", bo);
 		return ret;
 	}
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index fbe0842..730b93f 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -205,11 +205,11 @@ static void
 drm_gem_remove_prime_handles(struct drm_gem_object *obj, struct drm_file *filp)
 {
 	if (obj->import_attach) {
-		drm_prime_remove_imported_buf_handle(&filp->prime,
+		drm_prime_remove_buf_handle(&filp->prime,
 				obj->import_attach->dmabuf);
 	}
 	if (obj->export_dma_buf) {
-		drm_prime_remove_imported_buf_handle(&filp->prime,
+		drm_prime_remove_buf_handle(&filp->prime,
 				obj->export_dma_buf);
 	}
 }
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index f546ff9..6497c53 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -61,6 +61,7 @@ struct drm_prime_member {
 	struct dma_buf *dma_buf;
 	uint32_t handle;
 };
+static int drm_prime_add_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle);
 
 int drm_gem_prime_handle_to_fd(struct drm_device *dev,
 		struct drm_file *file_priv, uint32_t handle, uint32_t flags,
@@ -68,7 +69,8 @@ int drm_gem_prime_handle_to_fd(struct drm_device *dev,
 {
 	struct drm_gem_object *obj;
 	void *buf;
-	int ret;
+	int ret = 0;
+	struct dma_buf *dmabuf;
 
 	obj = drm_gem_object_lookup(dev, file_priv, handle);
 	if (!obj)
@@ -77,43 +79,44 @@ int drm_gem_prime_handle_to_fd(struct drm_device *dev,
 	mutex_lock(&file_priv->prime.lock);
 	/* re-export the original imported object */
 	if (obj->import_attach) {
-		get_dma_buf(obj->import_attach->dmabuf);
-		*prime_fd = dma_buf_fd(obj->import_attach->dmabuf, flags);
-		drm_gem_object_unreference_unlocked(obj);
-		mutex_unlock(&file_priv->prime.lock);
-		return 0;
+		dmabuf = obj->import_attach->dmabuf;
+		goto out_have_obj;
 	}
 
 	if (obj->export_dma_buf) {
-		get_dma_buf(obj->export_dma_buf);
-		*prime_fd = dma_buf_fd(obj->export_dma_buf, flags);
-		drm_gem_object_unreference_unlocked(obj);
-	} else {
-		buf = dev->driver->gem_prime_export(dev, obj, flags);
-		if (IS_ERR(buf)) {
-			/* normally the created dma-buf takes ownership of the ref,
-			 * but if that fails then drop the ref
-			 */
-			drm_gem_object_unreference_unlocked(obj);
-			mutex_unlock(&file_priv->prime.lock);
-			return PTR_ERR(buf);
-		}
-		obj->export_dma_buf = buf;
-		*prime_fd = dma_buf_fd(buf, flags);
+		dmabuf = obj->export_dma_buf;
+		goto out_have_obj;
 	}
+
+	buf = dev->driver->gem_prime_export(dev, obj, flags);
+	if (IS_ERR(buf)) {
+		/* normally the created dma-buf takes ownership of the ref,
+		 * but if that fails then drop the ref
+		 */
+		ret = PTR_ERR(buf);
+		goto out;
+	}
+	obj->export_dma_buf = buf;
+
 	/* if we've exported this buffer the cheat and add it to the import list
 	 * so we get the correct handle back
 	 */
-	ret = drm_prime_add_imported_buf_handle(&file_priv->prime,
-			obj->export_dma_buf, handle);
-	if (ret) {
-		drm_gem_object_unreference_unlocked(obj);
-		mutex_unlock(&file_priv->prime.lock);
-		return ret;
-	}
+	ret = drm_prime_add_buf_handle(&file_priv->prime,
+				       obj->export_dma_buf, handle);
+	if (ret)
+		goto out;
 
+	*prime_fd = dma_buf_fd(buf, flags);
 	mutex_unlock(&file_priv->prime.lock);
 	return 0;
+
+out_have_obj:
+	get_dma_buf(dmabuf);
+	*prime_fd = dma_buf_fd(dmabuf, flags);
+out:
+	drm_gem_object_unreference_unlocked(obj);
+	mutex_unlock(&file_priv->prime.lock);
+	return ret;
 }
 EXPORT_SYMBOL(drm_gem_prime_handle_to_fd);
 
@@ -130,7 +133,7 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 
 	mutex_lock(&file_priv->prime.lock);
 
-	ret = drm_prime_lookup_imported_buf_handle(&file_priv->prime,
+	ret = drm_prime_lookup_buf_handle(&file_priv->prime,
 			dma_buf, handle);
 	if (!ret) {
 		ret = 0;
@@ -149,7 +152,7 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 	if (ret)
 		goto out_put;
 
-	ret = drm_prime_add_imported_buf_handle(&file_priv->prime,
+	ret = drm_prime_add_buf_handle(&file_priv->prime,
 			dma_buf, *handle);
 	if (ret)
 		goto fail;
@@ -307,7 +310,7 @@ void drm_prime_destroy_file_private(struct drm_prime_file_private *prime_fpriv)
 }
 EXPORT_SYMBOL(drm_prime_destroy_file_private);
 
-int drm_prime_add_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle)
+static int drm_prime_add_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle)
 {
 	struct drm_prime_member *member;
 
@@ -315,14 +318,14 @@ int drm_prime_add_imported_buf_handle(struct drm_prime_file_private *prime_fpriv
 	if (!member)
 		return -ENOMEM;
 
+	get_dma_buf(dma_buf);
 	member->dma_buf = dma_buf;
 	member->handle = handle;
 	list_add(&member->entry, &prime_fpriv->head);
 	return 0;
 }
-EXPORT_SYMBOL(drm_prime_add_imported_buf_handle);
 
-int drm_prime_lookup_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle)
+int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle)
 {
 	struct drm_prime_member *member;
 
@@ -334,19 +337,20 @@ int drm_prime_lookup_imported_buf_handle(struct drm_prime_file_private *prime_fp
 	}
 	return -ENOENT;
 }
-EXPORT_SYMBOL(drm_prime_lookup_imported_buf_handle);
+EXPORT_SYMBOL(drm_prime_lookup_buf_handle);
 
-void drm_prime_remove_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf)
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf)
 {
 	struct drm_prime_member *member, *safe;
 
 	mutex_lock(&prime_fpriv->lock);
 	list_for_each_entry_safe(member, safe, &prime_fpriv->head, entry) {
 		if (member->dma_buf == dma_buf) {
+			dma_buf_put(dma_buf);
 			list_del(&member->entry);
 			kfree(member);
 		}
 	}
 	mutex_unlock(&prime_fpriv->lock);
 }
-EXPORT_SYMBOL(drm_prime_remove_imported_buf_handle);
+EXPORT_SYMBOL(drm_prime_remove_buf_handle);
diff --git a/drivers/gpu/drm/gma500/psb_irq.c b/drivers/gpu/drm/gma500/psb_irq.c
index 8652cdf..029eccf 100644
--- a/drivers/gpu/drm/gma500/psb_irq.c
+++ b/drivers/gpu/drm/gma500/psb_irq.c
@@ -211,7 +211,7 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 
 	vdc_stat = PSB_RVDC32(PSB_INT_IDENTITY_R);
 
-	if (vdc_stat & _PSB_PIPE_EVENT_FLAG)
+	if (vdc_stat & (_PSB_PIPE_EVENT_FLAG|_PSB_IRQ_ASLE))
 		dsp_int = 1;
 
 	/* FIXME: Handle Medfield
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 627fe35..ec7cc29 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -464,6 +464,7 @@ typedef struct drm_i915_private {
 	unsigned int int_crt_support:1;
 	unsigned int lvds_use_ssc:1;
 	unsigned int display_clock_mode:1;
+	unsigned int fdi_rx_polarity_inverted:1;
 	int lvds_ssc_freq;
 	unsigned int bios_lvds_val; /* initial [PCH_]LVDS reg val in VBIOS */
 	unsigned int lvds_val; /* used for checking LVDS channel mode */
@@ -672,6 +673,7 @@ typedef struct drm_i915_private {
 		unsigned long gtt_start;
 		unsigned long gtt_mappable_end;
 		unsigned long gtt_end;
+		unsigned long stolen_base; /* limited to low memory (32-bit) */
 
 		struct io_mapping *gtt_mapping;
 		phys_addr_t gtt_base_addr;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 97d4f4b..18da42c 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2525,17 +2525,35 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
 	return fence - dev_priv->fence_regs;
 }
 
+static void i915_gem_write_fence__ipi(void *data)
+{
+	wbinvd();
+}
+
 static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,
 					 struct drm_i915_fence_reg *fence,
 					 bool enable)
 {
-	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
-	int reg = fence_number(dev_priv, fence);
-
-	i915_gem_write_fence(obj->base.dev, reg, enable ? obj : NULL);
+	struct drm_device *dev = obj->base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int fence_reg = fence_number(dev_priv, fence);
+
+	/* In order to fully serialize access to the fenced region and
+	 * the update to the fence register we need to take extreme
+	 * measures on SNB+. In theory, the write to the fence register
+	 * flushes all memory transactions before, and coupled with the
+	 * mb() placed around the register write we serialise all memory
+	 * operations with respect to the changes in the tiler. Yet, on
+	 * SNB+ we need to take a step further and emit an explicit wbinvd()
+	 * on each processor in order to manually flush all memory
+	 * transactions before updating the fence register.
+	 */
+	if (HAS_LLC(obj->base.dev))
+		on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
+	i915_gem_write_fence(dev, fence_reg, enable ? obj : NULL);
 
 	if (enable) {
-		obj->fence_reg = reg;
+		obj->fence_reg = fence_reg;
 		fence->obj = obj;
 		list_move_tail(&fence->lru_list, &dev_priv->mm.fence_list);
 	} else {
diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index a9d58d7..dda0d35 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -155,6 +155,13 @@ create_hw_context(struct drm_device *dev,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (INTEL_INFO(dev)->gen >= 7) {
+		ret = i915_gem_object_set_cache_level(ctx->obj,
+						      I915_CACHE_LLC_MLC);
+		if (ret)
+			goto err_out;
+	}
+
 	/* The ring associated with the context object is handled by the normal
 	 * object tracking code. We give an initial ring value simple to pass an
 	 * assertion in the context switch code.
diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index ada2e90..d023ed6 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -43,56 +43,50 @@
  * for is a boon.
  */
 
-#define PTE_ADDRESS_MASK		0xfffff000
-#define PTE_ADDRESS_MASK_HIGH		0x000000f0 /* i915+ */
-#define PTE_MAPPING_TYPE_UNCACHED	(0 << 1)
-#define PTE_MAPPING_TYPE_DCACHE		(1 << 1) /* i830 only */
-#define PTE_MAPPING_TYPE_CACHED		(3 << 1)
-#define PTE_MAPPING_TYPE_MASK		(3 << 1)
-#define PTE_VALID			(1 << 0)
-
-/**
- * i915_stolen_to_phys - take an offset into stolen memory and turn it into
- *                       a physical one
- * @dev: drm device
- * @offset: address to translate
- *
- * Some chip functions require allocations from stolen space and need the
- * physical address of the memory in question.
- */
-static unsigned long i915_stolen_to_phys(struct drm_device *dev, u32 offset)
+static unsigned long i915_stolen_to_physical(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct pci_dev *pdev = dev_priv->bridge_dev;
 	u32 base;
 
-#if 0
 	/* On the machines I have tested the Graphics Base of Stolen Memory
-	 * is unreliable, so compute the base by subtracting the stolen memory
-	 * from the Top of Low Usable DRAM which is where the BIOS places
-	 * the graphics stolen memory.
+	 * is unreliable, so on those compute the base by subtracting the
+	 * stolen memory from the Top of Low Usable DRAM which is where the
+	 * BIOS places the graphics stolen memory.
+	 *
+	 * On gen2, the layout is slightly different with the Graphics Segment
+	 * immediately following Top of Memory (or Top of Usable DRAM). Note
+	 * it appears that TOUD is only reported by 865g, so we just use the
+	 * top of memory as determined by the e820 probe.
+	 *
+	 * XXX gen2 requires an unavailable symbol and 945gm fails with
+	 * its value of TOLUD.
 	 */
-	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
-		/* top 32bits are reserved = 0 */
+	base = 0;
+	if (INTEL_INFO(dev)->gen >= 6) {
+		/* Read Base Data of Stolen Memory Register (BDSM) directly.
+		 * Note that there is also a MCHBAR miror at 0x1080c0 or
+		 * we could use device 2:0x5c instead.
+		*/
+		pci_read_config_dword(pdev, 0xB0, &base);
+		base &= ~4095; /* lower bits used for locking register */
+	} else if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
+		/* Read Graphics Base of Stolen Memory directly */
 		pci_read_config_dword(pdev, 0xA4, &base);
-	} else {
-		/* XXX presume 8xx is the same as i915 */
-		pci_bus_read_config_dword(pdev->bus, 2, 0x5C, &base);
-	}
-#else
-	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
-		u16 val;
-		pci_read_config_word(pdev, 0xb0, &val);
-		base = val >> 4 << 20;
-	} else {
+#if 0
+	} else if (IS_GEN3(dev)) {
 		u8 val;
+		/* Stolen is immediately below Top of Low Usable DRAM */
 		pci_read_config_byte(pdev, 0x9c, &val);
 		base = val >> 3 << 27;
-	}
-	base -= dev_priv->mm.gtt->stolen_size;
+		base -= dev_priv->mm.gtt->stolen_size;
+	} else {
+		/* Stolen is immediately above Top of Memory */
+		base = max_low_pfn_mapped << PAGE_SHIFT;
 #endif
+	}
 
-	return base + offset;
+	return base;
 }
 
 static void i915_warn_stolen(struct drm_device *dev)
@@ -117,7 +111,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	if (!compressed_fb)
 		goto err;
 
-	cfb_base = i915_stolen_to_phys(dev, compressed_fb->start);
+	cfb_base = dev_priv->mm.stolen_base + compressed_fb->start;
 	if (!cfb_base)
 		goto err_fb;
 
@@ -130,7 +124,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 		if (!compressed_llb)
 			goto err_fb;
 
-		ll_base = i915_stolen_to_phys(dev, compressed_llb->start);
+		ll_base = dev_priv->mm.stolen_base + compressed_llb->start;
 		if (!ll_base)
 			goto err_llb;
 	}
@@ -149,7 +143,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	}
 
 	DRM_DEBUG_KMS("FBC base 0x%08lx, ll base 0x%08lx, size %dM\n",
-		      cfb_base, ll_base, size >> 20);
+		      (long)cfb_base, (long)ll_base, size >> 20);
 	return;
 
 err_llb:
@@ -181,6 +175,13 @@ int i915_gem_init_stolen(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long prealloc_size = dev_priv->mm.gtt->stolen_size;
 
+	dev_priv->mm.stolen_base = i915_stolen_to_physical(dev);
+	if (dev_priv->mm.stolen_base == 0)
+		return 0;
+
+	DRM_DEBUG_KMS("found %d bytes of stolen memory at %08lx\n",
+		      dev_priv->mm.gtt->stolen_size, dev_priv->mm.stolen_base);
+
 	/* Basic memrange allocator for stolen space */
 	drm_mm_init(&dev_priv->mm.stolen, 0, prealloc_size);
 
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index f02cfad..3814aa3 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3758,6 +3758,7 @@
 #define _TRANSB_CHICKEN2	 0xf1064
 #define TRANS_CHICKEN2(pipe) _PIPE(pipe, _TRANSA_CHICKEN2, _TRANSB_CHICKEN2)
 #define   TRANS_AUTOTRAIN_GEN_STALL_DIS	(1<<31)
+#define  TRANS_CHICKEN2_FDI_POLARITY_REVERSED	(1<<29)
 
 #define SOUTH_CHICKEN1		0xc2000
 #define  FDIA_PHASE_SYNC_SHIFT_OVR	19
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index d0df62a..d10cf1d 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -352,12 +352,14 @@ parse_general_features(struct drm_i915_private *dev_priv,
 		dev_priv->lvds_ssc_freq =
 			intel_bios_ssc_frequency(dev, general->ssc_freq);
 		dev_priv->display_clock_mode = general->display_clock_mode;
-		DRM_DEBUG_KMS("BDB_GENERAL_FEATURES int_tv_support %d int_crt_support %d lvds_use_ssc %d lvds_ssc_freq %d display_clock_mode %d\n",
+		dev_priv->fdi_rx_polarity_inverted = general->fdi_rx_polarity_inverted;
+		DRM_DEBUG_KMS("BDB_GENERAL_FEATURES int_tv_support %d int_crt_support %d lvds_use_ssc %d lvds_ssc_freq %d display_clock_mode %d fdi_rx_polarity_inverted %d\n",
 			      dev_priv->int_tv_support,
 			      dev_priv->int_crt_support,
 			      dev_priv->lvds_use_ssc,
 			      dev_priv->lvds_ssc_freq,
-			      dev_priv->display_clock_mode);
+			      dev_priv->display_clock_mode,
+			      dev_priv->fdi_rx_polarity_inverted);
 	}
 }
 
diff --git a/drivers/gpu/drm/i915/intel_bios.h b/drivers/gpu/drm/i915/intel_bios.h
index 31c2107..e0af201 100644
--- a/drivers/gpu/drm/i915/intel_bios.h
+++ b/drivers/gpu/drm/i915/intel_bios.h
@@ -127,7 +127,9 @@ struct bdb_general_features {
         /* bits 3 */
 	u8 disable_smooth_vision:1;
 	u8 single_dvi:1;
-	u8 rsvd9:6; /* finish byte */
+	u8 rsvd9:1;
+	u8 fdi_rx_polarity_inverted:1;
+	u8 rsvd10:4; /* finish byte */
 
         /* bits 4 */
 	u8 legacy_monitor_detect;
diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 36c542e..5f1d7ef 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -370,6 +370,7 @@ void intel_dvo_init(struct drm_device *dev)
 		const struct intel_dvo_device *dvo = &intel_dvo_devices[i];
 		struct i2c_adapter *i2c;
 		int gpio;
+		bool dvoinit;
 
 		/* Allow the I2C driver info to specify the GPIO to be used in
 		 * special cases, but otherwise default to what's defined
@@ -389,7 +390,17 @@ void intel_dvo_init(struct drm_device *dev)
 		i2c = intel_gmbus_get_adapter(dev_priv, gpio);
 
 		intel_dvo->dev = *dvo;
-		if (!dvo->dev_ops->init(&intel_dvo->dev, i2c))
+
+		/* GMBUS NAK handling seems to be unstable, hence let the
+		 * transmitter detection run in bit banging mode for now.
+		 */
+		intel_gmbus_force_bit(i2c, true);
+
+		dvoinit = dvo->dev_ops->init(&intel_dvo->dev, i2c);
+
+		intel_gmbus_force_bit(i2c, false);
+
+		if (!dvoinit)
 			continue;
 
 		intel_encoder->type = INTEL_OUTPUT_DVO;
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 0c52448..c78c988 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -796,6 +796,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "X7SPA-H"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Fujitsu Esprimo Q900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO Q900"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index c23c9ea..e782b76 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3712,6 +3712,7 @@ static void cpt_init_clock_gating(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int pipe;
+	uint32_t val;
 
 	/*
 	 * On Ibex Peak and Cougar Point, we need to disable clock
@@ -3722,8 +3723,12 @@ static void cpt_init_clock_gating(struct drm_device *dev)
 	I915_WRITE(SOUTH_CHICKEN2, I915_READ(SOUTH_CHICKEN2) |
 		   DPLS_EDP_PPS_FIX_DIS);
 	/* Without this, mode sets may fail silently on FDI */
-	for_each_pipe(pipe)
-		I915_WRITE(TRANS_CHICKEN2(pipe), TRANS_AUTOTRAIN_GEN_STALL_DIS);
+	for_each_pipe(pipe) {
+		val = TRANS_AUTOTRAIN_GEN_STALL_DIS;
+		if (dev_priv->fdi_rx_polarity_inverted)
+			val |= TRANS_CHICKEN2_FDI_POLARITY_REVERSED;
+		I915_WRITE(TRANS_CHICKEN2(pipe), val);
+	}
 }
 
 void intel_init_clock_gating(struct drm_device *dev)
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 6f13b35..aa2fa4d 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -116,6 +116,8 @@ struct mga_fbdev {
 	void *sysram;
 	int size;
 	struct ttm_bo_kmap_obj mapping;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 struct mga_crtc {
diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 880d336..f5f0366 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -29,16 +29,52 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 	int bpp = (mfbdev->mfb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = mfbdev->mfb.obj;
 	bo = gem_to_mga_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = mgag200_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
+
+		store_for_later = true;
+	}
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+	spin_lock_irqsave(&mfbdev->dirty_lock, flags);
+
+	if (mfbdev->y1 < y)
+		y = mfbdev->y1;
+	if (mfbdev->y2 > y2)
+		y2 = mfbdev->y2;
+	if (mfbdev->x1 < x)
+		x = mfbdev->x1;
+	if (mfbdev->x2 > x2)
+		x2 = mfbdev->x2;
+
+	if (store_for_later) {
+		mfbdev->x1 = x;
+		mfbdev->x2 = x2;
+		mfbdev->y1 = y;
+		mfbdev->y2 = y2;
+		spin_unlock_irqrestore(&mfbdev->dirty_lock, flags);
 		return;
 	}
 
+	mfbdev->x1 = mfbdev->y1 = INT_MAX;
+	mfbdev->x2 = mfbdev->y2 = 0;
+	spin_unlock_irqrestore(&mfbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -48,10 +84,10 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 		}
 		unmap = true;
 	}
-	for (i = y; i < y + height; i++) {
+	for (i = y; i <= y2; i++) {
 		/* assume equal stride for now */
 		src_offset = dst_offset = i * mfbdev->mfb.base.pitches[0] + (x * bpp);
-		memcpy_toio(bo->kmap.virtual + src_offset, mfbdev->sysram + src_offset, width * bpp);
+		memcpy_toio(bo->kmap.virtual + src_offset, mfbdev->sysram + src_offset, (x2 - x + 1) * bpp);
 
 	}
 	if (unmap)
@@ -270,6 +306,7 @@ int mgag200_fbdev_init(struct mga_device *mdev)
 
 	mdev->mfbdev = mfbdev;
 	mfbdev->helper.funcs = &mga_fb_helper_funcs;
+	spin_lock_init(&mfbdev->dirty_lock);
 
 	ret = drm_fb_helper_init(mdev->dev, &mfbdev->helper,
 				 mdev->num_crtc, MGAG200FB_CONN_LIMIT);
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index b223dcb..a707394 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -315,8 +315,8 @@ int mgag200_bo_reserve(struct mgag200_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
-			DRM_ERROR("reserve failed %p\n", bo);
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
+			DRM_ERROR("reserve failed %p %d\n", bo, ret);
 		return ret;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 5ce9bf5..43672b6 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1389,10 +1389,10 @@ int atom_allocate_fb_scratch(struct atom_context *ctx)
 		firmware_usage = (struct _ATOM_VRAM_USAGE_BY_FIRMWARE *)(ctx->bios + data_offset);
 
 		DRM_DEBUG("atom firmware requested %08x %dkb\n",
-			  firmware_usage->asFirmwareVramReserveInfo[0].ulStartAddrUsedByFirmware,
-			  firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb);
+			  le32_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].ulStartAddrUsedByFirmware),
+			  le16_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb));
 
-		usage_bytes = firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb * 1024;
+		usage_bytes = le16_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb) * 1024;
 	}
 	ctx->scratch_size_bytes = 0;
 	if (usage_bytes == 0)
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 2817101..3a3d3f8 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -569,6 +569,9 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE61(rdev))
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		/* use frac fb div on RS780/RS880 */
+		if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
 		pll->flags |= RADEON_PLL_LEGACY;
 
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 5528fea..5c23991 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -109,6 +109,27 @@ void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
 	}
 }
 
+static bool dce4_is_in_vblank(struct radeon_device *rdev, int crtc)
+{
+	if (RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK)
+		return true;
+	else
+		return false;
+}
+
+static bool dce4_is_counter_moving(struct radeon_device *rdev, int crtc)
+{
+	u32 pos1, pos2;
+
+	pos1 = RREG32(EVERGREEN_CRTC_STATUS_POSITION + crtc_offsets[crtc]);
+	pos2 = RREG32(EVERGREEN_CRTC_STATUS_POSITION + crtc_offsets[crtc]);
+
+	if (pos1 != pos2)
+		return true;
+	else
+		return false;
+}
+
 /**
  * dce4_wait_for_vblank - vblank wait asic callback.
  *
@@ -119,21 +140,28 @@ void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
  */
 void dce4_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
-	int i;
+	unsigned i = 0;
 
 	if (crtc >= rdev->num_crtc)
 		return;
 
-	if (RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[crtc]) & EVERGREEN_CRTC_MASTER_EN) {
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (!(RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK))
+	if (!(RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[crtc]) & EVERGREEN_CRTC_MASTER_EN))
+		return;
+
+	/* depending on when we hit vblank, we may be close to active; if so,
+	 * wait for another frame.
+	 */
+	while (dce4_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!dce4_is_counter_moving(rdev, crtc))
 				break;
-			udelay(1);
 		}
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (RREG32(EVERGREEN_CRTC_STATUS + crtc_offsets[crtc]) & EVERGREEN_CRTC_V_BLANK)
+	}
+
+	while (!dce4_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!dce4_is_counter_moving(rdev, crtc))
 				break;
-			udelay(1);
 		}
 	}
 }
@@ -541,6 +569,16 @@ void evergreen_hpd_init(struct radeon_device *rdev)
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		struct radeon_connector *radeon_connector = to_radeon_connector(connector);
+
+		if (connector->connector_type == DRM_MODE_CONNECTOR_eDP ||
+		    connector->connector_type == DRM_MODE_CONNECTOR_LVDS) {
+			/* don't try to enable hpd on eDP or LVDS avoid breaking the
+			 * aux dp channel on imac and help (but not completely fix)
+			 * https://bugzilla.redhat.com/show_bug.cgi?id=726143
+			 * also avoid interrupt storms during dpms.
+			 */
+			continue;
+		}
 		switch (radeon_connector->hpd.hpd) {
 		case RADEON_HPD_1:
 			WREG32(DC_HPD1_CONTROL, tmp);
@@ -1258,6 +1296,7 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_BLANK_DATA_EN)) {
 					radeon_wait_for_vblank(rdev, i);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
 				}
@@ -1265,8 +1304,10 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			}
 			/* wait for the next frame */
@@ -1276,6 +1317,15 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 					break;
 				udelay(1);
 			}
+
+			/* XXX this is a hack to avoid strange behavior with EFI on certain systems */
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
+			tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
+			tmp &= ~EVERGREEN_CRTC_MASTER_EN;
+			WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
+			save->crtc_enabled[i] = false;
+			/* ***** */
 		} else {
 			save->crtc_enabled[i] = false;
 		}
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index eecf30f..62ff39f 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -471,7 +471,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		    (rdev->pdev->device == 0x990F) ||
 		    (rdev->pdev->device == 0x9910) ||
 		    (rdev->pdev->device == 0x9917) ||
-		    (rdev->pdev->device == 0x9999)) {
+		    (rdev->pdev->device == 0x9999) ||
+		    (rdev->pdev->device == 0x999C)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9903) ||
@@ -480,7 +481,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x990D) ||
 			   (rdev->pdev->device == 0x990E) ||
 			   (rdev->pdev->device == 0x9913) ||
-			   (rdev->pdev->device == 0x9918)) {
+			   (rdev->pdev->device == 0x9918) ||
+			   (rdev->pdev->device == 0x999D)) {
 			rdev->config.cayman.max_simds_per_se = 4;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9919) ||
@@ -619,6 +621,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	if (ASIC_IS_DCE6(rdev))
+		WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	tmp = gb_addr_config & NUM_PIPES_MASK;
diff --git a/drivers/gpu/drm/radeon/nid.h b/drivers/gpu/drm/radeon/nid.h
index 870db34..e17d4dd 100644
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -45,6 +45,10 @@
 #define ARUBA_GB_ADDR_CONFIG_GOLDEN        0x12010001
 
 #define DMIF_ADDR_CONFIG  				0xBD4
+
+/* DCE6 only */
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_GFX_CNTL				        0x0E44
 #define		RINGID(x)					(((x) & 0x3) << 0)
 #define		VMID(x)						(((x) & 0x7) << 0)
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 8d7e33a..b08b5b9 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -70,6 +70,38 @@ MODULE_FIRMWARE(FIRMWARE_R520);
  * and others in some cases.
  */
 
+static bool r100_is_in_vblank(struct radeon_device *rdev, int crtc)
+{
+	if (crtc == 0) {
+		if (RREG32(RADEON_CRTC_STATUS) & RADEON_CRTC_VBLANK_CUR)
+			return true;
+		else
+			return false;
+	} else {
+		if (RREG32(RADEON_CRTC2_STATUS) & RADEON_CRTC2_VBLANK_CUR)
+			return true;
+		else
+			return false;
+	}
+}
+
+static bool r100_is_counter_moving(struct radeon_device *rdev, int crtc)
+{
+	u32 vline1, vline2;
+
+	if (crtc == 0) {
+		vline1 = (RREG32(RADEON_CRTC_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+		vline2 = (RREG32(RADEON_CRTC_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+	} else {
+		vline1 = (RREG32(RADEON_CRTC2_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+		vline2 = (RREG32(RADEON_CRTC2_VLINE_CRNT_VLINE) >> 16) & RADEON_CRTC_V_TOTAL;
+	}
+	if (vline1 != vline2)
+		return true;
+	else
+		return false;
+}
+
 /**
  * r100_wait_for_vblank - vblank wait asic callback.
  *
@@ -81,33 +113,30 @@ MODULE_FIRMWARE(FIRMWARE_R520);
 void r100_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
-	int i;
+	unsigned i = 0;
 
 	if (radeon_crtc->crtc_id == 0) {
-		if (RREG32(RADEON_CRTC_GEN_CNTL) & RADEON_CRTC_EN) {
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (!(RREG32(RADEON_CRTC_STATUS) & RADEON_CRTC_VBLANK_CUR))
-					break;
-				udelay(1);
-			}
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (RREG32(RADEON_CRTC_STATUS) & RADEON_CRTC_VBLANK_CUR)
-					break;
-				udelay(1);
-			}
-		}
+		if (!(RREG32(RADEON_CRTC_GEN_CNTL) & RADEON_CRTC_EN))
+			return;
 	} else {
-		if (RREG32(RADEON_CRTC2_GEN_CNTL) & RADEON_CRTC2_EN) {
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (!(RREG32(RADEON_CRTC2_STATUS) & RADEON_CRTC2_VBLANK_CUR))
-					break;
-				udelay(1);
-			}
-			for (i = 0; i < rdev->usec_timeout; i++) {
-				if (RREG32(RADEON_CRTC2_STATUS) & RADEON_CRTC2_VBLANK_CUR)
-					break;
-				udelay(1);
-			}
+		if (!(RREG32(RADEON_CRTC2_GEN_CNTL) & RADEON_CRTC2_EN))
+			return;
+	}
+
+	/* depending on when we hit vblank, we may be close to active; if so,
+	 * wait for another frame.
+	 */
+	while (r100_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!r100_is_counter_moving(rdev, crtc))
+				break;
+		}
+	}
+
+	while (!r100_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!r100_is_counter_moving(rdev, crtc))
+				break;
 		}
 	}
 }
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index e3558c3..ecf263f 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -489,7 +489,7 @@ void r600_hdmi_enable(struct drm_encoder *encoder)
 	offset = dig->afmt->offset;
 
 	/* Older chipsets require setting HDMI and routing manually */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		hdmi = HDMI0_ERROR_ACK | HDMI0_ENABLE;
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
@@ -558,7 +558,7 @@ void r600_hdmi_disable(struct drm_encoder *encoder)
 	radeon_irq_kms_disable_afmt(rdev, dig->afmt->id);
 
 	/* Older chipsets not handled by AtomBIOS */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, 0,
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index d67d4f3..3e3b3df 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2023,6 +2023,8 @@ static int radeon_atombios_parse_power_table_1_3(struct radeon_device *rdev)
 	num_modes = power_info->info.ucNumOfPowerModeEntries;
 	if (num_modes > ATOM_MAX_NUMBEROF_POWER_BLOCK)
 		num_modes = ATOM_MAX_NUMBEROF_POWER_BLOCK;
+	if (num_modes == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) * num_modes, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
@@ -2421,6 +2423,8 @@ static int radeon_atombios_parse_power_table_4_5(struct radeon_device *rdev)
 	power_info = (union power_info *)(mode_info->atom_context->bios + data_offset);
 
 	radeon_atombios_add_pplib_thermal_controller(rdev, &power_info->pplib.sThermalController);
+	if (power_info->pplib.ucNumStates == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       power_info->pplib.ucNumStates, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2503,6 +2507,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 	int index = GetIndexIntoMasterTable(DATA, PowerPlayInfo);
         u16 data_offset;
 	u8 frev, crev;
+	u8 *power_state_offset;
 
 	if (!atom_parse_data_header(mode_info->atom_context, index, NULL,
 				   &frev, &crev, &data_offset))
@@ -2519,15 +2524,17 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 	non_clock_info_array = (struct _NonClockInfoArray *)
 		(mode_info->atom_context->bios + data_offset +
 		 le16_to_cpu(power_info->pplib.usNonClockInfoArrayOffset));
+	if (state_array->ucNumEntries == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       state_array->ucNumEntries, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
+	power_state_offset = (u8 *)state_array->states;
 	for (i = 0; i < state_array->ucNumEntries; i++) {
 		mode_index = 0;
-		power_state = (union pplib_power_state *)&state_array->states[i];
-		/* XXX this might be an inagua bug... */
-		non_clock_array_index = i; /* power_state->v2.nonClockInfoIndex */
+		power_state = (union pplib_power_state *)power_state_offset;
+		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		rdev->pm.power_state[i].clock_info = kzalloc(sizeof(struct radeon_pm_clock_info) *
@@ -2539,9 +2546,6 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 		if (power_state->v2.ucNumDPMLevels) {
 			for (j = 0; j < power_state->v2.ucNumDPMLevels; j++) {
 				clock_array_index = power_state->v2.clockInfoIndex[j];
-				/* XXX this might be an inagua bug... */
-				if (clock_array_index >= clock_info_array->ucNumEntries)
-					continue;
 				clock_info = (union pplib_clock_info *)
 					&clock_info_array->clockInfo[clock_array_index * clock_info_array->ucEntrySize];
 				valid = radeon_atombios_parse_pplib_clock_info(rdev,
@@ -2563,6 +2567,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 								   non_clock_info);
 			state_index++;
 		}
+		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
 	}
 	/* if multiple clock modes, mark the lowest as no display */
 	for (i = 0; i < state_index; i++) {
@@ -2609,7 +2614,9 @@ void radeon_atombios_get_power_modes(struct radeon_device *rdev)
 		default:
 			break;
 		}
-	} else {
+	}
+
+	if (state_index == 0) {
 		rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state), GFP_KERNEL);
 		if (rdev->pm.power_state) {
 			rdev->pm.power_state[0].clock_info =
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 414b4ac..e32f4c2 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -51,8 +51,12 @@ int radeon_driver_unload_kms(struct drm_device *dev)
 
 	if (rdev == NULL)
 		return 0;
+	if (rdev->rmmio == NULL)
+		goto done_free;
 	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
+
+done_free:
 	kfree(rdev);
 	dev->dev_private = NULL;
 	return 0;
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 395d7e0..8c89481 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -856,7 +856,11 @@ static int radeon_debugfs_pm_info(struct seq_file *m, void *data)
 	struct radeon_device *rdev = dev->dev_private;
 
 	seq_printf(m, "default engine clock: %u0 kHz\n", rdev->pm.default_sclk);
-	seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
+	/* radeon_get_engine_clock is not reliable on APUs so just print the current clock */
+	if ((rdev->family >= CHIP_PALM) && (rdev->flags & RADEON_IS_IGP))
+		seq_printf(m, "current engine clock: %u0 kHz\n", rdev->pm.current_sclk);
+	else
+		seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
 	seq_printf(m, "default memory clock: %u0 kHz\n", rdev->pm.default_mclk);
 	if (rdev->asic->pm.get_memory_clock)
 		seq_printf(m, "current memory clock: %u0 kHz\n", radeon_get_memory_clock(rdev));
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 5301b3d..78aa835 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -46,21 +46,61 @@
 void rs600_gpu_init(struct radeon_device *rdev);
 int rs600_mc_wait_for_idle(struct radeon_device *rdev);
 
+static bool avivo_is_in_vblank(struct radeon_device *rdev, int crtc)
+{
+	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
+
+	if (RREG32(AVIVO_D1CRTC_STATUS + radeon_crtc->crtc_offset) & AVIVO_D1CRTC_V_BLANK)
+		return true;
+	else
+		return false;
+}
+
+static bool avivo_is_counter_moving(struct radeon_device *rdev, int crtc)
+{
+	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
+	u32 pos1, pos2;
+
+	pos1 = RREG32(AVIVO_D1CRTC_STATUS_POSITION + radeon_crtc->crtc_offset);
+	pos2 = RREG32(AVIVO_D1CRTC_STATUS_POSITION + radeon_crtc->crtc_offset);
+
+	if (pos1 != pos2)
+		return true;
+	else
+		return false;
+}
+
+/**
+ * avivo_wait_for_vblank - vblank wait asic callback.
+ *
+ * @rdev: radeon_device pointer
+ * @crtc: crtc to wait for vblank on
+ *
+ * Wait for vblank on the requested crtc (r5xx-r7xx).
+ */
 void avivo_wait_for_vblank(struct radeon_device *rdev, int crtc)
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc];
-	int i;
+	unsigned i = 0;
+
+	if (!(RREG32(AVIVO_D1CRTC_CONTROL + radeon_crtc->crtc_offset) & AVIVO_CRTC_EN))
+		return;
 
-	if (RREG32(AVIVO_D1CRTC_CONTROL + radeon_crtc->crtc_offset) & AVIVO_CRTC_EN) {
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (!(RREG32(AVIVO_D1CRTC_STATUS + radeon_crtc->crtc_offset) & AVIVO_D1CRTC_V_BLANK))
+	/* depending on when we hit vblank, we may be close to active; if so,
+	 * wait for another frame.
+	 */
+	while (avivo_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!avivo_is_counter_moving(rdev, crtc))
 				break;
 			udelay(1);
 		}
-		for (i = 0; i < rdev->usec_timeout; i++) {
-			if (RREG32(AVIVO_D1CRTC_STATUS + radeon_crtc->crtc_offset) & AVIVO_D1CRTC_V_BLANK)
+	}
+
+	while (!avivo_is_in_vblank(rdev, crtc)) {
+		if (i++ % 100 == 0) {
+			if (!avivo_is_counter_moving(rdev, crtc))
 				break;
-			udelay(1);
 		}
 	}
 }
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 6ab4a90..f2b256c 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1374,7 +1374,7 @@ static void si_select_se_sh(struct radeon_device *rdev,
 	u32 data = INSTANCE_BROADCAST_WRITES;
 
 	if ((se_num == 0xffffffff) && (sh_num == 0xffffffff))
-		data = SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
+		data |= SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	else if (se_num == 0xffffffff)
 		data |= SE_BROADCAST_WRITES | SH_INDEX(sh_num);
 	else if (sh_num == 0xffffffff)
@@ -1659,6 +1659,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	si_tiling_mode_table_init(rdev);
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 6f0083a..778b7de 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -60,6 +60,8 @@
 
 #define DMIF_ADDR_CONFIG  				0xBD4
 
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_STATUS				        0xE50
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0xe80
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 641d0e5..15d20de 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -312,10 +312,8 @@ static void xiic_fill_tx_fifo(struct xiic_i2c *i2c)
 			/* last message in transfer -> STOP */
 			data |= XIIC_TX_DYN_STOP_MASK;
 			dev_dbg(i2c->adap.dev.parent, "%s TX STOP\n", __func__);
-
-			xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
-		} else
-			xiic_setreg8(i2c, XIIC_DTR_REG_OFFSET, data);
+		}
+		xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
 	}
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7b000f..833957e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1576,8 +1576,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 					     sector, count, 1) == 0)
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset == 0)
-		rdev->badblocks.shift = -1;
+	} else if (sb->bblog_offset != 0)
+		rdev->badblocks.shift = 0;
 
 	if (!refdev) {
 		ret = 1;
@@ -3224,7 +3224,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	 * be used - I wonder if that matters
 	 */
 	rdev->badblocks.count = 0;
-	rdev->badblocks.shift = 0;
+	rdev->badblocks.shift = -1; /* disabled until explicitly enabled */
 	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	seqlock_init(&rdev->badblocks.lock);
 	if (rdev->badblocks.page == NULL)
@@ -3296,9 +3296,6 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 			goto abort_free;
 		}
 	}
-	if (super_format == -1)
-		/* hot-add for 0.90, or non-persistent: so no badblocks */
-		rdev->badblocks.shift = -1;
 
 	return rdev;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7077dcf..36c6003 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -976,7 +976,12 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
-		generic_make_request(bio);
+		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			/* Just ignore it */
+			bio_endio(bio, 0);
+		else
+			generic_make_request(bio);
 		bio = next;
 	}
 	kfree(plug);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c52d893..bec9db8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -912,6 +912,12 @@ static void flush_pending_writes(struct r10conf *conf)
 			struct bio *next = bio->bi_next;
 			bio->bi_next = NULL;
 			generic_make_request(bio);
+			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+				     !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+				/* Just ignore it */
+				bio_endio(bio, 0);
+			else
+				generic_make_request(bio);
 			bio = next;
 		}
 	} else
diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index ea8b947..7e41d54 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -36,6 +36,7 @@ struct adp5520_chip {
 	struct blocking_notifier_head notifier_list;
 	int irq;
 	unsigned long id;
+	uint8_t mode;
 };
 
 static int __adp5520_read(struct i2c_client *client,
@@ -326,7 +327,10 @@ static int adp5520_suspend(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_read(chip->dev, ADP5520_MODE_STATUS, &chip->mode);
+	/* All other bits are W1C */
+	chip->mode &= ADP5520_BL_EN | ADP5520_DIM_EN | ADP5520_nSTNBY;
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, 0);
 	return 0;
 }
 
@@ -335,7 +339,7 @@ static int adp5520_resume(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, chip->mode);
 	return 0;
 }
 #endif
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 396b258..246750e 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -368,13 +368,13 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
 	card->ext_csd.raw_trim_mult =
 		ext_csd[EXT_CSD_TRIM_MULT];
+	card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 	if (card->ext_csd.rev >= 4) {
 		/*
 		 * Enhanced area feature support -- check whether the eMMC
 		 * card has the Enhanced area enabled.  If so, export enhanced
 		 * area offset and size to user by adding sysfs interface.
 		 */
-		card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
 		    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
 			hc_erase_grp_sz =
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index aa131b3..1449469 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -300,16 +300,6 @@ config MMC_ATMELMCI
 
 endchoice
 
-config MMC_ATMELMCI_DMA
-	bool "Atmel MCI DMA support"
-	depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENGINE
-	help
-	  Say Y here to have the Atmel MCI driver use a DMA engine to
-	  do data transfers and thus increase the throughput and
-	  reduce the CPU utilization.
-
-	  If unsure, say N.
-
 config MMC_MSM
 	tristate "Qualcomm SDCC Controller Support"
 	depends on MMC && ARCH_MSM
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index a53c7c4..8e8afe4 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -175,6 +175,7 @@ struct atmel_mci {
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
+	unsigned int		sg_len;
 	unsigned int		pio_offset;
 	unsigned int		*buffer;
 	unsigned int		buf_size;
@@ -825,6 +826,7 @@ static u32 atmci_prepare_data(struct atmel_mci *host, struct mmc_data *data)
 	data->error = -EINPROGRESS;
 
 	host->sg = data->sg;
+	host->sg_len = data->sg_len;
 	host->data = data;
 	host->data_chan = NULL;
 
@@ -1757,7 +1759,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 			if (offset == sg->length) {
 				flush_dcache_page(sg_page(sg));
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1770,7 +1773,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 
 			flush_dcache_page(sg_page(sg));
 			host->sg = sg = sg_next(sg);
-			if (!sg)
+			host->sg_len--;
+			if (!sg || !host->sg_len)
 				goto done;
 
 			offset = 4 - remaining;
@@ -1821,7 +1825,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += 4;
 			if (offset == sg->length) {
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1835,7 +1840,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += remaining;
 
 			host->sg = sg = sg_next(sg);
-			if (!sg) {
+			host->sg_len--;
+			if (!sg || !host->sg_len) {
 				atmci_writel(host, ATMCI_TDR, value);
 				goto done;
 			}
@@ -2407,10 +2413,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	atmci_readl(host, ATMCI_SR);
 	clk_disable(host->mck);
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
-#endif
 
 	free_irq(platform_get_irq(pdev, 0), host);
 	iounmap(host->regs);
diff --git a/drivers/net/ethernet/freescale/gianfar_ptp.c b/drivers/net/ethernet/freescale/gianfar_ptp.c
index 0daa66b..d81c7af 100644
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -127,7 +127,6 @@ struct gianfar_ptp_registers {
 
 #define DRIVER		"gianfar_ptp"
 #define DEFAULT_CKSEL	1
-#define N_ALARM		1 /* first alarm is used internally to reset fipers */
 #define N_EXT_TS	2
 #define REG_SIZE	sizeof(struct gianfar_ptp_registers)
 
@@ -410,7 +409,7 @@ static struct ptp_clock_info ptp_gianfar_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "gianfar clock",
 	.max_adj	= 512000,
-	.n_alarm	= N_ALARM,
+	.n_alarm	= 0,
 	.n_ext_ts	= N_EXT_TS,
 	.n_per_out	= 0,
 	.pps		= 1,
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index b68d28a..33a1760 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1327,7 +1327,7 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 static int __devinit ibmveth_probe(struct vio_dev *dev,
 				   const struct vio_device_id *id)
 {
-	int rc, i;
+	int rc, i, mac_len;
 	struct net_device *netdev;
 	struct ibmveth_adapter *adapter;
 	unsigned char *mac_addr_p;
@@ -1337,11 +1337,19 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 		dev->unit_address);
 
 	mac_addr_p = (unsigned char *)vio_get_attribute(dev, VETH_MAC_ADDR,
-							NULL);
+							&mac_len);
 	if (!mac_addr_p) {
 		dev_err(&dev->dev, "Can't find VETH_MAC_ADDR attribute\n");
 		return -EINVAL;
 	}
+	/* Workaround for old/broken pHyp */
+	if (mac_len == 8)
+		mac_addr_p += 2;
+	else if (mac_len != 6) {
+		dev_err(&dev->dev, "VETH_MAC_ADDR attribute wrong len %d\n",
+			mac_len);
+		return -EINVAL;
+	}
 
 	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
 						VETH_MCAST_FILTER_SIZE, NULL);
@@ -1366,17 +1374,6 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
-	/*
-	 * Some older boxes running PHYP non-natively have an OF that returns
-	 * a 8-byte local-mac-address field (and the first 2 bytes have to be
-	 * ignored) while newer boxes' OF return a 6-byte field. Note that
-	 * IEEE 1275 specifies that local-mac-address must be a 6-byte field.
-	 * The RPA doc specifies that the first byte must be 10b, so we'll
-	 * just look for it to solve this 8 vs. 6 byte field issue
-	 */
-	if ((*mac_addr_p & 0x3) != 0x02)
-		mac_addr_p += 2;
-
 	adapter->mac_addr = 0;
 	memcpy(&adapter->mac_addr, mac_addr_p, 6);
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a46e75e..d191a63 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3951,6 +3951,7 @@ static int e1000_open(struct net_device *netdev)
 	netif_start_queue(netdev);
 
 	adapter->idle_check = true;
+	hw->mac.get_link_status = true;
 	pm_runtime_put(&pdev->dev);
 
 	/* fire a link status change interrupt to start the watchdog */
@@ -5454,8 +5455,7 @@ release:
 	return retval;
 }
 
-static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
-			    bool runtime)
+static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -5479,10 +5479,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	}
 	e1000e_reset_interrupt_capability(adapter);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
 	status = er32(STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -5538,13 +5534,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
 		ew32(WUFC, 0);
 	}
 
-	*enable_wake = !!wufc;
-
-	/* make sure adapter isn't asleep if manageability is enabled */
-	if ((adapter->flags & FLAG_MNG_PT_ENABLED) ||
-	    (hw->mac.ops.check_mng_mode(hw)))
-		*enable_wake = true;
-
 	if (adapter->hw.phy.type == e1000_phy_igp_3)
 		e1000e_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 
@@ -5556,26 +5545,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
 
 	pci_disable_device(pdev);
 
-	return 0;
-}
-
-static void e1000_power_off(struct pci_dev *pdev, bool sleep, bool wake)
-{
-	if (sleep && wake) {
-		pci_prepare_to_sleep(pdev);
-		return;
-	}
-
-	pci_wake_from_d3(pdev, wake);
-	pci_set_power_state(pdev, PCI_D3hot);
-}
-
-static void e1000_complete_shutdown(struct pci_dev *pdev, bool sleep,
-                                    bool wake)
-{
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct e1000_adapter *adapter = netdev_priv(netdev);
-
 	/*
 	 * The pci-e switch on some quad port adapters will report a
 	 * correctable error when the MAC transitions from D0 to D3.  To
@@ -5591,12 +5560,13 @@ static void e1000_complete_shutdown(struct pci_dev *pdev, bool sleep,
 		pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL,
 		                      (devctl & ~PCI_EXP_DEVCTL_CERE));
 
-		e1000_power_off(pdev, sleep, wake);
+		pci_save_state(pdev);
+		pci_prepare_to_sleep(pdev);
 
 		pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL, devctl);
-	} else {
-		e1000_power_off(pdev, sleep, wake);
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_PCIEASPM
@@ -5658,9 +5628,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	if (aspm_disable_flag)
 		e1000e_disable_aspm(pdev, aspm_disable_flag);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_save_state(pdev);
+	pci_set_master(pdev);
 
 	e1000e_set_interrupt_capability(adapter);
 	if (netif_running(netdev)) {
@@ -5727,14 +5695,8 @@ static int __e1000_resume(struct pci_dev *pdev)
 static int e1000_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int retval;
-	bool wake;
-
-	retval = __e1000_shutdown(pdev, &wake, false);
-	if (!retval)
-		e1000_complete_shutdown(pdev, true, wake);
 
-	return retval;
+	return __e1000_shutdown(pdev, false);
 }
 
 static int e1000_resume(struct device *dev)
@@ -5757,13 +5719,10 @@ static int e1000_runtime_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	if (e1000e_pm_ready(adapter)) {
-		bool wake;
-
-		__e1000_shutdown(pdev, &wake, true);
-	}
+	if (!e1000e_pm_ready(adapter))
+		return 0;
 
-	return 0;
+	return __e1000_shutdown(pdev, true);
 }
 
 static int e1000_idle(struct device *dev)
@@ -5801,12 +5760,7 @@ static int e1000_runtime_resume(struct device *dev)
 
 static void e1000_shutdown(struct pci_dev *pdev)
 {
-	bool wake = false;
-
-	__e1000_shutdown(pdev, &wake, false);
-
-	if (system_state == SYSTEM_POWER_OFF)
-		e1000_complete_shutdown(pdev, false, wake);
+	__e1000_shutdown(pdev, false);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -5924,9 +5878,9 @@ static pci_ers_result_t e1000_io_slot_reset(struct pci_dev *pdev)
 			"Cannot re-enable PCI device after reset.\n");
 		result = PCI_ERS_RESULT_DISCONNECT;
 	} else {
-		pci_set_master(pdev);
 		pdev->state_saved = true;
 		pci_restore_state(pdev);
+		pci_set_master(pdev);
 
 		pci_enable_wake(pdev, PCI_D3hot, 0);
 		pci_enable_wake(pdev, PCI_D3cold, 0);
@@ -6363,7 +6317,11 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
 	/* initialize the wol settings based on the eeprom settings */
 	adapter->wol = adapter->eeprom_wol;
-	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
+	/* make sure adapter isn't asleep if manageability is enabled */
+	if (adapter->wol || (adapter->flags & FLAG_MNG_PT_ENABLED) ||
+	    (hw->mac.ops.check_mng_mode(hw)))
+		device_wakeup_enable(&pdev->dev);
 
 	/* save off EEPROM version number */
 	e1000_read_nvm(&adapter->hw, 5, 1, &adapter->eeprom_vers);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1fff36d..926f0d0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2283,6 +2283,16 @@ static irqreturn_t ixgbe_msix_other(int irq, void *data)
 	 * with the write to EICR.
 	 */
 	eicr = IXGBE_READ_REG(hw, IXGBE_EICS);
+
+	/* The lower 16bits of the EICR register are for the queue interrupts
+	 * which should be masked here in order to not accidently clear them if
+	 * the bits are high when ixgbe_msix_other is called. There is a race
+	 * condition otherwise which results in possible performance loss
+	 * especially if the ixgbe_msix_other interrupt is triggering
+	 * consistently (as it would when PPS is turned on for the X540 device)
+	 */
+	eicr &= 0xFFFF0000;
+
 	IXGBE_WRITE_REG(hw, IXGBE_EICR, eicr);
 
 	if (eicr & IXGBE_EICR_LSC)
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 886b52f..74ca124 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5806,6 +5806,14 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		goto err_stop_0;
 	}
 
+	/* 8168evl does not automatically pad to minimum length. */
+	if (unlikely(tp->mac_version == RTL_GIGA_MAC_VER_34 &&
+		     skb->len < ETH_ZLEN)) {
+		if (skb_padto(skb, ETH_ZLEN))
+			goto err_update_stats;
+		skb_put(skb, ETH_ZLEN - skb->len);
+	}
+
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
@@ -5877,6 +5885,7 @@ err_dma_1:
 	rtl8169_unmap_tx_skb(d, tp->tx_skb + entry, txd);
 err_dma_0:
 	dev_kfree_skb(skb);
+err_update_stats:
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index a47b306..b3f10cb 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2237,15 +2237,15 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
+	char *buf = NULL;
+	ssize_t ret;
 
-	ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		kfree(buf);
-	}
+	ret = iwl_dump_nic_event_log(priv, true, &buf, true);
+	if (ret < 0)
+		goto err;
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+err:
+	kfree(buf);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index b29b798..efe8a4f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -706,6 +706,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_addsta_cmd sta_cmd;
+	static const struct iwl_link_quality_cmd zero_lq = {};
 	struct iwl_link_quality_cmd lq;
 	int i;
 	bool found = false;
@@ -744,7 +745,9 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 				else
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
-				send_lq = true;
+
+				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
 			ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 13fbc4e..8f352b4 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1831,9 +1831,9 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
-
-		pci_release_regions(pdev);
 		pci_disable_device(pdev);
+		pci_release_region(pdev, 2);
+		pci_release_region(pdev, 0);
 		pci_set_drvdata(pdev, NULL);
 	}
 }
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1345bdd..6c85ba5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4148,7 +4148,9 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-		!rt2x00_rt(rt2x00dev, RT5392)) {
+	    !rt2x00_rt(rt2x00dev, RT5392)) {
+		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
+
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -4159,8 +4161,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 				      &rt2x00dev->cap_flags))
 				rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 		}
-		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-				  drv_data->txmixer_gain_24g);
+		if (drv_data->txmixer_gain_24g >= min_gain) {
+			rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+					  drv_data->txmixer_gain_24g);
+		}
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 	}
 
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 729e038..97d0f03d 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -685,6 +685,7 @@ static int pci_pm_suspend(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -831,6 +832,7 @@ static int pci_pm_freeze(struct device *dev)
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -919,6 +921,7 @@ static int pci_pm_poweroff(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -1037,6 +1040,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a0f8e8f..466b669 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -663,15 +663,11 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
 		error = platform_pci_set_power_state(dev, state);
 		if (!error)
 			pci_update_current_state(dev, state);
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	} else {
+	} else
 		error = -ENODEV;
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	}
+
+	if (error && !dev->pm_cap) /* Fall back to PCI_D0 */
+		dev->current_state = PCI_D0;
 
 	return error;
 }
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 4267789..6a4adf7 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -805,9 +805,8 @@ static int cmos_suspend(struct device *dev)
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(mask);
 
-		/* shut down hpet emulation - we don't need it for alarm */
-		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
@@ -872,6 +871,7 @@ static int cmos_resume(struct device *dev)
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
+			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 71ea923c..5cf9cc7 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -567,6 +567,8 @@ static void __init sclp_add_standby_memory(void)
 	add_memory_merged(0);
 }
 
+#define MEM_SCT_SIZE (1UL << SECTION_SIZE_BITS)
+
 static void __init insert_increment(u16 rn, int standby, int assigned)
 {
 	struct memory_increment *incr, *new_incr;
@@ -579,7 +581,7 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
 	new_incr->rn = rn;
 	new_incr->standby = standby;
 	if (!standby)
-		new_incr->usecount = 1;
+		new_incr->usecount = rzm > MEM_SCT_SIZE ? rzm/MEM_SCT_SIZE : 1;
 	last_rn = 0;
 	prev = &sclp_mem_list;
 	list_for_each_entry(incr, &sclp_mem_list, list) {
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5505ffc..c2e6fd4 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -617,6 +617,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	nonseekable_open(inode, filp);
 
+	/* We refuse fsnotify events on ptmx, since it's a shared resource */
+	filp->f_mode |= FMODE_NONOTIFY;
+
 	retval = tty_alloc_file(filp);
 	if (retval)
 		return retval;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a21dc8e..9d2c26c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1877,6 +1877,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
+	put_device(tty_dev);
+
 	if (console_suspend_enabled || !uart_console(uport))
 		uport->suspended = 1;
 
@@ -1942,9 +1944,11 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 			disable_irq_wake(uport->irq);
 			uport->irq_wake = 0;
 		}
+		put_device(tty_dev);
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
+	put_device(tty_dev);
 	uport->suspended = 0;
 
 	/*
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 95a37fa..67ea9cf 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -939,10 +939,10 @@ void start_tty(struct tty_struct *tty)
 
 EXPORT_SYMBOL(start_tty);
 
+/* We limit tty time update visibility to every 8 seconds or so. */
 static void tty_update_time(struct timespec *time)
 {
-	unsigned long sec = get_seconds();
-	sec -= sec % 60;
+	unsigned long sec = get_seconds() & ~7;
 	if ((long)(sec - time->tv_sec) > 0)
 		time->tv_sec = sec;
 }
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index d214448..d5172fa 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -439,6 +439,8 @@ static int _hardware_enqueue(struct ci13xxx_ep *mEp, struct ci13xxx_req *mReq)
 		mReq->ptr->page[i] =
 			(mReq->req.dma + i * CI13XXX_PAGE_SIZE) & ~TD_RESERVED_MASK;
 
+	wmb();
+
 	if (!list_empty(&mEp->qh.queue)) {
 		struct ci13xxx_req *mReqPrev;
 		int n = hw_ep_bit(mEp->num, mEp->dir);
@@ -539,6 +541,12 @@ __acquires(mEp->lock)
 		struct ci13xxx_req *mReq = \
 			list_entry(mEp->qh.queue.next,
 				   struct ci13xxx_req, queue);
+
+		if (mReq->zptr) {
+			dma_pool_free(mEp->td_pool, mReq->zptr, mReq->zdma);
+			mReq->zptr = NULL;
+		}
+
 		list_del_init(&mReq->queue);
 		mReq->req.status = -ESHUTDOWN;
 
diff --git a/drivers/usb/chipidea/udc.h b/drivers/usb/chipidea/udc.h
index 4ff2384d..d12e8b5 100644
--- a/drivers/usb/chipidea/udc.h
+++ b/drivers/usb/chipidea/udc.h
@@ -40,7 +40,7 @@ struct ci13xxx_td {
 #define TD_CURR_OFFSET        (0x0FFFUL <<  0)
 #define TD_FRAME_NUM          (0x07FFUL <<  0)
 #define TD_RESERVED_MASK      (0x0FFFUL <<  0)
-} __attribute__ ((packed));
+} __attribute__ ((packed, aligned(4)));
 
 /* DMA layout of queue heads */
 struct ci13xxx_qh {
@@ -57,7 +57,7 @@ struct ci13xxx_qh {
 	/* 9 */
 	u32 RESERVED;
 	struct usb_ctrlrequest   setup;
-} __attribute__ ((packed));
+} __attribute__ ((packed, aligned(4)));
 
 /**
  * struct ci13xxx_req - usb request representation
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 7f75343..570fb4a 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -738,6 +738,8 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
+		if ((index & ~USB_DIR_IN) == 0)
+			return 0;
 		ret = findintfep(ps->dev, index);
 		if (ret >= 0)
 			ret = checkintf(ps, ret);
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b05c686..e90ca68 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -684,9 +684,6 @@ static int ehci_setup(struct usb_hcd *hcd)
 	if (retval)
 		return retval;
 
-	if (ehci_is_TDI(ehci))
-		tdi_reset(ehci);
-
 	ehci_reset(ehci);
 
 	return 0;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index b9ade46..8848616 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2450,14 +2450,21 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * TD list.
 		 */
 		if (list_empty(&ep_ring->td_list)) {
-			xhci_warn(xhci, "WARN Event TRB for slot %d ep %d "
-					"with no TDs queued?\n",
-				  TRB_TO_SLOT_ID(le32_to_cpu(event->flags)),
-				  ep_index);
-			xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
-				 (le32_to_cpu(event->flags) &
-				  TRB_TYPE_BITMASK)>>10);
-			xhci_print_trb_offsets(xhci, (union xhci_trb *) event);
+			/*
+			 * A stopped endpoint may generate an extra completion
+			 * event if the device was suspended.  Don't print
+			 * warnings.
+			 */
+			if (!(trb_comp_code == COMP_STOP ||
+						trb_comp_code == COMP_STOP_INVAL)) {
+				xhci_warn(xhci, "WARN Event TRB for slot %d ep %d with no TDs queued?\n",
+						TRB_TO_SLOT_ID(le32_to_cpu(event->flags)),
+						ep_index);
+				xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
+						(le32_to_cpu(event->flags) &
+						 TRB_TYPE_BITMASK)>>10);
+				xhci_print_trb_offsets(xhci, (union xhci_trb *) event);
+			}
 			if (ep->skip) {
 				ep->skip = false;
 				xhci_dbg(xhci, "td_list is empty while skip "
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 0fc6e5f..ba6a5d6 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -63,6 +63,7 @@ static const struct usb_device_id appledisplay_table[] = {
 	{ APPLEDISPLAY_DEVICE(0x9219) },
 	{ APPLEDISPLAY_DEVICE(0x921c) },
 	{ APPLEDISPLAY_DEVICE(0x921d) },
+	{ APPLEDISPLAY_DEVICE(0x9236) },
 
 	/* Terminating entry */
 	{ }
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index caa52dd..5843cc8 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -195,6 +195,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
@@ -874,7 +875,9 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
 	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
+	{ USB_DEVICE(ST_VID, ST_STMCLT_2232_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ST_VID, ST_STMCLT_4232_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_RF_R106) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
@@ -1792,20 +1795,24 @@ static int ftdi_8u2232c_probe(struct usb_serial *serial)
 }
 
 /*
- * First and second port on STMCLiteadaptors is reserved for JTAG interface
- * and the forth port for pio
+ * First two ports on JTAG adaptors using an FT4232 such as STMicroelectronics's
+ * ST Micro Connect Lite are reserved for JTAG or other non-UART interfaces and
+ * can be accessed from userspace.
+ * The next two ports are enabled as UARTs by default, where port 2 is
+ * a conventional RS-232 UART.
  */
 static int ftdi_stmclite_probe(struct usb_serial *serial)
 {
 	struct usb_device *udev = serial->dev;
 	struct usb_interface *interface = serial->interface;
 
-	if (interface == udev->actconfig->interface[2])
-		return 0;
-
-	dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+	if (interface == udev->actconfig->interface[0] ||
+	    interface == udev->actconfig->interface[1]) {
+		dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+		return -ENODEV;
+	}
 
-	return -ENODEV;
+	return 0;
 }
 
 /*
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 4801983..5c84306 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -74,6 +74,7 @@
 #define FTDI_OPENDCC_THROTTLE_PID	0xBFDA
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 #define FTDI_OPENDCC_GBM_PID	0xBFDC
+#define FTDI_OPENDCC_GBM_BOOST_PID	0xBFDD
 
 /* NZR SEM 16+ USB (http://www.nzr.de) */
 #define FTDI_NZR_SEM_USB_PID	0xC1E0	/* NZR SEM-LOG16+ */
@@ -1143,7 +1144,8 @@
  * STMicroelectonics
  */
 #define ST_VID			0x0483
-#define ST_STMCLT1030_PID	0x3747 /* ST Micro Connect Lite STMCLT1030 */
+#define ST_STMCLT_2232_PID	0x3746
+#define ST_STMCLT_4232_PID	0x3747
 
 /*
  * Papouch products (http://www.papouch.com/)
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 56fed62..1689782 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -344,6 +344,7 @@ static void option_instat_callback(struct urb *urb);
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
+#define OLIVETTI_PRODUCT_OLICARD145		0xc003
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
@@ -1227,6 +1228,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
@@ -1296,6 +1298,12 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FPDC_1COM, 0x0a, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_FPDC_2COM, 0x0a, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d01, 0xff, 0x02, 0x01) },	/* D-Link DWM-156 (variant) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d01, 0xff, 0x00, 0x00) },	/* D-Link DWM-156 (variant) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d02, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d02, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x00, 0x00) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 5fe451d..c1f6751 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -248,14 +248,26 @@ static int cypress_probe(struct usb_interface *intf,
 {
 	struct us_data *us;
 	int result;
+	struct usb_device *device;
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - cypress_usb_ids) + cypress_unusual_dev_list);
 	if (result)
 		return result;
 
-	us->protocol_name = "Transparent SCSI with Cypress ATACB";
-	us->proto_handler = cypress_atacb_passthrough;
+	/* Among CY7C68300 chips, the A revision does not support Cypress ATACB
+	 * Filter out this revision from EEPROM default descriptor values
+	 */
+	device = interface_to_usbdev(intf);
+	if (device->descriptor.iManufacturer != 0x38 ||
+	    device->descriptor.iProduct != 0x4e ||
+	    device->descriptor.iSerialNumber != 0x64) {
+		us->protocol_name = "Transparent SCSI with Cypress ATACB";
+		us->proto_handler = cypress_atacb_passthrough;
+	} else {
+		us->protocol_name = "Transparent SCSI";
+		us->proto_handler = usb_stor_transparent_scsi_command;
+	}
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 842d000..c7ada0d 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -61,15 +61,6 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 		/* This is an autofs submount, we can't expire it */
 		if (autofs_type_indirect(sbi->type))
 			goto done;
-
-		/*
-		 * Otherwise it's an offset mount and we need to check
-		 * if we can umount its mount, if there is one.
-		 */
-		if (!d_mountpoint(path.dentry)) {
-			status = 0;
-			goto done;
-		}
 	}
 
 	/* Update the expiry counter if fs is busy */
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ae94117..105b265 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -36,16 +36,19 @@
  * compare two delayed tree backrefs with same bytenr and type
  */
 static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
-			  struct btrfs_delayed_tree_ref *ref1)
+			  struct btrfs_delayed_tree_ref *ref1, int type)
 {
-	if (ref1->root < ref2->root)
-		return -1;
-	if (ref1->root > ref2->root)
-		return 1;
-	if (ref1->parent < ref2->parent)
-		return -1;
-	if (ref1->parent > ref2->parent)
-		return 1;
+	if (type == BTRFS_TREE_BLOCK_REF_KEY) {
+		if (ref1->root < ref2->root)
+			return -1;
+		if (ref1->root > ref2->root)
+			return 1;
+	} else {
+		if (ref1->parent < ref2->parent)
+			return -1;
+		if (ref1->parent > ref2->parent)
+			return 1;
+	}
 	return 0;
 }
 
@@ -109,7 +112,8 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
 	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
-				      btrfs_delayed_node_to_tree_ref(ref1));
+				      btrfs_delayed_node_to_tree_ref(ref1),
+				      ref1->type);
 	} else if (ref1->type == BTRFS_EXTENT_DATA_REF_KEY ||
 		   ref1->type == BTRFS_SHARED_DATA_REF_KEY) {
 		return comp_data_refs(btrfs_delayed_node_to_data_ref(ref2),
diff --git a/fs/dcache.c b/fs/dcache.c
index 2488c47..0578ce2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1256,8 +1256,10 @@ void shrink_dcache_parent(struct dentry * parent)
 	LIST_HEAD(dispose);
 	int found;
 
-	while ((found = select_parent(parent, &dispose)) != 0)
+	while ((found = select_parent(parent, &dispose)) != 0) {
 		shrink_dentry_list(&dispose);
+		cond_resched();
+	}
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
diff --git a/fs/exec.c b/fs/exec.c
index fab2c6d..39b6a3c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -623,7 +623,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		 * when the old and new regions overlap clear from new_end.
 		 */
 		free_pgd_range(&tlb, new_end, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	} else {
 		/*
 		 * otherwise, clean from old_start; this is done to not touch
@@ -632,7 +632,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		 * for the others its just a little faster.
 		 */
 		free_pgd_range(&tlb, old_start, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	}
 	tlb_finish_mmu(&tlb, new_end, old_end);
 
@@ -905,11 +905,13 @@ static int de_thread(struct task_struct *tsk)
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
+			threadgroup_change_begin(tsk);
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			write_unlock_irq(&tasklist_lock);
+			threadgroup_change_end(tsk);
 			schedule();
 		}
 
@@ -965,6 +967,7 @@ static int de_thread(struct task_struct *tsk)
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
+		threadgroup_change_end(tsk);
 
 		release_task(leader);
 	}
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index c22f170..e38370b 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -84,4 +84,5 @@ config EXT4_DEBUG
 	  Enables run-time debugging support for the ext4 filesystem.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+	  with a command such as:
+		echo 1 > /sys/module/ext4/parameters/mballoc_debug
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 56d258c..1a27af3 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -170,16 +170,20 @@ static inline void ext4_journal_callback_add(handle_t *handle,
  * ext4_journal_callback_del: delete a registered callback
  * @handle: active journal transaction handle on which callback was registered
  * @jce: registered journal callback entry to unregister
+ * Return true if object was sucessfully removed
  */
-static inline void ext4_journal_callback_del(handle_t *handle,
+static inline bool ext4_journal_callback_try_del(handle_t *handle,
 					     struct ext4_journal_cb_entry *jce)
 {
+	bool deleted;
 	struct ext4_sb_info *sbi =
 			EXT4_SB(handle->h_transaction->t_journal->j_private);
 
 	spin_lock(&sbi->s_md_lock);
+	deleted = !list_empty(&jce->jce_list);
 	list_del_init(&jce->jce_list);
 	spin_unlock(&sbi->s_md_lock);
+	return deleted;
 }
 
 int
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 2a1dcea..3d28be5 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -253,8 +253,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
 		needs_barrier = true;
-	jbd2_log_start_commit(journal, commit_tid);
-	ret = jbd2_log_wait_commit(journal, commit_tid);
+	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
  out:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5cf441c..72c9d8d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -55,21 +55,21 @@ static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 	__u16 csum_hi = 0;
 	__u32 csum;
 
-	csum_lo = raw->i_checksum_lo;
+	csum_lo = le16_to_cpu(raw->i_checksum_lo);
 	raw->i_checksum_lo = 0;
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
-		csum_hi = raw->i_checksum_hi;
+		csum_hi = le16_to_cpu(raw->i_checksum_hi);
 		raw->i_checksum_hi = 0;
 	}
 
 	csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)raw,
 			   EXT4_INODE_SIZE(inode->i_sb));
 
-	raw->i_checksum_lo = csum_lo;
+	raw->i_checksum_lo = cpu_to_le16(csum_lo);
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
-		raw->i_checksum_hi = csum_hi;
+		raw->i_checksum_hi = cpu_to_le16(csum_hi);
 
 	return csum;
 }
@@ -216,8 +216,7 @@ void ext4_evict_inode(struct inode *inode)
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
-			jbd2_log_start_commit(journal, commit_tid);
-			jbd2_log_wait_commit(journal, commit_tid);
+			jbd2_complete_transaction(journal, commit_tid);
 			filemap_write_and_wait(&inode->i_data);
 		}
 		truncate_inode_pages(&inode->i_data, 0);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 87b5519..773d341 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4438,11 +4438,11 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	node = rb_prev(new_node);
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
-		if (can_merge(entry, new_entry)) {
+		if (can_merge(entry, new_entry) &&
+		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
 			new_entry->efd_start_cluster = entry->efd_start_cluster;
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
-			ext4_journal_callback_del(handle, &entry->efd_jce);
 			kmem_cache_free(ext4_free_data_cachep, entry);
 		}
 	}
@@ -4450,10 +4450,10 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	node = rb_next(new_node);
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
-		if (can_merge(new_entry, entry)) {
+		if (can_merge(new_entry, entry) &&
+		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
-			ext4_journal_callback_del(handle, &entry->efd_jce);
 			kmem_cache_free(ext4_free_data_cachep, entry);
 		}
 	}
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index fe7c63f..b96e6b05 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -7,7 +7,7 @@
 #include "ext4.h"
 
 /* Checksumming functions */
-static __u32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
+static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int offset = offsetof(struct mmp_struct, mmp_checksum);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 82e1fde3..744097d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1255,6 +1255,8 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count += flex_gd->count;
+	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
@@ -1678,6 +1680,10 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 		return 0;
 
 	ext4_get_group_no_and_offset(sb, n_blocks_count - 1, &n_group, &offset);
+	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
+		ext4_warning(sb, "resize would cause inodes_count overflow");
+		return -EINVAL;
+	}
 	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
 
 	n_desc_blocks = (n_group + EXT4_DESC_PER_BLOCK(sb)) /
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f581886..f9b129c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -452,10 +452,13 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	struct super_block		*sb = journal->j_private;
 	struct ext4_sb_info		*sbi = EXT4_SB(sb);
 	int				error = is_journal_aborted(journal);
-	struct ext4_journal_cb_entry	*jce, *tmp;
+	struct ext4_journal_cb_entry	*jce;
 
+	BUG_ON(txn->t_state == T_FINISHED);
 	spin_lock(&sbi->s_md_lock);
-	list_for_each_entry_safe(jce, tmp, &txn->t_private_list, jce_list) {
+	while (!list_empty(&txn->t_private_list)) {
+		jce = list_entry(txn->t_private_list.next,
+				 struct ext4_journal_cb_entry, jce_list);
 		list_del_init(&jce->jce_list);
 		spin_unlock(&sbi->s_md_lock);
 		jce->jce_func(sb, jce, error);
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 4765190..73c0bd7 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -276,5 +276,5 @@ const struct file_operations fscache_stats_fops = {
 	.open		= fscache_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release        = single_release,
 };
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index af5280f..aa608d9 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -382,7 +382,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int space_left = 0;
 	int first_tag = 0;
 	int tag_flag;
-	int i, to_free = 0;
+	int i;
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
@@ -1108,7 +1108,7 @@ restart_loop:
 	journal->j_stats.run.rs_blocks_logged += stats.run.rs_blocks_logged;
 	spin_unlock(&journal->j_history_lock);
 
-	commit_transaction->t_state = T_FINISHED;
+	commit_transaction->t_state = T_COMMIT_CALLBACK;
 	J_ASSERT(commit_transaction == journal->j_committing_transaction);
 	journal->j_commit_sequence = commit_transaction->t_tid;
 	journal->j_committing_transaction = NULL;
@@ -1123,38 +1123,44 @@ restart_loop:
 				journal->j_average_commit_time*3) / 4;
 	else
 		journal->j_average_commit_time = commit_time;
+
 	write_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL &&
-	    commit_transaction->t_checkpoint_io_list == NULL) {
-		__jbd2_journal_drop_transaction(journal, commit_transaction);
-		to_free = 1;
+	if (journal->j_checkpoint_transactions == NULL) {
+		journal->j_checkpoint_transactions = commit_transaction;
+		commit_transaction->t_cpnext = commit_transaction;
+		commit_transaction->t_cpprev = commit_transaction;
 	} else {
-		if (journal->j_checkpoint_transactions == NULL) {
-			journal->j_checkpoint_transactions = commit_transaction;
-			commit_transaction->t_cpnext = commit_transaction;
-			commit_transaction->t_cpprev = commit_transaction;
-		} else {
-			commit_transaction->t_cpnext =
-				journal->j_checkpoint_transactions;
-			commit_transaction->t_cpprev =
-				commit_transaction->t_cpnext->t_cpprev;
-			commit_transaction->t_cpnext->t_cpprev =
-				commit_transaction;
-			commit_transaction->t_cpprev->t_cpnext =
+		commit_transaction->t_cpnext =
+			journal->j_checkpoint_transactions;
+		commit_transaction->t_cpprev =
+			commit_transaction->t_cpnext->t_cpprev;
+		commit_transaction->t_cpnext->t_cpprev =
+			commit_transaction;
+		commit_transaction->t_cpprev->t_cpnext =
 				commit_transaction;
-		}
 	}
 	spin_unlock(&journal->j_list_lock);
-
+	/* Drop all spin_locks because commit_callback may be block.
+	 * __journal_remove_checkpoint() can not destroy transaction
+	 * under us because it is not marked as T_FINISHED yet */
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 
 	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
-	if (to_free)
-		jbd2_journal_free_transaction(commit_transaction);
 
+	write_lock(&journal->j_state_lock);
+	spin_lock(&journal->j_list_lock);
+	commit_transaction->t_state = T_FINISHED;
+	/* Recheck checkpoint lists after j_list_lock was dropped */
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
+		__jbd2_journal_drop_transaction(journal, commit_transaction);
+		jbd2_journal_free_transaction(commit_transaction);
+	}
+	spin_unlock(&journal->j_list_lock);
+	write_unlock(&journal->j_state_lock);
 	wake_up(&journal->j_wait_done_commit);
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 484b8d1..b2d3cbe 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -699,6 +699,37 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 }
 
 /*
+ * When this function returns the transaction corresponding to tid
+ * will be completed.  If the transaction has currently running, start
+ * committing that transaction before waiting for it to complete.  If
+ * the transaction id is stale, it is by definition already completed,
+ * so just return SUCCESS.
+ */
+int jbd2_complete_transaction(journal_t *journal, tid_t tid)
+{
+	int	need_to_wait = 1;
+
+	read_lock(&journal->j_state_lock);
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == tid) {
+		if (journal->j_commit_request != tid) {
+			/* transaction not yet started, so request it */
+			read_unlock(&journal->j_state_lock);
+			jbd2_log_start_commit(journal, tid);
+			goto wait_commit;
+		}
+	} else if (!(journal->j_committing_transaction &&
+		     journal->j_committing_transaction->t_tid == tid))
+		need_to_wait = 0;
+	read_unlock(&journal->j_state_lock);
+	if (!need_to_wait)
+		return 0;
+wait_commit:
+	return jbd2_log_wait_commit(journal, tid);
+}
+EXPORT_SYMBOL(jbd2_complete_transaction);
+
+/*
  * Log buffer allocation routines:
  */
 
diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index ca0a080..193f04c 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -144,6 +144,9 @@ int nlmclnt_block(struct nlm_wait *block, struct nlm_rqst *req, long timeout)
 			timeout);
 	if (ret < 0)
 		return -ERESTARTSYS;
+	/* Reset the lock status after a server reboot so we resend */
+	if (block->b_status == nlm_lck_denied_grace_period)
+		block->b_status = nlm_lck_blocked;
 	req->a_res.status = block->b_status;
 	return 0;
 }
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 2c6c214..4d135ef 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1383,6 +1383,12 @@ int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state
 			case -ENOMEM:
 				err = 0;
 				goto out;
+			case -NFS4ERR_DELAY:
+			case -NFS4ERR_GRACE:
+				set_bit(NFS_DELEGATED_STATE, &state->flags);
+				ssleep(1);
+				err = -EAGAIN;
+				goto out;
 		}
 		err = nfs4_handle_exception(server, err, &exception);
 	} while (exception.retry);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c9c1c0a..4445c66 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -893,14 +893,14 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	nfs4_lock_state();
 	status = nfs4_preprocess_stateid_op(SVC_NET(rqstp),
 					cstate, stateid, WR_STATE, &filp);
-	if (filp)
-		get_file(filp);
-	nfs4_unlock_state();
-
 	if (status) {
+		nfs4_unlock_state();
 		dprintk("NFSD: nfsd4_write: couldn't process stateid!\n");
 		return status;
 	}
+	if (filp)
+		get_file(filp);
+	nfs4_unlock_state();
 
 	cnt = write->wr_buflen;
 	write->wr_how_written = write->wr_stable_how;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5b3224c..0ecd408 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -217,13 +217,7 @@ static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
 {
 	if (atomic_dec_and_test(&fp->fi_access[oflag])) {
 		nfs4_file_put_fd(fp, oflag);
-		/*
-		 * It's also safe to get rid of the RDWR open *if*
-		 * we no longer have need of the other kind of access
-		 * or if we already have the other kind of open:
-		 */
-		if (fp->fi_fds[1-oflag]
-			|| atomic_read(&fp->fi_access[1 - oflag]) == 0)
+		if (atomic_read(&fp->fi_access[1 - oflag]) == 0)
 			nfs4_file_put_fd(fp, O_RDWR);
 	}
 }
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 551b061..348937b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -343,10 +343,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			   all 32 bits of 'nseconds'. */
 			READ_BUF(12);
 			len += 12;
-			READ32(dummy32);
-			if (dummy32)
-				return nfserr_inval;
-			READ32(iattr->ia_atime.tv_sec);
+			READ64(iattr->ia_atime.tv_sec);
 			READ32(iattr->ia_atime.tv_nsec);
 			if (iattr->ia_atime.tv_nsec >= (u32)1000000000)
 				return nfserr_inval;
@@ -369,10 +366,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			   all 32 bits of 'nseconds'. */
 			READ_BUF(12);
 			len += 12;
-			READ32(dummy32);
-			if (dummy32)
-				return nfserr_inval;
-			READ32(iattr->ia_mtime.tv_sec);
+			READ64(iattr->ia_mtime.tv_sec);
 			READ32(iattr->ia_mtime.tv_nsec);
 			if (iattr->ia_mtime.tv_nsec >= (u32)1000000000)
 				return nfserr_inval;
@@ -2397,8 +2391,7 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_TIME_ACCESS) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.atime.tv_sec);
+		WRITE64((s64)stat.atime.tv_sec);
 		WRITE32(stat.atime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_DELTA) {
@@ -2411,15 +2404,13 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_TIME_METADATA) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.ctime.tv_sec);
+		WRITE64((s64)stat.ctime.tv_sec);
 		WRITE32(stat.ctime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_MODIFY) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.mtime.tv_sec);
+		WRITE64((s64)stat.mtime.tv_sec);
 		WRITE32(stat.mtime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 8445fbc..7e15ab0 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -577,7 +577,6 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 	int add = (arg & IN_MASK_ADD);
 	int ret;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 	if (unlikely(!(mask & IN_ALL_EVENTS)))
 		return -EINVAL;
@@ -630,7 +629,6 @@ static int inotify_new_watch(struct fsnotify_group *group,
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 	if (unlikely(!(mask & IN_ALL_EVENTS)))
 		return -EINVAL;
@@ -761,6 +759,10 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 	int ret, fput_needed;
 	unsigned flags = 0;
 
+	/* don't allow invalid bits: we don't want flags set */
+	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
+		return -EINVAL;
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(!filp))
 		return -EBADF;
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 4b93159..76f38eb 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1012,6 +1012,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	enum kobj_ns_type type;
 	const void *ns;
 	ino_t ino;
+	loff_t off;
 
 	type = sysfs_ns_type(parent_sd);
 	ns = sysfs_info(dentry->d_sb)->ns[type];
@@ -1034,6 +1035,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
+	off = filp->f_pos;
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, filp->f_pos, pos)) {
@@ -1045,19 +1047,24 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		len = strlen(name);
 		ino = pos->s_ino;
 		type = dt_type(pos);
-		filp->f_pos = pos->s_hash;
+		off = filp->f_pos = pos->s_hash;
 		filp->private_data = sysfs_get(pos);
 
 		mutex_unlock(&sysfs_mutex);
-		ret = filldir(dirent, name, len, filp->f_pos, ino, type);
+		ret = filldir(dirent, name, len, off, ino, type);
 		mutex_lock(&sysfs_mutex);
 		if (ret < 0)
 			break;
 	}
 	mutex_unlock(&sysfs_mutex);
-	if ((filp->f_pos > 1) && !pos) { /* EOF */
-		filp->f_pos = INT_MAX;
+
+	/* don't reference last entry if its refcount is dropped */
+	if (!pos) {
 		filp->private_data = NULL;
+
+		/* EOF and not changed as 0 or 1 in read/write path */
+		if (off == filp->f_pos && off > 1)
+			filp->f_pos = INT_MAX;
 	}
 	return 0;
 }
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index ff4947b..0084135 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -7,6 +7,16 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 
+/*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index d6b67bb..efd9db4 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1554,9 +1554,8 @@ extern void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *s
 
 void drm_prime_init_file_private(struct drm_prime_file_private *prime_fpriv);
 void drm_prime_destroy_file_private(struct drm_prime_file_private *prime_fpriv);
-int drm_prime_add_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle);
-int drm_prime_lookup_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle);
-void drm_prime_remove_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf);
+int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle);
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf);
 
 int drm_prime_add_dma_buf(struct drm_device *dev, struct drm_gem_object *obj);
 int drm_prime_lookup_obj(struct drm_device *dev, struct dma_buf *buf,
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 1cdbfe9..d7da55c 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -227,6 +227,7 @@
 	{0x1002, 0x6819, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6821, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6822, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6823, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6824, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
@@ -234,11 +235,13 @@
 	{0x1002, 0x6827, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6829, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x682A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x682B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x682D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x682F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6830, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6831, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6835, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6837, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6838, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6839, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
@@ -590,6 +593,8 @@
 	{0x1002, 0x9999, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 5499c92..c731973 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -42,8 +42,8 @@ struct ipc_namespace {
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
+	unsigned long	shm_tot;
 	int		shm_ctlmni;
-	int		shm_tot;
 	/*
 	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
 	 * of shmctl()
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3efc43f..ade60e7 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -498,6 +498,7 @@ struct transaction_s
 		T_COMMIT,
 		T_COMMIT_DFLUSH,
 		T_COMMIT_JFLUSH,
+		T_COMMIT_CALLBACK,
 		T_FINISHED
 	}			t_state;
 
@@ -1211,6 +1212,7 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_journal_force_commit_nested(journal_t *journal);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
+int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
 int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 23bddac..46bac3e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2455,27 +2455,18 @@ static inline void threadgroup_change_end(struct task_struct *tsk)
  *
  * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
  * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
- * perform exec.  This is useful for cases where the threadgroup needs to
- * stay stable across blockable operations.
+ * change ->group_leader/pid.  This is useful for cases where the threadgroup
+ * needs to stay stable across blockable operations.
  *
  * fork and exit paths explicitly call threadgroup_change_{begin|end}() for
  * synchronization.  While held, no new task will be added to threadgroup
  * and no existing live task will have its PF_EXITING set.
  *
- * During exec, a task goes and puts its thread group through unusual
- * changes.  After de-threading, exclusive access is assumed to resources
- * which are usually shared by tasks in the same group - e.g. sighand may
- * be replaced with a new one.  Also, the exec'ing task takes over group
- * leader role including its pid.  Exclude these changes while locked by
- * grabbing cred_guard_mutex which is used to synchronize exec path.
+ * de_thread() does threadgroup_change_{begin|end}() when a non-leader
+ * sub-thread becomes a new leader.
  */
 static inline void threadgroup_lock(struct task_struct *tsk)
 {
-	/*
-	 * exec uses exit for de-threading nesting group_rwsem inside
-	 * cred_guard_mutex. Grab cred_guard_mutex first.
-	 */
-	mutex_lock(&tsk->signal->cred_guard_mutex);
 	down_write(&tsk->signal->group_rwsem);
 }
 
@@ -2488,7 +2479,6 @@ static inline void threadgroup_lock(struct task_struct *tsk)
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
-	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}
diff --git a/ipc/shm.c b/ipc/shm.c
index 00faa05..9f753fc4 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -462,7 +462,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	size_t size = params->u.size;
 	int error;
 	struct shmid_kernel *shp;
-	int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct file * file;
 	char name[13];
 	int id;
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index ed206fd..23b8c66 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -609,9 +609,9 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
+		put_tree(tree);
 		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ff2bce5..bfc0578 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2067,7 +2067,7 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
 	if (retval)
 		goto out_free_group_list;
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1c5ab31..e3999c2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -298,6 +298,10 @@ ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 
@@ -1308,6 +1312,8 @@ retry:
 
 				expires = ktime_sub(hrtimer_get_expires(timer),
 						    base->offset);
+				if (expires.tv64 < 0)
+					expires.tv64 = KTIME_MAX;
 				if (expires.tv64 < expires_next.tv64)
 					expires_next = expires;
 				break;
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index a13987a..239a323 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,6 +66,8 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
+	struct clock_event_device *cur = tick_broadcast_device.evtdev;
+
 	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
 	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
@@ -73,6 +75,8 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 		return 0;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
+	if (cur)
+		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index da6c9ec..ead79bc 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -323,6 +323,7 @@ static void tick_shutdown(unsigned int *cpup)
 		 */
 		dev->mode = CLOCK_EVT_MODE_UNUSED;
 		clockevents_exchange_device(dev, NULL);
+		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d5525eb..09657d7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -624,7 +624,7 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 
 	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
 
-	for (i = 0; i < pages; i++) {
+	for (i = 1; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;
@@ -3579,7 +3579,8 @@ out:
 	if (fail)
 		return -EINVAL;
 
-	ftrace_graph_filter_enabled = 1;
+	ftrace_graph_filter_enabled = !!(*idx);
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bf2c50b..6fbd63a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4848,6 +4848,8 @@ static __init int tracer_init_debugfs(void)
 	trace_access_lock_init();
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("tracing_enabled", 0644, d_tracer,
 			&global_trace, &tracing_ctrl_fops);
@@ -4984,36 +4986,32 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	iter->cpu_file = TRACE_PIPE_ALL_CPU;
 }
 
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
+void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 {
-	static arch_spinlock_t ftrace_dump_lock =
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
+	static atomic_t dump_running;
 	unsigned int old_userobj;
-	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0, cpu;
 
-	/* only one dump */
-	local_irq_save(flags);
-	arch_spin_lock(&ftrace_dump_lock);
-	if (dump_ran)
-		goto out;
-
-	dump_ran = 1;
+	/* Only allow one dump user at a time. */
+	if (atomic_inc_return(&dump_running) != 1) {
+		atomic_dec(&dump_running);
+		return;
+	}
 
+	/*
+	 * Always turn off tracing when we dump.
+	 * We don't need to show trace output of what happens
+	 * between multiple crashes.
+	 *
+	 * If the user does a sysrq-z, then they can re-enable
+	 * tracing with echo 1 > tracing_on.
+	 */
 	tracing_off();
 
-	/* Did function tracer already get disabled? */
-	if (ftrace_is_dead()) {
-		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
-		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
-	}
-
-	if (disable_tracing)
-		ftrace_kill();
+	local_irq_save(flags);
 
 	trace_init_global_iter(&iter);
 
@@ -5046,6 +5044,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
+	/* Did function tracer already get disabled? */
+	if (ftrace_is_dead()) {
+		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
+	}
+
 	/*
 	 * We need to stop all tracing on all CPUS to read the
 	 * the next buffer. This is a bit expensive, but is
@@ -5085,26 +5089,14 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		printk(KERN_TRACE "---------------------------------\n");
 
  out_enable:
-	/* Re-enable tracing if requested */
-	if (!disable_tracing) {
-		trace_flags |= old_userobj;
+	trace_flags |= old_userobj;
 
-		for_each_tracing_cpu(cpu) {
-			atomic_dec(&iter.tr->data[cpu]->disabled);
-		}
-		tracing_on();
+	for_each_tracing_cpu(cpu) {
+		atomic_dec(&iter.tr->data[cpu]->disabled);
 	}
-
- out:
-	arch_spin_unlock(&ftrace_dump_lock);
+	atomic_dec(&dump_running);
 	local_irq_restore(flags);
 }
-
-/* By default: disable tracing after the dump */
-void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
-{
-	__ftrace_dump(true, oops_dump_mode);
-}
 EXPORT_SYMBOL_GPL(ftrace_dump);
 
 __init static int tracer_alloc_buffers(void)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 288541f..09fd98a 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -461,8 +461,6 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 /* Maximum number of functions to trace before diagnosing a hang */
 #define GRAPH_MAX_FUNC_TEST	100000000
 
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode);
 static unsigned int graph_hang_thresh;
 
 /* Wrap the real function entry probe to avoid possible hanging */
@@ -472,8 +470,11 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
 	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
 		ftrace_graph_stop();
 		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
-		if (ftrace_dump_on_oops)
-			__ftrace_dump(false, DUMP_ALL);
+		if (ftrace_dump_on_oops) {
+			ftrace_dump(DUMP_ALL);
+			/* ftrace_dump() disables tracing */
+			tracing_on();
+		}
 		return 0;
 	}
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index aa4270a..8298997 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -20,13 +20,24 @@
 
 #define STACK_TRACE_ENTRIES 500
 
+#ifdef CC_USING_FENTRY
+# define fentry		1
+#else
+# define fentry		0
+#endif
+
 static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES+1] =
 	 { [0 ... (STACK_TRACE_ENTRIES)] = ULONG_MAX };
 static unsigned stack_dump_index[STACK_TRACE_ENTRIES];
 
+/*
+ * Reserve one entry for the passed in ip. This will allow
+ * us to remove most or all of the stack size overhead
+ * added by the stack tracer itself.
+ */
 static struct stack_trace max_stack_trace = {
-	.max_entries		= STACK_TRACE_ENTRIES,
-	.entries		= stack_dump_trace,
+	.max_entries		= STACK_TRACE_ENTRIES - 1,
+	.entries		= &stack_dump_trace[1],
 };
 
 static unsigned long max_stack_size;
@@ -40,25 +51,34 @@ static DEFINE_MUTEX(stack_sysctl_mutex);
 int stack_tracer_enabled;
 static int last_stack_tracer_enabled;
 
-static inline void check_stack(void)
+static inline void
+check_stack(unsigned long ip, unsigned long *stack)
 {
 	unsigned long this_size, flags;
 	unsigned long *p, *top, *start;
+	static int tracer_frame;
+	int frame_size = ACCESS_ONCE(tracer_frame);
 	int i;
 
-	this_size = ((unsigned long)&this_size) & (THREAD_SIZE-1);
+	this_size = ((unsigned long)stack) & (THREAD_SIZE-1);
 	this_size = THREAD_SIZE - this_size;
+	/* Remove the frame of the tracer */
+	this_size -= frame_size;
 
 	if (this_size <= max_stack_size)
 		return;
 
 	/* we do not handle interrupt stacks yet */
-	if (!object_is_on_stack(&this_size))
+	if (!object_is_on_stack(stack))
 		return;
 
 	local_irq_save(flags);
 	arch_spin_lock(&max_stack_lock);
 
+	/* In case another CPU set the tracer_frame on us */
+	if (unlikely(!frame_size))
+		this_size -= tracer_frame;
+
 	/* a race could have already updated it */
 	if (this_size <= max_stack_size)
 		goto out;
@@ -71,10 +91,18 @@ static inline void check_stack(void)
 	save_stack_trace(&max_stack_trace);
 
 	/*
+	 * Add the passed in ip from the function tracer.
+	 * Searching for this on the stack will skip over
+	 * most of the overhead from the stack tracer itself.
+	 */
+	stack_dump_trace[0] = ip;
+	max_stack_trace.nr_entries++;
+
+	/*
 	 * Now find where in the stack these are.
 	 */
 	i = 0;
-	start = &this_size;
+	start = stack;
 	top = (unsigned long *)
 		(((unsigned long)start & ~(THREAD_SIZE-1)) + THREAD_SIZE);
 
@@ -98,6 +126,18 @@ static inline void check_stack(void)
 				found = 1;
 				/* Start the search from here */
 				start = p + 1;
+				/*
+				 * We do not want to show the overhead
+				 * of the stack tracer stack in the
+				 * max stack. If we haven't figured
+				 * out what that is, then figure it out
+				 * now.
+				 */
+				if (unlikely(!tracer_frame) && i == 1) {
+					tracer_frame = (p - stack) *
+						sizeof(unsigned long);
+					max_stack_size -= tracer_frame;
+				}
 			}
 		}
 
@@ -113,6 +153,7 @@ static inline void check_stack(void)
 static void
 stack_trace_call(unsigned long ip, unsigned long parent_ip)
 {
+	unsigned long stack;
 	int cpu;
 
 	if (unlikely(!ftrace_enabled || stack_trace_disabled))
@@ -125,7 +166,26 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	if (per_cpu(trace_active, cpu)++ != 0)
 		goto out;
 
-	check_stack();
+	/*
+	 * When fentry is used, the traced function does not get
+	 * its stack frame set up, and we lose the parent.
+	 * The ip is pretty useless because the function tracer
+	 * was called before that function set up its stack frame.
+	 * In this case, we use the parent ip.
+	 *
+	 * By adding the return address of either the parent ip
+	 * or the current ip we can disregard most of the stack usage
+	 * caused by the stack tracer itself.
+	 *
+	 * The function tracer always reports the address of where the
+	 * mcount call was, but the stack will hold the return address.
+	 */
+	if (fentry)
+		ip = parent_ip;
+	else
+		ip += MCOUNT_INSN_SIZE;
+
+	check_stack(ip, &stack);
 
  out:
 	per_cpu(trace_active, cpu)--;
@@ -373,6 +433,8 @@ static __init int stack_trace_init(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("stack_max_size", 0644, d_tracer,
 			&max_stack_size, &stack_max_size_fops);
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 96cffb2..847f88a 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -307,6 +307,8 @@ static int tracing_stat_init(void)
 	struct dentry *d_tracing;
 
 	d_tracing = tracing_init_dentry();
+	if (!d_tracing)
+		return 0;
 
 	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)
diff --git a/mm/mmap.c b/mm/mmap.c
index cf6434e..3ddb799 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1912,7 +1912,7 @@ static void unmap_region(struct mm_struct *mm,
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : 0);
+				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, start, end);
 }
 
@@ -2294,7 +2294,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
 
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, 0, -1);
 
 	/*
diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..6182870 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -214,6 +214,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		kiocb.ki_left = PAGE_SIZE;
 		kiocb.ki_nbytes = PAGE_SIZE;
 
+		set_page_writeback(page);
 		unlock_page(page);
 		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
 						&kiocb, &iov,
@@ -222,7 +223,23 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
+		} else {
+			/*
+			 * In the case of swap-over-nfs, this can be a
+			 * temporary failure if the system has limited
+			 * memory for allocating transmit buffers.
+			 * Mark the page dirty and avoid
+			 * rotate_reclaimable_page but rate-limit the
+			 * messages but do not flag PageError like
+			 * the normal direct-to-bio case as it could
+			 * be temporary.
+			 */
+			set_page_dirty(page);
+			ClearPageReclaim(page);
+			pr_err_ratelimited("Write error on dio swapfile (%Lu)\n",
+				page_file_offset(page));
 		}
+		end_page_writeback(page);
 		return ret;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 31371be..5d60ca1 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -66,6 +66,12 @@ static bool rpfilter_lookup_reverse(struct flowi4 *fl4,
 	return dev_match;
 }
 
+static bool rpfilter_is_local(const struct sk_buff *skb)
+{
+	const struct rtable *rt = skb_rtable(skb);
+	return rt && (rt->rt_flags & RTCF_LOCAL);
+}
+
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rpfilter_info *info;
@@ -76,7 +82,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	info = par->matchinfo;
 	invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (rpfilter_is_local(skb))
 		return true ^ invert;
 
 	iph = ip_hdr(skb);
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 5d1d8b0..a7b522f 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -71,6 +71,12 @@ static bool rpfilter_lookup_reverse6(const struct sk_buff *skb,
 	return ret;
 }
 
+static bool rpfilter_is_local(const struct sk_buff *skb)
+{
+	const struct rt6_info *rt = (const void *) skb_dst(skb);
+	return rt && (rt->rt6i_flags & RTF_LOCAL);
+}
+
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rpfilter_info *info = par->matchinfo;
@@ -78,7 +84,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6hdr *iph;
 	bool invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (rpfilter_is_local(skb))
 		return true ^ invert;
 
 	iph = ipv6_hdr(skb);
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 9730882..eaabc58 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1387,7 +1387,8 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 	if (ret == -EAGAIN)
 		ret = 1;
 
-	return ret < 0 ? ret : ret > 0 ? 0 : -IPSET_ERR_EXIST;
+	return (ret < 0 && ret != -ENOTEMPTY) ? ret :
+		ret > 0 ? 0 : -IPSET_ERR_EXIST;
 }
 
 /* Get headed data of a set */
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 6cb1225..19bf0fe 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -171,9 +171,13 @@ list_set_add(struct list_set *map, u32 i, ip_set_id_t id,
 {
 	const struct set_elem *e = list_set_elem(map, i);
 
-	if (i == map->size - 1 && e->id != IPSET_INVALID_ID)
-		/* Last element replaced: e.g. add new,before,last */
-		ip_set_put_byindex(e->id);
+	if (e->id != IPSET_INVALID_ID) {
+		const struct set_elem *x = list_set_elem(map, map->size - 1);
+
+		/* Last element replaced or pushed off */
+		if (x->id != IPSET_INVALID_ID)
+			ip_set_put_byindex(x->id);
+	}
 	if (with_timeout(map->timeout))
 		list_elem_tadd(map, i, id, ip_set_timeout_set(timeout));
 	else
diff --git a/net/netfilter/ipvs/ip_vs_pe_sip.c b/net/netfilter/ipvs/ip_vs_pe_sip.c
index 1aa5cac..55add93 100644
--- a/net/netfilter/ipvs/ip_vs_pe_sip.c
+++ b/net/netfilter/ipvs/ip_vs_pe_sip.c
@@ -37,14 +37,10 @@ static int get_callid(const char *dptr, unsigned int dataoff,
 		if (ret > 0)
 			break;
 		if (!ret)
-			return 0;
+			return -EINVAL;
 		dataoff += *matchoff;
 	}
 
-	/* Empty callid is useless */
-	if (!*matchlen)
-		return -EINVAL;
-
 	/* Too large is useless */
 	if (*matchlen > IP_VS_PEDATA_MAXLEN)
 		return -EINVAL;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index c4bc637..622dd4d 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -232,7 +232,9 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 		/* We only allow helper re-assignment of the same sort since
 		 * we cannot reallocate the helper extension area.
 		 */
-		if (help->helper != helper) {
+		struct nf_conntrack_helper *tmp = rcu_dereference(help->helper);
+
+		if (tmp && tmp->help != helper->help) {
 			RCU_INIT_POINTER(help->helper, NULL);
 			goto out;
 		}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9807f32..0f15779 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1579,6 +1579,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
 			enum ip_conntrack_events events;
 
+			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY])
+				return -EINVAL;
+
 			ct = ctnetlink_create_conntrack(net, zone, cda, &otuple,
 							&rtuple, u3);
 			if (IS_ERR(ct))
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5c0a112..8ec43a7 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1521,7 +1521,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 
 		msglen = origlen = end - dptr;
 		if (msglen > datalen)
-			return NF_DROP;
+			return NF_ACCEPT;
 
 		ret = process_sip_msg(skb, ct, dataoff, &dptr, &msglen);
 		if (ret != NF_ACCEPT)
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3062b88..633806e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -874,7 +874,7 @@ static void handle_channel(struct wiphy *wiphy,
 			return;
 
 		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
-		chan->flags = IEEE80211_CHAN_DISABLED;
+		chan->flags |= IEEE80211_CHAN_DISABLED;
 		return;
 	}
 
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index af7324b..4790568 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -2006,7 +2006,7 @@ static int max98088_probe(struct snd_soc_codec *codec)
                        ret);
                goto err_access;
        }
-       dev_info(codec->dev, "revision %c\n", ret + 'A');
+       dev_info(codec->dev, "revision %c\n", ret - 0x40 + 'A');
 
        snd_soc_write(codec, M98088_REG_51_PWR_SYS, M98088_PWRSV);
 
diff --git a/sound/usb/card.c b/sound/usb/card.c
index b3f5ad4..aa25e04 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -619,7 +619,9 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
 	int err = -ENODEV;
 
 	down_read(&chip->shutdown_rwsem);
-	if (!chip->shutdown && !chip->probing)
+	if (chip->probing)
+		err = 0;
+	else if (!chip->shutdown)
 		err = usb_autopm_get_interface(chip->pm_intf);
 	up_read(&chip->shutdown_rwsem);
 
diff --git a/sound/usb/card.h b/sound/usb/card.h
index 6e262c5..48aabb6 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -112,6 +112,7 @@ struct snd_usb_substream {
 	unsigned int altset_idx;     /* USB data format: index of alternate setting */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
+	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index eeefbce..d561e8c 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -125,8 +125,9 @@ struct snd_usb_midi {
 		struct snd_usb_midi_in_endpoint *in;
 	} endpoints[MIDI_MAX_ENDPOINTS];
 	unsigned long input_triggered;
-	unsigned int opened;
+	unsigned int opened[2];
 	unsigned char disconnected;
+	unsigned char input_running;
 
 	struct snd_kcontrol *roland_load_ctl;
 };
@@ -148,7 +149,6 @@ struct snd_usb_midi_out_endpoint {
 		struct snd_usb_midi_out_endpoint* ep;
 		struct snd_rawmidi_substream *substream;
 		int active;
-		bool autopm_reference;
 		uint8_t cable;		/* cable number << 4 */
 		uint8_t state;
 #define STATE_UNKNOWN	0
@@ -1033,29 +1033,41 @@ static void update_roland_altsetting(struct snd_usb_midi* umidi)
 	snd_usbmidi_input_start(&umidi->list);
 }
 
-static void substream_open(struct snd_rawmidi_substream *substream, int open)
+static int substream_open(struct snd_rawmidi_substream *substream, int dir,
+			  int open)
 {
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct snd_kcontrol *ctl;
 
 	mutex_lock(&umidi->mutex);
 	if (open) {
-		if (umidi->opened++ == 0 && umidi->roland_load_ctl) {
-			ctl = umidi->roland_load_ctl;
-			ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-			snd_ctl_notify(umidi->card,
+		if (!umidi->opened[0] && !umidi->opened[1]) {
+			if (umidi->roland_load_ctl) {
+				ctl = umidi->roland_load_ctl;
+				ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
-			update_roland_altsetting(umidi);
+				update_roland_altsetting(umidi);
+			}
 		}
+		umidi->opened[dir]++;
+		if (umidi->opened[1])
+			snd_usbmidi_input_start(&umidi->list);
 	} else {
-		if (--umidi->opened == 0 && umidi->roland_load_ctl) {
-			ctl = umidi->roland_load_ctl;
-			ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-			snd_ctl_notify(umidi->card,
+		umidi->opened[dir]--;
+		if (!umidi->opened[1])
+			snd_usbmidi_input_stop(&umidi->list);
+		if (!umidi->opened[0] && !umidi->opened[1]) {
+			if (umidi->roland_load_ctl) {
+				ctl = umidi->roland_load_ctl;
+				ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+			}
 		}
 	}
 	mutex_unlock(&umidi->mutex);
+	return 0;
 }
 
 static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
@@ -1063,7 +1075,6 @@ static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct usbmidi_out_port* port = NULL;
 	int i, j;
-	int err;
 
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
 		if (umidi->endpoints[i].out)
@@ -1076,25 +1087,14 @@ static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
 		snd_BUG();
 		return -ENXIO;
 	}
-	err = usb_autopm_get_interface(umidi->iface);
-	port->autopm_reference = err >= 0;
-	if (err < 0 && err != -EACCES)
-		return -EIO;
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;
-	substream_open(substream, 1);
-	return 0;
+	return substream_open(substream, 0, 1);
 }
 
 static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substream)
 {
-	struct snd_usb_midi* umidi = substream->rmidi->private_data;
-	struct usbmidi_out_port *port = substream->runtime->private_data;
-
-	substream_open(substream, 0);
-	if (port->autopm_reference)
-		usb_autopm_put_interface(umidi->iface);
-	return 0;
+	return substream_open(substream, 0, 0);
 }
 
 static void snd_usbmidi_output_trigger(struct snd_rawmidi_substream *substream, int up)
@@ -1147,14 +1147,12 @@ static void snd_usbmidi_output_drain(struct snd_rawmidi_substream *substream)
 
 static int snd_usbmidi_input_open(struct snd_rawmidi_substream *substream)
 {
-	substream_open(substream, 1);
-	return 0;
+	return substream_open(substream, 1, 1);
 }
 
 static int snd_usbmidi_input_close(struct snd_rawmidi_substream *substream)
 {
-	substream_open(substream, 0);
-	return 0;
+	return substream_open(substream, 1, 0);
 }
 
 static void snd_usbmidi_input_trigger(struct snd_rawmidi_substream *substream, int up)
@@ -2060,12 +2058,15 @@ void snd_usbmidi_input_stop(struct list_head* p)
 	unsigned int i, j;
 
 	umidi = list_entry(p, struct snd_usb_midi, list);
+	if (!umidi->input_running)
+		return;
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint* ep = &umidi->endpoints[i];
 		if (ep->in)
 			for (j = 0; j < INPUT_URBS; ++j)
 				usb_kill_urb(ep->in->urbs[j]);
 	}
+	umidi->input_running = 0;
 }
 
 static void snd_usbmidi_input_start_ep(struct snd_usb_midi_in_endpoint* ep)
@@ -2090,8 +2091,11 @@ void snd_usbmidi_input_start(struct list_head* p)
 	int i;
 
 	umidi = list_entry(p, struct snd_usb_midi, list);
+	if (umidi->input_running || !umidi->opened[1])
+		return;
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
 		snd_usbmidi_input_start_ep(umidi->endpoints[i].in);
+	umidi->input_running = 1;
 }
 
 /*
@@ -2228,10 +2232,9 @@ int snd_usbmidi_create(struct snd_card *card,
 		return err;
 	}
 
-	list_add_tail(&umidi->list, midi_list);
+	usb_autopm_get_interface_no_resume(umidi->iface);
 
-	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
-		snd_usbmidi_input_start_ep(umidi->endpoints[i].in);
+	list_add_tail(&umidi->list, midi_list);
 	return 0;
 }
 
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 90731af..cbaecce 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1017,7 +1017,7 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 	stride = runtime->frame_bits >> 3;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset + subs->pkt_offset_adj;
 		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
 			snd_printdd(KERN_ERR "frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 213ecad..2c22adf 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -746,6 +746,7 @@ static void set_format_emu_quirk(struct snd_usb_substream *subs,
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 1de0c8c..1891e49b 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -91,6 +91,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->dev = as->chip->dev;
 	subs->txfr_quirk = as->chip->txfr_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
+	subs->pkt_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 
@@ -193,6 +194,14 @@ static int parse_uac_endpoint_attributes(struct snd_usb_audio *chip,
 	if (!csep && altsd->bNumEndpoints >= 2)
 		csep = snd_usb_find_desc(alts->endpoint[1].extra, alts->endpoint[1].extralen, NULL, USB_DT_CS_ENDPOINT);
 
+	/*
+	 * If we can't locate the USB_DT_CS_ENDPOINT descriptor in the extra
+	 * bytes after the first endpoint, go search the entire interface.
+	 * Some devices have it directly *before* the standard endpoint.
+	 */
+	if (!csep)
+		csep = snd_usb_find_desc(alts->extra, alts->extralen, NULL, USB_DT_CS_ENDPOINT);
+
 	if (!csep || csep->bLength < 7 ||
 	    csep->bDescriptorSubtype != UAC_EP_GENERAL) {
 		snd_printk(KERN_WARNING "%d:%u:%d : no or invalid"


