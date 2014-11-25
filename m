Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaKYAoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:44:19 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30535 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750784AbaKYAm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:42:57 -0500
Message-Id: <20141125004221.803122027@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 24 Nov 2014 19:42:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC][PATCH 0/7] ftrace/x86: Clean up of mcount.S code
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

As you did not like the added macro that just inserted the frame setup
into the ftrace trampolines, I did a bit of clean up to hopefully make
the mcount code a bit more suitable to your taste. I did several of
the recommendations you have made.

1) You noticed that the static tracer hard coded the saving of the rip.
   I had that function also use ftrace_caller_setup. You mentioned
   the function graph tracer too, but that one does things differently
   and needs to stay hard coded.

2) I moved the MCOUNT_SAVE_FRAME out of the header file.

3) I renamed MCOUNT_SAVE_FRAME to save_mcount_regs which is a more meaningful
   name of what that function does. As "frame" gets confused to function
   frame, and mcount uses a different ABI to what must be saved.

4) When saving the RIP into the RIP pt_regs position of the stack, I
   had save_mcount_regs use %rdi, as that register is what holds the
   first parameter for the function hooks that the ftrace_caller and
   ftrace_regs_caller will call. This allows me to remove the copying
   of that register in ftrace_caller_setup.

5) Instead of callers to save_mcount_regs say what it added to the
   pt_regs structure (which is silly, because they don't even add
   the correct data), just have the callers pass in how much stack
   they used before calling it. This is to allow save_mcount_regs to
   be able to still find RIP.

6) Instead of all callers of save_mcount_regs doing a hard coded offset
   to get to the data on the stack before the stuff that save_mcount_regs
   used, create a macro MCOUNT_REG_SIZE that keeps all users in sync.

7) Move the saving of the frame pointers into save_mcount_regs, and remove
   the extra macro that you hated. I still have it do something different
   if frame pointers is compiled in or not, and if mcount or fentry is used.
   But I tested it (basic tests) on all variations, and it works.

I haven't run this through my main test suite which takes 8 to 12 hours to
run. But I did more than compile testing on them. If my tests uncover
something, these will change.

As this code is based on other code I have for 3.19, I pushed up my rfc
branch in case you want to look at it directly. Also at the end of this
email I have the full diff of these patches in one patch.

This patch series still expects my original patch that added the create_frame
and restore_frame macros to go in. That's a "quick fix" that should work
well for stable. I think these changes are a bit too much for a late rc
or stable. But If you prefer this to go in now, I can rearrange things
to do it.

Let me know if these changes have mcount.S give you less heebie-jeebies.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
rfc/mcount-update

Head SHA1: f9c9200f43396b13d2c77286412cb276ac0ba0a6


Steven Rostedt (Red Hat) (7):
      ftrace/x86: Have static tracing also use ftrace_caller_setup
      ftrace/x86: Move MCOUNT_SAVE_FRAME out of header file
      ftrace/x86: Rename MCOUNT_SAVE_FRAME and add more detailed comments
      ftrace/x86: Have save_mcount_regs store RIP in %rdi for first parameter
      ftrace/x86: Simplify save_mcount_regs on getting RIP
      ftrace/x86: Add macro MCOUNT_REG_SIZE for amount of stack used to save mcount regs
      ftrace/x86: Have save_mcount_regs macro also save stack frames if needed

----
 arch/x86/include/asm/ftrace.h |  33 -------
 arch/x86/kernel/mcount_64.S   | 209 ++++++++++++++++++++++++++----------------
 2 files changed, 130 insertions(+), 112 deletions(-)
