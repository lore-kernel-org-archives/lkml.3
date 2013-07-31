Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab3GaI6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:58:34 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:65404 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab3GaI61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:58:27 -0400
Message-ID: <51F8D1AC.4040501@intel.com>
Date: Wed, 31 Jul 2013 09:58:20 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leif Lindholm <leif.lindholm@linaro.org>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        patches@linaro.org
Subject: Re: [PATCH 4/4] efi: x86: make efi_lookup_mapped_addr() a common
 function
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org> <1375202858-28470-5-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1375202858-28470-5-git-send-email-leif.lindholm@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 05:47 PM, Leif Lindholm wrote:
> efi_lookup_mapped_addr() is a handy utility for other platforms
> than x86. Move it from arch/x86 to drivers/firmware/efi.
> 
> This function will be used by future ARM patches.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/x86/platform/efi/efi.c |   28 ----------------------------
>  drivers/firmware/efi/efi.c  |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 28 deletions(-)
> 

[...]

> +#if defined(CONFIG_X86)
> +/*
> + * We can't ioremap data in EFI boot services RAM, because we've already mapped
> + * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
> + * callable after efi_enter_virtual_mode and before efi_free_boot_services.
> + */
> +void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
> +{
> +	void *p;
> +	if (WARN_ON(!memmap.map))
> +		return NULL;
> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		efi_memory_desc_t *md = p;
> +		u64 size = md->num_pages << EFI_PAGE_SHIFT;
> +		u64 end = md->phys_addr + size;
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> +		    md->type != EFI_BOOT_SERVICES_CODE &&
> +		    md->type != EFI_BOOT_SERVICES_DATA)
> +			continue;
> +		if (!md->virt_addr)
> +			continue;
> +		if (phys_addr >= md->phys_addr && phys_addr < end) {
> +			phys_addr += md->virt_addr - md->phys_addr;
> +			return (__force void __iomem *)(unsigned long)phys_addr;
> +		}
> +	}
> +	return NULL;
> +}
> +#endif
> +

If we hang a 'struct efi_memory_map' off of 'struct efi', can we get rid
of this #ifdef?
