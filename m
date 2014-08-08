Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbaHHRqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507AbaHHRqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:46:09 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 17/17] x86: simplify iret stack handling on SYSCALL64 fastpath
Date: Fri,  8 Aug 2014 19:44:40 +0200
Message-Id: <1407519880-6719-18-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch, rcx and r11 were saved in pt_regs->rcx
and pt_regs->r11. Which looks natural, but requires messy
shuffling to/from iret stack whenever ptrace or e.g. iopl
wants to modify return address or flags - because that's
how these registers are used by SYSCALL/SYSRET.

This patch saves rcx and r11 in pt_regs->rip and pt_regs->flags,
and uses these values for SYSRET64 insn. Shuffling is eliminated.

On slow path, the values are saved in both locations - thus, ptrace
can modify rcx, and on syscall exit rcx will be different from
return address... don't see why that can be useful but anyway,
it works.

The lazy store of pt_regs->cs and pt_regs->ss is retained -
tests have shown that these insns do take ~2 cycles on fast path.

FIXUP_TOP_OF_STACK and RESTORE_TOP_OF_STACK macros are replaced
by a simpler single macro, STORE_IRET_FRAME_CS_SS.

stub_iopl is no longer needed: pt_regs->flags needs no fixing up.

PER_CPU(old_rsp) usage is simplified - now it is used only
as temp storage, and userspace stack pointer is immediately stored
in pt_regs->sp on syscall entry, instead of being used later,
on syscall exit. This allows to get rid of thread_struct::usersp.

Testing shows that syscall fast path is ~54.3 ns before
and after the patch (on 2.7 GHz Sandy Bridge CPU).

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
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
 arch/x86/include/asm/calling.h   |  18 +++--
 arch/x86/include/asm/compat.h    |   2 +-
 arch/x86/include/asm/processor.h |   1 -
 arch/x86/include/asm/ptrace.h    |   8 +--
 arch/x86/kernel/entry_64.S       | 140 +++++++++++++++++----------------------
 arch/x86/kernel/process_64.c     |   8 +--
 arch/x86/syscalls/syscall_64.tbl |   2 +-
 arch/x86/um/sys_call_table_64.c  |   2 +-
 8 files changed, 78 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index aa9113e..7afbcea 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -95,7 +95,7 @@ For 32-bit we have the following conventions - kernel is built with
 	CFI_ADJUST_CFA_OFFSET 15*8+\addskip
 	.endm
 
-	.macro SAVE_C_REGS_HELPER offset=0 rcx=1 r8plus=1
+	.macro SAVE_C_REGS_HELPER offset=0 rcx=1 r8910=1 r11=1
 	movq_cfi rdi, 14*8+\offset
 	movq_cfi rsi, 13*8+\offset
 	movq_cfi rdx, 12*8+\offset
@@ -103,21 +103,26 @@ For 32-bit we have the following conventions - kernel is built with
 	movq_cfi rcx, 11*8+\offset
 	.endif
 	movq_cfi rax, 10*8+\offset
-	.if \r8plus
+	.if \r8910
 	movq_cfi r8,  9*8+\offset
 	movq_cfi r9,  8*8+\offset
 	movq_cfi r10, 7*8+\offset
+	.endif
+	.if \r11
 	movq_cfi r11, 6*8+\offset
 	.endif
 	.endm
 	.macro SAVE_C_REGS offset=0
-	SAVE_C_REGS_HELPER \offset, 1, 1
+	SAVE_C_REGS_HELPER \offset, 1, 1, 1
 	.endm
 	.macro SAVE_C_REGS_EXCEPT_R891011
-	SAVE_C_REGS_HELPER 0, 1, 0
+	SAVE_C_REGS_HELPER 0, 1, 0, 0
 	.endm
 	.macro SAVE_C_REGS_EXCEPT_RCX_R891011
-	SAVE_C_REGS_HELPER 0, 0, 0
+	SAVE_C_REGS_HELPER 0, 0, 0, 0
+	.endm
+	.macro SAVE_C_REGS_EXCEPT_RCX_R11
+	SAVE_C_REGS_HELPER 0, 0, 1, 0
 	.endm
 
 	.macro SAVE_EXTRA_REGS offset=0
@@ -171,6 +176,9 @@ For 32-bit we have the following conventions - kernel is built with
 	.macro RESTORE_C_REGS_EXCEPT_RCX
 	RESTORE_C_REGS_HELPER 1,0,1,1,1
 	.endm
