Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbaJNW6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:58:52 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48180 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbaJNW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:57:52 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 2/5] x86: Store a per-cpu shadow copy of CR4
Date: Tue, 14 Oct 2014 15:57:36 -0700
Message-Id: <808fa43ef6e24d1df47c2666174d997105b9582d.1413323611.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context switches and TLB flushes can change individual bits of CR4.
CR4 reads take several cycles, so store a shadow copy of CR4 in a
per-cpu variable.

To avoid wasting a cache line, I added the CR4 shadow to
cpu_tlbstate, which is already touched during context switches.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/tlbflush.h | 52 ++++++++++++++++++++++++++++++-----------
 arch/x86/kernel/cpu/common.c    |  7 ++++++
 arch/x86/kernel/head32.c        |  1 +
 arch/x86/kernel/head64.c        |  2 ++
 arch/x86/kvm/vmx.c              |  4 ++--
 arch/x86/mm/init.c              |  8 +++++++
 arch/x86/mm/tlb.c               |  3 ---
 7 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 95b672f8b493..a04cad4bcbc3 100644
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
+	this_cpu_write(cpu_tlbstate.cr4, read_cr4());
+}
+
 /* Set in this cpu's CR4. */
 static inline void cr4_set(unsigned long mask)
 {
 	unsigned long cr4;
 
-	cr4 = read_cr4();
-	cr4 |= mask;
-	write_cr4(cr4);
+	cr4 = this_cpu_read(cpu_tlbstate.cr4);
+	if (!(cr4 & mask)) {
+		cr4 |= mask;
+		this_cpu_write(cpu_tlbstate.cr4, cr4);
+		write_cr4(cr4);
+	}
 }
 
 /* Clear in this cpu's CR4. */
@@ -30,9 +53,18 @@ static inline void cr4_clear(unsigned long mask)
 {
 	unsigned long cr4;
 
-	cr4 = read_cr4();
-	cr4 &= ~mask;
-	write_cr4(cr4);
+	cr4 = this_cpu_read(cpu_tlbstate.cr4);
+	if (cr4 & mask) {
+		cr4 &= ~mask;
+		this_cpu_write(cpu_tlbstate.cr4, cr4);
+		write_cr4(cr4);
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7d8400a4b192..ec73485b00c5 100644
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
@@ -1285,6 +1286,12 @@ void cpu_init(void)
 	int i;
 
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
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a48c26d01ab8..c3927506e0f4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2710,7 +2710,7 @@ static int hardware_enable(void *garbage)
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 	u64 old, test_bits;
 
-	if (read_cr4() & X86_CR4_VMXE)
+	if (cr4_read_shadow() & X86_CR4_VMXE)
 		return -EBUSY;
 
 	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
@@ -4237,7 +4237,7 @@ static void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	struct desc_ptr dt;
 
 	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);  /* 22.2.3 */
-	vmcs_writel(HOST_CR4, read_cr4());  /* 22.2.3, 22.2.5 */
+	vmcs_writel(HOST_CR4, cr4_read_shadow());  /* 22.2.3, 22.2.5 */
 	vmcs_writel(HOST_CR3, read_cr3());  /* 22.2.3  FIXME: shadow tables */
 
 	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);  /* 22.2.4 */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f64386652bd5..866244267192 100644
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
-- 
1.9.3

