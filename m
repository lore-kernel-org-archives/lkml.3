Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaE2UhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:37:14 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62164 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaE2UhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:37:12 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v6 2/2] arm64: enable context tracking
References: <1401394139-23469-1-git-send-email-larry.bassel@linaro.org>
	<1401394139-23469-3-git-send-email-larry.bassel@linaro.org>
Date: Thu, 29 May 2014 13:37:10 -0700
In-Reply-To: <1401394139-23469-3-git-send-email-larry.bassel@linaro.org>
	(Larry Bassel's message of "Thu, 29 May 2014 13:08:59 -0700")
Message-ID: <7hzji0z5hl.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Bassel <larry.bassel@linaro.org> writes:

> Make calls to ct_user_enter when the kernel is exited
> and ct_user_exit when the kernel is entered (in el0_da,
> el0_ia, el0_svc, el0_irq and all of the "error" paths).
>
> These macros expand to function calls which will only work
> properly if el0_sync and related code has been rearranged
> (in a previous patch of this series).
>
> The calls to ct_user_exit are made after hw debugging has been
> enabled (enable_dbg_and_irq).
>
> The call to ct_user_enter is made at the beginning of the
> kernel_exit macro.
>
> This patch is based on earlier work by Kevin Hilman.
> Save/restore optimizations were also done by Kevin.
>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
> ---
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/thread_info.h |  4 ++++
>  arch/arm64/kernel/entry.S            | 39 +++++++++++++++++++++++++++++++++++-
>  3 files changed, 43 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e759af5..ef18ae5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -55,6 +55,7 @@ config ARM64
>  	select RTC_LIB
>  	select SPARSE_IRQ
>  	select SYSCTL_EXCEPTION_TRACE
> +	select HAVE_CONTEXT_TRACKING
>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>  
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 720e70b..8363f34 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -100,6 +100,7 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_SIGPENDING		0
>  #define TIF_NEED_RESCHED	1
>  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
> +#define TIF_NOHZ                7

FWIW, in earlier versions this was bit 24, but we had to move it into
the first 2 bytes..

>  #define TIF_SYSCALL_TRACE	8
>  #define TIF_POLLING_NRFLAG	16
>  #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
> @@ -113,9 +114,12 @@ static inline struct thread_info *current_thread_info(void)
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
>  #define _TIF_32BIT		(1 << TIF_32BIT)
> +#define _TIF_SYSCALL_TRACE      (1 << TIF_SYSCALL_TRACE)
> +#define _TIF_NOHZ               (1 << TIF_NOHZ)
>  
>  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
>  				 _TIF_NOTIFY_RESUME)
> +#define _TIF_SYSCALL_WORK       (_TIF_SYSCALL_TRACE | _TIF_NOHZ)

...so that when this is used...

[...]

> @@ -616,9 +651,11 @@ el0_svc:
>  el0_svc_naked:					// compat entry point
>  	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
>  	enable_dbg_and_irq
> +	ct_user_exit 1
>  
>  	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
> -	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
> +	and	x16, x16, #_TIF_SYSCALL_WORK    // are we tracing syscalls?
> +	cbnz	x16, __sys_trace

...here, it doesn't get something like this:

entry.S:697: Error: immediate out of range at operand 3 -- `and x16,x16,#((1<<8)|(1<<24))'

Kevin
