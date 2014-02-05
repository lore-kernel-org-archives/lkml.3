Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaBERHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:07:33 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:46328 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaBERFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:05:35 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc: patches@linaro.org, Mark Salter <msalter@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 17/22] arm64: add EFI stub
Date: Wed,  5 Feb 2014 17:04:08 +0000
Message-Id: <1391619853-10601-18-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

This patch adds PE/COFF header fields to the start of the Image
so that it appears as an EFI application to EFI firmware. An EFI
stub is included to allow direct booting of the kernel Image.
Support in the COFF header for signed images was provided by
Ard Biesheuvel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/arm64/Kconfig            |   10 ++++
 arch/arm64/kernel/Makefile    |    3 ++
 arch/arm64/kernel/efi-entry.S |   93 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/efi-stub.c  |   67 ++++++++++++++++++++++++
 arch/arm64/kernel/head.S      |  112 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 285 insertions(+)
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0e7b443..355f87c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -258,6 +258,16 @@ config CMDLINE_FORCE
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
 
+config EFI_STUB
+	bool "EFI stub support"
+	depends on OF
+	select LIBFDT
+	default y
+	help
+	  This kernel feature allows an Image to be loaded directly
+	  by EFI firmware without the use of a bootloader.
+	  See Documentation/efi-stub.txt for more information.
+
 endmenu
 
 menu "Userspace binary formats"
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2d4554b..0f60b45 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -4,6 +4,8 @@
 
 CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
+			   -I$(src)/../../../scripts/dtc/libfdt
 
 # Object file lists.
 arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
