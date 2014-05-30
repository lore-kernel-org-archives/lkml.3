Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbaE3SYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:24:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbaE3SYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:24:14 -0400
Date: Fri, 30 May 2014 19:23:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v6 2/2] arm64: enable context tracking
Message-ID: <20140530182349.GI22895@arm.com>
References: <1401399904-24471-1-git-send-email-larry.bassel@linaro.org>
 <1401399904-24471-3-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401399904-24471-3-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:45:04PM +0100, Larry Bassel wrote:
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

Apparently I'm feeling pedantic today, one minor comment below...

> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index b0101b9..3c484e2 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -30,6 +30,32 @@
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

... I know we already changed this argument from \save, but maybe just
naming it \syscall makes most sense now?

If you make that change:

  Acked-by: Will Deacon <will.deacon@arm.com>

I'd like to give these some stress testing before it gets merged, so I'm
not sure if it'll make it for 3.16 given where we are at the moment.

Will
