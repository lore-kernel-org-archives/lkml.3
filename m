Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967380Ab3DROvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:51:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:27669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967092Ab3DROvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,502,1363158000"; 
   d="scan'208";a="320335306"
Message-ID: <51700876.1000305@intel.com>
Date: Thu, 18 Apr 2013 07:51:34 -0700
From: Darren Hart <darren.hart@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org>
In-Reply-To: <516FD24A.3070502@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 04:00 AM, Matt Fleming wrote:
> On 17/04/13 23:00, Bryan O'Donoghue wrote:
>> In my mind the only memory that is relevant to efi_enter_virtual_mode is
>> memory that the BIOS has marked as EFI_RUNTIME_SERVICE
>>
>> md->attribute & 0x80000000_00000000
>>
>> I couldn't quite understand why the code in
>>
>> arch/x86/platform/efi/efi.c:enter_virtual_mode() looks like this
>>
>> for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>>                 md = p;
>>                 if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>>                     md->type != EFI_BOOT_SERVICES_CODE &&
>>                     md->type != EFI_BOOT_SERVICES_DATA)
>>             continue;
>>
>> While the code in
>>
>> arch/ia64/kernel/efi.c:enter_virtual_mode
>>
>> for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
>>         md = p;
>>         if (md->attribute & EFI_MEMORY_RUNTIME) {
>>
>> The ia64 version is consistent with the standard - but obviously isn't
>> accounting for the work-around implemented to retrieve the BGRT on ia32.
>>
>> Looking at the commit message associated with
>> arch/x86/platform/efi/efi-bgrt.c
>>
>> It's pretty obvious the mapping of boot code/data was done to facilitate
>> BGRT.
> 
> No, that's incorrect. The patch that introduced the mapping of
> EFI_BOOT_SERVICES_{CODE,DATA} was committed before support for bgrt
> existed. git blame is a good tool to use when doing one of these
> historical digs, and in this case it shows that the above lines from
> efi_enter_virtual_mode() were introduced in the following commit,
> 
> commit 916f676f8dc016103f983c7ec54c18ecdbb6e349
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Wed May 25 09:53:13 2011 -0400
> 
>     x86, efi: Retain boot service code until after switching to virtual mode
>     
>     UEFI stands for "Unified Extensible Firmware Interface", where "Firmware"
>     is an ancient African word meaning "Why do something right when you can
>     do it so wrong that children will weep and brave adults will cower before
>     you", and "UEI" is Celtic for "We missed DOS so we burned it into your
>     ROMs". The UEFI specification provides for runtime services (ie, another
>     way for the operating system to be forced to depend on the firmware) and
>     we rely on these for certain trivial tasks such as setting up the
>     bootloader. But some hardware fails to work if we attempt to use these
>     runtime services from physical mode, and so we have to switch into virtual
>     mode. So far so dreadful.
>     
>     The specification makes it clear that the operating system is free to do
>     whatever it wants with boot services code after ExitBootServices() has been
>     called. SetVirtualAddressMap() can't be called until ExitBootServices() has
>     been. So, obviously, a whole bunch of EFI implementations call into boot
>     services code when we do that. Since we've been charmingly naive and
>     trusted that the specification may be somehow relevant to the real world,
>     we've already stuffed a picture of a penguin or something in that address
>     space. And just to make things more entertaining, we've also marked it
>     non-executable.
>     
>     This patch allocates the boot services regions during EFI init and makes
>     sure that they're executable. Then, after SetVirtualAddressMap(), it
>     discards them and everyone lives happily ever after. Except for the ones
>     who have to work on EFI, who live sad lives haunted by the knowledge that
>     someone's eventually going to write yet another firmware specification.
>     
>     [ hpa: adding this to urgent with a stable tag since it fixes currently-broken
>       hardware.  However, I do not know what the dependencies are and so I do
>       not know which -stable versions this may be a candidate for. ]
>     
>     Signed-off-by: Matthew Garrett <mjg@redhat.com>
>     Link: http://lkml.kernel.org/r/1306331593-28715-1-git-send-email-mjg@redhat.com
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>     Cc: Tony Luck <tony.luck@intel.com>
>     Cc: <stable@kernel.org>
> 
> Yes the bgrt code accesses the Boot Service mappings, but that isn't the
> only reason we want to map those regions.
> 
>> That's one solution - you'd need to make the i386::efi_ioremap() aware
>> of the BGRT work-around.
>>
>> Presumably this work-around is also required on ia64 too.
> 
> No, we've never seen an ia64 firmware implementation with the "access
> EFI Boot Services Code/Data after ExitBootServices() bug", and it
> doesn't suffer from the same virtual address space limitations that i386
> does.
>  
>> No, no - we *don't* have a BGRT object at all.
>>
>> We have a completely clean memory map - but the BGRT code is causing the
>> is_ram() failure.
>  
> You assume that mapping of the Boot Services regions is done purely for
> the benefit of pulling out the bgrt image - it's not, see the above
> commit log - and I assumed that you had an ACPI bgrt pointer in your
> memory map, but you don't.
> 
> Darren, Josh, have you ever seen an i386 machine with a bgrt pointer? If
> not, and given that we've never seen an i386 firmware that requires the
> above workaround from Matthew, combined with the fact that there are so
> few i386 implementations out there, I'm inclined to apply the patch
> below, because anything else is a lot more work. We can address this
> properly if we ever start seeing i386 machines with bgrt pointers that
> reference highmem.

