Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaJXW6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:58:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40621 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbaJXW6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:58:33 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3/8] x86: Store a per-cpu shadow copy of CR4
Date: Fri, 24 Oct 2014 15:58:08 -0700
Message-Id: <3a54dd3353fffbf84804398e00dfdc5b7c1afd7d.1414190806.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context switches and TLB flushes can change individual bits of CR4.
CR4 reads take several cycles, so store a shadow copy of CR4 in a
per-cpu variable.

To avoid wasting a cache line, I added the CR4 shadow to
cpu_tlbstate, which is already touched in switch_mm.  The heaviest
users of the cr4 shadow will be switch_mm and __switch_to_xtra, and
__switch_to_xtra is called shortly after switch_mm during context
switch, so the cacheline is likely to be hot.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/paravirt.h      |  6 ++---
 arch/x86/include/asm/special_insns.h |  6 ++---
 arch/x86/include/asm/tlbflush.h      | 52 +++++++++++++++++++++++++++---------
 arch/x86/include/asm/virtext.h       |  2 +-
 arch/x86/kernel/acpi/sleep.c         |  2 +-
 arch/x86/kernel/cpu/common.c         |  7 +++++
 arch/x86/kernel/cpu/mtrr/cyrix.c     |  6 ++---
 arch/x86/kernel/cpu/mtrr/generic.c   |  6 ++---
 arch/x86/kernel/head32.c             |  1 +
 arch/x86/kernel/head64.c             |  2 ++
 arch/x86/kernel/process_32.c         |  2 +-
 arch/x86/kernel/process_64.c         |  2 +-
 arch/x86/kernel/setup.c              |  2 +-
 arch/x86/kvm/svm.c                   |  2 +-
 arch/x86/kvm/vmx.c                   |  6 ++---
 arch/x86/mm/fault.c                  |  2 +-
 arch/x86/mm/init.c                   |  8 ++++++
 arch/x86/mm/tlb.c                    |  3 ---
 arch/x86/power/cpu.c                 | 11 +++-----
 arch/x86/realmode/init.c             |  2 +-
 20 files changed, 84 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e1610e29e..a9d76e02301b 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -80,16 +80,16 @@ static inline void write_cr3(unsigned long x)
 	PVOP_VCALL1(pv_mmu_ops.write_cr3, x);
 }
 
-static inline unsigned long read_cr4(void)
+static inline unsigned long __read_cr4(void)
 {
 	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr4);
 }
-static inline unsigned long read_cr4_safe(void)
+static inline unsigned long __read_cr4_safe(void)
 {
 	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr4_safe);
 }
 
-static inline void write_cr4(unsigned long x)
+static inline void __write_cr4(unsigned long x)
 {
 	PVOP_VCALL1(pv_cpu_ops.write_cr4, x);
 }
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index e820c080a4e9..6a4b00fafb00 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -137,17 +137,17 @@ static inline void write_cr3(unsigned long x)
 	native_write_cr3(x);
 }
 
-static inline unsigned long read_cr4(void)
+static inline unsigned long __read_cr4(void)
 {
 	return native_read_cr4();
 }
 
-static inline unsigned long read_cr4_safe(void)
+static inline unsigned long __read_cr4_safe(void)
 {
 	return native_read_cr4_safe();
 }
 
-static inline void write_cr4(unsigned long x)
+static inline void __write_cr4(unsigned long x)
 {
 	native_write_cr4(x);
 }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index fc0c4bc356ce..cd791948b286 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -15,14 +15,37 @@
 #define __flush_tlb_single(addr) __native_flush_tlb_single(addr)
 #endif
 
+struct tlb_state {
+#ifdef CONFIG_SMP
+	struct mm_struct *active_mm;
+	int state;
+#endif
+
+	/*
+	 * Access to this CR4 shadow and to H/W CR4 is protected by
+	 * disabling interrupts when modifying either one.
+	 */
+	unsigned long cr4;
+};
+DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
+
+/* Initialize cr4 shadow for this CPU. */
+static inline void cr4_init_shadow(void)
+{
+	this_cpu_write(cpu_tlbstate.cr4, __read_cr4());
+}
+
 /* Set in this cpu's CR4. */
 static inline void cr4_set_bits(unsigned long mask)
 {
 	unsigned long cr4;
 
-	cr4 = read_cr4();
-	cr4 |= mask;
-	write_cr4(cr4);
+	cr4 = this_cpu_read(cpu_tlbstate.cr4);
+	if ((cr4 | mask) != cr4) {
+		cr4 |= mask;
+		this_cpu_write(cpu_tlbstate.cr4, cr4);
+		__write_cr4(cr4);
+	}
 }
 
 /* Clear in this cpu's CR4. */
