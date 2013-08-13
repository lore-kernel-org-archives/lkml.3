Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab3HMOUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:20:34 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:47363 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756428Ab3HMOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:20:32 -0400
Date: Tue, 13 Aug 2013 15:19:48 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, msalter@redhat.com
Subject: Re: [PATCH 15/16] Add EFI stub for ARM
Message-ID: <20130813141947.GF2823@localhost.localdomain>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <1376090777-20090-16-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376090777-20090-16-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 04:26:16PM -0700, Roy Franz wrote:
> This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
> operations similarly to the x86 stub: it is a shim between the EFI firmware
> and the normal zImage entry point, and sets up the environment that the
> zImage is expecting.  This includes loading the initrd (optionaly) and
> device tree from the system partition based on the kernel command line.
> The stub updates the device tree as necessary, including adding reserved
> memory regions and adding entries for EFI runtime services. The PE/COFF
> "MZ" header at offset 0 results in the first instruction being an add
> that corrupts r5, which is not used by the zImage interface.

Thanks for the update -- a few more comments, nothing major.

> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/arm/boot/compressed/Makefile     |   15 +-
>  arch/arm/boot/compressed/efi-header.S |  111 ++++++++
>  arch/arm/boot/compressed/efi-stub.c   |  448 +++++++++++++++++++++++++++++++++
>  arch/arm/boot/compressed/efi-stub.h   |    5 +
>  arch/arm/boot/compressed/head.S       |   90 ++++++-
>  5 files changed, 661 insertions(+), 8 deletions(-)
>  create mode 100644 arch/arm/boot/compressed/efi-header.S
>  create mode 100644 arch/arm/boot/compressed/efi-stub.c
>  create mode 100644 arch/arm/boot/compressed/efi-stub.h
> 
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 7ac1610..5fad8bd 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -103,11 +103,22 @@ libfdt_objs	:= $(addsuffix .o, $(basename $(libfdt)))
>  $(addprefix $(obj)/,$(libfdt) $(libfdt_hdrs)): $(obj)/%: $(srctree)/scripts/dtc/libfdt/%
>  	$(call cmd,shipped)
>  
> -$(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
> +$(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o efi-stub.o): \
>  	$(addprefix $(obj)/,$(libfdt_hdrs))
>  
>  ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
> -OBJS	+= $(libfdt_objs) atags_to_fdt.o
> +OBJS	+= atags_to_fdt.o
> +USE_LIBFDT = y
> +endif
> +
> +ifeq ($(CONFIG_EFI_STUB),y)
> +CFLAGS_efi-stub.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
> +OBJS	+= efi-stub.o
> +USE_LIBFDT = y
> +endif
> +
> +ifeq ($(USE_LIBFDT),y)
> +OBJS	+= $(libfdt_objs)
>  endif
>  
>  targets       := vmlinux vmlinux.lds \
> diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
> new file mode 100644
> index 0000000..6965e0f
> --- /dev/null
> +++ b/arch/arm/boot/compressed/efi-header.S
> @@ -0,0 +1,111 @@
> +@ Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
> +@
> +@ This file contains the PE/COFF header that is part of the
> +@ EFI stub.
> +@
> +
> +	.org	0x3c
> +	@
> +	@ The PE header can be anywhere in the file, but for
> +	@ simplicity we keep it together with the MSDOS header
> +	@ The offset to the PE/COFF header needs to be at offset
> +	@ 0x3C in the MSDOS header.
> +	@ The only 2 fields of the MSDOS header that are used are this
> +	@ PE/COFF offset, and the "MZ" bytes at offset 0x0.
> +	@
> +	.long	pe_header			@ Offset to the PE header.
> +
> +      .align 3
> +pe_header:
> +	.ascii	"PE"
> +	.short 	0
> +
> +coff_header:
> +	.short	0x01c2				@ ARM or Thumb
> +	.short	2				@ nr_sections
> +	.long	0 				@ TimeDateStamp
> +	.long	0				@ PointerToSymbolTable
> +	.long	1				@ NumberOfSymbols
> +	.short	section_table - optional_header	@ SizeOfOptionalHeader
> +	.short	0x306				@ Characteristics.
> +						@ IMAGE_FILE_32BIT_MACHINE |
> +						@ IMAGE_FILE_DEBUG_STRIPPED |
> +						@ IMAGE_FILE_EXECUTABLE_IMAGE |
> +						@ IMAGE_FILE_LINE_NUMS_STRIPPED
> +
> +optional_header:
> +	.short	0x10b				@ PE32 format
> +	.byte	0x02				@ MajorLinkerVersion
> +	.byte	0x14				@ MinorLinkerVersion
> +
> +	.long	_edata - efi_stub_entry		@ SizeOfCode
> +
> +	.long	0				@ SizeOfInitializedData
> +	.long	0				@ SizeOfUninitializedData
> +
> +	.long	efi_stub_entry			@ AddressOfEntryPoint
> +	.long	efi_stub_entry			@ BaseOfCode
> +	.long	0				@ data
> +
> +extra_header_fields:
> +	.long	0				@ ImageBase
> +	.long	0x20				@ SectionAlignment
> +	.long	0x20				@ FileAlignment
> +	.short	0				@ MajorOperatingSystemVersion
> +	.short	0				@ MinorOperatingSystemVersion
> +	.short	0				@ MajorImageVersion
> +	.short	0				@ MinorImageVersion
> +	.short	0				@ MajorSubsystemVersion
> +	.short	0				@ MinorSubsystemVersion
> +	.long	0				@ Win32VersionValue
> +
> +	.long	_edata				@ SizeOfImage
> +
> +	@ Everything before the entry point is considered part of the header
> +	.long	efi_stub_entry			@ SizeOfHeaders
> +	.long	0				@ CheckSum
> +	.short	0xa				@ Subsystem (EFI application)
> +	.short	0				@ DllCharacteristics
> +	.long	0				@ SizeOfStackReserve
> +	.long	0				@ SizeOfStackCommit
> +	.long	0				@ SizeOfHeapReserve
> +	.long	0				@ SizeOfHeapCommit
> +	.long	0				@ LoaderFlags
> +	.long	0x0				@ NumberOfRvaAndSizes
> +
> +	# Section table
> +section_table:
> +
> +	#
> +	# The EFI application loader requires a relocation section
> +	# because EFI applications must be relocatable.  This is a
> +	# dummy section as far as we are concerned.
> +	#
> +	.ascii	".reloc"
> +	.byte	0
> +	.byte	0			@ end of 0 padding of section name
> +	.long	0
> +	.long	0
> +	.long	0			@ SizeOfRawData
> +	.long	0			@ PointerToRawData
> +	.long	0			@ PointerToRelocations
> +	.long	0			@ PointerToLineNumbers
> +	.short	0			@ NumberOfRelocations
> +	.short	0			@ NumberOfLineNumbers
> +	.long	0x42100040		@ Characteristics (section flags)
> +
> +
> +	.ascii	".text"
> +	.byte	0
> +	.byte	0
> +	.byte	0        		@ end of 0 padding of section name
> +	.long	_edata - efi_stub_entry		@ VirtualSize
> +	.long	efi_stub_entry			@ VirtualAddress
> +	.long	_edata - efi_stub_entry		@ SizeOfRawData
> +	.long	efi_stub_entry			@ PointerToRawData
> +
> +	.long	0		@ PointerToRelocations (0 for executables)
> +	.long	0		@ PointerToLineNumbers (0 for executables)
> +	.short	0		@ NumberOfRelocations  (0 for executables)
> +	.short	0		@ NumberOfLineNumbers  (0 for executables)
> +	.long	0xe0500020	@ Characteristics (section flags)
> diff --git a/arch/arm/boot/compressed/efi-stub.c b/arch/arm/boot/compressed/efi-stub.c
> new file mode 100644
> index 0000000..4fce68b
> --- /dev/null
> +++ b/arch/arm/boot/compressed/efi-stub.c
> @@ -0,0 +1,448 @@
> +/*
> + * linux/arch/arm/boot/compressed/efi-stub.c
> + *
> + * Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
> + *
> + * This file implements the EFI boot stub for the ARM kernel
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/efi.h>
> +#include <libfdt.h>
> +#include "efi-stub.h"
> +
> +/* EFI function call wrappers.  These are not required for
> + * ARM, but wrappers are required for X86 to convert between
> + * ABIs.  These wrappers are provided to allow code sharing
> + * between X86 and ARM.  Since these wrappers directly invoke the
> + * EFI function pointer, the function pointer type must be properly
> + * defined, which is not the case for X86  One advantage of this is
> + * it allows for type checking of arguments, which is not
> + * possible with the X86 wrappers.
> + */
> +#define efi_call_phys0(f)			f()
> +#define efi_call_phys1(f, a1)			f(a1)
> +#define efi_call_phys2(f, a1, a2)		f(a1, a2)
> +#define efi_call_phys3(f, a1, a2, a3)		f(a1, a2, a3)
> +#define efi_call_phys4(f, a1, a2, a3, a4)	f(a1, a2, a3, a4)
> +#define efi_call_phys5(f, a1, a2, a3, a4, a5)	f(a1, a2, a3, a4, a5)
> +
> +/* The maximum uncompressed kernel size is 32 MBytes, so we will reserve
> + * that for the decompressed kernel.  We have no easy way to tell what
> + * the actuall size of code + data the uncompressed kernel will use.
> + */
> +#define MAX_UNCOMP_KERNEL_SIZE	0x02000000
> +
> +/* The kernel zImage should be located between 32 Mbytes
> + * and 128 MBytes from the base of DRAM.  The min
> + * address leaves space for a maximal size uncompressed image,
> + * and the max address is due to how the zImage decompressor
> + * picks a destination address.
> + */
> +#define ZIMAGE_OFFSET_LIMIT	0x08000000
> +#define MIN_ZIMAGE_OFFSET	MAX_UNCOMP_KERNEL_SIZE
> +
> +#define PRINTK_PREFIX		"EFIstub: "
> +
> +struct fdt_region {
> +	u64 base;
> +	u64 size;
> +};
> +
> +
> +/* Include shared EFI stub code */
> +#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
> +
> +static int relocate_kernel(efi_system_table_t *sys_table,
> +			   unsigned long *zimage_addr,
> +			   unsigned long zimage_size,
> +			   unsigned long min_addr, unsigned long max_addr)
> +{
> +	/* Get current address of kernel. */
> +	unsigned long cur_zimage_addr = *zimage_addr;
> +	unsigned long new_addr = 0;
> +
> +	efi_status_t status;
> +
> +	if (!zimage_addr || !zimage_size)
> +		return EFI_INVALID_PARAMETER;
> +
> +	if (cur_zimage_addr > min_addr
> +	    && (cur_zimage_addr + zimage_size) < max_addr) {
> +		/* We don't need to do anything, as kernel is at an
> +		 * acceptable address already.
> +		 */
> +		return EFI_SUCCESS;
> +	}
> +	/*
> +	 * The EFI firmware loader could have placed the kernel image
> +	 * anywhere in memory, but the kernel has restrictions on the
> +	 * min and max physical address it can run at.
> +	 */
> +	status = efi_low_alloc(sys_table, zimage_size, 0,
> +			   &new_addr, min_addr);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to allocate usable memory for kernel.\n");
> +		return status;
> +	}
> +
> +	if (new_addr > (max_addr - zimage_size)) {
> +		efi_free(sys_table, zimage_size, new_addr);
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to allocate usable memory for kernel.\n");
> +		return EFI_INVALID_PARAMETER;
> +	}
> +
> +	/* We know source/dest won't overlap since both memory ranges
> +	 * have been allocated by UEFI, so we can safely use memcpy.
> +	 */
> +	memcpy((void *)new_addr, (void *)(unsigned long)cur_zimage_addr,
> +	       zimage_size);
> +
> +	/* Return the load address  */
> +	*zimage_addr = new_addr;
> +
> +	return status;
> +}
> +
> +
> +/* Convert the unicode UEFI command line to ASCII to pass to kernel.
> + * Size of memory allocated return in *cmd_line_len.
> + * Returns NULL on error.
> + */
> +static char *convert_cmdline_to_ascii(efi_system_table_t *sys_table,
> +				      efi_loaded_image_t *image,
> +				      unsigned long *cmd_line_len,
> +				      u32 max_addr)
> +{
> +	u16 *s2;
> +	u8 *s1 = NULL;
> +	unsigned long cmdline_addr = 0;
> +	int load_options_size = image->load_options_size / 2; /* ASCII */
> +	void *options = (u16 *)image->load_options;
> +	int options_size = 0;
> +	int status;
> +	int i;
> +	u16 zero = 0;
> +
> +	if (options) {
> +		s2 = options;
> +		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
> +			s2++;
> +			options_size++;
> +		}
> +	}
> +
> +	if (options_size == 0) {
> +		/* No command line options, so return empty string*/
> +		options_size = 1;
> +		options = &zero;
> +	}
> +
> +	options_size++;  /* NUL termination */
> +
> +	status = efi_high_alloc(sys_table, options_size, 0,
> +			    &cmdline_addr, max_addr);
> +	if (status != EFI_SUCCESS)
> +		return NULL;
> +
> +	s1 = (u8 *)(unsigned long)cmdline_addr;
> +	s2 = (u16 *)options;
> +
> +	for (i = 0; i < options_size - 1; i++)
> +		*s1++ = *s2++;
> +
> +	*s1 = '\0';
> +
> +	*cmd_line_len = options_size;
> +	return (char *)(unsigned long)cmdline_addr;
> +}
> +
> +
> +static u32 update_fdt(efi_system_table_t *sys_table, void *orig_fdt, void *fdt,
> +		      int new_fdt_size, char *cmdline_ptr, u64 initrd_addr,
> +		      u64 initrd_size, efi_memory_desc_t *memory_map,
> +		      int map_size, int desc_size)
> +{
> +	int node;
> +	int status;
> +	unsigned long fdt_val;
> +
> +	status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
> +	if (status != 0)
> +		goto fdt_set_fail;
> +
> +	node = fdt_subnode_offset(fdt, 0, "chosen");
> +	if (node < 0) {
> +		node = fdt_add_subnode(fdt, 0, "chosen");
> +		if (node < 0) {
> +			status = node; /* node is error code when negative */
> +			goto fdt_set_fail;
> +		}
> +	}
> +
> +	if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
> +		status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
> +				     strlen(cmdline_ptr) + 1);
> +		if (status)
> +			goto fdt_set_fail;
> +	}
> +
> +	/* Set intird address/end in device tree, if present */
> +	if (initrd_size != 0) {
> +		u64 initrd_image_end;
> +		u64 initrd_image_start = cpu_to_fdt64(initrd_addr);
> +		status = fdt_setprop(fdt, node, "linux,initrd-start",
> +				     &initrd_image_start, sizeof(u64));
> +		if (status)
> +			goto fdt_set_fail;
> +		initrd_image_end = cpu_to_fdt64(initrd_addr + initrd_size);
> +		status = fdt_setprop(fdt, node, "linux,initrd-end",
> +				     &initrd_image_end, sizeof(u64));
> +		if (status)
> +			goto fdt_set_fail;
> +	}
> +
> +	/* Add FDT entries for EFI runtime services in chosen node. */
> +	node = fdt_subnode_offset(fdt, 0, "chosen");
> +	fdt_val = cpu_to_fdt32((unsigned long)sys_table);
> +	status = fdt_setprop(fdt, node, "efi-system-table",
> +			     &fdt_val, sizeof(fdt_val));
> +	if (status)
> +		goto fdt_set_fail;
> +
> +	fdt_val = cpu_to_fdt32(desc_size);
> +	status = fdt_setprop(fdt, node, "efi-mmap-desc-size",
> +			     &fdt_val, sizeof(fdt_val));
> +	if (status)
> +		goto fdt_set_fail;
> +
> +	fdt_val = cpu_to_fdt32(map_size);
> +	status = fdt_setprop(fdt, node, "efi-runtime-mmap-size",
> +			     &fdt_val, sizeof(fdt_val));
> +	if (status)
> +		goto fdt_set_fail;
> +
> +	fdt_val = cpu_to_fdt32((unsigned long)memory_map);
> +	status = fdt_setprop(fdt, node, "efi-runtime-mmap",
> +			     &fdt_val, sizeof(fdt_val));
> +	if (status)
> +		goto fdt_set_fail;
> +
> +	return EFI_SUCCESS;

