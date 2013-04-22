Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3DVJjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:39:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab3DVJjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:39:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.11
Date: Mon, 22 Apr 2013 10:38:55 +0100
Message-Id: <1366623535-8481-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366623535-8481-1-git-send-email-luis.henriques@canonical.com>
References: <1366623535-8481-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4c5e7cf..a9b08fa 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .10
+EXTRAVERSION = .11
 NAME = Saber-toothed Squirrel
 
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
diff --git a/arch/arm/mach-at91/include/mach/at91_rtc.h b/arch/arm/mach-at91/include/mach/at91_rtc.h
index 5f940b6..da1945e 100644
--- a/arch/arm/mach-at91/include/mach/at91_rtc.h
+++ b/arch/arm/mach-at91/include/mach/at91_rtc.h
@@ -64,6 +64,7 @@
 #define	AT91_RTC_SCCR		0x1c			/* Status Clear Command Register */
 #define	AT91_RTC_IER		0x20			/* Interrupt Enable Register */
 #define	AT91_RTC_IDR		0x24			/* Interrupt Disable Register */
+#define	AT91_RTC_IMR		0x28			/* Interrupt Mask Register */
 
 #define	AT91_RTC_VER		0x2c			/* Valid Entry Register */
 #define		AT91_RTC_NVTIM		(1 <<  0)		/* Non valid Time */
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
index 5900cd5..897486c 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -132,7 +132,7 @@ ENTRY(cpu_v6_set_pte_ext)
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
index db7c1f2..9a50912 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -410,8 +410,8 @@ struct kvm_vcpu_arch {
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
index 6cbbabf..30355d4 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -741,7 +741,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
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
index 8e8b9a4..faf2c04 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -91,6 +91,7 @@ struct pv_lazy_ops {
 	/* Set deferred update mode, used for batching operations. */
 	void (*enter)(void);
 	void (*leave)(void);
+	void (*flush)(void);
 };
 
 struct pv_time_ops {
@@ -680,6 +681,7 @@ void paravirt_end_context_switch(struct task_struct *next);
 
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
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 9ce8859..6be2673 100644
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
@@ -477,6 +477,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.lazy_mode = {
 		.enter = paravirt_nop,
 		.leave = paravirt_nop,
+		.flush = paravirt_nop,
 	},
 
 	.set_fixmap = native_set_fixmap,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b6fbee..a7c8796 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1118,7 +1118,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
-	void *shared_kaddr;
 	unsigned long this_tsc_khz;
 	s64 kernel_ns, max_kernel_ns;
 	u64 tsc_timestamp;
@@ -1154,7 +1153,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	local_irq_restore(flags);
 
-	if (!vcpu->time_page)
+	if (!vcpu->pv_time_enabled)
 		return 0;
 
 	/*
@@ -1212,14 +1211,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
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
 
@@ -1498,7 +1492,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 		return 0;
 	}
 
-	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa))
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
+					sizeof(u32)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -1508,10 +1503,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.time_page) {
-		kvm_release_page_dirty(vcpu->arch.time_page);
-		vcpu->arch.time_page = NULL;
-	}
+	vcpu->arch.pv_time_enabled = false;
 }
 
 static void accumulate_steal_time(struct kvm_vcpu *vcpu)
@@ -1606,6 +1598,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 	case MSR_KVM_SYSTEM_TIME: {
+		u64 gpa_offset;
 		kvmclock_reset(vcpu);
 
 		vcpu->arch.time = data;
@@ -1615,16 +1608,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (!(data & 1))
 			break;
 
-		/* ...but clean it before doing the actual write */
-		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
+		gpa_offset = data & ~(PAGE_MASK | 1);
 
-		vcpu->arch.time_page =
-				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		     &vcpu->arch.pv_time, data & ~1ULL,
+		     sizeof(struct pvclock_vcpu_time_info)))
+			vcpu->arch.pv_time_enabled = false;
+		else
+			vcpu->arch.pv_time_enabled = true;
 
-		if (is_error_page(vcpu->arch.time_page)) {
-			kvm_release_page_clean(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
-		}
 		break;
 	}
 	case MSR_KVM_ASYNC_PF_EN:
@@ -1640,7 +1632,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 			return 1;
 
 		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.st.stime,
-							data & KVM_STEAL_VALID_BITS))
+						data & KVM_STEAL_VALID_BITS,
+						sizeof(struct kvm_steal_time)))
 			return 1;
 
 		vcpu->arch.st.msr_val = data;
