Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaCDXGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:06:21 -0500
Received: from relay3.sgi.com ([192.48.152.1]:55017 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753299AbaCDXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:06:19 -0500
Date: Tue, 4 Mar 2014 17:06:15 -0600
From: Russ Anderson <rja@sgi.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] efi: Quirk out SGI UV
Message-ID: <20140304230615.GF8556@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1393948937-21840-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393948937-21840-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 05:02:17PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Getting this thing to work with the new mapping scheme would need more
> work.

Thanks Boris.  Allows SGI UV to boot (without the extra bootline).

Acked-by: Russ Anderson <rja@sgi.com> 

> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/efi.h  |  1 +
>  arch/x86/kernel/setup.c     | 10 ++--------
>  arch/x86/platform/efi/efi.c | 20 ++++++++++++++++++++
>  3 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index e985d6bf7d3a..86d1fd4bf24c 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -135,6 +135,7 @@ extern void __init old_map_region(efi_memory_desc_t *md);
>  extern void __init runtime_code_page_mkexec(void);
>  extern void __init efi_runtime_mkexec(void);
>  extern void __init efi_dump_pagetable(void);
> +extern void __init efi_apply_memmap_quirks(void);
>  
>  struct efi_setup_data {
>  	u64 fw_vendor;
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 830ae2d95450..09c76d265550 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1238,14 +1238,8 @@ void __init setup_arch(char **cmdline_p)
>  	register_refined_jiffies(CLOCK_TICK_RATE);
>  
>  #ifdef CONFIG_EFI
> -	/* Once setup is done above, unmap the EFI memory map on
> -	 * mismatched firmware/kernel archtectures since there is no
> -	 * support for runtime services.
> -	 */
> -	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
> -		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
> -		efi_unmap_memmap();
> -	}
> +	if (efi_enabled(EFI_BOOT))
> +		efi_apply_memmap_quirks();
>  #endif
>  }
>  
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 482986c3afc5..518aa8540a6d 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -52,6 +52,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/x86_init.h>
>  #include <asm/rtc.h>
> +#include <asm/uv/uv.h>
>  
>  #define EFI_DEBUG
>  
> @@ -1298,3 +1299,22 @@ static int __init parse_efi_cmdline(char *str)
>  	return 0;
>  }
>  early_param("efi", parse_efi_cmdline);
> +
> +void __init efi_apply_memmap_quirks(void)
> +{
> +	/*
> +	 * Once setup is done earlier, unmap the EFI memory map on mismatched
> +	 * firmware/kernel architectures since there is no support for runtime
> +	 * services.
> +	 */
> +	if (!efi_is_native()) {
> +		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
> +		efi_unmap_memmap();
> +	}
> +
> +	/*
> +	 * UV doesn't support the new EFI pagetable mapping yet.
> +	 */
> +	if (is_uv_system())
> +		set_bit(EFI_OLD_MEMMAP, &efi.flags);
> +}
> -- 
> 1.9.0

-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
