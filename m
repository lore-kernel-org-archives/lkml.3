Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab3GPS6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:58:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3GPS6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:58:31 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=rTyptnn7BogA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RMKxM6tspQQA:10 a=cm27Pg_UAAAA:8 a=pGLkceISAAAA:8 a=MP1_qQ5raXxJip4QEOIA:9 a=QEXdDO2ut3YA:10 a=zv9_9hqRWm8A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374001107.6458.37.camel@gandalf.local.home>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
From: Steven Rostedt <rostedt@goodmis.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Date: Tue, 16 Jul 2013 14:58:27 -0400
In-Reply-To: <20130716183441.GA14232@www.outflux.net>
References: <20130716183441.GA14232@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 11:34 -0700, Kees Cook wrote:
> Since the IDT is referenced from a fixmap, make sure it is page aligned.
> Merge with 32-bit one, since it was already aligned to deal with F00F
> bug. Since bss is cleared before IDT setup, it can live there. This also
> moves the other *_idt_table variables into common locations.
> 
> This avoids the risk of the IDT ever being moved in the bss and having
> the mapping be offset, resulting in calling incorrect handlers. In the
> current upstream kernel this is not a manifested bug, but heavily patched
> kernels (such as those using the PaX patch series) did encounter this bug.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reported-by: PaX Team <pageexec@gmail.com>


I like it just because it removes those nasty #ifdef blocks for x86_64
or not.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
> v5:
>  - add comments to all IDTs about alignment reasoning, suggested by Linus
> v4:
>  - rework using __page_aligned_bss, suggested by Yinghai LU
>  - move all the other IDT variables as well, suggested by HPA
> v3:
>  - merge 32-bit and 64-bit idt_table definition
> v2:
>  - 32-bit was already aligned
> ---
>  arch/x86/kernel/head_64.S    |   15 ---------------
>  arch/x86/kernel/tracepoint.c |    6 ++----
>  arch/x86/kernel/traps.c      |   12 ++++++------
>  3 files changed, 8 insertions(+), 25 deletions(-)
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
> 1.7.9.5
> 
> 