@@ -2611,7 +2604,7 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 {
 	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
-	if (!vcpu->arch.time_page)
+	if (!vcpu->arch.pv_time_enabled)
 		return -EINVAL;
 	src->flags |= PVCLOCK_GUEST_STOPPED;
 	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
@@ -6211,6 +6204,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
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
index c6b10e2..e1a3691 100644
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
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dc5c3e3..51a5c3f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2052,6 +2052,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_mmu,
 		.leave = xen_leave_lazy_mmu,
+		.flush = paravirt_flush_lazy_mmu,
 	},
 
 	.set_fixmap = xen_set_fixmap,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index be7edfc..b3e5ad0 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -201,6 +201,8 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 	unsigned long val;						\
 	ssize_t ret;							\
 	ret = queue_var_store(&val, page, count);			\
+	if (ret < 0)							\
+		 return ret;						\
 	if (neg)							\
 		val = !val;						\
 									\
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
index fe5973f..a382b7c 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -150,6 +150,7 @@ enum piix_controller_ids {
 	tolapai_sata,
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
+	ich8_2port_sata_snb,
 };
 
 struct piix_map_db {
@@ -326,7 +327,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
-	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Lynx Point-LP) */
@@ -519,6 +520,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
+	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -660,6 +662,15 @@ static struct ata_port_info piix_port_info[] = {
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
index 96f0847..23f092d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2408,6 +2408,9 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (dev->horkage & ATA_HORKAGE_MAX_SEC_LBA48)
+		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -4065,6 +4068,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
 	{ "QUANTUM DAT    DAT72-000", NULL,	ATA_HORKAGE_ATAPI_MOD16_DMA },
+	{ "Slimtype DVD A  DS8A8SH", NULL,	ATA_HORKAGE_MAX_SEC_LBA48 },
 
 	/* Devices we expect to fail diagnostics */
 
diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 8369de1..8af01c1 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -75,14 +75,21 @@ static struct usb_device_id ath3k_table[] = {
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x0036) },
 	{ USB_DEVICE(0x0CF3, 0x3004) },
+	{ USB_DEVICE(0x0CF3, 0x3008) },
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x0CF3, 0x817a) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
+	{ USB_DEVICE(0x04CA, 0x3004) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x04CA, 0x3006) },
+	{ USB_DEVICE(0x04CA, 0x3008) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0930, 0x0219) },
 	{ USB_DEVICE(0x0489, 0xe057) },
+	{ USB_DEVICE(0x13d3, 0x3393) },
+	{ USB_DEVICE(0x0489, 0xe04e) },
+	{ USB_DEVICE(0x0489, 0xe056) },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE02C) },
@@ -104,14 +111,21 @@ static struct usb_device_id ath3k_blist_tbl[] = {
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0CF3, 0x817a), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU22 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xE03C), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 8b2046c..ff0782c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -141,14 +141,21 @@ static struct usb_device_id blacklist_table[] = {
 	/* Atheros 3012 with sflash firmware */
 	{ USB_DEVICE(0x0cf3, 0x0036), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0cf3, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x817a), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x13d3, 0x3393), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
 
 	/* Atheros AR5BBU12 with sflash firmware */
 	{ USB_DEVICE(0x0489, 0xe02c), .driver_info = BTUSB_IGNORE },
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
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9b00072..42c759a 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -53,6 +53,24 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+config EFI_VARS_PSTORE
+	bool "Register efivars backend for pstore"
+	depends on EFI_VARS && PSTORE
+	default y
+	help
+	  Say Y here to enable use efivars as a backend to pstore. This
+	  will allow writing console messages, crash dumps, or anything
+	  else supported by pstore to EFI variables.
+
+config EFI_VARS_PSTORE_DEFAULT_DISABLE
+	bool "Disable using efivars as a pstore backend by default"
+	depends on EFI_VARS_PSTORE
+	default n
+	help
+	  Saying Y here will disable the use of efivars as a storage
+	  backend for pstore by default. This setting can be overridden
+	  using the efivars module's pstore_disable parameter.
+
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index bfd8f43..303bc8e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -92,6 +92,11 @@ MODULE_VERSION(EFIVARS_VERSION);
 
 #define DUMP_NAME_LEN 52
 
