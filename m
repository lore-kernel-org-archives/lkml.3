Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKUV0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:26:33 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56728 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaKUV01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:26:27 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 3/5] x86, entry: Switch stacks on a paranoid entry from userspace
Date: Fri, 21 Nov 2014 13:26:09 -0800
Message-Id: <955e71b4b8427aec7e8b86de0bf877e7944ba1f3.1416604491.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
In-Reply-To: <cover.1416604491.git.luto@amacapital.net>
References: <cover.1416604491.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This causes all non-NMI, non-double-fault kernel entries from
userspace to run on the normal kernel stack.  Double-fault is
exempt to minimize confusion if we double-fault directly from
userspace due to a bad kernel stack.

This is, suprisingly, simpler and shorter than the current code.  It
removes the IMO rather frightening paranoid_userspace path, and it
make sync_regs much simpler.

There is no risk of stack overflow due to this change -- the kernel
stack that we switch to is empty.

This will also enable us to create non-atomic sections within
machine checks from userspace, which will simplify memory failure
handling.  It will also allow the upcoming fsgsbase code to be
simplified, because it doesn't need to worry about usergs when
scheduling in paranoid_exit, as that code no longer exists.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 Documentation/x86/entry_64.txt         | 18 ++++---
 Documentation/x86/x86_64/kernel-stacks |  8 ++--
 arch/x86/kernel/entry_64.S             | 86 ++++++++++++++++++----------------
 arch/x86/kernel/traps.c                | 23 ++-------
 4 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
index bc7226ef5055..8e53217e6d40 100644
--- a/Documentation/x86/entry_64.txt
+++ b/Documentation/x86/entry_64.txt
@@ -75,9 +75,6 @@ The expensive (paranoid) way is to read back the MSR_GS_BASE value
 	xorl %ebx,%ebx
 1:	ret
 
-and the whole paranoid non-paranoid macro complexity is about whether
-to suffer that RDMSR cost.
-
 If we are at an interrupt or user-trap/gate-alike boundary then we can
 use the faster check: the stack will be a reliable indicator of
 whether SWAPGS was already done: if we see that we are a secondary
@@ -90,6 +87,15 @@ which might have triggered right after a normal entry wrote CS to the
 stack but before we executed SWAPGS, then the only safe way to check
 for GS is the slower method: the RDMSR.
 
-So we try only to mark those entry methods 'paranoid' that absolutely
-need the more expensive check for the GS base - and we generate all
-'normal' entry points with the regular (faster) entry macros.
+Therefore, super-atomic entries (except NMI, which is handled separately)
+must use idtentry with paranoid=1 to handle gsbase correctly.  This
+triggers three main behavior changes:
+
+ - Interrupt entry will use the slower gsbase check.
+ - Interrupt entry from user mode will switch off the IST stack.
+ - Interrupt exit to kernel mode will not attempt to reschedule.
+
+We try to only use IST entries and the paranoid entry code for vectors
+that absolutely need the more expensive check for the GS base - and we
+generate all 'normal' entry points with the regular (faster) paranoid=0
+variant.
diff --git a/Documentation/x86/x86_64/kernel-stacks b/Documentation/x86/x86_64/kernel-stacks
index a01eec5d1d0b..e3c8a49d1a2f 100644
--- a/Documentation/x86/x86_64/kernel-stacks
+++ b/Documentation/x86/x86_64/kernel-stacks
@@ -40,9 +40,11 @@ An IST is selected by a non-zero value in the IST field of an
 interrupt-gate descriptor.  When an interrupt occurs and the hardware
 loads such a descriptor, the hardware automatically sets the new stack
 pointer based on the IST value, then invokes the interrupt handler.  If
-software wants to allow nested IST interrupts then the handler must
-adjust the IST values on entry to and exit from the interrupt handler.
-(This is occasionally done, e.g. for debug exceptions.)
+the interrupt came from user mode, then the interrupt handler prologue
+will switch back to the per-thread stack.  If software wants to allow
+nested IST interrupts then the handler must adjust the IST values on
+entry to and exit from the interrupt handler.  (This is occasionally
+done, e.g. for debug exceptions.)
 
 Events with different IST codes (i.e. with different stacks) can be
 nested.  For example, a debug interrupt can safely be interrupted by an
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb03fb3..de24b2eac6b2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1064,6 +1064,11 @@ ENTRY(\sym)
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 
 	.if \paranoid
+	.if \paranoid == 1
+	CFI_REMEMBER_STATE
+	testl $3, CS(%rsp)		/* If coming from userspace, switch */
+	jnz 1f				/* stacks. */
+	.endif
 	call save_paranoid
 	.else
 	call error_entry
@@ -1104,6 +1109,36 @@ ENTRY(\sym)
 	jmp error_exit			/* %ebx: no swapgs flag */
 	.endif
 
