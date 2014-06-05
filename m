Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaFEUDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:03:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFEUDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:03:31 -0400
Date: Thu, 5 Jun 2014 13:02:42 -0700
Message-Id: <201406052002.s55K2gXB012853@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm64/efi changes for v3.16
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>, Rob Landley <rob@landley.net>,
        Roy Franz <roy.franz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-doc@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

By agreement with the ARM64 EFI maintainers, we have agreed to make
-tip the upstream for all EFI patches.  That is why this patchset
comes from me :)

This patchset enables EFI stub support for ARM64, like we already have
on x86.

The following changes since commit e33655a386ed3b26ad36fb97a47ebb1c2ca1e928:

  efivars: Add compatibility code for compat tasks (2014-04-17 13:53:53 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git arm64-efi-for-linus

for you to fetch changes up to 74bcc2499291d38b6253f9dbd6af33a195222208:

  arm64: efi: only attempt efi map setup if booting via EFI (2014-05-23 15:29:43 +0100)

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm64: ignore dtb= when UEFI SecureBoot is enabled

Leif Lindholm (2):
      doc: arm: add UEFI support documentation
      arm64: efi: only attempt efi map setup if booting via EFI

Mark Salter (6):
      lib: add fdt_empty_tree.c
      efi: add helper function to get UEFI params from FDT
      arm64: Add function to create identity mappings
      arm64: add EFI runtime services
      arm64: efi: add EFI stub
      doc: arm64: add description of EFI stub support

Roy Franz (2):
      doc: efi-stub.txt updates for ARM
      efi: Add shared FDT related functions for ARM/ARM64

 Documentation/arm/00-INDEX      |   2 +
 Documentation/arm/uefi.txt      |  64 ++++++
 Documentation/arm64/booting.txt |   4 +
 Documentation/efi-stub.txt      |  33 ++-
 arch/arm64/Kconfig              |  16 ++
 arch/arm64/include/asm/efi.h    |  14 ++
 arch/arm64/include/asm/mmu.h    |   2 +
 arch/arm64/kernel/Makefile      |   3 +
 arch/arm64/kernel/efi-entry.S   | 109 ++++++++++
 arch/arm64/kernel/efi-stub.c    |  81 +++++++
 arch/arm64/kernel/efi.c         | 469 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S        | 112 ++++++++++
 arch/arm64/kernel/setup.c       |   5 +
 arch/arm64/mm/mmu.c             |  65 ++++--
 drivers/firmware/efi/Kconfig    |   7 +
 drivers/firmware/efi/arm-stub.c | 278 ++++++++++++++++++++++++
 drivers/firmware/efi/efi.c      |  79 +++++++
 drivers/firmware/efi/fdt.c      | 285 ++++++++++++++++++++++++
 include/linux/efi.h             |  12 +
 lib/Makefile                    |   3 +-
 lib/fdt_empty_tree.c            |   2 +
 21 files changed, 1619 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c
 create mode 100644 arch/arm64/kernel/efi.c
 create mode 100644 drivers/firmware/efi/arm-stub.c
 create mode 100644 drivers/firmware/efi/fdt.c
 create mode 100644 lib/fdt_empty_tree.c

diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
index a94090cc785d..3b08bc2b04cf 100644
--- a/Documentation/arm/00-INDEX
+++ b/Documentation/arm/00-INDEX
@@ -46,5 +46,7 @@ swp_emulation
 	- SWP/SWPB emulation handler/logging description
 tcm.txt
 	- ARM Tightly Coupled Memory
+uefi.txt
+	- [U]EFI configuration and runtime services documentation
 vlocks.txt
 	- Voting locks, low-level mechanism relying on memory system atomic writes.
diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
new file mode 100644
index 000000000000..d60030a1b909
--- /dev/null
+++ b/Documentation/arm/uefi.txt
@@ -0,0 +1,64 @@
+UEFI, the Unified Extensible Firmware Interface, is a specification
+governing the behaviours of compatible firmware interfaces. It is
+maintained by the UEFI Forum - http://www.uefi.org/.
+
+UEFI is an evolution of its predecessor 'EFI', so the terms EFI and
+UEFI are used somewhat interchangeably in this document and associated
+source code. As a rule, anything new uses 'UEFI', whereas 'EFI' refers
+to legacy code or specifications.
+
+UEFI support in Linux
+=====================
+Booting on a platform with firmware compliant with the UEFI specification
+makes it possible for the kernel to support additional features:
+- UEFI Runtime Services
+- Retrieving various configuration information through the standardised
+  interface of UEFI configuration tables. (ACPI, SMBIOS, ...)
+
+For actually enabling [U]EFI support, enable:
+- CONFIG_EFI=y
+- CONFIG_EFI_VARS=y or m
+
+The implementation depends on receiving information about the UEFI environment
+in a Flattened Device Tree (FDT) - so is only available with CONFIG_OF.
+
+UEFI stub
+=========
+The "stub" is a feature that extends the Image/zImage into a valid UEFI
+PE/COFF executable, including a loader application that makes it possible to
+load the kernel directly from the UEFI shell, boot menu, or one of the
+lightweight bootloaders like Gummiboot or rEFInd.
+
+The kernel image built with stub support remains a valid kernel image for
+booting in non-UEFI environments.
+
+UEFI kernel support on ARM
+==========================
+UEFI kernel support on the ARM architectures (arm and arm64) is only available
+when boot is performed through the stub.
+
+When booting in UEFI mode, the stub deletes any memory nodes from a provided DT.
+Instead, the kernel reads the UEFI memory map.
+
+The stub populates the FDT /chosen node with (and the kernel scans for) the
+following parameters:
+________________________________________________________________________________
+Name                      | Size   | Description
+================================================================================
+linux,uefi-system-table   | 64-bit | Physical address of the UEFI System Table.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-start     | 64-bit | Physical address of the UEFI memory map,
+                          |        | populated by the UEFI GetMemoryMap() call.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-size      | 32-bit | Size in bytes of the UEFI memory map
+                          |        | pointed to in previous entry.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
+                          |        | memory map.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
+--------------------------------------------------------------------------------
+linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
+--------------------------------------------------------------------------------
+
+For verbose debug messages, specify 'uefi_debug' on the kernel command line.
diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index beb754e87c65..37fc4f632176 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -85,6 +85,10 @@ The decompressed kernel image contains a 64-byte header as follows:
 Header notes:
 
 - code0/code1 are responsible for branching to stext.
+- when booting through EFI, code0/code1 are initially skipped.
+  res5 is an offset to the PE header and the PE header has the EFI
+  entry point (efi_stub_entry). When the stub has done its work, it
+  jumps to code0 to resume the normal boot process.
 
 The image must be placed at the specified offset (currently 0x80000)
 from the start of the system RAM and called there. The start of the
diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index c628788d5b47..7747024d3bb7 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -1,13 +1,21 @@
 			  The EFI Boot Stub
 		     ---------------------------
 
-On the x86 platform, a bzImage can masquerade as a PE/COFF image,
-thereby convincing EFI firmware loaders to load it as an EFI
-executable. The code that modifies the bzImage header, along with the
-EFI-specific entry point that the firmware loader jumps to are
-collectively known as the "EFI boot stub", and live in
+On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade
+as a PE/COFF image, thereby convincing EFI firmware loaders to load
+it as an EFI executable. The code that modifies the bzImage header,
+along with the EFI-specific entry point that the firmware loader
+jumps to are collectively known as the "EFI boot stub", and live in
 arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
-respectively.
+respectively. For ARM the EFI stub is implemented in
+arch/arm/boot/compressed/efi-header.S and
+arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
+between architectures is in drivers/firmware/efi/efi-stub-helper.c.
+
+For arm64, there is no compressed kernel support, so the Image itself
+masquerades as a PE/COFF image and the EFI stub is linked into the
+kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
+and arch/arm64/kernel/efi-stub.c.
 
 By using the EFI boot stub it's possible to boot a Linux kernel
 without the use of a conventional EFI boot loader, such as grub or
@@ -23,7 +31,10 @@ The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
 System Partition (ESP) and renamed with the extension ".efi". Without
 the extension the EFI firmware loader will refuse to execute it. It's
 not possible to execute bzImage.efi from the usual Linux file systems
-because EFI firmware doesn't have support for them.
+because EFI firmware doesn't have support for them. For ARM the
+arch/arm/boot/zImage should be copied to the system partition, and it
+may not need to be renamed. Similarly for arm64, arch/arm64/boot/Image
+should be copied but not necessarily renamed.
 
 
 **** Passing kernel parameters from the EFI shell
@@ -63,3 +74,11 @@ Notice how bzImage.efi can be specified with a relative path. That's
 because the image we're executing is interpreted by the EFI shell,
 which understands relative paths, whereas the rest of the command line
 is passed to bzImage.efi.
+
+
+**** The "dtb=" option
+
+For the ARM and arm64 architectures, we also need to be able to provide a
+device tree to the kernel. This is done with the "dtb=" command line option,
+and is processed in the same manner as the "initrd=" option that is
+described above.
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d3749a6e..6c71f122638d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -280,6 +280,20 @@ config CMDLINE_FORCE
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
 
+config EFI
+	bool "UEFI runtime support"
+	depends on OF && !CPU_BIG_ENDIAN
+	select LIBFDT
+	select UCS2_STRING
+	select EFI_PARAMS_FROM_FDT
+	default y
+	help
+	  This option provides support for runtime services provided
+	  by UEFI firmware (such as non-volatile variables, realtime
+          clock, and platform reset). A UEFI stub is also provided to
+	  allow the kernel to be booted as an EFI application. This
+	  is only useful on systems that have UEFI firmware.
+
 endmenu
 
 menu "Userspace binary formats"
@@ -333,6 +347,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
new file mode 100644
index 000000000000..5a46c4e7f539
--- /dev/null
+++ b/arch/arm64/include/asm/efi.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_EFI_H
+#define _ASM_EFI_H
+
+#include <asm/io.h>
+
+#ifdef CONFIG_EFI
+extern void efi_init(void);
+extern void efi_idmap_init(void);
+#else
+#define efi_init()
+#define efi_idmap_init()
+#endif
+
+#endif /* _ASM_EFI_H */
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index f600d400c07d..29ed1d865e13 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -28,5 +28,7 @@ extern void paging_init(void);
 extern void setup_mm_for_reboot(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
+/* create an identity mapping for memory (or io if map_io is true) */
+extern void create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io);
 
 #endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7d811d9522bc..db63a0a25810 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -4,6 +4,8 @@
 
 CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
+			   -I$(src)/../../../scripts/dtc/libfdt
 
 # Object file lists.
 arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
@@ -22,6 +24,7 @@ arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
+arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
new file mode 100644
index 000000000000..66716c9b9e5f
--- /dev/null
+++ b/arch/arm64/kernel/efi-entry.S
@@ -0,0 +1,109 @@
+/*
+ * EFI entry point.
+ *
+ * Copyright (C) 2013, 2014 Red Hat, Inc.
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
+	 *    * CPU in little-endian mode
+	 *    * MMU on with identity-mapped RAM
+	 *    * Icache and Dcache on
+	 *
+	 * We will most likely be running from some place other than where
+	 * we want to be. The kernel image wants to be placed at TEXT_OFFSET
+	 * from start of RAM.
+	 */
+ENTRY(efi_stub_entry)
+	/*
+	 * Create a stack frame to save FP/LR with extra space
+	 * for image_addr variable passed to efi_entry().
+	 */
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
+	add	x8, x8, #:lo12:_text
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
+	 * which are callee preserved.
+	 */
+	mov	x20, x0		// DTB address
+	ldr	x0, [sp, #16]	// relocated _text address
+	mov	x21, x0
+
+	/*
+	 * Flush dcache covering current runtime addresses
+	 * of kernel text/data. Then flush all of icache.
+	 */
+	adrp	x1, _text
+	add	x1, x1, #:lo12:_text
+	adrp	x2, _edata
+	add	x2, x2, #:lo12:_edata
+	sub	x1, x2, x1
+
+	bl	__flush_dcache_area
+	ic	ialluis
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
+	/* Jump to kernel entry point */
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
index 000000000000..60e98a639ac5
--- /dev/null
+++ b/arch/arm64/kernel/efi-stub.c
@@ -0,0 +1,81 @@
+/*
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
+#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
+
+static void efi_char16_printk(efi_system_table_t *sys_table_arg,
+			      efi_char16_t *str);
+
+static efi_status_t efi_open_volume(efi_system_table_t *sys_table,
+				    void *__image, void **__fh);
+static efi_status_t efi_file_close(void *handle);
+
+static efi_status_t
+efi_file_read(void *handle, unsigned long *size, void *addr);
+
+static efi_status_t
+efi_file_size(efi_system_table_t *sys_table, void *__fh,
+	      efi_char16_t *filename_16, void **handle, u64 *file_sz);
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
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
new file mode 100644
index 000000000000..14db1f6e8d7f
--- /dev/null
+++ b/arch/arm64/kernel/efi.c
@@ -0,0 +1,469 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 2.4
+ *
+ * Copyright (C) 2013, 2014 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/memblock.h>
+#include <linux/bootmem.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <asm/cacheflush.h>
+#include <asm/efi.h>
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+
+struct efi_memory_map memmap;
+
+static efi_runtime_services_t *runtime;
+
+static u64 efi_system_table;
+
+static int uefi_debug __initdata;
+static int __init uefi_debug_setup(char *str)
+{
+	uefi_debug = 1;
+
+	return 0;
+}
+early_param("uefi_debug", uefi_debug_setup);
+
+static int __init is_normal_ram(efi_memory_desc_t *md)
+{
+	if (md->attribute & EFI_MEMORY_WB)
+		return 1;
+	return 0;
+}
+
+static void __init efi_setup_idmap(void)
+{
+	struct memblock_region *r;
+	efi_memory_desc_t *md;
+	u64 paddr, npages, size;
+
+	for_each_memblock(memory, r)
+		create_id_mapping(r->base, r->size, 0);
+
+	/* map runtime io spaces */
+	for_each_efi_memory_desc(&memmap, md) {
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) || is_normal_ram(md))
+			continue;
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+		create_id_mapping(paddr, size, 1);
+	}
+}
+
+static int __init uefi_init(void)
+{
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i, retval;
+
+	efi.systab = early_memremap(efi_system_table,
+				    sizeof(efi_system_table_t));
+	if (efi.systab == NULL) {
+		pr_warn("Unable to map EFI system table.\n");
+		return -ENOMEM;
+	}
+
+	set_bit(EFI_BOOT, &efi.flags);
+	set_bit(EFI_64BIT, &efi.flags);
+
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
+		pr_err("System table signature incorrect\n");
+		return -EINVAL;
+	}
+	if ((efi.systab->hdr.revision >> 16) < 2)
+		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = early_memremap(efi.systab->fw_vendor,
+			     sizeof(vendor));
+	if (c16) {
+		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
+			vendor[i] = c16[i];
+		vendor[i] = '\0';
+	}
+
+	pr_info("EFI v%u.%.02u by %s\n",
+		efi.systab->hdr.revision >> 16,
+		efi.systab->hdr.revision & 0xffff, vendor);
+
+	retval = efi_config_init(NULL);
+	if (retval == 0)
+		set_bit(EFI_CONFIG_TABLES, &efi.flags);
+
+	early_memunmap(c16, sizeof(vendor));
+	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
+
+	return retval;
+}
+
+static __initdata char memory_type_name[][32] = {
+	{"Reserved"},
+	{"Loader Code"},
+	{"Loader Data"},
+	{"Boot Code"},
+	{"Boot Data"},
+	{"Runtime Code"},
+	{"Runtime Data"},
+	{"Conventional Memory"},
+	{"Unusable Memory"},
+	{"ACPI Reclaim Memory"},
+	{"ACPI Memory NVS"},
+	{"Memory Mapped I/O"},
+	{"MMIO Port Space"},
+	{"PAL Code"},
+};
+
+/*
+ * Return true for RAM regions we want to permanently reserve.
+ */
+static __init int is_reserve_region(efi_memory_desc_t *md)
+{
+	if (!is_normal_ram(md))
+		return 0;
+
+	if (md->attribute & EFI_MEMORY_RUNTIME)
+		return 1;
+
+	if (md->type == EFI_ACPI_RECLAIM_MEMORY ||
+	    md->type == EFI_RESERVED_TYPE)
+		return 1;
+
+	return 0;
+}
+
+static __init void reserve_regions(void)
+{
+	efi_memory_desc_t *md;
+	u64 paddr, npages, size;
+
+	if (uefi_debug)
+		pr_info("Processing EFI memory map:\n");
+
+	for_each_efi_memory_desc(&memmap, md) {
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+
+		if (uefi_debug)
+			pr_info("  0x%012llx-0x%012llx [%s]",
+				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
+				memory_type_name[md->type]);
+
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		if (is_normal_ram(md))
+			early_init_dt_add_memory_arch(paddr, size);
+
+		if (is_reserve_region(md) ||
+		    md->type == EFI_BOOT_SERVICES_CODE ||
+		    md->type == EFI_BOOT_SERVICES_DATA) {
+			memblock_reserve(paddr, size);
+			if (uefi_debug)
+				pr_cont("*");
+		}
+
+		if (uefi_debug)
+			pr_cont("\n");
+	}
+}
+
+
+static u64 __init free_one_region(u64 start, u64 end)
+{
+	u64 size = end - start;
+
+	if (uefi_debug)
+		pr_info("  EFI freeing: 0x%012llx-0x%012llx\n",	start, end - 1);
+
+	free_bootmem_late(start, size);
+	return size;
+}
+
+static u64 __init free_region(u64 start, u64 end)
+{
+	u64 map_start, map_end, total = 0;
+
+	if (end <= start)
+		return total;
+
+	map_start = (u64)memmap.phys_map;
+	map_end = PAGE_ALIGN(map_start + (memmap.map_end - memmap.map));
+	map_start &= PAGE_MASK;
+
+	if (start < map_end && end > map_start) {
+		/* region overlaps UEFI memmap */
+		if (start < map_start)
+			total += free_one_region(start, map_start);
+
+		if (map_end < end)
+			total += free_one_region(map_end, end);
+	} else
+		total += free_one_region(start, end);
+
+	return total;
+}
+
+static void __init free_boot_services(void)
+{
+	u64 total_freed = 0;
+	u64 keep_end, free_start, free_end;
+	efi_memory_desc_t *md;
+
+	/*
+	 * If kernel uses larger pages than UEFI, we have to be careful
+	 * not to inadvertantly free memory we want to keep if there is
+	 * overlap at the kernel page size alignment. We do not want to
+	 * free is_reserve_region() memory nor the UEFI memmap itself.
+	 *
+	 * The memory map is sorted, so we keep track of the end of
+	 * any previous region we want to keep, remember any region
+	 * we want to free and defer freeing it until we encounter
+	 * the next region we want to keep. This way, before freeing
+	 * it, we can clip it as needed to avoid freeing memory we
+	 * want to keep for UEFI.
+	 */
+
+	keep_end = 0;
+	free_start = 0;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		u64 paddr, npages, size;
+
+		if (is_reserve_region(md)) {
+			/*
+			 * We don't want to free any memory from this region.
+			 */
+			if (free_start) {
+				/* adjust free_end then free region */
+				if (free_end > md->phys_addr)
+					free_end -= PAGE_SIZE;
+				total_freed += free_region(free_start, free_end);
+				free_start = 0;
+			}
+			keep_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+			continue;
+		}
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA) {
+			/* no need to free this region */
+			continue;
+		}
+
+		/*
+		 * We want to free memory from this region.
+		 */
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		if (free_start) {
+			if (paddr <= free_end)
+				free_end = paddr + size;
+			else {
+				total_freed += free_region(free_start, free_end);
+				free_start = paddr;
+				free_end = paddr + size;
+			}
+		} else {
+			free_start = paddr;
+			free_end = paddr + size;
+		}
+		if (free_start < keep_end) {
+			free_start += PAGE_SIZE;
+			if (free_start >= free_end)
+				free_start = 0;
+		}
+	}
+	if (free_start)
+		total_freed += free_region(free_start, free_end);
+
+	if (total_freed)
+		pr_info("Freed 0x%llx bytes of EFI boot services memory",
+			total_freed);
+}
+
+void __init efi_init(void)
+{
+	struct efi_fdt_params params;
+
+	/* Grab UEFI information placed in FDT by stub */
+	if (!efi_get_fdt_params(&params, uefi_debug))
+		return;
+
+	efi_system_table = params.system_table;
+
+	memblock_reserve(params.mmap & PAGE_MASK,
+			 PAGE_ALIGN(params.mmap_size + (params.mmap & ~PAGE_MASK)));
+	memmap.phys_map = (void *)params.mmap;
+	memmap.map = early_memremap(params.mmap, params.mmap_size);
+	memmap.map_end = memmap.map + params.mmap_size;
+	memmap.desc_size = params.desc_size;
+	memmap.desc_version = params.desc_ver;
+
+	if (uefi_init() < 0)
+		return;
+
+	reserve_regions();
+}
+
+void __init efi_idmap_init(void)
+{
+	if (!efi_enabled(EFI_BOOT))
+		return;
+
+	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
+	efi_setup_idmap();
+}
+
+static int __init remap_region(efi_memory_desc_t *md, void **new)
+{
+	u64 paddr, vaddr, npages, size;
+
+	paddr = md->phys_addr;
+	npages = md->num_pages;
+	memrange_efi_to_native(&paddr, &npages);
+	size = npages << PAGE_SHIFT;
+
+	if (is_normal_ram(md))
+		vaddr = (__force u64)ioremap_cache(paddr, size);
+	else
+		vaddr = (__force u64)ioremap(paddr, size);
+
+	if (!vaddr) {
+		pr_err("Unable to remap 0x%llx pages @ %p\n",
+		       npages, (void *)paddr);
+		return 0;
+	}
+
+	/* adjust for any rounding when EFI and system pagesize differs */
+	md->virt_addr = vaddr + (md->phys_addr - paddr);
+
+	if (uefi_debug)
+		pr_info("  EFI remap 0x%012llx => %p\n",
+			md->phys_addr, (void *)md->virt_addr);
+
+	memcpy(*new, md, memmap.desc_size);
+	*new += memmap.desc_size;
+
+	return 1;
+}
+
+/*
+ * Switch UEFI from an identity map to a kernel virtual map
+ */
+static int __init arm64_enter_virtual_mode(void)
+{
+	efi_memory_desc_t *md;
+	phys_addr_t virtmap_phys;
+	void *virtmap, *virt_md;
+	efi_status_t status;
+	u64 mapsize;
+	int count = 0;
+	unsigned long flags;
+
+	if (!efi_enabled(EFI_BOOT)) {
+		pr_info("EFI services will not be available.\n");
+		return -1;
+	}
+
+	pr_info("Remapping and enabling EFI services.\n");
+
+	/* replace early memmap mapping with permanent mapping */
+	mapsize = memmap.map_end - memmap.map;
+	early_memunmap(memmap.map, mapsize);
+	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
+						   mapsize);
+	memmap.map_end = memmap.map + mapsize;
+
+	efi.memmap = &memmap;
+
+	/* Map the runtime regions */
+	virtmap = kmalloc(mapsize, GFP_KERNEL);
+	if (!virtmap) {
+		pr_err("Failed to allocate EFI virtual memmap\n");
+		return -1;
+	}
+	virtmap_phys = virt_to_phys(virtmap);
+	virt_md = virtmap;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (remap_region(md, &virt_md))
+			++count;
+	}
+
+	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
+	if (efi.systab)
+		set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
+	local_irq_save(flags);
+	cpu_switch_mm(idmap_pg_dir, &init_mm);
+
+	/* Call SetVirtualAddressMap with the physical address of the map */
+	runtime = efi.systab->runtime;
+	efi.set_virtual_address_map = runtime->set_virtual_address_map;
+
+	status = efi.set_virtual_address_map(count * memmap.desc_size,
+					     memmap.desc_size,
+					     memmap.desc_version,
+					     (efi_memory_desc_t *)virtmap_phys);
+	cpu_set_reserved_ttbr0();
+	flush_tlb_all();
+	local_irq_restore(flags);
+
+	kfree(virtmap);
+
+	free_boot_services();
+
+	if (status != EFI_SUCCESS) {
+		pr_err("Failed to set EFI virtual address map! [%lx]\n",
+			status);
+		return -1;
+	}
+
+	/* Set up runtime services function pointers */
+	runtime = efi.systab->runtime;
+	efi.get_time = runtime->get_time;
+	efi.set_time = runtime->set_time;
+	efi.get_wakeup_time = runtime->get_wakeup_time;
+	efi.set_wakeup_time = runtime->set_wakeup_time;
+	efi.get_variable = runtime->get_variable;
+	efi.get_next_variable = runtime->get_next_variable;
+	efi.set_variable = runtime->set_variable;
+	efi.query_variable_info = runtime->query_variable_info;
+	efi.update_capsule = runtime->update_capsule;
+	efi.query_capsule_caps = runtime->query_capsule_caps;
+	efi.get_next_high_mono_count = runtime->get_next_high_mono_count;
+	efi.reset_system = runtime->reset_system;
+
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+
+	return 0;
+}
+early_initcall(arm64_enter_virtual_mode);
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 0fd565000772..738291b5be29 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -108,8 +108,18 @@
 	/*
 	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
 	 */
