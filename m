Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbbANVtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:49:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbbANVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:49:52 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] x86: get rid of KERNEL_STACK_OFFSET
Date: Wed, 14 Jan 2015 22:48:19 +0100
Message-Id: <1421272101-16847-9-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PER_CPU_VAR(kernel_stack) was set up in a way where it points
five stack slots below the top of stack.

Presumably, it was done to avoid one "sub $5*8,%rsp"
in syscall/sysenter code paths, where iret frame needs to be
created by hand.

Ironically, none of them benefit from this optimization,
since all of them need to allocate additional data on stack
(struct pt_regs), so they still have to perform subtraction.
And ia32_sysenter_target even needs to *undo* this optimization:
it constructs iret stack with pushes instead of movs,
so it needs to start right at the top.

This patch eliminates KERNEL_STACK_OFFSET.
PER_CPU_VAR(kernel_stack) now points directly to top of stack.
pt_regs allocations are adjusted to allocate iret frame as well.

Semi-mysterious expressions THREAD_INFO(%rsp,RIP) - "why RIP??"
are now replaced by more logical THREAD_INFO(%rsp,SIZEOF_PTREGS) -
"rsp is SIZEOF_PTREGS bytes below the top, calculate
thread_info's address using that information"

Net result in code is that one instruction is eliminated,
and constants in several others have changed.

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
 arch/x86/ia32/ia32entry.S          | 35 +++++++++++++++++------------------
 arch/x86/include/asm/calling.h     |  2 ++
 arch/x86/include/asm/thread_info.h |  8 +++-----
 arch/x86/kernel/cpu/common.c       |  2 +-
 arch/x86/kernel/entry_64.S         |  9 ++++-----
 arch/x86/kernel/process_32.c       |  3 +--
 arch/x86/kernel/process_64.c       |  3 +--
 arch/x86/kernel/smpboot.c          |  3 +--
 arch/x86/xen/smp.c                 |  3 +--
 9 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 366f633..ed58fe1 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -125,7 +125,6 @@ ENTRY(ia32_sysenter_target)
 	CFI_REGISTER	rsp,rbp
 	SWAPGS_UNSAFE_STACK
 	movq	PER_CPU_VAR(kernel_stack), %rsp
-	addq	$(KERNEL_STACK_OFFSET),%rsp
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
@@ -139,7 +138,7 @@ ENTRY(ia32_sysenter_target)
 	CFI_REL_OFFSET rsp,0
 	pushfq_cfi
 	/*CFI_REL_OFFSET rflags,0*/
-	movl	TI_sysenter_return+THREAD_INFO(%rsp,3*8-KERNEL_STACK_OFFSET),%r10d
+	movl	TI_sysenter_return+THREAD_INFO(%rsp,3*8),%r10d
 	CFI_REGISTER rip,r10
 	pushq_cfi $__USER32_CS
 	/*CFI_REL_OFFSET cs,0*/
@@ -171,8 +170,8 @@ ENTRY(ia32_sysenter_target)
 	jnz sysenter_fix_flags
 sysenter_flags_fixed:
 
-	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
-	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,SIZEOF_PTREGS)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	CFI_REMEMBER_STATE
 	jnz  sysenter_tracesys
 	cmpq	$(IA32_NR_syscalls-1),%rax
@@ -184,10 +183,10 @@ sysenter_dispatch:
 	movq	%rax,RAX(%rsp)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP)
+	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jnz	sysexit_audit
 sysexit_from_sys_call:
-	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
+	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl	$~0x200,EFLAGS(%rsp)
 	movl	RIP(%rsp),%edx		/* User %eip */
@@ -232,7 +231,7 @@ sysexit_from_sys_call:
 	.endm
 
 	.macro auditsys_exit exit
-	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP)
+	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
@@ -247,7 +246,7 @@ sysexit_from_sys_call:
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP)
+	testl %edi,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jz \exit
 	CLEAR_RREGS
 	jmp int_with_check