@@ -30,9 +53,18 @@ static inline void cr4_clear_bits(unsigned long mask)
 {
 	unsigned long cr4;
 
-	cr4 = read_cr4();
-	cr4 &= ~mask;
-	write_cr4(cr4);
+	cr4 = this_cpu_read(cpu_tlbstate.cr4);
+	if ((cr4 & ~mask) != cr4) {
+		cr4 &= ~mask;
+		this_cpu_write(cpu_tlbstate.cr4, cr4);
+		__write_cr4(cr4);
+	}
+}
+
+/* Read the CR4 shadow. */
+static inline unsigned long cr4_read_shadow(void)
+{
+	return this_cpu_read(cpu_tlbstate.cr4);
 }
 
 /*
@@ -61,7 +93,7 @@ static inline void __native_flush_tlb_global_irq_disabled(void)
 {
 	unsigned long cr4;
 
-	cr4 = native_read_cr4();
+	cr4 = this_cpu_read(cpu_tlbstate.cr4);
 	/* clear PGE */
 	native_write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
@@ -221,12 +253,6 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
 
-struct tlb_state {
-	struct mm_struct *active_mm;
-	int state;
-};
-DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
-
 static inline void reset_lazy_tlbstate(void)
 {
 	this_cpu_write(cpu_tlbstate.state, 0);
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index f41e19ca717b..cce9ee68e335 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -46,7 +46,7 @@ static inline void cpu_vmxoff(void)
 
 static inline int cpu_vmx_enabled(void)
 {
-	return read_cr4() & X86_CR4_VMXE;
+	return __read_cr4() & X86_CR4_VMXE;
 }
 
 /** Disable VMX if it is enabled on the current CPU
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 31368207837c..d1daead5fcdd 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -78,7 +78,7 @@ int x86_acpi_suspend_lowlevel(void)
 
 	header->pmode_cr0 = read_cr0();
 	if (__this_cpu_read(cpu_info.cpuid_level) >= 0) {
-		header->pmode_cr4 = read_cr4();
+		header->pmode_cr4 = __read_cr4();
 		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_CR4);
 	}
 	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 847d62b78431..1b008f8e5219 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -19,6 +19,7 @@
 #include <asm/archrandom.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
+#include <asm/tlbflush.h>
 #include <asm/debugreg.h>
 #include <asm/sections.h>
 #include <asm/vsyscall.h>
@@ -1302,6 +1303,12 @@ void cpu_init(void)
 	wait_for_master_cpu(cpu);
 
 	/*
+	 * Initialize the CR4 shadow before doing anything that could
+	 * try to read it.
+	 */
+	cr4_init_shadow();
+
+	/*
 	 * Load microcode on this cpu if a valid microcode is available.
 	 * This is early microcode loading procedure.
 	 */
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 9e451b0876b5..f8c81ba0b465 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -138,8 +138,8 @@ static void prepare_set(void)
 
 	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
 	if (cpu_has_pge) {
-		cr4 = read_cr4();
-		write_cr4(cr4 & ~X86_CR4_PGE);
+		cr4 = __read_cr4();
+		__write_cr4(cr4 & ~X86_CR4_PGE);
 	}
 
 	/*
@@ -171,7 +171,7 @@ static void post_set(void)
 
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
-		write_cr4(cr4);
+		__write_cr4(cr4);
 }
 
 static void cyrix_set_arr(unsigned int reg, unsigned long base,
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0e25a1bc5ab5..7d74f7b3c6ba 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -678,8 +678,8 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 
 	/* Save value of CR4 and clear Page Global Enable (bit 7) */
 	if (cpu_has_pge) {
-		cr4 = read_cr4();
-		write_cr4(cr4 & ~X86_CR4_PGE);
+		cr4 = __read_cr4();
+		__write_cr4(cr4 & ~X86_CR4_PGE);
 	}
 
 	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
@@ -708,7 +708,7 @@ static void post_set(void) __releases(set_atomicity_lock)
 
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
-		write_cr4(cr4);
+		__write_cr4(cr4);
 	raw_spin_unlock(&set_atomicity_lock);
 }
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index d6c1b9836995..2911ef3a9f1c 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -31,6 +31,7 @@ static void __init i386_default_early_setup(void)
 
 asmlinkage __visible void __init i386_start_kernel(void)
 {
+	cr4_init_shadow();
 	sanitize_boot_params(&boot_params);
 
 	/* Call the subarch specific early setup function */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index eda1a865641e..3b241f0ca005 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -155,6 +155,8 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
 				(__START_KERNEL & PGDIR_MASK)));
 	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
 
