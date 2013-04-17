Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966574Ab3DQOGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:06:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42673 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966386Ab3DQOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:06:08 -0400
Message-ID: <516EAC4A.6040202@console-pimps.org>
Date: Wed, 17 Apr 2013 15:06:02 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
CC: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
In-Reply-To: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing some more folks)

On 16/04/13 16:58, Bryan O'Donoghue wrote:
> This warning is caused by efi_enter_virtual_mode mapping memory marked
> as !EFI_RUNTIME_MEMORY. The reason this memory is being mapped is to
> work around buggy code that stores an ACPI object called the Boot
> Graphics Resource Table - BGRT in memory of type EfiBootServices*.
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95
> Call Trace:
>  [<c102b6af>] warn_slowpath_common+0x5f/0x80
>  [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
>  [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
>  [<c102b6ed>] warn_slowpath_null+0x1d/0x20
>  [<c1023fb3>] __ioremap_caller+0x3d3/0x440
>  [<c106007b>] ? get_usage_chars+0xfb/0x110
>  [<c102d937>] ? vprintk_emit+0x147/0x480
>  [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
>  [<c102406a>] ioremap_cache+0x1a/0x20
>  [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
>  [<c1418593>] efi_enter_virtual_mode+0x1e4/0x3de
>  [<c1407984>] start_kernel+0x286/0x2f4
>  [<c1407535>] ? repair_env_string+0x51/0x51
>  [<c1407362>] i386_start_kernel+0x12c/0x12f
> ---[ end trace 4eaa2a86a8e2da22 ]---

The warning is telling you that someone is trying to ioremap RAM, which
is bad. It's not specifically an issue with the bgrt image, it's just
that said object happens to occupy an EfiBootServicesData region which
isn't mapped by the direct kernel mapping on i386.

Most (all?) boot loaders mark EFI_BOOT_SERVICES_{CODE,DATA} as E820_RAM,
which is why ioremap() complained about you trying to ioremap() a page
of RAM. They do this because after efi_free_boot_services() we want
these regions to be available for general allocation.

On x86-64 you rarely hit the ioremap() path because all RAM regions are
mapped by the kernel direct mapping, e.g __va() works on those
addresses. On i386, with its reduced virtual address space, it's much
more likely that those addresses are not part of the direct mapping, and
so this is the chunk of code that causes problems in
efi_enter_virtual_mode(),

                start_pfn = PFN_DOWN(md->phys_addr);
                end_pfn = PFN_UP(end);
                if (pfn_range_is_mapped(start_pfn, end_pfn)) {
                        va = __va(md->phys_addr);

                        if (!(md->attribute & EFI_MEMORY_WB))
                                efi_memory_uc((u64)(unsigned long)va, size);
                } else
                        va = efi_ioremap(md->phys_addr, size,
                                         md->type, md->attribute);

What we probably need is an i386-specific implementation of
efi_ioremap() that checks to see whether we're mapping a RAM region. I
thought of maybe using the kmap_high() functions, but I don't think
repeated calls to the kmap*() functions are guaranteed to provide
consecutive virtual addresses, and I doubt free_bootmem() (called from
efi_free_boot_services()) understands kmap'd addresses.

Maybe we should hot-add the EFI_BOOT_SERVICES_* regions once we've
finished with them and only then mark them as RAM?

x86 folks? Halp?

> On systems that do not have a BGRT object, there's no reason to map this
> memory in efi_enter_virtual_mode. This patch searches for the BGRT
> object and if found - will continue to map the boot services memory,
> else only memory with attribute EFI_RUNTIME_MEMORY will be mapped.
 
Like I said above, it just so happens on your machine that a BGRT object
occupies that chunk of memory, but this might not be the case on every
EFI i386 machine. You may have other useful things in that region that
you want to be mapped. It's also entirely possible that someone with the
same memory map layout as you _will_ want the bgrt image mapped. This
code needs fixing, instead of just working around the problem.

> Mapping only memory EFI_RUNTIME_MEMORY is is consistent with the code in
> arch/ia64/kernel/efi.c:efi_enter_virtual_mode();
> 
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue.lkml@nexus-software.ie>
> ---
>  arch/x86/platform/efi/efi-bgrt.c |   20 +++++++++++++++-----
>  arch/x86/platform/efi/efi.c      |   12 +++++++++---
>  include/linux/efi-bgrt.h         |    2 ++
>  3 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index 7145ec6..3655d62 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -25,19 +25,29 @@ struct bmp_header {
>  	u32 size;
>  } __packed;
>  
> -void __init efi_bgrt_init(void)
> +bool __init efi_bgrt_probe(void)
>  {
>  	acpi_status status;
> -	void __iomem *image;
> -	bool ioremapped = false;
> -	struct bmp_header bmp_header;
>  
>  	if (acpi_disabled)
> -		return;
> +		return false;
>  
> +	bgrt_tab = NULL;
>  	status = acpi_get_table("BGRT", 0,
>  	                        (struct acpi_table_header **)&bgrt_tab);
>  	if (ACPI_FAILURE(status))
> +		return false;
> +
> +	return true;
> +}
> +
> +void __init efi_bgrt_init(void)
> +{
> +	void __iomem *image;
> +	bool ioremapped = false;
> +	struct bmp_header bmp_header;
> +
> +	if (acpi_disabled || bgrt_tab == NULL)
>  		return;
>  
>  	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 5f2ecaf..7c64a2f 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -842,6 +842,7 @@ void __init efi_enter_virtual_mode(void)
>  	u64 end, systab, start_pfn, end_pfn;
>  	void *p, *va, *new_memmap = NULL;
>  	int count = 0;
> +	bool bgrt_map;
>  
>  	efi.systab = NULL;
>  
> @@ -855,6 +856,11 @@ void __init efi_enter_virtual_mode(void)
>  		return;
>  	}
>  
> +	/*
> +	 * Determine if mapping EFI boot code/data is required for BGRT mapping
> +	 */
> +	bgrt_map = efi_bgrt_probe();
> +
>  	/* Merge contiguous regions of the same type and attribute */
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		u64 prev_size;
> @@ -884,9 +890,9 @@ void __init efi_enter_virtual_mode(void)
>  
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
> -		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> -		    md->type != EFI_BOOT_SERVICES_CODE &&
> -		    md->type != EFI_BOOT_SERVICES_DATA)
> +		if (!((md->attribute & EFI_MEMORY_RUNTIME) || (bgrt_map &&
> +			(md->type == EFI_BOOT_SERVICES_CODE ||
> +			 md->type == EFI_BOOT_SERVICES_DATA))))
>  			continue;
>  
>  		size = md->num_pages << EFI_PAGE_SHIFT;
> diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
> index 051b21f..165426b 100644
> --- a/include/linux/efi-bgrt.h
> +++ b/include/linux/efi-bgrt.h
> @@ -6,6 +6,7 @@
>  #include <linux/acpi.h>
>  
>  void efi_bgrt_init(void);
> +bool efi_bgrt_probe(void);
>  
>  /* The BGRT data itself; only valid if bgrt_image != NULL. */
>  extern void *bgrt_image;
> @@ -15,6 +16,7 @@ extern struct acpi_table_bgrt *bgrt_tab;
>  #else /* !CONFIG_ACPI_BGRT */
>  
>  static inline void efi_bgrt_init(void) {}
> +static inline bool efi_bgrt_probe(void) { return false; }
>  
>  #endif /* !CONFIG_ACPI_BGRT */
>  
> 


-- 
Matt Fleming, Intel Open Source Technology Center
