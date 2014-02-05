Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaBERFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:05:32 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:52060 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaBERFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:05:24 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc: patches@linaro.org, Roy Franz <roy.franz@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 10/22] Add EFI stub for ARM
Date: Wed,  5 Feb 2014 17:04:01 +0000
Message-Id: <1391619853-10601-11-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roy Franz <roy.franz@linaro.org>

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
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 arch/arm/Kconfig                      |   11 +++
 arch/arm/boot/compressed/Makefile     |   17 ++++-
 arch/arm/boot/compressed/efi-header.S |  117 ++++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/efi-stub.c   |  118 +++++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/efi-stub.h   |    5 ++
 arch/arm/boot/compressed/head.S       |   83 +++++++++++++++++++++--
 6 files changed, 342 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/boot/compressed/efi-stub.c
 create mode 100644 arch/arm/boot/compressed/efi-stub.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ef2aa77..a693921 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1885,6 +1885,17 @@ config EARLY_IOREMAP
 	  the same virtual memory range as kmap so all early mappings must
 	  be unapped before paging_init() is called.
 
+config EFI_STUB
+	bool "EFI stub support"
+	depends on EFI && !CPU_BIG_ENDIAN
+	---help---
+	  This kernel feature allows a zImage to be loaded directly by EFI
+	  firmware without the use of a bootloader.  A PE/COFF header is
+	  added to the zImage in a way that makes the binary both a Linux
+	  zImage and an PE/COFF executable that can be executed directly by
+	  EFI firmware.
+	  See Documentation/efi-stub.txt for more information.
+
 config SECCOMP
 	bool
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 68c9183..1415411 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -91,7 +91,7 @@ suffix_$(CONFIG_KERNEL_LZ4)  = lz4
 
 # Borrowed libfdt files for the ATAG compatibility mode
 
-libfdt		:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c
+libfdt		:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c
 libfdt_hdrs	:= fdt.h libfdt.h libfdt_internal.h
 
 libfdt_objs	:= $(addsuffix .o, $(basename $(libfdt)))
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
index 0000000..dba8037
--- /dev/null
+++ b/arch/arm/boot/compressed/efi-stub.c
@@ -0,0 +1,118 @@
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
+#include <generated/compile.h>
+#include <generated/utsrelease.h>
+#include "efi-stub.h"
+
+/*
+ * The maximum uncompressed kernel size is 32 MBytes, so we will reserve
+ * that for the decompressed kernel.  We have no easy way to tell what
+ * the actuall size of code + data the uncompressed kernel will use.
+ */
+#define MAX_UNCOMP_KERNEL_SIZE	0x02000000
+
+/*
+ * The kernel zImage should be located between 32 Mbytes
+ * and 128 MBytes from the base of DRAM.  The min
+ * address leaves space for a maximal size uncompressed image,
+ * and the max address is due to how the zImage decompressor
+ * picks a destination address.
+ */
+#define ZIMAGE_OFFSET_LIMIT	0x08000000
+#define MIN_ZIMAGE_OFFSET	MAX_UNCOMP_KERNEL_SIZE
+#define MAX_FDT_OFFSET		ZIMAGE_OFFSET_LIMIT
+
+/* Include shared EFI stub code, and required headers. */
+#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
+#include "../../../../drivers/firmware/efi/fdt.c"
+#include "../../../drivers/firmware/efi/arm-stub.c"
+
+static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+					unsigned long *image_addr,
+					unsigned long *image_size,
+					unsigned long *reserve_addr,
+					unsigned long *reserve_size,
+					unsigned long dram_base,
+					efi_loaded_image_t *image)
+{
+	unsigned long nr_pages;
+	efi_status_t status;
+	/* Use alloc_addr to tranlsate between types */
+	efi_physical_addr_t alloc_addr;
+
+	/*
+	 * Verify that the DRAM base address is compatible the the ARM
+	 * boot protocol, which determines the base of DRAM by masking
+	 * off the low 24 bits of the address at which the zImage is
+	 * loaded at.  These assumptions are made by the decompressor,
+	 * before any memory map is available.
+	 */
+	if (dram_base & (ZIMAGE_OFFSET_LIMIT - 1)) {
+		pr_efi_err(sys_table, "Invalid DRAM base address alignment.\n");
+		return EFI_ERROR;
+	}
+
+	/*
+	 * Reserve memory for the uncompressed kernel image. This is
+	 * all that prevents any future allocations from conflicting
+	 * with the kernel.  Since we can't tell from the compressed
+	 * image how much DRAM the kernel actually uses (due to BSS
+	 * size uncertainty) we allocate the maximum possible size.
+	 * Do this very early, as prints can cause memory allocations
+	 * that may conflict with this.
+	 */
+	alloc_addr = dram_base;
+	*reserve_size = MAX_UNCOMP_KERNEL_SIZE;
+	nr_pages = round_up(*reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	status = efi_call_phys4(sys_table->boottime->allocate_pages,
+				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				nr_pages, &alloc_addr);
+	if (status != EFI_SUCCESS) {
+		*reserve_size = 0;
+		pr_efi_err(sys_table, "Unable to allocate memory for uncompressed kernel.\n");
+		return status;
+	}
+	*reserve_addr = alloc_addr;
+
+	/*
+	 * Relocate the zImage, if required.  ARM doesn't have a
+	 * preferred address, so we set it to 0, as we want to allocate
+	 * as low in memory as possible.
+	 */
+	*image_size = image->image_size;
+	status = efi_relocate_kernel(sys_table, image_addr, *image_size,
+				     *image_size, 0, 0);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to relocate kernel.\n");
+		efi_free(sys_table, *reserve_size, *reserve_addr);
+		*reserve_size = 0;
+		return status;
+	}
+
+	/*
+	 * Check to see if we were able to allocate memory low enough
+	 * in memory.  The kernel determines the base of DRAM from the
+	 * address at which the zImage is loaded.
+	 */
+	if (*image_addr + *image_size > dram_base + ZIMAGE_OFFSET_LIMIT) {
+		pr_efi_err(sys_table, "Failed to relocate kernel, no low memory available.\n");
+		efi_free(sys_table, *reserve_size, *reserve_addr);
+		*reserve_size = 0;
+		efi_free(sys_table, *image_size, *image_addr);
+		*image_size = 0;
+		return EFI_ERROR;
+	}
+	return EFI_SUCCESS;
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

