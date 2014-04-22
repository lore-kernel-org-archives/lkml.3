Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaDVL0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:26:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52506 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbaDVLZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:25:55 -0400
Date: Tue, 22 Apr 2014 13:25:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <amluto@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140422112550.GC15882@pd.tnic>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
 <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just nitpicks below:

On Mon, Apr 21, 2014 at 03:47:52PM -0700, H. Peter Anvin wrote:
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

I wish we'd put this description in the code instead of in a commit
message as those can get lost in git history over time.

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
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Link: http://lkml.kernel.org/r/tip-kicdm89kzw9lldryb1br9od0@git.kernel.org
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
> Cc: Andy Lutomirski <amluto@gmail.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Arjan van de Ven <arjan.van.de.ven@intel.com>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Alexandre Julliard <julliard@winehq.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

...

> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1e96c3628bf2..7cc01770bf21 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -58,6 +58,7 @@
>  #include <asm/asm.h>
>  #include <asm/context_tracking.h>
>  #include <asm/smap.h>
> +#include <asm/pgtable_types.h>
>  #include <linux/err.h>
>  
>  /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
> @@ -1040,8 +1041,16 @@ restore_args:
>  	RESTORE_ARGS 1,8,1
>  
>  irq_return:
> +	/*
> +	 * Are we returning to the LDT?  Note: in 64-bit mode
> +	 * SS:RSP on the exception stack is always valid.
> +	 */
> +	testb $4,(SS-RIP)(%rsp)
> +	jnz irq_return_ldt
> +
> +irq_return_iret:
>  	INTERRUPT_RETURN
> -	_ASM_EXTABLE(irq_return, bad_iret)
> +	_ASM_EXTABLE(irq_return_iret, bad_iret)
>  
>  #ifdef CONFIG_PARAVIRT
>  ENTRY(native_iret)
> @@ -1049,6 +1058,34 @@ ENTRY(native_iret)
>  	_ASM_EXTABLE(native_iret, bad_iret)
>  #endif
>  
> +irq_return_ldt:
> +	pushq_cfi %rcx
> +	larl (CS-RIP+8)(%rsp), %ecx
> +	jnz 1f		/* Invalid segment - will #GP at IRET time */
> +	testl $0x00200000, %ecx
> +	jnz 1f		/* Returning to 64-bit mode */
> +	larl (SS-RIP+8)(%rsp), %ecx
> +	jnz 1f		/* Invalid segment - will #SS at IRET time */

You mean " ... will #GP at IRET time"? But you're right, you're looking
at SS :-)

> +	testl $0x00400000, %ecx
> +	jnz 1f		/* Not a 16-bit stack segment */
> +	pushq_cfi %rsi
> +	pushq_cfi %rdi
> +	SWAPGS
> +	movq PER_CPU_VAR(espfix_stack),%rdi
> +	movl (RSP-RIP+3*8)(%rsp),%esi
> +	xorw %si,%si
> +	orq %rsi,%rdi
> +	movq %rsp,%rsi
> +	movl $8,%ecx
> +	rep;movsq
> +	leaq -(8*8)(%rdi),%rsp
> +	SWAPGS
> +	popq_cfi %rdi
> +	popq_cfi %rsi
> +1:
> +	popq_cfi %rcx
> +	jmp irq_return_iret
> +
>  	.section .fixup,"ax"
>  bad_iret:
>  	/*

...

> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 85126ccbdf6b..dc2d8afcafe9 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -32,6 +32,7 @@
>   * Manage page tables very early on.
>   */
>  extern pgd_t early_level4_pgt[PTRS_PER_PGD];
> +extern pud_t espfix_pud_page[PTRS_PER_PUD];

I guess you don't need the "extern" here.

>  extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
>  static unsigned int __initdata next_early_pgt = 2;
>  pmdval_t early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
> diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
> index af1d14a9ebda..ebc987398923 100644
> --- a/arch/x86/kernel/ldt.c
> +++ b/arch/x86/kernel/ldt.c
> @@ -229,17 +229,6 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
>  		}
>  	}
>  
> -	/*
> -	 * On x86-64 we do not support 16-bit segments due to
> -	 * IRET leaking the high bits of the kernel stack address.
> -	 */
> -#ifdef CONFIG_X86_64
> -	if (!ldt_info.seg_32bit) {
> -		error = -EINVAL;
> -		goto out_unlock;
> -	}
> -#endif
> -
>  	fill_ldt(&ldt, &ldt_info);
>  	if (oldmode)
>  		ldt.avl = 0;
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 34826934d4a7..ff32efb14e33 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -244,6 +244,11 @@ static void notrace start_secondary(void *unused)
>  	check_tsc_sync_target();
>  
>  	/*
> +	 * Enable the espfix hack for this CPU
> +	 */
> +	init_espfix_cpu();
> +
> +	/*
>  	 * We need to hold vector_lock so there the set of online cpus
>  	 * does not change while we are assigning vectors to cpus.  Holding
>  	 * this lock ensures we don't half assign or remove an irq from a cpu.
> diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
> index 20621d753d5f..96bf767a05fc 100644
> --- a/arch/x86/mm/dump_pagetables.c
> +++ b/arch/x86/mm/dump_pagetables.c
> @@ -327,6 +327,8 @@ void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd)
>  	int i;
>  	struct pg_state st = {};
>  
> +	st.to_dmesg = true;

Right, remove before applying :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