+#ifdef CONFIG_EFI
+efi_head:
+	/*
+	 * This add instruction has no meaningful effect except that
+	 * its opcode forms the magic "MZ" signature required by UEFI.
+	 */
+	add	x13, x18, #0x16
+	b	stext
+#else
 	b	stext				// branch to kernel start, magic
 	.long	0				// reserved
+#endif
 	.quad	TEXT_OFFSET			// Image load offset from start of RAM
 	.quad	0				// reserved
 	.quad	0				// reserved
@@ -120,7 +130,109 @@
 	.byte	0x52
 	.byte	0x4d
 	.byte	0x64
+#ifdef CONFIG_EFI
+	.long	pe_header - efi_head		// Offset to the PE header.
+#else
 	.word	0				// reserved
+#endif
+
+#ifdef CONFIG_EFI
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
+	.long	stext - efi_head		// SizeOfHeaders
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
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 720853f70b6b..0a14aaffc834 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -41,6 +41,7 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
+#include <linux/efi.h>
 
 #include <asm/fixmap.h>
 #include <asm/cputype.h>
@@ -55,6 +56,7 @@
 #include <asm/traps.h>
 #include <asm/memblock.h>
 #include <asm/psci.h>
+#include <asm/efi.h>
 
 unsigned int processor_id;
 EXPORT_SYMBOL(processor_id);
