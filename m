Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaHOPKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:10:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41059 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbaHOPKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:10:41 -0400
Date: Fri, 15 Aug 2014 16:09:52 +0100
From: Will Deacon <will.deacon@arm.com>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Daniel Kiper <daniel.kiper@oracle.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 5/7] arm64/efi: do not enter virtual mode in case booting
 with efi=noruntime or noefi
Message-ID: <20140815150952.GY27466@arm.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007731-15081-5-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408007731-15081-5-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:15:30AM +0100, Dave Young wrote:
> In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
> should error out.
> 
> At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
> the function or it will leak early mem.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/arm64/kernel/efi.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 6ed0362..309fab1 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -392,11 +392,16 @@ static int __init arm64_enter_virtual_mode(void)
>  		return -1;
>  	}
>  
> +	mapsize = memmap.map_end - memmap.map;
> +	if (efi_runtime_disabled()) {
> +		early_memunmap(memmap.map, mapsize);

Should this early_memunmap really be conditional? With this change, we no
longer unmap it before setting up the permanent mapping below.

Will

> +		pr_info("EFI runtime services will be disabled.\n");
> +		return -1;
> +	}
> +
>  	pr_info("Remapping and enabling EFI services.\n");
>  
>  	/* replace early memmap mapping with permanent mapping */
> -	mapsize = memmap.map_end - memmap.map;
> -	early_memunmap(memmap.map, mapsize);
>  	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
>  						   mapsize);
>  	memmap.map_end = memmap.map + mapsize;
> -- 
> 1.8.3.1
> 
> 
