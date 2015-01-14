Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbbANVtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:49:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbbANVtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:49:01 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] x86: entry_64.S: always allocate complete "struct pt_regs"
Date: Wed, 14 Jan 2015 22:48:11 +0100
Message-Id: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit code was using six stack slots less by not saving/restoring
registers which are callee-preserved according to C ABI,
and not allocating space for them.
Only when syscall needed a complete "struct pt_regs",
the complete area was allocated and filled in.
As an additional twist, on interrupt entry a "slightly less truncated pt_regs"
trick is used, to make nested interrupt stacks easier to unwind.

This proved to be a source of significant obfuscation and subtle bugs.
For example, stub_fork had to pop the return address,
extend the struct, save registers, and push return address back. Ugly.
ia32_ptregs_common pops return address and "returns" via jmp insn,
throwing a wrench into CPU return stack cache.

This patch changes code to always allocate a complete "struct pt_regs".
The saving of registers is still done lazily.

"Partial pt_regs" trick on interrupt stack is retained, but with added comments
which explain what we are doing, and why. Existing comments are improved.

Macros which manipulate "struct pt_regs" on stack are reworked:
ALLOC_PT_GPREGS_ON_STACK allocates the structure.
SAVE_C_REGS saves to it those registers which are clobbered by C code.
SAVE_EXTRA_REGS saves to it all other registers.
Corresponding RESTORE_* and REMOVE_PT_GPREGS_FROM_STACK macros reverse it.

ia32_ptregs_common, stub_fork and friends lost their ugly dance with
return pointer.

LOAD_ARGS32 in ia32entry.S now uses symbolic stack offsets
instead of magic numbers.

error_entry and save_paranoid now use SAVE_C_REGS + SAVE_EXTRA_REGS
instead of having it open-coded yet again.

Misleading and slightly wrong comments in "struct pt_regs" are fixed
(four instances).

Patch was run-tested: 64-bit executables, 32-bit executables,
strace works.
Timing tests did not show measurable difference in 32-bit
and 64-bit syscalls.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
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
 arch/x86/include/asm/calling.h         | 222 ++++++++++++++++-----------------
 arch/x86/include/asm/irqflags.h        |   4 +-
 arch/x86/include/asm/ptrace.h          |  13 +-
 arch/x86/include/uapi/asm/ptrace-abi.h |  16 ++-
 arch/x86/include/uapi/asm/ptrace.h     |  13 +-
 arch/x86/kernel/entry_64.S             | 210 +++++++++++++------------------
 7 files changed, 250 insertions(+), 275 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 156ebca..f4bed49 100644
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
+	ALLOC_PT_GPREGS_ON_STACK
+	SAVE_C_REGS_EXCEPT_R891011
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
 	ASM_STAC
@@ -182,7 +183,8 @@ sysexit_from_sys_call:
 	andl	$~0x200,EFLAGS-ARGOFFSET(%rsp)
 	movl	RIP-ARGOFFSET(%rsp),%edx		/* User %eip */
 	CFI_REGISTER rip,rdx
-	RESTORE_ARGS 0,24,0,0,0,0
+	RESTORE_RSI_RDI
+	REMOVE_PT_GPREGS_FROM_STACK 3*8
 	xorq	%r8,%r8
 	xorq	%r9,%r9
 	xorq	%r10,%r10
@@ -256,13 +258,13 @@ sysenter_tracesys:
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
@@ -304,7 +306,8 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8,0,0
+	ALLOC_PT_GPREGS_ON_STACK 8
+	SAVE_C_REGS_EXCEPT_RCX_R891011
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq	%rcx,RIP-ARGOFFSET(%rsp)
@@ -341,7 +344,7 @@ cstar_dispatch:
 	jnz sysretl_audit
 sysretl_from_sys_call:
 	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
-	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
+	RESTORE_RSI_RDI_RDX
 	movl RIP-ARGOFFSET(%rsp),%ecx
 	CFI_REGISTER rip,rcx
 	movl EFLAGS-ARGOFFSET(%rsp),%r11d	
