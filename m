Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3HMOWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:22:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50937 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756428Ab3HMOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:22:10 -0400
Date: Tue, 13 Aug 2013 15:21:33 +0100
From: Dave P Martin <Dave.Martin@arm.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 16/17] Add EFI stub for ARM
Message-ID: <20130813142133.GF2671@e103592.cambridge.arm.com>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
 <1375847113-24884-17-git-send-email-roy.franz@linaro.org>
 <20130807180548.GA12592@localhost.localdomain>
 <CAFECyb-aAHk0RzBGPmGOhRkm8=chwyAM=DdwE=6Z4VLR9sqFRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb-aAHk0RzBGPmGOhRkm8=chwyAM=DdwE=6Z4VLR9sqFRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 10:57:29PM +0100, Roy Franz wrote:
> On Wed, Aug 7, 2013 at 11:05 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> > On Tue, Aug 06, 2013 at 08:45:12PM -0700, Roy Franz wrote:
> >> This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
> >> operations similarly to the x86 stub: it is a shim between the EFI firmware
> >> and the normal zImage entry point, and sets up the environment that the
> >> zImage is expecting.  This includes loading the initrd (optionaly) and
> >> device tree from the system partition based on the kernel command line.
> >> The stub updates the device tree as necessary, including adding reserved
> >> memory regions and adding entries for EFI runtime services. The PE/COFF
> >> "MZ" header at offset 0 results in the first instruction being an add
> >> that corrupts r5, which is not used by the zImage interface.
> >
> > Some more comments below ... note that I haven't really looked at the C
> > code in depth.
> 
> Responses below, and I'm working on incorporating suggested changes
> for the next version.

I few responses-to-responses from me inline.  Your repose supersedes
most of this anyhow.

Cheers
---Dave

