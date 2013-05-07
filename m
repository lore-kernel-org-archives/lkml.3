Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3EGEFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:05:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3EGEFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:05:10 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=P6b63XBnyJwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=zNXoGfytzK0A:10 a=gilXszEKXWXpk4U-BF4A:9 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=Rm3zHy7k_-gA:10 a=-0qkl0XTG-IA:10 a=XNQn82OBbMlavPfb:21 a=lLi39dI0GZkZbeQ_:21 a=cAVNXQnw6tG-hL70:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367899507.7373.45.camel@gandalf.local.home>
Subject: Re: [000/126] 3.6.11.3-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Date: Tue, 07 May 2013 00:05:07 -0400
In-Reply-To: <20130507035712.909872333@goodmis.org>
References: <20130507035712.909872333@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 50c3a87..8be9655 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 6
 SUBLEVEL = 11
-EXTRAVERSION = .2
+EXTRAVERSION = .3
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index 4d4c046..1383f86 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -188,6 +188,10 @@ nautilus_machine_check(unsigned long vector, unsigned long la_ptr)
 extern void free_reserved_mem(void *, void *);
 extern void pcibios_claim_one_bus(struct pci_bus *);
 
+static struct resource irongate_io = {
+	.name	= "Irongate PCI IO",
+	.flags	= IORESOURCE_IO,
+};
 static struct resource irongate_mem = {
 	.name	= "Irongate PCI MEM",
 	.flags	= IORESOURCE_MEM,
@@ -209,6 +213,7 @@ nautilus_init_pci(void)
 
 	irongate = pci_get_bus_and_slot(0, 0);
 	bus->self = irongate;
+	bus->resource[0] = &irongate_io;
 	bus->resource[1] = &irongate_mem;
 
 	pci_bus_size_bridges(bus);
diff --git a/arch/arm/include/asm/hardware/iop3xx.h b/arch/arm/include/asm/hardware/iop3xx.h
index 2ff2c75..7e2507f 100644
--- a/arch/arm/include/asm/hardware/iop3xx.h
+++ b/arch/arm/include/asm/hardware/iop3xx.h
@@ -37,7 +37,7 @@ extern int iop3xx_get_init_atu(void);
  * IOP3XX processor registers
  */
 #define IOP3XX_PERIPHERAL_PHYS_BASE	0xffffe000
-#define IOP3XX_PERIPHERAL_VIRT_BASE	0xfeffe000
+#define IOP3XX_PERIPHERAL_VIRT_BASE	0xfedfe000
 #define IOP3XX_PERIPHERAL_SIZE		0x00002000
 #define IOP3XX_PERIPHERAL_UPPER_PA (IOP3XX_PERIPHERAL_PHYS_BASE +\
 					IOP3XX_PERIPHERAL_SIZE - 1)
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index ab243b8..5770b9d 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -316,7 +316,10 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
-	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
+	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
+		return 1;
+
+	if (event->state == PERF_EVENT_STATE_OFF && !event->attr.enable_on_exec)
 		return 1;
 
 	return armpmu->get_event_idx(hw_events, &fake_event) >= 0;
diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index f451539..4975d1f 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -41,12 +41,12 @@ static u32 notrace jiffy_sched_clock_read(void)
 
 static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
 
-static inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
+static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 {
 	u64 epoch_ns;
 	u32 epoch_cyc;
diff --git a/arch/arm/mach-imx/clk-imx35.c b/arch/arm/mach-imx/clk-imx35.c
index 65fb8bc..0c6061d 100644
--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -260,6 +260,8 @@ int __init mx35_clocks_init()
 	clk_prepare_enable(clk[gpio3_gate]);
 	clk_prepare_enable(clk[iim_gate]);
 	clk_prepare_enable(clk[emi_gate]);
+	clk_prepare_enable(clk[max_gate]);
+	clk_prepare_enable(clk[iomuxc_gate]);
 
 	/*
 	 * SCC is needed to boot via mmc after a watchdog reset. The clock code
diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
index dd3d591..48bc3c0 100644
--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -343,6 +343,7 @@ void __init feroceon_l2_init(int __l2_wt_override)
 	outer_cache.inv_range = feroceon_l2_inv_range;
 	outer_cache.clean_range = feroceon_l2_clean_range;
 	outer_cache.flush_range = feroceon_l2_flush_range;
+	outer_cache.inv_all = l2_inv_all;
 
 	enable_l2();
 
diff --git a/arch/arm/mm/proc-arm920.S b/arch/arm/mm/proc-arm920.S
index 1a8c138..2a5691a 100644
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -384,7 +384,7 @@ ENTRY(cpu_arm920_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/plat-s3c24xx/sleep.S */
 .globl	cpu_arm920_suspend_size
 .equ	cpu_arm920_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_arm920_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ PID
diff --git a/arch/arm/mm/proc-arm926.S b/arch/arm/mm/proc-arm926.S
index c31e62c..5e174e4 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -399,7 +399,7 @@ ENTRY(cpu_arm926_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/plat-s3c24xx/sleep.S */
 .globl	cpu_arm926_suspend_size
 .equ	cpu_arm926_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_arm926_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ PID
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index fbb2124..3fbb2c2 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -347,7 +347,7 @@ ENTRY(cpu_mohawk_set_pte_ext)
 
 .globl	cpu_mohawk_suspend_size
 .equ	cpu_mohawk_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_mohawk_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode
diff --git a/arch/arm/mm/proc-sa1100.S b/arch/arm/mm/proc-sa1100.S
index 3aa0da1..d92dfd0 100644
--- a/arch/arm/mm/proc-sa1100.S
+++ b/arch/arm/mm/proc-sa1100.S
@@ -172,7 +172,7 @@ ENTRY(cpu_sa1100_set_pte_ext)
 
 .globl	cpu_sa1100_suspend_size
 .equ	cpu_sa1100_suspend_size, 4 * 3
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_sa1100_do_suspend)
 	stmfd	sp!, {r4 - r6, lr}
 	mrc	p15, 0, r4, c3, c0, 0		@ domain ID
diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index 86b8b48..d9b9f8b 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -138,7 +138,7 @@ ENTRY(cpu_v6_set_pte_ext)
 /* Suspend/resume support: taken from arch/arm/mach-s3c64xx/sleep.S */
 .globl	cpu_v6_suspend_size
 .equ	cpu_v6_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_v6_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p15, 0, r4, c13, c0, 0	@ FCSE/PID
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index b0d5786..a2d1e86 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -410,7 +410,7 @@ ENTRY(cpu_xsc3_set_pte_ext)
 
 .globl	cpu_xsc3_suspend_size
 .equ	cpu_xsc3_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_xsc3_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 4ffebaa..9882153 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -524,7 +524,7 @@ ENTRY(cpu_xscale_set_pte_ext)
 
 .globl	cpu_xscale_suspend_size
 .equ	cpu_xscale_suspend_size, 4 * 6
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_xscale_do_suspend)
 	stmfd	sp!, {r4 - r9, lr}
 	mrc	p14, 0, r4, c6, c0, 0	@ clock configuration, for turbo mode
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 5f3ef87..9cfdcc9 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -187,7 +187,13 @@ static long pSeries_lpar_hpte_remove(unsigned long hpte_group)
 					   (0x1UL << 4), &dummy1, &dummy2);
 		if (lpar_rc == H_SUCCESS)
 			return i;
-		BUG_ON(lpar_rc != H_NOT_FOUND);
+
+		/*
+		 * The test for adjunct partition is performed before the
+		 * ANDCOND test.  H_RESOURCE may be returned, so we need to
+		 * check for that as well.
+		 */
+		BUG_ON(lpar_rc != H_NOT_FOUND && lpar_rc != H_RESOURCE);
 
 		slot_offset++;
 		slot_offset &= 0x7;
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 8a84501..5ef205c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -29,7 +29,6 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/piggy.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
-$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
 
 ifeq ($(CONFIG_EFI_STUB), y)
 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
@@ -43,7 +42,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-targets += vmlinux.bin.all vmlinux.relocs
+targets += $(patsubst $(obj)/%,%,$(VMLINUX_OBJS)) vmlinux.bin.all vmlinux.relocs
 
 CMD_RELOCS = arch/x86/tools/relocs
 quiet_cmd_relocs = RELOCS  $@
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09155d6..69c9a92 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -418,8 +418,8 @@ struct kvm_vcpu_arch {
 	gpa_t time;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned int hw_tsc_khz;
-	unsigned int time_offset;
-	struct page *time_page;
+	struct gfn_to_hva_cache pv_time;
+	bool pv_time_enabled;
 
 	struct {
 		u64 msr_val;
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a0facf3..97da2bb 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -705,7 +705,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	PVOP_VCALL0(pv_mmu_ops.lazy_mode.leave);
 }
 
-void arch_flush_lazy_mmu_mode(void);
+static inline void arch_flush_lazy_mmu_mode(void)
+{
+	PVOP_VCALL0(pv_mmu_ops.lazy_mode.flush);
+}
 
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 				phys_addr_t phys, pgprot_t flags)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..b3b0ec1 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -91,6 +91,7 @@ struct pv_lazy_ops {
 	/* Set deferred update mode, used for batching operations. */
 	void (*enter)(void);
 	void (*leave)(void);
+	void (*flush)(void);
 };
 
 struct pv_time_ops {
@@ -679,6 +680,7 @@ void paravirt_end_context_switch(struct task_struct *next);
 
 void paravirt_enter_lazy_mmu(void);
 void paravirt_leave_lazy_mmu(void);
+void paravirt_flush_lazy_mmu(void);
 
 void _paravirt_nop(void);
 u32 _paravirt_ident_32(u32);
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 1ace47b..2e188d6 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -29,13 +29,13 @@ extern const unsigned long sys_call_table[];
  */
 static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->orig_ax & __SYSCALL_MASK;
+	return regs->orig_ax;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
-	regs->ax = regs->orig_ax & __SYSCALL_MASK;
+	regs->ax = regs->orig_ax;
 }
 
 static inline long syscall_get_error(struct task_struct *task,
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 4fef207..c779730 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -7,7 +7,7 @@
 
 #define tlb_flush(tlb)							\
 {									\
-	if (tlb->fullmm == 0)						\
+	if (!tlb->fullmm && !tlb->need_flush_all) 			\
 		flush_tlb_mm_range(tlb->mm, tlb->start, tlb->end, 0UL);	\
 	else								\
 		flush_tlb_mm_range(tlb->mm, 0UL, TLB_FLUSH_ALL, 0UL);	\
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6bca492..5e6b361 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -128,8 +128,14 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 };
 
 static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
+	EVENT_EXTRA_END
+};
+
+static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
 	EVENT_EXTRA_END
 };
 
@@ -2058,7 +2064,10 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 45)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
@@ -2083,7 +2092,10 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 62)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 17fff18..8bfb335 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -263,6 +263,18 @@ void paravirt_leave_lazy_mmu(void)
 	leave_lazy(PARAVIRT_LAZY_MMU);
 }
 
+void paravirt_flush_lazy_mmu(void)
+{
+	preempt_disable();
+
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
+		arch_leave_lazy_mmu_mode();
+		arch_enter_lazy_mmu_mode();
+	}
+
+	preempt_enable();
+}
+
 void paravirt_start_context_switch(struct task_struct *prev)
 {
 	BUG_ON(preemptible());
@@ -292,18 +304,6 @@ enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return this_cpu_read(paravirt_lazy_mode);
 }
 
-void arch_flush_lazy_mmu_mode(void)
-{
-	preempt_disable();
-
-	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
-	}
-
-	preempt_enable();
-}
-
 struct pv_info pv_info = {
 	.name = "bare hardware",
 	.paravirt_enabled = 0,
@@ -475,6 +475,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.lazy_mode = {
 		.enter = paravirt_nop,
 		.leave = paravirt_nop,
+		.flush = paravirt_nop,
 	},
 
 	.set_fixmap = native_set_fixmap,
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ce87878..f0ecc92 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1574,5 +1574,5 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
 	if (!pv_eoi_enabled(vcpu))
 		return 0;
 	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.pv_eoi.data,
-					 addr);
+					 addr, sizeof(u8));
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a201790..f7a361f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1136,7 +1136,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
-	void *shared_kaddr;
 	unsigned long this_tsc_khz;
 	s64 kernel_ns, max_kernel_ns;
 	u64 tsc_timestamp;
@@ -1172,7 +1171,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	local_irq_restore(flags);
 
-	if (!vcpu->time_page)
+	if (!vcpu->pv_time_enabled)
 		return 0;
 
 	/*
@@ -1230,14 +1229,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 */
 	vcpu->hv_clock.version += 2;
 
-	shared_kaddr = kmap_atomic(vcpu->time_page);
-
-	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
-	       sizeof(vcpu->hv_clock));
-
-	kunmap_atomic(shared_kaddr);
-
-	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
+	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
+				&vcpu->hv_clock,
+				sizeof(vcpu->hv_clock));
 	return 0;
 }
 
@@ -1516,7 +1510,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 		return 0;
 	}
 
-	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa))
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
+					sizeof(u32)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -1526,10 +1521,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.time_page) {
-		kvm_release_page_dirty(vcpu->arch.time_page);
-		vcpu->arch.time_page = NULL;
-	}
+	vcpu->arch.pv_time_enabled = false;
 }
 
 static void accumulate_steal_time(struct kvm_vcpu *vcpu)
