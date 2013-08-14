Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab3HNRbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:31:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32822 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967Ab3HNRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:31:29 -0400
Date: Wed, 14 Aug 2013 19:31:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
Message-ID: <20130814173119.GC21191@laptop.programming.kicks-ass.net>
References: <20130814131539.790947874@chello.nl>
 <520B8A81.1080405@zytor.com>
 <20130814160416.GI24092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814160416.GI24092@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 06:04:16PM +0200, Peter Zijlstra wrote:
> OK, so something like the below would cure the worst of that I suppose.
> It compiles but doesn't boot; must've done something wrong.
> 
> Someone please look at it because my asm-foo blows. I pretty much
> copy/pasted this from asm/percpu.h.

OK, another hatchet job, now with bits borrowed from Andi's
voluntary-preempt v1. This one actually boots.

---
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
@@ -20,6 +20,28 @@ static __always_inline int *preempt_coun
 	return &__raw_get_cpu_var(__preempt_count);
 }
 
+#define __preempt_count_add(x) do {		\
+	asm volatile("addl %1," __percpu_arg(0)	\
+		: "+m" (__preempt_count) 	\
+		: "ri" ((int)x) 		\
+		: "memory"); 			\
+} while (0)
+
+#define __preempt_count_sub(x) do {		\
+	asm volatile("subl %1," __percpu_arg(0)	\
+		: "+m" (__preempt_count) 	\
+		: "ri" ((int)x) 		\
+		: "memory"); 			\
+} while (0)
+
+#define __preempt_enable() do {				\
+	asm volatile("\nsubl $1," __percpu_arg(0)	\
+		     "\njnz 1f"				\
+		     "\ncall __preempt_schedule"	\
+		     "\n1:" 				\
+		: "+m" (__preempt_count) : : "memory");	\
+} while (0)
+
 /*
  * must be macros to avoid header recursion hell
  */
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
+ENTRY(__preempt_schedule)
+	CFI_STARTPROC
+	SAVE_ALL
+	call preempt_schedule
+	RESTORE_ALL
+	ret
+	CFI_ENDPROC
+
+#ifdef CONFIG_CONTEXT_TRACKING
+
+ENTRY(__preempt_schedule_context)
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
@@ -17,6 +17,9 @@ static __always_inline int *preempt_coun
 	return &current_thread_info()->preempt_count;
 }
 
+#define __preempt_count_add(x)	do { current_thread_info()->preempt_count += (x); } while (0)
+#define __preempt_count_sub(x)  __preempt_count_add(-(x))
+
 /*
  * must be macros to avoid header recursion hell
  */
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -45,8 +45,8 @@ static __always_inline bool test_preempt
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
-# define add_preempt_count(val)	do { *preempt_count_ptr() += (val); } while (0)
-# define sub_preempt_count(val)	do { *preempt_count_ptr() -= (val); } while (0)
+# define add_preempt_count(val)	__preempt_count_add(val)
+# define sub_preempt_count(val)	__preempt_count_sub(val)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
@@ -64,7 +64,7 @@ do { \
 
 #ifdef CONFIG_CONTEXT_TRACKING
 
-void preempt_schedule_context(void);
+asmlinkage void preempt_schedule_context(void);
 
 #define preempt_check_resched_context() \
 do { \
@@ -101,17 +101,19 @@ do { \
 
 #define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
 
+#ifndef __preempt_enable
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
 	preempt_check_resched(); \
 } while (0)
+#else
+#define preempt_enable() __preempt_enable()
+#endif
 
 /* For debugging and tracer internals only! */
-#define add_preempt_count_notrace(val)			\
-	do { *preempt_count_ptr() += (val); } while (0)
-#define sub_preempt_count_notrace(val)			\
-	do { *preempt_count_ptr() -= (val); } while (0)
+#define add_preempt_count_notrace(val)	__preempt_count_add(val)
+#define sub_preempt_count_notrace(val)	__preempt_count_sub(val)
 #define inc_preempt_count_notrace() add_preempt_count_notrace(1)
 #define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
 
