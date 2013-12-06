Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3LFCAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:00:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LFCAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:00:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/3] arm: Add [U]EFI runtime services support
Date: Fri, 6 Dec 2013 02:59:48 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        mark.rutland@arm.com, linaro-uefi@linaro.org, matt.fleming@intel.com,
        patches@linaro.org, roy.franz@linaro.org, msalter@redhat.com,
        grant.likely@linaro.org
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312060259.48259.arnd@arndb.de>
X-Provags-ID: V02:K0:YRYn61J5FSGKucG7li5piIR3zhuV2779QslzZkpCLds
 k9zU+lLzSiFb9xPyO3IyXqfDLruFWM9ecOKZop4vzbhM4ZqOuC
 UwRbtXDF8pK0e4RdZ/u1T3uNmdT4/i5oGNTM7OBM0HqxQ9Ye9+
 zOgSDKMpDLAv2FPH2Rfk+CYdAiedqToegz5XgTtn+vKwtry0sb
 zcr6Ff6yK0fP7WL3+BsxSkwbriPsQxA4V8BOs8YVZVeBywcIyH
 wwzN5Hs64bjhUYCvWlJNoDAT/u7uHcVDchEfHWcJcKXztIrJIf
 oWxT3BQUV4mRnbMXgn2A6Up9+BHExhw0YRIj9X7P2fR1t9iCWk
 ReuFz2k3R3xM0m13/ebs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 November 2013, Leif Lindholm wrote:
> @@ -898,6 +900,10 @@ void __init setup_arch(char **cmdline_p)
>  	sanity_check_meminfo();
>  	arm_memblock_init(&meminfo, mdesc);
>  
> +#ifdef CONFIG_EFI
> +	uefi_memblock_arm_reserve_range();
> +#endif
> +

Better use 

	if (IS_ENABLED(CONFIG_EFI))

here for readability and better build-time checking of the interface when
CONFIG_EFI is disabled.

> +/*
> + * Returns 1 if 'facility' is enabled, 0 otherwise.
> + */
> +int efi_enabled(int facility)
> +{
> +	return test_bit(facility, &arm_uefi_facility) != 0;
> +}
> +EXPORT_SYMBOL(efi_enabled);

I'd use EXPORT_SYMBOL_GPL() unless there is a documented reason why
a symbol should be available to GPL-incompatible modules.

> +static __init int is_discardable_region(efi_memory_desc_t *md)
> +{
> +#ifdef KEEP_ALL_REGIONS
> +	return 0;
> +#endif

IS_ENABLED() again.

> +	if (md->attribute & EFI_MEMORY_RUNTIME)
> +		return 0;
> +
> +	switch (md->type) {
> +#ifdef KEEP_BOOT_SERVICES_REGIONS
> +	case EFI_BOOT_SERVICES_CODE:
> +	case EFI_BOOT_SERVICES_DATA:
> +#endif

and I think it can be used here too:

	switch (md->type) {
	case EFI_BOOT_SERVICES_CODE:
	case EFI_BOOT_SERVICES_DATA:
		if (IS_ENABLED(KEEP_BOOT_SERVICES_REGIONS))
			return 1;
		/* fallthrough */
	case EFI_ACPI_RECLAIM_MEMORY:

> +	memmap.phys_map = early_memremap((phys_addr_t)(u32) uefi_boot_mmap,
> +					 uefi_boot_mmap_size);
> +	if (!memmap.phys_map)
> +		return 1;
> +
> +	p = memmap.phys_map;
> +	e = (void *)((u32)p + uefi_boot_mmap_size);

You are doing a lot of type casts here, which is normally an indication
that you have the types wrong in some way. I can't spot a mistake
here, but maybe you can give it some more thought and see if it can be
changed.

> +static int __init remap_region(efi_memory_desc_t *md, efi_memory_desc_t *entry)
> +{
> +	u64 va;
> +	u64 paddr;
> +	u64 size;
> +
> +	*entry = *md;
> +	paddr = entry->phys_addr;
> +	size = entry->num_pages << EFI_PAGE_SHIFT;
> +
> +	/*
> +	 * Map everything writeback-capable as coherent memory,
> +	 * anything else as device.
> +	 */
> +	if (md->attribute & EFI_MEMORY_WB)
> +		va = (u64)((u32)uefi_remap(paddr, size) & 0xffffffffUL);
> +	else
> +		va = (u64)((u32)uefi_ioremap(paddr, size) & 0xffffffffUL);

Same here. Why is 'va' a u64?

	Arnd
