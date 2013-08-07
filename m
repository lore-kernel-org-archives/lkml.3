Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab3HGUlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:41:35 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60716 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332Ab3HGUlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:41:11 -0400
Message-ID: <201308072041.r77KfAhL016134@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 16:03:08 -0400
Subject: [PATCH] arch/tile: provide traceability for hypervisor calls
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds infrastructure (CONFIG_TILE_HVGLUE_TRACE) that
provides C code wrappers for the calls the kernel makes to the Tilera
hypervisor.  This allows standard kernel infrastructure like FTRACE to
be able to instrument hypervisor calls.

To allow direct calls to the true API, we export their names with a
leading underscore as well.  This is important for the few contexts
where we need to make hypervisor calls without touching the stack.

As part of this change, we also switch from creating the symbols
with linker magic to creating them with assembler magic.  This lets
us provide a symbol type and generally make them appear more as symbols
and less as just random values in the Elf namespace.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig.debug         |   8 ++
 arch/tile/kernel/Makefile       |   3 +-
 arch/tile/kernel/head_32.S      |   8 +-
 arch/tile/kernel/head_64.S      |   8 +-
 arch/tile/kernel/hvglue.S       |  74 +++++++++++
 arch/tile/kernel/hvglue.lds     |  60 ---------
 arch/tile/kernel/hvglue_trace.c | 266 ++++++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/intvec_32.S    |   2 +-
 arch/tile/kernel/intvec_64.S    |   2 +-
 arch/tile/kernel/vmlinux.lds.S  |   5 +-
 arch/tile/mm/migrate_32.S       |   4 +-
 arch/tile/mm/migrate_64.S       |   4 +-
 12 files changed, 368 insertions(+), 76 deletions(-)
 create mode 100644 arch/tile/kernel/hvglue.S
 delete mode 100644 arch/tile/kernel/hvglue.lds
 create mode 100644 arch/tile/kernel/hvglue_trace.c

diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index 9165ea9..b8d69f2 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -24,4 +24,12 @@ config DEBUG_EXTRA_FLAGS
 	  size and build time noticeably.  Such flags are often
 	  helpful if the main use of debug info is line number info.
 
+config TILE_HVGLUE_TRACE
+	bool "Provide wrapper functions for hypervisor ABI calls"
+	default n
+	help
+	  Provide wrapper functions for the hypervisor ABI calls
+	  defined in arch/tile/kernel/hvglue.S.  This allows tracing
+	  mechanisms, etc., to have visibility into those calls.
+
 endmenu
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index 5157d1c..c4a957a 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 extra-y := vmlinux.lds head_$(BITS).o
-obj-y := backtrace.o entry.o irq.o messaging.o \
+obj-y := backtrace.o entry.o hvglue.o irq.o messaging.o \
 	pci-dma.o proc.o process.o ptrace.o reboot.o \
 	setup.o signal.o single_step.o stack.o sys.o \
 	sysfs.o time.o traps.o unaligned.o vdso.o \
@@ -21,5 +21,6 @@ else
 obj-$(CONFIG_PCI)		+= pci.o
 endif
 obj-$(CONFIG_TILE_USB)		+= usb.o
+obj-$(CONFIG_TILE_HVGLUE_TRACE)	+= hvglue_trace.o
 
 obj-y				+= vdso/
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index 80cd407..d1527fc 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -39,12 +39,12 @@ ENTRY(_start)
 	}
 	{
 	  moveli r0, _HV_VERSION_OLD_HV_INIT
-	  jal hv_init
+	  jal _hv_init
 	}
 	/* Get a reasonable default ASID in r0 */
 	{
 	  move r0, zero
-	  jal hv_inquire_asid
+	  jal _hv_inquire_asid
 	}
 	/* Install the default page table */
 	{
@@ -73,12 +73,12 @@ ENTRY(_start)
 	}
 	{
 	  auli lr, lr, ha16(1f)
-	  j hv_install_context
+	  j _hv_install_context
 	}
 1:
 
 	/* Get our processor number and save it away in SAVE_K_0. */
