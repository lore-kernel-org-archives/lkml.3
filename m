Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab3K0Xcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:32:51 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48769 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250Ab3K0XcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:32:11 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V5 4/6] Add EFI stub for ARM
Date: Wed, 27 Nov 2013 15:31:53 -0800
Message-Id: <1385595115-21488-5-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
operates similarly to the x86 stub: it is a shim between the EFI firmware
and the normal zImage entry point, and sets up the environment that the
zImage is expecting.  This includes loading the initrd (optionaly) and
device tree from the system partition based on the kernel command line.
The stub updates the device tree as necessary, adding entries for EFI
runtime services. The PE/COFF "MZ" header at offset 0 results in the
first instruction being an add that corrupts r5, which is not used by
the zImage interface.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/boot/compressed/Makefile     |   15 +-
 arch/arm/boot/compressed/efi-header.S |  117 +++++++++++++
 arch/arm/boot/compressed/efi-stub.c   |  291 +++++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/efi-stub.h   |    5 +
 arch/arm/boot/compressed/head.S       |   83 +++++++++-
 5 files changed, 503 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/boot/compressed/efi-stub.c
 create mode 100644 arch/arm/boot/compressed/efi-stub.h

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index e7190bb..c0c7fee 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -99,11 +99,22 @@ libfdt_objs	:= $(addsuffix .o, $(basename $(libfdt)))
 $(addprefix $(obj)/,$(libfdt) $(libfdt_hdrs)): $(obj)/%: $(srctree)/scripts/dtc/libfdt/%
 	$(call cmd,shipped)
 