----

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index e1f7fecaa7d6..f45acad3c4b6 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -1,39 +1,6 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
-#ifdef __ASSEMBLY__
-
-	/* skip is set if the stack was already partially adjusted */
-	.macro MCOUNT_SAVE_FRAME skip=0
-	 /*
-	  * We add enough stack to save all regs.
-	  */
-	subq $(SS+8-\skip), %rsp
-	movq %rax, RAX(%rsp)
-	movq %rcx, RCX(%rsp)
-	movq %rdx, RDX(%rsp)
-	movq %rsi, RSI(%rsp)
-	movq %rdi, RDI(%rsp)
-	movq %r8, R8(%rsp)
-	movq %r9, R9(%rsp)
-	 /* Move RIP to its proper location */
-	movq SS+8(%rsp), %rdx
-	movq %rdx, RIP(%rsp)
-	.endm
-
-	.macro MCOUNT_RESTORE_FRAME skip=0
-	movq R9(%rsp), %r9
-	movq R8(%rsp), %r8
-	movq RDI(%rsp), %rdi
-	movq RSI(%rsp), %rsi
-	movq RDX(%rsp), %rdx
-	movq RCX(%rsp), %rcx
-	movq RAX(%rsp), %rax
-	addq $(SS+8-\skip), %rsp
-	.endm
-
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CC_USING_FENTRY
 # define MCOUNT_ADDR		((long)(__fentry__))
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 6dc134b8dc70..003b22df1d87 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,78 +21,144 @@
 # define function_hook	mcount
 #endif
 
-#ifdef CONFIG_DYNAMIC_FTRACE
+/* All cases save the original rbp (8 bytes) */
+#ifdef CONFIG_FRAME_POINTER
+# ifdef CC_USING_FENTRY
+/* Save parent and function stack frames (rip and rbp) */
+#  define MCOUNT_FRAME_SIZE	(8+16*2)
+# else
+/* Save just function stack frame (rip and rbp) */
+#  define MCOUNT_FRAME_SIZE	(8+16)
+# endif
+#else
+/* No need to save a stack frame */
+# define MCOUNT_FRAME_SIZE	8
+#endif /* CONFIG_FRAME_POINTER */
 
-ENTRY(function_hook)
-	retq
-END(function_hook)
+/* Size of stack used to save mcount regs in save_mcount_regs */
+#define MCOUNT_REG_SIZE		(SS+8 + MCOUNT_FRAME_SIZE)
+
+/*
+ * gcc -pg option adds a call to 'mcount' in most functions.
+ * When -mfentry is used, the call is to 'fentry' and not 'mcount'
+ * and is done before the function's stack frame is set up.
+ * They both require a set of regs to be saved before calling
+ * any C code and restored before returning back to the function.
+ *
+ * On boot up, all these calls are converted into nops. When tracing
+ * is enabled, the call can jump to either ftrace_caller or
+ * ftrace_regs_caller. Callbacks (tracing functions) that require
+ * ftrace_regs_caller (like kprobes) need to have pt_regs passed to
+ * it. For this reason, the size of the pt_regs structure will be
+ * allocated on the stack and the required mcount registers will
+ * be saved in the locations that pt_regs has them in.
+ */
+
+/* @added: the amount of stack added before calling this */
+.macro save_mcount_regs added=0
+
+	/* Always save the original rbp */
+	pushq %rbp
+
+#ifdef CONFIG_FRAME_POINTER
+	/*
+	 * Stack traces will stop at the ftrace trampoline if the frame pointer
+	 * is not set up properly. If fentry is used, we need to save a frame
+	 * pointer for the parent as well as the function traced, because the
+	 * fentry is called before the stack frame is set up, where as mcount
+	 * is called afterward.
+	 */
+#ifdef CC_USING_FENTRY
+	/* Save the parent pointer (skip orig rbp and our return address) */
+	pushq \added+8*2(%rsp)
+	pushq %rbp
+	movq %rsp, %rbp
+	/* Save the return address (now skip orig rbp, rbp and parent) */
+	pushq \added+8*3(%rsp)
+#else
+	/* Can't assume that rip is before this (unless added was zero) */
+	pushq \added+8(%rsp)
+#endif
+	pushq %rbp
+	movq %rsp, %rbp
+#endif /* CONFIG_FRAME_POINTER */
+
+	/*
+	 * We add enough stack to save all regs.
+	 */
+	subq $(MCOUNT_REG_SIZE - MCOUNT_FRAME_SIZE), %rsp
+	movq %rax, RAX(%rsp)
+	movq %rcx, RCX(%rsp)
+	movq %rdx, RDX(%rsp)
+	movq %rsi, RSI(%rsp)
+	movq %rdi, RDI(%rsp)
+	movq %r8, R8(%rsp)
+	movq %r9, R9(%rsp)
+	/*
+	 * Save the original RBP. Even though the mcount ABI does not
+	 * require this, it helps out callers.
+	 */
+	movq MCOUNT_REG_SIZE-8(%rsp), %rdx
+	movq %rdx, RBP(%rsp)
+
+	 /* Move RIP to its proper location */
+	movq MCOUNT_REG_SIZE+\added(%rsp), %rdi
+	movq %rdi, RIP(%rsp)
+	.endm
+
+.macro restore_mcount_regs
+	movq R9(%rsp), %r9
+	movq R8(%rsp), %r8
+	movq RDI(%rsp), %rdi
+	movq RSI(%rsp), %rsi
+	movq RDX(%rsp), %rdx
+	movq RCX(%rsp), %rcx
+	movq RAX(%rsp), %rax
+
+	/* ftrace_regs_caller can modify %rbp */
+	movq RBP(%rsp), %rbp
+
+	addq $MCOUNT_REG_SIZE, %rsp
+
+	.endm
 
 /* skip is set if stack has been adjusted */
