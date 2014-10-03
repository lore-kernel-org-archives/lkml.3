Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaJCNrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:47:13 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56101 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCNrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:47:10 -0400
Date: Fri, 3 Oct 2014 14:47:07 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141003134707.GJ14343@console-pimps.org>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-2-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411313216-2641-2-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep, at 05:26:54PM, Mathias Krause wrote:
> In commit 3891a04aafd6 ("x86-64, espfix: Don't leak bits 31:16 of %esp
> returning..") the "ESPFix Area" was added to the page table dump special
> sections. That area, though, has a limited amount of entries printed.
> 
> The EFI runtime services are, unfortunately, located in-between the
> espfix area and the high kernel memory mapping. Due to the enforced
> limitation for the espfix area, the EFI mappings won't be printed in the
> page table dump.
> 
> To make the ESP runtime service mappings visible again, provide them a
> dedicated entry.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
> v2: same as v1
> 
>  arch/x86/include/asm/pgtable_64_types.h |    2 ++
>  arch/x86/mm/dump_pagetables.c           |    3 +++
>  arch/x86/platform/efi/efi_64.c          |    3 +--
>  3 files changed, 6 insertions(+), 2 deletions(-)
 
Looks OK to me. Borislav?

> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 7166e25ecb57..602b6028c5b6 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -63,6 +63,8 @@ typedef struct { pteval_t pte; } pte_t;
>  #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
>  #define ESPFIX_PGD_ENTRY _AC(-2, UL)
>  #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
> +#define EFI_VA_START	 ( -4 * (_AC(1, UL) << 30))
> +#define EFI_VA_END	 (-68 * (_AC(1, UL) << 30))
>  
>  #define EARLY_DYNAMIC_PAGE_TABLES	64
>  
> diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
> index 95a427e57887..1a8053d1012e 100644
> --- a/arch/x86/mm/dump_pagetables.c
> +++ b/arch/x86/mm/dump_pagetables.c
> @@ -76,6 +76,9 @@ static struct addr_marker address_markers[] = {
>  # ifdef CONFIG_X86_ESPFIX64
>  	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
>  # endif
> +# ifdef CONFIG_EFI
> +	{ EFI_VA_END,		"EFI Runtime Services" },
> +# endif
>  	{ __START_KERNEL_map,   "High Kernel Mapping" },
>  	{ MODULES_VADDR,        "Modules" },
>  	{ MODULES_END,          "End Modules" },
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 290d397e1dd9..899c7f17ad85 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -48,8 +48,7 @@ static unsigned long efi_flags __initdata;
>   * We allocate runtime services regions bottom-up, starting from -4G, i.e.
>   * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
>   */
> -static u64 efi_va	= -4 * (1UL << 30);
> -#define EFI_VA_END	(-68 * (1UL << 30))
> +static u64 efi_va = EFI_VA_START;
>  
>  /*
>   * Scratch space used for switching the pagetable in the EFI stub
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Matt Fleming, Intel Open Source Technology Center
