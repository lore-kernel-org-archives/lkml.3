Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbaCMSm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:42:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57142 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbaCMSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:42:26 -0400
Date: Thu, 13 Mar 2014 18:41:49 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v4 2/3] arm64: split syscall_trace() into separate
 functions for enter/exit
Message-ID: <20140313184149.GL25472@mudshark.cambridge.arm.com>
References: <1393564465-3862-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705491-12343-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394705491-12343-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:11:30AM +0000, AKASHI Takahiro wrote:
> As done in arm, this change makes it easy to confirm we invoke syscall
> related hooks, including syscall tracepoint, audit and seccomp which would
> be implemented later, in correct order. That is, undoing operations in the
> opposite order on exit that they were done on entry.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/kernel/entry.S  |   10 ++++-----
>  arch/arm64/kernel/ptrace.c |   48 ++++++++++++++++++++++++++++++++++----------
>  2 files changed, 41 insertions(+), 17 deletions(-)

[...]

> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 6a8928b..9993a8f 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -1058,29 +1058,27 @@ long arch_ptrace(struct task_struct *child, long request,
>  	return ptrace_request(child, request, addr, data);
>  }
>  
> -asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
> +asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>  {
>  	unsigned long saved_reg;
>  
>  	if (!test_thread_flag(TIF_SYSCALL_TRACE))
>  		return regs->syscallno;
>  
> +	/*
> +	 * A scrach register (ip(r12) on AArch32, x7 on AArch64) is
> +	 * used to denote syscall entry/exit:
> +	 *   0 -> entry
> +	 */

You could add an enum, like we have on ARM (ptrace_syscall_dir) for the two
directions.

>  	if (is_compat_task()) {
> -		/* AArch32 uses ip (r12) for scratch */
>  		saved_reg = regs->regs[12];
> -		regs->regs[12] = dir;
> +		regs->regs[12] = 0;
>  	} else {
> -		/*
> -		 * Save X7. X7 is used to denote syscall entry/exit:
> -		 *   X7 = 0 -> entry, = 1 -> exit
> -		 */
>  		saved_reg = regs->regs[7];
> -		regs->regs[7] = dir;
> +		regs->regs[7] = 0;

This code could also be refactored so we calculated the register number
once, then avoid the if (is_compact_task()) check all over the place.

Similarly on the exit path.

Will
