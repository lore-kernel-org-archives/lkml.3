Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3LFB0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:26:05 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57996 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3LFB0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:26:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131205200054.ED87FC40785@trevor.secretlab.ca>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
	<1385595115-21488-5-git-send-email-roy.franz@linaro.org>
	<20131205200054.ED87FC40785@trevor.secretlab.ca>
Date: Thu, 5 Dec 2013 17:25:59 -0800
Message-ID: <CAFECyb-mYRx+5Lc-yWjcH2=4wYcgU7JLAWA7b32htBh7zGKLNQ@mail.gmail.com>
Subject: Re: [PATCH V5 4/6] Add EFI stub for ARM
From: Roy Franz <roy.franz@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 12:00 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Wed, 27 Nov 2013 15:31:53 -0800, Roy Franz <roy.franz@linaro.org> wrote:
>> This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
>> operates similarly to the x86 stub: it is a shim between the EFI firmware
>> and the normal zImage entry point, and sets up the environment that the
>> zImage is expecting.  This includes loading the initrd (optionaly) and
>> device tree from the system partition based on the kernel command line.
>> The stub updates the device tree as necessary, adding entries for EFI
>> runtime services. The PE/COFF "MZ" header at offset 0 results in the
>> first instruction being an add that corrupts r5, which is not used by
>> the zImage interface.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>
> I'm going to review this patch side-by-side with the ARM64 patch written
> by Mark. There are things that can still be consolidated. Otherwise the
> patch looks good.
>
>> ---
>> diff --git a/arch/arm/boot/compressed/efi-stub.c b/arch/arm/boot/compressed/efi-stub.c
>> new file mode 100644
>> index 0000000..2bd559d
>> --- /dev/null
>> +++ b/arch/arm/boot/compressed/efi-stub.c
>> @@ -0,0 +1,291 @@
>> +/*
>> + * linux/arch/arm/boot/compressed/efi-stub.c
>> + *
>> + * Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
>> + *
>> + * This file implements the EFI boot stub for the ARM kernel
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +#include <linux/efi.h>
>> +#include <libfdt.h>
>> +#include "efi-stub.h"
>> +
>> +/* EFI function call wrappers.  These are not required for
>> + * ARM, but wrappers are required for X86 to convert between
>> + * ABIs.  These wrappers are provided to allow code sharing
>> + * between X86 and ARM.  Since these wrappers directly invoke the
>> + * EFI function pointer, the function pointer type must be properly
>> + * defined, which is not the case for X86  One advantage of this is
>> + * it allows for type checking of arguments, which is not
>> + * possible with the X86 wrappers.
>> + */
>> +#define efi_call_phys0(f)                    f()
>> +#define efi_call_phys1(f, a1)                        f(a1)
>> +#define efi_call_phys2(f, a1, a2)            f(a1, a2)
>> +#define efi_call_phys3(f, a1, a2, a3)                f(a1, a2, a3)
>> +#define efi_call_phys4(f, a1, a2, a3, a4)    f(a1, a2, a3, a4)
>> +#define efi_call_phys5(f, a1, a2, a3, a4, a5)        f(a1, a2, a3, a4, a5)
>
> Identical to ARM64. I would put this into a common header usable by
> platforms that can call the functions directly.
>
>> +
>> +/* The maximum uncompressed kernel size is 32 MBytes, so we will reserve
>> + * that for the decompressed kernel.  We have no easy way to tell what
>> + * the actuall size of code + data the uncompressed kernel will use.
>> + */
>> +#define MAX_UNCOMP_KERNEL_SIZE       0x02000000
>> +
>> +/* The kernel zImage should be located between 32 Mbytes
>> + * and 128 MBytes from the base of DRAM.  The min
>> + * address leaves space for a maximal size uncompressed image,
>> + * and the max address is due to how the zImage decompressor
>> + * picks a destination address.
>> + */
>> +#define ZIMAGE_OFFSET_LIMIT  0x08000000
>> +#define MIN_ZIMAGE_OFFSET    MAX_UNCOMP_KERNEL_SIZE
>> +
>> +#define PRINTK_PREFIX                "EFIstub: "
>> +
>> +struct fdt_region {
>> +     u64 base;
>> +     u64 size;
>> +};
>
> Identical to ARM64; move to header.
>
>> +
>> +
>> +/* Include shared EFI stub code, and required headers. */
>> +#include "../../../../include/generated/compile.h"
>> +#include "../../../../include/generated/utsrelease.h"
>> +#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
>> +#include "../../../../drivers/firmware/efi/fdt.c"
>> +
>> +
>> +int efi_entry(void *handle, efi_system_table_t *sys_table,
>> +           unsigned long *zimage_addr)
>> +{
>> +     efi_loaded_image_t *image;
>> +     int status;
>> +     unsigned long nr_pages;
>> +     const struct fdt_region *region;
>> +
>> +     void *fdt;
>> +     int err;
>> +     int node;
>> +     unsigned long zimage_size = 0;
>> +     unsigned long dram_base;
>> +     /* addr/point and size pairs for memory management*/
>> +     unsigned long initrd_addr;
>> +     unsigned long initrd_size = 0;
>> +     unsigned long fdt_addr;
>> +     unsigned long fdt_size = 0;
>> +     efi_physical_addr_t kernel_reserve_addr;
>> +     unsigned long kernel_reserve_size = 0;
>> +     char *cmdline_ptr;
>> +     int cmdline_size = 0;
>> +
>> +     unsigned long map_size, desc_size;
>> +     u32 desc_ver;
>> +     unsigned long mmap_key;
>> +     efi_memory_desc_t *memory_map;
>> +
>> +     unsigned long new_fdt_size;
>> +     unsigned long new_fdt_addr;
>> +
>> +     efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
>> +
>> +     /* Check if we were booted by the EFI firmware */
>> +     if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
>> +             goto fail;
>> +
>> +     efi_printk(sys_table, PRINTK_PREFIX"Booting Linux using EFI stub.\n");
>
> Gratuitously different between ARM and ARM64. efi_printk() vs. pr_efi()
> and the string is different.
>
>> +     /* get the command line from EFI, using the LOADED_IMAGE protocol */
>> +     status = efi_call_phys3(sys_table->boottime->handle_protocol,
>> +                             handle, &proto, (void *)&image);
>> +     if (status != EFI_SUCCESS) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to get handle for LOADED_IMAGE_PROTOCOL.\n");
>> +             goto fail;
>> +     }
>> +
>> +     /* We are going to copy the command line into the device tree,
>> +      * so this memory just needs to not conflict with boot protocol
>> +      * requirements.
>> +      */
>> +     cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
>> +                                                &cmdline_size);
>> +     if (!cmdline_ptr) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to allocate memory for command line.\n");
>> +             goto fail;
>> +     }
>> +
>> +     /* We first load the device tree, as we need to get the base address of
>> +      * DRAM from the device tree.  The zImage, device tree, and initrd
>> +      * have address restrictions that are relative to the base of DRAM.
>> +      */
>> +     status = handle_cmdline_files(sys_table, image, cmdline_ptr, "dtb=",
>> +                                   0xffffffff, &fdt_addr, &fdt_size);
>> +     if (status != EFI_SUCCESS) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to load device tree blob.\n");
>> +             goto fail_free_cmdline;
>> +     }
>> +
>> +     err = fdt_check_header((void *)fdt_addr);
>> +     if (err != 0) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Device tree header not valid.\n");
>> +             goto fail_free_fdt;
>> +     }
>> +     if (fdt_totalsize((void *)fdt_addr) > fdt_size) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Incomplete device tree.\n");
>> +             goto fail_free_fdt;
>> +
>> +     }
>
> All of the above is basically identical.
>
>> +     /* Look up the base of DRAM from the device tree. */
>> +     fdt = (void *)fdt_addr;
>> +     node = fdt_subnode_offset(fdt, 0, "memory");
>> +     region = fdt_getprop(fdt, node, "reg", NULL);
>> +     if (region) {
>> +             dram_base = fdt64_to_cpu(region->base);
>> +     } else {
>> +             /* There is no way to get amount or addresses of physical
>> +              * memory installed using EFI calls.  If the device tree
>> +              * we read from disk doesn't have this, there is no way
>> +              * for us to construct this informaion.
>> +              */
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: No 'memory' node in device tree.\n");
>> +             goto fail_free_fdt;
>> +     }
>
> ARM and ARM64 differ here. ARM64 uses get_dram_base(), this open codes
> some stuff.
>
>> +
>> +     /* Reserve memory for the uncompressed kernel image. This is
>> +      * all that prevents any future allocations from conflicting
>> +      * with the kernel.  Since we can't tell from the compressed
>> +      * image how much DRAM the kernel actually uses (due to BSS
>> +      * size uncertainty) we allocate the maximum possible size.
>> +      */
>> +     kernel_reserve_addr = dram_base;
>> +     kernel_reserve_size = MAX_UNCOMP_KERNEL_SIZE;
>> +     nr_pages = round_up(kernel_reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
>> +     status = efi_call_phys4(sys_table->boottime->allocate_pages,
>> +                             EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
>> +                             nr_pages, &kernel_reserve_addr);
>> +     if (status != EFI_SUCCESS) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to allocate memory for uncompressed kernel.\n");
>> +             goto fail_free_fdt;
>> +     }
>
> This is ARM only since arm64 doesn't have a compressed version. It would
> be possible to stub out.
>
>> +
>> +     /* Relocate the zImage, if required.  ARM doesn't have a
>> +      * preferred address, so we set it to 0, as we want to allocate
>> +      * as low in memory as possible.
>> +      */
>> +     zimage_size = image->image_size;
>> +     status = efi_relocate_kernel(sys_table, zimage_addr, zimage_size,
>> +                                  zimage_size, 0, 0);
>> +     if (status != EFI_SUCCESS) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to relocate kernel.\n");
>> +             goto fail_free_kernel_reserve;
>> +     }
>
> Slight differences here.
>
>> +
>> +     /* Check to see if we were able to allocate memory low enough
>> +      * in memory.
>> +      */
>> +     if (*zimage_addr + zimage_size > dram_base + ZIMAGE_OFFSET_LIMIT) {
>> +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to relocate kernel, no low memory available.\n");
>> +             goto fail_free_zimage;
>> +     }
>
> Back to same code below this point, and is the same through to the
> bottom of the function. That is a lot of identical code. I think you can
> generalize the whole function with arch specific callouts in a couple of
> places.
>
> I really don't want to hold up the merging of this series. Aside from
> the duplication I think it is ready to be merged. However, the
> duplication is so obvious that I'm not comfortable with it. If I were
> an ARM or ARM64 core maintainer then I would push back on it.
>
> Go ahead an add my Acked-by for this patch. I'll support merging it as
> is provided that you promise me to merge the two versions with a
> follow-up patch ASAP. However, if you can I would still recommend
> respinning the series with the common bits split out right away since
> there's a much greater chance of getting the arm and arm64 maintainers
> to accept them.
>
> Acked-by: Grant Likely <grant.likely@linaro.org>
>
> g.

Hi Grant,

   You're not the first to bring this up, and I've discussed with Mark
making more of the code common.
My next series will pull more code into the shared files, so this will
be at least partly addressed then.  Further
consolidation if required will be much easier after both are merged.

Roy
