Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaKKUFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:05:13 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45256 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaKKUFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:05:10 -0500
Message-ID: <54626BF2.7070304@amacapital.net>
Date: Tue, 11 Nov 2014 12:05:06 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 4/8] x86: Add support for rd/wr fs/gs base
References: <1415663739-25525-1-git-send-email-andi@firstfloor.org> <1415663739-25525-4-git-send-email-andi@firstfloor.org>
In-Reply-To: <1415663739-25525-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 03:55 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Introduction:
> 
> IvyBridge added four new instructions to directly write the fs and gs
> 64bit base registers. Previously this had to be done with a system
> call to write to MSRs. The main use case is fast user space threading
> and switching the fs/gs registers quickly there. Another use
> case is having (relatively) cheap access to a new address
> register per thread.
> 
> The instructions are opt-in and have to be explicitely enabled
> by the OS.
> 
> For more details on how to use the instructions see
> Documentation/x86/fsgs.txt added in a followon patch.
> 
> Paranoid exception path changes:
> ===============================
> 
> The paranoid entry/exit code is used for any NMI like
> exception.
> 
> Previously Linux couldn't support the new instructions
> because the paranoid entry code relied on the gs base never being
> negative outside the kernel to decide when to use swaps. It would
> check the gs MSR value and assume it was already running in
> kernel if negative.
> 
> To get rid of this assumption we have to revamp the paranoid exception
> path to not rely on this. We can use the new instructions
> to get (relatively) quick access to the GS value, and use
> it directly.
> 
> This is also significantly faster than a MSR read, so will speed
> NMIs (critical for profiling)
> 
> The kernel gs for the paranoid path is now stored at the
> bottom of the IST stack (so that it can be derived from RSP).
> For this we need to know the size of the IST stack
> (4K or 8K), which is now passed in as a stack parameter
> to save_paranoid.
> 
> The original patch compared the gs with the kernel gs and
> assumed that if it was identical, swapgs was not needed
> (and no user space processing was needed). This
> was nice and simple and didn't need a lot of changes.
> 
> But this had the side effect that if a user process set its
> GS to the same as the kernel it may lose rescheduling
> checks (so a racing reschedule IPI would have been
> only acted upon the next non paranoid interrupt)
> 
> This version now switches to full save/restore of the GS.
> This requires quite some changes in the paranoid path.
> Unfortunately I didn't come up with a simpler scheme.
> 
> Previously we had a flag in EBX that indicated whether
> SWAPGS needs to be called later or not. In the new scheme
> this turns into a tristate, with a new "restore from R15"
> mode that is used when the FSGSBASE instructions are available.
> In this case the GS base is saved and restored.
> The exit paths are all adjusted to handle this correctly.
> 
> There is one complication: to allow debuggers (especially
> from the int3 or debug vectors) access to the user GS
> we need to save it in the task struct. Normally
> the next context switch would overwrite it with the wrong
> value from kernel_gs, so we set new flag also in task_struct
> that prevents it. The flag is cleared on context switch.
> 
> [Even with the additional flag the new FS/GS context switch
> is vastly faster than the old MSR based version for bases >4GB]
> 
> To prevent recursive interrupts clobbering this
> state in the task_struct this is only done for interrupts
> coming directly from ring 3.

Since this just came up in a different context today, I'd like to
propose a different solution to this piece of the problem.

Can we change the paranoid entry to check if the entry came from ring 3
and to just switch stacks immediately to the standard kernel stack and
run the non-paranoid entry code?  This eliminates paranoid_userspace
entirely, and there are no special gsbase machinations any more for the
entry-from-userspace path.

In fact, I think that this will result in the MSR KERNEL_GS_BASE value
*always* matching the userspace gs value from any C code in the kernel,
since we'll always swapgs exactly once on entry from userspace.

If we make this change, then:

> 
> After a reschedule comes back we check if the flag is still
> set. If it wasn't set the GS is back in the (swapped) kernel
> gs so we revert to the SWAPGS mode, instead of restoring GS.
> 
> So the three possible states for the paranoid exit path are:
> 
> - Do nothing (pre FSGSBASE), if we interrupted the kernel
> as determined by the existing negative GS

This works the same way as before.

> - Do swapgs, if we interrupted user space with positive GS
> (pre FSGSBASE), or we saved gs, but it was overwritten
> later by a context switch (with FSGSBASE)

This can never happen on paranoid return.