@@ -366,11 +368,14 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	efi_init();
 	arm64_memblock_init();
 
 	paging_init();
 	request_standard_resources();
 
+	efi_idmap_init();
+
 	unflatten_device_tree();
 
 	psci_init();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6b7e89569a3a..971eb45e8bda 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -168,7 +168,8 @@ static void __init *early_alloc(unsigned long sz)
 }
 
 static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
-				  unsigned long end, unsigned long pfn)
+				  unsigned long end, unsigned long pfn,
+				  pgprot_t prot)
 {
 	pte_t *pte;
 
@@ -180,16 +181,28 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
-		set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+		set_pte(pte, pfn_pte(pfn, prot));
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
 static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
-				  unsigned long end, phys_addr_t phys)
+				  unsigned long end, phys_addr_t phys,
+				  int map_io)
 {
 	pmd_t *pmd;
 	unsigned long next;
+	pmdval_t prot_sect;
+	pgprot_t prot_pte;
+
+	if (map_io) {
+		prot_sect = PMD_TYPE_SECT | PMD_SECT_AF |
+			    PMD_ATTRINDX(MT_DEVICE_nGnRE);
+		prot_pte = __pgprot(PROT_DEVICE_nGnRE);
+	} else {
+		prot_sect = prot_sect_kernel;
+		prot_pte = PAGE_KERNEL_EXEC;
+	}
 
 	/*
 	 * Check for initial section mappings in the pgd/pud and remove them.
@@ -205,7 +218,7 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 		/* try section mapping first */
 		if (((addr | next | phys) & ~SECTION_MASK) == 0) {
 			pmd_t old_pmd =*pmd;
-			set_pmd(pmd, __pmd(phys | prot_sect_kernel));
+			set_pmd(pmd, __pmd(phys | prot_sect));
 			/*
 			 * Check for previous table entries created during
 			 * boot (__create_page_tables) and flush them.
@@ -213,21 +226,23 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 			if (!pmd_none(old_pmd))
 				flush_tlb_all();
 		} else {
-			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys));
+			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
+				       prot_pte);
 		}
 		phys += next - addr;
 	} while (pmd++, addr = next, addr != end);
 }
 
 static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
-				  unsigned long end, unsigned long phys)
+				  unsigned long end, unsigned long phys,
+				  int map_io)
 {
 	pud_t *pud = pud_offset(pgd, addr);
 	unsigned long next;
 
 	do {
 		next = pud_addr_end(addr, end);
-		alloc_init_pmd(pud, addr, next, phys);
+		alloc_init_pmd(pud, addr, next, phys, map_io);
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
 }
@@ -236,30 +251,44 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
  * Create the page directory entries and any necessary page tables for the
  * mapping specified by 'md'.
  */
-static void __init create_mapping(phys_addr_t phys, unsigned long virt,
-				  phys_addr_t size)
+static void __init __create_mapping(pgd_t *pgd, phys_addr_t phys,
+				    unsigned long virt, phys_addr_t size,
+				    int map_io)
 {
 	unsigned long addr, length, end, next;
-	pgd_t *pgd;
-
-	if (virt < VMALLOC_START) {
-		pr_warning("BUG: not creating mapping for 0x%016llx at 0x%016lx - outside kernel range\n",
-			   phys, virt);
-		return;
-	}
 
 	addr = virt & PAGE_MASK;
 	length = PAGE_ALIGN(size + (virt & ~PAGE_MASK));
 
-	pgd = pgd_offset_k(addr);
 	end = addr + length;
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_pud(pgd, addr, next, phys);
+		alloc_init_pud(pgd, addr, next, phys, map_io);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void __init create_mapping(phys_addr_t phys, unsigned long virt,
+				  phys_addr_t size)
+{
+	if (virt < VMALLOC_START) {
+		pr_warn("BUG: not creating mapping for %pa at 0x%016lx - outside kernel range\n",
+			&phys, virt);
+		return;
+	}
+	__create_mapping(pgd_offset_k(virt & PAGE_MASK), phys, virt, size, 0);
+}
+
+void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
+{
+	if ((addr >> PGDIR_SHIFT) >= ARRAY_SIZE(idmap_pg_dir)) {
+		pr_warn("BUG: not creating id mapping for %pa\n", &addr);
+		return;
+	}
+	__create_mapping(&idmap_pg_dir[pgd_index(addr)],
+			 addr, addr, size, map_io);
+}
+
 static void __init map_mem(void)
 {
 	struct memblock_region *reg;
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 1e75f48b61f8..d420ae2d3413 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -47,6 +47,13 @@ config EFI_RUNTIME_MAP
 
 	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
 
+config EFI_PARAMS_FROM_FDT
+	bool
+	help
+	  Select this config option from the architecture Kconfig if
+	  the EFI runtime support gets system table address, memory
+          map address, and other parameters from the device tree.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/arm-stub.c
new file mode 100644
index 000000000000..41114ce03b01
--- /dev/null
+++ b/drivers/firmware/efi/arm-stub.c
@@ -0,0 +1,278 @@
+/*
+ * EFI stub implementation that is shared by arm and arm64 architectures.
+ * This should be #included by the EFI stub implementation files.
+ *
+ * Copyright (C) 2013,2014 Linaro Limited
+ *     Roy Franz <roy.franz@linaro.org
+ * Copyright (C) 2013 Red Hat, Inc.
+ *     Mark Salter <msalter@redhat.com>
+ *
+ * This file is part of the Linux kernel, and is made available under the
+ * terms of the GNU General Public License version 2.
+ *
+ */
+
+static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
+{
+	static efi_guid_t const var_guid __initconst = EFI_GLOBAL_VARIABLE_GUID;
+	static efi_char16_t const var_name[] __initconst = {
+		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
+
+	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
+	unsigned long size = sizeof(u8);
+	efi_status_t status;
+	u8 val;
+
+	status = f_getvar((efi_char16_t *)var_name, (efi_guid_t *)&var_guid,
+			  NULL, &size, &val);
+
+	switch (status) {
+	case EFI_SUCCESS:
+		return val;
+	case EFI_NOT_FOUND:
+		return 0;
+	default:
+		return 1;
+	}
+}
+
+static efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
+				    void *__image, void **__fh)
+{
+	efi_file_io_interface_t *io;
+	efi_loaded_image_t *image = __image;
+	efi_file_handle_t *fh;
+	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+	efi_status_t status;
+	void *handle = (void *)(unsigned long)image->device_handle;
+
+	status = sys_table_arg->boottime->handle_protocol(handle,
+				 &fs_proto, (void **)&io);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
+		return status;
+	}
+
+	status = io->open_volume(io, &fh);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table_arg, "Failed to open volume\n");
+
+	*__fh = fh;
+	return status;
+}
+static efi_status_t efi_file_close(void *handle)
+{
+	efi_file_handle_t *fh = handle;
+
+	return fh->close(handle);
+}
+
+static efi_status_t
+efi_file_read(void *handle, unsigned long *size, void *addr)
+{
+	efi_file_handle_t *fh = handle;
+
+	return fh->read(handle, size, addr);
+}
+
+
+static efi_status_t
+efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
+	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
+{
+	efi_file_handle_t *h, *fh = __fh;
+	efi_file_info_t *info;
+	efi_status_t status;
+	efi_guid_t info_guid = EFI_FILE_INFO_ID;
+	unsigned long info_sz;
+
+	status = fh->open(fh, &h, filename_16, EFI_FILE_MODE_READ, (u64)0);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to open file: ");
+		efi_char16_printk(sys_table_arg, filename_16);
+		efi_printk(sys_table_arg, "\n");
+		return status;
+	}
+
+	*handle = h;
+
+	info_sz = 0;
+	status = h->get_info(h, &info_guid, &info_sz, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		efi_printk(sys_table_arg, "Failed to get file info size\n");
+		return status;
+	}
+
+grow:
+	status = sys_table_arg->boottime->allocate_pool(EFI_LOADER_DATA,
+				 info_sz, (void **)&info);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
+		return status;
+	}
+
+	status = h->get_info(h, &info_guid, &info_sz,
+						   info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		sys_table_arg->boottime->free_pool(info);
+		goto grow;
+	}
+
+	*file_sz = info->file_size;
+	sys_table_arg->boottime->free_pool(info);
+
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table_arg, "Failed to get initrd info\n");
+
+	return status;
+}
+
+
+
+static void efi_char16_printk(efi_system_table_t *sys_table_arg,
+			      efi_char16_t *str)
+{
+	struct efi_simple_text_output_protocol *out;
+
+	out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
+	out->output_string(out, str);
+}
+
+
+/*
+ * This function handles the architcture specific differences between arm and
+ * arm64 regarding where the kernel image must be loaded and any memory that
+ * must be reserved. On failure it is required to free all
+ * all allocations it has made.
+ */
+static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+					unsigned long *image_addr,
+					unsigned long *image_size,
+					unsigned long *reserve_addr,
+					unsigned long *reserve_size,
+					unsigned long dram_base,
+					efi_loaded_image_t *image);
+/*
+ * EFI entry point for the arm/arm64 EFI stubs.  This is the entrypoint
+ * that is described in the PE/COFF header.  Most of the code is the same
+ * for both archictectures, with the arch-specific code provided in the
+ * handle_kernel_image() function.
+ */
+unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
+			       unsigned long *image_addr)
+{
+	efi_loaded_image_t *image;
+	efi_status_t status;
+	unsigned long image_size = 0;
+	unsigned long dram_base;
+	/* addr/point and size pairs for memory management*/
+	unsigned long initrd_addr;
+	u64 initrd_size = 0;
+	unsigned long fdt_addr = 0;  /* Original DTB */
+	u64 fdt_size = 0;  /* We don't get size from configuration table */
+	char *cmdline_ptr = NULL;
+	int cmdline_size = 0;
+	unsigned long new_fdt_addr;
+	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
+	unsigned long reserve_addr = 0;
+	unsigned long reserve_size = 0;
+
+	/* Check if we were booted by the EFI firmware */
+	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		goto fail;
+
+	pr_efi(sys_table, "Booting Linux Kernel...\n");
+
+	/*
+	 * Get a handle to the loaded image protocol.  This is used to get
+	 * information about the running image, such as size and the command
+	 * line.
+	 */
+	status = sys_table->boottime->handle_protocol(handle,
+					&loaded_image_proto, (void *)&image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to get loaded image protocol\n");
+		goto fail;
+	}
+
+	dram_base = get_dram_base(sys_table);
+	if (dram_base == EFI_ERROR) {
+		pr_efi_err(sys_table, "Failed to find DRAM base\n");
+		goto fail;
+	}
+	status = handle_kernel_image(sys_table, image_addr, &image_size,
+				     &reserve_addr,
+				     &reserve_size,
+				     dram_base, image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to relocate kernel\n");
+		goto fail;
+	}
+
+	/*
+	 * Get the command line from EFI, using the LOADED_IMAGE
+	 * protocol. We are going to copy the command line into the
+	 * device tree, so this can be allocated anywhere.
+	 */
+	cmdline_ptr = efi_convert_cmdline(sys_table, image, &cmdline_size);
+	if (!cmdline_ptr) {
+		pr_efi_err(sys_table, "getting command line via LOADED_IMAGE_PROTOCOL\n");
+		goto fail_free_image;
+	}
+
+	/*
+	 * Unauthenticated device tree data is a security hazard, so
+	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
+	 */
+	if (efi_secureboot_enabled(sys_table)) {
+		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
+	} else {
+		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
+					      "dtb=",
+					      ~0UL, (unsigned long *)&fdt_addr,
+					      (unsigned long *)&fdt_size);
+
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table, "Failed to load device tree!\n");
+			goto fail_free_cmdline;
+		}
+	}
+	if (!fdt_addr)
+		/* Look for a device tree configuration table entry. */
+		fdt_addr = (uintptr_t)get_fdt(sys_table);
+
+	status = handle_cmdline_files(sys_table, image, cmdline_ptr,
+				      "initrd=", dram_base + SZ_512M,
+				      (unsigned long *)&initrd_addr,
+				      (unsigned long *)&initrd_size);
+	if (status != EFI_SUCCESS)
+		pr_efi_err(sys_table, "Failed initrd from command line!\n");
+
+	new_fdt_addr = fdt_addr;
+	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
+				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
+				initrd_addr, initrd_size, cmdline_ptr,
+				fdt_addr, fdt_size);
+
+	/*
+	 * If all went well, we need to return the FDT address to the
+	 * calling function so it can be passed to kernel as part of
+	 * the kernel boot protocol.
+	 */
+	if (status == EFI_SUCCESS)
+		return new_fdt_addr;
+
+	pr_efi_err(sys_table, "Failed to update FDT and exit boot services\n");
+
+	efi_free(sys_table, initrd_size, initrd_addr);
+	efi_free(sys_table, fdt_size, fdt_addr);
+
+fail_free_cmdline:
+	efi_free(sys_table, cmdline_size, (unsigned long)cmdline_ptr);
+
+fail_free_image:
+	efi_free(sys_table, image_size, *image_addr);
+	efi_free(sys_table, reserve_size, reserve_addr);
+fail:
+	return EFI_ERROR;
+}
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index af20f1712337..cd36deb619fa 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -20,6 +20,8 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/efi.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
 #include <linux/io.h>
 
 struct efi __read_mostly efi = {
@@ -318,3 +320,80 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 
 	return 0;
 }