> 
> Thanks,
> Roy
> 
> >
> > Cheers
> > ---Dave
> >
> >>
> >> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> >> ---
> >>  arch/arm/boot/compressed/Makefile     |   18 +-
> >>  arch/arm/boot/compressed/efi-header.S |  114 ++++++++
> >>  arch/arm/boot/compressed/efi-stub.c   |  514 +++++++++++++++++++++++++++++++++
> >>  arch/arm/boot/compressed/head.S       |   90 +++++-
> >>  4 files changed, 728 insertions(+), 8 deletions(-)
> >>  create mode 100644 arch/arm/boot/compressed/efi-header.S
> >>  create mode 100644 arch/arm/boot/compressed/efi-stub.c
> >>
> >> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> >> index 7ac1610..c62826a 100644
> >> --- a/arch/arm/boot/compressed/Makefile
> >> +++ b/arch/arm/boot/compressed/Makefile
> >> @@ -106,8 +106,22 @@ $(addprefix $(obj)/,$(libfdt) $(libfdt_hdrs)): $(obj)/%: $(srctree)/scripts/dtc/
> >>  $(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
> >>       $(addprefix $(obj)/,$(libfdt_hdrs))
> >>
> >> +$(addprefix $(obj)/,$(libfdt_objs) efi-stub.o): \
> >> +     $(addprefix $(obj)/,$(libfdt_hdrs))
> >> +
> >
> > Don't we make $(libfdt_objs) depend on $(libfdt_hdrs) twice, now?
> >
> > Would it make sense just to add efi-stub.o to the list of targets in the
> > original rule?
> 
> Yes, change made.
> >
> >>  ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
> >> -OBJS += $(libfdt_objs) atags_to_fdt.o
> >> +OBJS += atags_to_fdt.o
> >> +USE_LIBFDT = y
> >> +endif
> >> +
> >> +ifeq ($(CONFIG_EFI_STUB),y)
> >> +CFLAGS_efi-stub.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
> >> +OBJS += efi-stub.o
> >> +USE_LIBFDT = y
> >> +endif
> >> +
> >> +ifeq ($(USE_LIBFDT),y)
> >> +OBJS += $(libfdt_objs)
> >>  endif
> >>
> >>  targets       := vmlinux vmlinux.lds \
> >> @@ -125,7 +139,7 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
> >>  KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
> >>  endif
> >>
> >> -ccflags-y := -fpic -mno-single-pic-base -fno-builtin -I$(obj)
> >> +ccflags-y := -fpic -mno-single-pic-base -fno-builtin -I$(obj) -fno-stack-protector
> >
> > You don't appear to explain this change anywhere.
> 
> Prior to my changes, even though the stack protector was not disabled,
> it was not actually used. GCC uses a heuristic
> based on the size of the stack whether to enable the stack protector,
> and the threshold to trigger its use was not met, so no stack checking
> was actually being done.  In order to do stack protection, a few
> __stack_chk_* functions/variable need to be provided by the
> application.  I worked a bit on adding these, but could not get them
> working in the stub/decompressor.  The x86 arch also has
> "-fno-stack-protector" defined for its compressed boot stub, so I
> decided to go that route as well.
> 
> >
> >>  asflags-y := -DZIMAGE
> >>
> >>  # Supply kernel BSS size to the decompressor via a linker symbol.
> >> diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
> >> new file mode 100644
> >> index 0000000..6ff32cc
> >> --- /dev/null
> >> +++ b/arch/arm/boot/compressed/efi-header.S
> >> @@ -0,0 +1,114 @@
> >> +@ Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
> >> +@
> >> +@ This file contains the PE/COFF header that is part of the
> >> +@ EFI stub.
> >> +@
> >> +
> >> +     .org    0x3c
> >> +     @
> >> +     @ The PE header can be anywhere in the file, but for
> >> +     @ simplicity we keep it together with the MSDOS header
> >> +     @ The offset to the PE/COFF header needs to be at offset
> >> +     @ 0x3C in the MSDOS header.
> >> +     @ The only 2 fields of the MSDOS header that are used are this
> >> +     @ PE/COFF offset, and the "MZ" bytes at offset 0x0.
> >> +     @
> >> +     .long   pe_header                       @ Offset to the PE header.
> >
> > Is there any chance of merging this with the equivalent x86 code?
> >
> > The PE/COFF header is much the same in both cases, although there
> > are some differences.  Maybe it would be more trouble than it is
> > worth...
> 
> I think it would be more pain than gain.  We are planning to add arm64 stub
> support next, so we'd end up with 4 architectures sharing this assembly file,
> which I think would be painful from a patch submission/review point of view.
> 
> >
> >> +
> >> +      .align 3
> >> +pe_header:
> >> +
> >> +
> >> +pe_header:
> >
> > Duplicate label?
> 
> Yup, fixed.
> >
> >> +     .ascii  "PE"
> >> +     .short  0
> >> +
> >> +coff_header:
> >> +     .short  0x01c2                          @ ARM or Thumb
> >> +     .short  2                               @ nr_sections
> >> +     .long   0                               @ TimeDateStamp
> >> +     .long   0                               @ PointerToSymbolTable
> >> +     .long   1                               @ NumberOfSymbols
> >> +     .short  section_table - optional_header @ SizeOfOptionalHeader
> >> +     .short  0x306                           @ Characteristics.
> >> +                                             @ IMAGE_FILE_32BIT_MACHINE |
> >> +                                             @ IMAGE_FILE_DEBUG_STRIPPED |
> >> +                                             @ IMAGE_FILE_EXECUTABLE_IMAGE |
> >> +                                             @ IMAGE_FILE_LINE_NUMS_STRIPPED
> >> +
> >> +optional_header:
> >> +     .short  0x10b                           @ PE32 format
> >> +     .byte   0x02                            @ MajorLinkerVersion
> >> +     .byte   0x14                            @ MinorLinkerVersion
> >> +
> >> +     .long   0                               @ SizeOfCode
> >
> > Do we need to fill in SizeOfCode with a real value?  It looks like x86
> > does.
> >
> > We should probably fill this in unless there's a documented ABI for EFI
> > boot on ARM which explicitly doesn't require these.
> 
> I will investigate/fix this.
> 
> >
> >> +
> >> +     .long   0                               @ SizeOfInitializedData
> >> +     .long   0                               @ SizeOfUninitializedData
> >> +
> >> +     .long   efi_stub_entry                  @ AddressOfEntryPoint
> >> +     .long   efi_stub_entry                  @ BaseOfCode
> >> +     .long   0                               @ data
> >> +
> >> +extra_header_fields:
> >> +     .long   0                               @ ImageBase
> >> +     .long   0x20                            @ SectionAlignment
> >> +     .long   0x20                            @ FileAlignment
> >> +     .short  0                               @ MajorOperatingSystemVersion
> >> +     .short  0                               @ MinorOperatingSystemVersion
> >> +     .short  0                               @ MajorImageVersion
> >> +     .short  0                               @ MinorImageVersion
> >> +     .short  0                               @ MajorSubsystemVersion
> >> +     .short  0                               @ MinorSubsystemVersion
> >> +     .long   0                               @ Win32VersionValue
> >> +
> >> +     .long   _edata                          @ SizeOfImage
> >> +
> >> +     @ Everything before the entry point is considered part of the header
> >> +     .long   efi_stub_entry                  @ SizeOfHeaders
> >> +     .long   0                               @ CheckSum
> >> +     .short  0xa                             @ Subsystem (EFI application)
> >> +     .short  0                               @ DllCharacteristics
> >> +     .long   0                               @ SizeOfStackReserve
> >> +     .long   0                               @ SizeOfStackCommit
> >> +     .long   0                               @ SizeOfHeapReserve
> >> +     .long   0                               @ SizeOfHeapCommit
> >> +     .long   0                               @ LoaderFlags
> >> +     .long   0x0                             @ NumberOfRvaAndSizes
> >> +
> >> +     # Section table
> >> +section_table:
> >> +
> >> +     #
> >> +     # The EFI application loader requires a relocation section
> >> +     # because EFI applications must be relocatable.  This is a
> >> +     # dummy section as far as we are concerned.
> >> +     #
> >> +     .ascii  ".reloc"
> >> +     .byte   0
> >> +     .byte   0                       @ end of 0 padding of section name
> >> +     .long   0
> >> +     .long   0
> >> +     .long   0                       @ SizeOfRawData
> >> +     .long   0                       @ PointerToRawData
> >> +     .long   0                       @ PointerToRelocations
> >> +     .long   0                       @ PointerToLineNumbers
> >> +     .short  0                       @ NumberOfRelocations
> >> +     .short  0                       @ NumberOfLineNumbers
> >> +     .long   0x42100040              @ Characteristics (section flags)
> >> +
> >> +
> >> +     .ascii  ".text"
> >> +     .byte   0
> >> +     .byte   0
> >> +     .byte   0                       @ end of 0 padding of section name
> >> +     .long   _edata - efi_stub_entry         @ VirtualSize
> >> +     .long   efi_stub_entry                  @ VirtualAddress
> >> +     .long   _edata - efi_stub_entry         @ SizeOfRawData
> >> +     .long   efi_stub_entry                  @ PointerToRawData
> >> +
> >> +     .long   0               @ PointerToRelocations (0 for executables)
> >> +     .long   0               @ PointerToLineNumbers (0 for executables)
> >> +     .short  0               @ NumberOfRelocations  (0 for executables)
> >> +     .short  0               @ NumberOfLineNumbers  (0 for executables)
> >> +     .long   0xe0500020      @ Characteristics (section flags)
> >
> > Can you explain why x86 needs an extra section (the .setup thing)?
> > I haven't dug into that in enough detail to understand it yet...
> 
> I will look into that, I don't know off hand.  I simplified the header
> for ARM as much as I could
> for booting with EDK2.
> >
> >> diff --git a/arch/arm/boot/compressed/efi-stub.c b/arch/arm/boot/compressed/efi-stub.c
> >> new file mode 100644
> >> index 0000000..b817ea3
> >> --- /dev/null
> >> +++ b/arch/arm/boot/compressed/efi-stub.c
> >> @@ -0,0 +1,514 @@
> >> +/*
> >> + * linux/arch/arm/boot/compressed/efi-stub.c
> >> + *
> >> + * Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
> >> + *
> >> + * This file implements the EFI boot stub for the ARM kernel
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + */
> >> +#include <linux/efi.h>
> >> +#include <libfdt.h>
> >> +
> >> +
> >> +/* Error code returned to ASM code instead of valid FDT address. */
> >> +#define EFI_STUB_ERROR               (~0)
> >
> > Can we put that into a suitable hedaer and use it in compressed/head.S,
> > instead of the magic 0xffffffff?  (Assuming that value is supposed to
> > match EFI_STUB_ERROR)
> 
> Yes, I will do this.
> >
> >> +
> >> +/* EFI function call wrappers.  These are not required for
> >> + * ARM, but wrappers are required for X86 to convert between
> >> + * ABIs.  These wrappers are provided to allow code sharing
> >> + * between X86 and ARM.  Since these wrappers directly invoke the
> >> + * EFI function pointer, the function pointer type must be properly
> >> + * defined, which is not the case for X86  One advantage of this is
> >> + * it allows for type checking of arguments, which is not
> >> + * possible with the X86 wrappers.
> >> + */
> >> +#define efi_call_phys0(f)                    f()
> >> +#define efi_call_phys1(f, a1)                        f(a1)
> >> +#define efi_call_phys2(f, a1, a2)            f(a1, a2)
> >> +#define efi_call_phys3(f, a1, a2, a3)                f(a1, a2, a3)
> >> +#define efi_call_phys4(f, a1, a2, a3, a4)    f(a1, a2, a3, a4)
> >> +#define efi_call_phys5(f, a1, a2, a3, a4, a5)        f(a1, a2, a3, a4, a5)
> >> +
> >> +/* The maximum uncompressed kernel size is 32 MBytes, so we will reserve
> >> + * that for the decompressed kernel.  We have no easy way to tell what
> >> + * the actuall size of code + data the uncompressed kernel will use.
> >> + */
> >> +#define MAX_UNCOMP_KERNEL_SIZE       0x02000000
> >
> > Can we fish the decompressed data size out of zImage, like the existing
> > zImage code does?  (see compressed/head.S:207).  I don't see why this
> > needs to be compile-time constant.
> 
> I am attempting to make sure all the memory used is accounted for in
> the EFI memory map,
> so I care not only about the uncompressed size, but also the BSS.  If
> I get the uncompressed
> image size, and use that for the allocation, the kernel will overwrite
> memory immediately following it.
> I had implemented what you suggested and ran into this problem.

Hmmm, it looks like I misunderstood what gets appended to the compressed
data.

However, it looks like the size of the kernel's bss is also made
available, via a link-time symbol _kernel_bss_size:

	KBSS_SZ = $(shell $(CROSS_COMPILE)size $(obj)/../../../../vmlinux | \
	                awk 'END{print $$3}')
	LDFLAGS_vmlinux = --defsym _kernel_bss_size=$(KBSS_SZ)

You could get at that by

	extern char _kernel_bss_size;

	/* ... */

	 ... (unsigned long)&_kernel_bss_size ...

> 
> >
> > Someday, someone may try to grow the kernel image beyond 32M.  It would
> > be nice to keep the number of things that breaks to a minimum, to ease
> > potential pain later.
> 
> I picked 32 MBytes based on some discussions of the boot process, and
> my understanding
> is that 32 MBytes is a somewhat hard upper limit on kernel size.

I guess we can address this one as and when.

I suspect that growth beyond 32MB may happen eventually, but it's
going to involve a bit of pain whatever.

So long as efi_stub barfs if the decompressed kernel + BSS doesn't
fit in the available space (you can refer to _kernel_bss_size to
check that).

> 
> >
> >> +
> >> +/* The kernel zImage should be located between 32 Mbytes
> >> + * and 128 MBytes from the base of DRAM.  The min
> >> + * address leaves space for a maximal size uncompressed image,
> >> + * and the max address is due to how the zImage decompressor
> >> + * picks a destination address.
> >> + */
> >> +#define MAX_ZIMAGE_OFFSET    0x08000000
> >
> > The maximum zImage offset is actually 1 less than this.  I think it's
> > just the name of the macro that is misleading, since you use it
> > correctly as an upper bound for memory allocation, so far as I can
> > see.
> >
> > Maybe ZIMAGE_OFFSET_LIMIT or something similar would work.
> 
> I'll rename this.
> 
> >
> >> +#define MIN_ZIMAGE_OFFSET    MAX_UNCOMP_KERNEL_SIZE
> >> +
> >> +#define MAX_CMDLINE_LEN              500
> >
> > This is a random looking number.  Is this supposed to match something
> > somewhere?  Does it serve any purpose other than acting as a sanity
> > limit?
> >
> > If this limit doesn't exist, then an unreasonably large command-line
> > passed by EFI would just lead to a memory allocation failure somewhere,
> > which feels like the right behaviour...
> >
> > If we can avoid building in arbitrary limits, it helps avoid surprises
> > later.
> 
> 
> This is just a sanity check, which should be easy to remove.  I think
> the failure mode will be a huge device tree being created,
> rather than an allocation failure.  In reality I think the limit will
> set by the EFI firmware - I doubt it is possible to pass a
> multi-megabyte command line.
> 
> >
> >> +
> >> +struct fdt_region {
> >> +     u64 base;
> >> +     u64 size;
> >> +};
> >> +
> >> +/*
> >> + * Additional size that could be used for FDT entries added by
> >> + * the UEFI OS Loader Estimation based on:
> >> + * EDID (300bytes) + bootargs  + initrd region (20bytes)
> >> + * + system memory region (20bytes) + mp_core entries (200
> >> + * bytes)
> >> + */
> >
> > What does 0x300 have to do with those numbers?
> >
> > When you say "estimate", are we guaranteed never to exceed that?
> > What happens if we do?
> 
> No guarantees, and we fail to boot if we run out of space in the new
> device tree.  This greatly simplifies the code,
> but I agree that it is not that nice.
> 
> >
> >> +#define FDT_ADDITIONAL_ENTRIES_SIZE     (0x300 + MAX_CMDLINE_LEN)
> >> +
> >> +/* Include shared EFI stub code */
> >> +#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
> >> +
> >> +
> >> +static int is_linux_reserved_region(int memory_type)
> >> +{
> >> +     switch (memory_type) {
> >> +     case EFI_RUNTIME_SERVICES_CODE:
> >> +     case EFI_RUNTIME_SERVICES_DATA:
> >> +     case EFI_UNUSABLE_MEMORY:
> >> +     case EFI_ACPI_RECLAIM_MEMORY:
> >> +     case EFI_ACPI_MEMORY_NVS:
> >> +             return 1;
> >> +     default:
> >> +             return 0;
> >> +     }
> >> +}
> >> +
> >> +
> >> +static int relocate_kernel(efi_system_table_t *sys_table,
> >> +                        unsigned long *load_addr, unsigned long *load_size,
> >> +                        unsigned long min_addr, unsigned long max_addr)
> >> +{
> >> +     /* Get current address of kernel. */
> >> +     unsigned long cur_zimage_addr = *load_addr;
> >> +     unsigned long zimage_size = *load_size;
> >> +     unsigned long new_addr = 0;
> >> +     unsigned long nr_pages;
> >> +
> >> +     efi_status_t status;
> >> +
> >> +     if (!load_addr || !load_size)
> >> +             return EFI_INVALID_PARAMETER;
> >> +
> >> +     *load_size = 0;
> >> +     if (cur_zimage_addr > min_addr
> >> +         && (cur_zimage_addr + zimage_size) < max_addr) {
> >> +             /* We don't need to do anything, as kernel at an acceptable
> >> +              * address already.
> >> +              */
> >> +             return EFI_SUCCESS;
> >> +     }
> >> +     /*
> >> +      * The EFI firmware loader could have placed the kernel image
> >> +      * anywhere in memory, but the kernel has restrictions on the
> >> +      * min and max physical address it can run at.
> >> +      */
> >> +     nr_pages = round_up(zimage_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> >
> > It looks like nr_pages is never used in this function.
> 
> Yup, removed.
> >
> >> +
> >> +     status = efi_low_alloc(sys_table, zimage_size, 0,
> >> +                        &new_addr, min_addr);
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "Failed to alloc memory for kernel.\n");
> >
> > Does efi_printk automatically prepend a suitable prefix?  If not,
> > it might be useful to define a macro to add a standard prefix to all
> > efi_printks here ("zImage: " or similar).
> 
> It doesn't, but I can add one.  Maybe "EFIstub"?  This is really
> separate from the zImage boot, so I think
> it would be helpful to differentiate it.

Sure, just something to disambiguate it.

> >
> > Minor nit: can we have "allocate" instead of "alloc"?
> Sure.
> >
> > I think both messages should say "failed to allocate usable memory".
> > EFI has already allocated memory for the kernel after all: it's
> > just in the wrong place initially.
> >
> >> +             return status;
> >> +     }
> >> +
> >> +     if (new_addr > (max_addr - zimage_size)) {
> >> +             efi_free(sys_table, zimage_size, new_addr);
> >> +             efi_printk(sys_table, "Failed to alloc usable memory for kernel.\n");
> >> +             return EFI_INVALID_PARAMETER;
> >> +     }
> >> +
> >> +     /* We know source/dest won't overlap since both memory ranges
> >> +      * have been allocated by UEFI, so we can safely use memcpy.
> >> +      */
> >> +     memcpy((void *)new_addr, (void *)(unsigned long)cur_zimage_addr,
> >> +            zimage_size);
> >
> > Is it possible for this allocation to fail -- i.e., because UEFI has
> > put us in an unsuitable location which is within the first 128MB of
> > RAM, such that we can't pick a suitable location without overlap?
> 
> I think so, since (in theory at least), other EFI applications could have run
> before us and allocated arbitrary amounts of memory.
> 
> >
> > For the time being though, I think this is impossible because the
> > decompressed Image can't exceed ~32MB (so the zImage should not
> > exceed that either, and both can fit inside 128MB.  It doesn't
> > matter if UEFI's initial load location overlaps the decompressed
> > Image).
> 
> The reason I am avoiding the zImage overlapping the decompressed image
> even though
> the zImage decompressor handles that case is that I want to ensure that
> all memory used during early boot is represented in the EFI memory map.
> By avoiding overlap, I only have to deal with predicting the final
> destination of the
> decompressed kernel.