-	jal hv_inquire_topology
+	jal _hv_inquire_topology
 	mulll_uu r4, r1, r2        /* r1 == y, r2 == width */
 	add r4, r4, r0             /* r0 == x, so r4 == cpu == y*width + x */
 
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index ed51320..969e4f8 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -55,11 +55,11 @@ ENTRY(_start)
 	  movei r2, TILE_CHIP_REV
 	  movei r3, KERNEL_PL
 	}
-	jal hv_init
+	jal _hv_init
 	/* Get a reasonable default ASID in r0 */
 	{
 	  move r0, zero
-	  jal hv_inquire_asid
+	  jal _hv_inquire_asid
 	}
 
 	/*
@@ -130,7 +130,7 @@ ENTRY(_start)
 	}
 	{
 	  moveli r3, CTX_PAGE_FLAG
-	  j hv_install_context
+	  j _hv_install_context
 	}
 1:
 
@@ -141,7 +141,7 @@ ENTRY(_start)
 	mtspr SPR_INTERRUPT_VECTOR_BASE_K, r0
 
 	/* Get our processor number and save it away in SAVE_K_0. */
-	jal hv_inquire_topology
+	jal _hv_inquire_topology
 	{
 	  GET_FIRST_INT(r5, r1)   /* r5 = width */
 	  GET_SECOND_INT(r4, r0)  /* r4 = y */
diff --git a/arch/tile/kernel/hvglue.S b/arch/tile/kernel/hvglue.S
new file mode 100644
index 0000000..2ab4566
--- /dev/null
+++ b/arch/tile/kernel/hvglue.S
@@ -0,0 +1,74 @@
+/* Hypervisor call vector addresses; see <hv/hypervisor.h> */
+.macro gensym sym, val, size
+.org \val
+.global _\sym
+.type _\sym,function
+_\sym:
+.size _\sym,\size
+#ifndef CONFIG_TILE_HVGLUE_TRACE
+.globl \sym
+.set \sym,_\sym
+#endif
+.endm
+
+.section .hvglue,"x",@nobits
+.align 8
+gensym hv_init, 0x20, 32
+gensym hv_install_context, 0x40, 32
+gensym hv_sysconf, 0x60, 32
+gensym hv_get_rtc, 0x80, 32
+gensym hv_set_rtc, 0xa0, 32
+gensym hv_flush_asid, 0xc0, 32
+gensym hv_flush_page, 0xe0, 32
+gensym hv_flush_pages, 0x100, 32
+gensym hv_restart, 0x120, 32
+gensym hv_halt, 0x140, 32
+gensym hv_power_off, 0x160, 32
+gensym hv_inquire_physical, 0x180, 32
+gensym hv_inquire_memory_controller, 0x1a0, 32
+gensym hv_inquire_virtual, 0x1c0, 32
+gensym hv_inquire_asid, 0x1e0, 32
+gensym hv_nanosleep, 0x200, 32
+gensym hv_console_read_if_ready, 0x220, 32
+gensym hv_console_write, 0x240, 32
+gensym hv_downcall_dispatch, 0x260, 32
+gensym hv_inquire_topology, 0x280, 32
+gensym hv_fs_findfile, 0x2a0, 32
+gensym hv_fs_fstat, 0x2c0, 32
+gensym hv_fs_pread, 0x2e0, 32
+gensym hv_physaddr_read64, 0x300, 32
+gensym hv_physaddr_write64, 0x320, 32
+gensym hv_get_command_line, 0x340, 32
+gensym hv_set_caching, 0x360, 32
+gensym hv_bzero_page, 0x380, 32
+gensym hv_register_message_state, 0x3a0, 32
+gensym hv_send_message, 0x3c0, 32
+gensym hv_receive_message, 0x3e0, 32
+gensym hv_inquire_context, 0x400, 32
+gensym hv_start_all_tiles, 0x420, 32
+gensym hv_dev_open, 0x440, 32
+gensym hv_dev_close, 0x460, 32
+gensym hv_dev_pread, 0x480, 32
+gensym hv_dev_pwrite, 0x4a0, 32
+gensym hv_dev_poll, 0x4c0, 32
+gensym hv_dev_poll_cancel, 0x4e0, 32
+gensym hv_dev_preada, 0x500, 32
+gensym hv_dev_pwritea, 0x520, 32
+gensym hv_flush_remote, 0x540, 32
+gensym hv_console_putc, 0x560, 32
+gensym hv_inquire_tiles, 0x580, 32
+gensym hv_confstr, 0x5a0, 32
+gensym hv_reexec, 0x5c0, 32
+gensym hv_set_command_line, 0x5e0, 32
+gensym hv_clear_intr, 0x600, 32
+gensym hv_enable_intr, 0x620, 32
+gensym hv_disable_intr, 0x640, 32
+gensym hv_raise_intr, 0x660, 32
+gensym hv_trigger_ipi, 0x680, 32
+gensym hv_store_mapping, 0x6a0, 32
+gensym hv_inquire_realpa, 0x6c0, 32
+gensym hv_flush_all, 0x6e0, 32
+gensym hv_get_ipi_pte, 0x700, 32
+gensym hv_set_pte_super_shift, 0x720, 32
+gensym hv_console_set_ipi, 0x7e0, 32
+gensym hv_glue_internals, 0x800, 30720
diff --git a/arch/tile/kernel/hvglue.lds b/arch/tile/kernel/hvglue.lds
deleted file mode 100644
index ef52290..0000000
--- a/arch/tile/kernel/hvglue.lds
+++ /dev/null
@@ -1,60 +0,0 @@
-/* Hypervisor call vector addresses; see <hv/hypervisor.h> */
-hv_init = TEXT_OFFSET + 0x10020;
-hv_install_context = TEXT_OFFSET + 0x10040;
-hv_sysconf = TEXT_OFFSET + 0x10060;
-hv_get_rtc = TEXT_OFFSET + 0x10080;
-hv_set_rtc = TEXT_OFFSET + 0x100a0;
-hv_flush_asid = TEXT_OFFSET + 0x100c0;
-hv_flush_page = TEXT_OFFSET + 0x100e0;
-hv_flush_pages = TEXT_OFFSET + 0x10100;
-hv_restart = TEXT_OFFSET + 0x10120;
-hv_halt = TEXT_OFFSET + 0x10140;
-hv_power_off = TEXT_OFFSET + 0x10160;
-hv_inquire_physical = TEXT_OFFSET + 0x10180;
-hv_inquire_memory_controller = TEXT_OFFSET + 0x101a0;
-hv_inquire_virtual = TEXT_OFFSET + 0x101c0;
-hv_inquire_asid = TEXT_OFFSET + 0x101e0;
-hv_nanosleep = TEXT_OFFSET + 0x10200;
-hv_console_read_if_ready = TEXT_OFFSET + 0x10220;
-hv_console_write = TEXT_OFFSET + 0x10240;
-hv_downcall_dispatch = TEXT_OFFSET + 0x10260;
-hv_inquire_topology = TEXT_OFFSET + 0x10280;
-hv_fs_findfile = TEXT_OFFSET + 0x102a0;
-hv_fs_fstat = TEXT_OFFSET + 0x102c0;
-hv_fs_pread = TEXT_OFFSET + 0x102e0;
-hv_physaddr_read64 = TEXT_OFFSET + 0x10300;
-hv_physaddr_write64 = TEXT_OFFSET + 0x10320;
-hv_get_command_line = TEXT_OFFSET + 0x10340;
-hv_set_caching = TEXT_OFFSET + 0x10360;
-hv_bzero_page = TEXT_OFFSET + 0x10380;
-hv_register_message_state = TEXT_OFFSET + 0x103a0;
-hv_send_message = TEXT_OFFSET + 0x103c0;
-hv_receive_message = TEXT_OFFSET + 0x103e0;
-hv_inquire_context = TEXT_OFFSET + 0x10400;
-hv_start_all_tiles = TEXT_OFFSET + 0x10420;
-hv_dev_open = TEXT_OFFSET + 0x10440;
-hv_dev_close = TEXT_OFFSET + 0x10460;
-hv_dev_pread = TEXT_OFFSET + 0x10480;
-hv_dev_pwrite = TEXT_OFFSET + 0x104a0;
-hv_dev_poll = TEXT_OFFSET + 0x104c0;
-hv_dev_poll_cancel = TEXT_OFFSET + 0x104e0;
-hv_dev_preada = TEXT_OFFSET + 0x10500;
-hv_dev_pwritea = TEXT_OFFSET + 0x10520;
-hv_flush_remote = TEXT_OFFSET + 0x10540;
-hv_console_putc = TEXT_OFFSET + 0x10560;
-hv_inquire_tiles = TEXT_OFFSET + 0x10580;
-hv_confstr = TEXT_OFFSET + 0x105a0;
-hv_reexec = TEXT_OFFSET + 0x105c0;
-hv_set_command_line = TEXT_OFFSET + 0x105e0;
-hv_clear_intr = TEXT_OFFSET + 0x10600;
-hv_enable_intr = TEXT_OFFSET + 0x10620;
-hv_disable_intr = TEXT_OFFSET + 0x10640;
-hv_raise_intr = TEXT_OFFSET + 0x10660;
-hv_trigger_ipi = TEXT_OFFSET + 0x10680;
-hv_store_mapping = TEXT_OFFSET + 0x106a0;
-hv_inquire_realpa = TEXT_OFFSET + 0x106c0;
-hv_flush_all = TEXT_OFFSET + 0x106e0;
-hv_get_ipi_pte = TEXT_OFFSET + 0x10700;
-hv_set_pte_super_shift = TEXT_OFFSET + 0x10720;
-hv_console_set_ipi = TEXT_OFFSET + 0x107e0;
-hv_glue_internals = TEXT_OFFSET + 0x10800;
diff --git a/arch/tile/kernel/hvglue_trace.c b/arch/tile/kernel/hvglue_trace.c
new file mode 100644
index 0000000..85c74ad
--- /dev/null
+++ b/arch/tile/kernel/hvglue_trace.c
@@ -0,0 +1,266 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ * Pull in the hypervisor header so we declare all the ABI functions
+ * with the underscore versions, then undef the names so that we can
+ * provide our own wrapper versions.
+ */
+#define hv_init _hv_init
+#define hv_install_context _hv_install_context
+#define hv_sysconf _hv_sysconf
+#define hv_get_rtc _hv_get_rtc
+#define hv_set_rtc _hv_set_rtc
+#define hv_flush_asid _hv_flush_asid
+#define hv_flush_page _hv_flush_page
+#define hv_flush_pages _hv_flush_pages
+#define hv_restart _hv_restart
+#define hv_halt _hv_halt
+#define hv_power_off _hv_power_off
+#define hv_inquire_physical _hv_inquire_physical
+#define hv_inquire_memory_controller _hv_inquire_memory_controller
+#define hv_inquire_virtual _hv_inquire_virtual
+#define hv_inquire_asid _hv_inquire_asid
+#define hv_nanosleep _hv_nanosleep
+#define hv_console_read_if_ready _hv_console_read_if_ready
+#define hv_console_write _hv_console_write
+#define hv_downcall_dispatch _hv_downcall_dispatch
+#define hv_inquire_topology _hv_inquire_topology
+#define hv_fs_findfile _hv_fs_findfile
+#define hv_fs_fstat _hv_fs_fstat
+#define hv_fs_pread _hv_fs_pread
+#define hv_physaddr_read64 _hv_physaddr_read64
+#define hv_physaddr_write64 _hv_physaddr_write64
+#define hv_get_command_line _hv_get_command_line
+#define hv_set_caching _hv_set_caching
+#define hv_bzero_page _hv_bzero_page
+#define hv_register_message_state _hv_register_message_state
+#define hv_send_message _hv_send_message
+#define hv_receive_message _hv_receive_message
+#define hv_inquire_context _hv_inquire_context
+#define hv_start_all_tiles _hv_start_all_tiles
+#define hv_dev_open _hv_dev_open
+#define hv_dev_close _hv_dev_close
+#define hv_dev_pread _hv_dev_pread
+#define hv_dev_pwrite _hv_dev_pwrite
+#define hv_dev_poll _hv_dev_poll
+#define hv_dev_poll_cancel _hv_dev_poll_cancel
+#define hv_dev_preada _hv_dev_preada
+#define hv_dev_pwritea _hv_dev_pwritea
+#define hv_flush_remote _hv_flush_remote
+#define hv_console_putc _hv_console_putc
+#define hv_inquire_tiles _hv_inquire_tiles
+#define hv_confstr _hv_confstr
+#define hv_reexec _hv_reexec
+#define hv_set_command_line _hv_set_command_line
+#define hv_clear_intr _hv_clear_intr
+#define hv_enable_intr _hv_enable_intr
+#define hv_disable_intr _hv_disable_intr
+#define hv_raise_intr _hv_raise_intr
+#define hv_trigger_ipi _hv_trigger_ipi
+#define hv_store_mapping _hv_store_mapping
+#define hv_inquire_realpa _hv_inquire_realpa
+#define hv_flush_all _hv_flush_all
+#define hv_get_ipi_pte _hv_get_ipi_pte
+#define hv_set_pte_super_shift _hv_set_pte_super_shift
+#define hv_console_set_ipi _hv_console_set_ipi
+#include <hv/hypervisor.h>
+#undef hv_init
+#undef hv_install_context
+#undef hv_sysconf
+#undef hv_get_rtc
+#undef hv_set_rtc
+#undef hv_flush_asid
+#undef hv_flush_page
+#undef hv_flush_pages
+#undef hv_restart
+#undef hv_halt
+#undef hv_power_off
+#undef hv_inquire_physical
+#undef hv_inquire_memory_controller
+#undef hv_inquire_virtual
+#undef hv_inquire_asid
+#undef hv_nanosleep
+#undef hv_console_read_if_ready
+#undef hv_console_write
+#undef hv_downcall_dispatch
+#undef hv_inquire_topology
+#undef hv_fs_findfile
+#undef hv_fs_fstat
+#undef hv_fs_pread
+#undef hv_physaddr_read64
+#undef hv_physaddr_write64
+#undef hv_get_command_line
+#undef hv_set_caching
+#undef hv_bzero_page
+#undef hv_register_message_state
+#undef hv_send_message
+#undef hv_receive_message
+#undef hv_inquire_context
+#undef hv_start_all_tiles
+#undef hv_dev_open
+#undef hv_dev_close
+#undef hv_dev_pread
+#undef hv_dev_pwrite
+#undef hv_dev_poll
+#undef hv_dev_poll_cancel
+#undef hv_dev_preada
+#undef hv_dev_pwritea
+#undef hv_flush_remote
+#undef hv_console_putc
+#undef hv_inquire_tiles
+#undef hv_confstr
+#undef hv_reexec
+#undef hv_set_command_line
+#undef hv_clear_intr
+#undef hv_enable_intr
+#undef hv_disable_intr
+#undef hv_raise_intr
+#undef hv_trigger_ipi
+#undef hv_store_mapping
+#undef hv_inquire_realpa
+#undef hv_flush_all
+#undef hv_get_ipi_pte
+#undef hv_set_pte_super_shift
+#undef hv_console_set_ipi
+
+/*
+ * Provide macros based on <linux/syscalls.h> to provide a wrapper
+ * function that invokes the same function with an underscore prefix.
+ * We can't use the existing __SC_xxx macros because we need to
+ * support up to nine arguments rather than up to six, and also this
+ * way the file stands alone from possible changes in the
+ * implementation of <linux/syscalls.h>.
+ */
+#define HV_WRAP0(type, name)					\
+	type name(void);					\
+	type name(void)						\
+	{							\
+		return _##name();				\
+	}
+#define __HV_DECL1(t1, a1)	t1 a1
+#define __HV_DECL2(t2, a2, ...) t2 a2, __HV_DECL1(__VA_ARGS__)
+#define __HV_DECL3(t3, a3, ...) t3 a3, __HV_DECL2(__VA_ARGS__)
+#define __HV_DECL4(t4, a4, ...) t4 a4, __HV_DECL3(__VA_ARGS__)
+#define __HV_DECL5(t5, a5, ...) t5 a5, __HV_DECL4(__VA_ARGS__)
+#define __HV_DECL6(t6, a6, ...) t6 a6, __HV_DECL5(__VA_ARGS__)
+#define __HV_DECL7(t7, a7, ...) t7 a7, __HV_DECL6(__VA_ARGS__)
+#define __HV_DECL8(t8, a8, ...) t8 a8, __HV_DECL7(__VA_ARGS__)
+#define __HV_DECL9(t9, a9, ...) t9 a9, __HV_DECL8(__VA_ARGS__)
+#define __HV_PASS1(t1, a1)	a1
+#define __HV_PASS2(t2, a2, ...) a2, __HV_PASS1(__VA_ARGS__)
+#define __HV_PASS3(t3, a3, ...) a3, __HV_PASS2(__VA_ARGS__)
+#define __HV_PASS4(t4, a4, ...) a4, __HV_PASS3(__VA_ARGS__)
+#define __HV_PASS5(t5, a5, ...) a5, __HV_PASS4(__VA_ARGS__)
+#define __HV_PASS6(t6, a6, ...) a6, __HV_PASS5(__VA_ARGS__)
+#define __HV_PASS7(t7, a7, ...) a7, __HV_PASS6(__VA_ARGS__)
+#define __HV_PASS8(t8, a8, ...) a8, __HV_PASS7(__VA_ARGS__)
+#define __HV_PASS9(t9, a9, ...) a9, __HV_PASS8(__VA_ARGS__)
+#define HV_WRAPx(x, type, name, ...)				\
+	type name(__HV_DECL##x(__VA_ARGS__));			\
+	type name(__HV_DECL##x(__VA_ARGS__))			\
+	{							\
+		return _##name(__HV_PASS##x(__VA_ARGS__));	\
+	}
+#define HV_WRAP1(type, name, ...) HV_WRAPx(1, type, name, __VA_ARGS__)
+#define HV_WRAP2(type, name, ...) HV_WRAPx(2, type, name, __VA_ARGS__)
+#define HV_WRAP3(type, name, ...) HV_WRAPx(3, type, name, __VA_ARGS__)
+#define HV_WRAP4(type, name, ...) HV_WRAPx(4, type, name, __VA_ARGS__)
+#define HV_WRAP5(type, name, ...) HV_WRAPx(5, type, name, __VA_ARGS__)
+#define HV_WRAP6(type, name, ...) HV_WRAPx(6, type, name, __VA_ARGS__)
+#define HV_WRAP7(type, name, ...) HV_WRAPx(7, type, name, __VA_ARGS__)
+#define HV_WRAP8(type, name, ...) HV_WRAPx(8, type, name, __VA_ARGS__)
+#define HV_WRAP9(type, name, ...) HV_WRAPx(9, type, name, __VA_ARGS__)
+
+/* List all the hypervisor API functions. */
+HV_WRAP4(void, hv_init, HV_VersionNumber, interface_version_number,
+	 int, chip_num, int, chip_rev_num, int, client_pl)
+HV_WRAP1(long, hv_sysconf, HV_SysconfQuery, query)
+HV_WRAP3(int, hv_confstr, HV_ConfstrQuery, query, HV_VirtAddr, buf, int, len)
+#if CHIP_HAS_IPI()
+HV_WRAP3(int, hv_get_ipi_pte, HV_Coord, tile, int, pl, HV_PTE*, pte)
+HV_WRAP3(int, hv_console_set_ipi, int, ipi, int, event, HV_Coord, coord);
+#else
+HV_WRAP1(void, hv_enable_intr, HV_IntrMask, enab_mask)
+HV_WRAP1(void, hv_disable_intr, HV_IntrMask, disab_mask)
+HV_WRAP1(void, hv_clear_intr, HV_IntrMask, clear_mask)
+HV_WRAP1(void, hv_raise_intr, HV_IntrMask, raise_mask)
+HV_WRAP2(HV_Errno, hv_trigger_ipi, HV_Coord, tile, int, interrupt)
+#endif /* !CHIP_HAS_IPI() */
+HV_WRAP3(int, hv_store_mapping, HV_VirtAddr, va, unsigned int, len,
+	 HV_PhysAddr, pa)
+HV_WRAP2(HV_PhysAddr, hv_inquire_realpa, HV_PhysAddr, cpa, unsigned int, len)
+HV_WRAP0(HV_RTCTime, hv_get_rtc)
+HV_WRAP1(void, hv_set_rtc, HV_RTCTime, time)
+HV_WRAP4(int, hv_install_context, HV_PhysAddr, page_table, HV_PTE, access,
+	 HV_ASID, asid, __hv32, flags)
+HV_WRAP2(int, hv_set_pte_super_shift, int, level, int, log2_count)
+HV_WRAP0(HV_Context, hv_inquire_context)
+HV_WRAP1(int, hv_flush_asid, HV_ASID, asid)
+HV_WRAP2(int, hv_flush_page, HV_VirtAddr, address, HV_PageSize, page_size)
+HV_WRAP3(int, hv_flush_pages, HV_VirtAddr, start, HV_PageSize, page_size,
+	 unsigned long, size)
+HV_WRAP1(int, hv_flush_all, int, preserve_global)
+HV_WRAP2(void, hv_restart, HV_VirtAddr, cmd, HV_VirtAddr, args)
+HV_WRAP0(void, hv_halt)
+HV_WRAP0(void, hv_power_off)
+HV_WRAP1(int, hv_reexec, HV_PhysAddr, entry)
+HV_WRAP0(HV_Topology, hv_inquire_topology)
+HV_WRAP3(HV_Errno, hv_inquire_tiles, HV_InqTileSet, set, HV_VirtAddr, cpumask,
+	 int, length)
+HV_WRAP1(HV_PhysAddrRange, hv_inquire_physical, int, idx)
+HV_WRAP2(HV_MemoryControllerInfo, hv_inquire_memory_controller, HV_Coord, coord,
+	 int, controller)
+HV_WRAP1(HV_VirtAddrRange, hv_inquire_virtual, int, idx)
+HV_WRAP1(HV_ASIDRange, hv_inquire_asid, int, idx)
+HV_WRAP1(void, hv_nanosleep, int, nanosecs)
+HV_WRAP0(int, hv_console_read_if_ready)
+HV_WRAP1(void, hv_console_putc, int, byte)
+HV_WRAP2(int, hv_console_write, HV_VirtAddr, bytes, int, len)
+HV_WRAP0(void, hv_downcall_dispatch)
+HV_WRAP1(int, hv_fs_findfile, HV_VirtAddr, filename)
+HV_WRAP1(HV_FS_StatInfo, hv_fs_fstat, int, inode)
+HV_WRAP4(int, hv_fs_pread, int, inode, HV_VirtAddr, buf,
+	 int, length, int, offset)
+HV_WRAP2(unsigned long long, hv_physaddr_read64, HV_PhysAddr, addr,
+	 HV_PTE, access)
+HV_WRAP3(void, hv_physaddr_write64, HV_PhysAddr, addr, HV_PTE, access,
+	 unsigned long long, val)
+HV_WRAP2(int, hv_get_command_line, HV_VirtAddr, buf, int, length)
+HV_WRAP2(HV_Errno, hv_set_command_line, HV_VirtAddr, buf, int, length)
+HV_WRAP1(void, hv_set_caching, unsigned long, bitmask)
+HV_WRAP2(void, hv_bzero_page, HV_VirtAddr, va, unsigned int, size)
+HV_WRAP1(HV_Errno, hv_register_message_state, HV_MsgState*, msgstate)
+HV_WRAP4(int, hv_send_message, HV_Recipient *, recips, int, nrecip,
+	 HV_VirtAddr, buf, int, buflen)
+HV_WRAP3(HV_RcvMsgInfo, hv_receive_message, HV_MsgState, msgstate,
+	 HV_VirtAddr, buf, int, buflen)
+HV_WRAP0(void, hv_start_all_tiles)
+HV_WRAP2(int, hv_dev_open, HV_VirtAddr, name, __hv32, flags)
+HV_WRAP1(int, hv_dev_close, int, devhdl)
+HV_WRAP5(int, hv_dev_pread, int, devhdl, __hv32, flags, HV_VirtAddr, va,
+	 __hv32, len, __hv64, offset)
+HV_WRAP5(int, hv_dev_pwrite, int, devhdl, __hv32, flags, HV_VirtAddr, va,
+	 __hv32, len, __hv64, offset)
+HV_WRAP3(int, hv_dev_poll, int, devhdl, __hv32, events, HV_IntArg, intarg)
+HV_WRAP1(int, hv_dev_poll_cancel, int, devhdl)
+HV_WRAP6(int, hv_dev_preada, int, devhdl, __hv32, flags, __hv32, sgl_len,
+	 HV_SGL *, sglp, __hv64, offset, HV_IntArg, intarg)
+HV_WRAP6(int, hv_dev_pwritea, int, devhdl, __hv32, flags, __hv32, sgl_len,
+	 HV_SGL *, sglp, __hv64, offset, HV_IntArg, intarg)
+HV_WRAP9(int, hv_flush_remote, HV_PhysAddr, cache_pa,
+	 unsigned long, cache_control, unsigned long*, cache_cpumask,
+	 HV_VirtAddr, tlb_va, unsigned long, tlb_length,
+	 unsigned long, tlb_pgsize, unsigned long*, tlb_cpumask,
+	 HV_Remote_ASID*, asids, int, asidcount)
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 1076765..9c0c3cb 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -758,7 +758,7 @@ intvec_\vecname:
 	.macro  dc_dispatch vecnum, vecname
 	.org    (\vecnum << 8)
 intvec_\vecname:
-	j       hv_downcall_dispatch
+	j       _hv_downcall_dispatch
 	ENDPROC(intvec_\vecname)
 	.endm
 
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 3c63fbd..99f8e9a 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -765,7 +765,7 @@ intvec_\vecname:
 	.macro  dc_dispatch vecnum, vecname
 	.org    (\vecnum << 8)
 intvec_\vecname:
-	j       hv_downcall_dispatch
+	j       _hv_downcall_dispatch
 	ENDPROC(intvec_\vecname)
 	.endm
 
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index a13ed90..0f0edaf 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -31,7 +31,10 @@ SECTIONS
   } :intrpt1 =0
 
   /* Hypervisor call vectors */
-  #include "hvglue.lds"
+  . = ALIGN(0x10000);
+  .hvglue : AT (ADDR(.hvglue) - LOAD_OFFSET) {
+    *(.hvglue)
+  } :NONE
 
   /* Now the real code */
   . = ALIGN(0x20000);
diff --git a/arch/tile/mm/migrate_32.S b/arch/tile/mm/migrate_32.S
index 5305814..7720854 100644
--- a/arch/tile/mm/migrate_32.S
+++ b/arch/tile/mm/migrate_32.S
@@ -136,7 +136,7 @@ STD_ENTRY(flush_and_install_context)
 	 move r8, zero  /* asids */
 	 move r9, zero  /* asidcount */
 	}
-	jal hv_flush_remote
+	jal _hv_flush_remote
 	bnz r0, .Ldone
 
 	/* Now install the new page table. */
@@ -152,7 +152,7 @@ STD_ENTRY(flush_and_install_context)
 	 move r4, r_asid
 	 moveli r5, HV_CTX_DIRECTIO | CTX_PAGE_FLAG
 	}
-	jal hv_install_context
+	jal _hv_install_context
 	bnz r0, .Ldone
 
 	/* Finally, flush the TLB. */
diff --git a/arch/tile/mm/migrate_64.S b/arch/tile/mm/migrate_64.S
index 1d15b108..a49eee3 100644
--- a/arch/tile/mm/migrate_64.S
+++ b/arch/tile/mm/migrate_64.S
@@ -123,7 +123,7 @@ STD_ENTRY(flush_and_install_context)
 	}
 	{
 	 move r8, zero  /* asidcount */
-	 jal hv_flush_remote
+	 jal _hv_flush_remote
 	}
 	bnez r0, 1f
 
@@ -136,7 +136,7 @@ STD_ENTRY(flush_and_install_context)
 	 move r2, r_asid
 	 moveli r3, HV_CTX_DIRECTIO | CTX_PAGE_FLAG
 	}
-	jal hv_install_context
+	jal _hv_install_context
 	bnez r0, 1f
 
 	/* Finally, flush the TLB. */
-- 
1.8.3.1

