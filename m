Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaKYCyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 21:54:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51952 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750784AbaKYCyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 21:54:37 -0500
Date: Mon, 24 Nov 2014 21:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH 0/7] ftrace/x86: Clean up of mcount.S code
Message-ID: <20141124215435.4cb3bae2@gandalf.local.home>
In-Reply-To: <CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com>
References: <20141125004221.803122027@goodmis.org>
	<CA+55aFxUTUbdxpjVMW8X9c=o8sui7OB_MYPfcbJuDyfUWtNrNg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a new update. I'll spare you the patch series and only show you
the rolled up patch. By swapping the parameters of
prepare_ftrace_return() that's used by ftrace_graph_caller, I was able
to have that take advantage of the rdi being filled for it too.

I pushed this up to my repo as well.

-- Steve

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
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 60881d919432..2142376dc8c6 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -871,7 +871,7 @@ static void *addr_from_call(void *ptr)
 	return ptr + MCOUNT_INSN_SIZE + calc.offset;
 }
 
-void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 			   unsigned long frame_pointer);
 
 /*
@@ -964,7 +964,7 @@ int ftrace_disable_ftrace_graph_caller(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
-void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 			   unsigned long frame_pointer)
 {
 	unsigned long old;
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index 6dc134b8dc70..1a5cf2a23ff3 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -21,78 +21,151 @@
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
 
-/* skip is set if stack has been adjusted */
-.macro ftrace_caller_setup trace_label skip=0
-	MCOUNT_SAVE_FRAME \skip
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
 
-	/* Save this location */
-GLOBAL(\trace_label)
-	/* Load the ftrace_ops into the 3rd parameter */
-	movq function_trace_op(%rip), %rdx
+/*
+ * @added: the amount of stack added before calling this
+ *
+ * After this is called, the following registers contain:
+ *
+ *  %rdi - holds the address that called the trampoline
+ *  %rsi - holds the parent function (traced function's return address)
+ *  %rdx - holds the original %rbp
+ */
+.macro save_mcount_regs added=0
 
-	/* Load ip into the first parameter */
-	movq RIP(%rsp), %rdi
-	subq $MCOUNT_INSN_SIZE, %rdi
-	/* Load the parent_ip into the second parameter */
-#ifdef CC_USING_FENTRY
-	movq SS+16(%rsp), %rsi
-#else
-	movq 8(%rbp), %rsi
-#endif
-.endm
+	/* Always save the original rbp */
+	pushq %rbp
 
 #ifdef CONFIG_FRAME_POINTER
-/*
- * Stack traces will stop at the ftrace trampoline if the frame pointer
- * is not set up properly. If fentry is used, we need to save a frame
- * pointer for the parent as well as the function traced, because the
- * fentry is called before the stack frame is set up, where as mcount
- * is called afterward.
- */
-.macro create_frame parent rip
+	/*
+	 * Stack traces will stop at the ftrace trampoline if the frame pointer
+	 * is not set up properly. If fentry is used, we need to save a frame
+	 * pointer for the parent as well as the function traced, because the
+	 * fentry is called before the stack frame is set up, where as mcount
+	 * is called afterward.
+	 */
 #ifdef CC_USING_FENTRY
-	pushq \parent
+	/* Save the parent pointer (skip orig rbp and our return address) */
+	pushq \added+8*2(%rsp)
 	pushq %rbp
 	movq %rsp, %rbp
+	/* Save the return address (now skip orig rbp, rbp and parent) */
+	pushq \added+8*3(%rsp)
+#else
+	/* Can't assume that rip is before this (unless added was zero) */
+	pushq \added+8(%rsp)
 #endif
-	pushq \rip
 	pushq %rbp
 	movq %rsp, %rbp
-.endm
+#endif /* CONFIG_FRAME_POINTER */
 
-.macro restore_frame
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
+	/* Copy the parent address into %rsi (second parameter) */
 #ifdef CC_USING_FENTRY
-	addq $16, %rsp
-#endif
-	popq %rbp
-	addq $8, %rsp
-.endm
+	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
 #else
-.macro create_frame parent rip
-.endm
-.macro restore_frame
-.endm
-#endif /* CONFIG_FRAME_POINTER */
+	/* %rdx contains original %rbp */
+	movq 8(%rdx), %rsi
+#endif
+
+	 /* Move RIP to its proper location */
+	movq MCOUNT_REG_SIZE+\added(%rsp), %rdi
+	movq %rdi, RIP(%rsp)
+
+	/*
+	 * Now %rdi (the first parameter) has the return address of
+	 * where ftrace_call returns. But the callbacks expect the
+	 * the address of the call itself.
+	 */
+	subq $MCOUNT_INSN_SIZE, %rdi
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
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+ENTRY(function_hook)
+	retq
+END(function_hook)
 
 ENTRY(ftrace_caller)
-	ftrace_caller_setup ftrace_caller_op_ptr
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs
+
+GLOBAL(ftrace_caller_op_ptr)
+	/* Load the ftrace_ops into the 3rd parameter */
+	movq function_trace_op(%rip), %rdx
+
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
@@ -112,11 +185,16 @@ GLOBAL(ftrace_stub)
 END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
-	/* Save the current flags before compare (in SS location)*/
+	/* Save the current flags before any operations that can change them */
 	pushfq
 
-	/* skip=8 to skip flags saved in SS */
-	ftrace_caller_setup ftrace_regs_caller_op_ptr 8
+	/* added 8 bytes to save flags */
+	save_mcount_regs 8
+	/* save_mcount_regs fills in first two parameters */
+
+GLOBAL(ftrace_regs_caller_op_ptr)
+	/* Load the ftrace_ops into the 3rd parameter */
+	movq function_trace_op(%rip), %rdx
 
 	/* Save the rest of pt_regs */
 	movq %r15, R15(%rsp)
@@ -125,37 +203,32 @@ ENTRY(ftrace_regs_caller)
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
@@ -163,11 +236,9 @@ GLOBAL(ftrace_regs_call)
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
@@ -182,9 +253,6 @@ GLOBAL(ftrace_regs_caller_end)
 
 	jmp ftrace_return
 
-	popfq
-	jmp  ftrace_stub
-
 END(ftrace_regs_caller)
 
 
@@ -207,19 +275,12 @@ GLOBAL(ftrace_stub)
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
+	/* save_mcount_regs fills in first two parameters */
+	save_mcount_regs
 
 	call   *ftrace_trace_function
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	jmp fgraph_trace
 END(function_hook)
@@ -228,21 +289,21 @@ END(function_hook)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	MCOUNT_SAVE_FRAME
+	/* Saves rbp into %rdx and fills first parameter  */
+	save_mcount_regs
 
 #ifdef CC_USING_FENTRY
-	leaq SS+16(%rsp), %rdi
+	leaq MCOUNT_REG_SIZE+8(%rsp), %rsi
 	movq $0, %rdx	/* No framepointers needed */
 #else
-	leaq 8(%rbp), %rdi
-	movq (%rbp), %rdx
+	/* Save address of the return address of traced function */
+	leaq 8(%rdx), %rsi
+	/* ftrace does sanity checks against frame pointers */
+	movq (%rdx), %rdx
 #endif
-	movq RIP(%rsp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rsi
-
 	call	prepare_ftrace_return
 
-	MCOUNT_RESTORE_FRAME
+	restore_mcount_regs
 
 	retq
 END(ftrace_graph_caller)
