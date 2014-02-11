Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaBKNu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:50:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaBKNu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:50:26 -0500
Date: Tue, 11 Feb 2014 08:49:26 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: will.deacon@arm.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        catalin.marinas@arm.com, arndb@arndb.de, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, viro@zeniv.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: make a single hook to syscall_trace() for all
 syscall features
Message-ID: <20140211134926.GA17952@madcap2.tricolour.ca>
References: <52F199D3.2060409@linaro.org>
 <1391767651-5296-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391767651-5296-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/07, AKASHI Takahiro wrote:
> Currently syscall_trace() is called only for ptrace.
> With additional TIF_xx flags introduced, it is now called in all the cases
> of audit, ftrace and seccomp in addition to ptrace.
> Those features will be implemented later, but it's safe to include them
> now because they can not be turned on anyway.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

Acked-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  arch/arm64/include/asm/thread_info.h |   13 +++++++++++++
>  arch/arm64/kernel/entry.S            |    5 +++--
>  arch/arm64/kernel/ptrace.c           |   11 +++++------
>  3 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 720e70b..c3df797 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -91,6 +91,9 @@ static inline struct thread_info *current_thread_info(void)
>  /*
>   * thread information flags:
>   *  TIF_SYSCALL_TRACE	- syscall trace active
> + *  TIF_SYSCALL_TRACEPOINT - syscall tracepoint for ftrace
> + *  TIF_SYSCALL_AUDIT	- syscall auditing
> + *  TIF_SECOMP		- syscall secure computing
>   *  TIF_SIGPENDING	- signal pending
>   *  TIF_NEED_RESCHED	- rescheduling necessary
>   *  TIF_NOTIFY_RESUME	- callback before returning to user
> @@ -101,6 +104,9 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_NEED_RESCHED	1
>  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
>  #define TIF_SYSCALL_TRACE	8
> +#define TIF_SYSCALL_AUDIT	9
> +#define TIF_SYSCALL_TRACEPOINT	10
> +#define TIF_SECCOMP		11
>  #define TIF_POLLING_NRFLAG	16
>  #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
>  #define TIF_FREEZE		19
> @@ -112,10 +118,17 @@ static inline struct thread_info *current_thread_info(void)
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> +#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
> +#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
> +#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
> +#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
>  #define _TIF_32BIT		(1 << TIF_32BIT)
>  
>  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
>  				 _TIF_NOTIFY_RESUME)
>  
> +#define _TIF_WORK_SYSCALL	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
> +				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
> +
>  #endif /* __KERNEL__ */
>  #endif /* __ASM_THREAD_INFO_H */
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 39ac630..c94b2ab 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -631,8 +631,9 @@ el0_svc_naked:					// compat entry point
>  	enable_irq
>  
>  	get_thread_info tsk
> -	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
> -	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
> +	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall hooks
> +	tst	x16, #_TIF_WORK_SYSCALL
> +	b.ne	__sys_trace
>  	adr	lr, ret_fast_syscall		// return address
>  	cmp     scno, sc_nr                     // check upper syscall limit
>  	b.hs	ni_sys
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 6a8928b..64ce39f 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -1062,9 +1062,6 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>  {
>  	unsigned long saved_reg;
>  
> -	if (!test_thread_flag(TIF_SYSCALL_TRACE))
> -		return regs->syscallno;
> -
>  	if (is_compat_task()) {
>  		/* AArch32 uses ip (r12) for scratch */
>  		saved_reg = regs->regs[12];
> @@ -1078,10 +1075,12 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>  		regs->regs[7] = dir;
>  	}
>  
> -	if (dir)
> +	if (dir) {
>  		tracehook_report_syscall_exit(regs, 0);
> -	else if (tracehook_report_syscall_entry(regs))
> -		regs->syscallno = ~0UL;
> +	} else {
> +		if (tracehook_report_syscall_entry(regs))
> +			regs->syscallno = ~0UL;
> +	}
>  
>  	if (is_compat_task())
>  		regs->regs[12] = saved_reg;
> -- 
> 1.7.9.5
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
