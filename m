Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaFQPPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:15:45 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35333 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933337AbaFQPPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:15:42 -0400
Date: Tue, 17 Jun 2014 16:15:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/24] ARM64: Change some CONFIG_COMPAT over to use
 CONFIG_AARCH32_EL0 instead.
Message-ID: <20140617151528.GB21752@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-4-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-4-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:01:58AM -0700, Andrew Pinski wrote:
> This patch changes CONFIG_COMPAT checks inside the arm64 which are AARCH32 specific.

Please state what it is changed to. I guess CONFIG_AARCH32_EL0. Longer
commit log is always better.

> --- a/arch/arm64/include/asm/signal32.h
> +++ b/arch/arm64/include/asm/signal32.h
> @@ -20,6 +20,7 @@
>  #ifdef CONFIG_COMPAT
>  #include <linux/compat.h>
>  
> +#ifdef CONFIG_AARCH32_EL0
>  #define AARCH32_KERN_SIGRET_CODE_OFFSET	0x500

Do we still need the top CONFIG_COMPAT for signal32.h? We don't use the
signal32 infrastructure for ILP32.

> diff --git a/arch/arm64/include/asm/stat.h b/arch/arm64/include/asm/stat.h
> index 15e3559..af04276 100644
> --- a/arch/arm64/include/asm/stat.h
> +++ b/arch/arm64/include/asm/stat.h
> @@ -22,6 +22,7 @@
>  
>  #include <asm/compat.h>
>  
> +#ifdef CONFIG_AARCH32_EL0

Same here, we have another #ifdef CONFIG_COMPAT above the #include.

> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c

[...]

> @@ -1041,11 +1041,28 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
>  
>  	return ret;
>  }
> -#endif /* CONFIG_COMPAT */
> +#else /* !CONFIG_AARCH32_EL0 */
> +long compat_a32_arch_ptrace(struct task_struct *child, compat_long_t request,
> +			    compat_ulong_t caddr, compat_ulong_t cdata)
> +{
> +	return -1;
> +}
> +#endif /* !CONFIG_AARCH32_EL0 */

Can you return an appropriate error code here?

> +
> +#ifdef CONFIG_COMPAT
> +long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
> +			compat_ulong_t caddr, compat_ulong_t cdata)
> +{
> +	if (is_compat_task())
> +		return compat_a32_arch_ptrace(child, request, caddr, cdata);
> +	return compat_ptrace_request(child, request, caddr, cdata);
> +}
> +#endif

So for ILP32, will we route ptrace calls via compat_arch_ptrace? Some
explanation for this code would help as it doesn't look like a simple
CONFIG_COMPAT conversion.

> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -417,3 +417,16 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
>  		tracehook_notify_resume(regs);
>  	}
>  }
> +
> +/* Some functions are needed for compat ptrace but we don't define
> +   them if we don't have AARCH32 support compiled in */

As per the kernel coding style, the multi-line comment should be:

/*
 * Some functions are needed for compat ptrace but we don't define
 * them if we don't have AARCH32 support compiled in.
 */

> +#if defined CONFIG_COMPAT && !defined CONFIG_AARCH32_EL0
> +int copy_siginfo_to_user32(compat_siginfo_t __user *to, const siginfo_t *from)
> +{
> +	return -EFAULT;
> +}
> +int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
> +{
> +	return -EFAULT;
> +}
> +#endif

Maybe it gets clearer in subsequent patches on how this interacts with
ptrace. But at this stage in the series, COMPAT cannot be defined
without CONFIG_AARCH32_EL0, so the above could be removed.

-- 
Catalin