-$(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
+$(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o efi-stub.o): \
 	$(addprefix $(obj)/,$(libfdt_hdrs))
 
 ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
-OBJS	+= $(libfdt_objs) atags_to_fdt.o
+OBJS	+= atags_to_fdt.o
+USE_LIBFDT = y
+endif
+
+ifeq ($(CONFIG_EFI_STUB),y)
+CFLAGS_efi-stub.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
+OBJS	+= efi-stub.o
+USE_LIBFDT = y
+endif
+
+ifeq ($(USE_LIBFDT),y)
+OBJS	+= $(libfdt_objs)
 endif
 
 targets       := vmlinux vmlinux.lds \
diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
new file mode 100644
index 0000000..dbb7101
--- /dev/null
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -0,0 +1,117 @@
+@ Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
+@
+@ This file contains the PE/COFF header that is part of the
+@ EFI stub.
+@
+
+	.org	0x3c
+	@
+	@ The PE header can be anywhere in the file, but for
+	@ simplicity we keep it together with the MSDOS header
+	@ The offset to the PE/COFF header needs to be at offset
+	@ 0x3C in the MSDOS header.
+	@ The only 2 fields of the MSDOS header that are used are this
+	@ PE/COFF offset, and the "MZ" bytes at offset 0x0.
+	@
+	.long	pe_header			@ Offset to the PE header.
+
+      .align 3
+pe_header:
+	.ascii	"PE"
+	.short 	0
+
+coff_header:
+	.short	0x01c2				@ ARM or Thumb
+	.short	2				@ nr_sections
+	.long	0 				@ TimeDateStamp
+	.long	0				@ PointerToSymbolTable
+	.long	1				@ NumberOfSymbols
+	.short	section_table - optional_header	@ SizeOfOptionalHeader
+	.short	0x306				@ Characteristics.
+						@ IMAGE_FILE_32BIT_MACHINE |
+						@ IMAGE_FILE_DEBUG_STRIPPED |
+						@ IMAGE_FILE_EXECUTABLE_IMAGE |
+						@ IMAGE_FILE_LINE_NUMS_STRIPPED
+
+optional_header:
+	.short	0x10b				@ PE32 format
+	.byte	0x02				@ MajorLinkerVersion
+	.byte	0x14				@ MinorLinkerVersion
+
+	.long	_edata - efi_stub_entry		@ SizeOfCode
+
+	.long	0				@ SizeOfInitializedData
+	.long	0				@ SizeOfUninitializedData
+
+	.long	efi_stub_entry			@ AddressOfEntryPoint
+	.long	efi_stub_entry			@ BaseOfCode
+	.long	0				@ data
+
+extra_header_fields:
+	.long	0				@ ImageBase
+	.long	0x20				@ SectionAlignment
+	.long	0x8				@ FileAlignment
+	.short	0				@ MajorOperatingSystemVersion
+	.short	0				@ MinorOperatingSystemVersion
+	.short	0				@ MajorImageVersion
+	.short	0				@ MinorImageVersion
+	.short	0				@ MajorSubsystemVersion
+	.short	0				@ MinorSubsystemVersion
+	.long	0				@ Win32VersionValue
+
+	.long	_edata				@ SizeOfImage
+
+	@ Everything before the entry point is considered part of the header
+	.long	efi_stub_entry			@ SizeOfHeaders
+	.long	0				@ CheckSum
+	.short	0xa				@ Subsystem (EFI application)
+	.short	0				@ DllCharacteristics
+	.long	0				@ SizeOfStackReserve
+	.long	0				@ SizeOfStackCommit
+	.long	0				@ SizeOfHeapReserve
+	.long	0				@ SizeOfHeapCommit
+	.long	0				@ LoaderFlags
+	.long	0x6				@ NumberOfRvaAndSizes
+
+	.quad   0                               @ ExportTable
+	.quad   0                               @ ImportTable
+	.quad   0                               @ ResourceTable
+	.quad   0                               @ ExceptionTable
+	.quad   0                               @ CertificationTable
+	.quad   0                               @ BaseRelocationTable
+	# Section table
+section_table:
+
+	#
+	# The EFI application loader requires a relocation section
+	# because EFI applications must be relocatable.  This is a
+	# dummy section as far as we are concerned.
+	#
+	.ascii	".reloc"
+	.byte	0
+	.byte	0			@ end of 0 padding of section name
+	.long	0
+	.long	0
+	.long	0			@ SizeOfRawData
+	.long	0			@ PointerToRawData
+	.long	0			@ PointerToRelocations
+	.long	0			@ PointerToLineNumbers
+	.short	0			@ NumberOfRelocations
+	.short	0			@ NumberOfLineNumbers
+	.long	0x42100040		@ Characteristics (section flags)
+
+
+	.ascii	".text"
+	.byte	0
+	.byte	0
+	.byte	0        		@ end of 0 padding of section name
+	.long	_edata - efi_stub_entry		@ VirtualSize
+	.long	efi_stub_entry			@ VirtualAddress
+	.long	_edata - efi_stub_entry		@ SizeOfRawData
+	.long	efi_stub_entry			@ PointerToRawData
+
+	.long	0		@ PointerToRelocations (0 for executables)
+	.long	0		@ PointerToLineNumbers (0 for executables)
+	.short	0		@ NumberOfRelocations  (0 for executables)
+	.short	0		@ NumberOfLineNumbers  (0 for executables)
+	.long	0xe0500020	@ Characteristics (section flags)
diff --git a/arch/arm/boot/compressed/efi-stub.c b/arch/arm/boot/compressed/efi-stub.c
new file mode 100644
index 0000000..2bd559d
--- /dev/null
+++ b/arch/arm/boot/compressed/efi-stub.c
@@ -0,0 +1,291 @@
+/*
+ * linux/arch/arm/boot/compressed/efi-stub.c
+ *
+ * Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
+ *
+ * This file implements the EFI boot stub for the ARM kernel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/efi.h>
+#include <libfdt.h>
+#include "efi-stub.h"
+
+/* EFI function call wrappers.  These are not required for
+ * ARM, but wrappers are required for X86 to convert between
+ * ABIs.  These wrappers are provided to allow code sharing
+ * between X86 and ARM.  Since these wrappers directly invoke the
+ * EFI function pointer, the function pointer type must be properly
+ * defined, which is not the case for X86  One advantage of this is
+ * it allows for type checking of arguments, which is not
+ * possible with the X86 wrappers.
+ */
+#define efi_call_phys0(f)			f()
+#define efi_call_phys1(f, a1)			f(a1)
+#define efi_call_phys2(f, a1, a2)		f(a1, a2)
+#define efi_call_phys3(f, a1, a2, a3)		f(a1, a2, a3)
+#define efi_call_phys4(f, a1, a2, a3, a4)	f(a1, a2, a3, a4)
+#define efi_call_phys5(f, a1, a2, a3, a4, a5)	f(a1, a2, a3, a4, a5)
+
+/* The maximum uncompressed kernel size is 32 MBytes, so we will reserve
+ * that for the decompressed kernel.  We have no easy way to tell what
+ * the actuall size of code + data the uncompressed kernel will use.
+ */
+#define MAX_UNCOMP_KERNEL_SIZE	0x02000000
+
+/* The kernel zImage should be located between 32 Mbytes
+ * and 128 MBytes from the base of DRAM.  The min
+ * address leaves space for a maximal size uncompressed image,
+ * and the max address is due to how the zImage decompressor
+ * picks a destination address.
+ */
+#define ZIMAGE_OFFSET_LIMIT	0x08000000
+#define MIN_ZIMAGE_OFFSET	MAX_UNCOMP_KERNEL_SIZE
+
+#define PRINTK_PREFIX		"EFIstub: "
+
+struct fdt_region {
+	u64 base;
+	u64 size;
+};
+
+
+/* Include shared EFI stub code, and required headers. */
+#include "../../../../include/generated/compile.h"
+#include "../../../../include/generated/utsrelease.h"
+#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
+#include "../../../../drivers/firmware/efi/fdt.c"
+
+
+int efi_entry(void *handle, efi_system_table_t *sys_table,
+	      unsigned long *zimage_addr)
+{
+	efi_loaded_image_t *image;
+	int status;
+	unsigned long nr_pages;
+	const struct fdt_region *region;
+
+	void *fdt;
+	int err;
+	int node;
+	unsigned long zimage_size = 0;
+	unsigned long dram_base;
+	/* addr/point and size pairs for memory management*/
+	unsigned long initrd_addr;
+	unsigned long initrd_size = 0;
+	unsigned long fdt_addr;
+	unsigned long fdt_size = 0;
+	efi_physical_addr_t kernel_reserve_addr;
+	unsigned long kernel_reserve_size = 0;
+	char *cmdline_ptr;
+	int cmdline_size = 0;
+
+	unsigned long map_size, desc_size;
+	u32 desc_ver;
+	unsigned long mmap_key;
+	efi_memory_desc_t *memory_map;
+
+	unsigned long new_fdt_size;
+	unsigned long new_fdt_addr;
+
+	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
+
+	/* Check if we were booted by the EFI firmware */
+	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		goto fail;
+
+	efi_printk(sys_table, PRINTK_PREFIX"Booting Linux using EFI stub.\n");
+
+
+	/* get the command line from EFI, using the LOADED_IMAGE protocol */
+	status = efi_call_phys3(sys_table->boottime->handle_protocol,
+				handle, &proto, (void *)&image);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to get handle for LOADED_IMAGE_PROTOCOL.\n");
+		goto fail;
+	}
+
+	/* We are going to copy the command line into the device tree,
+	 * so this memory just needs to not conflict with boot protocol
+	 * requirements.
+	 */
+	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
+						   &cmdline_size);
+	if (!cmdline_ptr) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to allocate memory for command line.\n");
+		goto fail;
+	}
+
+	/* We first load the device tree, as we need to get the base address of
+	 * DRAM from the device tree.  The zImage, device tree, and initrd
+	 * have address restrictions that are relative to the base of DRAM.
+	 */
+	status = handle_cmdline_files(sys_table, image, cmdline_ptr, "dtb=",
+				      0xffffffff, &fdt_addr, &fdt_size);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to load device tree blob.\n");
+		goto fail_free_cmdline;
+	}
+
+	err = fdt_check_header((void *)fdt_addr);
+	if (err != 0) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Device tree header not valid.\n");
+		goto fail_free_fdt;
+	}
+	if (fdt_totalsize((void *)fdt_addr) > fdt_size) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Incomplete device tree.\n");
+		goto fail_free_fdt;
+
+	}
+
+
+	/* Look up the base of DRAM from the device tree. */
+	fdt = (void *)fdt_addr;
+	node = fdt_subnode_offset(fdt, 0, "memory");
+	region = fdt_getprop(fdt, node, "reg", NULL);
+	if (region) {
+		dram_base = fdt64_to_cpu(region->base);
+	} else {
+		/* There is no way to get amount or addresses of physical
+		 * memory installed using EFI calls.  If the device tree
+		 * we read from disk doesn't have this, there is no way
+		 * for us to construct this informaion.
+		 */
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: No 'memory' node in device tree.\n");
+		goto fail_free_fdt;
+	}
+
+	/* Reserve memory for the uncompressed kernel image. This is
+	 * all that prevents any future allocations from conflicting
+	 * with the kernel.  Since we can't tell from the compressed
+	 * image how much DRAM the kernel actually uses (due to BSS
+	 * size uncertainty) we allocate the maximum possible size.
+	 */
+	kernel_reserve_addr = dram_base;
+	kernel_reserve_size = MAX_UNCOMP_KERNEL_SIZE;
+	nr_pages = round_up(kernel_reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	status = efi_call_phys4(sys_table->boottime->allocate_pages,
+				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				nr_pages, &kernel_reserve_addr);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to allocate memory for uncompressed kernel.\n");
+		goto fail_free_fdt;
+	}
+
+	/* Relocate the zImage, if required.  ARM doesn't have a
+	 * preferred address, so we set it to 0, as we want to allocate
+	 * as low in memory as possible.
+	 */
+	zimage_size = image->image_size;
+	status = efi_relocate_kernel(sys_table, zimage_addr, zimage_size,
+				     zimage_size, 0, 0);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to relocate kernel.\n");
+		goto fail_free_kernel_reserve;
+	}
+
+	/* Check to see if we were able to allocate memory low enough
+	 * in memory.
+	 */
+	if (*zimage_addr + zimage_size > dram_base + ZIMAGE_OFFSET_LIMIT) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to relocate kernel, no low memory available.\n");
+		goto fail_free_zimage;
+	}
+	status = handle_cmdline_files(sys_table, image, cmdline_ptr, "initrd=",
+				      dram_base + ZIMAGE_OFFSET_LIMIT,
+				      &initrd_addr, &initrd_size);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to load initrd.\n");
+		goto fail_free_zimage;
+	}
+
+	/* Estimate size of new FDT, and allocate memory for it. We
+	 * will allocate a bigger buffer if this ends up being too
+	 * small, so a rough guess is OK here.*/
+	new_fdt_size = fdt_size + cmdline_size + 0x800;
+	while (1) {
+		status = efi_high_alloc(sys_table, new_fdt_size, 0,
+					&new_fdt_addr,
+					dram_base + ZIMAGE_OFFSET_LIMIT);
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to allocate memory for new device tree.\n");
+			goto fail_free_initrd;
+		}
+
+		/* Now that we have done our final memory allocation (and free)
+		 * we can get the memory map key  needed for
+		 * exit_boot_services().
+		 */
+		status = efi_get_memory_map(sys_table, &memory_map, &map_size,
+					    &desc_size, &desc_ver, &mmap_key);
+		if (status != EFI_SUCCESS)
+			goto fail_free_new_fdt;
+
+		status = update_fdt(sys_table,
+				    fdt, (void *)new_fdt_addr, new_fdt_size,
+				    cmdline_ptr,
+				    initrd_addr, initrd_size,
+				    memory_map, map_size, desc_size, desc_ver);
+
+		/* Succeeding the first time is the expected case. */
+		if (status == EFI_SUCCESS)
+			break;
+
+		if (status == EFI_BUFFER_TOO_SMALL) {
+			/* We need to allocate more space for the new
+			 * device tree, so free existing buffer that is
+			 * too small.  Also free memory map, as we will need
+			 * to get new one that reflects the free/alloc we do
+			 * on the device tree buffer. */
+			efi_free(sys_table, new_fdt_size, new_fdt_addr);
+			efi_call_phys1(sys_table->boottime->free_pool,
+				       memory_map);
+			new_fdt_size += new_fdt_size / 4;
+		} else {
+			efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to constuct new device tree.\n");
+			goto fail_free_mmap;
+		}
+	}
+
+	/* Now we are ready to exit_boot_services.*/
+	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
+				handle, mmap_key);
+
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Exit boot services failed.\n");
+		goto fail_free_mmap;
+	}
+
+
+	/* Now we need to return the FDT address to the calling
+	 * assembly to this can be used as part of normal boot.
+	 */
+	return new_fdt_addr;
+
+fail_free_mmap:
+	efi_call_phys1(sys_table->boottime->free_pool, memory_map);
+
+fail_free_new_fdt:
+	efi_free(sys_table, new_fdt_size, new_fdt_addr);
+
+fail_free_initrd:
+	efi_free(sys_table, initrd_size, initrd_addr);
+
+fail_free_zimage:
+	efi_free(sys_table, zimage_size, *zimage_addr);
+
+fail_free_kernel_reserve:
+	efi_free(sys_table, kernel_reserve_size, kernel_reserve_addr);
+
+fail_free_fdt:
+	efi_free(sys_table, fdt_size, fdt_addr);
+
+fail_free_cmdline:
+	efi_free(sys_table, cmdline_size, (u32)cmdline_ptr);
+
+fail:
+	return EFI_STUB_ERROR;
+}
diff --git a/arch/arm/boot/compressed/efi-stub.h b/arch/arm/boot/compressed/efi-stub.h
new file mode 100644
index 0000000..0fe9376
--- /dev/null
+++ b/arch/arm/boot/compressed/efi-stub.h
@@ -0,0 +1,5 @@
+#ifndef _ARM_EFI_STUB_H
+#define _ARM_EFI_STUB_H
+/* Error code returned to ASM code instead of valid FDT address. */
+#define EFI_STUB_ERROR		(~0)
+#endif
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 066b034..eeb394c 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -10,6 +10,7 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include "efi-stub.h"
 
 	.arch	armv7-a
 /*
@@ -120,22 +121,93 @@
  */
 		.align
 		.arm				@ Always enter in ARM state
