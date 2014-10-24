Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbaJXXAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:00:20 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57747 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaJXW63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:58:29 -0400
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
Subject: [PATCH v2 2/8] x86: Clean up cr4 manipulation
Date: Fri, 24 Oct 2014 15:58:07 -0700
Message-Id: <495a10bdc9e67016b8fd3945700d46cfd5c12c2f.1414190806.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CR4 manipulation was split, seemingly at random, between direct
(write_cr4) and using a helper (set/clear_in_cr4).  Unfortunately,
the set_in_cr4 and clear_in_cr4 helpers also poke at the boot code,
which only a small subset of users actually wanted.

This patch replaces all cr4 access in functions that don't leave cr4
exactly the way they found it with new helpers cr4_set_bits,
cr4_clear_bits, and cr4_set_bits_and_update_boot.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/processor.h     | 33 --------------------------------
 arch/x86/include/asm/tlbflush.h      | 37 ++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/virtext.h       |  3 ++-
 arch/x86/kernel/cpu/common.c         | 10 +++++-----
 arch/x86/kernel/cpu/mcheck/mce.c     |  3 ++-
 arch/x86/kernel/cpu/mcheck/p5.c      |  3 ++-
 arch/x86/kernel/cpu/mcheck/winchip.c |  3 ++-
 arch/x86/kernel/cpu/perf_event.c     |  7 ++++---
 arch/x86/kernel/i387.c               |  3 ++-
 arch/x86/kernel/process.c            |  5 +++--
 arch/x86/kernel/xsave.c              |  3 ++-
 arch/x86/kvm/vmx.c                   |  4 ++--
 arch/x86/mm/init.c                   |  4 ++--
 arch/x86/xen/enlighten.c             |  4 ++--
 drivers/lguest/x86/core.c            |  4 ++--
 15 files changed, 69 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec794732..ddd8d13a010f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -578,39 +578,6 @@ static inline void load_sp0(struct tss_struct *tss,
 #define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
-/*
- * Save the cr4 feature set we're using (ie
- * Pentium 4MB enable and PPro Global page
- * enable), so that any CPU's that boot up
- * after us can get the correct flags.
- */
-extern unsigned long mmu_cr4_features;
-extern u32 *trampoline_cr4_features;
-
-static inline void set_in_cr4(unsigned long mask)
-{
-	unsigned long cr4;
-
-	mmu_cr4_features |= mask;
-	if (trampoline_cr4_features)
-		*trampoline_cr4_features = mmu_cr4_features;
-	cr4 = read_cr4();
-	cr4 |= mask;
-	write_cr4(cr4);
-}
-
-static inline void clear_in_cr4(unsigned long mask)
-{
-	unsigned long cr4;
-
-	mmu_cr4_features &= ~mask;
-	if (trampoline_cr4_features)
-		*trampoline_cr4_features = mmu_cr4_features;
-	cr4 = read_cr4();
-	cr4 &= ~mask;
-	write_cr4(cr4);
-}
-
 typedef struct {
 	unsigned long		seg;
 } mm_segment_t;
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 04905bfc508b..fc0c4bc356ce 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -15,6 +15,43 @@
 #define __flush_tlb_single(addr) __native_flush_tlb_single(addr)
 #endif
 
+/* Set in this cpu's CR4. */
+static inline void cr4_set_bits(unsigned long mask)
+{
+	unsigned long cr4;
+
+	cr4 = read_cr4();
+	cr4 |= mask;
+	write_cr4(cr4);
+}
+
+/* Clear in this cpu's CR4. */
+static inline void cr4_clear_bits(unsigned long mask)
+{
+	unsigned long cr4;
+
+	cr4 = read_cr4();
+	cr4 &= ~mask;
+	write_cr4(cr4);
+}
+
+/*
+ * Save some of cr4 feature set we're using (e.g.  Pentium 4MB
+ * enable and PPro Global page enable), so that any CPU's that boot
+ * up after us can get the correct flags.  This should only be used
+ * during boot on the boot cpu.
+ */
+extern unsigned long mmu_cr4_features;
+extern u32 *trampoline_cr4_features;
+
+static inline void cr4_set_bits_and_update_boot(unsigned long mask)
+{
+	mmu_cr4_features |= mask;
+	if (trampoline_cr4_features)
+		*trampoline_cr4_features = mmu_cr4_features;
+	cr4_set_bits(mask);
+}
+
 static inline void __native_flush_tlb(void)
 {
 	native_write_cr3(native_read_cr3());
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 5da71c27cc59..f41e19ca717b 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -19,6 +19,7 @@
 
 #include <asm/vmx.h>
 #include <asm/svm.h>
+#include <asm/tlbflush.h>
 
 /*
  * VMX functions:
@@ -40,7 +41,7 @@ static inline int cpu_has_vmx(void)
 static inline void cpu_vmxoff(void)
 {
 	asm volatile (ASM_VMX_VMXOFF : : : "cc");
-	write_cr4(read_cr4() & ~X86_CR4_VMXE);
+	cr4_clear_bits(X86_CR4_VMXE);
 }
 
 static inline int cpu_vmx_enabled(void)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b4f78c9ba19..847d62b78431 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -276,7 +276,7 @@ __setup("nosmep", setup_disable_smep);
 static __always_inline void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP))
-		set_in_cr4(X86_CR4_SMEP);
+		cr4_set_bits(X86_CR4_SMEP);
 }
 
 static __init int setup_disable_smap(char *arg)
@@ -296,9 +296,9 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_SMAP)) {
 #ifdef CONFIG_X86_SMAP
-		set_in_cr4(X86_CR4_SMAP);
+		cr4_set_bits(X86_CR4_SMAP);
 #else
-		clear_in_cr4(X86_CR4_SMAP);
+		cr4_clear_bits(X86_CR4_SMAP);
 #endif
 	}
 }
@@ -1320,7 +1320,7 @@ void cpu_init(void)
 
 	pr_debug("Initializing CPU#%d\n", cpu);
 
-	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+	cr4_clear_bits(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	/*
 	 * Initialize the per-CPU GDT with the boot GDT,
@@ -1401,7 +1401,7 @@ void cpu_init(void)
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
 	if (cpu_feature_enabled(X86_FEATURE_VME) || cpu_has_tsc || cpu_has_de)
-		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+		cr4_clear_bits(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	load_current_idt();
 	switch_to_new_gdt(cpu);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668cebfd..617bc12ef575 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -43,6 +43,7 @@
 #include <linux/export.h>
 
 #include <asm/processor.h>
+#include <asm/tlbflush.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -1455,7 +1456,7 @@ static void __mcheck_cpu_init_generic(void)
 	bitmap_fill(all_banks, MAX_NR_BANKS);
 	machine_check_poll(MCP_UC | m_fl, &all_banks);
 
-	set_in_cr4(X86_CR4_MCE);
+	cr4_set_bits(X86_CR4_MCE);
 
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	if (cap & MCG_CTL_P)
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index a3042989398c..30692ac88d1e 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -8,6 +8,7 @@
 #include <linux/smp.h>
 
 #include <asm/processor.h>
+#include <asm/tlbflush.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -59,7 +60,7 @@ void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
 	       "Intel old style machine check architecture supported.\n");
 
 	/* Enable MCE: */
-	set_in_cr4(X86_CR4_MCE);
+	cr4_set_bits(X86_CR4_MCE);
 	printk(KERN_INFO
 	       "Intel old style machine check reporting enabled on CPU#%d.\n",
 	       smp_processor_id());
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 7dc5564d0cdf..590cc753ba8f 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 
 #include <asm/processor.h>
+#include <asm/tlbflush.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -31,7 +32,7 @@ void winchip_mcheck_init(struct cpuinfo_x86 *c)
 	lo &= ~(1<<4);	/* Enable MCE */
 	wrmsr(MSR_IDT_FCR1, lo, hi);
 
-	set_in_cr4(X86_CR4_MCE);
+	cr4_set_bits(X86_CR4_MCE);
 
 	printk(KERN_INFO
 	       "Winchip machine check reporting enabled on CPU#0.\n");
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1b8299dd3d91..2176647fdbb7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -31,6 +31,7 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
+#include <asm/tlbflush.h>
 #include <asm/timer.h>
 #include <asm/desc.h>
 #include <asm/ldt.h>
@@ -1336,7 +1337,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 
 	case CPU_STARTING:
 		if (x86_pmu.attr_rdpmc)
-			set_in_cr4(X86_CR4_PCE);
+			cr4_set_bits(X86_CR4_PCE);
 		if (x86_pmu.cpu_starting)
 			x86_pmu.cpu_starting(cpu);
 		break;
@@ -1842,9 +1843,9 @@ static void change_rdpmc(void *info)
 	bool enable = !!(unsigned long)info;
 
 	if (enable)
-		set_in_cr4(X86_CR4_PCE);
+		cr4_set_bits(X86_CR4_PCE);
 	else
-		clear_in_cr4(X86_CR4_PCE);
+		cr4_clear_bits(X86_CR4_PCE);
 }
 
 static ssize_t set_attr_rdpmc(struct device *cdev,
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a9a4229f6161..87727b03196d 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -13,6 +13,7 @@
 #include <asm/sigcontext.h>
 #include <asm/processor.h>
 #include <asm/math_emu.h>
+#include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/i387.h>
@@ -180,7 +181,7 @@ void fpu_init(void)
 	if (cpu_has_xmm)
 		cr4_mask |= X86_CR4_OSXMMEXCPT;
 	if (cr4_mask)
-		set_in_cr4(cr4_mask);
+		cr4_set_bits(cr4_mask);
 
 	cr0 = read_cr0();
 	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e127ddaa2d5a..046e2d620bbe 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/tlbflush.h>
 
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -141,7 +142,7 @@ void flush_thread(void)
 
 static void hard_disable_TSC(void)
 {
-	write_cr4(read_cr4() | X86_CR4_TSD);
+	cr4_set_bits(X86_CR4_TSD);
 }
 
 void disable_TSC(void)
@@ -158,7 +159,7 @@ void disable_TSC(void)
 
 static void hard_enable_TSC(void)
 {
-	write_cr4(read_cr4() & ~X86_CR4_TSD);
+	cr4_clear_bits(X86_CR4_TSD);
 }
 
 static void enable_TSC(void)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 4c540c4719d8..9828fdff6d59 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -12,6 +12,7 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/sigframe.h>
+#include <asm/tlbflush.h>
 #include <asm/xcr.h>
 
 /*
@@ -453,7 +454,7 @@ static void prepare_fx_sw_frame(void)
  */
 static inline void xstate_enable(void)
 {
-	set_in_cr4(X86_CR4_OSXSAVE);
+	cr4_set_bits(X86_CR4_OSXSAVE);
 	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
 }
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0acac81f198b..93e2649fb786 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2765,7 +2765,7 @@ static int hardware_enable(void)
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | test_bits);
 	}