+static bool efivars_pstore_disable =
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
+
+module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -629,15 +634,13 @@ static struct kobj_type efivar_ktype = {
 	.default_attrs = def_attrs,
 };
 
-static struct pstore_info efi_pstore_info;
-
 static inline void
 efivar_unregister(struct efivar_entry *var)
 {
 	kobject_put(&var->kobj);
 }
 
-#ifdef CONFIG_PSTORE
+#ifdef CONFIG_EFI_VARS_PSTORE
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
@@ -771,37 +774,6 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 
 	return 0;
 }
-#else
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	return -1;
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, size_t size, struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id,
-			    struct pstore_info *psi)
-{
-	return 0;
-}
-#endif
 
 static struct pstore_info efi_pstore_info = {
 	.owner		= THIS_MODULE,
@@ -813,6 +785,24 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	efivars->efi_pstore_info = efi_pstore_info;
+	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efivars->efi_pstore_info.buf) {
+		efivars->efi_pstore_info.bufsize = 1024;
+		efivars->efi_pstore_info.data = efivars;
+		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
+		pstore_register(&efivars->efi_pstore_info);
+	}
+}
+#else
+static void efivar_pstore_register(struct efivars *efivars)
+{
+	return;
+}
+#endif
+
 static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
@@ -1188,15 +1178,8 @@ int register_efivars(struct efivars *efivars,
 	if (error)
 		unregister_efivars(efivars);
 
-	efivars->efi_pstore_info = efi_pstore_info;
-
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
-		efivars->efi_pstore_info.data = efivars;
-		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
-		pstore_register(&efivars->efi_pstore_info);
-	}
+	if (!efivars_pstore_disable)
+		efivar_pstore_register(efivars);
 
 out:
 	kfree(variable_name);
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 9fd25a4..1e30d8f 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -72,7 +72,7 @@ int i915_gem_init_aliasing_ppgtt(struct drm_device *dev)
 	/* ppgtt PDEs reside in the global gtt pagetable, which has 512*1024
 	 * entries. For aliasing ppgtt support we just steal them at the end for
 	 * now. */
-	first_pd_entry_in_global_pt = 512*1024 - I915_PPGTT_PD_ENTRIES;
+	first_pd_entry_in_global_pt = dev_priv->mm.gtt->gtt_total_entries - I915_PPGTT_PD_ENTRIES;
 
 	ppgtt = kzalloc(sizeof(*ppgtt), GFP_KERNEL);
 	if (!ppgtt)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 1f06ab4..2ec0617 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6881,6 +6881,34 @@ struct intel_quirk {
 	void (*hook)(struct drm_device *dev);
 };
 
+/* For systems that don't have a meaningful PCI subdevice/subvendor ID */
+struct intel_dmi_quirk {
+	void (*hook)(struct drm_device *dev);
+	const struct dmi_system_id (*dmi_id_list)[];
+};
+
+static int intel_dmi_reverse_brightness(const struct dmi_system_id *id)
+{
+	DRM_INFO("Backlight polarity reversed on %s\n", id->ident);
+	return 1;
+}
+
+static const struct intel_dmi_quirk intel_dmi_quirks[] = {
+	{
+		.dmi_id_list = &(const struct dmi_system_id[]) {
+			{
+				.callback = intel_dmi_reverse_brightness,
+				.ident = "NCR Corporation",
+				.matches = {DMI_MATCH(DMI_SYS_VENDOR, "NCR Corporation"),
+					    DMI_MATCH(DMI_PRODUCT_NAME, ""),
+				},
+			},
+			{ }  /* terminating entry */
+		},
+		.hook = quirk_invert_brightness,
+	},
+};
+
 static struct intel_quirk intel_quirks[] = {
 	/* HP Mini needs pipe A force quirk (LP: #322104) */
 	{ 0x27ae, 0x103c, 0x361a, quirk_pipea_force },
@@ -6912,6 +6940,15 @@ static struct intel_quirk intel_quirks[] = {
 
 	/* Acer Aspire 4736Z */
 	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
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
@@ -6929,6 +6966,10 @@ static void intel_init_quirks(struct drm_device *dev)
 		     q->subsystem_device == PCI_ANY_ID))
 			q->hook(dev);
 	}