@@ -1624,6 +1616,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 	case MSR_KVM_SYSTEM_TIME: {
+		u64 gpa_offset;
 		kvmclock_reset(vcpu);
 
 		vcpu->arch.time = data;
@@ -1633,16 +1626,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (!(data & 1))
 			break;
 
-		/* ...but clean it before doing the actual write */
-		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
+		gpa_offset = data & ~(PAGE_MASK | 1);
 
-		vcpu->arch.time_page =
-				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
-
-		if (is_error_page(vcpu->arch.time_page)) {
-			kvm_release_page_clean(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
-		}
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		     &vcpu->arch.pv_time, data & ~1ULL,
+		     sizeof(struct pvclock_vcpu_time_info)))
+			vcpu->arch.pv_time_enabled = false;
+		else
+			vcpu->arch.pv_time_enabled = true;
 		break;
 	}
 	case MSR_KVM_ASYNC_PF_EN:
@@ -1658,7 +1649,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			return 1;
 
 		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
-							data & KVM_STEAL_VALID_BITS))
+						data & KVM_STEAL_VALID_BITS,
+						sizeof(struct kvm_steal_time)))
 			return 1;
 
 		vcpu->arch.st.msr_val = data;
@@ -2636,7 +2628,7 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 {
 	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
-	if (!vcpu->arch.time_page)
+	if (!vcpu->arch.pv_time_enabled)
 		return -EINVAL;
 	src->flags |= PVCLOCK_GUEST_STOPPED;
 	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
@@ -6232,6 +6224,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask, GFP_KERNEL))
 		goto fail_free_mce_banks;
 
+	vcpu->arch.pv_time_enabled = false;
 	kvm_async_pf_hash_reset(vcpu);
 	kvm_pmu_init(vcpu);
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 642d880..53272bd 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1333,6 +1333,7 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
 	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mmu_mode;
+	pv_mmu_ops.lazy_mode.flush = paravirt_flush_lazy_mmu;
 	pv_mmu_ops.pte_update = lguest_pte_update;
 	pv_mmu_ops.pte_update_defer = lguest_pte_update;
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..3e6b840 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -377,10 +377,12 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (pgd_none(*pgd_ref))
 		return -1;
 
-	if (pgd_none(*pgd))
+	if (pgd_none(*pgd)) {
 		set_pgd(pgd, *pgd_ref);
-	else
+		arch_flush_lazy_mmu_mode();
+	} else {
 		BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
+	}
 
 	/*
 	 * Below here mismatches are bugs because these lower tables
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..eedfeed 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -58,6 +58,13 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
+	/*
+	 * NOTE! For PAE, any changes to the top page-directory-pointer-table
+	 * entries need a full cr3 reload to flush.
+	 */
+#ifdef CONFIG_X86_PAE
+	tlb->need_flush_all = 1;
+#endif
 	tlb_remove_page(tlb, virt_to_page(pmd));
 }
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dde1a3f..d396521 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2079,6 +2079,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_mmu,
 		.leave = xen_leave_lazy_mmu,
+		.flush = paravirt_flush_lazy_mmu,
 	},
 
 	.set_fixmap = xen_set_fixmap,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9628b29..59e77ef 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -207,6 +207,8 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 	unsigned long val;						\
 	ssize_t ret;							\
 	ret = queue_var_store(&val, page, count);			\
+	if (ret < 0)							\
+		 return ret;						\
 	if (neg)							\
 		val = !val;						\
 									\
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index ef5356c..0262210 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -161,6 +161,8 @@ static int hash_recvmsg(struct kiocb *unused, struct socket *sock,
 	else if (len < ds)
 		msg->msg_flags |= MSG_TRUNC;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	if (ctx->more) {
 		ctx->more = 0;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..a1c4f0a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -432,6 +432,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 	long copied = 0;
 
 	lock_sock(sk);
+	msg->msg_namelen = 0;
 	for (iov = msg->msg_iov, iovlen = msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
 		unsigned long seglen = iov->iov_len;
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 1a25263..b97b186 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -44,6 +44,7 @@ struct crypto_rfc4543_ctx {
 
 struct crypto_rfc4543_req_ctx {
 	u8 auth_tag[16];
+	u8 assocbuf[32];
 	struct scatterlist cipher[1];
 	struct scatterlist payload[2];
 	struct scatterlist assoc[2];
@@ -1142,9 +1143,19 @@ static struct aead_request *crypto_rfc4543_crypt(struct aead_request *req,
 	scatterwalk_crypto_chain(payload, dst, vdst == req->iv + 8, 2);
 	assoclen += 8 + req->cryptlen - (enc ? 0 : authsize);
 
-	sg_init_table(assoc, 2);
-	sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
-		    req->assoc->offset);
+	if (req->assoc->length == req->assoclen) {
+		sg_init_table(assoc, 2);
+		sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
+			    req->assoc->offset);
+	} else {
+		BUG_ON(req->assoclen > sizeof(rctx->assocbuf));
+
+		scatterwalk_map_and_copy(rctx->assocbuf, req->assoc, 0,
+					 req->assoclen, 0);
+
+		sg_init_table(assoc, 2);
+		sg_set_buf(assoc, rctx->assocbuf, req->assoclen);
+	}
 	scatterwalk_crypto_chain(assoc, payload, 0, 2);
 
 	aead_request_set_tfm(subreq, ctx->child);
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ef773e1..7bfe093 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -150,6 +150,7 @@ enum piix_controller_ids {
 	tolapai_sata,
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
+	ich8_2port_sata_snb,
 };
 
 struct piix_map_db {
@@ -502,6 +503,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
+	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -643,6 +645,15 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
+	[ich8_2port_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR
+					| PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8e1039c..3e351e7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2413,6 +2413,9 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (dev->horkage & ATA_HORKAGE_MAX_SEC_LBA48)
+		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -4069,6 +4072,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
 	{ "QUANTUM DAT    DAT72-000", NULL,	ATA_HORKAGE_ATAPI_MOD16_DMA },
+	{ "Slimtype DVD A  DS8A8SH", NULL,	ATA_HORKAGE_MAX_SEC_LBA48 },
 
 	/* Devices we expect to fail diagnostics */
 
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e6732cf..79f4fca 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -398,7 +398,7 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 			base = 0;
 
 		if (max < rbnode->base_reg + rbnode->blklen)
-			end = rbnode->base_reg + rbnode->blklen - max;
+			end = max - rbnode->base_reg + 1;
 		else
 			end = rbnode->blklen;
 
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index dfd7876..0ff5c2e 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -373,26 +373,14 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 	struct hpet_dev *devp;
 	unsigned long addr;
 
-	if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
-		return -EINVAL;
-
 	devp = file->private_data;
 	addr = devp->hd_hpets->hp_hpet_phys;
 
 	if (addr & (PAGE_SIZE - 1))
 		return -ENOSYS;
 
-	vma->vm_flags |= VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
-					PAGE_SIZE, vma->vm_page_prot)) {
-		printk(KERN_ERR "%s: io_remap_pfn_range failed\n",
-			__func__);
-		return -EAGAIN;
-	}
-
-	return 0;
+	return vm_iomap_memory(vma, addr, PAGE_SIZE);
 #else
 	return -ENOSYS;
 #endif
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index af2d81e..8cf7a38 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -220,8 +220,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table, policy->cpu);
 
-	locking_frequency = exynos_getspeed(0);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
@@ -285,6 +283,8 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+	locking_frequency = exynos_getspeed(0);
+
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 1c307e1..b8b0497 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1750,7 +1750,7 @@ static struct platform_driver cryp_driver = {
 	.shutdown = ux500_cryp_shutdown,
 	.driver = {
 		.owner = THIS_MODULE,
-		.name  = "cryp1"
+		.name  = "cryp1",
 		.pm    = &ux500_cryp_pm,
 	}
 };
diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index cdae207..6c3fca9 100644
--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -19,10 +19,10 @@
 /* There is only *one* pci_eisa device per machine, right ? */
 static struct eisa_root_device pci_eisa_root;
 
-static int __init pci_eisa_init(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+static int __init pci_eisa_init(struct pci_dev *pdev)
 {
-	int rc;
+	int rc, i;
+	struct resource *res, *bus_res = NULL;
 
 	if ((rc = pci_enable_device (pdev))) {
 		printk (KERN_ERR "pci_eisa : Could not enable device %s\n",
@@ -30,9 +30,30 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
 		return rc;
 	}
 
+	/*
+	 * The Intel 82375 PCI-EISA bridge is a subtractive-decode PCI
+	 * device, so the resources available on EISA are the same as those
+	 * available on the 82375 bus.  This works the same as a PCI-PCI
+	 * bridge in subtractive-decode mode (see pci_read_bridge_bases()).
+	 * We assume other PCI-EISA bridges are similar.
+	 *
+	 * eisa_root_register() can only deal with a single io port resource,
+	*  so we use the first valid io port resource.
+	 */
+	pci_bus_for_each_resource(pdev->bus, res, i)
+		if (res && (res->flags & IORESOURCE_IO)) {
+			bus_res = res;
+			break;
+		}
+
+	if (!bus_res) {
+		dev_err(&pdev->dev, "No resources available\n");
+		return -1;
+	}
+
 	pci_eisa_root.dev              = &pdev->dev;
-	pci_eisa_root.res	       = pdev->bus->resource[0];
-	pci_eisa_root.bus_base_addr    = pdev->bus->resource[0]->start;
+	pci_eisa_root.res	       = bus_res;
+	pci_eisa_root.bus_base_addr    = bus_res->start;
 	pci_eisa_root.slots	       = EISA_MAX_SLOTS;
 	pci_eisa_root.dma_mask         = pdev->dma_mask;
 	dev_set_drvdata(pci_eisa_root.dev, &pci_eisa_root);
@@ -45,22 +66,26 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
 	return 0;
 }
 
-static struct pci_device_id pci_eisa_pci_tbl[] = {
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
-	{ 0, }
-};
+/*
+ * We have to call pci_eisa_init_early() before pnpacpi_init()/isapnp_init().
+ *   Otherwise pnp resource will get enabled early and could prevent eisa
+ *   to be initialized.
+ * Also need to make sure pci_eisa_init_early() is called after
+ * x86/pci_subsys_init().
+ * So need to use subsys_initcall_sync with it.
+ */
+static int __init pci_eisa_init_early(void)
+{
+	struct pci_dev *dev = NULL;
+	int ret;
 
-static struct pci_driver __refdata pci_eisa_driver = {
-	.name		= "pci_eisa",
-	.id_table	= pci_eisa_pci_tbl,
-	.probe		= pci_eisa_init,
-};
+	for_each_pci_dev(dev)
+		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_EISA) {
+			ret = pci_eisa_init(dev);
+			if (ret)
+				return ret;
+		}
 
-static int __init pci_eisa_init_module (void)
-{
-	return pci_register_driver (&pci_eisa_driver);
+	return 0;
 }
-
-device_initcall(pci_eisa_init_module);
-MODULE_DEVICE_TABLE(pci, pci_eisa_pci_tbl);
+subsys_initcall_sync(pci_eisa_init_early);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 379abcb..e7ec168 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7153,6 +7153,15 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer Aspire 5734Z must invert backlight brightness */
 	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
+
+	/* Acer/eMachines G725 */
+	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
+
+	/* Acer/eMachines e725 */
+	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
+
+	/* Acer/Packard Bell NCL20 */
+	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 0a5daaa..fa82ead 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -752,8 +752,6 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 	int i;
 	unsigned char misc = 0;
 	unsigned char ext_vga[6];
-	unsigned char ext_vga_index24;
-	unsigned char dac_index90 = 0;
 	u8 bppshift;
 
 	static unsigned char dacvalue[] = {
@@ -804,7 +802,6 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 		option2 = 0x0000b000;
 		break;
 	case G200_ER:
-		dac_index90 = 0;
 		break;
 	}
 
@@ -853,10 +850,8 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 		WREG_DAC(i, dacvalue[i]);
 	}
 
-	if (mdev->type == G200_ER) {
-		WREG_DAC(0x90, dac_index90);
-	}
-
+	if (mdev->type == G200_ER)
+		WREG_DAC(0x90, 0);
 
 	if (option)
 		pci_write_config_dword(dev->pdev, PCI_MGA_OPTION, option);
@@ -953,8 +948,6 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 	if (mdev->type == G200_WB)
 		ext_vga[1] |= 0x88;
 
-	ext_vga_index24 = 0x05;
-
 	/* Set pixel clocks */
 	misc = 0x2d;
 	WREG8(MGA_MISC_OUT, misc);
@@ -966,7 +959,7 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 	}
 
 	if (mdev->type == G200_ER)
-		WREG_ECRT(24, ext_vga_index24);
+		WREG_ECRT(0x24, 0x5);
 
 	if (mdev->type == G200_EV) {
 		WREG_ECRT(6, 0);
diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index 8d9dc44..2185ed8 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -56,6 +56,10 @@ static int udl_get_modes(struct drm_connector *connector)
 	int ret;
 
 	edid = (struct edid *)udl_get_edid(udl);
+	if (!edid) {
+		drm_mode_connector_update_edid_property(connector, NULL);
+		return 0;
+	}
 
 	connector->display_info.raw_edid = (char *)edid;
 
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index db713c0..461a0d7 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -416,6 +416,8 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "%s: can't power on device\n", __func__);
+		pm_runtime_put_noidle(dev);
+		module_put(dev->driver->owner);
 		return ret;
 	}
 
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index a6e7451..6e3d6dc 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1159,41 +1159,17 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	struct map_info *map = mtd->priv;
-	resource_size_t start, off;
-	unsigned long len, vma_len;
-
-	if (mtd->type == MTD_RAM || mtd->type == MTD_ROM) {
-		off = get_vm_offset(vma);
-		start = map->phys;
-		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);
-		start &= PAGE_MASK;
-		vma_len = get_vm_size(vma);
-
-		/* Overflow in off+len? */
-		if (vma_len + off < off)
-			return -EINVAL;
-		/* Does it fit in the mapping? */
-		if (vma_len + off > len)
-			return -EINVAL;
-
-		off += start;
-		/* Did that overflow? */
-		if (off < start)
-			return -EINVAL;
-		if (set_vm_offset(vma, off) < 0)
-			return -EINVAL;
-		vma->vm_flags |= VM_IO | VM_RESERVED;
 
+        /* This is broken because it assumes the MTD device is map-based
+	   and that mtd->priv is a valid struct map_info.  It should be
+	   replaced with something that uses the mtd_get_unmapped_area()
+	   operation properly. */
+	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
 #ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || off >= __pa(high_memory))
+		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
 			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 #endif
-		if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				       vma->vm_end - vma->vm_start,
-				       vma->vm_page_prot))
-			return -EAGAIN;
-
-		return 0;
+		return vm_iomap_memory(vma, map->phys, map->size);
 	}
 	return -ENOSYS;
 #else
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 83ae683..1a93bab 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1893,6 +1893,7 @@ err_detach:
 	write_unlock_bh(&bond->lock);
 
 err_close:
+	slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_unset_master:
@@ -4876,9 +4877,18 @@ static int __net_init bond_net_init(struct net *net)
 static void __net_exit bond_net_exit(struct net *net)
 {
 	struct bond_net *bn = net_generic(net, bond_net_id);
+	struct bonding *bond, *tmp_bond;
+	LIST_HEAD(list);
 
 	bond_destroy_sysfs(bn);
 	bond_destroy_proc_dir(bn);
+
+	/* Kill off any bonds created after unregistering bond rtnl ops */
+	rtnl_lock();
+	list_for_each_entry_safe(bond, tmp_bond, &bn->dev_list, bond_list)
+		unregister_netdevice_queue(bond->dev, &list);
+	unregister_netdevice_many(&list);
+	rtnl_unlock();
 }
 
 static struct pernet_operations bond_net_ops = {
diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index 26e7129..108d3ef 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -922,6 +922,7 @@ static int mcp251x_open(struct net_device *net)
 	struct mcp251x_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
 	struct mcp251x_platform_data *pdata = spi->dev.platform_data;
+	unsigned long flags;
 	int ret;
 
 	ret = open_candev(net);
@@ -938,9 +939,14 @@ static int mcp251x_open(struct net_device *net)
 	priv->tx_skb = NULL;
 	priv->tx_len = 0;
 
+	flags = IRQF_ONESHOT;
+	if (pdata->irq_flags)
+		flags |= pdata->irq_flags;
+	else
+		flags |= IRQF_TRIGGER_FALLING;
+
 	ret = request_threaded_irq(spi->irq, NULL, mcp251x_can_ist,
-		  pdata->irq_flags ? pdata->irq_flags : IRQF_TRIGGER_FALLING,
-		  DEVICE_NAME, priv);
+				   flags, DEVICE_NAME, priv);
 	if (ret) {
 		dev_err(&spi->dev, "failed to acquire irq %d\n", spi->irq);
 		if (pdata->transceiver_enable)
diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index f2683eb..c505b55 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -94,8 +94,8 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 	struct net_device *dev;
 	struct sja1000_priv *priv;
 	struct resource res;
-	const u32 *prop;
-	int err, irq, res_size, prop_size;
+	u32 prop;
+	int err, irq, res_size;
 	void __iomem *base;
 
 	err = of_address_to_resource(np, 0, &res);
@@ -136,27 +136,27 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 	priv->read_reg = sja1000_ofp_read_reg;
 	priv->write_reg = sja1000_ofp_write_reg;
 
-	prop = of_get_property(np, "nxp,external-clock-frequency", &prop_size);
-	if (prop && (prop_size ==  sizeof(u32)))
-		priv->can.clock.freq = *prop / 2;
+	err = of_property_read_u32(np, "nxp,external-clock-frequency", &prop);
+	if (!err)
+		priv->can.clock.freq = prop / 2;
 	else
 		priv->can.clock.freq = SJA1000_OFP_CAN_CLOCK; /* default */
 
-	prop = of_get_property(np, "nxp,tx-output-mode", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		priv->ocr |= *prop & OCR_MODE_MASK;
+	err = of_property_read_u32(np, "nxp,tx-output-mode", &prop);
+	if (!err)
+		priv->ocr |= prop & OCR_MODE_MASK;
 	else
 		priv->ocr |= OCR_MODE_NORMAL; /* default */
 
-	prop = of_get_property(np, "nxp,tx-output-config", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		priv->ocr |= (*prop << OCR_TX_SHIFT) & OCR_TX_MASK;
+	err = of_property_read_u32(np, "nxp,tx-output-config", &prop);
+	if (!err)
+		priv->ocr |= (prop << OCR_TX_SHIFT) & OCR_TX_MASK;
 	else
 		priv->ocr |= OCR_TX0_PULLDOWN; /* default */
 
-	prop = of_get_property(np, "nxp,clock-out-frequency", &prop_size);
-	if (prop && (prop_size == sizeof(u32)) && *prop) {
-		u32 divider = priv->can.clock.freq * 2 / *prop;
+	err = of_property_read_u32(np, "nxp,clock-out-frequency", &prop);
+	if (!err && prop) {
+		u32 divider = priv->can.clock.freq * 2 / prop;
 
 		if (divider > 1)
 			priv->cdr |= divider / 2 - 1;
@@ -166,8 +166,7 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 		priv->cdr |= CDR_CLK_OFF; /* default */
 	}
 
-	prop = of_get_property(np, "nxp,no-comparator-bypass", NULL);
-	if (!prop)
+	if (!of_property_read_bool(np, "nxp,no-comparator-bypass"))
 		priv->cdr |= CDR_CBP; /* default */
 
 	priv->irq_flags = IRQF_SHARED;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index edfdf6b..b5fd934 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -186,7 +186,7 @@ struct atl1e_tpd_desc {
 /* how about 0x2000 */
 #define MAX_TX_BUF_LEN      0x2000
 #define MAX_TX_BUF_SHIFT    13
-/*#define MAX_TX_BUF_LEN  0x3000 */
+#define MAX_TSO_SEG_SIZE    0x3c00
 
 /* rrs word 1 bit 0:31 */
 #define RRS_RX_CSUM_MASK	0xFFFF
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index b986503..8f6b054 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2333,6 +2333,7 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl1e_link_chg_task);
+	netif_set_gso_max_size(netdev, MAX_TSO_SEG_SIZE);
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_err(netdev, "register netdevice failed\n");
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 440e963..fbc21a9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -301,6 +301,7 @@ static DEFINE_PCI_DEVICE_TABLE(tg3_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_5719)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_5720)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57762)},
+	{PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, TG3PCI_DEVICE_TIGON3_57766)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, PCI_DEVICE_ID_SYSKONNECT_9DXX)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, PCI_DEVICE_ID_SYSKONNECT_9MXX)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ALTIMA, PCI_DEVICE_ID_ALTIMA_AC1000)},
@@ -8784,7 +8785,14 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 		}
 
 		if (GET_CHIP_REV(tp->pci_chip_rev_id) != CHIPREV_57765_AX) {
-			u32 grc_mode = tr32(GRC_MODE);
+			u32 grc_mode;
+
+			/* Fix transmit hangs */
+			val = tr32(TG3_CPMU_PADRNG_CTL);
+			val |= TG3_CPMU_PADRNG_CTL_RDIV2;
+			tw32(TG3_CPMU_PADRNG_CTL, val);
+
+			grc_mode = tr32(GRC_MODE);
 
 			/* Access the lower 1K of DL PCIE block registers. */
 			val = grc_mode & ~GRC_MODE_PCIE_PORT_MASK;
@@ -9088,6 +9096,14 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 	if (tg3_flag(tp, PCI_EXPRESS))
 		rdmac_mode |= RDMAC_MODE_FIFO_LONG_BURST;
 
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_57766) {
+		tp->dma_limit = 0;
+		if (tp->dev->mtu <= ETH_DATA_LEN) {
+			rdmac_mode |= RDMAC_MODE_JMB_2K_MMRR;
+			tp->dma_limit = TG3_TX_BD_DMA_MAX_2K;
+		}
+	}
+
 	if (tg3_flag(tp, HW_TSO_1) ||
 	    tg3_flag(tp, HW_TSO_2) ||
 	    tg3_flag(tp, HW_TSO_3))
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 6d52cb2..3a58339 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -1120,6 +1120,8 @@
 #define  CPMU_MUTEX_GNT_DRIVER		 0x00001000
 #define TG3_CPMU_PHY_STRAP		0x00003664
 #define TG3_CPMU_PHY_STRAP_IS_SERDES	 0x00000020
+#define TG3_CPMU_PADRNG_CTL		0x00003668
+#define  TG3_CPMU_PADRNG_CTL_RDIV2	 0x00040000
 /* 0x3664 --> 0x36b0 unused */
 
 #define TG3_CPMU_EEE_MODE		0x000036b0
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 6c1c396..886b52f 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3827,6 +3827,30 @@ static void __devinit rtl_init_mdio_ops(struct rtl8169_private *tp)
 	}
 }
 
+static void rtl_speed_down(struct rtl8169_private *tp)
+{
+	u32 adv;
+	int lpa;
+
+	rtl_writephy(tp, 0x1f, 0x0000);
+	lpa = rtl_readphy(tp, MII_LPA);
+
+	if (lpa & (LPA_10HALF | LPA_10FULL))
+		adv = ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full;
+	else if (lpa & (LPA_100HALF | LPA_100FULL))
+		adv = ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full |
+		      ADVERTISED_100baseT_Half | ADVERTISED_100baseT_Full;
+	else
+		adv = ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full |
+		      ADVERTISED_100baseT_Half | ADVERTISED_100baseT_Full |
+		      (tp->mii.supports_gmii ?
+		       ADVERTISED_1000baseT_Half |
+		       ADVERTISED_1000baseT_Full : 0);
+
+	rtl8169_set_speed(tp->dev, AUTONEG_ENABLE, SPEED_1000, DUPLEX_FULL,
+			  adv);
+}
+
 static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 {
 	void __iomem *ioaddr = tp->mmio_addr;
@@ -3857,9 +3881,7 @@ static bool rtl_wol_pll_power_down(struct rtl8169_private *tp)
 	if (!(__rtl8169_get_wol(tp) & WAKE_ANY))
 		return false;
 
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, MII_BMCR, 0x0000);
-
+	rtl_speed_down(tp);
 	rtl_wol_suspend_quirk(tp);
 
 	return true;
diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index 6e1915a..c00c13a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -519,7 +519,7 @@ static const u32 ar9580_1p0_mac_core[][2] = {
 	{0x00008258, 0x00000000},
 	{0x0000825c, 0x40000000},
 	{0x00008260, 0x00080922},
-	{0x00008264, 0x9bc00010},
+	{0x00008264, 0x9d400010},
 	{0x00008268, 0xffffffff},
 	{0x0000826c, 0x0000ffff},
 	{0x00008270, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a035a38..01248b9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -774,7 +774,7 @@ static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
 	 * required version.
 	 */
 	if (priv->fw_version_major != MAJOR_VERSION_REQ ||
-	    priv->fw_version_minor != MINOR_VERSION_REQ) {
+	    priv->fw_version_minor < MINOR_VERSION_REQ) {
 		dev_err(priv->dev, "ath9k_htc: Please upgrade to FW version %d.%d\n",
 			MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
 		return -EINVAL;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 914718a..df4a82b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4583,7 +4583,8 @@ static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
-		/* FIXME */
+		ssb_pmu_spuravoid_pllupdate(&dev->dev->sdev->bus->chipco,
+					    avoid);
 		break;
 #endif
 	}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fe42137..b4719ea 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1487,7 +1487,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		}
 	}
 
-	for (i = 0; i < request->n_channels; i++) {
+	for (i = 0; i < min_t(u32, request->n_channels,
+			      MWIFIEX_USER_SCAN_CHAN_MAX); i++) {
 		chan = request->channels[i];
 		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
 		priv->user_scan_cfg->chan_list[i].radio_type = chan->band;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index a0c8cae..b1c673e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -52,8 +52,8 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
-	ERROR(rt2x00dev, "Indirect register access failed: "
-	      "offset=0x%.08x, value=0x%.08x\n", offset, *reg);
+	printk_once(KERN_ERR "%s() Indirect register access failed: "
+	      "offset=0x%.08x, value=0x%.08x\n", __func__, offset, *reg);
 	*reg = ~0;
 
 	return 0;
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index e76b447..8bae295 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -174,14 +174,6 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 #endif /* !PM */
 
 /*
- * PCIe port runtime suspend is broken for some chipsets, so use a
- * black list to disable runtime PM for these chipsets.
- */
-static const struct pci_device_id port_runtime_pm_black_list[] = {
-	{ /* end: all zeroes */ }
-};
-
-/*
  * pcie_portdrv_probe - Probe PCI-Express port devices
  * @dev: PCI-Express port device being probed
  *
@@ -214,16 +206,11 @@ static int __devinit pcie_portdrv_probe(struct pci_dev *dev,
 	 * it by default.
 	 */
 	dev->d3cold_allowed = false;
-	if (!pci_match_id(port_runtime_pm_black_list, dev))
-		pm_runtime_put_noidle(&dev->dev);
-
 	return 0;
 }
 
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
-	if (!pci_match_id(port_runtime_pm_black_list, dev))
-		pm_runtime_get_noresume(&dev->dev);
 	pcie_port_device_remove(dev);
 	pci_disable_device(dev);
 }
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index 2264331..b96766b 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -176,7 +176,7 @@ static void msi_wmi_notify(u32 value, void *context)
 				pr_debug("Suppressed key event 0x%X - "
 					 "Last press was %lld us ago\n",
 					 key->code, ktime_to_us(diff));
-				return;
+				goto msi_wmi_notify_exit;
 			}
 			last_pressed[key->code - SCANCODE_BASE] = cur;
 