+		.text
 start:
 		.type	start,#function
-		.rept	7
+#ifdef CONFIG_EFI_STUB
+		@ Magic MSDOS signature for PE/COFF + ADD opcode
+		@ the EFI stub only supports little endian, as the EFI functions
+		@ it invokes are little endian.
+		.word	0x62805a4d
+#else
+		mov	r0, r0
+#endif
+		.rept	5
 		mov	r0, r0
 		.endr
-   ARM(		mov	r0, r0		)
-   ARM(		b	1f		)
- THUMB(		adr	r12, BSYM(1f)	)
- THUMB(		bx	r12		)
+
+		adrl	r12, BSYM(zimage_continue)
+ ARM(		mov     pc, r12 )
+ THUMB(		bx	r12     )
+		@ zimage_continue will be in ARM or thumb mode as configured
 
 		.word	0x016f2818		@ Magic numbers to help the loader
 		.word	start			@ absolute load/run zImage address
 		.word	_edata			@ zImage end address
+
+#ifdef CONFIG_EFI_STUB
+		@ Portions of the MSDOS file header must be at offset
+		@ 0x3c from the start of the file.  All PE/COFF headers
+		@ are kept contiguous for simplicity.
+#include "efi-header.S"
+
+efi_stub_entry:
+		@ The EFI stub entry point is not at a fixed address, however
+		@ this address must be set in the PE/COFF header.
+		@ EFI entry point is in A32 mode, switch to T32 if configured.
+ THUMB(		adr	r12, BSYM(1f)	)
+ THUMB(		bx	r12		)
  THUMB(		.thumb			)
 1:
  ARM_BE8(	setend	be )			@ go BE8 if compiled for BE8