+	.macro RESTORE_C_REGS_EXCEPT_RCX_R11
+	RESTORE_C_REGS_HELPER 1,0,0,1,1
+	.endm
 	.macro RESTORE_RSI_RDI
 	RESTORE_C_REGS_HELPER 0,0,0,0,0
 	.endm
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index 59c6c40..acdee09 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -301,7 +301,7 @@ static inline void __user *arch_compat_alloc_user_space(long len)
 		sp = task_pt_regs(current)->sp;
 	} else {
 		/* -128 for the x32 ABI redzone */
-		sp = this_cpu_read(old_rsp) - 128;
+		sp = task_pt_regs(current)->sp - 128;
 	}
 
 	return (void __user *)round_down(sp - len, 16);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a4ea023..33c86c6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -474,7 +474,6 @@ struct thread_struct {
 #ifdef CONFIG_X86_32
 	unsigned long		sysenter_cs;
 #else
-	unsigned long		usersp;	/* Copy from PDA */
 	unsigned short		es;
 	unsigned short		ds;
 	unsigned short		fsindex;
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index c822b35..271c779 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -140,12 +140,8 @@ static inline bool user_64bit_mode(struct pt_regs *regs)
 #endif
 }
 
-#define current_user_stack_pointer()	this_cpu_read(old_rsp)
-/* ia32 vs. x32 difference */
-#define compat_user_stack_pointer()	\
-	(test_thread_flag(TIF_IA32) 	\
-	 ? current_pt_regs()->sp 	\
-	 : this_cpu_read(old_rsp))
+#define current_user_stack_pointer()	current_pt_regs()->sp
+#define compat_user_stack_pointer()	current_pt_regs()->sp
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 5d639a6..efe9780 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -24,8 +24,6 @@
  * - CFI macros are used to generate dwarf2 unwind information for better
  * backtraces. They don't change any code.
  * - ENTRY/END Define functions in the symbol table.
- * - FIXUP_TOP_OF_STACK/RESTORE_TOP_OF_STACK - Fix up the hardware stack
- * frame that is otherwise undefined after a SYSCALL
  * - TRACE_IRQ_* - Trace hard interrupt state for lock debugging.
  * - idtentry - Define exception entry points.
  */
@@ -121,29 +119,13 @@ ENDPROC(native_usergs_sysret64)
 #endif
 
 /*
- * C code is not supposed to know about undefined top of stack. Every time
- * a C function with an pt_regs argument is called from the SYSCALL based
- * fast path FIXUP_TOP_OF_STACK is needed.
- * RESTORE_TOP_OF_STACK syncs the syscall state after any possible ptregs
- * manipulation.
+ * struct pt_regs is not fully populated on the fast path
+ * (rcx, r11, cs and ss are not filled in).
+ * This macro populates segment registers in iret frame.
  */
-
-	/* %rsp:at FRAMEEND */
-	.macro FIXUP_TOP_OF_STACK tmp offset=0
-	movq PER_CPU_VAR(old_rsp),\tmp
-	movq \tmp,RSP+\offset(%rsp)
-	movq $__USER_DS,SS+\offset(%rsp)
-	movq $__USER_CS,CS+\offset(%rsp)
-	movq $-1,RCX+\offset(%rsp)
-	movq R11+\offset(%rsp),\tmp  /* get eflags */
-	movq \tmp,EFLAGS+\offset(%rsp)
-	.endm
-
-	.macro RESTORE_TOP_OF_STACK tmp offset=0
-	movq RSP+\offset(%rsp),\tmp
-	movq \tmp,PER_CPU_VAR(old_rsp)
-	movq EFLAGS+\offset(%rsp),\tmp
-	movq \tmp,R11+\offset(%rsp)
+	.macro STORE_IRET_FRAME_CS_SS offset=0
+	movq	$__USER_CS,CS+\offset(%rsp)
+	movq	$__USER_DS,SS+\offset(%rsp)
 	.endm
 
 /*
@@ -226,12 +208,16 @@ ENDPROC(native_usergs_sysret64)
  * Interrupts are off on entry.
  * Only called from user space.
  *
- * XXX	if we had a free scratch register we could save the RSP into the stack frame
- *      and report it properly in ps. Unfortunately we haven't.
- *
  * When user can change the frames always force IRET. That is because
  * it deals with uncanonical addresses better. SYSRET has trouble
  * with them due to bugs in both AMD and Intel CPUs.
+ *
+ * When returning through fast path, userspace sees rcx = return address,
+ * r11 = rflags. When returning through iret (e.g. if audit is active),
+ * these registers may contain garbage.
+ * For ptrace we manage to avoid that: when we hit slow path on entry,
+ * we do save rcx and r11 in pt_regs, so ptrace on exit also sees them.
+ * If slow path is entered only on exit, there will be garbage.
  */
 
 ENTRY(system_call)