@@ -195,6 +195,8 @@ static void msi_wmi_notify(u32 value, void *context)
 			pr_info("Unknown key pressed - %x\n", eventcode);
 	} else
 		pr_info("Unknown event received\n");
+
+msi_wmi_notify_exit:
 	kfree(response.pointer);
 }
 
diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 811ff72..324d84e 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -4,7 +4,7 @@ menu "Remoteproc drivers (EXPERIMENTAL)"
 config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
-	select FW_CONFIG
+	select FW_LOADER
 	select VIRTIO
 
 config OMAP_REMOTEPROC
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 70b296f..cf68afb 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -342,10 +342,12 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* it is now safe to add the virtio device */
 	ret = rproc_add_virtio_dev(rvdev, rsc->id);
 	if (ret)
-		goto free_rvdev;
+		goto remove_rvdev;
 
 	return 0;
 
+remove_rvdev:
+	list_del(&rvdev->node);
 free_rvdev:
 	kfree(rvdev);
 	return ret;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index efc6e72..fbb8048 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -235,6 +235,17 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	linkrate  = phy->linkrate;
 	memcpy(sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 
+	/* Handle vacant phy - rest of dr data is not valid so skip it */
+	if (phy->phy_state == PHY_VACANT) {
+		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+		phy->attached_dev_type = NO_DEVICE;
+		if (!test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
+			phy->phy_id = phy_id;
+			goto skip;
+		} else
+			goto out;
+	}
+
 	phy->attached_dev_type = to_dev_type(dr);
 	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state))
 		goto out;
@@ -272,6 +283,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->phy->maximum_linkrate = dr->pmax_linkrate;
 	phy->phy->negotiated_linkrate = phy->linkrate;
 
+ skip:
 	if (new_phy)
 		if (sas_phy_add(phy->phy)) {
 			sas_phy_free(phy->phy);
diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 4c63f77..2e2b04f 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -164,7 +164,7 @@ static int mpc512x_psc_spi_transfer_rxtx(struct spi_device *spi,
 
 		for (i = count; i > 0; i--) {
 			data = tx_buf ? *tx_buf++ : 0;
-			if (len == EOFBYTE)
+			if (len == EOFBYTE && t->cs_change)
 				setbits32(&fifo->txcmd, MPC512x_PSC_FIFO_EOF);
 			out_8(&fifo->txdata_8, data);
 			len--;
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index d1c8441f..59b4a3b 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -997,25 +997,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq, void *data)
 {
 	struct s3c64xx_spi_driver_data *sdd = data;
 	struct spi_master *spi = sdd->master;
-	unsigned int val;
+	unsigned int val, clr = 0;
 
-	val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
+	val = readl(sdd->regs + S3C64XX_SPI_STATUS);
 
-	val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
-		S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
-		S3C64XX_SPI_PND_TX_OVERRUN_CLR |
-		S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
-
-	writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
-
-	if (val & S3C64XX_SPI_PND_RX_OVERRUN_CLR)
+	if (val & S3C64XX_SPI_ST_RX_OVERRUN_ERR) {
+		clr = S3C64XX_SPI_PND_RX_OVERRUN_CLR;
 		dev_err(&spi->dev, "RX overrun\n");
-	if (val & S3C64XX_SPI_PND_RX_UNDERRUN_CLR)
+	}
+	if (val & S3C64XX_SPI_ST_RX_UNDERRUN_ERR) {
+		clr |= S3C64XX_SPI_PND_RX_UNDERRUN_CLR;
 		dev_err(&spi->dev, "RX underrun\n");
-	if (val & S3C64XX_SPI_PND_TX_OVERRUN_CLR)
+	}
+	if (val & S3C64XX_SPI_ST_TX_OVERRUN_ERR) {
+		clr |= S3C64XX_SPI_PND_TX_OVERRUN_CLR;
 		dev_err(&spi->dev, "TX overrun\n");
-	if (val & S3C64XX_SPI_PND_TX_UNDERRUN_CLR)
+	}
+	if (val & S3C64XX_SPI_ST_TX_UNDERRUN_ERR) {
+		clr |= S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
 		dev_err(&spi->dev, "TX underrun\n");
+	}
+
+	/* Clear the pending irq by setting and then clearing it */
+	writel(clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
+	writel(0, sdd->regs + S3C64XX_SPI_PENDING_CLR);
 
 	return IRQ_HANDLED;
 }
@@ -1039,9 +1044,13 @@ static void s3c64xx_spi_hwinit(struct s3c64xx_spi_driver_data *sdd, int channel)
 	writel(0, regs + S3C64XX_SPI_MODE_CFG);
 	writel(0, regs + S3C64XX_SPI_PACKET_CNT);
 
-	/* Clear any irq pending bits */
-	writel(readl(regs + S3C64XX_SPI_PENDING_CLR),
-				regs + S3C64XX_SPI_PENDING_CLR);
+	/* Clear any irq pending bits, should set and clear the bits */
+	val = S3C64XX_SPI_PND_RX_OVERRUN_CLR |
+		S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
+		S3C64XX_SPI_PND_TX_OVERRUN_CLR |
+		S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
+	writel(val, regs + S3C64XX_SPI_PENDING_CLR);
+	writel(0, regs + S3C64XX_SPI_PENDING_CLR);
 
 	writel(0, regs + S3C64XX_SPI_SWAP_CFG);
 
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index b58fef7..1fb9b22 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -645,3 +645,32 @@ u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc)
 		return 0;
 	}
 }
+
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid)
+{
+	u32 pmu_ctl = 0;
+
+	switch (cc->dev->bus->chip_id) {
+	case 0x4322:
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL0, 0x11100070);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL1, 0x1014140a);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL5, 0x88888854);
+		if (spuravoid == 1)
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05201828);
+		else
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05001828);
+		pmu_ctl = SSB_CHIPCO_PMU_CTL_PLL_UPD;
+		break;
+	case 43222:
+		/* TODO: BCM43222 requires updating PLLs too */
+		return;
+	default:
+		ssb_printk(KERN_ERR PFX
+			   "Unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
+			   cc->dev->bus->chip_id);
+		return;
+	}
+
+	chipco_set32(cc, SSB_CHIPCO_PMU_CTL, pmu_ctl);
+}
+EXPORT_SYMBOL_GPL(ssb_pmu_spuravoid_pllupdate);
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 41641ba..61077ce 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -420,6 +420,7 @@ static inline int core_alua_state_standby(
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -462,6 +463,7 @@ static inline int core_alua_state_unavailable(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -502,6 +504,7 @@ static inline int core_alua_state_transition(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 2ab31e4..03d203f 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1518,6 +1518,7 @@ static int __init thermal_init(void)
 		idr_destroy(&thermal_cdev_idr);
 		mutex_destroy(&thermal_idr_lock);
 		mutex_destroy(&thermal_list_lock);
+		return result;
 	}
 	result = genetlink_init();
 	return result;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..95a37fa 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -939,6 +939,14 @@ void start_tty(struct tty_struct *tty)
 
 EXPORT_SYMBOL(start_tty);
 
+static void tty_update_time(struct timespec *time)
+{
+	unsigned long sec = get_seconds();
+	sec -= sec % 60;
+	if ((long)(sec - time->tv_sec) > 0)
+		time->tv_sec = sec;
+}
+
 /**
  *	tty_read	-	read method for tty device files
  *	@file: pointer to tty file
@@ -975,8 +983,10 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
+
 	if (i > 0)
-		inode->i_atime = current_fs_time(inode->i_sb);
+		tty_update_time(&inode->i_atime);
+
 	return i;
 }
 
@@ -1079,7 +1089,7 @@ static inline ssize_t do_tty_write(
 	}
 	if (written) {
 		struct inode *inode = file->f_path.dentry->d_inode;
-		inode->i_mtime = current_fs_time(inode->i_sb);
+		tty_update_time(&inode->i_mtime);
 		ret = written;
 	}
 out:
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6968b72..cdaaa25 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -315,6 +315,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
 			size_t size;
+			int max = vfio_pci_get_irq_count(vdev, hdr.index);
 
 			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
 				size = sizeof(uint8_t);
@@ -324,7 +325,7 @@ static long vfio_pci_ioctl(void *device_data,
 				return -EINVAL;
 
 			if (hdr.argsz - minsz < hdr.count * size ||
-			    hdr.count > vfio_pci_get_irq_count(vdev, hdr.index))
+			    hdr.start >= max || hdr.start + hdr.count > max)
 				return -EINVAL;
 
 			data = kmalloc(hdr.count * size, GFP_KERNEL);
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0dff12a..edf5b2d 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1371,15 +1371,12 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct fb_info *info = file_fb_info(file);
 	struct fb_ops *fb;
-	unsigned long off;
+	unsigned long mmio_pgoff;
 	unsigned long start;
 	u32 len;
 
 	if (!info)
 		return -ENODEV;
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
-		return -EINVAL;
-	off = vma->vm_pgoff << PAGE_SHIFT;
 	fb = info->fbops;
 	if (!fb)
 		return -ENODEV;
@@ -1391,33 +1388,24 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 		return res;
 	}
 
-	/* frame buffer memory */
+	/*
+	 * Ugh. This can be either the frame buffer mapping, or
+	 * if pgoff points past it, the mmio mapping.
+	 */
 	start = info->fix.smem_start;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.smem_len);
-	if (off >= len) {
-		/* memory mapped io */
-		off -= len;
-		if (info->var.accel_flags) {
-			mutex_unlock(&info->mm_lock);
-			return -EINVAL;
-		}
+	len = info->fix.smem_len;
+	mmio_pgoff = PAGE_ALIGN((start & ~PAGE_MASK) + len) >> PAGE_SHIFT;
+	if (vma->vm_pgoff >= mmio_pgoff) {
+		vma->vm_pgoff -= mmio_pgoff;
 		start = info->fix.mmio_start;
-		len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
+		len = info->fix.mmio_len;
 	}
 	mutex_unlock(&info->mm_lock);
-	start &= PAGE_MASK;
-	if ((vma->vm_end - vma->vm_start + off) > len)
-		return -EINVAL;
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-	/* This is an IO map - tell maydump to skip this VMA */
-	vma->vm_flags |= VM_IO | VM_RESERVED;
+
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-	fb_pgprotect(file, vma, off);
-	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		return -EAGAIN;
-	return 0;
+	fb_pgprotect(file, vma, start);
+
+	return vm_iomap_memory(vma, start, len);
 }
 
 static int
diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..ed762ae 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1027,9 +1027,9 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	kunmap_atomic(ring);
 	return ret;
 }
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index d814a5d..d9eb32e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -315,6 +315,7 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 	unsigned long src_ptr;
 	unsigned long dst_ptr;
 	int overwrite_root = 0;
+	bool inode_item = key->type == BTRFS_INODE_ITEM_KEY;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
 		overwrite_root = 1;
@@ -324,6 +325,9 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 
 	/* look for the key in the destination tree */
 	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+
 	if (ret == 0) {
 		char *src_copy;
 		char *dst_copy;
@@ -365,6 +369,30 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 			return 0;
 		}
 
+		/*
+		 * We need to load the old nbytes into the inode so when we
+		 * replay the extents we've logged we get the right nbytes.
+		 */
+		if (inode_item) {
+			struct btrfs_inode_item *item;
+			u64 nbytes;
+
+			item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					      struct btrfs_inode_item);
+			nbytes = btrfs_inode_nbytes(path->nodes[0], item);
+			item = btrfs_item_ptr(eb, slot,
+					      struct btrfs_inode_item);
+			btrfs_set_inode_nbytes(eb, item, nbytes);
+		}
+	} else if (inode_item) {
+		struct btrfs_inode_item *item;
+
+		/*
+		 * New inode, set nbytes to 0 so that the nbytes comes out
+		 * properly when we replay the extents.
+		 */
+		item = btrfs_item_ptr(eb, slot, struct btrfs_inode_item);
+		btrfs_set_inode_nbytes(eb, item, 0);
 	}
 insert:
 	btrfs_release_path(path);
