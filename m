Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaBQRgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:36:10 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36749 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaBQRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:36:07 -0500
Date: Mon, 17 Feb 2014 17:35:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH] arm64: make a single hook to syscall_trace() for all
 syscall features
Message-ID: <20140217173522.GD26590@mudshark.cambridge.arm.com>
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

On Fri, Feb 07, 2014 at 10:07:31AM +0000, AKASHI Takahiro wrote:
> Currently syscall_trace() is called only for ptrace.
> With additional TIF_xx flags introduced, it is now called in all the cases
> of audit, ftrace and seccomp in addition to ptrace.
> Those features will be implemented later, but it's safe to include them
> now because they can not be turned on anyway.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
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

[...]

> +#define _TIF_WORK_SYSCALL	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
> +				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)

This is called _TIF_SYSCALL_WORK on arch/arm/, any reason not to follow the
naming convention here?

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

This doesn't look right for things like audit (where we don't want to report
the syscall if only _TIF_SYSCALL_AUDIT is set, for example).

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

This hunk doesn't do anything.

Will
