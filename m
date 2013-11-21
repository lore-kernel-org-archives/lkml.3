Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3KUQj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:39:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44690 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3KUQj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:39:56 -0500
Date: Thu, 21 Nov 2013 17:39:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 2/9 v3] efi: add a wrapper function efi_map_region_fixed
Message-ID: <20131121163947.GL26009@pd.tnic>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061753.223578092@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121061753.223578092@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:17:06PM +0800, dyoung@redhat.com wrote:
> Kexec kernel will use saved runtime virtual mapping, so add a
> new function efi_map_region_fixed for directly mapping a md
> to md->virt.
> 
> The md is passed in from 1st kernel, the virtual addr is
> saved in md->virt_addr.
> 
> Matt: coding style
>       reuse __map_region
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Except minor nitpick below:

Acked-by: Borislav Petkov <bp@suse.de>

> ---
>  arch/x86/include/asm/efi.h     |    1 +
>  arch/x86/platform/efi/efi_32.c |    2 ++
>  arch/x86/platform/efi/efi_64.c |   10 ++++++++++
>  3 files changed, 13 insertions(+)
> 
> --- efi.orig/arch/x86/include/asm/efi.h
> +++ efi/arch/x86/include/asm/efi.h
> @@ -128,6 +128,7 @@ extern void efi_call_phys_epilog(void);
>  extern void efi_unmap_memmap(void);
>  extern void efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
> +extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern void efi_setup_page_tables(void);
>  extern void __init old_map_region(efi_memory_desc_t *md);
> --- efi.orig/arch/x86/platform/efi/efi_64.c
> +++ efi/arch/x86/platform/efi/efi_64.c
> @@ -199,6 +199,16 @@ void __init efi_map_region(efi_memory_de
>  	md->virt_addr = efi_va;
>  }
>  
> +/*
> + * kexec kernel will use efi_map_region_fixed to map efi
> + * runtime memory ranges. md->virt_addr is the original virtual
> + * address which had been mapped in kexec 1st kernel.
> + */

Why not stretch this comment to the full 80 cols?

/*
 * kexec kernel will use efi_map_region_fixed to map efi runtime memory ranges.
 * md->virt_addr is the original virtual address which had been mapped in kexec
 * 1st kernel.
 */

> +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> +{
> +	__map_region(md, md->virt_addr);
> +}
> +
>  void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>  				 u32 type, u64 attribute)
>  {
> --- efi.orig/arch/x86/platform/efi/efi_32.c
> +++ efi/arch/x86/platform/efi/efi_32.c
> @@ -47,6 +47,8 @@ void __init efi_map_region(efi_memory_de
>  	old_map_region(md);
>  }
>  
> +void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
> +
>  void efi_call_phys_prelog(void)
>  {
>  	struct desc_ptr gdt_descr;
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
