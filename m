Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab3FDG6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:58:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60009 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759387Ab3FDG6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:58:42 -0400
Message-ID: <51AD901C.30607@intel.com>
Date: Tue, 04 Jun 2013 07:58:36 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UEFI: Don't pass boot services regions to SetVirtualAddressMap()
References: <1370211145-7273-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1370211145-7273-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2013 11:12 PM, Matthew Garrett wrote:
> We need to map boot services regions during startup in order to avoid
> firmware bugs, but we shouldn't be passing those regions to
> SetVirtualAddressMap(). Ensure that we're only passing regions that are
> marked as being mapped at runtime.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  arch/x86/platform/efi/efi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 63e167a..add0e37 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -922,6 +922,13 @@ void __init efi_enter_virtual_mode(void)
>  			va = efi_ioremap(md->phys_addr, size,
>  					 md->type, md->attribute);
>  
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
> +			if (!va)
> +				pr_err("ioremap of 0x%llX failed!\n",
> +				       (unsigned long long)md->phys_addr);
> +			continue;
> +		}
> +
>  		md->virt_addr = (u64) (unsigned long) va;
>  
>  		if (!va) {
> 

Is there any point in calling efi_ioremap() for non-runtime regions in
this case? In other words, why not the following patch?

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 63e167a..a438ed3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -903,9 +903,7 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
