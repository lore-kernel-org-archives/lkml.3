Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaGILNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:13:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37170 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbaGILNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:13:01 -0400
Date: Wed, 9 Jul 2014 12:12:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v4 2/2] arm64: Add seccomp support
Message-ID: <20140709111239.GH9485@arm.com>
References: <1404459115-8292-1-git-send-email-takahiro.akashi@linaro.org>
 <1404459115-8292-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404459115-8292-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Fri, Jul 04, 2014 at 08:31:55AM +0100, AKASHI Takahiro wrote:
> secure_computing() should always be called first in syscall_trace_enter().
> If it returns non-zero, we should stop further handling. Then that system
> call may eventually fail, be trapped or the process itself be killed
> depending on loaded rules.
> In this case, syscall_trace_enter() returns a dedicated value in order to
> skip a normal syscall table lookup because a seccomp rule may have already
> overridden errno.

[...]

> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index 70526cf..baab5fc 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -21,12 +21,14 @@
>  
>  #include <linux/audit.h>
>  #include <linux/compat.h>
> +#include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/sched.h>
>  #include <linux/mm.h>
>  #include <linux/smp.h>
>  #include <linux/ptrace.h>
>  #include <linux/user.h>
> +#include <linux/seccomp.h>
>  #include <linux/security.h>
>  #include <linux/init.h>
>  #include <linux/signal.h>
> @@ -1109,6 +1111,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
>  
>  asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>  {
> +	if (secure_computing(regs->syscallno) == -1)
> +		/* seccomp failures shouldn't expose any additional code. */
> +		return -EPERM;
> +
>  	if (test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);

We return regs->syscallno immediately after this, so we have the same issue
that Kees identified for arch/arm/. Did you follow the discussion I had with
Andy?

Will
