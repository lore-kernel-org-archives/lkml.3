Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaCGX1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:27:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaCGX1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:27:18 -0500
Date: Fri, 7 Mar 2014 15:25:57 -0800
Message-Id: <201403072325.s27NPvlt003528@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.14-rc6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: a.p.zijlstra@chello.nl, acme@ghostprotocols.net, bp@suse.de,
        dzickus@redhat.com, hpa@linux.intel.com, hpa@zytor.com,
        jolsa@redhat.com, linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        mingo@kernel.org, paulus@samba.org, peterz@infradead.org, rja@sgi.com,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de,
        vincent.weaver@maine.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of minor fixes.  The FPU stuff is still pending, I
fear.  I haven't heard anything from Suresh so I suspect I'm going to
have to dig into the init specifics myself and fix up the patchset.

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 5fa10196bdb5f190f595ebd048490ee52dddea0f:

  x86: Ignore NMIs that come in during early boot (2014-03-07 15:08:14 -0800)

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Quirk out SGI UV

H. Peter Anvin (2):
      Merge tag 'efi-urgent' into x86/urgent
      x86: Ignore NMIs that come in during early boot

Jiri Olsa (1):
      x86, trace: Fix CR2 corruption when tracing page faults

Peter Zijlstra (1):
      x86, trace: Further robustify CR2 handling vs tracing

 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/head_32.S   |  7 ++++++-
 arch/x86/kernel/head_64.S   |  6 +++++-
 arch/x86/kernel/setup.c     | 10 ++--------
 arch/x86/mm/fault.c         | 47 +++++++++++++++++++++++++++++++--------------
 arch/x86/platform/efi/efi.c | 20 +++++++++++++++++++
 6 files changed, 67 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 3d6b9f8..acd86c8 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -134,6 +134,7 @@ extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
+extern void __init efi_apply_memmap_quirks(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 81ba276..d2a2159 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -544,6 +544,10 @@ ENDPROC(early_idt_handlers)
 	/* This is global to keep gas from relaxing the jumps */
 ENTRY(early_idt_handler)
 	cld
+
+	cmpl $X86_TRAP_NMI,(%esp)
+	je is_nmi		# Ignore NMI
+
 	cmpl $2,%ss:early_recursion_flag
 	je hlt_loop
 	incl %ss:early_recursion_flag
@@ -594,8 +598,9 @@ ex_entry:
 	pop %edx
 	pop %ecx
 	pop %eax
-	addl $8,%esp		/* drop vector number and error code */
 	decl %ss:early_recursion_flag
+is_nmi:
+	addl $8,%esp		/* drop vector number and error code */
 	iret
 ENDPROC(early_idt_handler)
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e1aabdb..33f36c7 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -343,6 +343,9 @@ early_idt_handlers:
 ENTRY(early_idt_handler)
 	cld
 
+	cmpl $X86_TRAP_NMI,(%rsp)
+	je is_nmi		# Ignore NMI
+
 	cmpl $2,early_recursion_flag(%rip)
 	jz  1f
 	incl early_recursion_flag(%rip)
@@ -405,8 +408,9 @@ ENTRY(early_idt_handler)
 	popq %rdx
 	popq %rcx
 	popq %rax
-	addq $16,%rsp		# drop vector number and error code
 	decl early_recursion_flag(%rip)
+is_nmi:
+	addq $16,%rsp		# drop vector number and error code
 	INTERRUPT_RETURN
 ENDPROC(early_idt_handler)
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 06853e6..ce72964 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1239,14 +1239,8 @@ void __init setup_arch(char **cmdline_p)
 	register_refined_jiffies(CLOCK_TICK_RATE);
 
 #ifdef CONFIG_EFI
-	/* Once setup is done above, unmap the EFI memory map on
-	 * mismatched firmware/kernel archtectures since there is no
-	 * support for runtime services.
-	 */
-	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
-		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
-		efi_unmap_memmap();
-	}
+	if (efi_enabled(EFI_BOOT))
+		efi_apply_memmap_quirks();
 #endif
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6dea040..a10c8c7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1020,13 +1020,17 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
  * routines.
+ *
+ * This function must have noinline because both callers
+ * {,trace_}do_page_fault() have notrace on. Having this an actual function
+ * guarantees there's a function trace entry.
  */
-static void __kprobes
-__do_page_fault(struct pt_regs *regs, unsigned long error_code)
+static void __kprobes noinline
+__do_page_fault(struct pt_regs *regs, unsigned long error_code,
+		unsigned long address)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	unsigned long address;
 	struct mm_struct *mm;
 	int fault;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
@@ -1034,9 +1038,6 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	tsk = current;
 	mm = tsk->mm;
 
-	/* Get the faulting address: */
-	address = read_cr2();
-
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.
@@ -1248,32 +1249,50 @@ good_area:
 	up_read(&mm->mmap_sem);
 }
 
-dotraplinkage void __kprobes
+dotraplinkage void __kprobes notrace
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
+	unsigned long address = read_cr2(); /* Get the faulting address */
 	enum ctx_state prev_state;
 
+	/*
+	 * We must have this function tagged with __kprobes, notrace and call
+	 * read_cr2() before calling anything else. To avoid calling any kind
+	 * of tracing machinery before we've observed the CR2 value.
+	 *
+	 * exception_{enter,exit}() contain all sorts of tracepoints.
+	 */
+
 	prev_state = exception_enter();
-	__do_page_fault(regs, error_code);
+	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
 
-static void trace_page_fault_entries(struct pt_regs *regs,
+#ifdef CONFIG_TRACING
+static void trace_page_fault_entries(unsigned long address, struct pt_regs *regs,
 				     unsigned long error_code)
 {
 	if (user_mode(regs))
-		trace_page_fault_user(read_cr2(), regs, error_code);
+		trace_page_fault_user(address, regs, error_code);
 	else
-		trace_page_fault_kernel(read_cr2(), regs, error_code);
+		trace_page_fault_kernel(address, regs, error_code);
 }
 
-dotraplinkage void __kprobes
+dotraplinkage void __kprobes notrace
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
+	/*
+	 * The exception_enter and tracepoint processing could
+	 * trigger another page faults (user space callchain
+	 * reading) and destroy the original cr2 value, so read
+	 * the faulting address now.
+	 */
+	unsigned long address = read_cr2();
 	enum ctx_state prev_state;
 
 	prev_state = exception_enter();
-	trace_page_fault_entries(regs, error_code);
-	__do_page_fault(regs, error_code);
+	trace_page_fault_entries(address, regs, error_code);
+	__do_page_fault(regs, error_code, address);
 	exception_exit(prev_state);
 }
+#endif /* CONFIG_TRACING */
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1a201ac..b97acec 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -52,6 +52,7 @@
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
 #include <asm/rtc.h>
+#include <asm/uv/uv.h>
 
 #define EFI_DEBUG
 
@@ -1210,3 +1211,22 @@ static int __init parse_efi_cmdline(char *str)
 	return 0;
 }
 early_param("efi", parse_efi_cmdline);
+
+void __init efi_apply_memmap_quirks(void)
+{
+	/*
+	 * Once setup is done earlier, unmap the EFI memory map on mismatched
+	 * firmware/kernel architectures since there is no support for runtime
+	 * services.
+	 */
+	if (!efi_is_native()) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_unmap_memmap();
+	}
+
+	/*
+	 * UV doesn't support the new EFI pagetable mapping yet.
+	 */
+	if (is_uv_system())
+		set_bit(EFI_OLD_MEMMAP, &x86_efi_facility);
+}
