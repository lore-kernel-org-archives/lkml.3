Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaJBPqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:46:17 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40653 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJBPqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:46:16 -0400
Date: Thu, 2 Oct 2014 16:46:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 21/24] ARM64:ILP32: Use a seperate syscall table as a few
 syscalls need to be using the compat syscalls
Message-ID: <20141002154600.GG32147@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-22-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-22-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:19:15PM +0100, Andrew Pinski wrote:
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 9314352..dbedecf 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -643,9 +643,14 @@ ENDPROC(ret_from_fork)
>   */
>         .align  6
>  el0_svc:
> -       adrp    stbl, sys_call_table            // load syscall table pointer
>         uxtw    scno, w8                        // syscall number in w8
>         mov     sc_nr, #__NR_syscalls
> +#ifdef CONFIG_ARM64_ILP32
> +       get_thread_info tsk
> +       ldr     x16, [tsk, #TI_FLAGS]
> +       tbnz    x16, #TIF_32BIT, el0_ilp32_svc  // We are using ILP32
> +#endif
> +       adrp    stbl, sys_call_table            // load syscall table pointer
>  el0_svc_naked:                                 // compat entry point
>         stp     x0, scno, [sp, #S_ORIG_X0]      // save the original x0 and syscall number
>         enable_dbg_and_irq

The kernel_entry macro already sets tsk to the current thread_info, so
no need to re-read it.

You could also move the TI_FLAGS reading unconditionally in el0_svc and
el0_svc_compat and we only have a tbnz here without the subsequent
TI_FLAGS read in el0_svc_naked.

-- 
Catalin