@@ -372,13 +375,13 @@ cstar_tracesys:
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
@@ -433,7 +436,8 @@ ENTRY(ia32_syscall)
 	cld
 	/* note the registers are not zero extended to the sf.
 	   this could be a problem. */
-	SAVE_ARGS 0,1,0
+	ALLOC_PT_GPREGS_ON_STACK
+	SAVE_C_REGS_EXCEPT_R891011
 	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_tracesys
@@ -446,16 +450,16 @@ ia32_sysret:
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
@@ -492,7 +496,6 @@ GLOBAL(stub32_clone)
 
 	ALIGN
 ia32_ptregs_common:
-	popq %r11
 	CFI_ENDPROC
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
@@ -507,9 +510,9 @@ ia32_ptregs_common:
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
index 1f1297b..a2ef97a 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -55,143 +55,137 @@ For 32-bit we have the following conventions - kernel is built with
  * for assembly code:
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
-	.macro SAVE_ARGS addskip=0, save_rcx=1, save_r891011=1, rax_enosys=0
-	subq  $9*8+\addskip, %rsp
-	CFI_ADJUST_CFA_OFFSET	9*8+\addskip
-	movq_cfi rdi, 8*8
-	movq_cfi rsi, 7*8
-	movq_cfi rdx, 6*8
-
-	.if \save_rcx
-	movq_cfi rcx, 5*8
-	.endif
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
+	.macro ALLOC_PT_GPREGS_ON_STACK addskip=0
+	subq	$15*8+\addskip, %rsp
+	CFI_ADJUST_CFA_OFFSET 15*8+\addskip
+	.endm
 
-	.if \rax_enosys
-	movq $-ENOSYS, 4*8(%rsp)
-	.else
-	movq_cfi rax, 4*8
+	.macro SAVE_C_REGS_HELPER offset=0 rax=1 rcx=1 r8plus=1
+	.if \r8plus
+	movq_cfi r11, 6*8+\offset
+	movq_cfi r10, 7*8+\offset
+	movq_cfi r9,  8*8+\offset
+	movq_cfi r8,  9*8+\offset
 	.endif
-
-	.if \save_r891011
-	movq_cfi r8,  3*8
-	movq_cfi r9,  2*8
-	movq_cfi r10, 1*8
-	movq_cfi r11, 0*8
+	.if \rax
+	movq_cfi rax, 10*8+\offset
+	.endif
+	.if \rcx
+	movq_cfi rcx, 11*8+\offset
 	.endif
+	movq_cfi rdx, 12*8+\offset
+	movq_cfi rsi, 13*8+\offset
+	movq_cfi rdi, 14*8+\offset
+	.endm
+	.macro SAVE_C_REGS offset=0
+	SAVE_C_REGS_HELPER \offset, 1, 1, 1
+	.endm
+	.macro SAVE_C_REGS_EXCEPT_RAX_RCX offset=0
+	SAVE_C_REGS_HELPER \offset, 0, 0, 1
+	.endm
+	.macro SAVE_C_REGS_EXCEPT_R891011
+	SAVE_C_REGS_HELPER 0, 1, 1, 0
+	.endm
+	.macro SAVE_C_REGS_EXCEPT_RCX_R891011
+	SAVE_C_REGS_HELPER 0, 1, 0, 0
+	.endm
 
+	.macro SAVE_EXTRA_REGS offset=0
+	movq_cfi r15, 0*8+\offset
+	movq_cfi r14, 1*8+\offset
+	movq_cfi r13, 2*8+\offset
+	movq_cfi r12, 3*8+\offset
+	movq_cfi rbp, 4*8+\offset
+	movq_cfi rbx, 5*8+\offset
+	.endm
+	.macro SAVE_EXTRA_REGS_RBP offset=0
+	movq_cfi rbp, 4*8+\offset
 	.endm
 
-#define ARG_SKIP	(9*8)
+	.macro RESTORE_EXTRA_REGS offset=0
+	movq_cfi_restore 0*8+\offset, r15
+	movq_cfi_restore 1*8+\offset, r14
+	movq_cfi_restore 2*8+\offset, r13
+	movq_cfi_restore 3*8+\offset, r12
+	movq_cfi_restore 4*8+\offset, rbp
+	movq_cfi_restore 5*8+\offset, rbx
+	.endm
 
