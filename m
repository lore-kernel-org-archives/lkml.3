Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3K2NBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:01:51 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52330 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751440Ab3K2NBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:01:50 -0500
Date: Fri, 29 Nov 2013 12:59:53 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <a.anurag@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "naveen.sel@samsung.com" <naveen.sel@samsung.com>,
        "ashish.kalra@samsung.com" <ashish.kalra@samsung.com>,
        "narendra.m1@samsung.com" <narendra.m1@samsung.com>,
        "poorva.s@samsung.com" <poorva.s@samsung.com>,
        "mohammad.a2@samsung.com" <mohammad.a2@samsung.com>,
        "rajat.suri@samsung.com" <rajat.suri@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH V2] ARM : unwinder : Prevent data abort due to stack
 overflow while executing unwind instructions Signed-off-by: Anurag Aggarwal
 <a.anurag@samsung.com>
Message-ID: <20131129125953.GG4634@e103592.cambridge.arm.com>
References: <1385717671-28953-1-git-send-email-a.anurag@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385717671-28953-1-git-send-email-a.anurag@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like you still need to move your S-o-B line.  It needs to be at
the end of the commit message.

On Fri, Nov 29, 2013 at 09:34:31AM +0000, Anurag Aggarwal wrote:
> While unwinding backtrace, stack overflow is possible. This stack overflow can sometimes
> lead to data abort in system if the area after stack is not mapped to physical memory.
> 
> To prevent this problem from happening execute the instructions that can cause data
> abort in there seperate functions instead of unwind_exec_insn, where a check for there
> feasibility is made first.

Minor nit, but please wrap the commit message lines to 72 chars or less.
This helps the patch message to be listed nicely in git log.


If you agree with the changes I suggest below, the second paragraph
could be reworded something like:

--snip--

To prevent this problem from happening, execute the instructions that
can cause a data abort in separate helper functions, where a check for
feasibility is made before reading each word from the stack.

--snip--


> ---
>  arch/arm/kernel/unwind.c |  197 ++++++++++++++++++++++++++++++++++------------
>  1 files changed, 148 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index 00df012..150e0fc 100644
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
> @@ -235,6 +237,148 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
>  	return ret;
>  }
>  
> +static int unwind_exec_insn_0x80(struct unwind_ctrl_block *ctrl,
> +				unsigned long insn)

Since these are now split out as named functions, it's useful to have
human readable names.

Maybe something like:

        unwind_exec_pop_subset_r4_to_r13

What do you think?