+	for (i = 0; i < ARRAY_SIZE(intel_dmi_quirks); i++) {
+		if (dmi_check_system(*intel_dmi_quirks[i].dmi_id_list) != 0)
+			intel_dmi_quirks[i].hook(dev);
+	}
 }
 
 /* Disable the VGA plane that we never use */
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 505a917..abb9776 100644
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
index 3234224..b8e6463 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -61,6 +61,10 @@ static int udl_get_modes(struct drm_connector *connector)
 	int ret;
 
 	edid = (struct edid *)udl_get_edid(udl);
+	if (!edid) {
+		drm_mode_connector_update_edid_property(connector, NULL);
+		return 0;
+	}
 
 	connector->display_info.raw_edid = (char *)edid;
 
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 5b3c7d1..4d53351 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -26,6 +26,7 @@
 #include <linux/fb.h>
 
 #include <linux/pci.h>
+#include <linux/console.h>
 #include <linux/vga_switcheroo.h>
 
 #include <linux/vgaarb.h>
@@ -323,8 +324,10 @@ static int vga_switchto_stage2(struct vga_switcheroo_client *new_client)
 
 	if (new_client->fb_info) {
 		struct fb_event event;
+		console_lock();
 		event.info = new_client->fb_info;
 		fb_notifier_call_chain(FB_EVENT_REMAP_ALL_CONSOLE, &event);
+		console_unlock();
 	}
 
 	ret = vgasr_priv.handler->switchto(new_client->id);
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 1201a15..08e7e72 100644
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
index f2f482b..2cfb1a8 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1136,7 +1136,11 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long off;
 	u32 len;
 
-	if (mtd->type == MTD_RAM || mtd->type == MTD_ROM) {
+        /* This is broken because it assumes the MTD device is map-based
+	   and that mtd->priv is a valid struct map_info.  It should be
+	   replaced with something that uses the mtd_get_unmapped_area()
+	   operation properly. */
+	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
 		off = vma->vm_pgoff << PAGE_SHIFT;
 		start = map->phys;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7c0878f..ab8d882 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7662,12 +7662,15 @@ static int __init ixgbe_init_module(void)
 	pr_info("%s - version %s\n", ixgbe_driver_string, ixgbe_driver_version);
 	pr_info("%s\n", ixgbe_copyright);
 
+	ret = pci_register_driver(&ixgbe_driver);
+	if (ret)
+		return ret;
+
 #ifdef CONFIG_IXGBE_DCA
 	dca_register_notify(&dca_notifier);
 #endif
 
-	ret = pci_register_driver(&ixgbe_driver);
-	return ret;
+	return 0;
 }
 
 module_init(ixgbe_init_module);
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 67f73ae..a32d221 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3596,6 +3596,30 @@ static void __devinit rtl_init_mdio_ops(struct rtl8169_private *tp)
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
@@ -3623,9 +3647,7 @@ static bool rtl_wol_pll_power_down(struct rtl8169_private *tp)
 	if (!(__rtl8169_get_wol(tp) & WAKE_ANY))
 		return false;
 
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, MII_BMCR, 0x0000);
-
+	rtl_speed_down(tp);
 	rtl_wol_suspend_quirk(tp);
 
 	return true;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 76b5c0f..4506cda 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1368,7 +1368,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	for (i = 0; i < request->n_channels; i++) {
+	for (i = 0; i < min_t(u32, request->n_channels,
+			      MWIFIEX_USER_SCAN_CHAN_MAX); i++) {
 		chan = request->channels[i];
 		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
 		priv->user_scan_cfg->chan_list[i].radio_type = chan->band;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 0a4653a..1ea98a8 100644
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
index 99b6ee7..82702aa 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -440,10 +440,12 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* it is now safe to add the virtio device */
 	ret = rproc_add_virtio_dev(rvdev, rsc->id);
 	if (ret)
-		goto free_vrings;
+		goto remove_rvdev;
 
 	return 0;
 
+remove_rvdev:
+	list_del(&rvdev->node);
 free_vrings:
 	__rproc_free_vrings(rvdev, i);
 	kfree(rvdev);
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 129f49d..dc474bc 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -43,7 +43,6 @@ static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
-static u32 at91_rtc_imr;
 
 /*
  * Decode time/date into rtc_time structure
@@ -108,11 +107,9 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
-	at91_rtc_imr |= AT91_RTC_ACKUPD;
 	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
-	at91_rtc_imr &= ~AT91_RTC_ACKUPD;
 
 	at91_rtc_write(AT91_RTC_TIMR,
 			  bin2bcd(tm->tm_sec) << 0
@@ -144,7 +141,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
-	alrm->enabled = (at91_rtc_imr & AT91_RTC_ALARM)
+	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
 			? 1 : 0;
 
 	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -170,7 +167,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	tm.tm_sec = alrm->time.tm_sec;
 
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-	at91_rtc_imr &= ~AT91_RTC_ALARM;
 	at91_rtc_write(AT91_RTC_TIMALR,
 		  bin2bcd(tm.tm_sec) << 0
 		| bin2bcd(tm.tm_min) << 8
@@ -183,7 +179,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	if (alrm->enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_imr |= AT91_RTC_ALARM;
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
 	}
 
@@ -200,12 +195,9 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_imr |= AT91_RTC_ALARM;
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
-	} else {
+	} else
 		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-		at91_rtc_imr &= ~AT91_RTC_ALARM;
-	}
 
 	return 0;
 }
@@ -214,10 +206,12 @@ static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
  */
 static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
 {
+	unsigned long imr = at91_rtc_read(AT91_RTC_IMR);
+
 	seq_printf(seq, "update_IRQ\t: %s\n",
-			(at91_rtc_imr & AT91_RTC_ACKUPD) ? "yes" : "no");
+			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
-			(at91_rtc_imr & AT91_RTC_SECEV) ? "yes" : "no");
+			(imr & AT91_RTC_SECEV) ? "yes" : "no");
 
 	return 0;
 }