I guess that makes sense.  If it becomes a constraint, it can be fixed
later, but that probably won't happen for a while.

> 
> >
> > If UEFI put reserved regions with the first 128MB we're likely to
> > be dead anyway, so we shouldn't assume we'll have to cope with that
> > for now...
> 
> For these cases I'd like to be able to return an error message and
> refuse to boot, rather
> than dying during boot.
> 
> In principle, I like the EFI stub being a shim between the EFI
> firmware and the normal zImage boot.  In practice,
> I don't really like having to predict/guess what memory the zImage
> decompressor will use so that we can account for that
> in the EFI memory map.

zImage already suffers from that: you "just have to know" how to
arrange the zImage, initramfs and dtb, per board and per bootlodaer.
AUTO_ZRELADDR provides some extra flexibility, but there are still
arbitrary, unknown constraints which prevent for bootloader from
doing the right thing automatically.

efi_stub should avoid being worse than that, but if we can have
cleaner failures, that's definitely a bonus.

> 
> >
> >> +
> >> +     /* Return the load address and size */
> >> +     *load_addr = new_addr;
> >> +     *load_size = zimage_size;
> >
> > Is zimage_size ever changed?  It looks like it is still equal to the
> > initial value of *load_size at this point.
> 
> Nope, I can get rid of zimage_size and just use *load_size throughout.
> 
> >
> >> +
> >> +
> >> +     return status;
> >> +}
> >> +
> >> +
> >> +/* Convert the unicode UEFI command line to ASCII to pass to kernel.
> >> + * Size of memory allocated return in *cmd_line_len.
> >> + * Returns NULL on error.
> >> + */
> >> +static char *convert_cmdline_to_ascii(efi_system_table_t *sys_table,
> >> +                                   efi_loaded_image_t *image,
> >> +                                   unsigned long *cmd_line_len,
> >> +                                   u32 max_addr)
> >> +{
> >> +     u16 *s2;
> >> +     u8 *s1 = NULL;
> >> +     unsigned long cmdline_addr = 0;
> >> +     int load_options_size = image->load_options_size / 2; /* ASCII */
> >> +     void *options = (u16 *)image->load_options;
> >> +     int options_size = 0;
> >> +     int status;
> >> +     int i;
> >> +     u16 zero = 0;
> >> +
> >> +     if (options) {
> >> +             s2 = options;
> >> +             while (*s2 && *s2 != '\n' && options_size < load_options_size) {
> >> +                     s2++;
> >> +                     options_size++;
> >> +             }
> >> +     }
> >> +
> >> +     if (options_size == 0) {
> >> +             /* No command line options, so return empty string*/
> >> +             options_size = 1;
> >> +             options = &zero;
> >> +     }
> >> +
> >> +     if (options_size > MAX_CMDLINE_LEN)
> >> +             options_size = MAX_CMDLINE_LEN;
> >> +
> >> +     options_size++;  /* NUL termination */
> >
> > Do we care that options_size can now be > load_options_size?
> >
> > I guess image->load_options isn't realistically going to be right at
> > the end of a RAM bank, so probably nothing disastrous will happen if
> > we read off the end of it.
> >
> > It would be tidier to avoid this, though.
> 
> I'll update this to avoid reading past the end of the EFI option string.

OK, fine

> >
> >> +
> >> +     status = efi_high_alloc(sys_table, options_size, 0,
> >> +                         &cmdline_addr, max_addr);
> >> +     if (status != EFI_SUCCESS)
> >> +             return NULL;
> >> +
> >> +     s1 = (u8 *)(unsigned long)cmdline_addr;
> >> +     s2 = (u16 *)options;
> >> +
> >> +     for (i = 0; i < options_size - 1; i++)
> >> +             *s1++ = *s2++;
> >> +
> >> +     *s1 = '\0';
> >> +
> >> +     *cmd_line_len = options_size;
> >> +     return (char *)(unsigned long)cmdline_addr;
> >> +}
> >> +
> >> +static u32 update_fdt_and_exit_boot(efi_system_table_t *sys_table,
> >> +                                 void *handle, unsigned long dram_base,
> >> +                                 void *orig_fdt, u64 *orig_fdt_size,
> >> +                                 char *cmdline_ptr,
> >> +                                 unsigned long *cmdline_size,
> >> +                                 u64 initrd_addr, u64 initrd_size)
> >> +{
> >> +     unsigned long new_fdt_size;
> >> +     unsigned long new_fdt_addr;
> >> +     void *fdt;
> >> +     int node;
> >> +     int status;
> >> +     int i;
> >> +     unsigned long map_size, desc_size;
> >> +     unsigned long mmap_key;
> >> +     efi_memory_desc_t *memory_map;
> >> +     unsigned long fdt_val;
> >> +
> >> +     new_fdt_size = *orig_fdt_size + FDT_ADDITIONAL_ENTRIES_SIZE;
> >> +     status = efi_high_alloc(sys_table, new_fdt_size, 0, &new_fdt_addr,
> >> +                         dram_base + MAX_ZIMAGE_OFFSET);
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "ERROR: Unable to allocate memory for new device tree.\n");
> >> +             goto fail;
> >> +     }
> >
> > There are too many error messages in this function (and elsewhere).
> > Many of them are only useful for debugging: for real use, the only
> > interesting kinds of failure for the DT which will be meaningful to the
> > user are "bad device tree" and "out of memory".
> >
> > Also, it would be desirable to make the error messages more consistent;
> > currently we have "Failed to foo", "ERROR: bar", "ERROR moo", "Error baz",
> > and more.
> >
> > We also have "FDT", "fdt", "DTB", "Device Tree", "device tree", all of
> > which mean basically the same thing.
> >
> > You could try wrapping fdt_setprop() with a function which tries to set
> > the property and prints a suitable message if it fails, without having
> > to put explicit efi_printks all over the place.
> 
> I will review all of the messages, and add a consistent prefix as you
> suggested above.