> +{
> +	unsigned long high, low;
> +	unsigned long mask;
> +	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> +	int load_sp, reg = 4;
> +
> +	low = ctrl->vrs[SP];
> +	high = ALIGN(low, THREAD_SIZE);

You can calculate low, high and high - low once and store them in
unwind_ctrl_block.  No need to recalculate them every time.

Field names like "low" may be confusing though.  "sp_low" etc. may be
clearer.

> +
> +	insn = (insn << 8) | unwind_get_byte(ctrl);
> +	mask = insn & 0x0fff;
> +	if (mask == 0) {
> +		pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
> +			insn);
> +		return -URC_FAILURE;
> +	}
> +
> +	/*
> +	 *  Check whether there is enough space
> +	 *  on stack to execute the instruction
> +	 *  if not then return failure
> +	 */
> +	if ((high - low) < TOTAL_REGISTERS) {

I'm still not sure we are optimising something valuable by factoring out
this check.

It's also unfortunate that the code describes how many registers to pop
twice -- once in the check, and once in the while loop that does the
popping.  That kind of duplication brings risks of accidentally breaking
the code during future maintenance.  Someone might not modify the two
pieces of code in a consistent way.  Because stack overflow should never
normally occur anyway, a mistake like that could easily get missed
during testing.

Removing this whole if block and just doing a simple check each time a
register is loaded...


> +		unsigned long mask_copy = mask;
> +		int required_stack = 0;
> +
> +		while (mask_copy) {
> +			if (mask_copy & 1)
> +				required_stack++;
> +			mask_copy >>= 1;
> +		}
> +
> +		if ((high - low) < required_stack)
> +			return -URC_FAILURE;
> +	}
> +
> +	load_sp = mask & (1 << (13 - 4));
> +	while (mask) {
> +		if (mask & 1)
> +			ctrl->vrs[reg] = *vsp++;

... like this ...

	if (mask & 1) {
		if (vsp >= high)
			return -URC_FAILURE;

		ctrl->vrs[reg] = *vsp++;

... feels simpler.

Better though, that can be factored out as a separate function:

static int unwind_pop_reg(struct unwind_ctrl_block *ctrl, unsigned long **vsp,
			  unsigned int reg)
{
	if (*vsp >= ctrl->high)
		return -URC_FAILURE;

	ctrl->vrs[reg] = *(*vsp)++;
}

Then, in the insn helper, just do:

	if (mask & 1) {
		if (unwind_pop_reg(ctrl, &vsp, reg))
			return -URC_FAILURE;


And you can reuse that in each of the insn helpers.

This is likely to be a bit less efficient, but I think it will reduce
the amount of code and make things a bit cleaner.

> +		mask >>= 1;
> +		reg++;
> +	}
> +	if (!load_sp)
> +		ctrl->vrs[SP] = (unsigned long)vsp;
> +
> +	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
> +		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
> +
> +	return URC_OK;
> +}
> +
> +static int unwind_exec_insn_0xa0(struct unwind_ctrl_block *ctrl,

Maybe call this unwind_exec_pop_r4_to_rN?

> +				unsigned long insn)
> +{
> +	unsigned long high, low;
> +	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> +	int reg;
> +
> +	low = ctrl->vrs[SP];
> +	high = ALIGN(low, THREAD_SIZE);
> +
> +	/*
> +	 *  Check whether there is enough space
> +	 *  on stack to execute the instruction
> +	 *  if not then return failure
> +	 */
> +	if ((high-low) < TOTAL_REGISTERS) {
> +		int required_stack;
> +
> +		required_stack = insn & 7;
> +		required_stack += (insn & 0x80) ? 1 : 0;
> +
> +		if ((high-low) < required_stack)
> +			return -URC_FAILURE;
> +	}
> +
> +	/* pop R4-R[4+bbb] */
> +	for (reg = 4; reg <= 4 + (insn & 7); reg++)
> +		ctrl->vrs[reg] = *vsp++;
> +	if (insn & 0x80)
> +		ctrl->vrs[14] = *vsp++;
> +	ctrl->vrs[SP] = (unsigned long)vsp;
> +
> +	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
> +		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
> +
> +	return URC_OK;
> +}
> +
> +static int unwind_exec_insn_0xb1(struct unwind_ctrl_block *ctrl,

Maybe call this unwind_exec_pop_subset_r0_to_r3?

> +				unsigned long insn)
> +{
> +	unsigned long high, low;
> +	unsigned long mask = unwind_get_byte(ctrl);
> +	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> +	int reg = 0;
> +
> +	if (mask == 0 || mask & 0xf0) {
> +		pr_warning("unwind: Spare encoding %04lx\n",
> +			(insn << 8) | mask);
> +		return -URC_FAILURE;
> +	}
> +
> +	low = ctrl->vrs[SP];
> +	high = ALIGN(low, THREAD_SIZE);
> +
> +	/*
> +	 *  Check whether there is enough space
> +	 *  on stack to execute the instruction
> +	 *  if not then return failure
> +	 */
> +	if ((high-low) < TOTAL_REGISTERS) {
> +		unsigned long mask_copy = mask;
> +		int required_stack = 0;
> +
> +		while (mask_copy) {
> +			if (mask_copy & 1)
> +				required_stack++;
> +			mask_copy >>= 1;
> +		}
> +		if ((high-low) < required_stack)
> +			return -URC_FAILURE;
> +	}
> +
> +	/* pop R0-R3 according to mask */
> +	while (mask) {
> +		if (mask & 1)
> +			ctrl->vrs[reg] = *vsp++;
> +		mask >>= 1;
> +		reg++;
> +	}
> +	ctrl->vrs[SP] = (unsigned long)vsp;
> +
> +	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
> +		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
> +
> +	return URC_OK;
> +}
> +
>  /*
>   * Execute the current unwind instruction.
>   */
> @@ -249,65 +393,20 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>  	else if ((insn & 0xc0) == 0x40)
>  		ctrl->vrs[SP] -= ((insn & 0x3f) << 2) + 4;
>  	else if ((insn & 0xf0) == 0x80) {
> -		unsigned long mask;
> -		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> -		int load_sp, reg = 4;
> -
> -		insn = (insn << 8) | unwind_get_byte(ctrl);
> -		mask = insn & 0x0fff;
> -		if (mask == 0) {
> -			pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
> -				   insn);
> -			return -URC_FAILURE;
> -		}
> -
> -		/* pop R4-R15 according to mask */
> -		load_sp = mask & (1 << (13 - 4));
> -		while (mask) {
> -			if (mask & 1)
> -				ctrl->vrs[reg] = *vsp++;
> -			mask >>= 1;
> -			reg++;
> -		}
> -		if (!load_sp)
> -			ctrl->vrs[SP] = (unsigned long)vsp;
> +		return unwind_exec_insn_0x80(ctrl, insn);
>  	} else if ((insn & 0xf0) == 0x90 &&
>  		   (insn & 0x0d) != 0x0d)
>  		ctrl->vrs[SP] = ctrl->vrs[insn & 0x0f];
>  	else if ((insn & 0xf0) == 0xa0) {
> -		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> -		int reg;
> -
> -		/* pop R4-R[4+bbb] */
> -		for (reg = 4; reg <= 4 + (insn & 7); reg++)
> -			ctrl->vrs[reg] = *vsp++;
> -		if (insn & 0x80)
> -			ctrl->vrs[14] = *vsp++;
> -		ctrl->vrs[SP] = (unsigned long)vsp;
> +		 return unwind_exec_insn_0xa0(ctrl, insn);

There's an extra space before "return", here.

>  	} else if (insn == 0xb0) {
>  		if (ctrl->vrs[PC] == 0)
>  			ctrl->vrs[PC] = ctrl->vrs[LR];
>  		/* no further processing */
>  		ctrl->entries = 0;
>  	} else if (insn == 0xb1) {
> -		unsigned long mask = unwind_get_byte(ctrl);
> -		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> -		int reg = 0;
>  
> -		if (mask == 0 || mask & 0xf0) {
> -			pr_warning("unwind: Spare encoding %04lx\n",
> -			       (insn << 8) | mask);
> -			return -URC_FAILURE;
> -		}
> -
> -		/* pop R0-R3 according to mask */
> -		while (mask) {
> -			if (mask & 1)
> -				ctrl->vrs[reg] = *vsp++;
> -			mask >>= 1;
> -			reg++;
> -		}
> -		ctrl->vrs[SP] = (unsigned long)vsp;
> +		 return unwind_exec_insn_0xb1(ctrl, insn);

And here.

>  	} else if (insn == 0xb2) {
>  		unsigned long uleb128 = unwind_get_byte(ctrl);
>  
> -- 
> 1.7.0.4
> 
> 
