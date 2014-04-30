Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbaD3Kic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:38:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51254 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371AbaD3Ki2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:38:28 -0400
Date: Wed, 30 Apr 2014 12:38:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lutomriski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] x86-64, espfix: Don't leak bits 31:16 of %esp returning
 to 16-bit stack
Message-ID: <20140430103822.GD23736@pd.tnic>
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:15:46PM -0700, H. Peter Anvin wrote:
> This is intended as a final RFC for testing and flames^Wcomments
> before I add this to -tip.
> 
> Linus, this is technically a (functionality) regression fix.  Will you
> want this for 3.15?
> 
> ---------->8--------
> 
> The IRET instruction, when returning to a 16-bit segment, only
> restores the bottom 16 bits of the user space stack pointer.  This
> causes some 16-bit software to break, but it also leaks kernel state
> to user space.  We have a software workaround for that ("espfix") for
> the 32-bit kernel, but it relies on a nonzero stack segment base which
> is not available in 32-bit mode.

s/32-bit/64-bit/

> 
> In checkin:
> 
>     b3b42ac2cbae x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
> 
> we "solved" this by forbidding 16-bit segments on 64-bit kernels, with
> the logic that 16-bit support is crippled on 64-bit kernels anyway (no
> V86 support), but it turns out that people are doing stuff like
> running old Win16 binaries under Wine and expect it to work.
> 
> This works around this by creating percpu "ministacks", each of which
> is mapped 2^16 times 64K apart.  When we detect that the return SS is
> on the LDT, we copy the IRET frame to the ministack and use the
> relevant alias to return to userspace.  The ministacks are mapped
> readonly, so if the IRET fault we promote #GP to #DF which is an IST

"... so if IRET faults... "

> vector and thus has its own stack; we then do the fixup in the #DF
> handler.
> 
> (Making #GP an IST exception would make the msr_safe functions unsafe
> in NMI/MC context, and quite possibly have other effects.)
> 
> Special thanks to:
> 
> - Andy Lutomirski, for the suggestion of using very small stack slots
>   and copy (as opposed to map) the IRET frame there, and for the
>   suggestion to mark them readonly and let the fault promote to #DF.
> - Konrad Wilk for paravirt fixup and testing.
> - Borislav Petkov for testing help and useful comments.
> 
> This is technically a fix for a functionality regression.
> 
> Reported-by: Brian Gerst <brgerst@gmail.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Andrew Lutomriski <amluto@gmail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Dirk Hohndel <dirk@hohndel.org>
> Cc: Arjan van de Ven <arjan.van.de.ven@intel.com>
> Cc: comex <comexk@gmail.com>
> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---

...

> @@ -1110,9 +1143,41 @@ ENTRY(retint_kernel)
>  	call preempt_schedule_irq
>  	jmp exit_intr
>  #endif
> -
>  	CFI_ENDPROC
>  END(common_interrupt)
> +
> +	/*
> +	 * If IRET takes a fault on the espfix stack, then we
> +	 * end up promoting it to a doublefault.  In that case,
> +	 * modify the stack to make it look like we just entered
> +	 * the #GP handler from user space, similar to bad_iret.
> +	 */
> +	ALIGN
> +__do_double_fault:
> +	XCPT_FRAME 1 RDI+8
> +	movq RSP(%rdi),%rax		/* Trap on the espfix stack? */
> +	sarq $PGDIR_SHIFT,%rax
> +	cmpl $ESPFIX_PGD_ENTRY,%eax
> +	jne do_double_fault		/* No, just deliver the fault */
> +	cmpl $__KERNEL_CS,CS(%rdi)

What will happen more likely and thus more often - our "simulated" #DF
or a real one? Judging by the order of the tests, you're saying: the
simulated one. :-)

Otherwise, push the __KERNEL_CS test up?

> +	jne do_double_fault
> +	movq RIP(%rdi),%rax
> +	cmpq $irq_return_iret,%rax
> +#ifdef CONFIG_PARAVIRT
> +	je 1f
> +	cmpq $native_iret,%rax
> +#endif
> +	jne do_double_fault		/* This shouldn't happen... */
> +1:
> +	movq PER_CPU_VAR(kernel_stack),%rax
> +	subq $(6*8-KERNEL_STACK_OFFSET),%rax	/* Reset to original stack */
> +	movq %rax,RSP(%rdi)
> +	movq $0,(%rax)			/* Missing (lost) #GP error code */
> +	movq $general_protection,RIP(%rdi)
> +	retq
> +	CFI_ENDPROC
> +END(__do_double_fault)
> +
>  /*
>   * End of kprobes section
>   */

...

> diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
> new file mode 100644
> index 000000000000..b1b5ae21a73e
> --- /dev/null
> +++ b/arch/x86/kernel/espfix_64.c
> @@ -0,0 +1,203 @@
> +/* ----------------------------------------------------------------------- *
> + *
> + *   Copyright 2014 Intel Corporation; author: H. Peter Anvin
> + *
> + *   This file is part of the Linux kernel, and is made available under
> + *   the terms of the GNU General Public License version 2 or (at your
> + *   option) any later version; incorporated herein by reference.
> + *
> + * ----------------------------------------------------------------------- */

Yah, this is how big a licensing boilerplate should be! Maybe other
companies would look at this here and learn.

> +
> +/*
> + * The IRET instruction, when returning to a 16-bit segment, only
> + * restores the bottom 16 bits of the user space stack pointer.  This
> + * causes some 16-bit software to break, but it also leaks kernel state
> + * to user space.
> + *
> + * This works around this by creating percpu "ministacks", each of which
> + * is mapped 2^16 times 64K apart.  When we detect that the return SS is
> + * on the LDT, we copy the IRET frame to the ministack and use the
> + * relevant alias to return to userspace.  The ministacks are mapped
> + * readonly, so if the IRET fault we promote #GP to #DF which is an IST

"... so if IRET faults... "

> + * vector and thus has its own stack; we then do the fixup in the #DF
> + * handler.
> + *
> + * This file sets up the ministacks and the related page tables.  The
> + * actual ministack invocation is in entry_64.S.
> + */

Yep, this is how you write an explanation of the issue!

...

> @@ -208,17 +213,24 @@ static void note_page(struct seq_file *m, struct pg_state *st,
>  		/*
>  		 * Now print the actual finished series
>  		 */
> -		pt_dump_seq_printf(m, st->to_dmesg,  "0x%0*lx-0x%0*lx   ",
> -				   width, st->start_address,
> -				   width, st->current_address);
> -
> -		delta = (st->current_address - st->start_address) >> 10;
> -		while (!(delta & 1023) && unit[1]) {
> -			delta >>= 10;
> -			unit++;
> +		if (!st->marker->max_lines ||
> +		    st->lines < st->marker->max_lines) {
> +			pt_dump_seq_printf(m, st->to_dmesg, 
> +					   "0x%0*lx-0x%0*lx   ",
> +					   width, st->start_address,
> +					   width, st->current_address);
> +
> +			delta = st->current_address - st->start_address;
> +			while (!(delta & 1023) && unit[1]) {
> +				delta >>= 10;
> +				unit++;
> +			}
> +			pt_dump_cont_printf(m, st->to_dmesg, "%9lu%c ",
> +					    delta, *unit);
> +			printk_prot(m, st->current_prot, st->level,
> +				    st->to_dmesg);
>  		}
> -		pt_dump_cont_printf(m, st->to_dmesg, "%9lu%c ", delta, *unit);
> -		printk_prot(m, st->current_prot, st->level, st->to_dmesg);
> +		st->lines++;
>  
>  		/*
>  		 * We print markers for special areas of address space,
> @@ -226,7 +238,17 @@ static void note_page(struct seq_file *m, struct pg_state *st,
>  		 * This helps in the interpretation.
>  		 */
>  		if (st->current_address >= st->marker[1].start_address) {
> +			if (st->marker->max_lines &&
> +			    st->lines > st->marker->max_lines) {
> +				unsigned long nskip =
> +					st->lines - st->marker->max_lines;
> +				pt_dump_seq_printf(m, st->to_dmesg,
> +						   "... %lu entr%s skipped ... \n",
> +						   nskip,
> +						   nskip == 1 ? "y" : "ies");
> +			}
>  			st->marker++;
> +			st->lines = 0;
>  			pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
>  					   st->marker->name);

Nice:

---[ ESPfix Area ]---
0xffffff0000000000-0xffffff1100000000          68G                           pud
0xffffff1100000000-0xffffff110000d000          52K                           pte
0xffffff110000d000-0xffffff110000e000           4K     ro             GLB NX pte
0xffffff110000e000-0xffffff110001d000          60K                           pte
0xffffff110001d000-0xffffff110001e000           4K     ro             GLB NX pte
0xffffff110001e000-0xffffff110002d000          60K                           pte
0xffffff110002d000-0xffffff110002e000           4K     ro             GLB NX pte
0xffffff110002e000-0xffffff110003d000          60K                           pte
0xffffff110003d000-0xffffff110003e000           4K     ro             GLB NX pte
0xffffff110003e000-0xffffff110004d000          60K                           pte
0xffffff110004d000-0xffffff110004e000           4K     ro             GLB NX pte
0xffffff110004e000-0xffffff110005d000          60K                           pte
0xffffff110005d000-0xffffff110005e000           4K     ro             GLB NX pte
0xffffff110005e000-0xffffff110006d000          60K                           pte
0xffffff110006d000-0xffffff110006e000           4K     ro             GLB NX pte
0xffffff110006e000-0xffffff110007d000          60K                           pte
... 131059 entries skipped ...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