I don't believe I have seen a 32-bit EFI system with a BGRT, but then
again, I had to look it up today! That said, I suspect the MinnowBoard
would benefit from such a thing, so we should have an example of it
there in the near future.

Is this in anyway related to the following patch from Josh Boyer? We're
carrying this in the Yocto Project trees currently.

     commit 6f3e186bc7721c5b24ad90d4a751cccfccd445e6
     Author: Josh Boyer <jwboyer@redhat.com>
     Date:   Fri Aug 5 08:47:23 2011 -0400

        Add patch to fix 32bit EFI service mapping (rhbz 726701)

    Signed-off-by: Tom Zanussi <tom.zanussi@intel.com>
    Signed-off-by: Darren Hart <dvhart@linux.intel.com>

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 928bf83..6d7ecb5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -888,10 +888,13 @@ void __init efi_enter_virtual_mode(void)

        for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
                md = p;
-               if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-                   md->type != EFI_BOOT_SERVICES_CODE &&
-                   md->type != EFI_BOOT_SERVICES_DATA)
-                       continue;
+               if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+#ifdef CONFIG_X86_64
+                       if (md->type != EFI_BOOT_SERVICES_CODE &&
+                           md->type != EFI_BOOT_SERVICES_DATA)
+#endif
+                               continue;
+               }

                size = md->num_pages << EFI_PAGE_SHIFT;
                end = md->phys_addr + size;


> 
> ---
> 
> From 37ba0d4f43e0f8ec3e3342bc1331e36125495d3e Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Thu, 18 Apr 2013 09:57:55 +0100
> Subject: [PATCH] x86, efi: Refuse to ioremap highmem on i386
> 
> Bryan reports running into the following warning on i386,
> 
>   WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
>   Modules linked in:
>   Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95
>   Call Trace:
>    [<c102b6af>] warn_slowpath_common+0x5f/0x80
>    [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
>    [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
>    [<c102b6ed>] warn_slowpath_null+0x1d/0x20
>    [<c1023fb3>] __ioremap_caller+0x3d3/0x440
>    [<c106007b>] ? get_usage_chars+0xfb/0x110
>    [<c102d937>] ? vprintk_emit+0x147/0x480
>    [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
>    [<c102406a>] ioremap_cache+0x1a/0x20
>    [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
>    [<c1418593>] efi_enter_virtual_mode+0x1e4/0x3de
>    [<c1407984>] start_kernel+0x286/0x2f4
>    [<c1407535>] ? repair_env_string+0x51/0x51
>    [<c1407362>] i386_start_kernel+0x12c/0x12f
> 
> Due to the workaround described in commit 916f676f8 ("x86, efi: Retain
> boot service code until after switching to virtual mode") EFI Boot
> Service regions are mapped for a period during boot. Unfortunately, with
> the limited size of the i386 direct kernel map it's possible that some
> of the Boot Service regions will not be directly accessible, which
> causes them to be ioremap()'d, triggering the above warning as the
> regions are marked as E820_RAM in the e820 memmap.
> 
> The simplest fix is to refuse to map ram (and therefore, any EFI Boot
> Service regions) in an i386-specific version of efi_ioremap(), because
> there is no method of mapping arbitrary sizes of highmem at contiguous
> virtual addresses in the kernel address space.
> 
> There are currently only two situations where we need to map EFI Boot
> Service regions,
> 
>   1. To workaround the firmware bug described in 916f676f8
>   2. To access the ACPI BGRT image
> 
> but since we haven't seen an i386 implementation that requires either,
> this simple fix should suffice for now. Item 2. above does still work on
> i386 provided that the BGRT image is not in highmem.
> 
> Reported-by: Bryan O'Donoghue <bryan.odonoghue.lkml@nexus-software.ie>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/include/asm/efi.h     |    7 ++-----
>  arch/x86/platform/efi/efi_32.c |   15 +++++++++++++++
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 2fb5d58..8f042bf 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -35,8 +35,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
>  #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
>  	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
>  
> -#define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
> -
>  #else /* !CONFIG_X86_32 */
>  
>  #define EFI_LOADER_SIGNATURE	"EL64"
> @@ -88,9 +86,6 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
>  	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
>  		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
>  
> -extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
> -				 u32 type, u64 attribute);
> -
>  #endif /* CONFIG_X86_32 */
>  
>  extern int add_efi_memmap;
> @@ -101,6 +96,8 @@ extern void efi_call_phys_prelog(void);
>  extern void efi_call_phys_epilog(void);
>  extern void efi_unmap_memmap(void);
>  extern void efi_memory_uc(u64 addr, unsigned long size);
> +extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
> +				 u32 type, u64 attribute);
>  
>  struct efi_var_bootdata {
>  	struct setup_data data;
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index 40e4469..fbdfa97 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -67,3 +67,18 @@ void efi_call_phys_epilog(void)
>  
>  	local_irq_restore(efi_rt_eflags);
>  }
> +
> +void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
> +				 u32 type, u64 attribute)
> +{
> +	/*
> +	 * If we've been asked to map a chunk of ram, that means it is
> +	 * highmem and isn't accessible via the direct kernel mapping.
> +	 * i386 doesn't have a method for mapping arbitrary sized chunks
> +	 * of highmem into contiguous virtual addresses.
> +	 */
> +	if (page_is_ram(phys_addr))
> +		return NULL;
> +
> +	return ioremap_cache(phys_addr, size);
> +}
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