> - Restore from R15 (with FSGSBASE), if the gs base was saved
> in R15, and not overwritten by a context switch.
> 

I think that if we implement my suggestion, then we can't have a context
switch here either.

> Context switch changes:
> ======================
> 
> Then after these changes we need to also use the new instructions
> to save/restore fs and gs, so that the new values set by the
> users won't disappear.  This is also significantly
> faster for the case when the 64bit base has to be switched
> (that is when GS is larger than 4GB), as we can replace
> the slow MSR write with a faster wr[fg]sbase execution.
> 
> The instructions do not context switch
> the segment index, so the old invariant that fs or gs index
> have to be 0 for a different 64bit value to stick is still
> true. Previously it was enforced by arch_prctl, now the user
> program has to make sure it keeps the segment indexes zero.
> If it doesn't the changes may not stick.
> 
> [Yes, this implies that programs can find out when they
> got context switched. However they could already do that
> before by checking the timing.]

I don't like this.  Also, starting in 3.19 (if my CR4 patches get
merged), then this isn't true in a tight enough seccomp sandbox.

What's wrong with switching the segment indexes separately?  In the
common case, this will be two reads of segment registers per context
switch (to check if the previous segments registers were nonzero), which
should be pretty cheap.

Also, it's probably very unsafe to let one task leak an LDT index in fs
or gs into another task.  This is asking for cross-task segfaults in the
hands of malicious users.


Also, at some point hpa suggested that we should start saving and
restoring fs, gs, fsbase, and gsbase in sigcontext when we enable this
feature.  Userspace code might want that.

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 59def4c..db74af5 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -953,6 +953,9 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>  #ifdef CONFIG_NUMA
>  	numa_add_cpu(smp_processor_id());
>  #endif
> +
> +	if (cpu_has(c, X86_FEATURE_FSGSBASE))
> +		set_in_cr4(X86_CR4_FSGSBASE);

This will conflict with my cr4 patches (the merge will fail to compile).
 We can cross that bridge when we get to it.

>  
> +/* Values of the ebx flag: */
> +#define DO_RESTORE_R15	 2 /* Restore GS at end */
> +#define DO_SWAPGS	 1 /* Use SWAPGS at end */
> +#define DO_NOTHING	 0 /* Back to ring 0 with same gs */
> +
> +/*
> + * Stack layout:
> + * +16 pt_regs
> + * +8  stack mask for ist or 0
> + * +0  return address.
> + */
> +#define OFF 16
> +#define STKMSK 8
> +
>  ENTRY(save_paranoid)
> -	XCPT_FRAME 1 RDI+8
> +	XCPT_FRAME 1 RDI+OFF
>  	cld
> -	movq %rdi, RDI+8(%rsp)
> -	movq %rsi, RSI+8(%rsp)
> -	movq_cfi rdx, RDX+8
> -	movq_cfi rcx, RCX+8
> -	movq_cfi rax, RAX+8
> -	movq %r8, R8+8(%rsp)
> -	movq %r9, R9+8(%rsp)
> -	movq %r10, R10+8(%rsp)
> -	movq %r11, R11+8(%rsp)
> -	movq_cfi rbx, RBX+8
> -	movq %rbp, RBP+8(%rsp)
> -	movq %r12, R12+8(%rsp)
> -	movq %r13, R13+8(%rsp)
> -	movq %r14, R14+8(%rsp)
> -	movq %r15, R15+8(%rsp)
> -	movl $1,%ebx
> +	movq %rdi, RDI+OFF(%rsp)
> +	movq %rsi, RSI+OFF(%rsp)
> +	movq_cfi rdx, RDX+OFF
> +	movq_cfi rcx, RCX+OFF
> +	movq_cfi rax, RAX+OFF
> +	movq %r8, R8+OFF(%rsp)
> +	movq %r9, R9+OFF(%rsp)
> +	movq %r10, R10+OFF(%rsp)
> +	movq %r11, R11+OFF(%rsp)
> +	movq_cfi rbx, RBX+OFF
> +	movq %rbp, RBP+OFF(%rsp)
> +	movq %r12, R12+OFF(%rsp)
> +	movq %r13, R13+OFF(%rsp)
> +	movq %r14, R14+OFF(%rsp)
> +	movq %r15, R15+OFF(%rsp)
> +	movq $-1,ORIG_RAX+OFF(%rsp)	/* no syscall to restart */
> +33:
> +	ASM_NOP5	/* May be replaced with jump to paranoid_save_gs */
> +34:
> +	movl $DO_NOTHING,%ebx
>  	movl $MSR_GS_BASE,%ecx
>  	rdmsr
>  	testl %edx,%edx
>  	js 1f	/* negative -> in kernel */
>  	SWAPGS
> -	xorl %ebx,%ebx
> +	movl $DO_SWAPGS,%ebx
>  1:	ret
> +
> +	/* Patch in jump to paranoid_save_gs for X86_FEATURE_FSGSBASE */
> +	.section .altinstr_replacement,"ax"
> +35:	.byte 0xe9 /* 32bit near jump */
> +	.long paranoid_save_gs-34b
> +	.previous
> +	.section .altinstructions,"a"
> +	altinstruction_entry 33b,35b,X86_FEATURE_FSGSBASE,5,5
> +	.previous
> +
> +	/* Faster version not using RDMSR, and also not assuming
> +	 * anything about the previous GS value.
> +	 * This allows the user to arbitarily change GS using
> +	 * WRGSBASE.
> +	 */
> +paranoid_save_gs:
> +	RDGSBASE_R15			# read previous gs
> +	movq STKMSK(%rsp),%rax		# get ist stack mask
> +	andq %rsp,%rax			# get bottom of stack
> +	movq (%rax),%rdi		# get expected GS
> +	WRGSBASE_RDI			# set gs for kernel
> +	mov $DO_RESTORE_R15,%ebx	# flag for exit code
> +	testl $3,CS+OFF(%rsp)		# did we come from ring 0?
> +	je paranoid_save_gs_kernel
> +	/*
> +	 * Saving GS in the task struct allows a debugger to manipulate
> +	 * it. We only do this when coming from ring 3 to avoid recursion
> +	 * clobbering the state.
> +	 */
> +	movq PER_CPU_VAR(current_task),%rcx # get current
> +	movb $1,task_thread_gs_saved(%rcx)  # tell context switch gs is
> +					    # is already saved
> +	movq %r15,task_thread_gs(%rcx)      # save gs in task struct

