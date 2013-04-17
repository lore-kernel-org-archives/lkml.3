Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966961Ab3DQV6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:58:22 -0400
Received: from relay1.blacknight.com ([78.153.203.204]:36296 "EHLO
	relay1.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966948Ab3DQV6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:58:20 -0400
Message-ID: <516F1B90.9040508@nexus-software.ie>
Date: Wed, 17 Apr 2013 23:00:48 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org>
In-Reply-To: <516EAC4A.6040202@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/13 15:06, Matt Fleming wrote:
> (Cc'ing some more folks)
>
> On 16/04/13 16:58, Bryan O'Donoghue wrote:
>> This warning is caused by efi_enter_virtual_mode mapping memory marked
>> as !EFI_RUNTIME_MEMORY. The reason this memory is being mapped is to
>> work around buggy code that stores an ACPI object called the Boot
>> Graphics Resource Table - BGRT in memory of type EfiBootServices*.
>>
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
>> Modules linked in:
>> Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95
>> Call Trace:
>>   [<c102b6af>] warn_slowpath_common+0x5f/0x80
>>   [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
>>   [<c1023fb3>] ? __ioremap_caller+0x3d3/0x440
>>   [<c102b6ed>] warn_slowpath_null+0x1d/0x20
>>   [<c1023fb3>] __ioremap_caller+0x3d3/0x440
>>   [<c106007b>] ? get_usage_chars+0xfb/0x110
>>   [<c102d937>] ? vprintk_emit+0x147/0x480
>>   [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
>>   [<c102406a>] ioremap_cache+0x1a/0x20
>>   [<c1418593>] ? efi_enter_virtual_mode+0x1e4/0x3de
>>   [<c1418593>] efi_enter_virtual_mode+0x1e4/0x3de
>>   [<c1407984>] start_kernel+0x286/0x2f4
>>   [<c1407535>] ? repair_env_string+0x51/0x51
>>   [<c1407362>] i386_start_kernel+0x12c/0x12f
>> ---[ end trace 4eaa2a86a8e2da22 ]---
>
> The warning is telling you that someone is trying to ioremap RAM, which
> is bad. It's not specifically an issue with the bgrt image, it's just
> that said object happens to occupy an EfiBootServicesData region which
> isn't mapped by the direct kernel mapping on i386.

I understand that.

In my mind the only memory that is relevant to efi_enter_virtual_mode is 
memory that the BIOS has marked as EFI_RUNTIME_SERVICE

md->attribute & 0x80000000_00000000

I couldn't quite understand why the code in

arch/x86/platform/efi/efi.c:enter_virtual_mode() looks like this

for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
                 md = p;
                 if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
                     md->type != EFI_BOOT_SERVICES_CODE &&
                     md->type != EFI_BOOT_SERVICES_DATA)
			continue;

While the code in

arch/ia64/kernel/efi.c:enter_virtual_mode

for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
		md = p;
		if (md->attribute & EFI_MEMORY_RUNTIME) {

The ia64 version is consistent with the standard - but obviously isn't 
accounting for the work-around implemented to retrieve the BGRT on ia32.

Looking at the commit message associated with 
arch/x86/platform/efi/efi-bgrt.c

It's pretty obvious the mapping of boot code/data was done to facilitate 
BGRT.

Since the EFI memory map I'm using is clean - below - there's no reason 
for us to map the boot code/data.

> Most (all?) boot loaders mark EFI_BOOT_SERVICES_{CODE,DATA} as E820_RAM,
> which is why ioremap() complained about you trying to ioremap() a page
> of RAM.

But they aught to. It's entirely legitimate for the run-time to reclaim 
this memory - since after ExitBootServices() - none of the code/data 
inside of EFI_BOOT_SERVICES is of any use.

Caveat being the work-around that was done for BGRT.

They do this because after efi_free_boot_services() we want
> these regions to be available for general allocation.

Agree.

> On x86-64 you rarely hit the ioremap() path because all RAM regions are
> mapped by the kernel direct mapping, e.g __va() works on those
> addresses. On i386, with its reduced virtual address space, it's much
> more likely that those addresses are not part of the direct mapping, and
> so this is the chunk of code that causes problems in
> efi_enter_virtual_mode(),
>
>                  start_pfn = PFN_DOWN(md->phys_addr);
>                  end_pfn = PFN_UP(end);
>                  if (pfn_range_is_mapped(start_pfn, end_pfn)) {
>                          va = __va(md->phys_addr);
>
>                          if (!(md->attribute&  EFI_MEMORY_WB))
>                                  efi_memory_uc((u64)(unsigned long)va, size);
>                  } else
>                          va = efi_ioremap(md->phys_addr, size,
>                                           md->type, md->attribute);

Yes it fails sanity checking in efi_ioremap::__ioremap_caller on an 
"is_ram()" call.

> What we probably need is an i386-specific implementation of
> efi_ioremap() that checks to see whether we're mapping a RAM region. I
> thought of maybe using the kmap_high() functions, but I don't think
> repeated calls to the kmap*() functions are guaranteed to provide
> consecutive virtual addresses, and I doubt free_bootmem() (called from
> efi_free_boot_services()) understands kmap'd addresses.

That's one solution - you'd need to make the i386::efi_ioremap() aware 
of the BGRT work-around.

Presumably this work-around is also required on ia64 too.

> Maybe we should hot-add the EFI_BOOT_SERVICES_* regions once we've
> finished with them and only then mark them as RAM?
>
> x86 folks? Halp?
>
>> On systems that do not have a BGRT object, there's no reason to map this
>> memory in efi_enter_virtual_mode. This patch searches for the BGRT
>> object and if found - will continue to map the boot services memory,
>> else only memory with attribute EFI_RUNTIME_MEMORY will be mapped.
>
> Like I said above, it just so happens on your machine that a BGRT object
> occupies that chunk of memory, but this might not be the case on every
> EFI i386 machine. You may have other useful things in that region that
> you want to be mapped. It's also entirely possible that someone with the
> same memory map layout as you _will_ want the bgrt image mapped. This
> code needs fixing, instead of just working around the problem.

No, no - we *don't* have a BGRT object at all.

We have a completely clean memory map - but the BGRT code is causing the 
is_ram() failure.

Rather than just blow away the BGRT code the patch determines if a BGRT 
object exists.

If there is an ACPI::BGRT - then efi_enter_virtual_mode - will still 
continue to map EFI_BOOT_SERVICES*

If not then you get this

if (md->attribute & EFI_MEMORY_RUNTIME) {
	/* Only map EFI_RUNTIME_MEMORY here */
}

Which is what everybody who is !ACPI::BGRT really wants.

I've coded up a precautionary alternate version of the patch that passes 
a kernel parameter to switch off the offending code, though it would 
probably be better to pass a kernel parameter to switch it on !

Though that would require modification of the kernel command line for 
any system that currently relies on BGRT - so unfortunately I think 
switching off the - I hate to use the bug - seems the less 
user-impacting method.

I'll send this patch for reference - but, I do believe probing for BGRT 
is more appropriate than forcing a kernel parameter addition.

I think even if you make an i386 version of efi_ioremap() you still need 
to address the fundamental problem that only systems which want to 
implement the ACPI::BGRT work-around care about mapping 
EFI_BOOT_SERVICES, unless I've missed a trick here ?


Bryan
