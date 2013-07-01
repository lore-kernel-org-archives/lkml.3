Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3GAJpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:45:34 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:44833 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:45:32 -0400
Date: Mon, 1 Jul 2013 11:45:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.11
Message-ID: <20130701094528.GA16494@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: a3d7b7dddcc38c19aa46509c7282e8def80384a8 x86, asm, cleanup: Replace open-coded control register values with symbolic

Misc changes, with a bigger processor-flags cleanup/reorganization by
H. Peter Anvin.

out-of-topic modifications in x86-asm-for-linus:
------------------------------------------------
drivers/lguest/x86/core.c          # 1adfa76: x86, flags: Rename X86_EFLAGS_BIT
include/uapi/linux/const.h         # 2fc016c: linux/const.h: Add _BITUL() and _

 Thanks,

	Ingo

------------------>
H. Peter Anvin (5):
      linux/const.h: Add _BITUL() and _BITULL()
      x86, flags: Rename X86_EFLAGS_BIT1 to X86_EFLAGS_FIXED
      x86: Rename X86_CR4_RDWRGSFS to X86_CR4_FSGSBASE
      x86, processor-flags: Fix the datatypes and add bit number defines
      x86, asm, cleanup: Replace open-coded control register values with symbolic

Jan Beulich (1):
      x86: __force_order doesn't need to be an actual variable

Joe Perches (1):
      x86/vdso: Convert use of typedef ctl_table to struct ctl_table


 arch/x86/include/asm/kvm_host.h             |   2 +-
 arch/x86/include/asm/special_insns.h        |   2 +-
 arch/x86/include/uapi/asm/processor-flags.h | 154 +++++++++++++++++++---------
 arch/x86/kernel/cpu/mtrr/cyrix.c            |   2 +-
 arch/x86/kernel/cpu/mtrr/generic.c          |   2 +-
 arch/x86/kernel/entry_64.S                  |   2 +-
 arch/x86/kernel/process_32.c                |   2 +-
 arch/x86/kernel/process_64.c                |   2 +-
 arch/x86/kernel/relocate_kernel_32.S        |   2 +-
 arch/x86/kvm/vmx.c                          |   2 +-
 arch/x86/kvm/x86.c                          |   2 +-
 arch/x86/vdso/vdso32-setup.c                |   4 +-
 drivers/lguest/x86/core.c                   |   2 +-
 include/uapi/linux/const.h                  |   3 +
 14 files changed, 120 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3741c65..af9c552 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -59,7 +59,7 @@
 	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
 			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE     \
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
-			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_RDWRGSFS \
+			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 41fc93a..2f4d924 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -16,7 +16,7 @@ static inline void native_clts(void)
  * all loads stores around it, which can hurt performance. Solution is to
  * use a variable and mimic reads and writes to it to enforce serialization
  */
