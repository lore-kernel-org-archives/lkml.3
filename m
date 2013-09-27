Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3I0Lfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 07:35:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45097 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab3I0Lf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 07:35:26 -0400
Date: Fri, 27 Sep 2013 12:35:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v1 2/7] arm64: restore FPSIMD to default state for
 kernel and signal contexts
Message-ID: <20130927113507.GC11063@MacBook-Pro.local>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
 <1380269087-8520-3-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380269087-8520-3-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 09:04:42AM +0100, Jiang Liu wrote:
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index bb785d2..12a25e5 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -80,9 +80,14 @@ void fpsimd_thread_switch(struct task_struct *next)
>  
>  void fpsimd_flush_thread(void)
>  {
> +	struct fpsimd_state *state = &current->thread.fpsimd_state;
> +
>  	preempt_disable();
> -	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
> -	fpsimd_load_state(&current->thread.fpsimd_state);
> +	memset(state, 0, sizeof(struct fpsimd_state));
> +#if (AARCH64_FPCR_DEFAULT_VAL != 0)
> +	state->fpcr = AARCH64_FPCR_DEFAULT_VAL;
> +#endif
> +	fpsimd_load_state(state);
>  	preempt_enable();

We can leave this to 0 as the default for user. Glibc already programs
this register.

>  }
>  
> @@ -99,6 +104,8 @@ void kernel_neon_begin(void)
>  
>  	if (current->mm)
>  		fpsimd_save_state(&current->thread.fpsimd_state);
> +
> +	fpsimd_init_hw_state();

This function should indeed do some initialisation rather than relying
on whatever the user set for FPCR.

> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 890a591..6d80612 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -52,6 +52,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
>  
>  	/* dump the hardware registers to the fpsimd_state structure */
>  	fpsimd_save_state(fpsimd);
> +	fpsimd_init_hw_state();

Here I think we need to leave the default user setting for fpcr as
decided by glibc (or libgcc) when an application starts.

>  	/* copy the FP and status/control registers */
>  	err = __copy_to_user(ctx->vregs, fpsimd->vregs, sizeof(fpsimd->vregs));
> diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
> index e393174..cb2cb41 100644
> --- a/arch/arm64/kernel/signal32.c
> +++ b/arch/arm64/kernel/signal32.c
> @@ -248,6 +248,7 @@ static int compat_preserve_vfp_context(struct compat_vfp_sigframe __user *frame)
>  	 * in AArch32.
>  	 */
>  	fpsimd_save_state(fpsimd);
> +	fpsimd_init_hw_state();

Same here.

-- 
Catalin