-	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
+	cr4_set_bits(X86_CR4_VMXE);
 
 	if (vmm_exclusive) {
 		kvm_cpu_vmxon(phys_addr);
@@ -2802,7 +2802,7 @@ static void hardware_disable(void)
 		vmclear_local_loaded_vmcss();
 		kvm_cpu_vmxoff();
 	}
-	write_cr4(read_cr4() & ~X86_CR4_VMXE);
+	cr4_clear_bits(X86_CR4_VMXE);
 }
 
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 66dba36f2343..73b37cd0d253 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -144,11 +144,11 @@ static void __init probe_page_size_mask(void)
 
 	/* Enable PSE if available */
 	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
+		cr4_set_bits_and_update_boot(X86_CR4_PSE);
 
 	/* Enable PGE if available */
 	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
+		cr4_set_bits_and_update_boot(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 1a3f0445432a..03920ef71f9c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1483,10 +1483,10 @@ static void xen_pvh_set_cr_flags(int cpu)
 	 * set them here. For all, OSFXSR OSXMMEXCPT are set in fpu_init.
 	*/
 	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
+		cr4_set_bits_and_update_boot(X86_CR4_PSE);
 
 	if (cpu_has_pge)
-		set_in_cr4(X86_CR4_PGE);
+		cr4_set_bits_and_update_boot(X86_CR4_PGE);
 }
 
 /*
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 922a1acbf652..e1700ff370dd 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -452,9 +452,9 @@ void lguest_arch_handle_trap(struct lg_cpu *cpu)
 static void adjust_pge(void *on)
 {
 	if (on)
-		write_cr4(read_cr4() | X86_CR4_PGE);
+		cr4_set_bits(X86_CR4_PGE);
 	else
-		write_cr4(read_cr4() & ~X86_CR4_PGE);
+		cr4_clear_bits(X86_CR4_PGE);
 }
 
 /*H:020
-- 
1.9.3