@@ -486,7 +514,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	u64 extent_end;
 	u64 alloc_hint;
 	u64 start = key->offset;
-	u64 saved_nbytes;
+	u64 nbytes = 0;
 	struct btrfs_file_extent_item *item;
 	struct inode *inode = NULL;
 	unsigned long size;
@@ -496,10 +524,19 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	found_type = btrfs_file_extent_type(eb, item);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
-	    found_type == BTRFS_FILE_EXTENT_PREALLOC)
-		extent_end = start + btrfs_file_extent_num_bytes(eb, item);
-	else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
+	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		nbytes = btrfs_file_extent_num_bytes(eb, item);
+		extent_end = start + nbytes;
+
+		/*
+		 * We don't add to the inodes nbytes if we are prealloc or a
+		 * hole.
+		 */
+		if (btrfs_file_extent_disk_bytenr(eb, item) == 0)
+			nbytes = 0;
+	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size = btrfs_file_extent_inline_len(eb, item);
+		nbytes = btrfs_file_extent_ram_bytes(eb, item);
 		extent_end = (start + size + mask) & ~mask;
 	} else {
 		ret = 0;
@@ -548,7 +585,6 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, inode, start, extent_end,
 				 &alloc_hint, 1);
@@ -636,7 +672,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 	}
 
-	inode_set_bytes(inode, saved_nbytes);
+	inode_add_bytes(inode, nbytes);
 	ret = btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b39bb4a..487db09 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1489,14 +1489,24 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			}
 			break;
 		case Opt_blank_pass:
-			vol->password = NULL;
-			break;
-		case Opt_pass:
 			/* passwords have to be handled differently
 			 * to allow the character used for deliminator
 			 * to be passed within them
 			 */
 
+			/*
+			 * Check if this is a case where the  password
+			 * starts with a delimiter
+			 */
+			tmp_end = strchr(data, '=');
+			tmp_end++;
+			if (!(tmp_end < end && tmp_end[1] == delim)) {
+				/* No it is not. Set the password to NULL */
+				vol->password = NULL;
+				break;
+			}
+			/* Yes it is. Drop down to Opt_pass below.*/
+		case Opt_pass:
 			/* Obtain the value string */
 			value = strchr(data, '=');
 			value++;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 07cc71f..fa44697 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -926,8 +926,11 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 		cmd = F_SETLK;
 		fl->fl_type = F_UNLCK;
 	}
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
+		if (fl->fl_type == F_UNLCK)
+			posix_lock_file_wait(file, fl);
 		return -EIO;
+	}
 	if (IS_GETLK(cmd))
 		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
 	else if (fl->fl_type == F_UNLCK)
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 5849e3e..32b12e5 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -517,7 +517,7 @@ void hfsplus_file_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
+		loff_t size = inode->i_size;
 
 		res = pagecache_write_begin(NULL, mapping, size, 0,
 						AOP_FLAG_UNINTERRUPTIBLE,
diff --git a/fs/inode.c b/fs/inode.c
index 7c14897..d76b46f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -725,7 +725,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 		 * inode to the back of the list so we don't spin on it.
 		 */
 		if (!spin_trylock(&inode->i_lock)) {
-			list_move_tail(&inode->i_lru, &sb->s_inode_lru);
+			list_move(&inode->i_lru, &sb->s_inode_lru);
 			continue;
 		}
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 71a197f..c39f275 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1576,6 +1576,12 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	c->remounting_rw = 1;
 	c->ro_mount = 0;
 
+	if (c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			return err;
+	}
+
 	err = check_free_space(c);
 	if (err)
 		goto out;
@@ -1692,12 +1698,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 		err = dbg_check_space_info(c);
 	}
 
-	if (c->space_fixup) {
-		err = ubifs_fixup_free_space(c);
-		if (err)
-			goto out;
-	}
-
 	mutex_unlock(&c->umount_mutex);
 	return err;
 
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index ed6642a..54d2a6a 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -91,7 +91,12 @@ struct mmu_gather {
 	unsigned int		need_flush : 1,	/* Did free PTEs */
 				fast_mode  : 1; /* No batching   */
 
-	unsigned int		fullmm;
+	/* we are in the middle of an operation to clear
+	 * a full mm and can make some optimizations */
+	unsigned int		fullmm : 1,
+	/* we have performed an operation which
+	 * requires a complete flush of the tlb */
+				need_flush_all : 1;
 
 	struct mmu_gather_batch *active;
 	struct mmu_gather_batch	local;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 5713d3a..b07e008 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -938,7 +938,7 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 	}
 }
 
-static inline bool atapi_command_packet_set(const u16 *dev_id)
+static inline int atapi_command_packet_set(const u16 *dev_id)
 {
 	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
diff --git a/include/linux/capability.h b/include/linux/capability.h
index d10b7ed..19e11d4 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -377,6 +377,7 @@ struct cpu_vfs_cap_data {
 
 #ifdef __KERNEL__
 
+struct file;
 struct inode;
 struct dentry;
 struct user_namespace;
@@ -553,6 +554,7 @@ extern bool capable(int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
 extern bool nsown_capable(int cap);
 extern bool inode_capable(const struct inode *inode, int cap);
+extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
 
 /* audit system wants to get cap info from files as well */
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 55e6d63..fee0238 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -305,7 +305,6 @@ ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int origin);
 int ftrace_regex_release(struct inode *inode, struct file *file);
 
 void __init
@@ -429,6 +428,8 @@ static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
+
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
 
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 65af688..4972e6e 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -111,4 +111,25 @@ static inline int kref_put_mutex(struct kref *kref,
 	}
 	return 0;
 }
+
+/**
+ * kref_get_unless_zero - Increment refcount for object unless it is zero.
+ * @kref: object.
+ *
+ * Return non-zero if the increment succeeded. Otherwise return 0.
+ *
+ * This function is intended to simplify locking around refcounting for
+ * objects that can be looked up from a lookup structure, and which are
+ * removed from that lookup structure in the object destructor.
+ * Operations on such objects require at least a read lock around
+ * lookup + kref_get, and a write lock around kref_put + remove from lookup
+ * structure. Furthermore, RCU implementations become extremely tricky.
+ * With a lookup followed by a kref_get_unless_zero *with return value check*
+ * locking in the kref_put path can be deferred to the actual removal from
+ * the lookup structure and RCU lookups become trivial.
+ */
+static inline int __must_check kref_get_unless_zero(struct kref *kref)
+{
+	return atomic_add_unless(&kref->refcount, 1, 0);
+}
 #endif /* _KREF_H_ */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b70b48b..5a0fa66 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -456,7 +456,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
-			      gpa_t gpa);
+			      gpa_t gpa, unsigned long len);
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index fa7cc72..b0bcce0 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -71,6 +71,7 @@ struct gfn_to_hva_cache {
 	u64 generation;
 	gpa_t gpa;
 	unsigned long hva;
+	unsigned long len;
 	struct kvm_memory_slot *memslot;
 };
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 64f90e1..f216f6b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -395,6 +395,7 @@ enum {
 	ATA_HORKAGE_NOSETXFER	= (1 << 14),	/* skip SETXFER, SATA only */
 	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
 	ATA_HORKAGE_DUMP_ID	= (1 << 16),	/* dump IDENTIFY data */
+	ATA_HORKAGE_MAX_SEC_LBA48 = (1 << 17),	/* Set max sects to 65535 */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 311be90..a8a3df0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1534,6 +1534,8 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
+
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b91c93b..e50d832 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -233,9 +233,9 @@ struct netdev_hw_addr {
 #define NETDEV_HW_ADDR_T_SLAVE		3
 #define NETDEV_HW_ADDR_T_UNICAST	4
 #define NETDEV_HW_ADDR_T_MULTICAST	5
-	bool			synced;
 	bool			global_use;
 	int			refcount;
+	int			synced;
 	struct rcu_head		rcu_head;
 };
 
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 5a710b9..87a03c7 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -93,14 +93,20 @@ do { \
 
 #else /* !CONFIG_PREEMPT_COUNT */
 
-#define preempt_disable()		do { } while (0)
-#define sched_preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable()		do { } while (0)
-
-#define preempt_disable_notrace()		do { } while (0)
-#define preempt_enable_no_resched_notrace()	do { } while (0)
-#define preempt_enable_notrace()		do { } while (0)
+/*
+ * Even if we don't have any preemption, we need preempt disable/enable
+ * to be barriers, so that we don't have things like get_user/put_user
+ * that can cause faults and scheduling migrate into our preempt-protected
+ * region.
+ */
+#define preempt_disable()		barrier()
+#define sched_preempt_enable_no_resched()	barrier()
+#define preempt_enable_no_resched()	barrier()
+#define preempt_enable()		barrier()
+
+#define preempt_disable_notrace()		barrier()
+#define preempt_enable_no_resched_notrace()	barrier()
+#define preempt_enable_notrace()		barrier()
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
diff --git a/include/linux/socket.h b/include/linux/socket.h
index ba7b2e8..9b9b3cb 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -317,7 +317,8 @@ struct ucred {
 /* IPX options */
 #define IPX_TYPE	1
 
-extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
+extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred,
+			  bool use_effective);
 
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index a26e2fb..e2369c1 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -16,7 +16,10 @@
  * In the debug case, 1 means unlocked, 0 means locked. (the values
  * are inverted, to catch initialization bugs)
  *
- * No atomicity anywhere, we are on UP.
+ * No atomicity anywhere, we are on UP. However, we still need
+ * the compiler barriers, because we do not want the compiler to
+ * move potentially faulting instructions (notably user accesses)
+ * into the locked sequence, resulting in non-atomic execution.
  */
 
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -25,6 +28,7 @@
 static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	lock->slock = 0;
+	barrier();
 }
 
 static inline void
@@ -32,6 +36,7 @@ arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	local_irq_save(flags);
 	lock->slock = 0;
+	barrier();
 }
 
 static inline int arch_spin_trylock(arch_spinlock_t *lock)
@@ -39,32 +44,34 @@ static inline int arch_spin_trylock(arch_spinlock_t *lock)
 	char oldval = lock->slock;
 
 	lock->slock = 0;
+	barrier();
 
 	return oldval > 0;
 }
 
 static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
+	barrier();
 	lock->slock = 1;
 }
 
 /*
  * Read-write spinlocks. No debug version.
  */
-#define arch_read_lock(lock)		do { (void)(lock); } while (0)
-#define arch_write_lock(lock)		do { (void)(lock); } while (0)
-#define arch_read_trylock(lock)	({ (void)(lock); 1; })
-#define arch_write_trylock(lock)	({ (void)(lock); 1; })
-#define arch_read_unlock(lock)		do { (void)(lock); } while (0)
-#define arch_write_unlock(lock)	do { (void)(lock); } while (0)
+#define arch_read_lock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_write_lock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_read_trylock(lock)	({ barrier(); (void)(lock); 1; })
+#define arch_write_trylock(lock)	({ barrier(); (void)(lock); 1; })
+#define arch_read_unlock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_write_unlock(lock)	do { barrier(); (void)(lock); } while (0)
 
 #else /* DEBUG_SPINLOCK */
 #define arch_spin_is_locked(lock)	((void)(lock), 0)
 /* for sched.c and kernel_lock.c: */
-# define arch_spin_lock(lock)		do { (void)(lock); } while (0)
-# define arch_spin_lock_flags(lock, flags)	do { (void)(lock); } while (0)
-# define arch_spin_unlock(lock)	do { (void)(lock); } while (0)
-# define arch_spin_trylock(lock)	({ (void)(lock); 1; })
+# define arch_spin_lock(lock)		do { barrier(); (void)(lock); } while (0)
+# define arch_spin_lock_flags(lock, flags)	do { barrier(); (void)(lock); } while (0)
+# define arch_spin_unlock(lock)	do { barrier(); (void)(lock); } while (0)
+# define arch_spin_trylock(lock)	({ barrier(); (void)(lock); 1; })
 #endif /* DEBUG_SPINLOCK */
 
 #define arch_spin_is_contended(lock)	(((void)(lock), 0))
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index 1a6b004..29ce7e4 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -219,6 +219,7 @@
 #define SSB_CHIPCO_PMU_CTL			0x0600 /* PMU control */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV		0xFFFF0000 /* ILP div mask */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV_SHIFT	16
+#define  SSB_CHIPCO_PMU_CTL_PLL_UPD		0x00000400
 #define  SSB_CHIPCO_PMU_CTL_NOILPONW		0x00000200 /* No ILP on wait */
 #define  SSB_CHIPCO_PMU_CTL_HTREQEN		0x00000100 /* HT req enable */
 #define  SSB_CHIPCO_PMU_CTL_ALPREQEN		0x00000080 /* ALP req enable */
