Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaHAOt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbaHAOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:49:22 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
Date: Fri,  1 Aug 2014 16:48:17 +0200
Message-Id: <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit code was using six stack slots fewer by not saving/restoring
registers which a callee-preserved according to C ABI,
and not allocating space for them.

Only when syscall needed a complete "struct pt_regs",
the complete area was allocated and filled in.

This proved to be a source of significant obfuscation and subtle bugs.
For example, stub_fork had to pop the return address,
extend the struct, save registers, and push return address back. Ugly.
ia32_ptregs_common pops return address and "returns" via jmp insn,
throwing a wrench into CPU return stack cache.

This patch changes code to always allocate a complete "struct pt_regs".
The saving of registers is still done lazily.

Macros which manipulate "struct pt_regs" on stack are reworked:
ALLOC_PTREGS_ON_STACK allocates the structure.
SAVE_C_REGS saves to it those registers which are clobbered by C code.
SAVE_EXTRA_REGS saves to it all other registers.
Corresponding RESTORE_* and REMOVE_PTREGS_FROM_STACK macros reverse it.

ia32_ptregs_common, stub_fork and friends lost their ugly dance with
return pointer.

LOAD_ARGS32 in ia32entry.S now uses a symbolic stack offsets
instead of magic numbers.

Misleading and slightly wrong comments in "struct pt_regs" are fixed
(four instances).

Patch was run-tested: 64-bit executables, 32-bit executables,
strace works.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/ia32/ia32entry.S              |  47 +++----
 arch/x86/include/asm/calling.h         | 224 ++++++++++++++++-----------------
 arch/x86/include/asm/irqflags.h        |   4 +-
 arch/x86/include/asm/ptrace.h          |  13 +-
 arch/x86/include/uapi/asm/ptrace-abi.h |  16 ++-
 arch/x86/include/uapi/asm/ptrace.h     |  13 +-
 arch/x86/kernel/entry_64.S             | 132 ++++++++-----------
 arch/x86/kernel/preempt.S              |  16 ++-
 8 files changed, 232 insertions(+), 233 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 4299eb0..ef9ee16 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -62,12 +62,12 @@
 	 */
 	.macro LOAD_ARGS32 offset, _r9=0
 	.if \_r9
-	movl \offset+16(%rsp),%r9d
+	movl \offset+R9(%rsp),%r9d
 	.endif
-	movl \offset+40(%rsp),%ecx
-	movl \offset+48(%rsp),%edx
-	movl \offset+56(%rsp),%esi
-	movl \offset+64(%rsp),%edi
+	movl \offset+RCX(%rsp),%ecx
+	movl \offset+RDX(%rsp),%edx
+	movl \offset+RSI(%rsp),%esi
+	movl \offset+RDI(%rsp),%edi
 	movl %eax,%eax			/* zero extension */
 	.endm
 	
@@ -144,7 +144,8 @@ ENTRY(ia32_sysenter_target)
 	CFI_REL_OFFSET rip,0
 	pushq_cfi %rax
 	cld
-	SAVE_ARGS 0,1,0
+	ALLOC_PTREGS_ON_STACK
+	SAVE_C_REGS_EXCEPT_R891011
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
 	ASM_STAC
