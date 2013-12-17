Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3LQLXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:23:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44696 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3LQLXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:23:39 -0500
Date: Tue, 17 Dec 2013 12:23:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Message-ID: <20131217112334.GB30592@pd.tnic>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1387236997-26975-4-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 12:36:37AM +0100, Borislav Petkov wrote:
> @@ -880,6 +906,19 @@ void __init efi_enter_virtual_mode(void)
>  
>  	efi_dump_pagetable();
>  
> +	/*
> +	 * It can happen that the physical address of new_memmap lands in memory
> +	 * which is not mapped in the EFI page table. Therefore we need to go
> +	 * and ident-map those pages containing the map before calling
> +	 * phys_efi_set_virtual_address_map().
> +	 */
> +	if (kernel_map_pages_in_pgd(pgd, __pa(new_memmap), __pa(new_memmap),
> +				    1 << new_memmap_shift, _PAGE_NX)) {
> +		pr_err("Error ident-mapping new memmap (0x%lx)!\n",
> +		       __pa(new_memmap));
> +		goto err_out;
> +	}
> +
>  	status = phys_efi_set_virtual_address_map(
>  		memmap.desc_size * count,
>  		memmap.desc_size,
> @@ -916,7 +955,7 @@ void __init efi_enter_virtual_mode(void)
>  	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
>  		runtime_code_page_mkexec();
>  
> -	kfree(new_memmap);
> +	__free_pages(new_memmap, new_memmap_shift);

Note to self: carve out the error path of populate_pgd() into a separate
function and call it here to unmap the pages previously mapped above as
we're freeing them here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