+
+#ifdef CONFIG_EFI_PARAMS_FROM_FDT
+
+#define UEFI_PARAM(name, prop, field)			   \
+	{						   \
+		{ name },				   \
+		{ prop },				   \
+		offsetof(struct efi_fdt_params, field),    \
+		FIELD_SIZEOF(struct efi_fdt_params, field) \
+	}
+
+static __initdata struct {
+	const char name[32];
+	const char propname[32];
+	int offset;
+	int size;
+} dt_params[] = {
+	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
+	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
+	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
+	UEFI_PARAM("MemMap Desc. Size", "linux,uefi-mmap-desc-size", desc_size),
+	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
+};
+
+struct param_info {
+	int verbose;
+	void *params;
+};
+
+static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
+				       int depth, void *data)
+{
+	struct param_info *info = data;
+	void *prop, *dest;
+	unsigned long len;
+	u64 val;
+	int i;
+
+	if (depth != 1 ||
+	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
+		return 0;
+
+	pr_info("Getting parameters from FDT:\n");
+
+	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
+		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
+		if (!prop) {
+			pr_err("Can't find %s in device tree!\n",
+			       dt_params[i].name);
+			return 0;
+		}
+		dest = info->params + dt_params[i].offset;
+
+		val = of_read_number(prop, len / sizeof(u32));
+
+		if (dt_params[i].size == sizeof(u32))
+			*(u32 *)dest = val;
+		else
+			*(u64 *)dest = val;
+
+		if (info->verbose)
+			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
+				dt_params[i].size * 2, val);
+	}
+	return 1;
+}
+
+int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
+{
+	struct param_info info;
+
+	info.verbose = verbose;
+	info.params = params;
+
+	return of_scan_flat_dt(fdt_find_uefi_params, &info);
+}
+#endif /* CONFIG_EFI_PARAMS_FROM_FDT */
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
new file mode 100644
index 000000000000..5c6a8e8a9580
--- /dev/null
+++ b/drivers/firmware/efi/fdt.c
@@ -0,0 +1,285 @@
+/*
+ * FDT related Helper functions used by the EFI stub on multiple
+ * architectures. This should be #included by the EFI stub
+ * implementation files.
+ *
+ * Copyright 2013 Linaro Limited; author Roy Franz
+ *
+ * This file is part of the Linux kernel, and is made available
+ * under the terms of the GNU General Public License version 2.
+ *
+ */
+
+static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
+			       unsigned long orig_fdt_size,
+			       void *fdt, int new_fdt_size, char *cmdline_ptr,
+			       u64 initrd_addr, u64 initrd_size,
+			       efi_memory_desc_t *memory_map,
+			       unsigned long map_size, unsigned long desc_size,
+			       u32 desc_ver)
+{
+	int node, prev;
+	int status;
+	u32 fdt_val32;
+	u64 fdt_val64;
+
+	/*
+	 * Copy definition of linux_banner here.  Since this code is
+	 * built as part of the decompressor for ARM v7, pulling
+	 * in version.c where linux_banner is defined for the
+	 * kernel brings other kernel dependencies with it.
+	 */
+	const char linux_banner[] =
+	    "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+	    LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+
+	/* Do some checks on provided FDT, if it exists*/
+	if (orig_fdt) {
+		if (fdt_check_header(orig_fdt)) {
+			pr_efi_err(sys_table, "Device Tree header not valid!\n");
+			return EFI_LOAD_ERROR;
+		}
+		/*
+		 * We don't get the size of the FDT if we get if from a
+		 * configuration table.
+		 */
+		if (orig_fdt_size && fdt_totalsize(orig_fdt) > orig_fdt_size) {
+			pr_efi_err(sys_table, "Truncated device tree! foo!\n");
+			return EFI_LOAD_ERROR;
+		}
+	}
+
+	if (orig_fdt)
+		status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
+	else
+		status = fdt_create_empty_tree(fdt, new_fdt_size);
+
+	if (status != 0)
+		goto fdt_set_fail;
+
+	/*
+	 * Delete any memory nodes present. We must delete nodes which
+	 * early_init_dt_scan_memory may try to use.
+	 */
+	prev = 0;
+	for (;;) {
+		const char *type, *name;
+		int len;
+
+		node = fdt_next_node(fdt, prev, NULL);
+		if (node < 0)
+			break;
+
+		type = fdt_getprop(fdt, node, "device_type", &len);
+		if (type && strncmp(type, "memory", len) == 0) {
+			fdt_del_node(fdt, node);
+			continue;
+		}
+
+		prev = node;
+	}
+
+	node = fdt_subnode_offset(fdt, 0, "chosen");
+	if (node < 0) {
+		node = fdt_add_subnode(fdt, 0, "chosen");
+		if (node < 0) {
+			status = node; /* node is error code when negative */
+			goto fdt_set_fail;
+		}
+	}
+
+	if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
+		status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
+				     strlen(cmdline_ptr) + 1);
+		if (status)
+			goto fdt_set_fail;
+	}
+
+	/* Set initrd address/end in device tree, if present */
+	if (initrd_size != 0) {
+		u64 initrd_image_end;
+		u64 initrd_image_start = cpu_to_fdt64(initrd_addr);
+
+		status = fdt_setprop(fdt, node, "linux,initrd-start",
+				     &initrd_image_start, sizeof(u64));
+		if (status)
+			goto fdt_set_fail;
+		initrd_image_end = cpu_to_fdt64(initrd_addr + initrd_size);
+		status = fdt_setprop(fdt, node, "linux,initrd-end",
+				     &initrd_image_end, sizeof(u64));
+		if (status)
+			goto fdt_set_fail;
+	}
+
+	/* Add FDT entries for EFI runtime services in chosen node. */
+	node = fdt_subnode_offset(fdt, 0, "chosen");
+	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)sys_table);
+	status = fdt_setprop(fdt, node, "linux,uefi-system-table",
+			     &fdt_val64, sizeof(fdt_val64));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)memory_map);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
+			     &fdt_val64,  sizeof(fdt_val64));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(map_size);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-size",
+			     &fdt_val32,  sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(desc_size);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-size",
+			     &fdt_val32, sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+	fdt_val32 = cpu_to_fdt32(desc_ver);
+	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-ver",
+			     &fdt_val32, sizeof(fdt_val32));
+	if (status)
+		goto fdt_set_fail;
+
+	/*
+	 * Add kernel version banner so stub/kernel match can be
+	 * verified.
+	 */
+	status = fdt_setprop_string(fdt, node, "linux,uefi-stub-kern-ver",
+			     linux_banner);
+	if (status)
+		goto fdt_set_fail;
+
+	return EFI_SUCCESS;
+
+fdt_set_fail:
+	if (status == -FDT_ERR_NOSPACE)
+		return EFI_BUFFER_TOO_SMALL;
+
+	return EFI_LOAD_ERROR;
+}
+
+#ifndef EFI_FDT_ALIGN
+#define EFI_FDT_ALIGN EFI_PAGE_SIZE
+#endif
+
+/*
+ * Allocate memory for a new FDT, then add EFI, commandline, and
+ * initrd related fields to the FDT.  This routine increases the
+ * FDT allocation size until the allocated memory is large
+ * enough.  EFI allocations are in EFI_PAGE_SIZE granules,
+ * which are fixed at 4K bytes, so in most cases the first
+ * allocation should succeed.
+ * EFI boot services are exited at the end of this function.
+ * There must be no allocations between the get_memory_map()
+ * call and the exit_boot_services() call, so the exiting of
+ * boot services is very tightly tied to the creation of the FDT
+ * with the final memory map in it.
+ */
+
+efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
+					    void *handle,
+					    unsigned long *new_fdt_addr,
+					    unsigned long max_addr,
+					    u64 initrd_addr, u64 initrd_size,
+					    char *cmdline_ptr,
+					    unsigned long fdt_addr,
+					    unsigned long fdt_size)
+{
+	unsigned long map_size, desc_size;
+	u32 desc_ver;
+	unsigned long mmap_key;
+	efi_memory_desc_t *memory_map;
+	unsigned long new_fdt_size;
+	efi_status_t status;
+
+	/*
+	 * Estimate size of new FDT, and allocate memory for it. We
+	 * will allocate a bigger buffer if this ends up being too
+	 * small, so a rough guess is OK here.
+	 */
+	new_fdt_size = fdt_size + EFI_PAGE_SIZE;
+	while (1) {
+		status = efi_high_alloc(sys_table, new_fdt_size, EFI_FDT_ALIGN,
+					new_fdt_addr, max_addr);
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table, "Unable to allocate memory for new device tree.\n");
+			goto fail;
+		}
+
+		/*
+		 * Now that we have done our final memory allocation (and free)
+		 * we can get the memory map key  needed for
+		 * exit_boot_services().
+		 */
+		status = efi_get_memory_map(sys_table, &memory_map, &map_size,
+					    &desc_size, &desc_ver, &mmap_key);
+		if (status != EFI_SUCCESS)
+			goto fail_free_new_fdt;
+
+		status = update_fdt(sys_table,
+				    (void *)fdt_addr, fdt_size,
+				    (void *)*new_fdt_addr, new_fdt_size,
+				    cmdline_ptr, initrd_addr, initrd_size,
+				    memory_map, map_size, desc_size, desc_ver);
+
+		/* Succeeding the first time is the expected case. */
+		if (status == EFI_SUCCESS)
+			break;
+
+		if (status == EFI_BUFFER_TOO_SMALL) {
+			/*
+			 * We need to allocate more space for the new
+			 * device tree, so free existing buffer that is
+			 * too small.  Also free memory map, as we will need
+			 * to get new one that reflects the free/alloc we do
+			 * on the device tree buffer.
+			 */
+			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
+			sys_table->boottime->free_pool(memory_map);
+			new_fdt_size += EFI_PAGE_SIZE;
+		} else {
+			pr_efi_err(sys_table, "Unable to constuct new device tree.\n");
+			goto fail_free_mmap;
+		}
+	}
+
+	/* Now we are ready to exit_boot_services.*/
+	status = sys_table->boottime->exit_boot_services(handle, mmap_key);
+
+
+	if (status == EFI_SUCCESS)
+		return status;
+
+	pr_efi_err(sys_table, "Exit boot services failed.\n");
+
+fail_free_mmap:
+	sys_table->boottime->free_pool(memory_map);
+
+fail_free_new_fdt:
+	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
+
+fail:
+	return EFI_LOAD_ERROR;
+}
+
+static void *get_fdt(efi_system_table_t *sys_table)
+{
+	efi_guid_t fdt_guid = DEVICE_TREE_GUID;
+	efi_config_table_t *tables;
+	void *fdt;
+	int i;
+
+	tables = (efi_config_table_t *) sys_table->tables;
+	fdt = NULL;
+
+	for (i = 0; i < sys_table->nr_tables; i++)
+		if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
+			fdt = (void *) tables[i].table;
+			break;
+	 }
+
+	return fdt;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6a4d8e27d1d7..41bbf8ba4ba8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -575,6 +575,9 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long si
 #define EFI_FILE_SYSTEM_GUID \
     EFI_GUID(  0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
 
+#define DEVICE_TREE_GUID \
+    EFI_GUID(  0xb1b621d5, 0xf19c, 0x41a5, 0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -664,6 +667,14 @@ struct efi_memory_map {
 	unsigned long desc_size;
 };
 
+struct efi_fdt_params {
+	u64 system_table;
+	u64 mmap;
+	u32 mmap_size;
+	u32 desc_size;
+	u32 desc_ver;
+};
+
 typedef struct {
 	u32 revision;
 	u32 parent_handle;
@@ -861,6 +872,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
 extern void efi_get_time(struct timespec *now);
 extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
+extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
 
 /* Iterate through an efi_memory_map */
diff --git a/lib/Makefile b/lib/Makefile
index 0cd7b68e1382..74a32dc49a93 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -148,7 +148,8 @@ obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
 
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 
-libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o
+libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
+	       fdt_empty_tree.o
 $(foreach file, $(libfdt_files), \
 	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
diff --git a/lib/fdt_empty_tree.c b/lib/fdt_empty_tree.c
new file mode 100644
index 000000000000..5d30c58150ad
--- /dev/null
+++ b/lib/fdt_empty_tree.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt_empty_tree.c"