@@ -232,7 +226,7 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 	unsigned int rtsr;
 	unsigned long events = 0;
 
-	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_imr;
+	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
@@ -296,7 +290,6 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
-	at91_rtc_imr = 0;
 
 	ret = request_irq(irq, at91_rtc_interrupt,
 				IRQF_SHARED,
@@ -336,7 +329,6 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
-	at91_rtc_imr = 0;
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
@@ -349,35 +341,31 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 
 /* AT91RM9200 RTC Power management control */
 
-static u32 at91_rtc_bkpimr;
-
+static u32 at91_rtc_imr;
 
 static int at91_rtc_suspend(struct device *dev)
 {
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
 	 */
-	at91_rtc_bkpimr = at91_rtc_imr & (AT91_RTC_ALARM|AT91_RTC_SECEV);
-	if (at91_rtc_bkpimr) {
-		if (device_may_wakeup(dev)) {
+	at91_rtc_imr = at91_rtc_read(AT91_RTC_IMR)
+			& (AT91_RTC_ALARM|AT91_RTC_SECEV);
+	if (at91_rtc_imr) {
+		if (device_may_wakeup(dev))
 			enable_irq_wake(irq);
-		} else {
-			at91_rtc_write(AT91_RTC_IDR, at91_rtc_bkpimr);
-			at91_rtc_imr &= ~at91_rtc_bkpimr;
-		}
-}
+		else
+			at91_rtc_write(AT91_RTC_IDR, at91_rtc_imr);
+	}
 	return 0;
 }
 
 static int at91_rtc_resume(struct device *dev)
 {
-	if (at91_rtc_bkpimr) {
-		if (device_may_wakeup(dev)) {
+	if (at91_rtc_imr) {
+		if (device_may_wakeup(dev))
 			disable_irq_wake(irq);
-		} else {
-			at91_rtc_imr |= at91_rtc_bkpimr;
-			at91_rtc_write(AT91_RTC_IER, at91_rtc_bkpimr);
-		}
+		else
+			at91_rtc_write(AT91_RTC_IER, at91_rtc_imr);
 	}
 	return 0;
 }
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 101b28e..58e6183 100644
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
index 972a94c..486e864 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -889,25 +889,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq, void *data)
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
@@ -931,9 +936,13 @@ static void s3c64xx_spi_hwinit(struct s3c64xx_spi_driver_data *sdd, int channel)
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
 
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 9179997..bdee2d5 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -413,6 +413,7 @@ static inline int core_alua_state_standby(
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -455,6 +456,7 @@ static inline int core_alua_state_unavailable(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -495,6 +497,7 @@ static inline int core_alua_state_transition(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 5bf163e..18ded2d 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -842,6 +842,8 @@ static void con2fb_init_display(struct vc_data *vc, struct fb_info *info,
  *
  *	Maps a virtual console @unit to a frame buffer device
  *	@newidx.
+ *
+ *	This should be called with the console lock held.
  */
 static int set_con2fb_map(int unit, int newidx, int user)
 {
@@ -859,7 +861,7 @@ static int set_con2fb_map(int unit, int newidx, int user)
 
 	if (!search_for_mapped_con() || !con_is_bound(&fb_con)) {
 		info_idx = newidx;
-		return fbcon_takeover(0);
+		return do_fbcon_takeover(0);
 	}
 
 	if (oldidx != -1)
@@ -867,7 +869,6 @@ static int set_con2fb_map(int unit, int newidx, int user)
 
 	found = search_fb_in_map(newidx);
 
-	console_lock();
 	con2fb_map[unit] = newidx;
 	if (!err && !found)
  		err = con2fb_acquire_newinfo(vc, info, unit, oldidx);
@@ -894,7 +895,6 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	if (!search_fb_in_map(info_idx))
 		info_idx = newidx;
 
-	console_unlock();
  	return err;
 }
 
@@ -3025,6 +3025,7 @@ static inline int fbcon_unbind(void)
 }
 #endif /* CONFIG_VT_HW_CONSOLE_BINDING */
 
+/* called with console_lock held */
 static int fbcon_fb_unbind(int idx)
 {
 	int i, new_idx = -1, ret = 0;
@@ -3051,6 +3052,7 @@ static int fbcon_fb_unbind(int idx)
 	return ret;
 }
 
+/* called with console_lock held */
 static int fbcon_fb_unregistered(struct fb_info *info)
 {
 	int i, idx;
@@ -3088,6 +3090,7 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 	return 0;
 }
 
+/* called with console_lock held */
 static void fbcon_remap_all(int idx)
 {
 	int i;
@@ -3132,6 +3135,7 @@ static inline void fbcon_select_primary(struct fb_info *info)
 }
 #endif /* CONFIG_FRAMEBUFFER_DETECT_PRIMARY */
 
+/* called with console_lock held */
 static int fbcon_fb_registered(struct fb_info *info)
 {
 	int ret = 0, i, idx;
@@ -3284,6 +3288,7 @@ static int fbcon_event_notify(struct notifier_block *self,
 		ret = fbcon_fb_unregistered(info);
 		break;
 	case FB_EVENT_SET_CONSOLE_MAP:
+		/* called with console lock held */
 		con2fb = event->data;
 		ret = set_con2fb_map(con2fb->console - 1,
 				     con2fb->framebuffer, 1);
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index afa804f..e4cc585 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1177,8 +1177,10 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 		event.data = &con2fb;
 		if (!lock_fb_info(info))
 			return -ENODEV;
+		console_lock();
 		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
+		console_unlock();
 		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index aad8644..5a1ff11 100644
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
 	btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f027c2b..9169ae3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1644,14 +1644,24 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
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
index a8a81d7..e756a62 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -900,8 +900,11 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
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
diff --git a/fs/inode.c b/fs/inode.c
index 6d5a282..78c342b 100644
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
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 32df2b6..5856c9e 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -937,7 +937,7 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 	}
 }
 
-static inline bool atapi_command_packet_set(const u16 *dev_id)
+static inline int atapi_command_packet_set(const u16 *dev_id)
 {
 	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
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
index 9c07dce..fd2a616 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -93,4 +93,25 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 {
 	return kref_sub(kref, 1, release);
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
index 96c158a..a6c5d05 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -450,7 +450,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
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
index 6e887c7..7e13eb4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -393,6 +393,7 @@ enum {
 	ATA_HORKAGE_NOSETXFER	= (1 << 14),	/* skip SETXFER, SATA only */
 	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
 	ATA_HORKAGE_DUMP_ID	= (1 << 16),	/* dump IDENTIFY data */
+	ATA_HORKAGE_MAX_SEC_LBA48 = (1 << 17),	/* Set max sects to 65535 */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
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
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cdd5607..e4cee8d 100644
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
diff --git a/kernel/panic.c b/kernel/panic.c
index d2a5f4e..e1b2822 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -75,6 +75,14 @@ void panic(const char *fmt, ...)
 	int state = 0;
 
 	/*
+	 * Disable local interrupts. This will prevent panic_smp_self_stop
+	 * from deadlocking the first cpu that invokes the panic, since
+	 * there is nothing to prevent an interrupt handler (that runs
+	 * after the panic_lock is acquired) from invoking panic again.
+	 */
+	local_irq_disable();
+
+	/*
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
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
diff --git a/kernel/sys.c b/kernel/sys.c
index b6fe559..0836a7f 100644
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
index 1b6ec54..38353bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -642,7 +642,6 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 
@@ -1000,6 +999,19 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
+loff_t
+ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t ret;
+
+	if (file->f_mode & FMODE_READ)
+		ret = seq_lseek(file, offset, whence);
+	else
+		file->f_pos = ret = 1;
+
+	return ret;
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
@@ -2510,7 +2522,7 @@ static void ftrace_filter_reset(struct ftrace_hash *hash)
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_regex_lseek() should be used as the lseek routine, and
+ * ftrace_filter_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -2594,19 +2606,6 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
 				 inode, file);
 }
 
-loff_t
-ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t ret;
-
-	if (file->f_mode & FMODE_READ)
-		ret = seq_lseek(file, offset, origin);
-	else
-		file->f_pos = ret = 1;
-
-	return ret;
-}
-
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;
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
 
@@ -4255,7 +4254,7 @@ static const struct file_operations ftrace_pid_fops = {
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_pid_release,
 };
 
@@ -4375,12 +4374,8 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
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
diff --git a/net/can/gw.c b/net/can/gw.c
index b41acf2..423d226 100644
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
@@ -850,7 +850,7 @@ static void cgw_remove_all_jobs(void)
 	hlist_for_each_entry_safe(gwj, n, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 	}
 }
 
@@ -903,7 +903,7 @@ static int cgw_remove_job(struct sk_buff *skb,  struct nlmsghdr *nlh, void *arg)
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
-		kfree(gwj);
+		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;
 	}
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 2c6a785..e6b34c8 100644
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
diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 4c054f4..86f6468 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -322,7 +322,7 @@ int snd_hdmi_get_eld(struct hdmi_eld *eld,
 		     struct hda_codec *codec, hda_nid_t nid)
 {
 	int i;
-	int ret;
+	int ret = 0;
 	int size;
 	unsigned char *buf;
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a351a6f..1baf0dc 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6525,7 +6525,8 @@ static int alc662_parse_auto_config(struct hda_codec *codec)
 	const hda_nid_t *ssids;
 
 	if (codec->vendor_id == 0x10ec0272 || codec->vendor_id == 0x10ec0663 ||
-	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670)
+	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670 ||
+	    codec->vendor_id == 0x10ec0671)
 		ssids = alc663_ssids;
 	else
 		ssids = alc662_ssids;
@@ -6970,6 +6971,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
 	{ .id = 0x10ec0668, .name = "ALC668", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
+	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 86b8a29..8ddfc19 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1082,6 +1082,8 @@ static const struct snd_soc_dapm_route wm8903_intercon[] = {
 	{ "ROP", NULL, "Right Speaker PGA" },
 	{ "RON", NULL, "Right Speaker PGA" },
 
+	{ "Charge Pump", NULL, "CLK_DSP" },
+
 	{ "Left Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Right Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Left Line Output PGA", NULL, "Charge Pump" },
diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index 28dd76c..83300fb 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -497,6 +497,8 @@ static void imx_ssi_ac97_reset(struct snd_ac97 *ac97)
 
 	if (imx_ssi->ac97_reset)
 		imx_ssi->ac97_reset(ac97);
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
@@ -505,6 +507,9 @@ static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
 
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
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index e4c808d..10a7247f 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -467,7 +467,7 @@ static int snd_nativeinstruments_control_get(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				  0, cpu_to_le16(wIndex),
+				  0, wIndex,
 				  &tmp, sizeof(tmp), 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
@@ -498,7 +498,7 @@ static int snd_nativeinstruments_control_put(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				  cpu_to_le16(wValue), cpu_to_le16(wIndex),
+				  wValue, wIndex,
 				  NULL, 0, 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index c46171a..b7fa802 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -486,7 +486,7 @@ static int snd_usb_nativeinstruments_boot_quirk(struct usb_device *dev)
 {
 	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				  cpu_to_le16(1), 0, NULL, 0, 1000);
+				  1, 0, NULL, 0, 1000);
 
 	if (ret < 0)
 		return ret;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 26fd54d..fdb1faf 100644
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
index 7d9d969..e32731c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1378,21 +1378,38 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
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
@@ -1403,8 +1420,13 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
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
@@ -1424,8 +1446,13 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
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
