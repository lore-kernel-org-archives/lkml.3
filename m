Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475Ab3DRNlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934480Ab3DRNlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:41:21 -0400
Date: Thu, 18 Apr 2013 09:40:59 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Message-ID: <20130418134059.GF18383@hansolo.jdub.homelinux.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <516EAC4A.6040202@console-pimps.org>
 <516F1B90.9040508@nexus-software.ie>
 <516FD24A.3070502@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516FD24A.3070502@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:00:26PM +0100, Matt Fleming wrote:
> On 17/04/13 23:00, Bryan O'Donoghue wrote:
> > In my mind the only memory that is relevant to efi_enter_virtual_mode is
> > memory that the BIOS has marked as EFI_RUNTIME_SERVICE
> > 
> > md->attribute & 0x80000000_00000000
> > 
> > I couldn't quite understand why the code in
> > 
> > arch/x86/platform/efi/efi.c:enter_virtual_mode() looks like this
> > 
> > for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> >                 md = p;
> >                 if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> >                     md->type != EFI_BOOT_SERVICES_CODE &&
> >                     md->type != EFI_BOOT_SERVICES_DATA)
> >             continue;
> > 
> > While the code in
> > 
> > arch/ia64/kernel/efi.c:enter_virtual_mode
> > 
> > for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
> >         md = p;
> >         if (md->attribute & EFI_MEMORY_RUNTIME) {
> > 
> > The ia64 version is consistent with the standard - but obviously isn't
> > accounting for the work-around implemented to retrieve the BGRT on ia32.
> > 
> > Looking at the commit message associated with
> > arch/x86/platform/efi/efi-bgrt.c
> > 
> > It's pretty obvious the mapping of boot code/data was done to facilitate
> > BGRT.
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
> > That's one solution - you'd need to make the i386::efi_ioremap() aware
> > of the BGRT work-around.
> > 
> > Presumably this work-around is also required on ia64 too.
> 
> No, we've never seen an ia64 firmware implementation with the "access
> EFI Boot Services Code/Data after ExitBootServices() bug", and it
> doesn't suffer from the same virtual address space limitations that i386
> does.
>  
> > No, no - we *don't* have a BGRT object at all.
> > 
> > We have a completely clean memory map - but the BGRT code is causing the
> > is_ram() failure.
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

Hm.  I'm probably the least clueful person to ask on this one.  Fedora
has a number of 32-bit bug reports, but we explicitly don't support
32-bit UEFI.

BGRT is a new addition in ACPI 5.0, right?  Hopefully with it being
relatively recent, and new 32-bit firmware being somewhat rare, it won't
be a problem.

josh