As mentioned above, it seems like this would be simplified if this code
could never happen.

> +paranoid_save_gs_kernel:
> +	ret
> +
>  	CFI_ENDPROC
>  END(save_paranoid)
>  
> @@ -1040,7 +1096,8 @@ apicinterrupt IRQ_WORK_VECTOR \
>   */
>  #define INIT_TSS_IST(x) PER_CPU_VAR(init_tss) + (TSS_ist + ((x) - 1) * 8)
>  
> -.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1
> +.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1 \
> +		stack_mask=-EXCEPTION_STKSZ
>  ENTRY(\sym)
>  	/* Sanity check */
>  	.if \shift_ist != -1 && \paranoid == 0
> @@ -1064,7 +1121,10 @@ ENTRY(\sym)
>  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  
>  	.if \paranoid
> +	pushq_cfi $\stack_mask		/* ist stack size */
>  	call save_paranoid
> +	/* r15: previous gs */
> +	popq_cfi %rax			/* Drop ist stack size */

IMO this is a bit ugly, but I don't see a better solution off the top of
my head.

>  	.else
>  	call error_entry
>  	.endif
> @@ -1099,7 +1159,7 @@ ENTRY(\sym)
>  	.endif
>  
>  	.if \paranoid
> -	jmp paranoid_exit		/* %ebx: no swapgs flag */
> +	jmp paranoid_exit		/* %ebx: no swapgs flag, r15: old gs */
>  	.else
>  	jmp error_exit			/* %ebx: no swapgs flag */
>  	.endif
> @@ -1287,8 +1347,10 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
>  	hyperv_callback_vector hyperv_vector_handler
>  #endif /* CONFIG_HYPERV */
>  
> -idtentry debug do_debug has_error_code=0 paranoid=1 shift_ist=DEBUG_STACK
> -idtentry int3 do_int3 has_error_code=0 paranoid=1 shift_ist=DEBUG_STACK
> +idtentry debug do_debug has_error_code=0 paranoid=1 shift_ist=DEBUG_STACK \
> +	 stack_mask=-DEBUG_STKSZ
> +idtentry int3 do_int3 has_error_code=0 paranoid=1 shift_ist=DEBUG_STACK \
> +	 stack_mask=-DEBUG_STKSZ
>  idtentry stack_segment do_stack_segment has_error_code=1 paranoid=1
>  #ifdef CONFIG_XEN
>  idtentry xen_debug do_debug has_error_code=0
> @@ -1317,49 +1379,69 @@ idtentry machine_check has_error_code=0 paranoid=1 do_sym=*machine_check_vector(
>  	 * hard flags at once, atomically)
>  	 */
>  
> -	/* ebx:	no swapgs flag */
> +	/* ebx:	no swapgs flag, r15: gs if ebx == DO_RESTORE_R15 */
>  ENTRY(paranoid_exit)
>  	DEFAULT_FRAME
>  	DISABLE_INTERRUPTS(CLBR_NONE)
>  	TRACE_IRQS_OFF_DEBUG
> -	testl %ebx,%ebx				/* swapgs needed? */
> -	jnz paranoid_restore
> +	cmpl  $DO_NOTHING,%ebx		/* swapgs needed? */
> +	je  paranoid_restore
>  	testl $3,CS(%rsp)
>  	jnz   paranoid_userspace
>  paranoid_swapgs:
>  	TRACE_IRQS_IRETQ 0
> +	cmpl  $DO_RESTORE_R15,%ebx	/* restore gs? */
> +	je  paranoid_restore_gs