OK (I confess to being a bit pedantic here)

> >
> >> +
> >> +
> >> +     fdt = (void *)new_fdt_addr;
> >> +     status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
> >> +     if (status != 0) {
> >> +             efi_printk(sys_table, "ERROR: Device Tree open_int failed.\n");
> >> +             goto fail_free_new_fdt;
> >> +     }
> >> +     /* We are done with the original DTB, so free it. */
> >> +     efi_free(sys_table, *orig_fdt_size, (u32)orig_fdt);
> >> +     *orig_fdt_size = 0;
> >> +
> >> +     node = fdt_subnode_offset(fdt, 0, "chosen");
> >> +     if (node < 0) {
> >> +             node = fdt_add_subnode(fdt, 0, "chosen");
> >> +             if (node < 0) {
> >> +                     efi_printk(sys_table, "Error on finding 'chosen' node\n");
> >> +                     goto fail_free_new_fdt;
> >> +             }
> >> +     }
> >> +
> >> +     if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
> >> +             status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
> >> +                                  strlen(cmdline_ptr) + 1);
> >> +             if (status) {
> >> +                     efi_printk(sys_table, "Failed to set new bootarg\n");
> >> +                     goto fail_free_new_fdt;
> >> +             }
> >> +     }
> >> +     /* We are done with original command line, so free it. */
> >> +     efi_free(sys_table, *cmdline_size, (u32)cmdline_ptr);
> >> +     *cmdline_size = 0;
> >> +
> >> +     /* Set intird address/end in device tree, if present */
> >> +     if (initrd_size != 0) {
> >> +             u64 initrd_image_end;
> >> +             u64 initrd_image_start = cpu_to_fdt64(initrd_addr);
> >> +             status = fdt_setprop(fdt, node, "linux,initrd-start",
> >> +                                  &initrd_image_start, sizeof(u64));
> >> +             if (status) {
> >> +                     efi_printk(sys_table, "Failed to set new 'linux,initrd-start'\n");
> >> +                     goto fail_free_new_fdt;
> >> +             }
> >> +             initrd_image_end = cpu_to_fdt64(initrd_addr + initrd_size);
> >> +             status = fdt_setprop(fdt, node, "linux,initrd-end",
> >> +                                  &initrd_image_end, sizeof(u64));
> >> +             if (status) {
> >> +                     efi_printk(sys_table, "Failed to set new 'linux,initrd-end'\n");
> >> +                     goto fail_free_new_fdt;
> >> +             }
> >> +     }
> >> +
> >> +     /* Update memory map in the device tree. The memory node must
> >> +      * be present in the tree.*/
> >> +     node = fdt_subnode_offset(fdt, 0, "memory");
> >> +     if (node < 0) {
> >> +             efi_printk(sys_table, "ERROR: FDT memory node does not exist in DTB.\n");
> >> +             goto fail_free_new_fdt;
> >> +     }
> >> +
> >> +     status = efi_get_memory_map(sys_table, &memory_map, &map_size,
> >> +                                 &desc_size, &mmap_key);
> >> +     if (status != EFI_SUCCESS)
> >> +             goto fail_free_new_fdt;
> >> +
> >> +     for (i = 0; i < (map_size / sizeof(efi_memory_desc_t)); i++) {
> >> +             efi_memory_desc_t *desc;
> >> +             unsigned long m = (unsigned long)memory_map;
> >> +             desc = (efi_memory_desc_t *)(m + (i * desc_size));
> >> +
> >> +             if (is_linux_reserved_region(desc->type)) {
> >> +                     status = fdt_add_mem_rsv(fdt, desc->phys_addr,
> >> +                                              desc->num_pages * EFI_PAGE_SIZE);
> >> +                     if (status != 0) {
> >> +                             efi_printk(sys_table, "ERROR: Failed to add 'memreserve' to fdt.\n");
> >> +                             goto fail_free_mmap;
> >> +                     }
> >> +             }
> >> +     }
> >> +
> >> +
> >> +     /* Add FDT entries for EFI runtime services in chosen node.
> >> +      * We need to add the final memory map, so this is done at
> >> +      * the very end.
> >> +      */
> >> +     node = fdt_subnode_offset(fdt, 0, "chosen");
> >> +     fdt_val = cpu_to_fdt32((unsigned long)sys_table);
> >> +     status = fdt_setprop(fdt, node, "efi-system-table",
> >> +                          &fdt_val, sizeof(fdt_val));
> >> +     if (status) {
> >> +             efi_printk(sys_table, "Failed to set new 'efi-system-table'\n");
> >> +             goto fail_free_new_fdt;
> >> +     }
> >> +     fdt_val = cpu_to_fdt32(desc_size);
> >> +     status = fdt_setprop(fdt, node, "efi-mmap-desc-size",
> >> +                          &fdt_val, sizeof(fdt_val));
> >> +     if (status) {
> >> +             efi_printk(sys_table, "Failed to set new 'efi-mmap-desc-size'\n");
> >> +             goto fail_free_new_fdt;
> >> +     }
> >> +     fdt_val = cpu_to_fdt32(map_size);
> >> +     status = fdt_setprop(fdt, node, "efi-runtime-mmap-size",
> >> +                          &fdt_val, sizeof(fdt_val));
> >> +     if (status) {
> >> +             efi_printk(sys_table, "Failed to set new 'efi-runtime-mmap-size'\n");
> >> +             goto fail_free_new_fdt;
> >> +     }
> >> +     fdt_val = cpu_to_fdt32((unsigned long)memory_map);
> >> +     status = fdt_setprop(fdt, node, "efi-runtime-mmap",
> >> +                          &fdt_val, sizeof(fdt_val));
> >> +     if (status) {
> >> +             efi_printk(sys_table, "Failed to set new 'efi-runtime-mmap'\n");
> >> +             goto fail_free_new_fdt;
> >> +     }
> >
> > We have one function doing two completely different jobs here (as
> > documented by the name).  Can it be split?
> 
> I had it split, but due to the address/size pairs that needed to be
> passed around
> to free the allocated memory on error I combined them.  I'll take
> another look at it.
> I think pulling the allocations out of the function may make this
> cleaner, and could
> also make the removal of the guessed new FTD size easier to remove.
> I'll need to handle
> re-trying the FTD allocation in order to gracefully handle significant
> growth in the DTB.
> 
> 
> >
> >> +
> >> +     /* Now we need to exit boot services.  We need the key from
> >> +      * the most recent read of the memory map to do this.  We can't
> >> +      * free this buffer in the normal case, but do free it when
> >> +      * exit_boot_services() fails or adding the memory map to the FDT
> >> +      * fails.
> >> +      */
> >> +     status = efi_call_phys2(sys_table->boottime->exit_boot_services,
> >> +                             handle, mmap_key);
> >> +
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "exit boot services failed.\n");
> >> +             goto fail_free_mmap;
> >> +     }
> >> +
> >> +     return new_fdt_addr;
> >> +
> >> +fail_free_mmap:
> >> +     efi_call_phys1(sys_table->boottime->free_pool, memory_map);
> >> +
> >> +fail_free_new_fdt:
> >> +     efi_free(sys_table, new_fdt_size, new_fdt_addr);
> >> +
> >> +fail:
> >> +     return 0;
> >> +}
> >> +
> >> +
> >> +int efi_entry(void *handle, efi_system_table_t *sys_table,
> >> +           unsigned long *zimage_addr)
> >> +{
> >> +     efi_loaded_image_t *image;
> >> +     int status;
> >> +     unsigned long nr_pages;
> >> +     const struct fdt_region *region;
> >> +
> >> +     void *fdt;
> >> +     int err;
> >> +     int node;
> >> +     unsigned long zimage_size = 0;
> >> +     unsigned long dram_base;
> >> +     /* addr/point and size pairs for memory management*/
> >> +     u64 initrd_addr;
> >> +     u64 initrd_size = 0;
> >> +     u64 fdt_addr;  /* Original DTB */
> >> +     u64 fdt_size = 0;
> >> +     u64 kernel_reserve_addr;
> >> +     u64 kernel_reserve_size = 0;
> >> +     char *cmdline_ptr;
> >> +     unsigned long cmdline_size = 0;
> >> +     unsigned long new_fdt_addr;
> >> +
> >> +     efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
> >> +
> >> +     /* Check if we were booted by the EFI firmware */
> >> +     if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
> >> +             goto fail;
> >> +
> >> +     efi_printk(sys_table, "Booting Linux using EFI stub.\n");
> >> +
> >> +
> >> +     /* get the command line from EFI, using the LOADED_IMAGE protocol */
> >> +     status = efi_call_phys3(sys_table->boottime->handle_protocol,
> >> +                             handle, &proto, (void *)&image);
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
> >> +             goto fail;
> >> +     }
> >> +
> >> +     /* We are going to copy this into device tree, so we don't care where in
> >> +      * memory it is.
> >> +      */
> >> +     cmdline_ptr = convert_cmdline_to_ascii(sys_table, image,
> >> +                                            &cmdline_size, 0xFFFFFFFF);
> >> +     if (!cmdline_ptr) {
> >> +             efi_printk(sys_table, "ERROR converting command line to ascii.\n");
> >> +             goto fail;
> >> +     }
> >> +
> >> +     /* We first load the device tree, as we need to get the base address of
> >> +      * DRAM from the device tree.  The zImage, device tree, and initrd
> >> +      * have address restrictions that are relative to the base of DRAM.
> >> +      */
> >> +     status = handle_cmdline_files(sys_table, image, cmdline_ptr, "dtb=",
> >> +                                   0xffffffff, &fdt_addr, &fdt_size);
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "Error loading dtb blob\n");
> >> +             goto fail_free_cmdline;
> >> +     }
> >> +
> >> +     err = fdt_check_header((void *)(unsigned long)fdt_addr);
> >> +     if (err != 0) {
> >> +             efi_printk(sys_table, "ERROR: Device Tree header not valid\n");
> >> +             goto fail_free_dtb;
> >> +     }
> >> +     if (fdt_totalsize((void *)(unsigned long)fdt_addr) > fdt_size) {
> >> +             efi_printk(sys_table, "ERROR: Incomplete device tree.\n");
> >> +             goto fail_free_dtb;
> >> +
> >> +     }
> >> +
> >> +
> >> +     /* Look up the base of DRAM from the device tree.*/
> >> +     fdt = (void *)(u32)fdt_addr;
> >> +     node = fdt_subnode_offset(fdt, 0, "memory");
> >> +     region = fdt_getprop(fdt, node, "reg", NULL);
> >> +     if (region) {
> >> +             dram_base = fdt64_to_cpu(region->base);
> >> +     } else {
> >> +             efi_printk(sys_table, "Error: no 'memory' node in device tree.\n");
> >> +             goto fail_free_dtb;
> >> +     }
> >> +
> >> +     /* Reserve memory for the uncompressed kernel image. */
> >> +     kernel_reserve_addr = dram_base;
> >> +     kernel_reserve_size = MAX_UNCOMP_KERNEL_SIZE;
> >> +     nr_pages = round_up(kernel_reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> >> +     status = efi_call_phys4(sys_table->boottime->allocate_pages,
> >> +                             EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
> >> +                             nr_pages, &kernel_reserve_addr);
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "ERROR allocating memory for uncompressed kernel.\n");
> >> +             goto fail_free_dtb;
> >> +     }
> >> +
> >> +     /* Relocate the zImage, if required. */
> >> +     zimage_size = image->image_size;
> >> +     status = relocate_kernel(sys_table, zimage_addr, &zimage_size,
> >> +                              dram_base + MIN_ZIMAGE_OFFSET,
> >> +                              dram_base + MAX_ZIMAGE_OFFSET);
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "Failed to relocate kernel\n");
> >> +             goto fail_free_kernel_reserve;
> >> +     }
> >> +
> >> +     status = handle_cmdline_files(sys_table, image, cmdline_ptr, "initrd=",
> >> +                                   dram_base + MAX_ZIMAGE_OFFSET,
> >> +                                   &initrd_addr, &initrd_size);
> >> +     if (status != EFI_SUCCESS) {
> >> +             efi_printk(sys_table, "Error loading initrd\n");
> >> +             goto fail_free_zimage;
> >> +     }
> >> +
> >> +     new_fdt_addr = update_fdt_and_exit_boot(sys_table, handle,
> >> +                                             dram_base, fdt, &fdt_size,
> >> +                                             cmdline_ptr, &cmdline_size,
> >> +                                             initrd_addr, initrd_size);
> >> +
> >> +     if (new_fdt_addr == 0) {
> >> +             efi_printk(sys_table, "Error updating device tree and exiting boot services.\n");
> >> +             goto fail_free_initrd;
> >> +     }
> >
> > Ideally, we shouldn't have one error message for two completely
> > different causes.
> >
> > The printk could move into update_fdt_and_exit_boot() and split
> > into more specific cases.
> >
> >> +
> >> +
> >> +     /* Now we need to return the FDT address to the calling
> >> +      * assembly to this can be used as part of normal boot.
> >> +      */
> >> +     return new_fdt_addr;
> >> +
> >> +fail_free_initrd:
> >> +     efi_free(sys_table, initrd_size, initrd_addr);
> >> +
> >> +fail_free_zimage:
> >> +     efi_free(sys_table, zimage_size, *zimage_addr);
> >> +
> >> +fail_free_kernel_reserve:
> >> +     efi_free(sys_table, kernel_reserve_addr, kernel_reserve_size);
> >> +
> >> +fail_free_dtb:
> >> +     efi_free(sys_table, fdt_size, fdt_addr);
> >> +
> >> +fail_free_cmdline:
> >> +     efi_free(sys_table, cmdline_size, (u32)cmdline_ptr);
> >> +
> >> +fail:
> >> +     return EFI_STUB_ERROR;
> >> +}
> >> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> >> index 75189f1..491e752 100644
> >> --- a/arch/arm/boot/compressed/head.S
> >> +++ b/arch/arm/boot/compressed/head.S
> >> @@ -120,21 +120,100 @@
> >>   */
> >>               .align
> >>               .arm                            @ Always enter in ARM state
> >> +             .text
> >>  start:
> >>               .type   start,#function
> >> -             .rept   7
> >> +#ifdef CONFIG_EFI_STUB
> >> +             @ Magic MSDOS signature for PE/COFF + ADD opcode
> >> +             .word   0x62805a4d
> >
> > Did you get a chance to respond to the endianness issue I raised?
> For now the EFI stub only supports LE, and I need to update
> the Kconfig to reflect this.  Adding BE should be possible, but I don't
> plan to work on that at this time.

