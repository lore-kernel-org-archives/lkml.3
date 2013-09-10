Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3IJNVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:21:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46847 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3IJNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:21:23 -0400
Message-Id: <20130910132011.474646746@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Sep 2013 15:08:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 7/7] sched, x86: Optimize the preempt_schedule() call
References: <20130910130811.507933095@infradead.org>
Content-Disposition: inline; filename=peterz-x86-opt-call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the bloat of the C calling convention out of the
preempt_enable() sites by creating an ASM wrapper which allows us to
do an asm("call ___preempt_schedule") instead.

calling.h bits by Andi Kleen

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/calling.h |   50 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/preempt.h |    8 ++++++
 arch/x86/kernel/Makefile       |    2 +
 arch/x86/kernel/preempt.S      |   25 ++++++++++++++++++++
 include/asm-generic/preempt.h  |   10 ++++++++
 include/linux/preempt.h        |   13 ++++------
 6 files changed, 100 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -48,6 +48,8 @@ For 32-bit we have the following convent
 
 #include <asm/dwarf2.h>
 
+#ifdef CONFIG_X86_64
+
 /*
  * 64-bit system call stack frame layout defines and helpers,
  * for assembly code:
@@ -192,3 +194,51 @@ For 32-bit we have the following convent
 	.macro icebp
 	.byte 0xf1
 	.endm
+
+#else /* CONFIG_X86_64 */
+
+/*
+ * For 32bit only simplified versions of SAVE_ALL/RESTORE_ALL. These
+ * are different from the entry_32.S versions in not changing the segment
+ * registers. So only suitable for in kernel use, not when transitioning
+ * from or to user space. The resulting stack frame is not a standard
+ * pt_regs frame. The main use case is calling C code from assembler
+ * when all the registers need to be preserved.
+ */
+
+	.macro SAVE_ALL
+	pushl_cfi %eax
+	CFI_REL_OFFSET eax, 0
+	pushl_cfi %ebp
+	CFI_REL_OFFSET ebp, 0
+	pushl_cfi %edi
+	CFI_REL_OFFSET edi, 0
+	pushl_cfi %esi
+	CFI_REL_OFFSET esi, 0
+	pushl_cfi %edx
+	CFI_REL_OFFSET edx, 0
+	pushl_cfi %ecx
+	CFI_REL_OFFSET ecx, 0
+	pushl_cfi %ebx
+	CFI_REL_OFFSET ebx, 0
+	.endm
+
+	.macro RESTORE_ALL
+	popl_cfi %ebx
+	CFI_RESTORE ebx
+	popl_cfi %ecx
+	CFI_RESTORE ecx
+	popl_cfi %edx
+	CFI_RESTORE edx
+	popl_cfi %esi
+	CFI_RESTORE esi
+	popl_cfi %edi
+	CFI_RESTORE edi
+	popl_cfi %ebp
+	CFI_RESTORE ebp
+	popl_cfi %eax
+	CFI_RESTORE eax
+	.endm
+
+#endif /* CONFIG_X86_64 */
+
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -99,4 +99,12 @@ static __always_inline bool should_resch
 	return unlikely(!__this_cpu_read_4(__preempt_count));
 }
 
+#ifdef CONFIG_PREEMPT
+#define __preempt_schedule() asm ("call ___preempt_schedule")
+
+#ifdef CONFIG_CONTEXT_TRACKING
+#define __preempt_schedule_context() asm ("call ___preempt_schedule_context")
+#endif
+#endif /* CONFIG_PREEMPT */
+
 #endif /* __ASM_PREEMPT_H */
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,6 +36,8 @@ obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
+obj-$(CONFIG_PREEMPT)	+= preempt.o
+
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
--- /dev/null
+++ b/arch/x86/kernel/preempt.S
@@ -0,0 +1,25 @@
+
+#include <linux/linkage.h>
+#include <asm/dwarf2.h>
+#include <asm/asm.h>
+#include <asm/calling.h>
+
+ENTRY(___preempt_schedule)
+	CFI_STARTPROC
+	SAVE_ALL
+	call preempt_schedule
+	RESTORE_ALL
+	ret
+	CFI_ENDPROC
+
+#ifdef CONFIG_CONTEXT_TRACKING
+
+ENTRY(___preempt_schedule_context)
+	CFI_STARTPROC
+	SAVE_ALL
+	call preempt_schedule_context
+	RESTORE_ALL
+	ret
+	CFI_ENDPROC
+
+#endif
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -90,4 +90,14 @@ static __always_inline bool should_resch
 	return unlikely(!*preempt_count_ptr());
 }
 
+#ifdef CONFIG_PREEMPT
+extern asmlinkage void preempt_schedule(void);
+#define __preempt_schedule() preempt_schedule()
+
+#ifdef CONFIG_CONTEXT_TRACKING
+extern asmlinkage void preempt_schedule_context(void);
+#define __preempt_schedule_context() preempt_schedule_context()
+#endif
+#endif /* CONFIG_PREEMPT */
+
 #endif /* __ASM_PREEMPT_H */
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -50,18 +50,17 @@ do { \
 #define preempt_enable_no_resched() sched_preempt_enable_no_resched()
 
 #ifdef CONFIG_PREEMPT
-asmlinkage void preempt_schedule(void);
 #define preempt_enable() \
 do { \
 	barrier(); \
 	if (unlikely(preempt_count_dec_and_test())) \
-		preempt_schedule(); \
+		__preempt_schedule(); \
 } while (0)
 
 #define preempt_check_resched() \
 do { \
 	if (should_resched()) \
-		preempt_schedule(); \
+		__preempt_schedule(); \
 } while (0)
 
 #else
@@ -83,17 +82,15 @@ do { \
 
 #ifdef CONFIG_PREEMPT
 
-#ifdef CONFIG_CONTEXT_TRACKING
-asmlinkage void preempt_schedule_context(void);
-#else
-#define preempt_schedule_context() preempt_schedule()
+#ifndef CONFIG_CONTEXT_TRACKING
+#define __preempt_schedule_context() __preempt_schedule()
 #endif
 
 #define preempt_enable_notrace() \
 do { \
 	barrier(); \
 	if (unlikely(__preempt_count_dec_and_test())) \
-		preempt_schedule_context(); \
+		__preempt_schedule_context(); \
 } while (0)
 #else
 #define preempt_enable_notrace() preempt_enable_no_resched_notrace()