If we switched off the IST for an entry from userspace, we wouldn't need
the conditionals at all for the rdfsgsbase case, right?


>  	SWAPGS_UNSAFE_STACK
>  	RESTORE_ALL 8
>  	jmp irq_return
> +paranoid_restore_gs:
> +	WRGSBASE_R15
> +	RESTORE_ALL 8
> +	jmp irq_return
>  paranoid_restore:
>  	TRACE_IRQS_IRETQ_DEBUG 0
>  	RESTORE_ALL 8
>  	jmp irq_return
>  paranoid_userspace:
>  	GET_THREAD_INFO(%rcx)
> -	movl TI_flags(%rcx),%ebx
> -	andl $_TIF_WORK_MASK,%ebx
> -	jz paranoid_swapgs
> +	movl TI_flags(%rcx),%ebp
> +	andl $_TIF_WORK_MASK,%ebp
> +	jz paranoid_clear_gs_flag
>  	movq %rsp,%rdi			/* &pt_regs */
>  	call sync_regs
>  	movq %rax,%rsp			/* switch stack for scheduling */
> -	testl $_TIF_NEED_RESCHED,%ebx
> +	testl $_TIF_NEED_RESCHED,%ebp
>  	jnz paranoid_schedule
> -	movl %ebx,%edx			/* arg3: thread flags */
> +	movl %ebp,%edx			/* arg3: thread flags */
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_NONE)
>  	xorl %esi,%esi 			/* arg2: oldset */
>  	movq %rsp,%rdi 			/* arg1: &pt_regs */
>  	call do_notify_resume
> -	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> -	jmp paranoid_userspace
> +	jmp paranoid_after_schedule
> +paranoid_clear_gs_flag:
> +	movq PER_CPU_VAR(current_task),%rcx
> +	movb $0,task_thread_gs_saved(%rcx)
> +	jmp paranoid_swapgs
>  paranoid_schedule:
>  	TRACE_IRQS_ON
>  	ENABLE_INTERRUPTS(CLBR_ANY)
>  	SCHEDULE_USER
> +paranoid_after_schedule:
>  	DISABLE_INTERRUPTS(CLBR_ANY)
>  	TRACE_IRQS_OFF
> +	cmpl $DO_RESTORE_R15,%ebx
> +	jne  paranoid_userspace
> +	movq PER_CPU_VAR(current_task),%rcx
> +	cmpb $0,task_thread_gs_saved(%rcx) /* did we schedule? */
> +	jne  paranoid_userspace		   /* did not schedule: keep our gs */
> +	/*
> +	 * Otherwise the context switch has put the correct gs into
> +	 * kernel_gs, so we can just end with swapgs and it
> +	 * will DTRT.
> +	 */
> +	mov  $DO_SWAPGS,%ebx		   /* force swapgs after schedule */

OMG more special cases :(  I'm liking my stack-switching proposal even
more.  Grr, entry code is a mess.

> +	if (static_cpu_has(X86_FEATURE_FSGSBASE)) {
> +		prev->fs = rdfsbase();
> +		/* Interrupts are disabled here. */
> +		if (!prev->gs_saved) {
> +			swapgs();
> +			prev->gs = rdgsbase();
> +			swapgs();

Is this adequately protected against kprobes?

--Andy
