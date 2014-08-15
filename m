Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaHOPGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:06:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41008 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbaHOPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:06:45 -0400
Date: Fri, 15 Aug 2014 16:05:44 +0100
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
Subject: Re: [PATCH 4/7] arm64/efi: uefi_init error handling fix
Message-ID: <20140815150544.GX27466@arm.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007731-15081-4-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408007731-15081-4-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:15:29AM +0100, Dave Young wrote:
> There's one early memmap leak in uefi_init error path, fix it and slightly tune
> the error handling code.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Reported-by: Will Deacon <will.deacon@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>

Thanks for fixing this.

Will

> ---
>  arch/arm64/kernel/efi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e72f310..6ed0362 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -89,7 +89,8 @@ static int __init uefi_init(void)
>  	 */
>  	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
>  		pr_err("System table signature incorrect\n");
> -		return -EINVAL;
> +		retval = -EINVAL;
> +		goto out;
>  	}
>  	if ((efi.systab->hdr.revision >> 16) < 2)
>  		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
> @@ -103,6 +104,7 @@ static int __init uefi_init(void)
>  		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
>  			vendor[i] = c16[i];
>  		vendor[i] = '\0';
> +		early_memunmap(c16, sizeof(vendor));
>  	}
>  
>  	pr_info("EFI v%u.%.02u by %s\n",
> @@ -113,9 +115,8 @@ static int __init uefi_init(void)
>  	if (retval == 0)
>  		set_bit(EFI_CONFIG_TABLES, &efi.flags);
>  
> -	early_memunmap(c16, sizeof(vendor));
> +out:
>  	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
> -
>  	return retval;
>  }
>  
> -- 
> 1.8.3.1
> 
> 