@@ -269,7 +268,7 @@ sysenter_fix_flags:
 
 sysenter_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP)
+	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jz	sysenter_auditsys
 #endif
 	SAVE_EXTRA_REGS
@@ -318,7 +317,7 @@ ENDPROC(ia32_sysenter_target)
 ENTRY(ia32_cstar_target)
 	CFI_STARTPROC32	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
+	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
@@ -330,7 +329,7 @@ ENTRY(ia32_cstar_target)
 	 * disabled irqs and here we enable it straight after entry:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	ALLOC_PT_GPREGS_ON_STACK 8	/* +8: space for orig_ax */
+	ALLOC_PT_GPREGS_ON_STACK 6*8 /* 6*8: space for orig_ax and iret frame */
 	SAVE_C_REGS_EXCEPT_RCX_R891011
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX(%rsp)
@@ -353,8 +352,8 @@ ENTRY(ia32_cstar_target)
 1:	movl	(%r8),%r9d
 	_ASM_EXTABLE(1b,ia32_badarg)
 	ASM_CLAC
-	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
-	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
+	orl     $TS_COMPAT,TI_status+THREAD_INFO(%rsp,SIZEOF_PTREGS)
+	testl   $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
 	cmpq $IA32_NR_syscalls-1,%rax
@@ -366,10 +365,10 @@ cstar_dispatch:
 	movq %rax,RAX(%rsp)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP)
+	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jnz sysretl_audit
 sysretl_from_sys_call:
-	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
+	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	RESTORE_RSI_RDI_RDX
 	movl RIP(%rsp),%ecx
 	CFI_REGISTER rip,rcx
@@ -404,7 +403,7 @@ sysretl_audit:
 
 cstar_tracesys:
 #ifdef CONFIG_AUDITSYSCALL
-	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP)
+	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jz cstar_auditsys
 #endif
 	xchgl %r9d,%ebp
@@ -471,8 +470,8 @@ ENTRY(ia32_syscall)
 	   this could be a problem. */
 	ALLOC_PT_GPREGS_ON_STACK
 	SAVE_C_REGS_EXCEPT_R891011
-	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP)
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
+	orl $TS_COMPAT,TI_status+THREAD_INFO(%rsp,SIZEOF_PTREGS)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jnz ia32_tracesys
 	cmpq $(IA32_NR_syscalls-1),%rax
 	ja ia32_badsys
diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index 3cd7e31..9f0de92 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -88,6 +88,8 @@ For 32-bit we have the following conventions - kernel is built with
 #define RSP		19*8
 #define SS		20*8
 
+#define SIZEOF_PTREGS	21*8
+
 	.macro ALLOC_PT_GPREGS_ON_STACK addskip=0
 	subq	$15*8+\addskip, %rsp
 	CFI_ADJUST_CFA_OFFSET 15*8+\addskip
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e82e95a..3eb9d05 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -149,7 +149,6 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
 #define STACK_WARN		(THREAD_SIZE/8)
-#define KERNEL_STACK_OFFSET	(5*(BITS_PER_LONG/8))
 
 /*
  * macros/functions for gaining access to the thread information structure
@@ -163,8 +162,7 @@ DECLARE_PER_CPU(unsigned long, kernel_stack);
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(this_cpu_read_stable(kernel_stack) +
-		      KERNEL_STACK_OFFSET - THREAD_SIZE);
+	ti = (void *)(this_cpu_read_stable(kernel_stack) - THREAD_SIZE);
 	return ti;
 }
 
@@ -184,13 +182,13 @@ static inline unsigned long current_stack_pointer(void)
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg) \
 	_ASM_MOV PER_CPU_VAR(kernel_stack),reg ; \
-	_ASM_SUB $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg ;
+	_ASM_SUB $(THREAD_SIZE),reg ;
 
 /*
  * Same if PER_CPU_VAR(kernel_stack) is, perhaps with some offset, already in
  * a certain register (to be used in assembler memory operands).
  */
