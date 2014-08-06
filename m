Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbaHFMkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:40:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59469 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbaHFMk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:40:28 -0400
Date: Wed, 6 Aug 2014 13:39:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: Dave Young <dyoung@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140806123958.GK25953@arm.com>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 09:38:25AM +0100, Dave Young wrote:
> Adding a noefi boot param like in X86 to disable efi runtime services support.
> 
> This will be useful for debugging uefi problems. Also it will be useful
> for later kexec/kdump work. Kexec on uefi support in X86 depends on a fixed vm
> area specific for uefi runtime 1:1 mapping, kernel will switch to a different
> page table for any uefi runtime callback in virtual mode. In arm64 similar
> work probably is necessary. But kexec boot will just works with 'noefi' with
> the limitaion of lacking runtime services. The runtime services is not critical
> for kdump kernel for now. So as for kexec/kdump just leave the 1:1 mapping a
> future work.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

This looks fine to me, but I'd like Leif's ack before I merge it. Leif?

Will

> ---
>  arch/arm64/kernel/efi.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/arm64/kernel/efi.c
> ===================================================================
> --- linux-2.6.orig/arch/arm64/kernel/efi.c
> +++ linux-2.6/arch/arm64/kernel/efi.c
> @@ -31,6 +31,14 @@ static efi_runtime_services_t *runtime;
>  
>  static u64 efi_system_table;
>  
> +static bool disable_runtime __initdata = false;
> +static int __init setup_noefi(char *arg)
> +{
> +	disable_runtime = true;
> +	return 0;
> +}
> +early_param("noefi", setup_noefi);
> +
>  static int uefi_debug __initdata;
>  static int __init uefi_debug_setup(char *str)
>  {
> @@ -391,11 +399,14 @@ static int __init arm64_enter_virtual_mo
>  		return -1;
>  	}
>  
> -	pr_info("Remapping and enabling EFI services.\n");
> -
> -	/* replace early memmap mapping with permanent mapping */
>  	mapsize = memmap.map_end - memmap.map;
>  	early_memunmap(memmap.map, mapsize);
> +
> +	if (disable_runtime)
> +		return -ENODEV;
> +
> +	pr_info("Remapping and enabling EFI services.\n");
> +	/* replace early memmap mapping with permanent mapping */
>  	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
>  						   mapsize);
>  	memmap.map_end = memmap.map + mapsize;
> 
