Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaCJAR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 20:17:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40179 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaCJAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 20:17:27 -0400
Date: Sun, 9 Mar 2014 17:15:22 -0700
Message-Id: <201403100015.s2A0FM4Z015106@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.14-rc6 - bad patch dropped
Cc: <jolsa@redhat.com>, <vincent.weaver@maine.edu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Russ Anderson <rja@sgi.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The same collection of fixes except the broken NMI patch dropped.  I
will send a fixed version of that plus Suresh' FPU fix in a few days,
to get them some testing, plus I will be on a trip (part of why I got
unduly rushed this past Friday.  Sorry again for that.)

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus-fixed

for you to fetch changes up to d4078e232267ff53f3b030b9698a3c001db4dbec:

  x86, trace: Further robustify CR2 handling vs tracing (2014-03-06 10:58:18 -0800)

----------------------------------------------------------------
Borislav Petkov (1):
      x86/efi: Quirk out SGI UV

H. Peter Anvin (1):
      Merge tag 'efi-urgent' into x86/urgent

Jiri Olsa (1):
      x86, trace: Fix CR2 corruption when tracing page faults

Peter Zijlstra (1):
      x86, trace: Further robustify CR2 handling vs tracing

 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/setup.c     | 10 ++--------
 arch/x86/mm/fault.c         | 47 +++++++++++++++++++++++++++++++--------------
 arch/x86/platform/efi/efi.c | 20 +++++++++++++++++++
 4 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 3d6b9f81cc68..acd86c850414 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -134,6 +134,7 @@ extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
+extern void __init efi_apply_memmap_quirks(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 06853e670354..ce72964b2f46 100644
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
index 6dea040cc3a1..a10c8c792161 100644
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
index 1a201ac7cef8..b97acecf3fd9 100644
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