-#define THREAD_INFO(reg, off) KERNEL_STACK_OFFSET+(off)-THREAD_SIZE(reg)
+#define THREAD_INFO(reg, off) (off)-THREAD_SIZE(reg)
 
 #endif
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c604965..aa76c69 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1116,7 +1116,7 @@ static __init int setup_disablecpuid(char *arg)
 __setup("clearcpuid=", setup_disablecpuid);
 
 DEFINE_PER_CPU(unsigned long, kernel_stack) =
-	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
+	(unsigned long)&init_thread_union + THREAD_SIZE;
 EXPORT_PER_CPU_SYMBOL(kernel_stack);
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 71036fe..279af0e 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -236,7 +236,7 @@ ENDPROC(native_usergs_sysret64)
 ENTRY(system_call)
 	CFI_STARTPROC	simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,KERNEL_STACK_OFFSET
+	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
 	SWAPGS_UNSAFE_STACK
@@ -248,20 +248,19 @@ ENTRY(system_call)
 GLOBAL(system_call_after_swapgs)
 
 	movq	%rsp,PER_CPU_VAR(old_rsp)
-	/* kernel_stack is set so that 5 slots (iret frame) are preallocated */
 	movq	PER_CPU_VAR(kernel_stack),%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
 	 * and short:
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	ALLOC_PT_GPREGS_ON_STACK 8		/* +8: space for orig_ax */
+	ALLOC_PT_GPREGS_ON_STACK 6*8 /* 6*8: space for orig_ax and iret frame */
 	SAVE_C_REGS_EXCEPT_RAX_RCX
 	movq	$-ENOSYS,RAX(%rsp)
 	movq_cfi rax,(ORIG_RAX)
 	movq	%rcx,RIP(%rsp)
 	CFI_REL_OFFSET rip,RIP
-	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP)
+	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)
 	jnz tracesys
 system_call_fastpath:
 #if __SYSCALL_MASK == ~0
@@ -285,7 +284,7 @@ sysret_check:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
-	movl TI_flags+THREAD_INFO(%rsp,RIP),%edx
+	movl TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
 	CFI_REMEMBER_STATE
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8f3ebfe..ecda2bd 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -311,8 +311,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	arch_end_context_switch(next_p);
 
 	this_cpu_write(kernel_stack,
-		  (unsigned long)task_stack_page(next_p) +
-		  THREAD_SIZE - KERNEL_STACK_OFFSET);
+		(unsigned long)task_stack_page(next_p) + THREAD_SIZE);
 
 	/*
 	 * Restore %gs if needed (which is common)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5a2c029..975d342 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -414,8 +414,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_count);
 
 	this_cpu_write(kernel_stack,
-		  (unsigned long)task_stack_page(next_p) +
-		  THREAD_SIZE - KERNEL_STACK_OFFSET);
+		(unsigned long)task_stack_page(next_p) + THREAD_SIZE);
 
 	/*
 	 * Now maybe reload the debug registers and handle I/O bitmaps
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6d7022c..66fd449 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -776,8 +776,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	initial_gs = per_cpu_offset(cpu);
 #endif
 	per_cpu(kernel_stack, cpu) =
-		(unsigned long)task_stack_page(idle) -
-		KERNEL_STACK_OFFSET + THREAD_SIZE;
+		(unsigned long)task_stack_page(idle) + THREAD_SIZE;
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
 	stack_start  = idle->thread.sp;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 4c071ae..4e71a3b 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -452,8 +452,7 @@ static int xen_cpu_up(unsigned int cpu, struct task_struct *idle)
 	clear_tsk_thread_flag(idle, TIF_FORK);
 #endif
 	per_cpu(kernel_stack, cpu) =
-		(unsigned long)task_stack_page(idle) -
-		KERNEL_STACK_OFFSET + THREAD_SIZE;
+		(unsigned long)task_stack_page(idle) + THREAD_SIZE;
 
 	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
-- 
1.8.1.4

