Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaJNW5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:57:54 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63894 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaJNW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:57:50 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 1/5] x86: Clean up cr4 manipulation
Date: Tue, 14 Oct 2014 15:57:35 -0700
Message-Id: <724658a527c0572dde1a400a5e90b85f45421201.1413323611.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CR4 manipulation was split, seemingly at random, between direct
(write_cr4) and using a helper (set/clear_in_cr4).  Unfortunately,
the set_in_cr4 and clear_in_cr4 helpers also poke at the boot code,
which only a small subset of users actually wanted.

This patch replaces all cr4 access in functions that don't leave cr4
exactly the way they found it with new helpers cr4_set, cr4_clear,
and cr4_set_and_update_boot.

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
 14 files changed, 67 insertions(+), 55 deletions(-)

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
index 04905bfc508b..95b672f8b493 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -15,6 +15,43 @@
 #define __flush_tlb_single(addr) __native_flush_tlb_single(addr)
 #endif
 
+/* Set in this cpu's CR4. */
+static inline void cr4_set(unsigned long mask)
+{
+	unsigned long cr4;
+
+	cr4 = read_cr4();
+	cr4 |= mask;
+	write_cr4(cr4);
+}
+
+/* Clear in this cpu's CR4. */
+static inline void cr4_clear(unsigned long mask)
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
+static inline void cr4_set_and_update_boot(unsigned long mask)
+{
+	mmu_cr4_features |= mask;
+	if (trampoline_cr4_features)
+		*trampoline_cr4_features = mmu_cr4_features;
+	cr4_set(mask);
+}
+
 static inline void __native_flush_tlb(void)
 {
 	native_write_cr3(native_read_cr3());
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 5da71c27cc59..7503a642294a 100644
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
+	cr4_clear(X86_CR4_VMXE);
 }
 
 static inline int cpu_vmx_enabled(void)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b42bd6f..7d8400a4b192 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -276,7 +276,7 @@ __setup("nosmep", setup_disable_smep);
 static __always_inline void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP))
-		set_in_cr4(X86_CR4_SMEP);
+		cr4_set(X86_CR4_SMEP);
 }
 
 static __init int setup_disable_smap(char *arg)
@@ -296,9 +296,9 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_SMAP)) {
 #ifdef CONFIG_X86_SMAP
-		set_in_cr4(X86_CR4_SMAP);
+		cr4_set(X86_CR4_SMAP);
 #else
-		clear_in_cr4(X86_CR4_SMAP);
+		cr4_clear(X86_CR4_SMAP);
 #endif
 	}
 }
@@ -1307,7 +1307,7 @@ void cpu_init(void)
 
 	pr_debug("Initializing CPU#%d\n", cpu);
 
-	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+	cr4_clear(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	/*
 	 * Initialize the per-CPU GDT with the boot GDT,
@@ -1392,7 +1392,7 @@ void cpu_init(void)
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
-		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+		cr4_clear(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	load_current_idt();
 	switch_to_new_gdt(cpu);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bd9ccda8087f..d1b4903d82bb 100644
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
+	cr4_set(X86_CR4_MCE);
 
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	if (cap & MCG_CTL_P)
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index a3042989398c..fed632fd79bb 100644
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
+	cr4_set(X86_CR4_MCE);
 	printk(KERN_INFO
 	       "Intel old style machine check reporting enabled on CPU#%d.\n",
 	       smp_processor_id());
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 7dc5564d0cdf..e4b151428915 100644
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
+	cr4_set(X86_CR4_MCE);
 
 	printk(KERN_INFO
 	       "Winchip machine check reporting enabled on CPU#0.\n");
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2879ecdaac43..2401593df4a3 100644
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
@@ -1326,7 +1327,7 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 
 	case CPU_STARTING:
 		if (x86_pmu.attr_rdpmc)
-			set_in_cr4(X86_CR4_PCE);
+			cr4_set(X86_CR4_PCE);
 		if (x86_pmu.cpu_starting)
 			x86_pmu.cpu_starting(cpu);
 		break;
@@ -1832,9 +1833,9 @@ static void change_rdpmc(void *info)
 	bool enable = !!(unsigned long)info;
 
 	if (enable)
-		set_in_cr4(X86_CR4_PCE);
+		cr4_set(X86_CR4_PCE);
 	else
-		clear_in_cr4(X86_CR4_PCE);
+		cr4_clear(X86_CR4_PCE);
 }
 
 static ssize_t set_attr_rdpmc(struct device *cdev,
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index a9a4229f6161..dc369b52e949 100644
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
+		cr4_set(cr4_mask);
 
 	cr0 = read_cr0();
 	cr0 &= ~(X86_CR0_TS|X86_CR0_EM); /* clear TS and EM */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f804dc935d2a..d7e4c27b731f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/tlbflush.h>
 
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -139,7 +140,7 @@ void flush_thread(void)
 
 static void hard_disable_TSC(void)
 {
-	write_cr4(read_cr4() | X86_CR4_TSD);
+	cr4_set(X86_CR4_TSD);
 }
 
 void disable_TSC(void)
@@ -156,7 +157,7 @@ void disable_TSC(void)
 
 static void hard_enable_TSC(void)
 {
-	write_cr4(read_cr4() & ~X86_CR4_TSD);
+	cr4_clear(X86_CR4_TSD);
 }
 
 static void enable_TSC(void)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 940b142cc11f..c4057fd56c38 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -12,6 +12,7 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/sigframe.h>
+#include <asm/tlbflush.h>
 #include <asm/xcr.h>
 
 /*
@@ -452,7 +453,7 @@ static void prepare_fx_sw_frame(void)
  */
 static inline void xstate_enable(void)
 {
-	set_in_cr4(X86_CR4_OSXSAVE);
+	cr4_set(X86_CR4_OSXSAVE);
 	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
 }
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bfe11cf124a1..a48c26d01ab8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2737,7 +2737,7 @@ static int hardware_enable(void *garbage)
 		/* enable and lock */
 		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | test_bits);
 	}
-	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
+	cr4_set(X86_CR4_VMXE);
 
 	if (vmm_exclusive) {
 		kvm_cpu_vmxon(phys_addr);
@@ -2774,7 +2774,7 @@ static void hardware_disable(void *garbage)
 		vmclear_local_loaded_vmcss();
 		kvm_cpu_vmxoff();
 	}
-	write_cr4(read_cr4() & ~X86_CR4_VMXE);
+	cr4_clear(X86_CR4_VMXE);
 }
 
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 66dba36f2343..f64386652bd5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -144,11 +144,11 @@ static void __init probe_page_size_mask(void)
 
 	/* Enable PSE if available */
 	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
+		cr4_set_and_update_boot(X86_CR4_PSE);
 
 	/* Enable PGE if available */
 	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
+		cr4_set_and_update_boot(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11fb5008..9acf0af34ed1 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1482,10 +1482,10 @@ static void xen_pvh_set_cr_flags(int cpu)
 	 * set them here. For all, OSFXSR OSXMMEXCPT are set in fpu_init.
 	*/
 	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
+		cr4_set_and_update_boot(X86_CR4_PSE);
 
 	if (cpu_has_pge)
-		set_in_cr4(X86_CR4_PGE);
+		cr4_set_and_update_boot(X86_CR4_PGE);
 }
 
 /*
-- 
1.9.3

