Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3J0Lur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:50:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46836 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3J0Lup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:50:45 -0400
Date: Sun, 27 Oct 2013 12:50:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 1/6] Add function efi_remap_region for remapping to saved
 virt address
Message-ID: <20131027115038.GB21868@pd.tnic>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.776610726@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131027035922.776610726@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 11:47:14AM +0800, dyoung@redhat.com wrote:
> Kexec kernel will use saved runtime virtual mapping, so add a
> new function efi_remap_region to remapping it directly without
> calculate the virt addr from efi_va.
> 
> The md is passed in from 1st kernel, the virtual addr is
> saved in md->virt_addr.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/include/asm/efi.h     |    1 +
>  arch/x86/platform/efi/efi_32.c |    4 ++++
>  arch/x86/platform/efi/efi_64.c |   13 +++++++++++++
>  3 files changed, 18 insertions(+)
> 
> --- linux-2.6.orig/arch/x86/include/asm/efi.h
> +++ linux-2.6/arch/x86/include/asm/efi.h
> @@ -112,6 +112,7 @@ extern void efi_call_phys_epilog(void);
>  extern void efi_unmap_memmap(void);
>  extern void efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
> +extern void __init efi_remap_region(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern void __init old_map_region(efi_memory_desc_t *md);
>  
> --- linux-2.6.orig/arch/x86/platform/efi/efi_64.c
> +++ linux-2.6/arch/x86/platform/efi/efi_64.c
> @@ -177,6 +177,19 @@ void __init efi_map_region(efi_memory_de
>  	md->virt_addr = efi_va;
>  }
>  
> +void __init efi_remap_region(efi_memory_desc_t *md)

remap? Why?

You did have efi_map_region_fixed() which made more sense.

> +{
> +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> +	unsigned long pf = 0;
> +
> +	if (!(md->attribute & EFI_MEMORY_WB))
> +		pf |= _PAGE_PCD;
> +
> +	if(kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr, md->num_pages, pf))

ERROR: space required before the open parenthesis '('
#59: FILE: arch/x86/platform/efi/efi_64.c:188:
+       if(kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr, md->num_pages, pf))


Please run them all through checkpatch.pl - better yet, integrate
checkpatch into your workflow like using git hooks, for example.

> +		pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",

WARNING: Prefer pr_warn(... to pr_warning(...
#60: FILE: arch/x86/platform/efi/efi_64.c:189:
+               pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",

> +			   md->phys_addr, md->virt_addr);
> +}
> +
>  void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>  				 u32 type, u64 attribute)
>  {
> --- linux-2.6.orig/arch/x86/platform/efi/efi_32.c
> +++ linux-2.6/arch/x86/platform/efi/efi_32.c
> @@ -46,6 +46,10 @@ void __init efi_map_region(efi_memory_de
>  	old_map_region(md);
>  }
>  
> +void __init efi_remap_region(efi_memory_desc_t *md)
> +{
> +}

Let's keep braces on the same line as the function to save space:

void __init efi_remap_region(efi_memory_desc_t *md) {}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
