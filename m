Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3LFMMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:12:33 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50996 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753262Ab3LFMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:12:31 -0500
Date: Fri, 6 Dec 2013 12:11:55 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <a.anurag@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "narendra.m1@samsung.com" <narendra.m1@samsung.com>,
        "poorva.s@samsung.com" <poorva.s@samsung.com>,
        "naveen.sel@samsung.com" <naveen.sel@samsung.com>,
        "ashish.kalra@samsung.com" <ashish.kalra@samsung.com>,
        "mohammad.a2@samsung.com" <mohammad.a2@samsung.com>,
        "rajat.suri@samsung.com" <rajat.suri@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] ARM : unwinder : Prevent data abort due to stack overflow
Message-ID: <20131206121149.GA4897@e103592.cambridge.arm.com>
References: <1386310193-6434-1-git-send-email-a.anurag@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386310193-6434-1-git-send-email-a.anurag@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 06:09:53AM +0000, Anurag Aggarwal wrote:
> While unwinding backtrace, stack overflow is possible. This stack
> overflow can sometimes lead to data abort in system if the area after
> stack is not mapped to physical memory.
> 
> To prevent this problem from happening, execute the instructions that
> can cause a data abort in separate helper functions, where a check for
> feasibility is made before reading each word from the stack.
> 
> Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>
> ---
>  arch/arm/kernel/unwind.c | 138 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 100 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index 00df012..6d854f8 100644
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
> @@ -66,9 +68,11 @@ void __aeabi_unwind_cpp_pr2(void)
>  EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
>  
>  struct unwind_ctrl_block {
> -	unsigned long vrs[16];		/* virtual register set */
> +	unsigned long vrs[TOTAL_REGISTERS];	/* virtual register set */
>  	const unsigned long *insn;	/* pointer to the current instructions word */
> +	unsigned long sp_high;		/* highest value of sp allowed*/
>  	int entries;			/* number of entries left to interpret */
> +	int last_register_set;          /* store if we are at the last set */

I find the name and comment a bit confusing here.  Also, strictly
speaking it can be a bool.

Maybe:

	/*
	 * true: check for stack overflow for each register pop;
	 * false: save overhead if there is plenty of stack remaining.
	 */
	bool check_each_pop;


It shouldn't be too hard to understand from reading the code though, so
I'm happy with your version if you prefer.
	
[...]

> @@ -382,11 +438,17 @@ int unwind_frame(struct stackframe *frame)
>  		return -URC_FAILURE;
>  	}
>  
> +	/* we are just starting, initialize last register set as 0 */
> +	ctrl.last_register_set = 0;
> +
>  	while (ctrl.entries > 0) {
> -		int urc = unwind_exec_insn(&ctrl);
> +		int urc;
> +		if ((ctrl.sp_high - ctrl.vrs[SP]) < TOTAL_REGISTERS)
> +			ctrl.last_register_set = 1;

If this is done once per unwind_exec_insn(), I think it would be better
to put the check at the start of unwind_exec_insn() instead of outside.


The check still looks wrong too?

ctrl.sp_high - ctrl.vrs[SP] gives the available space in bytes, but
TOTAL_REGISTERS is measured in words.


One way to get the correct value would be simply

	sizeof ctrl.vrs

since that's the array we're trying to fill from the stack.

(in that case I guess that the TOTAL_REGISTERS macro might not be needed
again)

Cheers
---Dave