+	.if \paranoid == 1
+	CFI_RESTORE_STATE
+	/*
+	 * Paranoid entry from userspace.  Switch stacks and treat it
+	 * as a normal entry.  This means that paranoid handlers
+	 * run in real process context if user_mode(regs).
+	 */
+1:
+	call error_entry
+
+	DEFAULT_FRAME 0
+
+	movq %rsp,%rdi			/* pt_regs pointer */
+	call sync_regs
+	movq %rax,%rsp			/* switch stack */
+
+	movq %rsp,%rdi			/* pt_regs pointer */
+
+	.if \has_error_code
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
+	.else
+	xorl %esi,%esi			/* no error code */
+	.endif
+
+	call \do_sym
+
+	jmp error_exit			/* %ebx: no swapgs flag */
+	.endif
+
 	CFI_ENDPROC
 END(\sym)
 .endm
@@ -1124,7 +1159,7 @@ idtentry overflow do_overflow has_error_code=0
 idtentry bounds do_bounds has_error_code=0
 idtentry invalid_op do_invalid_op has_error_code=0
 idtentry device_not_available do_device_not_available has_error_code=0
-idtentry double_fault __do_double_fault has_error_code=1 paranoid=1
+idtentry double_fault __do_double_fault has_error_code=1 paranoid=2
 idtentry coprocessor_segment_overrun do_coprocessor_segment_overrun has_error_code=0
 idtentry invalid_TSS do_invalid_TSS has_error_code=1
 idtentry segment_not_present do_segment_not_present has_error_code=1
@@ -1305,16 +1340,14 @@ idtentry machine_check has_error_code=0 paranoid=1 do_sym=*machine_check_vector(
 #endif
 
 	/*
-	 * "Paranoid" exit path from exception stack.
-	 * Paranoid because this is used by NMIs and cannot take
-	 * any kernel state for granted.
-	 * We don't do kernel preemption checks here, because only
-	 * NMI should be common and it does not enable IRQs and
-	 * cannot get reschedule ticks.
+	 * "Paranoid" exit path from exception stack.  This is invoked
+	 * only on return from non-NMI IST interrupts that came
+	 * from kernel space.
 	 *
-	 * "trace" is 0 for the NMI handler only, because irq-tracing
-	 * is fundamentally NMI-unsafe. (we cannot change the soft and
-	 * hard flags at once, atomically)
+	 * We may be returning to very strange contexts (e.g. very early
+	 * in syscall entry), so checking for preemption here would
+	 * be complicated.  Fortunately, we there's no good reason
+	 * to try to handle preemption here.
 	 */
 
 	/* ebx:	no swapgs flag */
@@ -1324,43 +1357,14 @@ ENTRY(paranoid_exit)
 	TRACE_IRQS_OFF_DEBUG
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz paranoid_restore
-	testl $3,CS(%rsp)
-	jnz   paranoid_userspace
-paranoid_swapgs:
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
 	RESTORE_ALL 8
-	jmp irq_return
+	INTERRUPT_RETURN
 paranoid_restore:
 	TRACE_IRQS_IRETQ_DEBUG 0
 	RESTORE_ALL 8
-	jmp irq_return
-paranoid_userspace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz paranoid_swapgs
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz paranoid_schedule
-	movl %ebx,%edx			/* arg3: thread flags */
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
-	jmp paranoid_userspace
-paranoid_schedule:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	SCHEDULE_USER
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	TRACE_IRQS_OFF
-	jmp paranoid_userspace
+	INTERRUPT_RETURN
 	CFI_ENDPROC
 END(paranoid_exit)
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f5c4b8813774..6a02760df7b4 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -408,27 +408,14 @@ NOKPROBE_SYMBOL(do_int3);
 
 #ifdef CONFIG_X86_64
 /*
- * Help handler running on IST stack to switch back to user stack
- * for scheduling or signal handling. The actual stack switch is done in
- * entry.S
+ * Help handler running on IST stack to switch off the IST stack if the
+ * interrupted code was in user mode. The actual stack switch is done in
+ * entry_64.S
  */
 asmlinkage __visible struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
-	struct pt_regs *regs = eregs;
-	/* Did already sync */
-	if (eregs == (struct pt_regs *)eregs->sp)
-		;
-	/* Exception from user space */
-	else if (user_mode(eregs))
-		regs = task_pt_regs(current);
-	/*
-	 * Exception from kernel and interrupts are enabled. Move to
-	 * kernel process stack.
-	 */
-	else if (eregs->flags & X86_EFLAGS_IF)
-		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
-	if (eregs != regs)
-		*regs = *eregs;
+	struct pt_regs *regs = task_pt_regs(current);
+	*regs = *eregs;
 	return regs;
 }
 NOKPROBE_SYMBOL(sync_regs);
-- 
1.9.3

