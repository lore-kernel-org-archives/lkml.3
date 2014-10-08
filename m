Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaJHONZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:13:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43707 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbaJHONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:13:24 -0400
Date: Wed, 8 Oct 2014 15:13:06 +0100
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
Subject: Re: [PATCH v7 1/6] arm64: ptrace: add PTRACE_SET_SYSCALL
Message-ID: <20141008141306.GQ26140@arm.com>
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org>
 <1412243176-16192-2-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412243176-16192-2-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Thu, Oct 02, 2014 at 10:46:11AM +0100, AKASHI Takahiro wrote:
> To allow tracer to be able to change/skip a system call by re-writing
> a syscall number, there are several approaches:
> 
> (1) modify x8 register with ptrace(PTRACE_SETREGSET), and handle this case
>     later on in syscall_trace_enter(), or
> (2) support ptrace(PTRACE_SET_SYSCALL) as on arm
> 
> Thinking of the fact that user_pt_regs doesn't expose 'syscallno' to
> tracer as well as that secure_computing() expects a changed syscall number
> to be visible, especially case of -1, before this function returns in
> syscall_trace_enter(), we'd better take (2).
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/include/uapi/asm/ptrace.h |    1 +
>  arch/arm64/kernel/ptrace.c           |   14 +++++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
> index 6913643..49c6174 100644
> --- a/arch/arm64/include/uapi/asm/ptrace.h
> +++ b/arch/arm64/include/uapi/asm/ptrace.h
> @@ -23,6 +23,7 @@
>  
>  #include <asm/hwcap.h>
>  
> +#define PTRACE_SET_SYSCALL	23
>  
>  /*
>   * PSR bits
> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> index fe63ac5..2842f9f 100644
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -1082,7 +1082,19 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
>  long arch_ptrace(struct task_struct *child, long request,
>  		 unsigned long addr, unsigned long data)
>  {
> -	return ptrace_request(child, request, addr, data);
> +	int ret;
> +
> +	switch (request) {
> +		case PTRACE_SET_SYSCALL:
> +			task_pt_regs(child)->syscallno = data;
> +			ret = 0;
> +			break;
> +		default:
> +			ret = ptrace_request(child, request, addr, data);
> +			break;
> +	}
> +
> +	return ret;
>  }

I still don't understand why this needs to be in arch-specific code. Can't
we implement this in generic code and get architectures to implement
something like syscall_set_nr if they want the generic interface?

Will
