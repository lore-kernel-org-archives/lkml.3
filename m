Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaESPc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:32:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39247 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaESPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:32:55 -0400
Date: Mon, 19 May 2014 16:32:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v3 2/2] arm64: enable context tracking
Message-ID: <20140519153220.GH15130@arm.com>
References: <1399672310-9061-1-git-send-email-larry.bassel@linaro.org>
 <1399672310-9061-3-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399672310-9061-3-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 10:51:50PM +0100, Larry Bassel wrote:
> Make calls to ct_user_enter when the kernel is exited
> and ct_user_exit when the kernel is entered (in el0_da,
> el0_ia, el0_svc, el0_irq and all of the "error" paths).
> 
> These macros expand to function calls which will only work
> properly if el0_sync and related code has been rearranged
> (in a previous patch of this series).
> 
> The calls to ct_user_exit are made after hw debugging has been
> enabled (enable_dbg).
> 
> The call to ct_user_enter is made at the beginning of the
> kernel_exit macro.
> 
> This patch is based on earlier work by Kevin Hilman.

[...]

> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 720e70b..301ea6a 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -108,6 +108,7 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_SINGLESTEP		21
>  #define TIF_32BIT		22	/* 32bit process */
>  #define TIF_SWITCH_MM		23	/* deferred switch_mm */
> +#define TIF_NOHZ                24
>  
>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 136bb7d..c839bab 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -30,6 +30,44 @@
>  #include <asm/unistd32.h>
>  
>  /*
> + * Context tracking subsystem.  Used to instrument transitions
> + * between user and kernel mode.
> + */
> +	.macro ct_user_exit, save = 0
> +#ifdef CONFIG_CONTEXT_TRACKING
> +	bl	context_tracking_user_exit
> +	.if \save == 1

It would be clearer to refer to the parameter as `restore' for the exit
case, I reckon.

> +	/*
> +	 * save/restore needed during syscalls.  Restore syscall arguments from
> +	 * the values already saved on stack during kernel_entry
> +	 */
> +	ldp	x0, x1, [sp]
> +	ldp	x2, x3, [sp, #S_X2]
> +	ldp	x4, x5, [sp, #S_X4]
> +	ldp	x6, x7, [sp, #S_X6]
> +	.endif
> +#endif
> +	.endm

[...]

>  	.macro	kernel_exit, el, ret = 0
>  	ldp	x21, x22, [sp, #S_PC]		// load ELR, SPSR
>  	.if	\el == 0
> +	ct_user_enter \ret
>  	ldr	x23, [sp, #S_SP]		// load return stack pointer
>  	.endif
>  	.if	\ret

You should check how this patch applies against my debug exception rework:

2a2830703a23 ("arm64: debug: avoid accessing mdscr_el1 on fault paths where
possible") in today's next.

As well as addressing the conflicts, it's worth nothing that the thread_info
becomes available in tsk much earlier for exceptions from userspace with
that patch applied.

Will
