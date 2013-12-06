Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab3LFRyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:54:38 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:38664 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab3LFRyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:54:36 -0500
Date: Fri, 6 Dec 2013 18:54:49 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, matt.fleming@intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        mark.rutland@arm.com, linaro-uefi@lists.linaro.org, patches@linaro.org,
        roy.franz@linaro.org, msalter@redhat.com, grant.likely@linaro.org
Subject: Re: [PATCH v3 2/3] arm: Add [U]EFI runtime services support
Message-ID: <20131206175449.GD24997@rocoto.smurfnet.nu>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
 <201312060259.48259.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312060259.48259.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thank you for your comments.

On Fri, Dec 06, 2013 at 02:59:48AM +0100, Arnd Bergmann wrote:
> On Thursday 28 November 2013, Leif Lindholm wrote:
> > @@ -898,6 +900,10 @@ void __init setup_arch(char **cmdline_p)
> >  	sanity_check_meminfo();
> >  	arm_memblock_init(&meminfo, mdesc);
> >  
> > +#ifdef CONFIG_EFI
> > +	uefi_memblock_arm_reserve_range();
> > +#endif
> > +
> 
> Better use 
> 
> 	if (IS_ENABLED(CONFIG_EFI))
> 
> here for readability and better build-time checking of the interface when
> CONFIG_EFI is disabled.

I think I'll do what Grant suggested and stub it out in asm/uefi.h.

> > +/*
> > + * Returns 1 if 'facility' is enabled, 0 otherwise.
> > + */
> > +int efi_enabled(int facility)
> > +{
> > +	return test_bit(facility, &arm_uefi_facility) != 0;
> > +}
> > +EXPORT_SYMBOL(efi_enabled);
> 
> I'd use EXPORT_SYMBOL_GPL() unless there is a documented reason why
> a symbol should be available to GPL-incompatible modules.

So ... this is duplicating x86 code which Matt Fleming has promised
to make generic. I'd prefer to keep it identical to x86 until this
copy goes away.

> > +static __init int is_discardable_region(efi_memory_desc_t *md)
> > +{
> > +#ifdef KEEP_ALL_REGIONS
> > +	return 0;
> > +#endif
> 
> IS_ENABLED() again.
 
Ok.

> > +	if (md->attribute & EFI_MEMORY_RUNTIME)
> > +		return 0;
> > +
> > +	switch (md->type) {
> > +#ifdef KEEP_BOOT_SERVICES_REGIONS
> > +	case EFI_BOOT_SERVICES_CODE:
> > +	case EFI_BOOT_SERVICES_DATA:
> > +#endif
> 
> and I think it can be used here too:
> 
> 	switch (md->type) {
> 	case EFI_BOOT_SERVICES_CODE:
> 	case EFI_BOOT_SERVICES_DATA:
> 		if (IS_ENABLED(KEEP_BOOT_SERVICES_REGIONS))
> 			return 1;
> 		/* fallthrough */
> 	case EFI_ACPI_RECLAIM_MEMORY:

Will redesign for next version.

> > +	memmap.phys_map = early_memremap((phys_addr_t)(u32) uefi_boot_mmap,
> > +					 uefi_boot_mmap_size);
> > +	if (!memmap.phys_map)
> > +		return 1;
> > +
> > +	p = memmap.phys_map;
> > +	e = (void *)((u32)p + uefi_boot_mmap_size);
> 
> You are doing a lot of type casts here, which is normally an indication
> that you have the types wrong in some way. I can't spot a mistake
> here, but maybe you can give it some more thought and see if it can be
> changed.

Grant made much the same comments here. It is possible the change to
the DT bindings to have all addresses 64-bit actually makes this go
away. I will revisit for next version.

> > +static int __init remap_region(efi_memory_desc_t *md, efi_memory_desc_t *entry)
> > +{
> > +	u64 va;
> > +	u64 paddr;
> > +	u64 size;
> > +
> > +	*entry = *md;
> > +	paddr = entry->phys_addr;
> > +	size = entry->num_pages << EFI_PAGE_SHIFT;
> > +
> > +	/*
> > +	 * Map everything writeback-capable as coherent memory,
> > +	 * anything else as device.
> > +	 */
> > +	if (md->attribute & EFI_MEMORY_WB)
> > +		va = (u64)((u32)uefi_remap(paddr, size) & 0xffffffffUL);
> > +	else
> > +		va = (u64)((u32)uefi_ioremap(paddr, size) & 0xffffffffUL);
> 
> Same here. Why is 'va' a u64?

Because the field in the structure (defined by UEFI) is 64-bit:

        entry->virt_addr = va;

/
    Leif