@@ -661,5 +662,6 @@ enum ssb_pmu_ldo_volt_id {
 void ssb_pmu_set_ldo_voltage(struct ssb_chipcommon *cc,
 			     enum ssb_pmu_ldo_volt_id id, u32 voltage);
 void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on);
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid);
 
 #endif /* LINUX_SSB_CHIPCO_H_ */
diff --git a/include/net/scm.h b/include/net/scm.h
index 7dc0854..5e1c8d2 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -49,7 +49,7 @@ static __inline__ void scm_set_cred(struct scm_cookie *scm,
 {
 	scm->pid  = get_pid(pid);
 	scm->cred = cred ? get_cred(cred) : NULL;
-	cred_to_ucred(pid, cred, &scm->creds);
+	cred_to_ucred(pid, cred, &scm->creds, false);
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
diff --git a/kernel/capability.c b/kernel/capability.c
index 493d972..f6c2ce5 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -393,6 +393,30 @@ bool ns_capable(struct user_namespace *ns, int cap)
 EXPORT_SYMBOL(ns_capable);
 
 /**
+ * file_ns_capable - Determine if the file's opener had a capability in effect
+ * @file:  The file we want to check
+ * @ns:  The usernamespace we want the capability in
+ * @cap: The capability to be tested for
+ *
+ * Return true if task that opened the file had a capability in effect
+ * when the file was opened.
+ *
+ * This does not set PF_SUPERPRIV because the caller may not
+ * actually be privileged.
+ */
+bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap)
+{
+	if (WARN_ON_ONCE(!cap_valid(cap)))
+		return false;
+
+	if (security_capable(file->f_cred, ns, cap) == 0)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(file_ns_capable);
+
+/**
  * capable - Determine if the current task has a superior capability in effect
  * @cap: The capability to be tested for
  *
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7fee567..44b3539 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5131,7 +5131,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..1c5ab31 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -61,6 +61,7 @@
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
 
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
 	.clock_base =
 	{
 		{
@@ -1640,8 +1641,6 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	raw_spin_lock_init(&cpu_base->lock);
-
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 		timerqueue_init_head(&cpu_base->clock_base[i].active);
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c685e31..c3ae144 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -176,10 +176,36 @@ static u64 sched_clock_remote(struct sched_clock_data *scd)
 	u64 this_clock, remote_clock;
 	u64 *ptr, old_val, val;
 
+#if BITS_PER_LONG != 64
+again:
+	/*
+	 * Careful here: The local and the remote clock values need to
+	 * be read out atomic as we need to compare the values and
+	 * then update either the local or the remote side. So the
+	 * cmpxchg64 below only protects one readout.
+	 *
+	 * We must reread via sched_clock_local() in the retry case on
+	 * 32bit as an NMI could use sched_clock_local() via the
+	 * tracer and hit between the readout of
+	 * the low32bit and the high 32bit portion.
+	 */
+	this_clock = sched_clock_local(my_scd);
+	/*
+	 * We must enforce atomic readout on 32bit, otherwise the
+	 * update on the remote cpu can hit inbetween the readout of
+	 * the low32bit and the high 32bit portion.
+	 */
+	remote_clock = cmpxchg64(&scd->clock, 0, 0);
+#else
+	/*
+	 * On 64bit the read of [my]scd->clock is atomic versus the
+	 * update, so we can avoid the above 32bit dance.
+	 */
 	sched_clock_local(my_scd);
 again:
 	this_clock = my_scd->clock;
 	remote_clock = scd->clock;
+#endif
 
 	/*
 	 * Use the opportunity that we have both locks
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1a48cdb..2f88246 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1651,8 +1651,10 @@ static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
 
-	BUG_ON(rq != this_rq());
-	BUG_ON(p == current);
+	if (WARN_ON_ONCE(rq != this_rq()) ||
+	    WARN_ON_ONCE(p == current))
+		return;
+
 	lockdep_assert_held(&rq->lock);
 
 	if (!raw_spin_trylock(&p->pi_lock)) {
diff --git a/kernel/signal.c b/kernel/signal.c
index be4f856..6b9b817 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2898,7 +2898,7 @@ do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 
 static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
-	struct siginfo info;
+	struct siginfo info = {};
 
 	info.si_signo = sig;
 	info.si_errno = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index 909148a..61c086b7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -323,7 +323,6 @@ void kernel_restart_prepare(char *cmd)
 	system_state = SYSTEM_RESTART;
 	usermodehelper_disable();
 	device_shutdown();
-	syscore_shutdown();
 }
 
 /**
@@ -369,6 +368,7 @@ void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
 	disable_nonboot_cpus();
+	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
@@ -394,6 +394,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
+	disable_nonboot_cpus();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c27095d..d5525eb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -642,7 +642,6 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 
@@ -2510,7 +2509,7 @@ static void ftrace_filter_reset(struct ftrace_hash *hash)
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_regex_lseek() should be used as the lseek routine, and
+ * ftrace_filter_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -2595,7 +2594,7 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
 }
 
 loff_t
-ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
+ftrace_filter_lseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t ret;
 
@@ -3414,7 +3413,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3422,7 +3421,7 @@ static const struct file_operations ftrace_notrace_fops = {
 	.open = ftrace_notrace_open,
 	.read = seq_read,
 	.write = ftrace_notrace_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3627,8 +3626,8 @@ static const struct file_operations ftrace_graph_fops = {
 	.open		= ftrace_graph_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_graph_release,
-	.llseek		= seq_lseek,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
@@ -4237,7 +4236,7 @@ static const struct file_operations ftrace_pid_fops = {
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_pid_release,
 };
 
@@ -4353,12 +4352,8 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 		ftrace_startup_sysctl();
 
 		/* we are starting ftrace again */
-		if (ftrace_ops_list != &ftrace_list_end) {
-			if (ftrace_ops_list->next == &ftrace_list_end)
-				ftrace_trace_function = ftrace_ops_list->func;
-			else
-				ftrace_trace_function = ftrace_ops_list_func;
-		}
+		if (ftrace_ops_list != &ftrace_list_end)
+			update_ftrace_function();
 
 	} else {
 		/* stopping ftrace calls (just send to ftrace_stub) */
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index d4545f4..aa4270a 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -324,7 +324,7 @@ static const struct file_operations stack_trace_filter_fops = {
 	.open = stack_trace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
diff --git a/lib/kobject.c b/lib/kobject.c
index e07ee1f..a654866 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -529,6 +529,13 @@ struct kobject *kobject_get(struct kobject *kobj)
 	return kobj;
 }
 
+static struct kobject *kobject_get_unless_zero(struct kobject *kobj)
+{
+	if (!kref_get_unless_zero(&kobj->kref))
+		kobj = NULL;
+	return kobj;
+}
+
 /*
  * kobject_cleanup - free kobject resources.
  * @kobj: object to cleanup
@@ -751,7 +758,7 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 
 	list_for_each_entry(k, &kset->list, entry) {
 		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
-			ret = kobject_get(k);
+			ret = kobject_get_unless_zero(k);
 			break;
 		}
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 651d1ab..0bf06e9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2963,7 +2963,17 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			break;
 		}
 
-		if (absent ||
+		/*
+		 * We need call hugetlb_fault for both hugepages under migration
+		 * (in which case hugetlb_fault waits for the migration,) and
+		 * hwpoisoned hugepages (in which case we need to prevent the
+		 * caller from accessing to them.) In order to do this, we use
+		 * here is_swap_pte instead of is_hugetlb_entry_migration and
+		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
+		 * both cases, and because we can't follow correct pages
+		 * directly from any kind of swap entries.
+		 */
+		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
 		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
diff --git a/mm/memory.c b/mm/memory.c
index 5736170..06ff7fb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -206,6 +206,7 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 	tlb->mm = mm;
 
 	tlb->fullmm     = fullmm;
+	tlb->need_flush_all = 0;
 	tlb->start	= -1UL;
 	tlb->end	= 0;
 	tlb->need_flush = 0;
@@ -2341,6 +2342,53 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
+/**
+ * vm_iomap_memory - remap memory to userspace
+ * @vma: user vma to map to
+ * @start: start of area
+ * @len: size of area
+ *
+ * This is a simplified io_remap_pfn_range() for common driver use. The
+ * driver just needs to give us the physical memory range to be mapped,
+ * we'll figure out the rest from the vma information.
+ *
+ * NOTE! Some drivers might want to tweak vma->vm_page_prot first to get
+ * whatever write-combining details or similar.
+ */
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
+{
+	unsigned long vm_len, pfn, pages;
+
+	/* Check that the physical memory area passed in looks valid */
+	if (start + len < start)
+		return -EINVAL;
+	/*
+	 * You *really* shouldn't map things that aren't page-aligned,
+	 * but we've historically allowed it because IO memory might
+	 * just have smaller alignment.
+	 */
+	len += start & ~PAGE_MASK;
+	pfn = start >> PAGE_SHIFT;
+	pages = (len + ~PAGE_MASK) >> PAGE_SHIFT;
+	if (pfn + pages < pfn)
+		return -EINVAL;
+
+	/* We start the mapping 'vm_pgoff' pages into the area */
+	if (vma->vm_pgoff > pages)
+		return -EINVAL;
+	pfn += vma->vm_pgoff;
+	pages -= vma->vm_pgoff;
+
+	/* Can we fit all of the mapping? */
+	vm_len = vma->vm_end - vma->vm_start;
+	if (vm_len >> PAGE_SHIFT > pages)
+		return -EINVAL;
+
+	/* Ok, let it rip */
+	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_iomap_memory);
+
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
 				     pte_fn_t fn, void *data)
diff --git a/mm/mmap.c b/mm/mmap.c
index ae18a48..cf6434e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1611,7 +1611,7 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 
 	/* Check the cache first. */
 	/* (Cache hit rate is typically around 35%.) */
-	vma = mm->mmap_cache;
+	vma = ACCESS_ONCE(mm->mmap_cache);
 	if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
 		struct rb_node *rb_node;
 
diff --git a/mm/nommu.c b/mm/nommu.c
index d4b0c10..a60db99 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -807,7 +807,7 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 	struct vm_area_struct *vma;
 
 	/* check the cache first */
-	vma = mm->mmap_cache;
+	vma = ACCESS_ONCE(mm->mmap_cache);
 	if (vma && vma->vm_start <= addr && vma->vm_end > addr)
 		return vma;
 
diff --git a/net/atm/common.c b/net/atm/common.c
index 0c0ad93..f0a9b7e 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -520,6 +520,8 @@ int vcc_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb;
 	int copied, error = -EINVAL;
 
+	msg->msg_namelen = 0;
+
 	if (sock->state != SS_CONNECTED)
 		return -ENOTCONN;
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 779095d..d53a123 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1647,6 +1647,7 @@ static int ax25_recvmsg(struct kiocb *iocb, struct socket *sock,
 		ax25_address src;
 		const unsigned char *mac = skb_mac_header(skb);
 
+		memset(sax, 0, sizeof(struct full_sockaddr_ax25));
 		ax25_addr_parse(mac + 1, skb->data - mac - 1, &src, NULL,
 				&digi, NULL, NULL);
 		sax->sax25_family = AF_AX25;
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index f7db579..1801db0 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -229,6 +229,8 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -236,8 +238,6 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 		return err;
 	}
 
-	msg->msg_namelen = 0;
-
 	copied = skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 1a17850..3fd0464 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -610,6 +610,7 @@ static int rfcomm_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 		rfcomm_dlc_accept(d);
+		msg->msg_namelen = 0;
 		return 0;
 	}
 
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 095259f..ff2ff3c 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -286,6 +286,8 @@ static int caif_seqpkt_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (m->msg_flags&MSG_OOB)
 		goto read_error;
 
+	m->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, 0 , &ret);
 	if (!skb)
 		goto read_error;
diff --git a/net/can/gw.c b/net/can/gw.c
index b54d5e6..36cf941 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -436,7 +436,7 @@ static int cgw_notifier(struct notifier_block *nb,
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(gwj);
-				kfree(gwj);
+				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
 	}
@@ -826,7 +826,7 @@ static void cgw_remove_all_jobs(void)
 	hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 	}
 }
 
@@ -879,7 +879,7 @@ static int cgw_remove_job(struct sk_buff *skb,  struct nlmsghdr *nlh, void *arg)
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index 9509394..cefd2c2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1907,6 +1907,9 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	const char *driver = "";
 
+	if (!net_ratelimit())
+		return;
+
 	if (dev && dev->dev.parent)
 		driver = dev_driver_string(dev->dev.parent);
 
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 716f363..fb898d7 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -38,7 +38,7 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 	ha->type = addr_type;
 	ha->refcount = 1;
 	ha->global_use = global;
-	ha->synced = false;
+	ha->synced = 0;
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
 
@@ -164,7 +164,7 @@ int __hw_addr_sync(struct netdev_hw_addr_list *to_list,
 					    addr_len, ha->type);
 			if (err)
 				break;