OK, so long as that is made explicit in Kconfig, that sounds
reasonable.
> 
> 
> 
> >> +#else
> >> +             mov     r0, r0
> >> +#endif
> >> +             .rept   5
> >>               mov     r0, r0
> >>               .endr
> >> -   ARM(              mov     r0, r0          )
> >> -   ARM(              b       1f              )
> >> - THUMB(              adr     r12, BSYM(1f)   )
> >> - THUMB(              bx      r12             )
> >> +
> >> +             @ zimage_continue will be in ARM or thumb mode as configured
> >> + THUMB(              adrl    r12, BSYM(zimage_continue))
> >> + ARM(                adrl    r12, zimage_continue)
> >> +             bx      r12
> >
> > Note that BSYM() can be used both in ARM and Thumb kernels.
> >
> > In any case, ARM kernels cannot contain BX instructions because we still
> > support ARMv4 (which doesn't have it).
> >
> > I'm presuming you found zimage_continue is too far away for adr here,
> > which is why you changed it.  Assuming that't the case, this might make
> > sense:
> >
> >         adrl    r12, BSYM(zimage_continue)
> >  ARM(   mov     pc, r12 )
> >  THUMB( bx      r12     )
> 
> Yes, I changed this due to lack of range.
> 
> >
> >> + THUMB(              .thumb                  )
> >
> > For tidiness, it's better to avoid this dangling .thumb ... move it
> > to just before zimage_continue instead, since efi_stub_entry has to be
> > ARM anyway.
> 
> OK
> >
> >>
> >>               .word   0x016f2818              @ Magic numbers to help the loader
> >>               .word   start                   @ absolute load/run zImage address
> >>               .word   _edata                  @ zImage end address
> >> +
> >> +#ifdef CONFIG_EFI_STUB
> >> +             @ Portions of the MSDOS file header must be at offset
> >> +             @ 0x3c from the start of the file.  All PE/COFF headers
> >> +             @ are kept contiguous for simplicity.
> >> +#include "efi-header.S"
> >> +
> >> +efi_stub_entry:
> >> +             @ The EFI stub entry point is not at a fixed address, however
> >> +             @ this address must be set in the PE/COFF header.
> >> +             @ EFI entry point is in A32 mode, switch to T32 if configured.
> >> + THUMB(              .arm                    )
> >
> > ^So, you can lose .arm here too (but keep the comment -- that's valuable
> > info)
> >
> >> + THUMB(              adr     r12, BSYM(1f)   )
> >> + THUMB(              bx      r12             )
> >>   THUMB(              .thumb                  )
> >>  1:
> >> +             @ Save lr on stack for possible return to EFI firmware.
> >> +             @ Don't care about fp, but need 64 bit alignment....
> >> +             stmfd   sp!, {fp, lr}
> >> +
> >> +             @ Save args to EFI app across got fixup call
> >> +             stmfd   sp!, {r0, r1}
> >
> > Mostly minor coding nits follow...
> 
> I'll go through these and update the code.  I appreciate your review,
> as I am new to ARM assembly.

No problem -- it's already not far off.

I think my comments were all tidiness rather than correctness issues.

Cheers
---Dave

> 
> >
> >
> > stmfd sp!, {r0, r1, fp, lr} ?
> >
> >> +             ldmfd   sp!, {r0, r1}
> >> +
> >> +             @ allocate space on stack for return of new entry point of
> >> +             @ zImage, as EFI stub may copy the kernel.  Pass address
> >> +             @ of space in r2 - EFI stub will fill in the pointer.
> >> +
> >> +             sub     sp, #8                  @ we only need 4 bytes,
> >
> > I presume EFI guarantees a valid stack with 8-byte-aligned sp on entry?
> >
> > kernel asm is written in the traditional syntax, which means explicit
> > source and destination registers for instructions like this:
> >
> >         sub     sp, sp, #8
> >
> > Since the EFI stub code will only be built with new toolchains it
> > probably doesn't matter, but it's best to be consistent for readability
> > purposes.
> >
> >> +                                             @ but keep stack 8 byte aligned.
> >> +             mov     r2, sp
> >> +             @ Pass our actual runtime start address in pointer data
> >> +             adr     r11, LC0                @ address of LC0 at run time
> >> +             ldr     r12, [r11, #0]          @ address of LC0 at link time
> >> +
> >> +             sub     r3, r11, r12            @ calculate the delta offset
> >> +             str     r3, [r2, #0]
> >> +             bl      efi_entry
> >> +
> >> +             @ get new zImage entry address from stack, put into r3
> >> +             ldr     r3, [sp, #0]
> >> +             add     sp, #8  @ restore stack
> >
> >         add     sp, sp, #8
> >
> >> +
> >> +             @ Check for error return from EFI stub (0xFFFFFFFF)
> >> +             ldr     r1, =0xffffffff
> >
> > Minor nit, but ldr= is wasteful for this.
> >
> > You could use mvn r1, #0 (or mov r1, #0xffffffff -- the assembler is
> > smart enough to translate this)...
> >
> >> +             cmp     r0, r1
> >
> > ...alternatively, don't use r1 at all and do:
> >
> >         cmn     r0, #1
> >
> >> +             beq     efi_load_fail
> >> +
> >> +
> >> +             @ Save return values of efi_entry
> >> +             stmfd   sp!, {r0, r3}
> >> +             bl      cache_clean_flush
> >> +             bl      cache_off
> >
> > Why turn the cache off?  Does that mean that EFI may launch images with
> > the cache enabled?
> >
> > If so, are we guaranteed that VA=PA?  Otherwise simply turning the MMU
> > off is not safe.
> >
> > (Hmm, the UEFI spec seems to suggest "yes" for these questions)
> >
> >> +             ldmfd   sp!, {r0, r3}
> >> +
> >> +             @ put DTB address in r2, it was returned by EFI entry
> >> +             mov     r2, r0
> >> +             ldr     r1, =0xffffffff         @ DTB machine type
> >
> > mov/mvn: see above
> >
> >> +             mov     r0, #0  @ r0 is 0
> >
> > Useless comment: maybe say why you're doing this ("r0 is 0, as required
> > by the kernel boot protocol", or something like that).
> >
> >> +
> >> +             @ Branch to (possibly) relocated zImage entry that is in r3
> >> +             bx      r3
> >> +
> >> +efi_load_fail:
> >> +             @ Return EFI_LOAD_ERROR to EFI firmware on error.
> >> +             @ Switch back to ARM mode for EFI is done based on
> >> +             @ return address on stack
> >> +             ldr     r0, =0x80000001
> >> +             ldmfd   sp!, {fp, pc}
> >> +#endif
> >> +
> >> +zimage_continue:
> >>               mrs     r9, cpsr
> >>  #ifdef CONFIG_ARM_VIRT_EXT
> >>               bl      __hyp_stub_install      @ get into SVC mode, reversibly
> >> @@ -167,7 +246,6 @@ not_angel:
> >>                * by the linker here, but it should preserve r7, r8, and r9.
> >>                */
> >>
> >> -             .text
> >>
> >>  #ifdef CONFIG_AUTO_ZRELADDR
> >>               @ determine final kernel image address
> >> --
> >> 1.7.10.4
> >>
> >>
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