This looks better.

> +
> +fdt_set_fail:
> +	if (status == -FDT_ERR_NOSPACE)
> +		return EFI_BUFFER_TOO_SMALL;
> +
> +	return EFI_LOAD_ERROR;
> +}
> +
> +
> +

Maybe add a comment to indicate that this returns the address of the
relocated fdt, or EFI_LOAD_ERROR.

By default "int" feels more likely to return a status code.

It is not common to return pointers using the "int" type: it may be
preferable to use unsigned long of void * instead.  This won't
change the functionality.

Casts to (int) which could overflow the signed range can cause GCC
to generate bizarre code in some situations, because C doesn't
have to guarantee wrapping when casting to signed types.  Since we
just pass that value through without doing any arithmetic I think we're
unlikely to hit that here, but it's best avoided anyhow.

> +int efi_entry(void *handle, efi_system_table_t *sys_table,
> +	      unsigned long *zimage_addr)
> +{
> +	efi_loaded_image_t *image;
> +	int status;
> +	unsigned long nr_pages;
> +	const struct fdt_region *region;
> +
> +	void *fdt;
> +	int err;
> +	int node;
> +	unsigned long zimage_size = 0;
> +	unsigned long dram_base;
> +	/* addr/point and size pairs for memory management*/
> +	u64 initrd_addr;
> +	u64 initrd_size = 0;
> +	u64 fdt_addr;
> +	u64 fdt_size = 0;
> +	u64 kernel_reserve_addr;
> +	u64 kernel_reserve_size = 0;
> +	char *cmdline_ptr;
> +	unsigned long cmdline_size = 0;
> +
> +	unsigned long map_size, desc_size;
> +	unsigned long mmap_key;
> +	efi_memory_desc_t *memory_map;
> +
> +	unsigned long new_fdt_size;
> +	unsigned long new_fdt_addr;
> +
> +	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
> +
> +	/* Check if we were booted by the EFI firmware */
> +	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
> +		goto fail;
> +
> +	efi_printk(sys_table, PRINTK_PREFIX"Booting Linux using EFI stub.\n");
> +
> +
> +	/* get the command line from EFI, using the LOADED_IMAGE protocol */
> +	status = efi_call_phys3(sys_table->boottime->handle_protocol,
> +				handle, &proto, (void *)&image);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
> +		goto fail;
> +	}
> +
> +	/* We are going to copy this into device tree, so we don't care where in
> +	 * memory it is.
> +	 */
> +	cmdline_ptr = convert_cmdline_to_ascii(sys_table, image,
> +					       &cmdline_size, 0xFFFFFFFF);
> +	if (!cmdline_ptr) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: converting command line to ascii failed.\n");

