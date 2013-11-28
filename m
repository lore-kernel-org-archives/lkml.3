Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3K1U0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:26:11 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54125 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045Ab3K1U0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 15:26:08 -0500
Date: Thu, 28 Nov 2013 20:24:53 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <a.anurag@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, naveen.sel@samsung.com,
        linux@arm.linux.org.uk, mohammad.a2@samsung.com, nico@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, ashish.kalra@samsung.com,
        cpgs@samsung.com, anurag19aggarwal@gmail.com,
        naveenkrishna.ch@gmail.com, rajat.suri@samsung.com,
        poorva.s@samsung.com, narendra.m1@samsung.com
Subject: Re: [PATCH] ARM : unwinder : Prevent data abort due to stack
 overflow in unwind_exec_insn Signed-off-by: Anurag Aggarwal
 <a.anurag@samsung.com>
Message-ID: <20131128202453.GE4634@e103592.cambridge.arm.com>
References: <1385634439-24554-1-git-send-email-a.anurag@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385634439-24554-1-git-send-email-a.anurag@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:57:19PM +0530, Anurag Aggarwal wrote:
> While executing some unwind instructions stack overflow can cause a data abort
> when area beyond stack is not mapped to physical memory.
> 
> To prevent the data abort check whether it is possible to execute
> these instructions before unwinding the stack
> ---
>  arch/arm/kernel/unwind.c |   59 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 58 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index 00df012..3777cd7 100644
> --- a/arch/arm/kernel/unwind.c
> +++ b/arch/arm/kernel/unwind.c
> @@ -49,6 +49,8 @@
>  #include <asm/traps.h>
>  #include <asm/unwind.h>
>  
> +#define TOTAL_REGISTERS 16
> +
>  /* Dummy functions to avoid linker complaints */
>  void __aeabi_unwind_cpp_pr0(void)
>  {
> @@ -66,7 +68,7 @@ void __aeabi_unwind_cpp_pr2(void)
>  EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
>  
>  struct unwind_ctrl_block {
> -	unsigned long vrs[16];		/* virtual register set */
> +	unsigned long vrs[TOTAL_REGISTERS];	/* virtual register set */
>  	const unsigned long *insn;	/* pointer to the current instructions word */
>  	int entries;			/* number of entries left to interpret */
>  	int byte;			/* current byte number in the instructions word */
> @@ -235,6 +237,58 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
>  	return ret;
>  }
>  
> +/* check whether there is enough space on stack to execute instructions
> +   that can cause a data abort*/

Nit: strange comment formatting in all your multi-line comments.

/*
 * Please format multi-line comments
 * like this.
 */

> +static int unwind_check_insn(struct unwind_ctrl_block *ctrl, unsigned long insn)
> +{

I really think this shouldn't be separated out in this way, because it
means the decoder has to be implemented twice, and moving the checks far
away from the code that the checks need to match.

Maybe you could refactor the code so that each insn has its own function,
including the check and the execution.

Then

> +	unsigned long high, low;
> +	int required_stack = 0;
> +
> +	low = ctrl->vrs[SP];
> +	high = ALIGN(low, THREAD_SIZE);
> +
> +	/* check whether we have enough space to extract
> +	atleast one set of registers*/
> +	if ((high - low) > TOTAL_REGISTERS)
> +		return URC_OK;

Although this appears safe, I wonder whether it just creates additional
ways for the code to be wrong, without providing much optimisation.

(For example, the maximum number of registers that can be read is
not actually TOTAL_REGISTERS.)

Cheers
---Dave

> +
> +	if ((insn & 0xf0) == 0x80) {
> +		unsigned long mask;
> +		insn = (insn << 8) | unwind_get_byte(ctrl);
> +		mask = insn & 0x0fff;
> +		if (mask == 0) {
> +			pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
> +				insn);
> +			return -URC_FAILURE;
> +		}
> +		while (mask) {
> +			if (mask & 1)
> +				required_stack++;
> +			mask >>= 1;
> +		}
> +	} else if ((insn & 0xf0) == 0xa0) {
> +		required_stack += insn & 7;
> +		required_stack +=  (insn & 0x80) ? 1 : 0;
> +	} else if (insn == 0xb1) {
> +		unsigned long mask = unwind_get_byte(ctrl);
> +		if (mask == 0 || mask & 0xf0) {
> +			pr_warning("unwind: Spare encoding %04lx\n",
> +				(insn << 8) | mask);
> +			return -URC_FAILURE;
> +		}
> +		while (mask) {
> +			if (mask & 1)
> +				required_stack++;
> +			mask >>= 1;
> +		}
> +	}
> +
> +	if ((high - low) < required_stack)
> +		return -URC_FAILURE;
> +
> +	return URC_OK;
> +}
> +
>  /*
>   * Execute the current unwind instruction.
>   */
> @@ -244,6 +298,9 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>  
>  	pr_debug("%s: insn = %08lx\n", __func__, insn);
>  
> +	if (unwind_check_insn(ctrl, insn) < 0)
> +		return -URC_FAILURE;
> +
>  	if ((insn & 0xc0) == 0x00)
>  		ctrl->vrs[SP] += ((insn & 0x3f) << 2) + 4;
>  	else if ((insn & 0xc0) == 0x40)
> -- 
> 1.7.0.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