-.macro ftrace_caller_setup trace_label skip=0
-	MCOUNT_SAVE_FRAME \skip
+.macro ftrace_caller_setup trace_label added=0
+	save_mcount_regs \added
 
 	/* Save this location */
 GLOBAL(\trace_label)
 	/* Load the ftrace_ops into the 3rd parameter */
 	movq function_trace_op(%rip), %rdx
 
-	/* Load ip into the first parameter */
-	movq RIP(%rsp), %rdi
+	/* %rdi already has %rip from the save_mcount_regs macro */
 	subq $MCOUNT_INSN_SIZE, %rdi
 	/* Load the parent_ip into the second parameter */
 #ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
+	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
 #else
-	movq 8(%rbp), %rsi
+	/* Need to grab the original %rbp */
+	movq RBP(%rsp), %rsi
+	/* Now parent address is 8 above original %rbp */
+	movq 8(%rsi), %rsi
 #endif
 .endm
 
-#ifdef CONFIG_FRAME_POINTER
-/*
- * Stack traces will stop at the ftrace trampoline if the frame pointer
- * is not set up properly. If fentry is used, we need to save a frame
- * pointer for the parent as well as the function traced, because the
- * fentry is called before the stack frame is set up, where as mcount
- * is called afterward.
- */
-.macro create_frame parent rip
-#ifdef CC_USING_FENTRY
-	pushq \parent
-	pushq %rbp
-	movq %rsp, %rbp
-#endif
-	pushq \rip
-	pushq %rbp
-	movq %rsp, %rbp
-.endm
+#ifdef CONFIG_DYNAMIC_FTRACE
 
-.macro restore_frame
-#ifdef CC_USING_FENTRY
-	addq $16, %rsp
-#endif
-	popq %rbp
-	addq $8, %rsp
-.endm
-#else
-.macro create_frame parent rip
-.endm
-.macro restore_frame
-.endm
-#endif /* CONFIG_FRAME_POINTER */
+ENTRY(function_hook)
+	retq
+END(function_hook)
 
 ENTRY(ftrace_caller)
 	ftrace_caller_setup ftrace_caller_op_ptr
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
 
-	create_frame %rsi, %rdi
-
 GLOBAL(ftrace_call)
 	call ftrace_stub
 
-	restore_frame
-
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	/*
 	 * The copied trampoline must call ftrace_return as it
@@ -112,10 +178,10 @@ GLOBAL(ftrace_stub)
 END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
-	/* Save the current flags before compare (in SS location)*/
+	/* Save the current flags before any operations that can change them */
 	pushfq
 