The real reason for this failure is failure to allocate memory: there's
no other way it can fail.

So, the error message could be "Unable to allocate memory for command
line"

> +		goto fail;
> +	}
> +
> +	/* We first load the device tree, as we need to get the base address of
> +	 * DRAM from the device tree.  The zImage, device tree, and initrd
> +	 * have address restrictions that are relative to the base of DRAM.
> +	 */
> +	status = handle_cmdline_files(sys_table, image, cmdline_ptr, "dtb=",
> +				      0xffffffff, &fdt_addr, &fdt_size);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to load device tree blob.\n");
> +		goto fail_free_cmdline;
> +	}
> +
> +	err = fdt_check_header((void *)(unsigned long)fdt_addr);
> +	if (err != 0) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: device tree header not valid\n");
> +		goto fail_free_fdt;
> +	}
> +	if (fdt_totalsize((void *)(unsigned long)fdt_addr) > fdt_size) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Incomplete device tree.\n");
> +		goto fail_free_fdt;
> +
> +	}
> +
> +
> +	/* Look up the base of DRAM from the device tree.*/
> +	fdt = (void *)(u32)fdt_addr;
> +	node = fdt_subnode_offset(fdt, 0, "memory");
> +	region = fdt_getprop(fdt, node, "reg", NULL);
> +	if (region) {
> +		dram_base = fdt64_to_cpu(region->base);
> +	} else {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: no 'memory' node in device tree.\n");
> +		goto fail_free_fdt;
> +	}
> +
> +	/* Reserve memory for the uncompressed kernel image. */
> +	kernel_reserve_addr = dram_base;
> +	kernel_reserve_size = MAX_UNCOMP_KERNEL_SIZE;
> +	nr_pages = round_up(kernel_reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> +	status = efi_call_phys4(sys_table->boottime->allocate_pages,
> +				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
> +				nr_pages, &kernel_reserve_addr);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: unable to allocate memory for uncompressed kernel.\n");
> +		goto fail_free_fdt;
> +	}
> +
> +	/* Relocate the zImage, if required. */
> +	zimage_size = image->image_size;
> +	status = relocate_kernel(sys_table, zimage_addr, zimage_size,
> +				 dram_base + MIN_ZIMAGE_OFFSET,
> +				 dram_base + ZIMAGE_OFFSET_LIMIT);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to relocate kernel\n");
> +		goto fail_free_kernel_reserve;
> +	}
> +
> +	status = handle_cmdline_files(sys_table, image, cmdline_ptr, "initrd=",
> +				      dram_base + ZIMAGE_OFFSET_LIMIT,
> +				      &initrd_addr, &initrd_size);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to load initrd\n");
> +		goto fail_free_zimage;
> +	}
> +
> +	/* Estimate size of new FDT, and allocate memory for it. We
> +	 * will allocate a bigger buffer if this ends up being too
> +	 * small, so a rough guess is OK here.*/
> +	new_fdt_size = fdt_size + cmdline_size + 0x200;
> +
> +fdt_alloc_retry:

Minor stylistic thing, but looping using goto is not too readable.

The following while loop might be a bit clearer, but I leave it
up to you.

while (1) {

> +	status = efi_high_alloc(sys_table, new_fdt_size, 0, &new_fdt_addr,
> +			    dram_base + ZIMAGE_OFFSET_LIMIT);
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to allocate memory for new device tree.\n");
> +		goto fail_free_initrd;
> +	}
> +
> +	/* Now that we have done our final memory allocation (and free)
> +	 * we can get the memory map key needed
> +	 * forexit_boot_services.*/
> +	status = efi_get_memory_map(sys_table, &memory_map, &map_size,
> +				    &desc_size, &mmap_key);
> +	if (status != EFI_SUCCESS)
> +		goto fail_free_new_fdt;
> +
> +	status = update_fdt(sys_table,
> +			    fdt, (void *)new_fdt_addr, new_fdt_size,
> +			    cmdline_ptr,
> +			    initrd_addr, initrd_size,
> +			    memory_map, map_size, desc_size);

if (status == EFI_SUCCESS)
	break;

instead of

> +
> +	if (status != EFI_SUCCESS) {

then

	if (status != EFI_BUFFER_TOO_SMALL)
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to constuct new device tree.\n");
> +		goto fail_free_initrd;

instead of

> +		if (status == EFI_BUFFER_TOO_SMALL) {

then

> +			/* We need to allocate more space for the new
> +			 * device tree, so free existing buffer that is
> +			 * too small.  Also free memory map, as we will need
> +			 * to get new one that reflects the free/alloc we do
> +			 * on the device tree buffer. */
> +			efi_free(sys_table, new_fdt_size, new_fdt_addr);
> +			efi_call_phys1(sys_table->boottime->free_pool,
> +				       memory_map);
> +			new_fdt_size += new_fdt_size/4;

And then just loop
	}

instead of the rest:

> +			goto fdt_alloc_retry;
> +		}
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to constuct new device tree.\n");
> +		goto fail_free_initrd;
> +	}
> +
> +	/* Now we are ready to exit_boot_services.*/
> +	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
> +				handle, mmap_key);
> +
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, PRINTK_PREFIX"ERROR: exit boot services failed.\n");
> +		goto fail_free_mmap;
> +	}
> +
> +
> +	/* Now we need to return the FDT address to the calling
> +	 * assembly to this can be used as part of normal boot.
> +	 */
> +	return new_fdt_addr;
> +
> +fail_free_mmap:
> +	efi_call_phys1(sys_table->boottime->free_pool, memory_map);
> +
> +fail_free_new_fdt:
> +	efi_free(sys_table, new_fdt_size, new_fdt_addr);
> +
> +fail_free_initrd:
> +	efi_free(sys_table, initrd_size, initrd_addr);
> +
> +fail_free_zimage:
> +	efi_free(sys_table, zimage_size, *zimage_addr);
> +
> +fail_free_kernel_reserve:
> +	efi_free(sys_table, kernel_reserve_addr, kernel_reserve_size);
> +
> +fail_free_fdt:
> +	efi_free(sys_table, fdt_size, fdt_addr);
> +
> +fail_free_cmdline:
> +	efi_free(sys_table, cmdline_size, (u32)cmdline_ptr);
> +
> +fail:
> +	return EFI_STUB_ERROR;
> +}
> diff --git a/arch/arm/boot/compressed/efi-stub.h b/arch/arm/boot/compressed/efi-stub.h
> new file mode 100644
> index 0000000..0fe9376
> --- /dev/null
> +++ b/arch/arm/boot/compressed/efi-stub.h
> @@ -0,0 +1,5 @@
> +#ifndef _ARM_EFI_STUB_H
> +#define _ARM_EFI_STUB_H
> +/* Error code returned to ASM code instead of valid FDT address. */
> +#define EFI_STUB_ERROR		(~0)
> +#endif
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 75189f1..5401a3a 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -10,6 +10,7 @@
>   */
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
> +#include "efi-stub.h"
>  
>  	.arch	armv7-a
>  /*
> @@ -120,21 +121,99 @@
>   */
>  		.align
>  		.arm				@ Always enter in ARM state
> +		.text
>  start:
>  		.type	start,#function
> -		.rept	7
> +#ifdef CONFIG_EFI_STUB
> +		@ Magic MSDOS signature for PE/COFF + ADD opcode
> +		.word	0x62805a4d
> +#else
> +		mov	r0, r0
> +#endif
> +		.rept	5
>  		mov	r0, r0
>  		.endr
> -   ARM(		mov	r0, r0		)
> -   ARM(		b	1f		)
> - THUMB(		adr	r12, BSYM(1f)	)
> - THUMB(		bx	r12		)
> +
> +		adrl	r12, BSYM(zimage_continue)
> + ARM(		mov     pc, r12 )
> + THUMB(		bx	r12     )
> +		@ zimage_continue will be in ARM or thumb mode as configured
>  
>  		.word	0x016f2818		@ Magic numbers to help the loader
>  		.word	start			@ absolute load/run zImage address
>  		.word	_edata			@ zImage end address
> +
> +#ifdef CONFIG_EFI_STUB
> +		@ Portions of the MSDOS file header must be at offset
> +		@ 0x3c from the start of the file.  All PE/COFF headers
> +		@ are kept contiguous for simplicity.
> +#include "efi-header.S"
> +
> +efi_stub_entry:
> +		@ The EFI stub entry point is not at a fixed address, however
> +		@ this address must be set in the PE/COFF header.
> +		@ EFI entry point is in A32 mode, switch to T32 if configured.
> + THUMB(		adr	r12, BSYM(1f)	)
> + THUMB(		bx	r12		)
>   THUMB(		.thumb			)
>  1:
> +		@ Save lr on stack for possible return to EFI firmware.
> +		@ Don't care about fp, but need 64 bit alignment....
> +		stmfd	sp!, {fp, lr}
> +
> +		@ allocate space on stack for return of new entry point of
> +		@ zImage, as EFI stub may copy the kernel.  Pass address
> +		@ of space in r2 - EFI stub will fill in the pointer.
> +
> +		sub	sp, sp, #8		@ we only need 4 bytes,
> +						@ but keep stack 8 byte aligned.
> +		mov	r2, sp

