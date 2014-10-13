Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaJMHQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:16:43 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64024 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaJMHQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:16:40 -0400
Date: Mon, 13 Oct 2014 09:16:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm tree changes for v3.18
Message-ID: <20141013071636.GA13555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   # HEAD: f74954f01ec9bb2004bcc24f247d1f26f1063ad2 x86: Unwind-annotate thunk_32.S

The changes in this cycle were:

 - Speed up the x86 __preempt_schedule() implementation
 - Fix/improve low level asm code debug info annotations

 Thanks,

	Ingo

------------------>
Jan Beulich (3):
      x86: Improve cmpxchg16b_emu.S
      x86: Improve cmpxchg8b_emu.S
      x86: Unwind-annotate thunk_32.S

Oleg Nesterov (2):
      x86: Speed up ___preempt_schedule*() by using THUNK helpers
      x86/lib/Makefile: Remove the unnecessary "+= thunk_64.o"


 arch/x86/kernel/Makefile      |  2 --
 arch/x86/kernel/preempt.S     | 25 -------------------------
 arch/x86/lib/Makefile         |  2 +-
 arch/x86/lib/cmpxchg16b_emu.S | 32 +++++++++++++-------------------
 arch/x86/lib/cmpxchg8b_emu.S  | 20 +++++++++-----------
 arch/x86/lib/thunk_32.S       | 41 +++++++++++++++++++++++++++++++----------
 arch/x86/lib/thunk_64.S       |  7 +++++++
 7 files changed, 61 insertions(+), 68 deletions(-)
 delete mode 100644 arch/x86/kernel/preempt.S

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index ada2e2d6be3e..8f1e77440b2b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -39,8 +39,6 @@ obj-y			+= tsc.o tsc_msr.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
-obj-$(CONFIG_PREEMPT)	+= preempt.o
-
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
diff --git a/arch/x86/kernel/preempt.S b/arch/x86/kernel/preempt.S
deleted file mode 100644
index ca7f0d58a87d..000000000000
--- a/arch/x86/kernel/preempt.S
+++ /dev/null
@@ -1,25 +0,0 @@
-
-#include <linux/linkage.h>
-#include <asm/dwarf2.h>
-#include <asm/asm.h>
-#include <asm/calling.h>
-
-ENTRY(___preempt_schedule)
-	CFI_STARTPROC
-	SAVE_ALL
-	call preempt_schedule
-	RESTORE_ALL
-	ret
-	CFI_ENDPROC
-
-#ifdef CONFIG_CONTEXT_TRACKING
-
-ENTRY(___preempt_schedule_context)
-	CFI_STARTPROC
-	SAVE_ALL
-	call preempt_schedule_context
-	RESTORE_ALL
-	ret
-	CFI_ENDPROC
-
-#endif
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 4d4f96a27638..66127b919a99 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -39,7 +39,7 @@ endif
 else
         obj-y += iomap_copy_64.o
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
-        lib-y += thunk_64.o clear_page_64.o copy_page_64.o
+        lib-y += clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o copy_user_nocache_64.o
 	lib-y += cmpxchg16b_emu.o
diff --git a/arch/x86/lib/cmpxchg16b_emu.S b/arch/x86/lib/cmpxchg16b_emu.S
index 1e572c507d06..40a172541ee2 100644
--- a/arch/x86/lib/cmpxchg16b_emu.S
+++ b/arch/x86/lib/cmpxchg16b_emu.S
@@ -6,15 +6,8 @@
  *
  */
 #include <linux/linkage.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
 #include <asm/dwarf2.h>
-
-#ifdef CONFIG_SMP
-#define SEG_PREFIX %gs:
-#else
-#define SEG_PREFIX
-#endif
+#include <asm/percpu.h>
 
 .text
 
@@ -39,24 +32,25 @@ CFI_STARTPROC
 # *atomic* on a single cpu (as provided by the this_cpu_xx class of
 # macros).
 #
-this_cpu_cmpxchg16b_emu:
-	pushf
+	pushfq_cfi
 	cli
 
-	cmpq SEG_PREFIX(%rsi), %rax
-	jne not_same
-	cmpq SEG_PREFIX 8(%rsi), %rdx
-	jne not_same
+	cmpq PER_CPU_VAR((%rsi)), %rax
+	jne .Lnot_same
+	cmpq PER_CPU_VAR(8(%rsi)), %rdx
+	jne .Lnot_same
 
