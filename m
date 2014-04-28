Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428AbaD1WN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:13:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:5258 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414AbaD1WN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="531201194"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
Date: Mon, 28 Apr 2014 15:12:38 -0700
Message-Id: <1398723161-21968-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

IvyBridge added new instructions to directly write the fs and gs
64bit base registers. Previously this had to be done with a system
call to write to MSRs. The main use case is fast user space threading
and switching the fs/gs registers quickly there.

The instructions are opt-in and have to be explicitely enabled
by the OS.

Previously Linux couldn't support this because the paranoid
entry code relied on the gs base never being negative outside
the kernel to decide when to use swaps. It would check the gs MSR
value and assume it was already running in kernel if the value
was already negative.

This patch changes the paranoid entry code to use rdgsbase
if available.  Then we check the GS value against the expected GS value
stored at the bottom of the IST stack. If the value is the expected
value we skip swapgs.

This is also significantly faster than a MSR read, so will speed
NMis (critical for profiling)

An alternative would have been to save/restore the GS value
unconditionally, but this approach needs less changes.

Then after these changes we need to also use the new instructions
to save/restore fs and gs, so that the new values set by the
users won't disappear.  This is also significantly
faster for the case when the 64bit base has to be switched
(that is when GS is larger than 4GB), as we can replace
the slow MSR write with a faster wr[fg]sbase execution.

The instructions do not context switch
the segment index, so the old invariant that fs or gs index
have to be 0 for a different 64bit value to stick is still
true. Previously it was enforced by arch_prctl, now the user
program has to make sure it keeps the segment indexes zero.
If it doesn't the changes may not stick.

This is in term enables fast switching when there are
enough threads that their TLS segment does not fit below 4GB,
or alternatively programs that use fs as an additional base
register will not get a sigificant context switch penalty.

It is all done in a single patch to avoid bisect crash
holes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |  6 ++++++
 arch/x86/kernel/entry_64.S   | 38 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/process_64.c | 28 ++++++++++++++++++++++++----
 3 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 79ba4b9..0fb8767 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -938,6 +938,9 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 #ifdef CONFIG_NUMA
 	numa_add_cpu(smp_processor_id());
 #endif
+
+	if (cpu_has(c, X86_FEATURE_FSGSBASE))
+		set_in_cr4(X86_CR4_FSGSBASE);
 }
 
 #ifdef CONFIG_X86_64
@@ -1287,10 +1290,13 @@ void cpu_init(void)
 	 */
 	if (!oist->ist[0]) {
 		char *estacks = per_cpu(exception_stacks, cpu);
+		void *gs = per_cpu(irq_stack_union.gs_base, cpu);
 
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
 			if (v == DEBUG_STACK - 1)
 				estacks = per_cpu(debug_stack, cpu);
+			/* Store GS at bottom of stack for bootstrap access */
+			*(void **)estacks = gs;
 			estacks += exception_stack_sizes[v];
 			oist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..7c77b2b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -58,6 +58,7 @@
 #include <asm/asm.h>
 #include <asm/context_tracking.h>
 #include <asm/smap.h>
+#include <asm/alternative-asm.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -508,6 +509,10 @@ ENTRY(save_paranoid)
 	movq_cfi r14, R14+8
 	movq_cfi r15, R15+8
 	movl $1,%ebx
+33:
+	ASM_NOP5	/* May be replaced with jump to paranoid_save_gs */
+34:
+	movq $-1,ORIG_RAX+8(%rsp)	/* no syscall to restart */
 	movl $MSR_GS_BASE,%ecx
 	rdmsr
 	testl %edx,%edx
@@ -515,6 +520,37 @@ ENTRY(save_paranoid)
 	SWAPGS
 	xorl %ebx,%ebx
 1:	ret
+
+	/* Patch in jump to paranoid_save_gs for X86_FEATURE_FSGSBASE */
+	.section .altinstr_replacement,"ax"
+35:	.byte 0xe9 /* 32bit near jump */
+	.long paranoid_save_gs-34b
+	.previous
+	.section .altinstructions,"a"
+	altinstruction_entry 33b,35b,X86_FEATURE_FSGSBASE,5,5
+	.previous
+
+	/* Faster version not using RDMSR, and also not assuming
+	 * anything about the previous GS value.
+	 * This allows the user to arbitarily change GS using
+	 * WRGSBASE.
+	 */
+paranoid_save_gs:
+	.byte 0xf3,0x48,0x0f,0xae,0xc9	# rdgsbaseq %rcx
+	movq $-EXCEPTION_STKSZ,%rax	# non debug stack size
+	cmpq $DEBUG_STACK,ORIG_RAX+8(%rsp)
+	movq $-1,ORIG_RAX+8(%rsp)	# no syscall to restart
+	jne  1f
+	movq $-DEBUG_STKSZ,%rax		# debug stack size
+1:
+	andq %rsp,%rax			# bottom of stack
+	movq (%rax),%rdi		# get expected GS
+	cmpq %rdi,%rcx			# is it the kernel gs?
+	jz   2f
+	SWAPGS
+	xorl %ebx,%ebx
+2:	ret
+
 	CFI_ENDPROC
 END(save_paranoid)
 	.popsection
@@ -1245,7 +1281,7 @@ ENTRY(\sym)
 	INTR_FRAME
 	ASM_CLAC
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	pushq_cfi $\ist		/* ORIG_RAX: pass ist number to save_paranoid */
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9c0280f..334a87a 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -49,6 +49,7 @@
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
+#include <asm/fsgs.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -311,6 +312,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	savesegment(fs, fsindex);
 	savesegment(gs, gsindex);
+	if (static_cpu_has(X86_FEATURE_FSGSBASE)) {
+		prev->fs = rdfsbase();
+		/* Interrupts are disabled here. */
+		swapgs();
+		prev->gs = rdgsbase();
+		swapgs();
+	}
 
 	load_TLS(next, cpu);
 
@@ -341,8 +349,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 			prev->fs = 0;
 	}
 	/* when next process has a 64bit base use it */
-	if (next->fs)
-		wrmsrl(MSR_FS_BASE, next->fs);
+	if (next->fs) {
+		if (static_cpu_has(X86_FEATURE_FSGSBASE))
+			wrfsbase(next->fs);
+		else
+			wrmsrl(MSR_FS_BASE, next->fs);
+	}
 	prev->fsindex = fsindex;
 
 	if (unlikely(gsindex | next->gsindex | prev->gs)) {
@@ -350,8 +362,16 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		if (gsindex)
 			prev->gs = 0;
 	}
-	if (next->gs)
-		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
+	if (next->gs) {
+		if (static_cpu_has(X86_FEATURE_FSGSBASE)) {
+			/* Interrupts are disabled here. */
+			swapgs();
+			wrgsbase(next->gs);
+			swapgs();
+		} else {
+			wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
+		}
+	}
 	prev->gsindex = gsindex;
 
 	switch_fpu_finish(next_p, fpu);
-- 
1.9.0