@@ -20,6 +22,7 @@ arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
+arm64-obj-$(CONFIG_EFI_STUB)		+= efi-stub.o efi-entry.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
new file mode 100644
index 0000000..83bfb72
--- /dev/null
+++ b/arch/arm64/kernel/efi-entry.S
@@ -0,0 +1,93 @@
+/*
+ * EFI entry point.
+ *
+ * Copyright (C) 2013 Red Hat, Inc.
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/assembler.h>
+
+#define EFI_LOAD_ERROR 0x8000000000000001
+
+	__INIT
+
+	/*
+	 * We arrive here from the EFI boot manager with:
+	 *
+	 *    * MMU on with identity-mapped RAM.
+	 *    * Icache and Dcache on
+	 *
+	 * We will most likely be running from some place other than where
+	 * we want to be. The kernel image wants to be placed at TEXT_OFFSET
+	 * from start of RAM.
+	 */
+ENTRY(efi_stub_entry)
+	stp	x29, x30, [sp, #-32]!
+
+	/*
+	 * Call efi_entry to do the real work.
+	 * x0 and x1 are already set up by firmware. Current runtime
+	 * address of image is calculated and passed via *image_addr.
+	 *
+	 * unsigned long efi_entry(void *handle,
+	 *                         efi_system_table_t *sys_table,
+	 *                         unsigned long *image_addr) ;
+	 */
+	adrp	x8, _text
+        add	x8, x8, #:lo12:_text
+	add	x2, sp, 16
+	str	x8, [x2]
+	bl	efi_entry
+	cmn	x0, #1
+	b.eq	efi_load_fail
+
+	/*
+	 * efi_entry() will have relocated the kernel image if necessary
+	 * and we return here with device tree address in x0 and the kernel
+	 * entry point stored at *image_addr. Save those values in registers
+	 * which are preserved by __flush_dcache_all.
+	 */
+	ldr	x1, [sp, #16]
+	mov	x20, x0
+	mov	x21, x1
+
+	/* Turn off Dcache and MMU */
+	mrs	x0, CurrentEL
+	cmp	x0, #PSR_MODE_EL2t
+	ccmp	x0, #PSR_MODE_EL2h, #0x4, ne
+	b.ne	1f
+	mrs	x0, sctlr_el2
+	bic	x0, x0, #1 << 0	// clear SCTLR.M
+	bic	x0, x0, #1 << 2	// clear SCTLR.C
+	msr	sctlr_el2, x0
+	isb
+	b	2f
+1:
+	mrs	x0, sctlr_el1
+	bic	x0, x0, #1 << 0	// clear SCTLR.M
+	bic	x0, x0, #1 << 2	// clear SCTLR.C
+	msr	sctlr_el1, x0
+	isb
+2:
+	bl	__flush_dcache_all
+
+	/* Jump to real entry point */
+	mov	x0, x20
+	mov	x1, xzr
+	mov	x2, xzr
+	mov	x3, xzr
+	br	x21
+
+efi_load_fail:
+	mov	x0, #EFI_LOAD_ERROR
+	ldp	x29, x30, [sp], #32
+	ret
+
+ENDPROC(efi_stub_entry)
diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
new file mode 100644
index 0000000..17f5cc3
--- /dev/null
+++ b/arch/arm64/kernel/efi-stub.c
@@ -0,0 +1,67 @@
+/*
+ * linux/arch/arm/boot/compressed/efi-stub.c
+ *
+ * Copyright (C) 2013, 2014 Linaro Ltd;  <roy.franz@linaro.org>
+ *
+ * This file implements the EFI boot stub for the arm64 kernel.
+ * Adapted from ARM version by Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/efi.h>
+#include <linux/libfdt.h>
+#include <asm/sections.h>
+#include <generated/compile.h>
+#include <generated/utsrelease.h>
+
+/*
+ * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
+ * start of kernel and may not cross a 2MiB boundary. We set alignment to
+ * 2MiB so we know it won't cross a 2MiB boundary.
+ */
+#define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
+#define MAX_FDT_OFFSET	SZ_512M
+
+/* Include shared EFI stub code */
+#include "../../../drivers/firmware/efi/efi-stub-helper.c"
+#include "../../../drivers/firmware/efi/fdt.c"
+#include "../../../drivers/firmware/efi/arm-stub.c"
+
+
+static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+					unsigned long *image_addr,
+					unsigned long *image_size,
+					unsigned long *reserve_addr,
+					unsigned long *reserve_size,
+					unsigned long dram_base,
+					efi_loaded_image_t *image)
+{
+	efi_status_t status;
+	unsigned long kernel_size, kernel_memsize = 0;
+
+	/* Relocate the image, if required. */
+	kernel_size = _edata - _text;
+	if (*image_addr != (dram_base + TEXT_OFFSET)) {
+		kernel_memsize = kernel_size + (_end - _edata);
+		status = efi_relocate_kernel(sys_table, image_addr,
+					     kernel_size, kernel_memsize,
+					     dram_base + TEXT_OFFSET,
+					     PAGE_SIZE);
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table, "Failed to relocate kernel\n");
+			return status;
+		}
+		if (*image_addr != (dram_base + TEXT_OFFSET)) {
+			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
+			efi_free(sys_table, kernel_memsize, *image_addr);
+			return EFI_ERROR;
+		}
+		*image_size = kernel_memsize;
+	}
+
+
+	return EFI_SUCCESS;
+}
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index c86bfdf..2f07979 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -107,8 +107,18 @@
 	/*
 	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
 	 */
+#ifdef CONFIG_EFI_STUB
+	/*
+	 * Magic "MZ" signature for PE/COFF
+	 * Little Endian:  add x13, x18, #0x16
+	 */
+efi_head:
+	.long   0x91005a4d
+	b	stext
+#else
 	b	stext				// branch to kernel start, magic
 	.long	0				// reserved
+#endif
 	.quad	TEXT_OFFSET			// Image load offset from start of RAM
 	.quad	0				// reserved
 	.quad	0				// reserved
@@ -119,7 +129,109 @@
 	.byte	0x52
 	.byte	0x4d
 	.byte	0x64
+#ifdef CONFIG_EFI_STUB
+	.long	pe_header - efi_head		// Offset to the PE header.
+#else
 	.word	0				// reserved