-			ha->synced = true;
+			ha->synced++;
 			ha->refcount++;
 		} else if (ha->refcount == 1) {
 			__hw_addr_del(to_list, ha->addr, addr_len, ha->type);
@@ -185,7 +185,7 @@ void __hw_addr_unsync(struct netdev_hw_addr_list *to_list,
 		if (ha->synced) {
 			__hw_addr_del(to_list, ha->addr,
 				      addr_len, ha->type);
-			ha->synced = false;
+			ha->synced--;
 			__hw_addr_del(from_list, ha->addr,
 				      addr_len, ha->type);
 		}
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1c854d4..cb99f6e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1068,7 +1068,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq = net->dev_base_seq;
 
-	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(cb->nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 
 		if (tb[IFLA_EXT_MASK])
@@ -1918,7 +1918,7 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 	u32 ext_filter_mask = 0;
 	u16 min_ifinfo_dump_size = 0;
 
-	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 		if (tb[IFLA_EXT_MASK])
 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
diff --git a/net/core/sock.c b/net/core/sock.c
index a6000fb..e794a4a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -862,15 +862,20 @@ EXPORT_SYMBOL(sock_setsockopt);
 
 
 void cred_to_ucred(struct pid *pid, const struct cred *cred,
-		   struct ucred *ucred)
+		   struct ucred *ucred, bool use_effective)
 {
 	ucred->pid = pid_vnr(pid);
 	ucred->uid = ucred->gid = -1;
 	if (cred) {
 		struct user_namespace *current_ns = current_user_ns();
 
-		ucred->uid = from_kuid(current_ns, cred->euid);
-		ucred->gid = from_kgid(current_ns, cred->egid);
+		if (use_effective) {
+			ucred->uid = from_kuid(current_ns, cred->euid);
+			ucred->gid = from_kgid(current_ns, cred->egid);
+		} else {
+			ucred->uid = from_kuid(current_ns, cred->uid);
+			ucred->gid = from_kgid(current_ns, cred->gid);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(cred_to_ucred);
@@ -1031,7 +1036,8 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
-		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred,
+			      &peercred, true);
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index b61e9de..6e356c5 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -139,8 +139,6 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	/* skb is pure payload to encrypt */
 
-	err = -ENOMEM;
-
 	esp = x->data;
 	aead = esp->aead;
 	alen = crypto_aead_authsize(aead);
@@ -176,8 +174,10 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 	}
 
 	tmp = esp_alloc_tmp(aead, nfrags + sglists, seqhilen);
-	if (!tmp)
+	if (!tmp) {
+		err = -ENOMEM;
 		goto error;
+	}
 
 	seqhi = esp_tmp_seqhi(tmp);
 	iv = esp_tmp_iv(aead, tmp, seqhilen);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 578e536..71ce1c0b 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -255,8 +255,7 @@ static void ip_expire(unsigned long arg)
 		if (!head->dev)
 			goto out_rcu_unlock;
 
-		/* skb dst is stale, drop it, and perform route lookup again */
-		skb_dst_drop(head);
+		/* skb has no dst, perform route lookup again */
 		iph = ip_hdr(head);
 		err = ip_route_input_noref(head, iph->daddr, iph->saddr,
 					   iph->tos, head->dev);
@@ -521,8 +520,16 @@ found:
 		qp->q.last_in |= INET_FRAG_FIRST_IN;
 
 	if (qp->q.last_in == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    qp->q.meat == qp->q.len)
-		return ip_frag_reasm(qp, prev, dev);
+	    qp->q.meat == qp->q.len) {
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		err = ip_frag_reasm(qp, prev, dev);
+		skb->_skb_refdst = orefdst;
+		return err;
+	}
+
+	skb_dst_drop(skb);
 
 	write_lock(&ip4_frags.lock);
 	list_move_tail(&qp->q.lru_list, &qp->q.net->lru_list);
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 650e152..3324857 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -347,8 +347,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
 	 * hasn't changed since we received the original syn, but I see
 	 * no easy way to do this.
 	 */
-	flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
-			   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
+	flowi4_init_output(&fl4, sk->sk_bound_dev_if, sk->sk_mark,
+			   RT_CONN_FLAGS(sk), RT_SCOPE_UNIVERSE, IPPROTO_TCP,
 			   inet_sk_flowi_flags(sk),
 			   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
 			   ireq->loc_addr, th->source, th->dest);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index db1b172..c30a56e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -116,6 +116,7 @@ int sysctl_tcp_early_retrans __read_mostly = 2;
 #define FLAG_DSACKING_ACK	0x800 /* SACK blocks contained D-SACK info */
 #define FLAG_NONHEAD_RETRANS_ACKED	0x1000 /* Non-head rexmitted data was ACKed */
 #define FLAG_SACK_RENEGING	0x2000 /* snd_una advanced to a sacked seq */
+#define FLAG_UPDATE_TS_RECENT	0x4000 /* tcp_replace_ts_recent() */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -3599,6 +3600,27 @@ static void tcp_send_challenge_ack(struct sock *sk)
 	}
 }
 
+static void tcp_store_ts_recent(struct tcp_sock *tp)
+{
+	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
+	tp->rx_opt.ts_recent_stamp = get_seconds();
+}
+
+static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
+{
+	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
+		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
+		 * extra check below makes sure this can only happen
+		 * for pure ACK frames.  -DaveM
+		 *
+		 * Not only, also it occurs for expired timestamps.
+		 */
+
+		if (tcp_paws_check(&tp->rx_opt, 0))
+			tcp_store_ts_recent(tp);
+	}
+}
+
 /* This routine deals with incoming acks, but not outgoing ones. */
 static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 {
@@ -3651,6 +3673,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	prior_fackets = tp->fackets_out;
 	prior_in_flight = tcp_packets_in_flight(tp);
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	if (flag & FLAG_UPDATE_TS_RECENT)
+		tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	if (!(flag & FLAG_SLOWPATH) && after(ack, prior_snd_una)) {
 		/* Window is constant, pure forward advance.
 		 * No more checks are required.
@@ -3967,27 +3995,6 @@ const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
 EXPORT_SYMBOL(tcp_parse_md5sig_option);
 #endif
 
-static inline void tcp_store_ts_recent(struct tcp_sock *tp)
-{
-	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
-	tp->rx_opt.ts_recent_stamp = get_seconds();
-}
-
-static inline void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
-{
-	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
-		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
-		 * extra check below makes sure this can only happen
-		 * for pure ACK frames.  -DaveM
-		 *
-		 * Not only, also it occurs for expired timestamps.
-		 */
-
-		if (tcp_paws_check(&tp->rx_opt, 0))
-			tcp_store_ts_recent(tp);
-	}
-}
-
 /* Sorry, PAWS as specified is broken wrt. pure-ACKs -DaveM
  *
  * It is not fatal. If this ACK does _not_ change critical state (seqs, window)
@@ -5580,14 +5587,10 @@ slow_path:
 		return 0;
 
 step5:
-	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
+	if (th->ack &&
+	    tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0)
 		goto discard;
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -6002,7 +6005,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 
 	/* step 5: check the ACK field */
 	if (th->ack) {
-		int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH) > 0;
+		int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH |
+						  FLAG_UPDATE_TS_RECENT) > 0;
 
 		switch (sk->sk_state) {
 		case TCP_SYN_RECV:
@@ -6114,11 +6118,6 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	} else
 		goto discard;
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 6: check the URG bit */
 	tcp_urg(sk, skb, th);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fb79daa..c7f1fe4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2380,8 +2380,12 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 	 */
 	TCP_SKB_CB(skb)->when = tcp_time_stamp;
 
-	/* make sure skb->data is aligned on arches that require it */
-	if (unlikely(NET_IP_ALIGN && ((unsigned long)skb->data & 3))) {
+	/* make sure skb->data is aligned on arches that require it
+	 * and check if ack-trimming & collapsing extended the headroom
+	 * beyond what csum_start can cover.
+	 */
+	if (unlikely((NET_IP_ALIGN && ((unsigned long)skb->data & 3)) ||
+		     skb_headroom(skb) >= 0xFFFF)) {
 		struct sk_buff *nskb = __pskb_copy(skb, MAX_TCP_HEADER,
 						   GFP_ATOMIC);
 		err = nskb ? tcp_transmit_skb(sk, nskb, 0, GFP_ATOMIC) :
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ec627b5..dd8549a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2397,6 +2397,9 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
 static void init_loopback(struct net_device *dev)
 {
 	struct inet6_dev  *idev;
+	struct net_device *sp_dev;
+	struct inet6_ifaddr *sp_ifa;
+	struct rt6_info *sp_rt;
 
 	/* ::1 */
 
@@ -2408,6 +2411,30 @@ static void init_loopback(struct net_device *dev)
 	}
 
 	add_addr(idev, &in6addr_loopback, 128, IFA_HOST);
+
+	/* Add routes to other interface's IPv6 addresses */
+	for_each_netdev(dev_net(dev), sp_dev) {
+		if (!strcmp(sp_dev->name, dev->name))
+			continue;
+
+		idev = __in6_dev_get(sp_dev);
+		if (!idev)
+			continue;
+
+		read_lock_bh(&idev->lock);
+		list_for_each_entry(sp_ifa, &idev->addr_list, if_list) {
+
+			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
+				continue;
+
+			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
+
+			/* Failure cases are ignored */
+			if (!IS_ERR(sp_rt))
+				ip6_ins_rt(sp_rt);
+		}
+		read_unlock_bh(&idev->lock);
+	}
 }
 
 static void addrconf_add_linklocal(struct inet6_dev *idev, const struct in6_addr *addr)
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 66d2096..3673b8f 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -386,8 +386,17 @@ found:
 	}
 
 	if (fq->q.last_in == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    fq->q.meat == fq->q.len)
-		return ip6_frag_reasm(fq, prev, dev);
+	    fq->q.meat == fq->q.len) {
+		int res;
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		res = ip6_frag_reasm(fq, prev, dev);
+		skb->_skb_refdst = orefdst;
+		return res;
+	}
+
+	skb_dst_drop(skb);
 
 	write_lock(&ip6_frags.lock);
 	list_move_tail(&fq->q.lru_list, &fq->q.net->lru_list);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index fe48fc9..e3eec75 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -397,6 +397,7 @@ static void tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 		if (dst)
 			dst->ops->redirect(dst, sk, skb);
+		goto out;
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index 73dfe2c..927ff4d 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1386,6 +1386,8 @@ static int irda_recvmsg_dgram(struct kiocb *iocb, struct socket *sock,
 
 	IRDA_DEBUG(4, "%s()\n", __func__);
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
 	if (!skb)
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index cd6f7a9..625bc50 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1331,6 +1331,8 @@ static int iucv_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct sk_buff *skb, *rskb, *cskb;
 	int err = 0;
 
+	msg->msg_namelen = 0;
+
 	if ((sk->sk_state == IUCV_DISCONN) &&
 	    skb_queue_empty(&iucv->backlog_skb_q) &&
 	    skb_queue_empty(&sk->sk_receive_queue) &&
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 9275471..2c9ccce 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -684,6 +684,7 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		lsa->l2tp_addr = ipv6_hdr(skb)->saddr;
 		lsa->l2tp_flowinfo = 0;
 		lsa->l2tp_scope_id = 0;
+		lsa->l2tp_conn_id = 0;
 		if (ipv6_addr_type(&lsa->l2tp_addr) & IPV6_ADDR_LINKLOCAL)
 			lsa->l2tp_scope_id = IP6CB(skb)->iif;
 	}
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index c219000..c9d0431 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -720,6 +720,8 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	int target;	/* Read at least this many bytes */
 	long timeo;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	copied = -ENOTCONN;
 	if (unlikely(sk->sk_type == SOCK_STREAM && sk->sk_state == TCP_LISTEN))
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a58c0b6..bb8d96b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2337,7 +2337,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 			list_del(&dep->list);
 			mutex_unlock(&local->mtx);
 
-			ieee80211_roc_notify_destroy(dep);
+			ieee80211_roc_notify_destroy(dep, true);
 			return 0;
 		}
 
@@ -2377,7 +2377,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 			ieee80211_start_next_roc(local);
 		mutex_unlock(&local->mtx);
 
