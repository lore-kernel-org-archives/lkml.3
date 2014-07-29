Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaG2DkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:40:11 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62276 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaG2DkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <tip-7209a75d2009dbf7745e2fd354abf25c3deb3ca3@git.kernel.org>
References: <7b8f1d8ef6597cb16ae004a43c56980a7de3cf94.1406129132.git.luto@amacapital.net>
 <tip-7209a75d2009dbf7745e2fd354abf25c3deb3ca3@git.kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 28 Jul 2014 20:39:43 -0700
Message-ID: <CALCETrXH2PKbNBnK5k+97_tm4ERUT__WLe_6CPn=0-ftJr+sCA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86_64/entry/xen: Do not invoke espfix64 on Xen
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 3:33 PM, tip-bot for Andy Lutomirski
<tipbot@zytor.com> wrote:
> Commit-ID:  7209a75d2009dbf7745e2fd354abf25c3deb3ca3
> Gitweb:     http://git.kernel.org/tip/7209a75d2009dbf7745e2fd354abf25c3deb3ca3
> Author:     Andy Lutomirski <luto@amacapital.net>
> AuthorDate: Wed, 23 Jul 2014 08:34:11 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 28 Jul 2014 15:25:40 -0700
>
> x86_64/entry/xen: Do not invoke espfix64 on Xen
>
> This moves the espfix64 logic into native_iret.  To make this work,
> it gets rid of the native patch for INTERRUPT_RETURN:
> INTERRUPT_RETURN on native kernels is now 'jmp native_iret'.
>
> This changes the 16-bit SS behavior on Xen from OOPSing to leaking
> some bits of the Xen hypervisor's RSP (I think).
>
> [ hpa: this is a nonzero cost on native, but probably not enough to
>   measure. Xen needs to fix this in their own code, probably doing
>   something equivalent to espfix64. ]

Any plan to either fix or remove the buggy bsp-only initialization of
espfix64 on paravirt?  It's harmless now, but IMO it's still ugly.  Or
should this wait for 3.17?

--Andy

>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Link: http://lkml.kernel.org/r/7b8f1d8ef6597cb16ae004a43c56980a7de3cf94.1406129132.git.luto@amacapital.net
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/include/asm/irqflags.h     |  2 +-
>  arch/x86/kernel/entry_64.S          | 28 ++++++++++------------------
>  arch/x86/kernel/paravirt_patch_64.c |  2 --
>  3 files changed, 11 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
> index bba3cf8..0a8b519 100644
> --- a/arch/x86/include/asm/irqflags.h
> +++ b/arch/x86/include/asm/irqflags.h
> @@ -129,7 +129,7 @@ static inline notrace unsigned long arch_local_irq_save(void)
>
>  #define PARAVIRT_ADJUST_EXCEPTION_FRAME        /*  */
>
> -#define INTERRUPT_RETURN       iretq
> +#define INTERRUPT_RETURN       jmp native_iret
>  #define USERGS_SYSRET64                                \
>         swapgs;                                 \
>         sysretq;
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b25ca96..c844f08 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -830,27 +830,24 @@ restore_args:
>         RESTORE_ARGS 1,8,1
>
>  irq_return:
> +       INTERRUPT_RETURN
> +
> +ENTRY(native_iret)
>         /*
>          * Are we returning to a stack segment from the LDT?  Note: in
>          * 64-bit mode SS:RSP on the exception stack is always valid.
>          */
>  #ifdef CONFIG_X86_ESPFIX64
>         testb $4,(SS-RIP)(%rsp)
> -       jnz irq_return_ldt
> +       jnz native_irq_return_ldt
>  #endif
>
> -irq_return_iret:
> -       INTERRUPT_RETURN
> -       _ASM_EXTABLE(irq_return_iret, bad_iret)
> -
> -#ifdef CONFIG_PARAVIRT
> -ENTRY(native_iret)
> +native_irq_return_iret:
>         iretq
> -       _ASM_EXTABLE(native_iret, bad_iret)
> -#endif
> +       _ASM_EXTABLE(native_irq_return_iret, bad_iret)
>
>  #ifdef CONFIG_X86_ESPFIX64
> -irq_return_ldt:
> +native_irq_return_ldt:
>         pushq_cfi %rax
>         pushq_cfi %rdi
>         SWAPGS
> @@ -872,7 +869,7 @@ irq_return_ldt:
>         SWAPGS
>         movq %rax,%rsp
>         popq_cfi %rax
> -       jmp irq_return_iret
> +       jmp native_irq_return_iret
>  #endif
>
>         .section .fixup,"ax"
> @@ -956,13 +953,8 @@ __do_double_fault:
>         cmpl $__KERNEL_CS,CS(%rdi)
>         jne do_double_fault
>         movq RIP(%rdi),%rax
> -       cmpq $irq_return_iret,%rax
> -#ifdef CONFIG_PARAVIRT
> -       je 1f
> -       cmpq $native_iret,%rax
> -#endif
> +       cmpq $native_irq_return_iret,%rax
>         jne do_double_fault             /* This shouldn't happen... */
> -1:
>         movq PER_CPU_VAR(kernel_stack),%rax
>         subq $(6*8-KERNEL_STACK_OFFSET),%rax    /* Reset to original stack */
>         movq %rax,RSP(%rdi)
> @@ -1428,7 +1420,7 @@ error_sti:
>   */
>  error_kernelspace:
>         incl %ebx
> -       leaq irq_return_iret(%rip),%rcx
> +       leaq native_irq_return_iret(%rip),%rcx
>         cmpq %rcx,RIP+8(%rsp)
>         je error_swapgs
>         movl %ecx,%eax  /* zero extend */
> diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
> index 3f08f34..a1da673 100644
> --- a/arch/x86/kernel/paravirt_patch_64.c
> +++ b/arch/x86/kernel/paravirt_patch_64.c
> @@ -6,7 +6,6 @@ DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
>  DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
>  DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
>  DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
> -DEF_NATIVE(pv_cpu_ops, iret, "iretq");
>  DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
>  DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
>  DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
> @@ -50,7 +49,6 @@ unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
>                 PATCH_SITE(pv_irq_ops, save_fl);
>                 PATCH_SITE(pv_irq_ops, irq_enable);
>                 PATCH_SITE(pv_irq_ops, irq_disable);
> -               PATCH_SITE(pv_cpu_ops, iret);
>                 PATCH_SITE(pv_cpu_ops, irq_enable_sysexit);
>                 PATCH_SITE(pv_cpu_ops, usergs_sysret32);
>                 PATCH_SITE(pv_cpu_ops, usergs_sysret64);



-- 
Andy Lutomirski
AMA Capital Management, LLC