-static unsigned long __force_order;
+extern unsigned long __force_order;
 
 static inline unsigned long native_read_cr0(void)
 {
diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index 54991a7..180a0c3 100644
--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -2,75 +2,129 @@
 #define _UAPI_ASM_X86_PROCESSOR_FLAGS_H
 /* Various flags defined: can be included from assembler. */
 
+#include <linux/const.h>
+
 /*
  * EFLAGS bits
  */
-#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
-#define X86_EFLAGS_BIT1	0x00000002 /* Bit 1 - always on */
-#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
-#define X86_EFLAGS_AF	0x00000010 /* Auxiliary carry Flag */
-#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
-#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
-#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
-#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
-#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
-#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
-#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
-#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
-#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
-#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
-#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
-#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
-#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
-#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
+#define X86_EFLAGS_CF_BIT	0 /* Carry Flag */
+#define X86_EFLAGS_CF		_BITUL(X86_EFLAGS_CF_BIT)
+#define X86_EFLAGS_FIXED_BIT	1 /* Bit 1 - always on */
+#define X86_EFLAGS_FIXED	_BITUL(X86_EFLAGS_FIXED_BIT)
+#define X86_EFLAGS_PF_BIT	2 /* Parity Flag */
+#define X86_EFLAGS_PF		_BITUL(X86_EFLAGS_PF_BIT)
+#define X86_EFLAGS_AF_BIT	4 /* Auxiliary carry Flag */
+#define X86_EFLAGS_AF		_BITUL(X86_EFLAGS_AF_BIT)
+#define X86_EFLAGS_ZF_BIT	6 /* Zero Flag */
+#define X86_EFLAGS_ZF		_BITUL(X86_EFLAGS_ZF_BIT)
+#define X86_EFLAGS_SF_BIT	7 /* Sign Flag */
+#define X86_EFLAGS_SF		_BITUL(X86_EFLAGS_SF_BIT)
+#define X86_EFLAGS_TF_BIT	8 /* Trap Flag */
+#define X86_EFLAGS_TF		_BITUL(X86_EFLAGS_TF_BIT)
+#define X86_EFLAGS_IF_BIT	9 /* Interrupt Flag */
+#define X86_EFLAGS_IF		_BITUL(X86_EFLAGS_IF_BIT)
+#define X86_EFLAGS_DF_BIT	10 /* Direction Flag */
+#define X86_EFLAGS_DF		_BITUL(X86_EFLAGS_DF_BIT)
+#define X86_EFLAGS_OF_BIT	11 /* Overflow Flag */
+#define X86_EFLAGS_OF		_BITUL(X86_EFLAGS_OF_BIT)
+#define X86_EFLAGS_IOPL_BIT	12 /* I/O Privilege Level (2 bits) */
+#define X86_EFLAGS_IOPL		(_AC(3,UL) << X86_EFLAGS_IOPL_BIT)
+#define X86_EFLAGS_NT_BIT	14 /* Nested Task */
+#define X86_EFLAGS_NT		_BITUL(X86_EFLAGS_NT_BIT)
+#define X86_EFLAGS_RF_BIT	16 /* Resume Flag */
+#define X86_EFLAGS_RF		_BITUL(X86_EFLAGS_RF_BIT)
+#define X86_EFLAGS_VM_BIT	17 /* Virtual Mode */
+#define X86_EFLAGS_VM		_BITUL(X86_EFLAGS_VM_BIT)
+#define X86_EFLAGS_AC_BIT	18 /* Alignment Check/Access Control */
+#define X86_EFLAGS_AC		_BITUL(X86_EFLAGS_AC_BIT)
+#define X86_EFLAGS_AC_BIT	18 /* Alignment Check/Access Control */
+#define X86_EFLAGS_AC		_BITUL(X86_EFLAGS_AC_BIT)
+#define X86_EFLAGS_VIF_BIT	19 /* Virtual Interrupt Flag */
+#define X86_EFLAGS_VIF		_BITUL(X86_EFLAGS_VIF_BIT)
+#define X86_EFLAGS_VIP_BIT	20 /* Virtual Interrupt Pending */
+#define X86_EFLAGS_VIP		_BITUL(X86_EFLAGS_VIP_BIT)
+#define X86_EFLAGS_ID_BIT	21 /* CPUID detection */
+#define X86_EFLAGS_ID		_BITUL(X86_EFLAGS_ID_BIT)
 
 /*
  * Basic CPU control in CR0
  */
-#define X86_CR0_PE	0x00000001 /* Protection Enable */
-#define X86_CR0_MP	0x00000002 /* Monitor Coprocessor */
-#define X86_CR0_EM	0x00000004 /* Emulation */
-#define X86_CR0_TS	0x00000008 /* Task Switched */
-#define X86_CR0_ET	0x00000010 /* Extension Type */
-#define X86_CR0_NE	0x00000020 /* Numeric Error */
-#define X86_CR0_WP	0x00010000 /* Write Protect */
-#define X86_CR0_AM	0x00040000 /* Alignment Mask */
-#define X86_CR0_NW	0x20000000 /* Not Write-through */
-#define X86_CR0_CD	0x40000000 /* Cache Disable */
-#define X86_CR0_PG	0x80000000 /* Paging */
+#define X86_CR0_PE_BIT		0 /* Protection Enable */
+#define X86_CR0_PE		_BITUL(X86_CR0_PE_BIT)
+#define X86_CR0_MP_BIT		1 /* Monitor Coprocessor */
+#define X86_CR0_MP		_BITUL(X86_CR0_MP_BIT)
+#define X86_CR0_EM_BIT		2 /* Emulation */
+#define X86_CR0_EM		_BITUL(X86_CR0_EM_BIT)
+#define X86_CR0_TS_BIT		3 /* Task Switched */
+#define X86_CR0_TS		_BITUL(X86_CR0_TS_BIT)
+#define X86_CR0_ET_BIT		4 /* Extension Type */
+#define X86_CR0_ET		_BITUL(X86_CR0_ET_BIT)
+#define X86_CR0_NE_BIT		5 /* Numeric Error */
+#define X86_CR0_NE		_BITUL(X86_CR0_NE_BIT)
+#define X86_CR0_WP_BIT		16 /* Write Protect */
+#define X86_CR0_WP		_BITUL(X86_CR0_WP_BIT)
+#define X86_CR0_AM_BIT		18 /* Alignment Mask */
+#define X86_CR0_AM		_BITUL(X86_CR0_AM_BIT)
+#define X86_CR0_NW_BIT		29 /* Not Write-through */
+#define X86_CR0_NW		_BITUL(X86_CR0_NW_BIT)
+#define X86_CR0_CD_BIT		30 /* Cache Disable */
+#define X86_CR0_CD		_BITUL(X86_CR0_CD_BIT)
+#define X86_CR0_PG_BIT		31 /* Paging */
+#define X86_CR0_PG		_BITUL(X86_CR0_PG_BIT)
 
 /*
  * Paging options in CR3
  */
-#define X86_CR3_PWT	0x00000008 /* Page Write Through */
-#define X86_CR3_PCD	0x00000010 /* Page Cache Disable */
-#define X86_CR3_PCID_MASK 0x00000fff /* PCID Mask */
+#define X86_CR3_PWT_BIT		3 /* Page Write Through */
+#define X86_CR3_PWT		_BITUL(X86_CR3_PWT_BIT)
+#define X86_CR3_PCD_BIT		4 /* Page Cache Disable */
+#define X86_CR3_PCD		_BITUL(X86_CR3_PCD_BIT)
+#define X86_CR3_PCID_MASK	_AC(0x00000fff,UL) /* PCID Mask */
 
 /*
  * Intel CPU features in CR4
  */
-#define X86_CR4_VME	0x00000001 /* enable vm86 extensions */
-#define X86_CR4_PVI	0x00000002 /* virtual interrupts flag enable */
-#define X86_CR4_TSD	0x00000004 /* disable time stamp at ipl 3 */
-#define X86_CR4_DE	0x00000008 /* enable debugging extensions */
-#define X86_CR4_PSE	0x00000010 /* enable page size extensions */
-#define X86_CR4_PAE	0x00000020 /* enable physical address extensions */
-#define X86_CR4_MCE	0x00000040 /* Machine check enable */
-#define X86_CR4_PGE	0x00000080 /* enable global pages */
-#define X86_CR4_PCE	0x00000100 /* enable performance counters at ipl 3 */
-#define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
-#define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
-#define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
-#define X86_CR4_RDWRGSFS 0x00010000 /* enable RDWRGSFS support */
-#define X86_CR4_PCIDE	0x00020000 /* enable PCID support */
-#define X86_CR4_OSXSAVE 0x00040000 /* enable xsave and xrestore */
-#define X86_CR4_SMEP	0x00100000 /* enable SMEP support */
-#define X86_CR4_SMAP	0x00200000 /* enable SMAP support */
+#define X86_CR4_VME_BIT		0 /* enable vm86 extensions */
+#define X86_CR4_VME		_BITUL(X86_CR4_VME_BIT)
+#define X86_CR4_PVI_BIT		1 /* virtual interrupts flag enable */
+#define X86_CR4_PVI		_BITUL(X86_CR4_PVI_BIT)
+#define X86_CR4_TSD_BIT		2 /* disable time stamp at ipl 3 */
+#define X86_CR4_TSD		_BITUL(X86_CR4_TSD_BIT)
+#define X86_CR4_DE_BIT		3 /* enable debugging extensions */
+#define X86_CR4_DE		_BITUL(X86_CR4_DE_BIT)
+#define X86_CR4_PSE_BIT		4 /* enable page size extensions */
+#define X86_CR4_PSE		_BITUL(X86_CR4_PSE_BIT)
+#define X86_CR4_PAE_BIT		5 /* enable physical address extensions */
+#define X86_CR4_PAE		_BITUL(X86_CR4_PAE_BIT)
+#define X86_CR4_MCE_BIT		6 /* Machine check enable */
+#define X86_CR4_MCE		_BITUL(X86_CR4_MCE_BIT)
+#define X86_CR4_PGE_BIT		7 /* enable global pages */
+#define X86_CR4_PGE		_BITUL(X86_CR4_PGE_BIT)
+#define X86_CR4_PCE_BIT		8 /* enable performance counters at ipl 3 */
+#define X86_CR4_PCE		_BITUL(X86_CR4_PCE_BIT)
+#define X86_CR4_OSFXSR_BIT	9 /* enable fast FPU save and restore */
+#define X86_CR4_OSFXSR		_BITUL(X86_CR4_OSFXSR_BIT)
+#define X86_CR4_OSXMMEXCPT_BIT	10 /* enable unmasked SSE exceptions */
+#define X86_CR4_OSXMMEXCPT	_BITUL(X86_CR4_OSXMMEXCPT_BIT)
+#define X86_CR4_VMXE_BIT	13 /* enable VMX virtualization */
+#define X86_CR4_VMXE		_BITUL(X86_CR4_VMXE_BIT)
+#define X86_CR4_SMXE_BIT	14 /* enable safer mode (TXT) */
+#define X86_CR4_SMXE		_BITUL(X86_CR4_SMXE_BIT)
+#define X86_CR4_FSGSBASE_BIT	16 /* enable RDWRFSGS support */
+#define X86_CR4_FSGSBASE	_BITUL(X86_CR4_FSGSBASE_BIT)
+#define X86_CR4_PCIDE_BIT	17 /* enable PCID support */
+#define X86_CR4_PCIDE		_BITUL(X86_CR4_PCIDE_BIT)
+#define X86_CR4_OSXSAVE_BIT	18 /* enable xsave and xrestore */
+#define X86_CR4_OSXSAVE		_BITUL(X86_CR4_OSXSAVE_BIT)
+#define X86_CR4_SMEP_BIT	20 /* enable SMEP support */
+#define X86_CR4_SMEP		_BITUL(X86_CR4_SMEP_BIT)
+#define X86_CR4_SMAP_BIT	21 /* enable SMAP support */
+#define X86_CR4_SMAP		_BITUL(X86_CR4_SMAP_BIT)
 
 /*
  * x86-64 Task Priority Register, CR8
  */
-#define X86_CR8_TPR	0x0000000F /* task priority register */
+#define X86_CR8_TPR		_AC(0x0000000f,UL) /* task priority register */
 
 /*
  * AMD and Transmeta use MSRs for configuration; see <asm/msr-index.h>
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 68a3343..9e451b0 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -167,7 +167,7 @@ static void post_set(void)
 	setCx86(CX86_CCR3, ccr3);
 
 	/* Enable caches */
-	write_cr0(read_cr0() & 0xbfffffff);
+	write_cr0(read_cr0() & ~X86_CR0_CD);
 
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index fa72a39..00f557b 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -701,7 +701,7 @@ static void post_set(void) __releases(set_atomicity_lock)
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 
 	/* Enable caches */
-	write_cr0(read_cr0() & 0xbfffffff);
+	write_cr0(read_cr0() & ~X86_CR0_CD);
 
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7272089..5fe1fb2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -365,7 +365,7 @@ ENDPROC(native_usergs_sysret64)
 	/*CFI_REL_OFFSET	ss,0*/
 	pushq_cfi %rax /* rsp */
 	CFI_REL_OFFSET	rsp,0
-	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_BIT1) /* eflags - interrupts on */
+	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED) /* eflags - interrupts on */
 	/*CFI_REL_OFFSET	rflags,0*/
 	pushq_cfi $__KERNEL_CS /* cs */
 	/*CFI_REL_OFFSET	cs,0*/
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7305f7d..0339f5c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -147,7 +147,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->bp = arg;
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
-		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		p->fpu_counter = 0;
 		p->thread.io_bitmap_ptr = NULL;
 		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 355ae06..f99a242 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -176,7 +176,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->bp = arg;
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
-		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		return 0;
 	}
 	*childregs = *current_pt_regs();
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index 36818f8..e13f8e7 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -186,7 +186,7 @@ identity_mapped:
 	movl	CP_PA_PGD(%ebx), %eax
 	movl	%eax, %cr3
 	movl	%cr0, %eax