-	movq %rbx, SEG_PREFIX(%rsi)
-	movq %rcx, SEG_PREFIX 8(%rsi)
+	movq %rbx, PER_CPU_VAR((%rsi))
+	movq %rcx, PER_CPU_VAR(8(%rsi))
 
-	popf
+	CFI_REMEMBER_STATE
+	popfq_cfi
 	mov $1, %al
 	ret
 
- not_same:
-	popf
+	CFI_RESTORE_STATE
+.Lnot_same:
+	popfq_cfi
 	xor %al,%al
 	ret
 
diff --git a/arch/x86/lib/cmpxchg8b_emu.S b/arch/x86/lib/cmpxchg8b_emu.S
index 828cb710dec2..b4807fce5177 100644
--- a/arch/x86/lib/cmpxchg8b_emu.S
+++ b/arch/x86/lib/cmpxchg8b_emu.S
@@ -7,11 +7,8 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
 #include <asm/dwarf2.h>
 
-
 .text
 
 /*
@@ -30,27 +27,28 @@ CFI_STARTPROC
 # set the whole ZF thing (caller will just compare
 # eax:edx with the expected value)
 #
-cmpxchg8b_emu:
-	pushfl
+	pushfl_cfi
 	cli
 
 	cmpl  (%esi), %eax
-	jne not_same
+	jne .Lnot_same
 	cmpl 4(%esi), %edx
-	jne half_same
+	jne .Lhalf_same
 
 	movl %ebx,  (%esi)
 	movl %ecx, 4(%esi)
 
-	popfl
+	CFI_REMEMBER_STATE
+	popfl_cfi
 	ret
 
- not_same:
+	CFI_RESTORE_STATE
+.Lnot_same:
 	movl  (%esi), %eax
- half_same:
+.Lhalf_same:
 	movl 4(%esi), %edx
 
-	popfl
+	popfl_cfi
 	ret
 
 CFI_ENDPROC
diff --git a/arch/x86/lib/thunk_32.S b/arch/x86/lib/thunk_32.S
index 28f85c916712..e28cdaf5ac2c 100644
--- a/arch/x86/lib/thunk_32.S
+++ b/arch/x86/lib/thunk_32.S
@@ -6,25 +6,46 @@
  */
 	#include <linux/linkage.h>
 	#include <asm/asm.h>
+	#include <asm/dwarf2.h>
 
-#ifdef CONFIG_TRACE_IRQFLAGS
 	/* put return address in eax (arg1) */
-	.macro thunk_ra name,func
+	.macro THUNK name, func, put_ret_addr_in_eax=0
 	.globl \name
 \name:
-	pushl %eax
-	pushl %ecx
-	pushl %edx
+	CFI_STARTPROC
+	pushl_cfi %eax
+	CFI_REL_OFFSET eax, 0
+	pushl_cfi %ecx
+	CFI_REL_OFFSET ecx, 0
+	pushl_cfi %edx
+	CFI_REL_OFFSET edx, 0
+
+	.if \put_ret_addr_in_eax
 	/* Place EIP in the arg1 */
 	movl 3*4(%esp), %eax
+	.endif
+
 	call \func
-	popl %edx
-	popl %ecx
-	popl %eax
+	popl_cfi %edx
+	CFI_RESTORE edx
+	popl_cfi %ecx
+	CFI_RESTORE ecx
+	popl_cfi %eax
+	CFI_RESTORE eax
 	ret
+	CFI_ENDPROC
 	_ASM_NOKPROBE(\name)
 	.endm
 
-	thunk_ra trace_hardirqs_on_thunk,trace_hardirqs_on_caller
-	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_off_caller
+#ifdef CONFIG_TRACE_IRQFLAGS
+	THUNK trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1
+	THUNK trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
+#endif
+
+#ifdef CONFIG_PREEMPT
+	THUNK ___preempt_schedule, preempt_schedule
+#ifdef CONFIG_CONTEXT_TRACKING
+	THUNK ___preempt_schedule_context, preempt_schedule_context
 #endif
+#endif
+
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 92d9feaff42b..b30b5ebd614a 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -38,6 +38,13 @@
 	THUNK lockdep_sys_exit_thunk,lockdep_sys_exit
 #endif
 
+#ifdef CONFIG_PREEMPT
+	THUNK ___preempt_schedule, preempt_schedule
+#ifdef CONFIG_CONTEXT_TRACKING
+	THUNK ___preempt_schedule_context, preempt_schedule_context
+#endif
+#endif
+
 	/* SAVE_ARGS below is used only for the .cfi directives it contains. */
 	CFI_STARTPROC
 	SAVE_ARGS
