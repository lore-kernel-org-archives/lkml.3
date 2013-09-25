Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3IYQkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:40:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3IYQkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:40:18 -0400
Date: Wed, 25 Sep 2013 09:39:43 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-tk7xdi1cvvxewixzke8t8le1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, x86: Optimize the preempt_schedule() call
Git-Commit-ID: 1a338ac32ca630f67df25b4a16436cccc314e997
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:39:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a338ac32ca630f67df25b4a16436cccc314e997
Gitweb:     http://git.kernel.org/tip/1a338ac32ca630f67df25b4a16436cccc314e997
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 14 Aug 2013 14:51:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 14:23:07 +0200

sched, x86: Optimize the preempt_schedule() call

Remove the bloat of the C calling convention out of the
preempt_enable() sites by creating an ASM wrapper which allows us to
do an asm("call ___preempt_schedule") instead.

calling.h bits by Andi Kleen

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-tk7xdi1cvvxewixzke8t8le1@git.kernel.org
[ Fixed build error. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/calling.h   | 50 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/preempt.h   | 10 ++++++++
 arch/x86/kernel/Makefile         |  2 ++
 arch/x86/kernel/i386_ksyms_32.c  |  7 ++++++
 arch/x86/kernel/preempt.S        | 25 ++++++++++++++++++++
 arch/x86/kernel/x8664_ksyms_64.c |  7 ++++++
 include/asm-generic/preempt.h    | 10 ++++++++
 include/linux/preempt.h          | 13 ++++-------
 8 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 0fa6750..cb4c73b 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -48,6 +48,8 @@ For 32-bit we have the following conventions - kernel is built with
 
 #include <asm/dwarf2.h>
 
+#ifdef CONFIG_X86_64
+
 /*
  * 64-bit system call stack frame layout defines and helpers,
  * for assembly code:
@@ -192,3 +194,51 @@ For 32-bit we have the following conventions - kernel is built with
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
diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 1309942..1de41690 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -95,4 +95,14 @@ static __always_inline bool should_resched(void)
 	return unlikely(!__this_cpu_read_4(__preempt_count));
 }
 
+#ifdef CONFIG_PREEMPT
+  extern asmlinkage void ___preempt_schedule(void);
+# define __preempt_schedule() asm ("call ___preempt_schedule")
+  extern asmlinkage void preempt_schedule(void);
+# ifdef CONFIG_CONTEXT_TRACKING
+    extern asmlinkage void ___preempt_schedule_context(void);
+#   define __preempt_schedule_context() asm ("call ___preempt_schedule_context")
+# endif
+#endif
+
 #endif /* __ASM_PREEMPT_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a5408b9..9b0a34e 100644
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
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 0fa6912..05fd74f 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -37,3 +37,10 @@ EXPORT_SYMBOL(strstr);
 
 EXPORT_SYMBOL(csum_partial);
 EXPORT_SYMBOL(empty_zero_page);
+
+#ifdef CONFIG_PREEMPT
+EXPORT_SYMBOL(___preempt_schedule);
+#ifdef CONFIG_CONTEXT_TRACKING
+EXPORT_SYMBOL(___preempt_schedule_context);
+#endif
+#endif
diff --git a/arch/x86/kernel/preempt.S b/arch/x86/kernel/preempt.S
new file mode 100644
index 0000000..ca7f0d5
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
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index b014d94..0406819 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -66,3 +66,10 @@ EXPORT_SYMBOL(empty_zero_page);
 #ifndef CONFIG_PARAVIRT
 EXPORT_SYMBOL(native_load_gs_index);
 #endif
+
+#ifdef CONFIG_PREEMPT
+EXPORT_SYMBOL(___preempt_schedule);
+#ifdef CONFIG_CONTEXT_TRACKING
+EXPORT_SYMBOL(___preempt_schedule_context);
+#endif
+#endif
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index 82d958f..5dc14ed 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -100,4 +100,14 @@ static __always_inline bool should_resched(void)
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
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 2343d87..a3d9dc8 100644
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