-	.macro RESTORE_ARGS rstor_rax=1, addskip=0, rstor_rcx=1, rstor_r11=1, \
-			    rstor_r8910=1, rstor_rdx=1
+	.macro RESTORE_C_REGS_HELPER rstor_rax=1, rstor_rcx=1, rstor_r11=1, rstor_r8910=1, rstor_rdx=1
 	.if \rstor_r11
-	movq_cfi_restore 0*8, r11
+	movq_cfi_restore 6*8, r11
 	.endif
-
 	.if \rstor_r8910
-	movq_cfi_restore 1*8, r10
-	movq_cfi_restore 2*8, r9
-	movq_cfi_restore 3*8, r8
+	movq_cfi_restore 7*8, r10
+	movq_cfi_restore 8*8, r9
+	movq_cfi_restore 9*8, r8
 	.endif
-
 	.if \rstor_rax
-	movq_cfi_restore 4*8, rax
+	movq_cfi_restore 10*8, rax
 	.endif
-
 	.if \rstor_rcx
-	movq_cfi_restore 5*8, rcx
+	movq_cfi_restore 11*8, rcx
 	.endif
-
 	.if \rstor_rdx
-	movq_cfi_restore 6*8, rdx
-	.endif
-
-	movq_cfi_restore 7*8, rsi
-	movq_cfi_restore 8*8, rdi
-
-	.if ARG_SKIP+\addskip > 0
-	addq $ARG_SKIP+\addskip, %rsp
-	CFI_ADJUST_CFA_OFFSET	-(ARG_SKIP+\addskip)
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
+	.macro REMOVE_PT_GPREGS_FROM_STACK addskip=0
+	addq $15*8+\addskip, %rsp
+	CFI_ADJUST_CFA_OFFSET -(15*8+\addskip)
 	.endm
 
 	.macro icebp
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 0a8b519..021bee9 100644
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
index 86fc2bb..4077d96 100644
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
index 7d59df2..a21b5b3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -14,9 +14,6 @@
  * NOTE: This code handles signal-recognition, which happens every time
  * after an interrupt and after each system call.
  *
- * Normal syscalls and interrupts don't save a full stack frame, this is
- * only done for syscall tracing, signals or fork/exec et.al.
- *
  * A note on terminology:
  * - top of stack: Architecture defined interrupt frame from SS to RIP
  * at the top of the kernel process stack.
@@ -26,12 +23,6 @@
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
@@ -156,7 +147,7 @@ ENDPROC(native_usergs_sysret64)
 	.endm
 
 /*
- * initial frame state for interrupts (and exceptions without error code)
+ * empty frame
  */
 	.macro EMPTY_FRAME start=1 offset=0
 	.if \start
@@ -189,9 +180,9 @@ ENDPROC(native_usergs_sysret64)
 	.endm
 
 /*
- * frame that enables calling into C.
+ * frame that enables passing a complete pt_regs to a C function.
  */
-	.macro PARTIAL_FRAME start=1 offset=0
+	.macro DEFAULT_FRAME start=1 offset=0
 	XCPT_FRAME \start, ORIG_RAX+\offset-ARGOFFSET
 	CFI_REL_OFFSET rdi, RDI+\offset-ARGOFFSET
 	CFI_REL_OFFSET rsi, RSI+\offset-ARGOFFSET
@@ -202,13 +193,6 @@ ENDPROC(native_usergs_sysret64)
 	CFI_REL_OFFSET r9, R9+\offset-ARGOFFSET
 	CFI_REL_OFFSET r10, R10+\offset-ARGOFFSET
 	CFI_REL_OFFSET r11, R11+\offset-ARGOFFSET
-	.endm
-
-/*
- * frame that enables passing a complete pt_regs to a C function.
- */
-	.macro DEFAULT_FRAME start=1 offset=0
-	PARTIAL_FRAME \start, R11+\offset-R15
 	CFI_REL_OFFSET rbx, RBX+\offset
 	CFI_REL_OFFSET rbp, RBP+\offset
 	CFI_REL_OFFSET r12, R12+\offset
