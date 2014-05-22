Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbaEVU3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:29:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58757 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaEVU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:29:21 -0400
Message-ID: <537E5E1F.3050605@codeaurora.org>
Date: Thu, 22 May 2014 16:29:19 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Larry Bassel <larry.bassel@linaro.org>
CC: catalin.marinas@arm.com, will.deacon@arm.com, khilman@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] arm64: enable context tracking
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org> <1400786855-32656-3-git-send-email-larry.bassel@linaro.org>
In-Reply-To: <1400786855-32656-3-git-send-email-larry.bassel@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On 05/22/2014 03:27 PM, Larry Bassel wrote:
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

> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -30,6 +30,44 @@
>  #include <asm/unistd32.h>
>  
>  /*
> + * Context tracking subsystem.  Used to instrument transitions
> + * between user and kernel mode.
> + */
> +	.macro ct_user_exit, restore = 0
> +#ifdef CONFIG_CONTEXT_TRACKING
> +	bl	context_tracking_user_exit
> +	.if \restore == 1
> +	/*
> +	 * Save/restore needed during syscalls.  Restore syscall arguments from
> +	 * the values already saved on stack during kernel_entry.
> +	 */
> +	ldp	x0, x1, [sp]
> +	ldp	x2, x3, [sp, #S_X2]
> +	ldp	x4, x5, [sp, #S_X4]
> +	ldp	x6, x7, [sp, #S_X6]
> +	.endif
> +#endif
> +	.endm
> +
> +	.macro ct_user_enter, save = 0
> +#ifdef CONFIG_CONTEXT_TRACKING
> +	.if \save == 1
> +	/*
> +	 * Save/restore only needed on syscall fastpath, which uses
> +	 * x0-x2.
> +	 */
> +	push    x2, x3

Why is x3 saved?

> +	push    x0, x1
> +	.endif
> +	bl	context_tracking_user_enter
> +	.if \save == 1
> +	pop     x0, x1
> +	pop     x2, x3
> +	.endif
> +#endif
> +	.endm

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