-		ieee80211_roc_notify_destroy(found);
+		ieee80211_roc_notify_destroy(found, true);
 	} else {
 		/* work may be pending so use it all the time */
 		found->abort = true;
@@ -2387,6 +2387,8 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 
 		/* work will clean up etc */
 		flush_delayed_work(&found->work);
+		WARN_ON(!found->to_be_freed);
+		kfree(found);
 	}
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 642a2a3..bf08e3c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -339,6 +339,7 @@ struct ieee80211_roc_work {
 	enum nl80211_channel_type chan_type;
 
 	bool started, abort, hw_begun, notified;
+	bool to_be_freed;
 
 	unsigned long hw_start_time;
 
@@ -1274,7 +1275,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
 void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata);
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc);
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free);
 void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b71d466..38727ef 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3237,8 +3237,16 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	/* prep auth_data so we don't go into idle on disassoc */
 	ifmgd->auth_data = auth_data;
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[DEAUTH_DISASSOC_LEN];
+
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_UNSPECIFIED,
+				       false, frame_buf);
+
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       sizeof(frame_buf));
+	}
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
@@ -3290,8 +3298,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[DEAUTH_DISASSOC_LEN];
+
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_UNSPECIFIED,
+				       false, frame_buf);
+
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       sizeof(frame_buf));
+	}
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
 		err = -EBUSY;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 2138dc3..2fe484c 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -293,10 +293,13 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 	}
 }
 
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free)
 {
 	struct ieee80211_roc_work *dep, *tmp;
 
+	if (WARN_ON(roc->to_be_freed))
+		return;
+
 	/* was never transmitted */
 	if (roc->frame) {
 		cfg80211_mgmt_tx_status(&roc->sdata->wdev,
@@ -313,9 +316,12 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 						   GFP_KERNEL);
 
 	list_for_each_entry_safe(dep, tmp, &roc->dependents, list)
-		ieee80211_roc_notify_destroy(dep);
+		ieee80211_roc_notify_destroy(dep, true);
 
-	kfree(roc);
+	if (free)
+		kfree(roc);
+	else
+		roc->to_be_freed = true;
 }
 
 void ieee80211_sw_roc_work(struct work_struct *work)
@@ -328,6 +334,9 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 
+	if (roc->to_be_freed)
+		goto out_unlock;
+
 	if (roc->abort)
 		goto finish;
 
@@ -368,7 +377,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
  finish:
 		list_del(&roc->list);
 		started = roc->started;
-		ieee80211_roc_notify_destroy(roc);
+		ieee80211_roc_notify_destroy(roc, !roc->abort);
 
 		if (started) {
 			drv_flush(local, false);
@@ -408,7 +417,7 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 
 	list_del(&roc->list);
 
-	ieee80211_roc_notify_destroy(roc);
+	ieee80211_roc_notify_destroy(roc, true);
 
 	/* if there's another roc, start it now */
 	ieee80211_start_next_roc(local);
@@ -458,12 +467,14 @@ void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
 	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {
 		if (local->ops->remain_on_channel) {
 			list_del(&roc->list);
-			ieee80211_roc_notify_destroy(roc);
+			ieee80211_roc_notify_destroy(roc, true);
 		} else {
 			ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
 
 			/* work will clean up etc */
 			flush_delayed_work(&roc->work);
+			WARN_ON(!roc->to_be_freed);
+			kfree(roc);
 		}
 	}
 
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 7261eb8..f334fbd 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1177,6 +1177,7 @@ static int nr_recvmsg(struct kiocb *iocb, struct socket *sock,
 	}
 
 	if (sax != NULL) {
+		memset(sax, 0, sizeof(*sax));
 		sax->sax25_family = AF_NETROM;
 		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
 			      AX25_ADDR_LEN);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index ddeb9aa..6832022 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -579,6 +579,8 @@ static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	pr_debug("%p %zu\n", sk, len);
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 
 	if (sk->sk_state == LLCP_CLOSED &&
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index c4719ce..7f645d1 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1257,6 +1257,7 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
 	if (srose != NULL) {
+		memset(srose, 0, msg->msg_namelen);
 		srose->srose_family = AF_ROSE;
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 564b9fc..611d5e9 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -963,8 +963,11 @@ cbq_dequeue(struct Qdisc *sch)
 		cbq_update(q);
 		if ((incr -= incr2) < 0)
 			incr = 0;
+		q->now += incr;
+	} else {
+		if (now > q->now)
+			q->now = now;
 	}
-	q->now += incr;
 	q->now_rt = now;
 
 	for (;;) {
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 09dc5b9..149bbae 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -802,6 +802,7 @@ static void set_orig_addr(struct msghdr *m, struct tipc_msg *msg)
 	if (addr) {
 		addr->family = AF_TIPC;
 		addr->addrtype = TIPC_ADDR_ID;
+		memset(&addr->addr, 0, sizeof(addr->addr));
 		addr->addr.id.ref = msg_origport(msg);
 		addr->addr.id.node = msg_orignode(msg);
 		addr->addr.name.domain = 0;	/* could leave uninitialized */
@@ -916,6 +917,9 @@ static int recv_msg(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 restart:
 
@@ -1032,6 +1036,9 @@ static int recv_stream(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, buf_len);
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 1b3abc8..37292d8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1998,7 +1998,7 @@ again:
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
 			    (UNIXCB(skb).cred != siocb->scm->cred))
 				break;
-		} else {
+		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 			check_creds = 1;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index bf3bf43..7203c9a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3219,18 +3219,10 @@ EXPORT_SYMBOL_GPL(snd_pcm_lib_default_mmap);
 int snd_pcm_lib_mmap_iomem(struct snd_pcm_substream *substream,
 			   struct vm_area_struct *area)
 {
-	long size;
-	unsigned long offset;
+	struct snd_pcm_runtime *runtime = substream->runtime;;
 
 	area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
-	area->vm_flags |= VM_IO;
-	size = area->vm_end - area->vm_start;
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	if (io_remap_pfn_range(area, area->vm_start,
-				(substream->runtime->dma_addr + offset) >> PAGE_SHIFT,
-				size, area->vm_page_prot))
-		return -EAGAIN;
-	return 0;
+	return vm_iomap_memory(area, runtime->dma_addr, runtime->dma_bytes);
 }
 
 EXPORT_SYMBOL(snd_pcm_lib_mmap_iomem);
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f60254d..558b6b0 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -165,7 +165,7 @@ const char *snd_hda_get_jack_type(u32 cfg)
 		"Line Out", "Speaker", "HP Out", "CD",
 		"SPDIF Out", "Digital Out", "Modem Line", "Modem Hand",
 		"Line In", "Aux", "Mic", "Telephony",
-		"SPDIF In", "Digitial In", "Reserved", "Other"
+		"SPDIF In", "Digital In", "Reserved", "Other"
 	};
 
 	return jack_types[(cfg & AC_DEFCFG_DEVICE)
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e1b7061..dd7f1db 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6656,7 +6656,8 @@ static int alc662_parse_auto_config(struct hda_codec *codec)
 	const hda_nid_t *ssids;
 
 	if (codec->vendor_id == 0x10ec0272 || codec->vendor_id == 0x10ec0663 ||
-	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670)
+	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670 ||
+	    codec->vendor_id == 0x10ec0671)
 		ssids = alc663_ssids;
 	else
 		ssids = alc662_ssids;
@@ -7108,6 +7109,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
 	{ .id = 0x10ec0668, .name = "ALC668", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
+	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 73f1c8d..3dfc582 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1083,6 +1083,8 @@ static const struct snd_soc_dapm_route wm8903_intercon[] = {
 	{ "ROP", NULL, "Right Speaker PGA" },
 	{ "RON", NULL, "Right Speaker PGA" },
 
+	{ "Charge Pump", NULL, "CLK_DSP" },
+
 	{ "Left Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Right Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Left Line Output PGA", NULL, "Charge Pump" },
diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index 81d7728..5b8140b 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -498,6 +498,8 @@ static void imx_ssi_ac97_reset(struct snd_ac97 *ac97)
 
 	if (imx_ssi->ac97_reset)
 		imx_ssi->ac97_reset(ac97);
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
@@ -506,6 +508,9 @@ static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
 
 	if (imx_ssi->ac97_warm_reset)
 		imx_ssi->ac97_warm_reset(ac97);
+
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 struct snd_ac97_bus_ops soc_ac97_ops = {
diff --git a/sound/soc/sh/dma-sh7760.c b/sound/soc/sh/dma-sh7760.c
index 7da2018..312715f 100644
--- a/sound/soc/sh/dma-sh7760.c
+++ b/sound/soc/sh/dma-sh7760.c
@@ -342,8 +342,8 @@ static int camelot_pcm_new(struct snd_soc_pcm_runtime *rtd)
 	return 0;
 }
 
-static struct snd_soc_platform sh7760_soc_platform = {
-	.pcm_ops 	= &camelot_pcm_ops,
+static struct snd_soc_platform_driver sh7760_soc_platform = {
+	.ops		= &camelot_pcm_ops,
 	.pcm_new	= camelot_pcm_new,
 	.pcm_free	= camelot_pcm_free,
 };
diff --git a/sound/soc/spear/spear_pcm.c b/sound/soc/spear/spear_pcm.c
index 8c7f237..8cf6d70 100644
--- a/sound/soc/spear/spear_pcm.c
+++ b/sound/soc/spear/spear_pcm.c
@@ -149,9 +149,9 @@ static void spear_pcm_free(struct snd_pcm *pcm)
 
 static u64 spear_pcm_dmamask = DMA_BIT_MASK(32);
 
-static int spear_pcm_new(struct snd_card *card,
-		struct snd_soc_dai *dai, struct snd_pcm *pcm)
+static int spear_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
+	struct snd_card *card = rtd->card->snd_card;
 	int ret;
 
 	if (!card->dev->dma_mask)
@@ -159,16 +159,16 @@ static int spear_pcm_new(struct snd_card *card,
 	if (!card->dev->coherent_dma_mask)
 		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
-	if (dai->driver->playback.channels_min) {
-		ret = spear_pcm_preallocate_dma_buffer(pcm,
+	if (rtd->cpu_dai->driver->playback.channels_min) {
+		ret = spear_pcm_preallocate_dma_buffer(rtd->pcm,
 				SNDRV_PCM_STREAM_PLAYBACK,
 				spear_pcm_hardware.buffer_bytes_max);
 		if (ret)
 			return ret;
 	}
 
-	if (dai->driver->capture.channels_min) {
-		ret = spear_pcm_preallocate_dma_buffer(pcm,
+	if (rtd->cpu_dai->driver->capture.channels_min) {
+		ret = spear_pcm_preallocate_dma_buffer(rtd->pcm,
 				SNDRV_PCM_STREAM_CAPTURE,
 				spear_pcm_hardware.buffer_bytes_max);
 		if (ret)
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index ae2b714..76e7dda 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -493,7 +493,7 @@ static int snd_nativeinstruments_control_get(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				  0, cpu_to_le16(wIndex),
+				  0, wIndex,
 				  &tmp, sizeof(tmp), 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
@@ -524,7 +524,7 @@ static int snd_nativeinstruments_control_put(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				  cpu_to_le16(wValue), cpu_to_le16(wIndex),
+				  wValue, wIndex,
 				  NULL, 0, 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 0f58b4b..213ecad 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -484,7 +484,7 @@ static int snd_usb_nativeinstruments_boot_quirk(struct usb_device *dev)
 {
 	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				  cpu_to_le16(1), 0, NULL, 0, 1000);
+				  1, 0, NULL, 0, 1000);
 
 	if (ret < 0)
 		return ret;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index ef61d52..92b1e28 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -73,9 +73,12 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 			u32 redir_index = (ioapic->ioregsel - 0x10) >> 1;
 			u64 redir_content;
 
-			ASSERT(redir_index < IOAPIC_NUM_PINS);
+			if (redir_index < IOAPIC_NUM_PINS)
+				redir_content =
+					ioapic->redirtbl[redir_index].bits;
+			else
+				redir_content = ~0ULL;
 
-			redir_content = ioapic->redirtbl[redir_index].bits;
 			result = (ioapic->ioregsel & 0x1) ?
 			    (redir_content >> 32) & 0xffffffff :
 			    redir_content & 0xffffffff;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d617f69..f555d95 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1393,21 +1393,38 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 }
 
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
-			      gpa_t gpa)
+			      gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int offset = offset_in_page(gpa);
-	gfn_t gfn = gpa >> PAGE_SHIFT;
+	gfn_t start_gfn = gpa >> PAGE_SHIFT;
+	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
+	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
+	gfn_t nr_pages_avail;
 
 	ghc->gpa = gpa;
 	ghc->generation = slots->generation;
-	ghc->memslot = gfn_to_memslot(kvm, gfn);
-	ghc->hva = gfn_to_hva_many(ghc->memslot, gfn, NULL);
-	if (!kvm_is_error_hva(ghc->hva))
+	ghc->len = len;
+	ghc->memslot = gfn_to_memslot(kvm, start_gfn);
+	ghc->hva = gfn_to_hva_many(ghc->memslot, start_gfn, &nr_pages_avail);
+	if (!kvm_is_error_hva(ghc->hva) && nr_pages_avail >= nr_pages_needed) {
 		ghc->hva += offset;
-	else
-		return -EFAULT;
-
+	} else {
+		/*
+		 * If the requested region crosses two memslots, we still
+		 * verify that the entire region is valid here.
+		 */
+		while (start_gfn <= end_gfn) {
+			ghc->memslot = gfn_to_memslot(kvm, start_gfn);
+			ghc->hva = gfn_to_hva_many(ghc->memslot, start_gfn,
+						   &nr_pages_avail);
+			if (kvm_is_error_hva(ghc->hva))
+				return -EFAULT;
+			start_gfn += nr_pages_avail;
+		}
+		/* Use the slow path for cross page reads and writes. */
+		ghc->memslot = NULL;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
@@ -1418,8 +1435,13 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int r;
 
+	BUG_ON(len > ghc->len);
+
 	if (slots->generation != ghc->generation)
-		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa);
+		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
+
+	if (unlikely(!ghc->memslot))
+		return kvm_write_guest(kvm, ghc->gpa, data, len);
 
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
@@ -1439,8 +1461,13 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	int r;
 
+	BUG_ON(len > ghc->len);
+
 	if (slots->generation != ghc->generation)
-		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa);
+		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa, ghc->len);
+
+	if (unlikely(!ghc->memslot))
+		return kvm_read_guest(kvm, ghc->gpa, data, len);
 
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;


