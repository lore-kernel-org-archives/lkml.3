Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196Ab3GSBaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:30:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363Ab3GSBaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:30:04 -0400
Date: Thu, 18 Jul 2013 18:30:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>, PaX Team <pageexec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86: Make sure IDT is page aligned
Message-ID: <20130719013011.GA2446@kroah.com>
References: <20130719011526.15FA46608B1@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719011526.15FA46608B1@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 01:15:26AM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7
> Commit:     4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7
> Parent:     5ff560fd48d5b3d82fa0c3aff625c9da1a301911
> Author:     Kees Cook <keescook@chromium.org>
> AuthorDate: Tue Jul 16 11:34:41 2013 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue Jul 16 15:14:48 2013 -0700
> 
>     x86: Make sure IDT is page aligned
>     
>     Since the IDT is referenced from a fixmap, make sure it is page aligned.
>     Merge with 32-bit one, since it was already aligned to deal with F00F
>     bug. Since bss is cleared before IDT setup, it can live there. This also
>     moves the other *_idt_table variables into common locations.
>     
>     This avoids the risk of the IDT ever being moved in the bss and having
>     the mapping be offset, resulting in calling incorrect handlers. In the
>     current upstream kernel this is not a manifested bug, but heavily patched
>     kernels (such as those using the PaX patch series) did encounter this bug.
>     
>     The tables other than idt_table technically do not need to be page
>     aligned, at least not at the current time, but using a common
>     declaration avoids mistakes.  On 64 bits the table is exactly one page
>     long, anyway.
>     
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>     Link: http://lkml.kernel.org/r/20130716183441.GA14232@www.outflux.net
>     Reported-by: PaX Team <pageexec@gmail.com>
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/kernel/head_64.S    |   15 ---------------
>  arch/x86/kernel/tracepoint.c |    6 ++----
>  arch/x86/kernel/traps.c      |   12 ++++++------
>  3 files changed, 8 insertions(+), 25 deletions(-)

This patch is now in Linus's tree.  Kees, did you also want this in the
-stable tree(s)?

thanks,

greg k-h


> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 5e4d8a8..e1aabdb 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -512,21 +512,6 @@ ENTRY(phys_base)
>  
>  #include "../../x86/xen/xen-head.S"
>  	
> -	.section .bss, "aw", @nobits
> -	.align L1_CACHE_BYTES
> -ENTRY(idt_table)
> -	.skip IDT_ENTRIES * 16
> -
> -	.align L1_CACHE_BYTES
> -ENTRY(debug_idt_table)
> -	.skip IDT_ENTRIES * 16
> -
> -#ifdef CONFIG_TRACING
> -	.align L1_CACHE_BYTES
> -ENTRY(trace_idt_table)
> -	.skip IDT_ENTRIES * 16
> -#endif
> -
>  	__PAGE_ALIGNED_BSS
>  NEXT_PAGE(empty_zero_page)
>  	.skip PAGE_SIZE
> diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
> index 4e584a8..1c113db 100644
> --- a/arch/x86/kernel/tracepoint.c
> +++ b/arch/x86/kernel/tracepoint.c
> @@ -12,10 +12,8 @@ atomic_t trace_idt_ctr = ATOMIC_INIT(0);
>  struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
>  				(unsigned long) trace_idt_table };
>  
> -#ifndef CONFIG_X86_64
> -gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
> -					= { { { { 0, 0 } } }, };
> -#endif
> +/* No need to be aligned, but done to keep all IDTs defined the same way. */
> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_bss;
>  
>  static int trace_irq_vector_refcount;
>  static DEFINE_MUTEX(irq_vector_mutex);
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index b0865e8..1b23a1c 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -63,19 +63,19 @@
>  #include <asm/x86_init.h>
>  #include <asm/pgalloc.h>
>  #include <asm/proto.h>
> +
> +/* No need to be aligned, but done to keep all IDTs defined the same way. */
> +gate_desc debug_idt_table[NR_VECTORS] __page_aligned_bss;
>  #else
>  #include <asm/processor-flags.h>
>  #include <asm/setup.h>
>  
>  asmlinkage int system_call(void);
> -
> -/*
> - * The IDT has to be page-aligned to simplify the Pentium
> - * F0 0F bug workaround.
> - */
> -gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
>  #endif
>  
> +/* Must be page-aligned because the real IDT is used in a fixmap. */
> +gate_desc idt_table[NR_VECTORS] __page_aligned_bss;
> +
>  DECLARE_BITMAP(used_vectors, NR_VECTORS);
>  EXPORT_SYMBOL_GPL(used_vectors);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
