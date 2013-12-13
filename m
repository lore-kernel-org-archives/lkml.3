Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3LMQCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:02:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52614 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab3LMQCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:02:03 -0500
Date: Fri, 13 Dec 2013 17:01:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131213160150.GE32329@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-11-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386582147-9802-11-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:42:23PM +0800, Dave Young wrote:
> For kexec/kdump kernel efi runtime mappings are saved, printing original whole
> memmap ranges does not make sense anymore. So introduce a new function to only
> print runtime maps in case kexec/kdump kernel is used.
> 
> changelog:
> Matt: use efi_setup instead of esdata
>       share function print_efi_memmap for both normal and kexec boot.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 69a6ec2..94a1cbc 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -423,19 +423,16 @@ int __init efi_memblock_x86_reserve_range(void)
>  	return 0;
>  }
>  
> -static void __init print_efi_memmap(void)
> +static void __init print_efi_memmap(void *map, int nr_map, int md_size)
>  {
>  #ifdef EFI_DEBUG
>  	efi_memory_desc_t *md;
>  	void *p;
>  	int i;
>  
> -	for (p = memmap.map, i = 0;
> -	     p < memmap.map_end;
> -	     p += memmap.desc_size, i++) {
> +	for (p = map, i = 0; i < nr_map; p += md_size, i++) {
>  		md = p;
> -		pr_info("mem%02u: type=%u, attr=0x%llx, "
> -			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
> +		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
>  			i, md->type, md->attribute, md->phys_addr,
>  			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
>  			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> @@ -797,7 +794,20 @@ void __init efi_init(void)
>  		x86_platform.set_wallclock = efi_set_rtc_mmss;
>  	}
>  #endif
> -	print_efi_memmap();
> +	if (efi_setup) {
> +		int s;
> +		struct efi_setup_data *data;
> +
> +		s = sizeof(*data) + nr_efi_runtime_map * sizeof(data->map[0]);
> +		data = early_memremap(efi_setup, s);
> +		if (!data)
> +			return;
> +		print_efi_memmap(data->map, nr_efi_runtime_map,
> +				 sizeof(data->map[0]));
> +		early_memunmap(data, s);

Well, if you call print_efi_memmap() in parse_efi_setup() you can save
yourself that map/unmaping no?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