@@ -220,21 +204,8 @@ ENDPROC(native_usergs_sysret64)
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
-	movq %rdi, RDI+8(%rsp)
-	movq %rsi, RSI+8(%rsp)
-	movq_cfi rdx, RDX+8
-	movq_cfi rcx, RCX+8
-	movq_cfi rax, RAX+8
-	movq %r8, R8+8(%rsp)
-	movq %r9, R9+8(%rsp)
-	movq %r10, R10+8(%rsp)
-	movq %r11, R11+8(%rsp)
-	movq_cfi rbx, RBX+8
-	movq %rbp, RBP+8(%rsp)
-	movq %r12, R12+8(%rsp)
-	movq %r13, R13+8(%rsp)
-	movq %r14, R14+8(%rsp)
-	movq %r15, R15+8(%rsp)
+	SAVE_C_REGS 8
+	SAVE_EXTRA_REGS 8
 	movl $1,%ebx
 	movl $MSR_GS_BASE,%ecx
 	rdmsr
@@ -263,7 +234,7 @@ ENTRY(ret_from_fork)
 
 	GET_THREAD_INFO(%rcx)
 
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 
 	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
 	jz   1f
@@ -275,12 +246,10 @@ ENTRY(ret_from_fork)
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
@@ -338,9 +307,11 @@ GLOBAL(system_call_after_swapgs)
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	SAVE_ARGS 8, 0, rax_enosys=1
+	ALLOC_PT_GPREGS_ON_STACK 8
+	SAVE_C_REGS_EXCEPT_RAX_RCX
+	movq	$-ENOSYS,RAX-ARGOFFSET(%rsp)
 	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
-	movq  %rcx,RIP-ARGOFFSET(%rsp)
+	movq	%rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
@@ -374,9 +345,9 @@ sysret_check:
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
@@ -428,16 +399,16 @@ sysret_audit:
 
 	/* Do syscall tracing */
 tracesys:
-	leaq -REST_SKIP(%rsp), %rdi
+	movq %rsp, %rdi
 	movq $AUDIT_ARCH_X86_64, %rsi
 	call syscall_trace_enter_phase1
 	test %rax, %rax
 	jnz tracesys_phase2		/* if needed, run the slow path */
-	LOAD_ARGS 0			/* else restore clobbered regs */
+	RESTORE_C_REGS			/* else restore clobbered regs */
 	jmp system_call_fastpath	/*      and return to the fast path */
 
 tracesys_phase2:
-	SAVE_REST
+	SAVE_EXTRA_REGS
 	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp, %rdi
 	movq $AUDIT_ARCH_X86_64, %rsi
@@ -445,12 +416,12 @@ tracesys_phase2:
 	call syscall_trace_enter_phase2
 
 	/*
-	 * Reload arg registers from stack in case ptrace changed them.
+	 * Reload registers from stack in case ptrace changed them.
 	 * We don't reload %rax because syscall_trace_entry_phase2() returned
 	 * the value it wants us to use in the table lookup.
 	 */
-	LOAD_ARGS ARGOFFSET, 1
-	RESTORE_REST
+	RESTORE_C_REGS_EXCEPT_RAX
+	RESTORE_EXTRA_REGS
 #if __SYSCALL_MASK == ~0
 	cmpq $__NR_syscall_max,%rax
 #else
@@ -501,7 +472,7 @@ int_very_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 int_check_syscall_exit_work:
-	SAVE_REST
+	SAVE_EXTRA_REGS
 	/* Check for syscall exit trace */
 	testl $_TIF_WORK_SYSCALL_EXIT,%edx
 	jz int_signal
@@ -520,7 +491,7 @@ int_signal:
 	call do_notify_resume
 1:	movl $_TIF_WORK_MASK,%edi
 int_restore_rest:
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
@@ -530,15 +501,12 @@ END(system_call)
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
@@ -546,7 +514,7 @@ END(stub_\func)
 	.macro FIXED_FRAME label,func
 ENTRY(\label)
 	CFI_STARTPROC
