Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaIKQiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:38:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55648 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755241AbaIKQiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:38:14 -0400
Date: Thu, 11 Sep 2014 17:37:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v2] arm: prevent BUG_ON in audit_syscall_entry()
Message-ID: <20140911163736.GV6158@arm.com>
References: <1410238199-956-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410238199-956-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Tue, Sep 09, 2014 at 05:49:59AM +0100, AKASHI Takahiro wrote:
> BUG_ON() in audit_syscall_entry() will be hit if user issues syscall(-1)
> while syscall auditing is enabled (that is, by starting auditd).

[...]

> diff --git a/arch/arm/include/asm/traps.h b/arch/arm/include/asm/traps.h
> index f555bb3..de01145 100644
> --- a/arch/arm/include/asm/traps.h
> +++ b/arch/arm/include/asm/traps.h
> @@ -49,6 +49,7 @@ static inline int in_exception_text(unsigned long ptr)
>  extern void __init early_trap_init(void *);
>  extern void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame);
>  extern void ptrace_break(struct task_struct *tsk, struct pt_regs *regs);
> +extern int arm_syscall(int no, struct pt_regs *regs);
>  
>  extern void *vectors_page;
>  
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index e52fe5a..28d3931 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -426,7 +426,6 @@ ENTRY(vector_swi)
>  local_restart:
>  	ldr	r10, [tsk, #TI_FLAGS]		@ check for syscall tracing
>  	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
> -

You don't need this cosmetic change.

>  	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
>  	bne	__sys_trace
>  
> @@ -476,10 +475,11 @@ __sys_trace:
>  	cmp	scno, #-1			@ skip the syscall?
>  	bne	2b
>  	add	sp, sp, #S_OFF			@ restore stack
> -	b	ret_slow_syscall
> +	b	__sys_trace_return_skipped

Can't you just remove the add as well, them fall-through here?

>  
>  __sys_trace_return:
>  	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
> +__sys_trace_return_skipped:
>  	mov	r0, sp
>  	bl	syscall_trace_exit
>  	b	ret_slow_syscall
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 0c27ed6..68b42cd 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -930,7 +930,9 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>  
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>  {
> -	current_thread_info()->syscall = scno;
> +	int orig_scno;
> +
> +	current_thread_info()->syscall = orig_scno = scno;
>  
>  	/* Do the secure computing check first; failures should be fast. */
>  	if (secure_computing(scno) == -1)
> @@ -941,31 +943,40 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs, int scno)
>  
>  	scno = current_thread_info()->syscall;
>  
> -	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> -		trace_sys_enter(regs, scno);
> +	if (scno >= 0 && scno < NR_syscalls) {

Is this supposed to work for OABI? If so, better use __NR_SYSCALL_BASE.

> +		if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> +			trace_sys_enter(regs, scno);
> +
> +		audit_syscall_entry(AUDIT_ARCH_ARM, scno,
> +				    regs->ARM_r0, regs->ARM_r1,
> +				    regs->ARM_r2, regs->ARM_r3);
> +	}
>  
> -	audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0, regs->ARM_r1,
> -			    regs->ARM_r2, regs->ARM_r3);
> +	/* user-issued syscall of -1 */
> +	if (scno == -1 && orig_scno == -1)

Make this an else if, for clarity?

> +		arm_syscall(scno, regs);

Doesn't this always result in bad_syscall being called, which sends a SIGILL
to the task? Shouldn't we simply return -ENOSYS instead? You could do that
in the assembly code.

>  	return scno;
>  }
>  
>  asmlinkage void syscall_trace_exit(struct pt_regs *regs)
>  {
> -	/*
> -	 * Audit the syscall before anything else, as a debugger may
> -	 * come in and change the current registers.
> -	 */
> -	audit_syscall_exit(regs);
> +	if (current_thread_info()->syscall < NR_syscalls) {

Again, not going to work for OABI.

Will
