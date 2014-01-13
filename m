Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaAMAXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 19:23:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49398 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaAMAXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:23:16 -0500
Date: Sun, 12 Jan 2014 16:22:43 -0800
Message-Id: <201401130022.s0D0MhxM022361@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.13
Cc: <stable@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, halfdog <me@halfdog.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry, meant to push out this batch earlier this weekend.

The following changes since commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc:

  Linux 3.13-rc7 (2014-01-04 15:12:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

The head of this tree is 26bef1318adc1b3a530ecc807ef99346db2aa8b0.

  x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround (2014-01-11 19:15:52 -0800)

----------------------------------------------------------------
Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Steven Rostedt (1):
      ftrace/x86: Load ftrace_ops in parameter not the variable holding it

 arch/x86/include/asm/fpu-internal.h | 13 +++++++------
 arch/x86/kernel/entry_32.S          |  4 ++--
 arch/x86/kernel/entry_64.S          |  2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index c49a613c6452..cea1c76d49bf 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -293,12 +293,13 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. "m" is a random variable that should be in L1 */
-	alternative_input(
-		ASM_NOP8 ASM_NOP2,
-		"emms\n\t"		/* clear stack tags */
-		"fildl %P[addr]",	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (tsk->thread.fpu.has_fpu));
+	if (unlikely(static_cpu_has(X86_FEATURE_FXSAVE_LEAK))) {
+		asm volatile(
+			"fnclex\n\t"
+			"emms\n\t"
+			"fildl %P[addr]"	/* set F?P to defined value */
+			: : [addr] "m" (tsk->thread.fpu.has_fpu));
+	}
 
 	return fpu_restore_checking(&tsk->thread.fpu);
 }
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 51e2988c5728..a2a4f4697889 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1082,7 +1082,7 @@ ENTRY(ftrace_caller)
 	pushl $0	/* Pass NULL as regs pointer */
 	movl 4*4(%esp), %eax
 	movl 0x4(%ebp), %edx
-	leal function_trace_op, %ecx
+	movl function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
@@ -1140,7 +1140,7 @@ ENTRY(ftrace_regs_caller)
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
 	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
 	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
-	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
+	movl function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
 	pushl %esp		/* Save pt_regs as 4th parameter */
 
 GLOBAL(ftrace_regs_call)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e21b0785a85b..1e96c3628bf2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -88,7 +88,7 @@ END(function_hook)
 	MCOUNT_SAVE_FRAME \skip
 
 	/* Load the ftrace_ops into the 3rd parameter */
-	leaq function_trace_op, %rdx
+	movq function_trace_op(%rip), %rdx
 
 	/* Load ip into the first parameter */
 	movq RIP(%rsp), %rdi
