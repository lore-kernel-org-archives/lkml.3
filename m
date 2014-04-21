Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaDUXTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 19:19:24 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:53295 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaDUXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 19:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Mon, 21 Apr 2014 16:19:01 -0700
Message-ID: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 3:47 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> This is a prototype of espfix for the 64-bit kernel.  espfix is a
> workaround for the architectural definition of IRET, which fails to
> restore bits [31:16] of %esp when returning to a 16-bit stack
> segment.  We have a workaround for the 32-bit kernel, but that
> implementation doesn't work for 64 bits.
>
> The 64-bit implementation works like this:
>
> Set up a ministack for each CPU, which is then mapped 65536 times
> using the page tables.  This implementation uses the second-to-last
> PGD slot for this; with a 64-byte espfix stack this is sufficient for
> 2^18 CPUs (currently we support a max of 2^13 CPUs.)
>
> 64 bytes appear to be sufficient, because NMI and #MC cause a task
> switch.
>
> THIS IS A PROTOTYPE AND IS NOT COMPLETE.  We need to make sure all
> code paths that can interrupt userspace execute this code.
> Fortunately we never need to use the espfix stack for nested faults,
> so one per CPU is guaranteed to be safe.
>
> Furthermore, this code adds unnecessary instructions to the common
> path.  For example, on exception entry we push %rdi, pop %rdi, and
> then save away %rdi.  Ideally we should do this in such a way that we
> avoid unnecessary swapgs, especially on the IRET path (the exception
> path is going to be very rare, and so is less critical.)
>
> Putting this version out there for people to look at/laugh at/play
> with.

Hahaha! :)

Some comments:

Does returning to 64-bit CS with 16-bit SS not need espfix?
Conversely, does 16-bit CS and 32-bit SS need espfix?


> @@ -1058,6 +1095,7 @@ bad_iret:
>          * So pretend we completed the iret and took the #GPF in user mode.
>          *
>          * We are now running with the kernel GS after exception recovery.
> +        * Exception entry will have removed us from the espfix stack.
>          * But error_entry expects us to have user GS to match the user %cs,
>          * so swap back.
>          */

What is that referring to?


> +       /*
> +        * Switch from the espfix stack to the proper stack: tricky stuff.
> +        * On the stack right now is 5 words of exception frame,
> +        * error code/oldeax, RDI, and the return value, so no additional
> +        * stack is available.
> +        *
> +        * We will always be using the user space GS on entry.
> +       */
> +ENTRY(espfix_fix_stack)
> +       SWAPGS
> +       cld
> +       movq PER_CPU_VAR(kernel_stack),%rdi
> +       subq $8*8,%rdi
> +       /* Use the real stack to hold these registers for now */
> +       movq %rsi,-8(%rdi)
> +       movq %rcx,-16(%rdi)
> +       movq %rsp,%rsi
> +       movl $8,%ecx
> +       rep;movsq
> +       leaq -(10*8)(%rdi),%rsp
> +       popq %rcx
> +       popq %rsi
> +       SWAPGS
> +       retq
>

Is it guaranteed that the userspace thread that caused this is dead?
If not, do you need to change RIP so that espfix gets invoked again
when you return from the exception?

> +
> +void init_espfix_cpu(void)
> +{
> +       int cpu = smp_processor_id();
> +       unsigned long addr;
> +       pgd_t pgd, *pgd_p;
> +       pud_t pud, *pud_p;
> +       pmd_t pmd, *pmd_p;
> +       pte_t pte, *pte_p;
> +       int n;
> +       void *stack_page;
> +
> +       cpu = smp_processor_id();
> +       BUG_ON(cpu >= (8 << 20)/ESPFIX_STACK_SIZE);
> +
> +       /* We only have to do this once... */
> +       if (likely(this_cpu_read(espfix_stack)))
> +               return;         /* Already initialized */
> +
> +       addr = espfix_base_addr(cpu);
> +
> +       /* Did another CPU already set this up? */
> +       if (likely(espfix_already_there(addr)))
> +               goto done;
> +
> +       mutex_lock(&espfix_init_mutex);
> +
> +       if (unlikely(espfix_already_there(addr)))
> +               goto unlock_done;

Wouldn't it be simpler to just have a single static bool to indicate
whether espfix is initialized?

Even better: why not separate the percpu init from the pagetable init
and just do the pagetable init once from main or even modify_ldt?

--Andy
