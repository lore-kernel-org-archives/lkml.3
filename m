Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3IYJY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:24:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33233 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3IYJY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:24:56 -0400
Message-ID: <1c45cce8ceb98b178976751a1d7db8be.squirrel@www.skyhub.de>
In-Reply-To: <20130921113929.GB1587@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
    <1379602494-26684-12-git-send-email-bp@alien8.de>
    <20130921113929.GB1587@pd.tnic>
Date: Wed, 25 Sep 2013 11:24:54 +0200 (CEST)
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
From: "Borislav Petkov" <bp@alien8.de>
To: "Borislav Petkov" <bp@alien8.de>
Cc: "X86 ML" <x86@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@suse.de>,
        "Matt Fleming" <matt@console-pimps.org>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "James Bottomley" <james.bottomley@hansenpartnership.com>,
        "Vivek Goyal" <vgoyal@redhat.com>, "Dave Young" <dyoung@redhat.com>,
        linux-efi@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, September 21, 2013 1:39 pm, Borislav Petkov wrote:
> diff --git a/arch/x86/platform/efi/efi_32.c
> b/arch/x86/platform/efi/efi_32.c
> index 40e446941dd7..661663b08eaf 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -37,9 +37,36 @@
>   * claim EFI runtime service handler exclusively and to duplicate a
> memory in
>   * low memory space say 0 - 3G.
>   */
> -
>  static unsigned long efi_rt_eflags;
>
> +void efi_sync_low_kernel_mappings(void) {}
> +
> +void __init efi_map_region(efi_memory_desc_t *md)
> +{
> +	u64 start_pfn, end_pfn, end;
> +	unsigned long size;
> +	void *va;
> +
> +	start_pfn = PFN_DOWN(md->phys_addr);
> +	size	  = md->num_pages << PAGE_SHIFT;
> +	end	  = md->phys_addr + size;
> +	end_pfn   = PFN_UP(end);
> +
> +	if (pfn_range_is_mapped(start_pfn, end_pfn)) {
> +		va = __va(md->phys_addr);
> +
> +		if (!(md->attribute & EFI_MEMORY_WB))
> +			efi_memory_uc((u64)(unsigned long)va, size);
> +	} else
> +		va = efi_ioremap(md->phys_addr, size,
> +				 md->type, md->attribute);
> +
> +	md->virt_addr = (u64) (unsigned long) va;
> +	if (!va)
> +		pr_err("ioremap of 0x%llX failed!\n",
> +		       (unsigned long long)md->phys_addr);
> +}
> +

Another note-to-self, while I'm here: it is probably prudent to
be conservative here and keep the old runtime mapping method
in generic EFI code and behind a chicken bit, something like
"efi.use_old_runtime_mapping" or shorter so that people whose systems
break from the new mapping can fall back to the old, well-tested method.

Thanks.

-- 
Regards/Gruss,
Boris.