@@ -172,7 +173,8 @@ sysexit_from_sys_call:
 	andl  $~0x200,EFLAGS-R11(%rsp) 
 	movl	RIP-R11(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
-	RESTORE_ARGS 0,24,0,0,0,0
+	RESTORE_RSI_RDI
+	REMOVE_PTREGS_FROM_STACK 8*3
 	xorq	%r8,%r8
 	xorq	%r9,%r9
 	xorq	%r10,%r10
@@ -240,13 +242,13 @@ sysenter_tracesys:
 	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz	sysenter_auditsys
 #endif
-	SAVE_REST
+	SAVE_EXTRA_REGS
 	CLEAR_RREGS
 	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	cmpq	$(IA32_NR_syscalls-1),%rax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
@@ -288,7 +290,8 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,0,0
+	ALLOC_PTREGS_ON_STACK 8
+	SAVE_C_REGS_EXCEPT_RCX_R891011
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq	%rcx,RIP-ARGOFFSET(%rsp)
@@ -325,7 +328,7 @@ cstar_dispatch:
 	jnz sysretl_audit
 sysretl_from_sys_call:
 	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
+	RESTORE_RSI_RDI_RDX
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
 	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
@@ -356,13 +359,13 @@ cstar_tracesys:
 	jz cstar_auditsys
 #endif
 	xchgl %r9d,%ebp
-	SAVE_REST
+	SAVE_EXTRA_REGS
 	CLEAR_RREGS 0, r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	xchgl %ebp,%r9d
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
@@ -417,7 +420,8 @@ ENTRY(ia32_syscall)
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
-	SAVE_ARGS 0,1,0
+	ALLOC_PTREGS_ON_STACK
+	SAVE_C_REGS_EXCEPT_R891011
 	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_tracesys
@@ -430,16 +434,16 @@ ia32_sysret:
 	movq %rax,RAX-ARGOFFSET(%rsp)
 ia32_ret_from_sys_call:
 	CLEAR_RREGS -ARGOFFSET
-	jmp int_ret_from_sys_call 
+	jmp int_ret_from_sys_call
 
-ia32_tracesys:			 
-	SAVE_REST
+ia32_tracesys:
+	SAVE_EXTRA_REGS
 	CLEAR_RREGS
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja  int_ret_from_sys_call	/* ia32_tracesys has set RAX(%rsp) */
 	jmp ia32_do_call
@@ -475,7 +479,6 @@ GLOBAL(stub32_clone)
 
 	ALIGN
 ia32_ptregs_common:
-	popq %r11
 	CFI_ENDPROC
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -490,9 +493,9 @@ ia32_ptregs_common:
 /*	CFI_REL_OFFSET	rflags,EFLAGS-ARGOFFSET*/
 	CFI_REL_OFFSET	rsp,RSP-ARGOFFSET
 /*	CFI_REL_OFFSET	ss,SS-ARGOFFSET*/
-	SAVE_REST
+	SAVE_EXTRA_REGS 8
 	call *%rax
-	RESTORE_REST
-	jmp  ia32_sysret	/* misbalances the return cache */
+	RESTORE_EXTRA_REGS 8
+	ret
 	CFI_ENDPROC
 END(ia32_ptregs_common)
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index e176cea..10aff1e 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -52,142 +52,132 @@ For 32-bit we have the following conventions - kernel is built with
 
 /*
  * 64-bit system call stack frame layout defines and helpers,
- * for assembly code:
+ * for assembly code.
  */
 
-#define R15		  0
-#define R14		  8
-#define R13		 16
-#define R12		 24
-#define RBP		 32
-#define RBX		 40
-
-/* arguments: interrupts/non tracing syscalls only save up to here: */
-#define R11		 48
-#define R10		 56
-#define R9		 64
-#define R8		 72
-#define RAX		 80
-#define RCX		 88
-#define RDX		 96
-#define RSI		104
-#define RDI		112
-#define ORIG_RAX	120       /* + error_code */
-/* end of arguments */
-
-/* cpu exception frame or undefined in case of fast syscall: */
-#define RIP		128
-#define CS		136
-#define EFLAGS		144
-#define RSP		152
-#define SS		160
-
-#define ARGOFFSET	R11
-
-	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1
-	subq  $9*8+\addskip, %rsp
-	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
-	movq_cfi rdi, 8*8
-	movq_cfi rsi, 7*8
-	movq_cfi rdx, 6*8
-
-	.if \save_rcx
-	movq_cfi rcx, 5*8
-	.endif
-
-	movq_cfi rax, 4*8
+/* The layout forms the "struct pt_regs" on the stack: */
+/*
+ * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
+ * unless syscall needs a complete, fully filled "struct pt_regs".
+ */
+#define R15		0*8
+#define R14		1*8
+#define R13		2*8
+#define R12		3*8
+#define RBP		4*8
+#define RBX		5*8
+/* These regs are callee-clobbered. Always saved on kernel entry. */
+#define R11		6*8
+#define R10		7*8
+#define R9		8*8
+#define R8		9*8
+#define RAX		10*8
+#define RCX		11*8
+#define RDX		12*8
+#define RSI		13*8
+#define RDI		14*8
+/*
+ * On syscall entry, this is syscall#. On CPU exception, this is error code.
+ * On hw interrupt, it's IRQ number:
+ */
+#define ORIG_RAX	15*8
+/* Return frame for iretq */
+#define RIP		16*8
+#define CS		17*8
+#define EFLAGS		18*8
+#define RSP		19*8
+#define SS		20*8
+
+#define ARGOFFSET	0
+
+	.macro ALLOC_PTREGS_ON_STACK addskip=0
+	subq	$15*8+\addskip, %rsp
+	CFI_ADJUST_CFA_OFFSET 15*8+\addskip
+	.endm
 
-	.if \save_r891011
-	movq_cfi r8,  3*8
-	movq_cfi r9,  2*8
-	movq_cfi r10, 1*8
-	movq_cfi r11, 0*8
+	.macro SAVE_C_REGS_HELPER rcx=1 r8plus=1
+	movq_cfi rdi, 14*8
+	movq_cfi rsi, 13*8
+	movq_cfi rdx, 12*8
+	.if \rcx
+	movq_cfi rcx, 11*8
 	.endif
-
+	movq_cfi rax, 10*8
+	.if \r8plus
+	movq_cfi r8,  9*8
+	movq_cfi r9,  8*8
+	movq_cfi r10, 7*8
+	movq_cfi r11, 6*8
+	.endif
+	.endm
+	.macro SAVE_C_REGS
+	SAVE_C_REGS_HELPER 1, 1
+	.endm
+	.macro SAVE_C_REGS_EXCEPT_R891011
+	SAVE_C_REGS_HELPER 1, 0
+	.endm
+	.macro SAVE_C_REGS_EXCEPT_RCX_R891011
+	SAVE_C_REGS_HELPER 0, 0
 	.endm
 
-#define ARG_SKIP	(9*8)
+	.macro SAVE_EXTRA_REGS offset=0
+	movq_cfi rbx, 5*8+\offset
+	movq_cfi rbp, 4*8+\offset
+	movq_cfi r12, 3*8+\offset
+	movq_cfi r13, 2*8+\offset
+	movq_cfi r14, 1*8+\offset
+	movq_cfi r15, 0*8+\offset
+	.endm
 
-	.macro RESTORE_ARGS rstor_rax=1, addskip=0, rstor_rcx=1, rstor_r11=1, \
-			    rstor_r8910=1, rstor_rdx=1
-	.if \rstor_r11
-	movq_cfi_restore 0*8, r11
-	.endif
+	.macro RESTORE_EXTRA_REGS offset=0
+	movq_cfi_restore 0*8+\offset, r15
+	movq_cfi_restore 1*8+\offset, r14
+	movq_cfi_restore 2*8+\offset, r13
+	movq_cfi_restore 3*8+\offset, r12
+	movq_cfi_restore 4*8+\offset, rbp
+	movq_cfi_restore 5*8+\offset, rbx
+	.endm
 
-	.if \rstor_r8910
-	movq_cfi_restore 1*8, r10
-	movq_cfi_restore 2*8, r9
-	movq_cfi_restore 3*8, r8
+	.macro RESTORE_C_REGS_HELPER rax=1, rcx=1, r11=1, r8910=1, rdx=1
+	.if \r11
+	movq_cfi_restore 6*8, r11
 	.endif
-
-	.if \rstor_rax
-	movq_cfi_restore 4*8, rax
+	.if \r8910
+	movq_cfi_restore 7*8, r10
+	movq_cfi_restore 8*8, r9
+	movq_cfi_restore 9*8, r8
 	.endif
-
-	.if \rstor_rcx
-	movq_cfi_restore 5*8, rcx
+	.if \rax
+	movq_cfi_restore 10*8, rax
 	.endif
-
-	.if \rstor_rdx
-	movq_cfi_restore 6*8, rdx
+	.if \rcx
+	movq_cfi_restore 11*8, rcx
 	.endif
-
-	movq_cfi_restore 7*8, rsi
-	movq_cfi_restore 8*8, rdi
-
-	.if ARG_SKIP+\addskip > 0
-	addq $ARG_SKIP+\addskip, %rsp
-	CFI_ADJUST_CFA_OFFSET	-(ARG_SKIP+\addskip)
+	.if \rdx
+	movq_cfi_restore 12*8, rdx
 	.endif
+	movq_cfi_restore 13*8, rsi
+	movq_cfi_restore 14*8, rdi
 	.endm
-
-	.macro LOAD_ARGS offset, skiprax=0
-	movq \offset(%rsp),    %r11
-	movq \offset+8(%rsp),  %r10
-	movq \offset+16(%rsp), %r9
-	movq \offset+24(%rsp), %r8
-	movq \offset+40(%rsp), %rcx
-	movq \offset+48(%rsp), %rdx
-	movq \offset+56(%rsp), %rsi
-	movq \offset+64(%rsp), %rdi
-	.if \skiprax
-	.else
-	movq \offset+72(%rsp), %rax
-	.endif
+	.macro RESTORE_C_REGS
+	RESTORE_C_REGS_HELPER 1,1,1,1,1
 	.endm
-
-#define REST_SKIP	(6*8)
-
-	.macro SAVE_REST
-	subq $REST_SKIP, %rsp
-	CFI_ADJUST_CFA_OFFSET	REST_SKIP
-	movq_cfi rbx, 5*8
-	movq_cfi rbp, 4*8
-	movq_cfi r12, 3*8
-	movq_cfi r13, 2*8
-	movq_cfi r14, 1*8
-	movq_cfi r15, 0*8
+	.macro RESTORE_C_REGS_EXCEPT_RAX
+	RESTORE_C_REGS_HELPER 0,1,1,1,1
 	.endm
-
-	.macro RESTORE_REST
-	movq_cfi_restore 0*8, r15
-	movq_cfi_restore 1*8, r14
-	movq_cfi_restore 2*8, r13
-	movq_cfi_restore 3*8, r12
-	movq_cfi_restore 4*8, rbp
-	movq_cfi_restore 5*8, rbx
-	addq $REST_SKIP, %rsp
-	CFI_ADJUST_CFA_OFFSET	-(REST_SKIP)
+	.macro RESTORE_C_REGS_EXCEPT_RCX
+	RESTORE_C_REGS_HELPER 1,0,1,1,1
 	.endm
-
-	.macro SAVE_ALL
-	SAVE_ARGS
-	SAVE_REST
+	.macro RESTORE_RSI_RDI
+	RESTORE_C_REGS_HELPER 0,0,0,0,0
+	.endm
+	.macro RESTORE_RSI_RDI_RDX
+	RESTORE_C_REGS_HELPER 0,0,0,0,1
 	.endm
 
-	.macro RESTORE_ALL addskip=0
-	RESTORE_REST
-	RESTORE_ARGS 1, \addskip
+	.macro REMOVE_PTREGS_FROM_STACK addskip=0
+	addq $15*8+\addskip, %rsp
+	CFI_ADJUST_CFA_OFFSET -(15*8+\addskip)
 	.endm
 
 	.macro icebp
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index bba3cf8..6f98c16 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -171,9 +171,9 @@ static inline int arch_irqs_disabled(void)
 #define ARCH_LOCKDEP_SYS_EXIT_IRQ	\
 	TRACE_IRQS_ON; \
 	sti; \
-	SAVE_REST; \
+	SAVE_EXTRA_REGS; \
 	LOCKDEP_SYS_EXIT; \
-	RESTORE_REST; \
+	RESTORE_EXTRA_REGS; \
 	cli; \
 	TRACE_IRQS_OFF;
 
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 6205f0c..c822b35 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -31,13 +31,17 @@ struct pt_regs {
 #else /* __i386__ */
 
 struct pt_regs {
+/*
+ * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
+ * unless syscall needs a complete, fully filled "struct pt_regs".
+ */
 	unsigned long r15;
 	unsigned long r14;
 	unsigned long r13;
 	unsigned long r12;
 	unsigned long bp;
 	unsigned long bx;
-/* arguments: non interrupts/non tracing syscalls only save up to here*/
+/* These regs are callee-clobbered. Always saved on kernel entry. */
 	unsigned long r11;
 	unsigned long r10;
 	unsigned long r9;
@@ -47,9 +51,12 @@ struct pt_regs {
 	unsigned long dx;
 	unsigned long si;
 	unsigned long di;
+/*
+ * On syscall entry, this is syscall#. On CPU exception, this is error code.
+ * On hw interrupt, it's IRQ number:
+ */
 	unsigned long orig_ax;
-/* end of arguments */
-/* cpu exception frame or undefined */
+/* Return frame for iretq */
 	unsigned long ip;
 	unsigned long cs;
 	unsigned long flags;
diff --git a/arch/x86/include/uapi/asm/ptrace-abi.h b/arch/x86/include/uapi/asm/ptrace-abi.h
index 7b0a55a..580aee3 100644
--- a/arch/x86/include/uapi/asm/ptrace-abi.h
+++ b/arch/x86/include/uapi/asm/ptrace-abi.h
@@ -25,13 +25,17 @@
 #else /* __i386__ */
 
 #if defined(__ASSEMBLY__) || defined(__FRAME_OFFSETS)
+/*
+ * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
+ * unless syscall needs a complete, fully filled "struct pt_regs".
+ */
 #define R15 0
 #define R14 8
 #define R13 16
 #define R12 24
 #define RBP 32
 #define RBX 40
-/* arguments: interrupts/non tracing syscalls only save up to here*/
+/* These regs are callee-clobbered. Always saved on kernel entry. */
 #define R11 48
 #define R10 56
 #define R9 64
@@ -41,15 +45,17 @@
 #define RDX 96
 #define RSI 104
 #define RDI 112
-#define ORIG_RAX 120       /* = ERROR */
-/* end of arguments */
-/* cpu exception frame or undefined in case of fast syscall. */
+/*
+ * On syscall entry, this is syscall#. On CPU exception, this is error code.
+ * On hw interrupt, it's IRQ number:
+ */
+#define ORIG_RAX 120
+/* Return frame for iretq */
 #define RIP 128
 #define CS 136
 #define EFLAGS 144
 #define RSP 152
 #define SS 160
-#define ARGOFFSET R11
 #endif /* __ASSEMBLY__ */
 
 /* top of stack page */
diff --git a/arch/x86/include/uapi/asm/ptrace.h b/arch/x86/include/uapi/asm/ptrace.h
index ac4b9aa..bc16115 100644
--- a/arch/x86/include/uapi/asm/ptrace.h
+++ b/arch/x86/include/uapi/asm/ptrace.h
@@ -41,13 +41,17 @@ struct pt_regs {
 #ifndef __KERNEL__
 
 struct pt_regs {
+/*
+ * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
+ * unless syscall needs a complete, fully filled "struct pt_regs".
+ */
 	unsigned long r15;
 	unsigned long r14;
 	unsigned long r13;
 	unsigned long r12;
 	unsigned long rbp;
 	unsigned long rbx;
-/* arguments: non interrupts/non tracing syscalls only save up to here*/
+/* These regs are callee-clobbered. Always saved on kernel entry. */
 	unsigned long r11;
 	unsigned long r10;
 	unsigned long r9;
@@ -57,9 +61,12 @@ struct pt_regs {
 	unsigned long rdx;
 	unsigned long rsi;
 	unsigned long rdi;
+/*
+ * On syscall entry, this is syscall#. On CPU exception, this is error code.
+ * On hw interrupt, it's IRQ number:
+ */
 	unsigned long orig_rax;
-/* end of arguments */
-/* cpu exception frame or undefined */
+/* Return frame for iretq */
 	unsigned long rip;
 	unsigned long cs;
 	unsigned long eflags;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 37f7d95..b3c3ebb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -26,12 +26,6 @@
  * Some macro usage:
  * - CFI macros are used to generate dwarf2 unwind information for better
  * backtraces. They don't change any code.
- * - SAVE_ALL/RESTORE_ALL - Save/restore all registers
- * - SAVE_ARGS/RESTORE_ARGS - Save/restore registers that C functions modify.
- * There are unfortunately lots of special cases where some registers
- * not touched. The macro is a big mess that should be cleaned up.
- * - SAVE_REST/RESTORE_REST - Handle the registers not saved by SAVE_ARGS.
- * Gives a full stack frame.
  * - ENTRY/END Define functions in the symbol table.
  * - FIXUP_TOP_OF_STACK/RESTORE_TOP_OF_STACK - Fix up the hardware stack
  * frame that is otherwise undefined after a SYSCALL
@@ -264,7 +258,7 @@ ENTRY(ret_from_fork)
 
 	GET_THREAD_INFO(%rcx)
 
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 
 	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
 	jz   1f
@@ -276,12 +270,10 @@ ENTRY(ret_from_fork)
 	jmp ret_from_sys_call			# go to the SYSRET fastpath
 
 1:
-	subq $REST_SKIP, %rsp	# leave space for volatiles
-	CFI_ADJUST_CFA_OFFSET	REST_SKIP
 	movq %rbp, %rdi
 	call *%rbx
 	movl $0, RAX(%rsp)
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(ret_from_fork)
@@ -339,7 +331,8 @@ GLOBAL(system_call_after_swapgs)
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,0
+	ALLOC_PTREGS_ON_STACK 8
+	SAVE_C_REGS
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
@@ -375,9 +368,9 @@ sysret_check:
 	 * sysretq will re-enable interrupts:
 	 */
 	TRACE_IRQS_ON
+	RESTORE_C_REGS_EXCEPT_RCX
 	movq RIP-ARGOFFSET(%rsp),%rcx
 	CFI_REGISTER	rip,rcx
-	RESTORE_ARGS 1,-ARG_SKIP,0
 	/*CFI_REGISTER	rflags,r11*/
 	movq	PER_CPU_VAR(old_rsp), %rsp
 	USERGS_SYSRET64
@@ -429,7 +422,7 @@ auditsys:
 	movq %rax,%rsi			/* 2nd arg: syscall number */
 	movl $AUDIT_ARCH_X86_64,%edi	/* 1st arg: audit arch */
 	call __audit_syscall_entry
-	LOAD_ARGS 0		/* reload call-clobbered registers */
+	RESTORE_C_REGS			/* reload call-clobbered registers */
 	jmp system_call_fastpath
 
 	/*
@@ -453,7 +446,7 @@ tracesys:
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz auditsys
 #endif
-	SAVE_REST
+	SAVE_EXTRA_REGS
 	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
 	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp,%rdi
@@ -463,8 +456,8 @@ tracesys:
 	 * We don't reload %rax because syscall_trace_enter() returned
 	 * the value it wants us to use in the table lookup.
 	 */
-	LOAD_ARGS ARGOFFSET, 1
-	RESTORE_REST
+	RESTORE_C_REGS_EXCEPT_RAX
+	RESTORE_EXTRA_REGS
 #if __SYSCALL_MASK == ~0
 	cmpq $__NR_syscall_max,%rax
 #else
@@ -515,7 +508,7 @@ int_very_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 int_check_syscall_exit_work:
-	SAVE_REST
+	SAVE_EXTRA_REGS
 	/* Check for syscall exit trace */
 	testl $_TIF_WORK_SYSCALL_EXIT,%edx
 	jz int_signal
@@ -534,7 +527,7 @@ int_signal:
 	call do_notify_resume
 1:	movl $_TIF_WORK_MASK,%edi
 int_restore_rest:
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
@@ -544,15 +537,12 @@ END(system_call)
 	.macro FORK_LIKE func
 ENTRY(stub_\func)
 	CFI_STARTPROC
-	popq	%r11			/* save return address */
-	PARTIAL_FRAME 0
-	SAVE_REST
-	pushq	%r11			/* put it back on stack */
+	DEFAULT_FRAME 0, 8		/* offset 8: return address */
+	SAVE_EXTRA_REGS 8
 	FIXUP_TOP_OF_STACK %r11, 8
-	DEFAULT_FRAME 0 8		/* offset 8: return address */
 	call sys_\func
 	RESTORE_TOP_OF_STACK %r11, 8
-	ret $REST_SKIP		/* pop extended registers */
+	ret
 	CFI_ENDPROC
 END(stub_\func)
 	.endm
@@ -560,7 +550,7 @@ END(stub_\func)
 	.macro FIXED_FRAME label,func
 ENTRY(\label)
 	CFI_STARTPROC
-	PARTIAL_FRAME 0 8		/* offset 8: return address */
+	DEFAULT_FRAME 0, 8		/* offset 8: return address */
 	FIXUP_TOP_OF_STACK %r11, 8-ARGOFFSET
 	call \func
 	RESTORE_TOP_OF_STACK %r11, 8-ARGOFFSET
@@ -577,12 +567,12 @@ END(\label)
 ENTRY(stub_execve)
 	CFI_STARTPROC
 	addq $8, %rsp
-	PARTIAL_FRAME 0
-	SAVE_REST
+	DEFAULT_FRAME 0
+	SAVE_EXTRA_REGS
 	FIXUP_TOP_OF_STACK %r11
 	call sys_execve
 	movq %rax,RAX(%rsp)
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_execve)
@@ -594,12 +584,12 @@ END(stub_execve)
 ENTRY(stub_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
-	PARTIAL_FRAME 0
-	SAVE_REST
+	DEFAULT_FRAME 0
+	SAVE_EXTRA_REGS
 	FIXUP_TOP_OF_STACK %r11
 	call sys_rt_sigreturn
 	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_rt_sigreturn)
@@ -608,12 +598,12 @@ END(stub_rt_sigreturn)
 ENTRY(stub_x32_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
-	PARTIAL_FRAME 0
-	SAVE_REST
+	DEFAULT_FRAME 0
+	SAVE_EXTRA_REGS
 	FIXUP_TOP_OF_STACK %r11
 	call sys32_x32_rt_sigreturn
 	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_x32_rt_sigreturn)
@@ -621,13 +611,13 @@ END(stub_x32_rt_sigreturn)
 ENTRY(stub_x32_execve)
 	CFI_STARTPROC
 	addq $8, %rsp
-	PARTIAL_FRAME 0
-	SAVE_REST
+	DEFAULT_FRAME 0
+	SAVE_EXTRA_REGS
 	FIXUP_TOP_OF_STACK %r11
 	call compat_sys_execve
 	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_x32_execve)
@@ -683,51 +673,31 @@ END(interrupt)
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	/* reserve pt_regs for scratch regs and rbp */
-	subq $ORIG_RAX-RBP, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
-	cld
-	/* start from rbp in pt_regs and jump over */
-	movq_cfi rdi, (RDI-RBP)
-	movq_cfi rsi, (RSI-RBP)
-	movq_cfi rdx, (RDX-RBP)
-	movq_cfi rcx, (RCX-RBP)
-	movq_cfi rax, (RAX-RBP)
-	movq_cfi  r8,  (R8-RBP)
-	movq_cfi  r9,  (R9-RBP)
-	movq_cfi r10, (R10-RBP)
-	movq_cfi r11, (R11-RBP)
-
-	/* Save rbp so that we can unwind from get_irq_regs() */
-	movq_cfi rbp, 0
-
-	/* Save previous stack value */
-	movq %rsp, %rsi
-
-	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
-	testl $3, CS-RBP(%rsi)
+	ALLOC_PTREGS_ON_STACK
+	SAVE_C_REGS
+	movq %rsp, %rdi	/* arg1 for handler */
+	testl $3, CS(%rsp)
 	je 1f
 	SWAPGS
-	/*
+1:	/*
 	 * irq_count is used to check if a CPU is already on an interrupt stack
 	 * or not. While this is essentially redundant with preempt_count it is
 	 * a little cheaper to use a separate counter in the PDA (short of
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
-1:	incl PER_CPU_VAR(irq_count)
+	incl PER_CPU_VAR(irq_count)
 	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
-	CFI_DEF_CFA_REGISTER	rsi
+	CFI_DEF_CFA_REGISTER	rdi
 
 	/* Store previous stack value */
-	pushq %rsi
+	pushq %rdi
 	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
 			0x77 /* DW_OP_breg7 */, 0, \
 			0x06 /* DW_OP_deref */, \
-			0x08 /* DW_OP_const1u */, SS+8-RBP, \
+			0x08 /* DW_OP_const1u */, SS+8, \
 			0x22 /* DW_OP_plus */
 	/* We entered an interrupt context - irqs are off: */
 	TRACE_IRQS_OFF
-
 	call \func
 	.endm
 
@@ -749,10 +719,9 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
-	leaq ARGOFFSET-RBP(%rsi), %rsp
+	CFI_DEF_CFA rsi,SS+8	/* reg/off reset after def_cfa_expr */
+	movq %rsi, %rsp
 	CFI_DEF_CFA_REGISTER	rsp
-	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
 
 exit_intr:
 	GET_THREAD_INFO(%rcx)
@@ -789,7 +758,8 @@ retint_restore_args:	/* return to kernel space */
 	 */
 	TRACE_IRQS_IRETQ
 restore_args:
-	RESTORE_ARGS 1,8,1
+	RESTORE_C_REGS
+	REMOVE_PTREGS_FROM_STACK 8
 
 irq_return:
 	/*
@@ -876,12 +846,12 @@ retint_signal:
 	jz    retint_swapgs
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_REST
+	SAVE_EXTRA_REGS
 	movq $-1,ORIG_RAX(%rsp)
 	xorl %esi,%esi		# oldset
 	movq %rsp,%rdi		# &pt_regs
 	call do_notify_resume
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)
@@ -1256,7 +1226,9 @@ ENTRY(xen_failsafe_callback)
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
 	pushq_cfi $-1 /* orig_ax = -1 => not a system call */
-	SAVE_ALL
+	ALLOC_PTREGS_ON_STACK
+	SAVE_C_REGS
+	SAVE_EXTRA_REGS
 	jmp error_exit
 	CFI_ENDPROC
 END(xen_failsafe_callback)
@@ -1313,11 +1285,15 @@ ENTRY(paranoid_exit)
 paranoid_swapgs:
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
-	RESTORE_ALL 8
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PTREGS_FROM_STACK 8
 	jmp irq_return
 paranoid_restore:
 	TRACE_IRQS_IRETQ_DEBUG 0
-	RESTORE_ALL 8
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PTREGS_FROM_STACK 8
 	jmp irq_return
 paranoid_userspace:
 	GET_THREAD_INFO(%rcx)
@@ -1412,7 +1388,7 @@ END(error_entry)
 ENTRY(error_exit)
 	DEFAULT_FRAME
 	movl %ebx,%eax
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)
@@ -1671,8 +1647,10 @@ end_repeat_nmi:
 nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
 	/* Pop the extra iret frame at once */
-	RESTORE_ALL 6*8
+	REMOVE_PTREGS_FROM_STACK 6*8
 
 	/* Clear the NMI executing stack variable */
 	movq $0, 5*8(%rsp)
diff --git a/arch/x86/kernel/preempt.S b/arch/x86/kernel/preempt.S
index ca7f0d5..673da2f 100644
--- a/arch/x86/kernel/preempt.S
+++ b/arch/x86/kernel/preempt.S
@@ -6,9 +6,13 @@
 
 ENTRY(___preempt_schedule)
 	CFI_STARTPROC
-	SAVE_ALL
+	ALLOC_PTREGS_ON_STACK
+	SAVE_C_REGS
+	SAVE_EXTRA_REGS
 	call preempt_schedule
-	RESTORE_ALL
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PTREGS_FROM_STACK
 	ret
 	CFI_ENDPROC
 
@@ -16,9 +20,13 @@ ENTRY(___preempt_schedule)
 
 ENTRY(___preempt_schedule_context)
 	CFI_STARTPROC
-	SAVE_ALL
+	ALLOC_PTREGS_ON_STACK
+	SAVE_C_REGS
+	SAVE_EXTRA_REGS
 	call preempt_schedule_context
-	RESTORE_ALL
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PTREGS_FROM_STACK
 	ret
 	CFI_ENDPROC
 
-- 
1.8.1.4