+		@ Save lr on stack for possible return to EFI firmware.
+		@ Don't care about fp, but need 64 bit alignment....
+		stmfd	sp!, {fp, lr}
+
+		@ allocate space on stack for passing current zImage address
+		@ and for the EFI stub to return of new entry point of
+		@ zImage, as EFI stub may copy the kernel.  Pointer address
+		@ is passed in r2.  r0 and r1 are passed through from the
+		@ EFI firmware to efi_entry
+		adr	r3, start
+		str	r3, [sp, #-8]!
+		mov	r2, sp			@ pass pointer in r2
+		bl	efi_entry
+		ldr	r3, [sp], #8	@ get new zImage address from stack
+
+		@ Check for error return from EFI stub.  r0 has FDT address
+		@ or EFI_STUB_ERROR error code.
+		cmp	r0, #EFI_STUB_ERROR
+		beq	efi_load_fail
+
+		@ Save return values of efi_entry
+		stmfd	sp!, {r0, r3}
+		bl	cache_clean_flush
+		bl	cache_off
+		ldmfd   sp!, {r0, r3}
+
+		@ Set parameters for booting zImage according to boot protocol
+		@ put FDT address in r2, it was returned by efi_entry()
+		@ r1 is FDT machine type, and r0 needs to be 0
+		mov	r2, r0
+		mov	r1, #0xFFFFFFFF
+		mov	r0, #0
+
+		@ Branch to (possibly) relocated zImage that is in r3
+		@ Make sure we are in A32 mode, as zImage requires
+ THUMB(		bx	r3		)
+ ARM(		mov	pc, r3		)
+
+efi_load_fail:
+		@ Return EFI_LOAD_ERROR to EFI firmware on error.
+		@ Switch back to ARM mode for EFI is done based on
+		@ return address on stack in case we are in THUMB mode
+		ldr	r0, =0x80000001
+		ldmfd	sp!, {fp, pc}		@ put lr from stack into pc
+#endif
+
+ THUMB(		.thumb			)
+zimage_continue:
 		mrs	r9, cpsr
 #ifdef CONFIG_ARM_VIRT_EXT
 		bl	__hyp_stub_install	@ get into SVC mode, reversibly
@@ -168,7 +240,6 @@ not_angel:
 		 * by the linker here, but it should preserve r7, r8, and r9.
 		 */
 
-		.text
 
 #ifdef CONFIG_AUTO_ZRELADDR
 		@ determine final kernel image address
-- 
1.7.10.4

