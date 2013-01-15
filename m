Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3AONsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:48:52 -0500
Received: from smtp.citrix.com ([66.165.176.89]:55519 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066Ab3AONss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:48:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355097600"; 
   d="scan'208";a="3788770"
Date: Tue, 15 Jan 2013 13:48:45 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v7u1 10/31] x86, 64bit: Don't set max_pfn_mapped wrong
 value early on native path
In-Reply-To: <1357260531-11115-11-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1301151242000.4978@kaball.uk.xensource.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-11-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2013, Yinghai Lu wrote:
> We are not having max_pfn_mapped set correctly until init_memory_mapping.
> 
> so don't print it initial value for 64bit
> 
> Also need to use KERNEL_IMAGE_SIZE directly for highmap cleanup.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/head64.c |    3 ---
>  arch/x86/kernel/setup.c  |    2 ++
>  arch/x86/mm/init_64.c    |    6 +++++-
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index a3fc233..7061d8b 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -146,9 +146,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
>  	/* clear bss before set_intr_gate with early_idt_handler */
>  	clear_bss();
>  
> -	/* XXX - this is wrong... we need to build page tables from scratch */
> -	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
> -
>  	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
>  #ifdef CONFIG_EARLY_PRINTK
>  		set_intr_gate(i, &early_idt_handlers[i]);
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 63160c6..04797e78 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -910,8 +910,10 @@ void __init setup_arch(char **cmdline_p)
>  	setup_bios_corruption_check();
>  #endif
>  
> +#ifdef CONFIG_X86_32
>  	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
>  			(max_pfn_mapped<<PAGE_SHIFT) - 1);
> +#endif
>  
>  	reserve_real_mode();
>  
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 9c5f2b1..98385a2 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -394,10 +394,14 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
>  void __init cleanup_highmap(void)
>  {
>  	unsigned long vaddr = __START_KERNEL_map;
> -	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
> +	unsigned long vaddr_end = __START_KERNEL_map + KERNEL_IMAGE_SIZE;
>  	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
>  	pmd_t *pmd = level2_kernel_pgt;
>  
> +	/* Xen has its own end somehow with abused max_pfn_mapped */
> +	if (max_pfn_mapped)
> +		vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);

If you are going to put a comment like that in the code, could you
please at least add some useful details, rather than a generic
"somehow"? It doesn't seem very helpful to me or to any other hackers
looking at the code.

The issue is even described as a comment in the code at the beginning of
arch/x86/xen/mmu.c:xen_setup_kernel_pagetable:

/* max_pfn_mapped is the last pfn mapped in the initial memory
 * mappings. Considering that on Xen after the kernel mappings we
 * have the mappings of some pages that don't exist in pfn space, we
 * set max_pfn_mapped to the last real pfn mapped. */

Now if max_pfn_mapped is supposed to represent the last pfn mapped in
the initial memory mapping, then I think that the way Xen uses
max_pfn_mapped is actually correct.


The question is: has max_pfn_mapped actually changed meaning?
Because if it hasn't I don't see why you need this change.



>  	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
>  		if (pmd_none(*pmd))
>  			continue;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