-	PARTIAL_FRAME 0 8		/* offset 8: return address */
+	DEFAULT_FRAME 0, 8		/* offset 8: return address */
 	FIXUP_TOP_OF_STACK %r11, 8-ARGOFFSET
 	call \func
 	RESTORE_TOP_OF_STACK %r11, 8-ARGOFFSET
@@ -563,12 +531,12 @@ END(\label)
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
@@ -576,13 +544,13 @@ END(stub_execve)
 ENTRY(stub_execveat)
 	CFI_STARTPROC
 	addq $8, %rsp
-	PARTIAL_FRAME 0
-	SAVE_REST
+	DEFAULT_FRAME 0
+	SAVE_EXTRA_REGS
 	FIXUP_TOP_OF_STACK %r11
 	call sys_execveat
 	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_execveat)
@@ -594,12 +562,12 @@ END(stub_execveat)
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
@@ -608,12 +576,12 @@ END(stub_rt_sigreturn)
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
@@ -621,13 +589,13 @@ END(stub_x32_rt_sigreturn)
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
@@ -635,13 +603,13 @@ END(stub_x32_execve)
 ENTRY(stub_x32_execveat)
 	CFI_STARTPROC
 	addq $8, %rsp
-	PARTIAL_FRAME 0
-	SAVE_REST
+	DEFAULT_FRAME 0
+	SAVE_EXTRA_REGS
 	FIXUP_TOP_OF_STACK %r11
 	call compat_sys_execveat
 	RESTORE_TOP_OF_STACK %r11
 	movq %rax,RAX(%rsp)
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_x32_execveat)
@@ -697,42 +665,36 @@ END(interrupt)
 
 /* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	/* reserve pt_regs for scratch regs and rbp */
-	subq $ORIG_RAX-RBP, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
 	cld
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
+	/*
+	 * Since nothing in interrupt handling code touches r12...r15 members
+	 * of "struct pt_regs", and since interrupts can nest, we can save
+	 * four stack slots and simultaneously provide
+	 * an unwind-friendly stack layout by saving "truncated" pt_regs
+	 * exactly up to rbp slot, without these members.
+	 */
+	ALLOC_PT_GPREGS_ON_STACK -RBP
+	SAVE_C_REGS -RBP
+	/* this goes to 0(%rsp) for unwinder, not for saving the value: */
+	SAVE_EXTRA_REGS_RBP -RBP
 
-	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
-	testl $3, CS-RBP(%rsi)
+	leaq -RBP(%rsp),%rdi	/* arg1 for \func (pointer to pt_regs) */
+
+	testl $3, CS-RBP(%rsp)
 	je 1f
 	SWAPGS
+1:
 	/*
+	 * Save previous stack pointer, optionally switch to interrupt stack.
 	 * irq_count is used to check if a CPU is already on an interrupt stack
 	 * or not. While this is essentially redundant with preempt_count it is
 	 * a little cheaper to use a separate counter in the PDA (short of
 	 * moving irq_enter into assembly, which would be too much work)
 	 */
-1:	incl PER_CPU_VAR(irq_count)
+	movq %rsp, %rsi
+	incl PER_CPU_VAR(irq_count)
 	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
 	CFI_DEF_CFA_REGISTER	rsi
-
-	/* Store previous stack value */
 	pushq %rsi
 	CFI_ESCAPE	0x0f /* DW_CFA_def_cfa_expression */, 6, \
 			0x77 /* DW_OP_breg7 */, 0, \
@@ -764,6 +726,7 @@ ret_from_intr:
 	/* Restore saved previous stack */
 	popq %rsi
 	CFI_DEF_CFA rsi,SS+8-RBP	/* reg/off reset after def_cfa_expr */
+	/* return code expects complete pt_regs - adjust rsp accordingly: */
 	leaq ARGOFFSET-RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
@@ -775,7 +738,7 @@ exit_intr:
 
 	/* Interrupt came from user space */
 	/*
-	 * Has a correct top of stack, but a partial stack frame
+	 * Has a correct top of stack.
 	 * %rcx: thread info. Interrupts off.
 	 */
 retint_with_reschedule:
@@ -803,7 +766,8 @@ retint_restore_args:	/* return to kernel space */
 	 */
 	TRACE_IRQS_IRETQ
 restore_args:
-	RESTORE_ARGS 1,8,1
+	RESTORE_C_REGS
+	REMOVE_PT_GPREGS_FROM_STACK 8
 
 irq_return:
 	INTERRUPT_RETURN
@@ -874,12 +838,12 @@ retint_signal:
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
@@ -1006,8 +970,7 @@ ENTRY(\sym)
 	pushq_cfi $-1			/* ORIG_RAX: no syscall to restart */
 	.endif
 
-	subq $ORIG_RAX-R15, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
+	ALLOC_PT_GPREGS_ON_STACK
 
 	.if \paranoid
 	.if \paranoid == 1
@@ -1253,7 +1216,9 @@ ENTRY(xen_failsafe_callback)
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
 	pushq_cfi $-1 /* orig_ax = -1 => not a system call */
-	SAVE_ALL
+	ALLOC_PT_GPREGS_ON_STACK
+	SAVE_C_REGS
+	SAVE_EXTRA_REGS
 	jmp error_exit
 	CFI_ENDPROC
 END(xen_failsafe_callback)
@@ -1305,11 +1270,15 @@ ENTRY(paranoid_exit)
 	jnz paranoid_restore
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
-	RESTORE_ALL 8
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PT_GPREGS_FROM_STACK 8
 	INTERRUPT_RETURN
 paranoid_restore:
 	TRACE_IRQS_IRETQ_DEBUG 0
-	RESTORE_ALL 8
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PT_GPREGS_FROM_STACK 8
 	INTERRUPT_RETURN
 	CFI_ENDPROC
 END(paranoid_exit)
@@ -1323,21 +1292,8 @@ ENTRY(error_entry)
 	CFI_ADJUST_CFA_OFFSET 15*8
 	/* oldrax contains error code */
 	cld
-	movq %rdi, RDI+8(%rsp)
-	movq %rsi, RSI+8(%rsp)
-	movq %rdx, RDX+8(%rsp)
-	movq %rcx, RCX+8(%rsp)
-	movq %rax, RAX+8(%rsp)
-	movq  %r8,  R8+8(%rsp)
-	movq  %r9,  R9+8(%rsp)
-	movq %r10, R10+8(%rsp)
-	movq %r11, R11+8(%rsp)
-	movq_cfi rbx, RBX+8
-	movq %rbp, RBP+8(%rsp)
-	movq %r12, R12+8(%rsp)
-	movq %r13, R13+8(%rsp)
-	movq %r14, R14+8(%rsp)
-	movq %r15, R15+8(%rsp)
+	SAVE_C_REGS 8
+	SAVE_EXTRA_REGS 8
 	xorl %ebx,%ebx
 	testl $3,CS+8(%rsp)
 	je error_kernelspace
@@ -1386,7 +1342,7 @@ END(error_entry)
 ENTRY(error_exit)
 	DEFAULT_FRAME
 	movl %ebx,%eax
-	RESTORE_REST
+	RESTORE_EXTRA_REGS
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	GET_THREAD_INFO(%rcx)
@@ -1605,8 +1561,8 @@ end_repeat_nmi:
 	 * so that we repeat another NMI.
 	 */
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
-	subq $ORIG_RAX-R15, %rsp
-	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
+	ALLOC_PT_GPREGS_ON_STACK
+
 	/*
 	 * Use save_paranoid to handle SWAPGS, but no need to use paranoid_exit
 	 * as we should not be calling schedule in NMI context.
@@ -1645,8 +1601,10 @@ end_repeat_nmi:
 nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
 	/* Pop the extra iret frame at once */
-	RESTORE_ALL 6*8
+	REMOVE_PT_GPREGS_FROM_STACK 6*8
 
 	/* Clear the NMI executing stack variable */
 	movq $0, 5*8(%rsp)
-- 
1.8.1.4