@@ -256,9 +242,16 @@ GLOBAL(system_call_after_swapgs)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	ALLOC_PTREGS_ON_STACK 6*8	/* space for orig_ax and iret frame */
-	SAVE_C_REGS
-	movq  %rax,ORIG_RAX(%rsp)
-	movq  %rcx,RIP(%rsp)
+	SAVE_C_REGS_EXCEPT_RCX_R11
+	/* Fill orig_ax and, partially, iret frame (rip,flags,rsp) */
+	movq	%rax,ORIG_RAX(%rsp)
+	movq	%rcx,RIP(%rsp)
+	movq	PER_CPU_VAR(old_rsp),%rcx
+	/*movq	$__USER_CS,CS(%rsp) - moved out of fast path */
+	movq	%r11,EFLAGS(%rsp)
+	movq	%rcx,RSP(%rsp)
+	/*movq	$__USER_DS,SS(%rsp) - moved out of fast path */
+
 	CFI_REL_OFFSET rip,RIP
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jnz tracesys
@@ -276,7 +269,7 @@ from_badsys:
 	movq %rax,RAX(%rsp)
 /*
  * Syscall return path ending with SYSRET (fast path)
- * Has incomplete stack frame and undefined top of stack.
+ * Has incompletely filled pt_regs and iret frame's ss and cs.
  */
 ret_from_sys_call:
 	movl $_TIF_ALLWORK_MASK,%edi
@@ -293,11 +286,12 @@ sysret_check:
 	 * sysretq will re-enable interrupts:
 	 */
 	TRACE_IRQS_ON
-	RESTORE_C_REGS_EXCEPT_RCX
-	movq RIP(%rsp),%rcx
+	RESTORE_C_REGS_EXCEPT_RCX_R11
+	movq	RIP(%rsp),%rcx
 	CFI_REGISTER	rip,rcx
+	movq	EFLAGS(%rsp),%r11
 	/*CFI_REGISTER	rflags,r11*/
-	movq	PER_CPU_VAR(old_rsp), %rsp
+	movq	RSP(%rsp),%rsp
 	/*
 	 * 64bit SYSRET restores rip from rcx,
 	 * rflags from r11 (but RF and VM bits are forced to 0),
@@ -309,6 +303,7 @@ sysret_check:
 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */
 sysret_careful:
+	STORE_IRET_FRAME_CS_SS
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
@@ -331,7 +326,6 @@ sysret_signal:
 	 * These all wind up with the iret return path anyway,
 	 * so just join that path right now.
 	 */
-	FIXUP_TOP_OF_STACK %r11
 	jmp int_check_syscall_exit_work
 
 badsys:
@@ -370,15 +364,18 @@ sysret_audit:
 	jmp sysret_check
 #endif	/* CONFIG_AUDITSYSCALL */
 
-	/* Do syscall tracing */
+	/* Do entry syscall tracing */
 tracesys:
+	movq	RIP(%rsp),%rcx
+	STORE_IRET_FRAME_CS_SS /* fill the rest of iret frame */
+	movq	%r11,R11(%rsp) /* fill the rest of pt_regs */
+	movq	%rcx,RCX(%rsp) /* ditto */
 #ifdef CONFIG_AUDITSYSCALL
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jz auditsys
 #endif
 	SAVE_EXTRA_REGS
 	movq $-ENOSYS,RAX(%rsp) /* ptrace can change this for a bad syscall */
-	FIXUP_TOP_OF_STACK %rdi
 	movq %rsp,%rdi
 	call syscall_trace_enter
 	/*
@@ -402,7 +399,7 @@ tracesys:
 
 /*
  * Syscall return path ending with IRET.
- * Has correct top of stack, but partial stack frame.
+ * Has correct top of stack, but possibly only partially filled pt_regs.
  */
 GLOBAL(int_ret_from_sys_call)
 	DISABLE_INTERRUPTS(CLBR_NONE)
@@ -469,43 +466,15 @@ ENTRY(stub_\func)
 	CFI_STARTPROC
 	DEFAULT_FRAME 0, 8		/* offset 8: return address */
 	SAVE_EXTRA_REGS 8
-	FIXUP_TOP_OF_STACK %r11, 8
-	call sys_\func
-	RESTORE_TOP_OF_STACK %r11, 8
-	ret
+	STORE_IRET_FRAME_CS_SS 8	/* not sure we need this. paranoia */
+	jmp sys_\func
 	CFI_ENDPROC
 END(stub_\func)
 	.endm
 
-	.macro FIXED_FRAME label,func
-ENTRY(\label)
-	CFI_STARTPROC
-	DEFAULT_FRAME 0, 8		/* offset 8: return address */
-	FIXUP_TOP_OF_STACK %r11, 8
-	call \func
-	RESTORE_TOP_OF_STACK %r11, 8
-	ret
-	CFI_ENDPROC
-END(\label)
-	.endm
-
 	FORK_LIKE  clone
 	FORK_LIKE  fork
 	FORK_LIKE  vfork