-	orl	$(1<<31), %eax
+	orl	$X86_CR0_PG, %eax
 	movl	%eax, %cr0
 	lea	PAGE_SIZE(%edi), %esp
 	movl	%edi, %eax
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 260a919..b30f5a5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7942,7 +7942,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 
 	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->host_rsp);
 	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->host_rip);
-	vmx_set_rflags(vcpu, X86_EFLAGS_BIT1);
+	vmx_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	/*
 	 * Note that calling vmx_set_cr0 is important, even if cr0 hasn't
 	 * actually changed, because it depends on the current state of
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 094b5d9..6b941b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -619,7 +619,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (!guest_cpuid_has_smep(vcpu) && (cr4 & X86_CR4_SMEP))
 		return 1;
 
-	if (!guest_cpuid_has_fsgsbase(vcpu) && (cr4 & X86_CR4_RDWRGSFS))
+	if (!guest_cpuid_has_fsgsbase(vcpu) && (cr4 & X86_CR4_FSGSBASE))
 		return 1;
 
 	if (is_long_mode(vcpu)) {
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0faad64..d6bfb87 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -372,7 +372,7 @@ subsys_initcall(sysenter_setup);
 /* Register vsyscall32 into the ABI table */
 #include <linux/sysctl.h>
 
-static ctl_table abi_table2[] = {
+static struct ctl_table abi_table2[] = {
 	{
 		.procname	= "vsyscall32",
 		.data		= &sysctl_vsyscall32,
@@ -383,7 +383,7 @@ static ctl_table abi_table2[] = {
 	{}
 };
 
-static ctl_table abi_root_table2[] = {
+static struct ctl_table abi_root_table2[] = {
 	{
 		.procname = "abi",
 		.mode = 0555,
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index f0a3347..5169239 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -700,7 +700,7 @@ void lguest_arch_setup_regs(struct lg_cpu *cpu, unsigned long start)
 	 * interrupts are enabled.  We always leave interrupts enabled while
 	 * running the Guest.
 	 */
-	regs->eflags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+	regs->eflags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 
 	/*
 	 * The "Extended Instruction Pointer" register says where the Guest is
diff --git a/include/uapi/linux/const.h b/include/uapi/linux/const.h
index c22c707..c872bfd 100644
--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -21,4 +21,7 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
+#define _BITUL(x)	(_AC(1,UL) << (x))
+#define _BITULL(x)	(_AC(1,ULL) << (x))
+
 #endif /* !(_LINUX_CONST_H) */