-	/* skip=8 to skip flags saved in SS */
+	/* added 8 bytes to save flags */
 	ftrace_caller_setup ftrace_regs_caller_op_ptr 8
 
 	/* Save the rest of pt_regs */
@@ -125,37 +191,32 @@ ENTRY(ftrace_regs_caller)
 	movq %r12, R12(%rsp)
 	movq %r11, R11(%rsp)
 	movq %r10, R10(%rsp)
-	movq %rbp, RBP(%rsp)
 	movq %rbx, RBX(%rsp)
 	/* Copy saved flags */
-	movq SS(%rsp), %rcx
+	movq MCOUNT_REG_SIZE(%rsp), %rcx
 	movq %rcx, EFLAGS(%rsp)
 	/* Kernel segments */
 	movq $__KERNEL_DS, %rcx
 	movq %rcx, SS(%rsp)
 	movq $__KERNEL_CS, %rcx
 	movq %rcx, CS(%rsp)
-	/* Stack - skipping return address */
-	leaq SS+16(%rsp), %rcx
+	/* Stack - skipping return address and flags */
+	leaq MCOUNT_REG_SIZE+8*2(%rsp), %rcx
 	movq %rcx, RSP(%rsp)
 
 	/* regs go into 4th parameter */
 	leaq (%rsp), %rcx
 
-	create_frame %rsi, %rdi
-
 GLOBAL(ftrace_regs_call)
 	call ftrace_stub
 
-	restore_frame
-
 	/* Copy flags back to SS, to restore them */
 	movq EFLAGS(%rsp), %rax
-	movq %rax, SS(%rsp)
+	movq %rax, MCOUNT_REG_SIZE(%rsp)
 
 	/* Handlers can change the RIP */
 	movq RIP(%rsp), %rax
-	movq %rax, SS+8(%rsp)
+	movq %rax, MCOUNT_REG_SIZE+8(%rsp)
 
 	/* restore the rest of pt_regs */
 	movq R15(%rsp), %r15
@@ -163,11 +224,9 @@ GLOBAL(ftrace_regs_call)
 	movq R13(%rsp), %r13
 	movq R12(%rsp), %r12
 	movq R10(%rsp), %r10
-	movq RBP(%rsp), %rbp
 	movq RBX(%rsp), %rbx
 
-	/* skip=8 to skip flags saved in SS */
-	MCOUNT_RESTORE_FRAME 8
+	restore_mcount_regs
 
 	/* Restore flags */
 	popfq
@@ -182,9 +241,6 @@ GLOBAL(ftrace_regs_caller_end)
 
 	jmp ftrace_return
 
-	popfq
-	jmp  ftrace_stub
-
 END(ftrace_regs_caller)
 
 
@@ -207,19 +263,11 @@ GLOBAL(ftrace_stub)
 	retq
 
 trace:
-	MCOUNT_SAVE_FRAME
-
-	movq RIP(%rsp), %rdi
-#ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
-#else
-	movq 8(%rbp), %rsi
-#endif
-	subq $MCOUNT_INSN_SIZE, %rdi
+	ftrace_caller_setup ftrace_caller_op_ptr
 
 	call   *ftrace_trace_function
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	jmp fgraph_trace
 END(function_hook)
@@ -228,21 +276,24 @@ END(function_hook)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	MCOUNT_SAVE_FRAME
+	save_mcount_regs
 
 #ifdef CC_USING_FENTRY
-	leaq SS+16(%rsp), %rdi
+	leaq MCOUNT_REG_SIZE+8(%rsp), %rdi
 	movq $0, %rdx	/* No framepointers needed */
 #else
-	leaq 8(%rbp), %rdi
-	movq (%rbp), %rdx
+	/* Need to grab the original %rbp */
+	movq RBP(%rsp), %rdx
+	/* Now parent address is 8 above original %rbp */
+	leaq 8(%rdx), %rdi
+	movq (%rdx), %rdx
 #endif
 	movq RIP(%rsp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rsi
 
 	call	prepare_ftrace_return
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	retq
 END(ftrace_graph_caller)
