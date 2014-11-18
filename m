Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaKROEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:04:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60248 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbaKROE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:04:29 -0500
Date: Tue, 18 Nov 2014 14:04:25 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20141118140425.GM18842@arm.com>
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org>
 <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 01:10:34AM +0000, AKASHI Takahiro wrote:
> If tracer specifies -1 as a syscall number, this traced system call should
> be skipped with a return value specified in x0.
> This patch implements this semantics, but there is one restriction here:
> 
>     syscall(-1) always return ENOSYS whatever value is stored in x0
>     (a return value) at syscall entry.
> 
> Normally, with ptrace off, syscall(-1) returns -ENOSYS. With ptrace on,
> however, if a tracer didn't pay any attention to user-issued syscall(-1)
> and just let it go, it would return a value in x0 as in other system call
> cases. This means that this system call might succeed and yet see any bogus
> return value. This should be definitely avoided.
> 
> Please also note:
> * syscall entry tracing and syscall exit tracing (ftrace tracepoint and
>   audit) are always executed, if enabled, even when skipping a system call
>   (that is, -1).
>   In this way, we can avoid a potential bug where audit_syscall_entry()
>   might be called without audit_syscall_exit() at the previous system call
>   being called, that would cause OOPs in audit_syscall_entry().
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/kernel/entry.S  |    3 +++
>  arch/arm64/kernel/ptrace.c |   18 ++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 726b910..01118b1 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -670,6 +670,8 @@ ENDPROC(el0_svc)
>  __sys_trace:
>  	mov	x0, sp
>  	bl	syscall_trace_enter
> +	cmp	w0, #-1				// skip the syscall?
> +	b.eq	__sys_trace_return_skipped
>  	adr	lr, __sys_trace_return		// return address
>  	uxtw	scno, w0			// syscall number (possibly new)
>  	mov	x1, sp				// pointer to regs
> @@ -684,6 +686,7 @@ __sys_trace:
>  
>  __sys_trace_return:
>  	str	x0, [sp]			// save returned x0
> +__sys_trace_return_skipped:
>  	mov	x0, sp
>  	bl	syscall_trace_exit
>  	b	ret_to_user
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 8b98781..34b1e85 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -1149,6 +1149,8 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>  
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>  {
> +	int orig_syscallno = regs->syscallno;
> +
>  	if (test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
>  
> @@ -1158,6 +1160,22 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>  	audit_syscall_entry(regs->syscallno, regs->orig_x0, regs->regs[1],
>  			    regs->regs[2], regs->regs[3]);
>  
> +	if (((int)regs->syscallno == -1) && (orig_syscallno == -1)) {
> +		/*
> +		 * user-issued syscall(-1):
> +		 * RESTRICTION: We always return ENOSYS whatever value is
> +		 *   stored in x0 (a return value) at this point.
> +		 * Normally, with ptrace off, syscall(-1) returns -ENOSYS.
> +		 * With ptrace on, however, if a tracer didn't pay any
> +		 * attention to user-issued syscall(-1) and just let it go
> +		 * without a hack here, it would return a value in x0 as in
> +		 * other system call cases. This means that this system call
> +		 * might succeed and see any bogus return value.
> +		 * This should be definitely avoided.
> +		 */
> +		regs->regs[0] = -ENOSYS;
> +	}

I'm still really uncomfortable with this, and it doesn't seem to match what
arch/arm/ does either. Doesn't it also prevent a tracer from skipping
syscall(-1)?

Will
