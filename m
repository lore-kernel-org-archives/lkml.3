Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3K0K1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:27:09 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56142 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab3K0K1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:27:06 -0500
Date: Wed, 27 Nov 2013 10:27:01 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 08/12] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131127102701.GD18170@console-pimps.org>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-9-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385445477-9665-9-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov, at 01:57:53PM, Dave Young wrote:
> For kexec/kdump kernel efi runtime mappings are saved, printing original whole
> memmap ranges does not make sense anymore. So introduce a new function to only
> print runtime maps in case kexec/kdump kernel is used.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index fafeb40..c65b0b8 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -430,6 +430,24 @@ int __init efi_memblock_x86_reserve_range(void)
>  	return 0;
>  }
>  
> +/* for kexec kernel runtime maps are passed in setup_data */
> +static void __init print_saved_runtime_map(void)
> +{
> +#ifdef EFI_DEBUG
> +	int i;
> +	efi_memory_desc_t *md;
> +
> +	for (i = 0; i < nr_efi_runtime_map; i++) {
> +		md = esdata->map + i;
> +		pr_info("mem%02u: type=%u, attr=0x%llx, "
> +			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
> +			i, md->type, md->attribute, md->phys_addr,
> +			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> +			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> +	}
> +#endif  /*  EFI_DEBUG  */
> +}
> +
>  static void __init print_efi_memmap(void)
>  {
>  #ifdef EFI_DEBUG
> @@ -782,7 +800,10 @@ void __init efi_init(void)
>  		x86_platform.set_wallclock = efi_set_rtc_mmss;
>  	}
>  #endif
> -	print_efi_memmap();
> +	if (esdata)
> +		print_saved_runtime_map();
> +	else
> +		print_efi_memmap();
>  }

Heh, you can probably already guess what I'm going to say here...

How about using a single function to dump the memory ranges irrespective
of whether the memory map comes from 'memmap' or 'esdata'? e.g.
something along the lines of,

	if (esdata)
		print_efi_memmap(esdata->map, nr_efi_runtime_map,
				 sizeof(esdata->map[0]));
	else
		print_efi_memmap(memmap.map, memmap.nr_map,
				 memmap.desc_size);

?

-- 
Matt Fleming, Intel Open Source Technology Center