You can save an instruction here: skip these two instructions, and see
below just before the call to efi_entry [1]

> +		@ Pass our actual runtime start address in pointer data
> +		adr	r11, LC0		@ address of LC0 at run time
> +		ldr	r12, [r11, #0]		@ address of LC0 at link time

Can we just move this delta calculation after efi_entry?

You don't need to specifiy an explicit offset if it's zero, btw:

	ldr	r12, [r11]

works just as well.  Same for the other instances.

> +
> +		sub	r3, r11, r12		@ calculate the delta offset
> +		str	r3, [r2, #0]

I think r2 is still equal to sp, so

	str	r3, [sp]

should be OK.

[1]Or, combine this with the modification of sp:

	str	r3, [sp, #-8]!
	mov	r2, sp

> +		bl	efi_entry
> +
> +		@ get new zImage entry address from stack, put into r3
> +		ldr	r3, [sp, #0]
> +		add	sp, sp, #8  		@ restore stack

	ldr	r3, [sp], #8

> +
> +		@ Check for error return from EFI stub
> +		mov	r1, #EFI_STUB_ERROR
> +		cmp	r0, r1

	cmp r0, #EFI_STUB_ERROR

probably works.  The assembler will turn this into a cmn as necessary.

> +		beq	efi_load_fail
> +
> +
> +		@ Save return values of efi_entry
> +		stmfd	sp!, {r0, r3}
> +		bl	cache_clean_flush
> +		bl	cache_off
> +		ldmfd   sp!, {r0, r3}
> +
> +		@ Set parameters for booting zImage according to boot protocol
> +		@ put FDT address in r2, it was returned by efi_entry()
> +		@ r1 is FDT machine type, and r0 needs to be 0
> +		mov	r2, r0
> +		mov	r1, #0xFFFFFFFF
> +		mov	r0, #0
> +
> +		@ Branch to (possibly) relocated zImage that is in r3
> +		@ Make sure we are in A32 mode, as zImage requires
> + THUMB(		bx	r3		)
> + ARM(		mov	pc, r3		)
> +
> +efi_load_fail:
> +		@ Return EFI_LOAD_ERROR to EFI firmware on error.
> +		@ Switch back to ARM mode for EFI is done based on
> +		@ return address on stack
> +		ldr	r0, =0x80000001
> +		ldmfd	sp!, {fp, pc}
> +#endif
> +
> + THUMB(		.thumb			)
> +zimage_continue:
>  		mrs	r9, cpsr
>  #ifdef CONFIG_ARM_VIRT_EXT
>  		bl	__hyp_stub_install	@ get into SVC mode, reversibly
> @@ -167,7 +246,6 @@ not_angel:
>  		 * by the linker here, but it should preserve r7, r8, and r9.
>  		 */
>  
> -		.text
>  
>  #ifdef CONFIG_AUTO_ZRELADDR
>  		@ determine final kernel image address
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