+#endif
+
+#ifdef CONFIG_EFI_STUB
+	.align 3
+pe_header:
+	.ascii	"PE"
+	.short 	0
+coff_header:
+	.short	0xaa64				// AArch64
+	.short	2				// nr_sections
+	.long	0 				// TimeDateStamp
+	.long	0				// PointerToSymbolTable
+	.long	1				// NumberOfSymbols
+	.short	section_table - optional_header	// SizeOfOptionalHeader
+	.short	0x206				// Characteristics.
+						// IMAGE_FILE_DEBUG_STRIPPED |
+						// IMAGE_FILE_EXECUTABLE_IMAGE |
+						// IMAGE_FILE_LINE_NUMS_STRIPPED
+optional_header:
+	.short	0x20b				// PE32+ format
+	.byte	0x02				// MajorLinkerVersion
+	.byte	0x14				// MinorLinkerVersion
+	.long	_edata - stext			// SizeOfCode
+	.long	0				// SizeOfInitializedData
+	.long	0				// SizeOfUninitializedData
+	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
+	.long	stext - efi_head		// BaseOfCode
+
+extra_header_fields:
+	.quad	0				// ImageBase
+	.long	0x20				// SectionAlignment
+	.long	0x8				// FileAlignment
+	.short	0				// MajorOperatingSystemVersion
+	.short	0				// MinorOperatingSystemVersion
+	.short	0				// MajorImageVersion
+	.short	0				// MinorImageVersion
+	.short	0				// MajorSubsystemVersion
+	.short	0				// MinorSubsystemVersion
+	.long	0				// Win32VersionValue
+
+	.long	_edata - efi_head		// SizeOfImage
+
+	// Everything before the kernel image is considered part of the header
+	.long	stext - efi_head			// SizeOfHeaders
+	.long	0				// CheckSum
+	.short	0xa				// Subsystem (EFI application)
+	.short	0				// DllCharacteristics
+	.quad	0				// SizeOfStackReserve
+	.quad	0				// SizeOfStackCommit
+	.quad	0				// SizeOfHeapReserve
+	.quad	0				// SizeOfHeapCommit
+	.long	0				// LoaderFlags
+	.long	0x6				// NumberOfRvaAndSizes
+
+	.quad	0				// ExportTable
+	.quad	0				// ImportTable
+	.quad	0				// ResourceTable
+	.quad	0				// ExceptionTable
+	.quad	0				// CertificationTable
+	.quad	0				// BaseRelocationTable
+
+	// Section table
+section_table:
+
+	/*
+	 * The EFI application loader requires a relocation section
+	 * because EFI applications must be relocatable.  This is a
+	 * dummy section as far as we are concerned.
+	 */
+	.ascii	".reloc"
+	.byte	0
+	.byte	0			// end of 0 padding of section name
+	.long	0
+	.long	0
+	.long	0			// SizeOfRawData
+	.long	0			// PointerToRawData
+	.long	0			// PointerToRelocations
+	.long	0			// PointerToLineNumbers
+	.short	0			// NumberOfRelocations
+	.short	0			// NumberOfLineNumbers
+	.long	0x42100040		// Characteristics (section flags)
+
+
+	.ascii	".text"
+	.byte	0
+	.byte	0
+	.byte	0        		// end of 0 padding of section name
+	.long	_edata - stext		// VirtualSize
+	.long	stext - efi_head	// VirtualAddress
+	.long	_edata - stext		// SizeOfRawData
+	.long	stext - efi_head	// PointerToRawData
+
+	.long	0		// PointerToRelocations (0 for executables)
+	.long	0		// PointerToLineNumbers (0 for executables)
+	.short	0		// NumberOfRelocations  (0 for executables)
+	.short	0		// NumberOfLineNumbers  (0 for executables)
+	.long	0xe0500020	// Characteristics (section flags)
+	.align 5
+#endif
 
 ENTRY(stext)
 	mov	x21, x0				// x21=FDT
-- 
1.7.10.4