+	cr4_init_shadow();
+
 	/* Kill off the identity-map trampoline */
 	reset_early_page_tables();
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8f3ebfe710d0..603c4f99cb5a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -101,7 +101,7 @@ void __show_regs(struct pt_regs *regs, int all)
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
-	cr4 = read_cr4_safe();
+	cr4 = __read_cr4_safe();
 	printk(KERN_DEFAULT "CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
 			cr0, cr2, cr3, cr4);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3ed4a68d4013..7e2810252d88 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -93,7 +93,7 @@ void __show_regs(struct pt_regs *regs, int all)
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
-	cr4 = read_cr4();
+	cr4 = __read_cr4();
 
 	printk(KERN_DEFAULT "FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
 	       fs, fsindex, gs, gsindex, shadowgs);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 235cfd39e0d7..2d7cab9adaf6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1176,7 +1176,7 @@ void __init setup_arch(char **cmdline_p)
 
 	if (boot_cpu_data.cpuid_level >= 0) {
 		/* A CPU has %cr4 if and only if it has CPUID */
-		mmu_cr4_features = read_cr4();
+		mmu_cr4_features = __read_cr4();
 		if (trampoline_cr4_features)
 			*trampoline_cr4_features = mmu_cr4_features;
 	}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 65510f624dfe..42c3a90281ee 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1581,7 +1581,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 static int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	unsigned long host_cr4_mce = read_cr4() & X86_CR4_MCE;
+	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
 	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
 
 	if (cr4 & X86_CR4_VMXE)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 93e2649fb786..de464ddcff20 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2738,7 +2738,7 @@ static int hardware_enable(void)
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 	u64 old, test_bits;
 
-	if (read_cr4() & X86_CR4_VMXE)
+	if (cr4_read_shadow() & X86_CR4_VMXE)
 		return -EBUSY;
 
 	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
@@ -4274,7 +4274,7 @@ static void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
 
 	/* Save the most likely value for this task's CR4 in the VMCS. */
-	cr4 = read_cr4();
+	cr4 = cr4_read_shadow();
 	vmcs_writel(HOST_CR4, cr4);			/* 22.2.3, 22.2.5 */
 	vmx->host_state.vmcs_host_cr4 = cr4;
 
@@ -7546,7 +7546,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 
-	cr4 = read_cr4();
+	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->host_state.vmcs_host_cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
 		vmx->host_state.vmcs_host_cr4 = cr4;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index d973e61e450d..5239ac2e189a 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -600,7 +600,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
 		if (pte && pte_present(*pte) && pte_exec(*pte) &&
 				(pgd_flags(*pgd) & _PAGE_USER) &&
-				(read_cr4() & X86_CR4_SMEP))
+				(__read_cr4() & X86_CR4_SMEP))
 			printk(smep_warning, from_kuid(&init_user_ns, current_uid()));
 	}
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 73b37cd0d253..0a59a63bcdad 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -687,3 +687,11 @@ void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate) = {
+#ifdef CONFIG_SMP
+	.active_mm = &init_mm,
+	.state = 0,
+#endif
+	.cr4 = ~0UL,	/* fail hard if we screw up cr4 shadow initialization */
+};
+EXPORT_SYMBOL_GPL(cpu_tlbstate);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index ee61c36d64f8..3250f2371aea 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -14,9 +14,6 @@
 #include <asm/uv/uv.h>
 #include <linux/debugfs.h>
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
-			= { &init_mm, 0, };
-
 /*
  *	Smarter SMP flushing macros.
  *		c/o Linus Torvalds.
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 6ec7910f59bf..3e32ed5648a0 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -105,11 +105,8 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr0 = read_cr0();
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
-#ifdef CONFIG_X86_32
-	ctxt->cr4 = read_cr4_safe();
-#else
-/* CONFIG_X86_64 */
-	ctxt->cr4 = read_cr4();
+	ctxt->cr4 = __read_cr4_safe();
+#ifdef CONFIG_X86_64
 	ctxt->cr8 = read_cr8();
 #endif
 	ctxt->misc_enable_saved = !rdmsrl_safe(MSR_IA32_MISC_ENABLE,
@@ -175,12 +172,12 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	/* cr4 was introduced in the Pentium CPU */
 #ifdef CONFIG_X86_32
 	if (ctxt->cr4)
-		write_cr4(ctxt->cr4);
+		__write_cr4(ctxt->cr4);
 #else
 /* CONFIG X86_64 */
 	wrmsrl(MSR_EFER, ctxt->efer);
 	write_cr8(ctxt->cr8);
-	write_cr4(ctxt->cr4);
+	__write_cr4(ctxt->cr4);
 #endif
 	write_cr3(ctxt->cr3);
 	write_cr2(ctxt->cr2);
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index bad628a620c4..0b7a63d98440 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -81,7 +81,7 @@ void __init setup_real_mode(void)
 
 	trampoline_header->start = (u64) secondary_startup_64;
 	trampoline_cr4_features = &trampoline_header->cr4;
-	*trampoline_cr4_features = read_cr4();
+	*trampoline_cr4_features = __read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
 	trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
-- 
1.9.3

