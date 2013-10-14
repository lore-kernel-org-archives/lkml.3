Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3JNPYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:24:45 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54563 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756759Ab3JNPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:24:44 -0400
Date: Mon, 14 Oct 2013 16:23:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 2/4] arm64: restore FPSIMD to default state for
 kernel and signal contexts
Message-ID: <20131014152345.GF7682@arm.com>
References: <1381674029-430-1-git-send-email-liuj97@gmail.com>
 <1381674029-430-2-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381674029-430-2-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 03:20:18PM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Restore FPSIMD control and status registers to default values
> when creating new FPSIMD contexts for kernel context and reset
> FPSIMD status register when creating FPSIMD context for signal
> handling, otherwise the stale value in FPSIMD control and status
> registers may affect the new kernal or signal handling contexts.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/fpsimd.h | 16 ++++++++++++++++
>  arch/arm64/kernel/fpsimd.c      | 11 +++++++++--
>  arch/arm64/kernel/signal.c      |  1 +
>  arch/arm64/kernel/signal32.c    |  1 +
>  4 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index c43b4ac..b2dc30f 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -50,8 +50,24 @@ struct fpsimd_state {
>  #define VFP_STATE_SIZE		((32 * 8) + 4)
>  #endif
>  
> +#define	AARCH64_FPCR_DEFAULT_VAL	0
> +
>  struct task_struct;
>  
> +static inline void fpsimd_init_hw_state(void)
> +{
> +	int val = AARCH64_FPCR_DEFAULT_VAL;
> +
> +	asm ("msr fpcr, %x0\n"
> +	     "msr fpsr, xzr\n"
> +             : : "r"(val));
> +}

These could go in the fpsimd.c file, they are not used outside it.

> +
> +static inline void fpsimd_clear_fpsr(void)
> +{
> +	asm ("msr fpsr, xzr\n");
> +}
> +
>  extern void fpsimd_save_state(struct fpsimd_state *state);
>  extern void fpsimd_load_state(struct fpsimd_state *state);
>  
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

Better to write as:

	if (AARCH64_FPCR_DEFAULT_VAL)
		state->fpcr = AARCH64_FPCR_DEFAULT_VAL;

The compiler should optimise it out.

> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 890a591..4ee231e 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -52,6 +52,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
>  
>  	/* dump the hardware registers to the fpsimd_state structure */
>  	fpsimd_save_state(fpsimd);
> +	fpsimd_clear_fpsr();

That's the wrong place for such call. This function is supposed to save
the existing FP context and not modify it. Ideally we should do this as
with the other registers, just restoring them when returning to user.
But I wouldn't add fpsr to pt_regs, so somewhere like handle_signal()
should be OK.

-- 
Catalin