-	FIXED_FRAME stub_iopl, sys_iopl
-
-ENTRY(stub_execve)
-	CFI_STARTPROC
-	addq $8, %rsp
-	DEFAULT_FRAME 0
-	SAVE_EXTRA_REGS
-	FIXUP_TOP_OF_STACK %r11
-	call sys_execve
-	movq %rax,RAX(%rsp)
-	RESTORE_EXTRA_REGS
-	jmp int_ret_from_sys_call
-	CFI_ENDPROC
-END(stub_execve)
 
 /*
  * sigreturn is special because it needs to restore all registers on return.
@@ -516,25 +485,35 @@ ENTRY(stub_rt_sigreturn)
 	addq $8, %rsp
 	DEFAULT_FRAME 0
 	SAVE_EXTRA_REGS
-	FIXUP_TOP_OF_STACK %r11
+	STORE_IRET_FRAME_CS_SS
 	call sys_rt_sigreturn
-	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
+stub_return:
+	movq %rax,RAX(%rsp)
 	RESTORE_EXTRA_REGS
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_rt_sigreturn)
 
+ENTRY(stub_execve)
+	CFI_STARTPROC
+	addq $8, %rsp
+	DEFAULT_FRAME 0
+	SAVE_EXTRA_REGS
+	STORE_IRET_FRAME_CS_SS
+	call sys_execve
+	jmp stub_return
+	CFI_ENDPROC
+END(stub_execve)
+
 #ifdef CONFIG_X86_X32_ABI
 ENTRY(stub_x32_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
 	DEFAULT_FRAME 0
 	SAVE_EXTRA_REGS
-	FIXUP_TOP_OF_STACK %r11
+	STORE_IRET_FRAME_CS_SS
 	call sys32_x32_rt_sigreturn
-	movq %rax,RAX(%rsp) # fixme, this could be done at the higher layer
-	RESTORE_EXTRA_REGS
-	jmp int_ret_from_sys_call
+	jmp stub_return
 	CFI_ENDPROC
 END(stub_x32_rt_sigreturn)
 
@@ -543,15 +522,11 @@ ENTRY(stub_x32_execve)
 	addq $8, %rsp
 	DEFAULT_FRAME 0
 	SAVE_EXTRA_REGS
-	FIXUP_TOP_OF_STACK %r11
+	STORE_IRET_FRAME_CS_SS
 	call compat_sys_execve
-	RESTORE_TOP_OF_STACK %r11
-	movq %rax,RAX(%rsp)
-	RESTORE_EXTRA_REGS
-	jmp int_ret_from_sys_call
+	jmp stub_return
 	CFI_ENDPROC
 END(stub_x32_execve)
-
 #endif
 
 /*
@@ -576,10 +551,13 @@ ENTRY(ret_from_fork)
 	testl $3, CS(%rsp)			# from kernel_thread?
 	jz   1f
 
+	/*
+	 * TODO: can we instead check CS(%rsp) == __USER32_CS below?
+	 * We won't need GET_THREAD_INFO(%rcx) then...
+	 */
 	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
 
-	RESTORE_TOP_OF_STACK %rdi
 	jmp ret_from_sys_call			# go to the SYSRET fastpath
 
 1:
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2105487e..5a7ba74 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -161,7 +161,6 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.sp0 = (unsigned long)task_stack_page(p) + THREAD_SIZE;
 	childregs = task_pt_regs(p);
 	p->thread.sp = (unsigned long) childregs;
-	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
 	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
@@ -238,10 +237,8 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	loadsegment(es, _ds);
 	loadsegment(ds, _ds);
 	load_gs_index(0);
-	current->thread.usersp	= new_sp;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	this_cpu_write(old_rsp, new_sp);
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
@@ -359,8 +356,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = this_cpu_read(old_rsp);
-	this_cpu_write(old_rsp, next->usersp);
 	this_cpu_write(current_task, next_p);
 
 	/*
@@ -559,6 +554,5 @@ long sys_arch_prctl(int code, unsigned long addr)
 
 unsigned long KSTK_ESP(struct task_struct *task)
 {
-	return (test_tsk_thread_flag(task, TIF_IA32)) ?
-			(task_pt_regs(task)->sp) : ((task)->thread.usersp);
+	return task_pt_regs(task)->sp;
 }
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1..8b745ae 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -178,7 +178,7 @@
 169	common	reboot			sys_reboot
 170	common	sethostname		sys_sethostname
 171	common	setdomainname		sys_setdomainname
-172	common	iopl			stub_iopl
+172	common	iopl			sys_iopl
 173	common	ioperm			sys_ioperm
 174	64	create_module
 175	common	init_module		sys_init_module
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index f2f0723..5c81ed2 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -16,7 +16,7 @@
  */
 
 /* Not going to be implemented by UML, since we have no hardware. */
-#define stub_iopl sys_ni_syscall
+#define sys_iopl sys_ni_syscall
 #define sys_ioperm sys_ni_syscall
 
 /*
-- 
1.8.1.4

