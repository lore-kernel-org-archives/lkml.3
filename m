Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3HOUhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:37:37 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:46346 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3HOUhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:37:33 -0400
Message-ID: <201308152037.r7FKbWw3004200@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 15 Aug 2013 16:23:24 -0400
Subject: [PATCH] tile: remove support for TILE64
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chip is no longer being actively developed for (it was superceded
by the TILEPro64 in 2008), and in any case the existing compiler and
toolchain in the community do not support it.  It's unlikely that the
kernel works with TILE64 at this point as the configuration has not been
tested in years.  The support is also awkward as it requires maintaining
a significant number of ifdefs.  So, just remove it altogether.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                         |   2 +-
 arch/tile/include/asm/atomic_32.h         |  17 --
 arch/tile/include/asm/barrier.h           |   4 -
 arch/tile/include/asm/elf.h               |   1 -
 arch/tile/include/asm/homecache.h         |   3 +-
 arch/tile/include/asm/processor.h         |  16 --
 arch/tile/include/asm/smp.h               |   2 -
 arch/tile/include/asm/traps.h             |   2 +-
 arch/tile/include/uapi/arch/Kbuild        |   1 -
 arch/tile/include/uapi/arch/chip.h        |   4 +-
 arch/tile/include/uapi/arch/chip_tile64.h | 258 ---------------------------
 arch/tile/include/uapi/arch/spr_def_32.h  |   2 -
 arch/tile/kernel/intvec_32.S              |  69 +-------
 arch/tile/kernel/intvec_64.S              |   2 -
 arch/tile/kernel/irq.c                    |   4 +-
 arch/tile/kernel/process.c                |  44 +----
 arch/tile/kernel/relocate_kernel_32.S     |   2 -
 arch/tile/kernel/relocate_kernel_64.S     |   2 -
 arch/tile/kernel/setup.c                  |  13 --
 arch/tile/kernel/single_step.c            |   2 -
 arch/tile/lib/Makefile                    |   2 +-
 arch/tile/lib/atomic_32.c                 |  90 ----------
 arch/tile/lib/memcpy_32.S                 |  61 -------
 arch/tile/lib/memcpy_tile64.c             | 280 ------------------------------
 arch/tile/lib/memset_32.c                 | 105 -----------
 arch/tile/mm/fault.c                      |  70 ++------
 arch/tile/mm/homecache.c                  |  29 +---
 arch/tile/mm/init.c                       |  68 +-------
 28 files changed, 34 insertions(+), 1121 deletions(-)
 delete mode 100644 arch/tile/include/uapi/arch/chip_tile64.h
 delete mode 100644 arch/tile/lib/memcpy_tile64.c

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index ee91e4a..5c872e7 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -208,7 +208,7 @@ config SYSVIPC_COMPAT
 	def_bool y
 	depends on COMPAT && SYSVIPC
 
-# We do not currently support disabling HIGHMEM on tile64 and tilepro.
+# We do not currently support disabling HIGHMEM on tilepro.
 config HIGHMEM
 	bool # "Support for more than 512 MB of RAM"
 	default !TILEGX
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index e7fb5cf..96156f5 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -252,21 +252,6 @@ static inline void atomic64_set(atomic64_t *v, u64 n)
  * Internal definitions only beyond this point.
  */
 
-#define ATOMIC_LOCKS_FOUND_VIA_TABLE() \
-  (!CHIP_HAS_CBOX_HOME_MAP() && defined(CONFIG_SMP))
-
-#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-
-/* Number of entries in atomic_lock_ptr[]. */
-#define ATOMIC_HASH_L1_SHIFT 6
-#define ATOMIC_HASH_L1_SIZE (1 << ATOMIC_HASH_L1_SHIFT)
-
-/* Number of locks in each struct pointed to by atomic_lock_ptr[]. */
-#define ATOMIC_HASH_L2_SHIFT (CHIP_L2_LOG_LINE_SIZE() - 2)
-#define ATOMIC_HASH_L2_SIZE (1 << ATOMIC_HASH_L2_SHIFT)
-
-#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
-
 /*
  * Number of atomic locks in atomic_locks[]. Must be a power of two.
  * There is no reason for more than PAGE_SIZE / 8 entries, since that
@@ -281,8 +266,6 @@ static inline void atomic64_set(atomic64_t *v, u64 n)
 extern int atomic_locks[];
 #endif
 
-#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
-
 /*
  * All the code that may fault while holding an atomic lock must
  * place the pointer to the lock in ATOMIC_LOCK_REG so the fault code
diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
index 990a217..a9a73da 100644
--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -77,7 +77,6 @@
 
 #define __sync()	__insn_mf()
 
-#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
 #include <hv/syscall_public.h>
 /*
  * Issue an uncacheable load to each memory controller, then
@@ -96,7 +95,6 @@ static inline void __mb_incoherent(void)
 		       "r20", "r21", "r22", "r23", "r24",
 		       "r25", "r26", "r27", "r28", "r29");
 }
-#endif
 
 /* Fence to guarantee visibility of stores to incoherent memory. */
 static inline void
@@ -104,7 +102,6 @@ mb_incoherent(void)
 {
 	__insn_mf();
 
-#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
 	{
 #if CHIP_HAS_TILE_WRITE_PENDING()
 		const unsigned long WRITE_TIMEOUT_CYCLES = 400;
@@ -116,7 +113,6 @@ mb_incoherent(void)
 #endif /* CHIP_HAS_TILE_WRITE_PENDING() */
 		(void) __mb_incoherent();
 	}
-#endif /* CHIP_HAS_MF_WAITS_FOR_VICTIMS() */
 }
 
 #define fast_wmb()	__sync()
diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index e1da88e..41d9878 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -30,7 +30,6 @@ typedef unsigned long elf_greg_t;
 #define ELF_NGREG (sizeof(struct pt_regs) / sizeof(elf_greg_t))
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 
-#define EM_TILE64  187
 #define EM_TILEPRO 188
 #define EM_TILEGX  191
 
diff --git a/arch/tile/include/asm/homecache.h b/arch/tile/include/asm/homecache.h
index 49d19df..7ddd1b8 100644
--- a/arch/tile/include/asm/homecache.h
+++ b/arch/tile/include/asm/homecache.h
@@ -33,8 +33,7 @@ struct zone;
 
 /*
  * Is this page immutable (unwritable) and thus able to be cached more
- * widely than would otherwise be possible?  On tile64 this means we
- * mark the PTE to cache locally; on tilepro it means we have "nc" set.
+ * widely than would otherwise be possible?  This means we have "nc" set.
  */
 #define PAGE_HOME_IMMUTABLE -2
 
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 5aa5431..4232363 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -113,18 +113,14 @@ struct thread_struct {
 	unsigned long intctrl_0;
 	/* Is this task currently doing a backtrace? */
 	bool in_backtrace;
-#if CHIP_HAS_PROC_STATUS_SPR()
 	/* Any other miscellaneous processor state bits */
 	unsigned long proc_status;
-#endif
 #if !CHIP_HAS_FIXED_INTVEC_BASE()
 	/* Interrupt base for PL0 interrupts */
 	unsigned long interrupt_vector_base;
 #endif
-#if CHIP_HAS_TILE_RTF_HWM()
 	/* Tile cache retry fifo high-water mark */
 	unsigned long tile_rtf_hwm;
-#endif
 #if CHIP_HAS_DSTREAM_PF()
 	/* Data stream prefetch control */
 	unsigned long dstream_pf;
@@ -137,12 +133,6 @@ struct thread_struct {
 	/* Async DMA TLB fault information */
 	struct async_tlb dma_async_tlb;
 #endif
-#if CHIP_HAS_SN_PROC()
-	/* Was static network processor when we were switched out? */
-	int sn_proc_running;
-	/* Async SNI TLB fault information */
-	struct async_tlb sn_async_tlb;
-#endif
 };
 
 #endif /* !__ASSEMBLY__ */
@@ -286,7 +276,6 @@ extern char chip_model[64];
 /* Data on which physical memory controller corresponds to which NUMA node. */
 extern int node_controller[];
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 /* Does the heap allocator return hash-for-home pages by default? */
 extern int hash_default;
 
@@ -296,11 +285,6 @@ extern int kstack_hash;
 /* Does MAP_ANONYMOUS return hash-for-home pages by default? */
 #define uheap_hash hash_default
 
-#else
-#define hash_default 0
-#define kstack_hash 0
-#define uheap_hash 0
-#endif
 
 /* Are we using huge pages in the TLB for kernel data? */
 extern int kdata_huge;
diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
index 1aa759a..9a326b6 100644
--- a/arch/tile/include/asm/smp.h
+++ b/arch/tile/include/asm/smp.h
@@ -101,10 +101,8 @@ void print_disabled_cpus(void);
 extern struct cpumask cpu_lotar_map;
 #define cpu_is_valid_lotar(cpu) cpumask_test_cpu((cpu), &cpu_lotar_map)
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 /* Which processors are used for hash-for-home mapping */
 extern struct cpumask hash_for_home_map;
-#endif
 
 /* Which cpus can have their cache flushed by hv_flush_remote(). */
 extern struct cpumask cpu_cacheable_map;
diff --git a/arch/tile/include/asm/traps.h b/arch/tile/include/asm/traps.h
index 5f172b2..4b99a1c 100644
--- a/arch/tile/include/asm/traps.h
+++ b/arch/tile/include/asm/traps.h
@@ -21,7 +21,7 @@
 /* mm/fault.c */
 void do_page_fault(struct pt_regs *, int fault_num,
 		   unsigned long address, unsigned long write);
-#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
+#if CHIP_HAS_TILE_DMA()
 void do_async_page_fault(struct pt_regs *);
 #endif
 
diff --git a/arch/tile/include/uapi/arch/Kbuild b/arch/tile/include/uapi/arch/Kbuild
index 4ebc34f..97dfbec 100644
--- a/arch/tile/include/uapi/arch/Kbuild
+++ b/arch/tile/include/uapi/arch/Kbuild
@@ -1,7 +1,6 @@
 # UAPI Header export list
 header-y += abi.h
 header-y += chip.h
-header-y += chip_tile64.h
 header-y += chip_tilegx.h
 header-y += chip_tilepro.h
 header-y += icache.h
diff --git a/arch/tile/include/uapi/arch/chip.h b/arch/tile/include/uapi/arch/chip.h
index 926d3db..4c91f90 100644
--- a/arch/tile/include/uapi/arch/chip.h
+++ b/arch/tile/include/uapi/arch/chip.h
@@ -12,9 +12,7 @@
  *   more details.
  */
 
-#if __tile_chip__ == 0
-#include <arch/chip_tile64.h>
-#elif __tile_chip__ == 1
+#if __tile_chip__ == 1
 #include <arch/chip_tilepro.h>
 #elif defined(__tilegx__)
 #include <arch/chip_tilegx.h>
diff --git a/arch/tile/include/uapi/arch/chip_tile64.h b/arch/tile/include/uapi/arch/chip_tile64.h
deleted file mode 100644
index 261aaba..0000000
--- a/arch/tile/include/uapi/arch/chip_tile64.h
+++ /dev/null
@@ -1,258 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-/*
- * @file
- * Global header file.
- * This header file specifies defines for TILE64.
- */
-
-#ifndef __ARCH_CHIP_H__
-#define __ARCH_CHIP_H__
-
-/** Specify chip version.
- * When possible, prefer the CHIP_xxx symbols below for future-proofing.
- * This is intended for cross-compiling; native compilation should
- * use the predefined __tile_chip__ symbol.
- */
-#define TILE_CHIP 0
-
-/** Specify chip revision.
- * This provides for the case of a respin of a particular chip type;
- * the normal value for this symbol is "0".
- * This is intended for cross-compiling; native compilation should
- * use the predefined __tile_chip_rev__ symbol.
- */
-#define TILE_CHIP_REV 0
-
-/** The name of this architecture. */
-#define CHIP_ARCH_NAME "tile64"
-
-/** The ELF e_machine type for binaries for this chip. */
-#define CHIP_ELF_TYPE() EM_TILE64
-
-/** The alternate ELF e_machine type for binaries for this chip. */
-#define CHIP_COMPAT_ELF_TYPE() 0x2506
-
-/** What is the native word size of the machine? */
-#define CHIP_WORD_SIZE() 32
-
-/** How many bits of a virtual address are used. Extra bits must be
- * the sign extension of the low bits.
- */
-#define CHIP_VA_WIDTH() 32
-
-/** How many bits are in a physical address? */
-#define CHIP_PA_WIDTH() 36
-
-/** Size of the L2 cache, in bytes. */
-#define CHIP_L2_CACHE_SIZE() 65536
-
-/** Log size of an L2 cache line in bytes. */
-#define CHIP_L2_LOG_LINE_SIZE() 6
-
-/** Size of an L2 cache line, in bytes. */
-#define CHIP_L2_LINE_SIZE() (1 << CHIP_L2_LOG_LINE_SIZE())
-
-/** Associativity of the L2 cache. */
-#define CHIP_L2_ASSOC() 2
-
-/** Size of the L1 data cache, in bytes. */
-#define CHIP_L1D_CACHE_SIZE() 8192
-
-/** Log size of an L1 data cache line in bytes. */
-#define CHIP_L1D_LOG_LINE_SIZE() 4
-
-/** Size of an L1 data cache line, in bytes. */
-#define CHIP_L1D_LINE_SIZE() (1 << CHIP_L1D_LOG_LINE_SIZE())
-
-/** Associativity of the L1 data cache. */
-#define CHIP_L1D_ASSOC() 2
-
-/** Size of the L1 instruction cache, in bytes. */
-#define CHIP_L1I_CACHE_SIZE() 8192
-
-/** Log size of an L1 instruction cache line in bytes. */
-#define CHIP_L1I_LOG_LINE_SIZE() 6
-
-/** Size of an L1 instruction cache line, in bytes. */
-#define CHIP_L1I_LINE_SIZE() (1 << CHIP_L1I_LOG_LINE_SIZE())
-
-/** Associativity of the L1 instruction cache. */
-#define CHIP_L1I_ASSOC() 1
-
-/** Stride with which flush instructions must be issued. */
-#define CHIP_FLUSH_STRIDE() CHIP_L2_LINE_SIZE()
-
-/** Stride with which inv instructions must be issued. */
-#define CHIP_INV_STRIDE() CHIP_L1D_LINE_SIZE()
-
-/** Stride with which finv instructions must be issued. */
-#define CHIP_FINV_STRIDE() CHIP_L1D_LINE_SIZE()
-
-/** Can the local cache coherently cache data that is homed elsewhere? */
-#define CHIP_HAS_COHERENT_LOCAL_CACHE() 0
-
-/** How many simultaneous outstanding victims can the L2 cache have? */
-#define CHIP_MAX_OUTSTANDING_VICTIMS() 2
-
-/** Does the TLB support the NC and NOALLOC bits? */
-#define CHIP_HAS_NC_AND_NOALLOC_BITS() 0
-
-/** Does the chip support hash-for-home caching? */
-#define CHIP_HAS_CBOX_HOME_MAP() 0
-
-/** Number of entries in the chip's home map tables. */
-/* #define CHIP_CBOX_HOME_MAP_SIZE() -- does not apply to chip 0 */
-
-/** Do uncacheable requests miss in the cache regardless of whether
- * there is matching data? */
-#define CHIP_HAS_ENFORCED_UNCACHEABLE_REQUESTS() 0
-
-/** Does the mf instruction wait for victims? */
-#define CHIP_HAS_MF_WAITS_FOR_VICTIMS() 1
-
-/** Does the chip have an "inv" instruction that doesn't also flush? */
-#define CHIP_HAS_INV() 0
-
-/** Does the chip have a "wh64" instruction? */
-#define CHIP_HAS_WH64() 0
-
-/** Does this chip have a 'dword_align' instruction? */
-#define CHIP_HAS_DWORD_ALIGN() 0
-
-/** Number of performance counters. */
-#define CHIP_PERFORMANCE_COUNTERS() 2
-
-/** Does this chip have auxiliary performance counters? */
-#define CHIP_HAS_AUX_PERF_COUNTERS() 0
-
-/** Is the CBOX_MSR1 SPR supported? */
-#define CHIP_HAS_CBOX_MSR1() 0
-
-/** Is the TILE_RTF_HWM SPR supported? */
-#define CHIP_HAS_TILE_RTF_HWM() 0
-
-/** Is the TILE_WRITE_PENDING SPR supported? */
-#define CHIP_HAS_TILE_WRITE_PENDING() 0
-
-/** Is the PROC_STATUS SPR supported? */
-#define CHIP_HAS_PROC_STATUS_SPR() 0
-
-/** Is the DSTREAM_PF SPR supported? */
-#define CHIP_HAS_DSTREAM_PF() 0
-
-/** Log of the number of mshims we have. */
-#define CHIP_LOG_NUM_MSHIMS() 2
-
-/** Are the bases of the interrupt vector areas fixed? */
-#define CHIP_HAS_FIXED_INTVEC_BASE() 1
-
-/** Are the interrupt masks split up into 2 SPRs? */
-#define CHIP_HAS_SPLIT_INTR_MASK() 1
-
-/** Is the cycle count split up into 2 SPRs? */
-#define CHIP_HAS_SPLIT_CYCLE() 1
-
-/** Does the chip have a static network? */
-#define CHIP_HAS_SN() 1
-
-/** Does the chip have a static network processor? */
-#define CHIP_HAS_SN_PROC() 1
-
-/** Size of the L1 static network processor instruction cache, in bytes. */
-#define CHIP_L1SNI_CACHE_SIZE() 2048
-
-/** Does the chip have DMA support in each tile? */
-#define CHIP_HAS_TILE_DMA() 1
-
-/** Does the chip have the second revision of the directly accessible
- *  dynamic networks?  This encapsulates a number of characteristics,
- *  including the absence of the catch-all, the absence of inline message
- *  tags, the absence of support for network context-switching, and so on.
- */
-#define CHIP_HAS_REV1_XDN() 0
-
-/** Does the chip have cmpexch and similar (fetchadd, exch, etc.)? */
-#define CHIP_HAS_CMPEXCH() 0
-
-/** Does the chip have memory-mapped I/O support? */
-#define CHIP_HAS_MMIO() 0
-
-/** Does the chip have post-completion interrupts? */
-#define CHIP_HAS_POST_COMPLETION_INTERRUPTS() 0
-
-/** Does the chip have native single step support? */
-#define CHIP_HAS_SINGLE_STEP() 0
-
-#ifndef __OPEN_SOURCE__  /* features only relevant to hypervisor-level code */
-
-/** How many entries are present in the instruction TLB? */
-#define CHIP_ITLB_ENTRIES() 8
-
-/** How many entries are present in the data TLB? */
-#define CHIP_DTLB_ENTRIES() 16
-
-/** How many MAF entries does the XAUI shim have? */
-#define CHIP_XAUI_MAF_ENTRIES() 16
-
-/** Does the memory shim have a source-id table? */
-#define CHIP_HAS_MSHIM_SRCID_TABLE() 1
-
-/** Does the L1 instruction cache clear on reset? */
-#define CHIP_HAS_L1I_CLEAR_ON_RESET() 0
-
-/** Does the chip come out of reset with valid coordinates on all tiles?
- * Note that if defined, this also implies that the upper left is 1,1.
- */
-#define CHIP_HAS_VALID_TILE_COORD_RESET() 0
-
-/** Does the chip have unified packet formats? */
-#define CHIP_HAS_UNIFIED_PACKET_FORMATS() 0
-
-/** Does the chip support write reordering? */
-#define CHIP_HAS_WRITE_REORDERING() 0
-
-/** Does the chip support Y-X routing as well as X-Y? */
-#define CHIP_HAS_Y_X_ROUTING() 0
-
-/** Is INTCTRL_3 managed with the correct MPL? */
-#define CHIP_HAS_INTCTRL_3_STATUS_FIX() 0
-
-/** Is it possible to configure the chip to be big-endian? */
-#define CHIP_HAS_BIG_ENDIAN_CONFIG() 0
-
-/** Is the CACHE_RED_WAY_OVERRIDDEN SPR supported? */
-#define CHIP_HAS_CACHE_RED_WAY_OVERRIDDEN() 0
-
-/** Is the DIAG_TRACE_WAY SPR supported? */
-#define CHIP_HAS_DIAG_TRACE_WAY() 0
-
-/** Is the MEM_STRIPE_CONFIG SPR supported? */
-#define CHIP_HAS_MEM_STRIPE_CONFIG() 0
-
-/** Are the TLB_PERF SPRs supported? */
-#define CHIP_HAS_TLB_PERF() 0
-
-/** Is the VDN_SNOOP_SHIM_CTL SPR supported? */
-#define CHIP_HAS_VDN_SNOOP_SHIM_CTL() 0
-
-/** Does the chip support rev1 DMA packets? */
-#define CHIP_HAS_REV1_DMA_PACKETS() 0
-
-/** Does the chip have an IPI shim? */
-#define CHIP_HAS_IPI() 0
-
-#endif /* !__OPEN_SOURCE__ */
-#endif /* __ARCH_CHIP_H__ */
diff --git a/arch/tile/include/uapi/arch/spr_def_32.h b/arch/tile/include/uapi/arch/spr_def_32.h
index 4644c8d..f5ae4df 100644
--- a/arch/tile/include/uapi/arch/spr_def_32.h
+++ b/arch/tile/include/uapi/arch/spr_def_32.h
@@ -215,8 +215,6 @@
 #define SPR_SIM_CONTROL 0x4e0c
 #define SPR_SNCTL 0x0805
 #define SPR_SNCTL__FRZFABRIC_MASK  0x1
-#define SPR_SNCTL__FRZPROC_MASK  0x2
-#define SPR_SNPC 0x080b
 #define SPR_SNSTATIC 0x080c
 #define SPR_SYSTEM_SAVE_0_0 0x4b00
 #define SPR_SYSTEM_SAVE_0_1 0x4b01
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 2ce69a5..00f0644 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -32,12 +32,6 @@
 
 #define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
 
-#if !CHIP_HAS_WH64()
-	/* By making this an empty macro, we can use wh64 in the code. */
-	.macro  wh64 reg
-	.endm
-#endif
-
 	.macro  push_reg reg, ptr=sp, delta=-4
 	{
 	 sw     \ptr, \reg
@@ -325,18 +319,14 @@ intvec_\vecname:
 	 movei  r3, -1   /* not used, but set for consistency */
 	}
 	.else
-#if CHIP_HAS_AUX_PERF_COUNTERS()
 	.ifc \c_routine, op_handle_aux_perf_interrupt
 	{
 	 mfspr  r2, AUX_PERF_COUNT_STS
 	 movei  r3, -1   /* not used, but set for consistency */
 	}
 	.else
-#endif
 	movei   r3, 0
-#if CHIP_HAS_AUX_PERF_COUNTERS()
 	.endif
-#endif
 	.endif
 	.endif
 	.endif
@@ -561,7 +551,6 @@ intvec_\vecname:
 	.endif
 	mtspr   INTERRUPT_CRITICAL_SECTION, zero
 
-#if CHIP_HAS_WH64()
 	/*
 	 * Prepare the first 256 stack bytes to be rapidly accessible
 	 * without having to fetch the background data.  We don't really
@@ -582,7 +571,6 @@ intvec_\vecname:
 	 addi   r52, r52, -64
 	}
 	wh64    r52
-#endif
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	.ifnc \function,handle_nmi
@@ -1535,12 +1523,10 @@ STD_ENTRY(_sys_clone)
 	__HEAD
 	.align 64
 	/* Align much later jump on the start of a cache line. */
-#if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
 	nop
 #if PAGE_SIZE >= 0x10000
 	nop
 #endif
-#endif
 ENTRY(sys_cmpxchg)
 
 	/*
@@ -1574,45 +1560,6 @@ ENTRY(sys_cmpxchg)
 # error Code here assumes PAGE_OFFSET can be loaded with just hi16()
 #endif
 
-#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-	{
-	 /* Check for unaligned input. */
-	 bnz    sp, .Lcmpxchg_badaddr
-	 mm     r25, r0, zero, 3, PAGE_SHIFT-1
-	}
-	{
-	 crc32_32 r25, zero, r25
-	 moveli r21, lo16(atomic_lock_ptr)
-	}
-	{
-	 auli   r21, r21, ha16(atomic_lock_ptr)
-	 auli   r23, zero, hi16(PAGE_OFFSET)  /* hugepage-aligned */
-	}
-	{
-	 shri	r20, r25, 32 - ATOMIC_HASH_L1_SHIFT
-	 slt_u  r23, r0, r23
-	 lw	r26, r0  /* see comment in the "#else" for the "lw r26". */
-	}
-	{
-	 s2a    r21, r20, r21
-	 bbns   r23, .Lcmpxchg_badaddr
-	}
-	{
-	 lw     r21, r21
-	 seqi	r23, TREG_SYSCALL_NR_NAME, __NR_FAST_cmpxchg64
-	 andi	r25, r25, ATOMIC_HASH_L2_SIZE - 1
-	}
-	{
-	 /* Branch away at this point if we're doing a 64-bit cmpxchg. */
-	 bbs    r23, .Lcmpxchg64
-	 andi   r23, r0, 7       /* Precompute alignment for cmpxchg64. */
-	}
-	{
-	 s2a	ATOMIC_LOCK_REG_NAME, r25, r21
-	 j      .Lcmpxchg32_tns   /* see comment in the #else for the jump. */
-	}
-
-#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
 	{
 	 /* Check for unaligned input. */
 	 bnz    sp, .Lcmpxchg_badaddr
@@ -1637,12 +1584,9 @@ ENTRY(sys_cmpxchg)
 
 	 /*
 	  * Ensure that the TLB is loaded before we take out the lock.
-	  * On tilepro, this will start fetching the value all the way
-	  * into our L1 as well (and if it gets modified before we
-	  * grab the lock, it will be invalidated from our cache
-	  * before we reload it).  On tile64, we'll start fetching it
-	  * into our L1 if we're the home, and if we're not, we'll
-	  * still at least start fetching it into the home's L2.
+	  * This will start fetching the value all the way into our L1
+	  * as well (and if it gets modified before we grab the lock,
+	  * it will be invalidated from our cache before we reload it).
 	  */
 	 lw	r26, r0
 	}
@@ -1685,8 +1629,6 @@ ENTRY(sys_cmpxchg)
 	 j      .Lcmpxchg32_tns
 	}
 
-#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
-
 /* Symbol for do_page_fault_ics() to use to compare against the PC. */
 .global __sys_cmpxchg_grab_lock
 __sys_cmpxchg_grab_lock:
@@ -1824,9 +1766,6 @@ __sys_cmpxchg_grab_lock:
 	.align 64
 .Lcmpxchg64:
 	{
-#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-	 s2a	ATOMIC_LOCK_REG_NAME, r25, r21
-#endif
 	 bzt     r23, .Lcmpxchg64_tns
 	}
 	j       .Lcmpxchg_badaddr
@@ -1961,10 +1900,8 @@ int_unalign:
 		     do_page_fault
 	int_hand     INT_SN_CPL, SN_CPL, bad_intr
 	int_hand     INT_DOUBLE_FAULT, DOUBLE_FAULT, do_trap
-#if CHIP_HAS_AUX_PERF_COUNTERS()
 	int_hand     INT_AUX_PERF_COUNT, AUX_PERF_COUNT, \
 		     op_handle_aux_perf_interrupt, handle_nmi
-#endif
 
 	/* Synthetic interrupt delivered only by the simulator */
 	int_hand     INT_BREAKPOINT, BREAKPOINT, do_breakpoint
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index ccb0e65..8299f29 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -515,12 +515,10 @@ intvec_\vecname:
 	.else
 	.ifc \c_routine, op_handle_perf_interrupt
 	mfspr   r2, PERF_COUNT_STS
-#if CHIP_HAS_AUX_PERF_COUNTERS()
 	.else
 	.ifc \c_routine, op_handle_aux_perf_interrupt
 	mfspr   r2, AUX_PERF_COUNT_STS
 	.endif
-#endif
 	.endif
 	.endif
 	.endif
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 0e6c521..d8ba060 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -74,7 +74,7 @@ static DEFINE_SPINLOCK(available_irqs_lock);
 
 /*
  * The interrupt handling path, implemented in terms of HV interrupt
- * emulation on TILE64 and TILEPro, and IPI hardware on TILE-Gx.
+ * emulation on TILEPro, and IPI hardware on TILE-Gx.
  * Entered with interrupts disabled.
  */
 void tile_dev_intr(struct pt_regs *regs, int intnum)
@@ -235,7 +235,7 @@ void tile_irq_activate(unsigned int irq, int tile_irq_type)
 {
 	/*
 	 * We use handle_level_irq() by default because the pending
-	 * interrupt vector (whether modeled by the HV on TILE64 and
+	 * interrupt vector (whether modeled by the HV on
 	 * TILEPro or implemented in hardware on TILE-Gx) has
 	 * level-style semantics for each bit.  An interrupt fires
 	 * whenever a bit is high, not just at edges.
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 9892f03..781ac33 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -188,16 +188,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	memset(&p->thread.dma_async_tlb, 0, sizeof(struct async_tlb));
 #endif
 
-#if CHIP_HAS_SN_PROC()
-	/* Likewise, the new thread is not running static processor code. */
-	p->thread.sn_proc_running = 0;
-	memset(&p->thread.sn_async_tlb, 0, sizeof(struct async_tlb));
-#endif
-
-#if CHIP_HAS_PROC_STATUS_SPR()
 	/* New thread has its miscellaneous processor state bits clear. */
 	p->thread.proc_status = 0;
-#endif
 
 #ifdef CONFIG_HARDWALL
 	/* New thread does not own any networks. */
@@ -381,15 +373,11 @@ static void save_arch_state(struct thread_struct *t)
 	t->system_save[2] = __insn_mfspr(SPR_SYSTEM_SAVE_0_2);
 	t->system_save[3] = __insn_mfspr(SPR_SYSTEM_SAVE_0_3);
 	t->intctrl_0 = __insn_mfspr(SPR_INTCTRL_0_STATUS);
-#if CHIP_HAS_PROC_STATUS_SPR()
 	t->proc_status = __insn_mfspr(SPR_PROC_STATUS);
-#endif
 #if !CHIP_HAS_FIXED_INTVEC_BASE()
 	t->interrupt_vector_base = __insn_mfspr(SPR_INTERRUPT_VECTOR_BASE_0);
 #endif
-#if CHIP_HAS_TILE_RTF_HWM()
 	t->tile_rtf_hwm = __insn_mfspr(SPR_TILE_RTF_HWM);
-#endif
 #if CHIP_HAS_DSTREAM_PF()
 	t->dstream_pf = __insn_mfspr(SPR_DSTREAM_PF);
 #endif
@@ -410,15 +398,11 @@ static void restore_arch_state(const struct thread_struct *t)
 	__insn_mtspr(SPR_SYSTEM_SAVE_0_2, t->system_save[2]);
 	__insn_mtspr(SPR_SYSTEM_SAVE_0_3, t->system_save[3]);
 	__insn_mtspr(SPR_INTCTRL_0_STATUS, t->intctrl_0);
-#if CHIP_HAS_PROC_STATUS_SPR()
 	__insn_mtspr(SPR_PROC_STATUS, t->proc_status);
-#endif
 #if !CHIP_HAS_FIXED_INTVEC_BASE()
 	__insn_mtspr(SPR_INTERRUPT_VECTOR_BASE_0, t->interrupt_vector_base);
 #endif
-#if CHIP_HAS_TILE_RTF_HWM()
 	__insn_mtspr(SPR_TILE_RTF_HWM, t->tile_rtf_hwm);
-#endif
 #if CHIP_HAS_DSTREAM_PF()
 	__insn_mtspr(SPR_DSTREAM_PF, t->dstream_pf);
 #endif
@@ -427,26 +411,11 @@ static void restore_arch_state(const struct thread_struct *t)
 
 void _prepare_arch_switch(struct task_struct *next)
 {
-#if CHIP_HAS_SN_PROC()
-	int snctl;
-#endif
 #if CHIP_HAS_TILE_DMA()
 	struct tile_dma_state *dma = &current->thread.tile_dma_state;
 	if (dma->enabled)
 		save_tile_dma_state(dma);
 #endif
-#if CHIP_HAS_SN_PROC()
-	/*
-	 * Suspend the static network processor if it was running.
-	 * We do not suspend the fabric itself, just like we don't
-	 * try to suspend the UDN.
-	 */
-	snctl = __insn_mfspr(SPR_SNCTL);
-	current->thread.sn_proc_running =
-		(snctl & SPR_SNCTL__FRZPROC_MASK) == 0;
-	if (current->thread.sn_proc_running)
-		__insn_mtspr(SPR_SNCTL, snctl | SPR_SNCTL__FRZPROC_MASK);
-#endif
 }
 
 
@@ -479,17 +448,6 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 	/* Restore other arch state. */
 	restore_arch_state(&next->thread);
 
-#if CHIP_HAS_SN_PROC()
-	/*
-	 * Restart static network processor in the new process
-	 * if it was running before.
-	 */
-	if (next->thread.sn_proc_running) {
-		int snctl = __insn_mfspr(SPR_SNCTL);
-		__insn_mtspr(SPR_SNCTL, snctl & ~SPR_SNCTL__FRZPROC_MASK);
-	}
-#endif
-
 #ifdef CONFIG_HARDWALL
 	/* Enable or disable access to the network registers appropriately. */
 	hardwall_switch_tasks(prev, next);
@@ -557,7 +515,7 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 		schedule();
 		return 1;
 	}
-#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
+#if CHIP_HAS_TILE_DMA()
 	if (thread_info_flags & _TIF_ASYNC_TLB) {
 		do_async_page_fault(regs);
 		return 1;
diff --git a/arch/tile/kernel/relocate_kernel_32.S b/arch/tile/kernel/relocate_kernel_32.S
index f7fd37b..e44fbcf 100644
--- a/arch/tile/kernel/relocate_kernel_32.S
+++ b/arch/tile/kernel/relocate_kernel_32.S
@@ -77,7 +77,6 @@ STD_ENTRY(relocate_new_kernel)
 	move	r30, sp
 	addi	sp, sp, -8
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 	/*
 	 * On TILEPro, we need to flush all tiles' caches, since we may
 	 * have been doing hash-for-home caching there.  Note that we
@@ -113,7 +112,6 @@ STD_ENTRY(relocate_new_kernel)
 	}
 
 	jalr	r20
-#endif
 
 	/* r33 is destination pointer, default to zero */
 
diff --git a/arch/tile/kernel/relocate_kernel_64.S b/arch/tile/kernel/relocate_kernel_64.S
index 02bc446..d9d8cf6 100644
--- a/arch/tile/kernel/relocate_kernel_64.S
+++ b/arch/tile/kernel/relocate_kernel_64.S
@@ -78,7 +78,6 @@ STD_ENTRY(relocate_new_kernel)
 	move	r30, sp
 	addi	sp, sp, -16
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 	/*
 	 * On TILE-GX, we need to flush all tiles' caches, since we may
 	 * have been doing hash-for-home caching there.  Note that we
@@ -116,7 +115,6 @@ STD_ENTRY(relocate_new_kernel)
 	shl16insli	r20, r20, hw0(hv_flush_remote)
 
 	jalr	r20
-#endif
 
 	/* r33 is destination pointer, default to zero */
 
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 37a5b78..eef58a7 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1046,9 +1046,6 @@ void __cpuinit setup_cpu(int boot)
 	arch_local_irq_unmask(INT_DMATLB_MISS);
 	arch_local_irq_unmask(INT_DMATLB_ACCESS);
 #endif
-#if CHIP_HAS_SN_PROC()
-	arch_local_irq_unmask(INT_SNITLB_MISS);
-#endif
 #ifdef __tilegx__
 	arch_local_irq_unmask(INT_SINGLE_STEP_K);
 #endif
@@ -1063,10 +1060,6 @@ void __cpuinit setup_cpu(int boot)
 	/* Static network is not restricted. */
 	__insn_mtspr(SPR_MPL_SN_ACCESS_SET_0, 1);
 #endif
-#if CHIP_HAS_SN_PROC()
-	__insn_mtspr(SPR_MPL_SN_NOTIFY_SET_0, 1);
-	__insn_mtspr(SPR_MPL_SN_CPL_SET_0, 1);
-#endif
 
 	/*
 	 * Set the MPL for interrupt control 0 & 1 to the corresponding
@@ -1304,7 +1297,6 @@ static void __init validate_va(void)
 struct cpumask __write_once cpu_lotar_map;
 EXPORT_SYMBOL(cpu_lotar_map);
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 /*
  * hash_for_home_map lists all the tiles that hash-for-home data
  * will be cached on.  Note that this may includes tiles that are not
@@ -1314,7 +1306,6 @@ EXPORT_SYMBOL(cpu_lotar_map);
  */
 struct cpumask hash_for_home_map;
 EXPORT_SYMBOL(hash_for_home_map);
-#endif
 
 /*
  * cpu_cacheable_map lists all the cpus whose caches the hypervisor can
@@ -1407,7 +1398,6 @@ static void __init setup_cpu_maps(void)
 		cpu_lotar_map = *cpu_possible_mask;
 	}
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 	/* Retrieve set of CPUs used for hash-for-home caching */
 	rc = hv_inquire_tiles(HV_INQ_TILES_HFH_CACHE,
 			      (HV_VirtAddr) hash_for_home_map.bits,
@@ -1415,9 +1405,6 @@ static void __init setup_cpu_maps(void)
 	if (rc < 0)
 		early_panic("hv_inquire_tiles(HFH_CACHE) failed: rc %d\n", rc);
 	cpumask_or(&cpu_cacheable_map, cpu_possible_mask, &hash_for_home_map);
-#else
-	cpu_cacheable_map = *cpu_possible_mask;
-#endif
 }
 
 
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 5ef2e9e..de07fa7 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -546,7 +546,6 @@ void single_step_once(struct pt_regs *regs)
 			}
 			break;
 
-#if CHIP_HAS_WH64()
 		/* postincrement operations */
 		case IMM_0_OPCODE_X1:
 			switch (get_ImmOpcodeExtension_X1(bundle)) {
@@ -581,7 +580,6 @@ void single_step_once(struct pt_regs *regs)
 				break;
 			}
 			break;
-#endif /* CHIP_HAS_WH64() */
 		}
 
 		if (state->update) {
diff --git a/arch/tile/lib/Makefile b/arch/tile/lib/Makefile
index 9adfd76..c4211cb 100644
--- a/arch/tile/lib/Makefile
+++ b/arch/tile/lib/Makefile
@@ -7,7 +7,7 @@ lib-y = cacheflush.o checksum.o cpumask.o delay.o uaccess.o \
 	strchr_$(BITS).o strlen_$(BITS).o strnlen_$(BITS).o
 
 lib-$(CONFIG_TILEGX) += memcpy_user_64.o
-lib-$(CONFIG_TILEPRO) += atomic_32.o atomic_asm_32.o memcpy_tile64.o
+lib-$(CONFIG_TILEPRO) += atomic_32.o atomic_asm_32.o
 lib-$(CONFIG_SMP) += spinlock_$(BITS).o usercopy_$(BITS).o
 
 obj-$(CONFIG_MODULES) += exports.o
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 42eacb1..5d91d18 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -20,50 +20,12 @@
 #include <linux/atomic.h>
 #include <arch/chip.h>
 
-/* See <asm/atomic_32.h> */
-#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-
-/*
- * A block of memory containing locks for atomic ops. Each instance of this
- * struct will be homed on a different CPU.
- */
-struct atomic_locks_on_cpu {
-	int lock[ATOMIC_HASH_L2_SIZE];
-} __attribute__((aligned(ATOMIC_HASH_L2_SIZE * 4)));
-
-static DEFINE_PER_CPU(struct atomic_locks_on_cpu, atomic_lock_pool);
-
-/* The locks we'll use until __init_atomic_per_cpu is called. */
-static struct atomic_locks_on_cpu __initdata initial_atomic_locks;
-
-/* Hash into this vector to get a pointer to lock for the given atomic. */
-struct atomic_locks_on_cpu *atomic_lock_ptr[ATOMIC_HASH_L1_SIZE]
-	__write_once = {
-	[0 ... ATOMIC_HASH_L1_SIZE-1] (&initial_atomic_locks)
-};
-
-#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
-
 /* This page is remapped on startup to be hash-for-home. */
 int atomic_locks[PAGE_SIZE / sizeof(int)] __page_aligned_bss;
 
-#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
-
 int *__atomic_hashed_lock(volatile void *v)
 {
 	/* NOTE: this code must match "sys_cmpxchg" in kernel/intvec_32.S */
-#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-	unsigned long i =
-		(unsigned long) v & ((PAGE_SIZE-1) & -sizeof(long long));
-	unsigned long n = __insn_crc32_32(0, i);
-
-	/* Grab high bits for L1 index. */
-	unsigned long l1_index = n >> ((sizeof(n) * 8) - ATOMIC_HASH_L1_SHIFT);
-	/* Grab low bits for L2 index. */
-	unsigned long l2_index = n & (ATOMIC_HASH_L2_SIZE - 1);
-
-	return &atomic_lock_ptr[l1_index]->lock[l2_index];
-#else
 	/*
 	 * Use bits [3, 3 + ATOMIC_HASH_SHIFT) as the lock index.
 	 * Using mm works here because atomic_locks is page aligned.
@@ -72,26 +34,13 @@ int *__atomic_hashed_lock(volatile void *v)
 				      (unsigned long)atomic_locks,
 				      2, (ATOMIC_HASH_SHIFT + 2) - 1);
 	return (int *)ptr;
-#endif
 }
 
 #ifdef CONFIG_SMP
 /* Return whether the passed pointer is a valid atomic lock pointer. */
 static int is_atomic_lock(int *p)
 {
-#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-	int i;
-	for (i = 0; i < ATOMIC_HASH_L1_SIZE; ++i) {
-
-		if (p >= &atomic_lock_ptr[i]->lock[0] &&
-		    p < &atomic_lock_ptr[i]->lock[ATOMIC_HASH_L2_SIZE]) {
-			return 1;
-		}
-	}
-	return 0;
-#else
 	return p >= &atomic_locks[0] && p < &atomic_locks[ATOMIC_HASH_SIZE];
-#endif
 }
 
 void __atomic_fault_unlock(int *irqlock_word)
@@ -210,43 +159,6 @@ struct __get_user __atomic_bad_address(int __user *addr)
 
 void __init __init_atomic_per_cpu(void)
 {
-#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
-
-	unsigned int i;
-	int actual_cpu;
-
-	/*
-	 * Before this is called from setup, we just have one lock for
-	 * all atomic objects/operations.  Here we replace the
-	 * elements of atomic_lock_ptr so that they point at per_cpu
-	 * integers.  This seemingly over-complex approach stems from
-	 * the fact that DEFINE_PER_CPU defines an entry for each cpu
-	 * in the grid, not each cpu from 0..ATOMIC_HASH_SIZE-1.  But
-	 * for efficient hashing of atomics to their locks we want a
-	 * compile time constant power of 2 for the size of this
-	 * table, so we use ATOMIC_HASH_SIZE.
-	 *
-	 * Here we populate atomic_lock_ptr from the per cpu
-	 * atomic_lock_pool, interspersing by actual cpu so that
-	 * subsequent elements are homed on consecutive cpus.
-	 */
-
-	actual_cpu = cpumask_first(cpu_possible_mask);
-
-	for (i = 0; i < ATOMIC_HASH_L1_SIZE; ++i) {
-		/*
-		 * Preincrement to slightly bias against using cpu 0,
-		 * which has plenty of stuff homed on it already.
-		 */
-		actual_cpu = cpumask_next(actual_cpu, cpu_possible_mask);
-		if (actual_cpu >= nr_cpu_ids)
-			actual_cpu = cpumask_first(cpu_possible_mask);
-
-		atomic_lock_ptr[i] = &per_cpu(atomic_lock_pool, actual_cpu);
-	}
-
-#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
-
 	/* Validate power-of-two and "bigger than cpus" assumption */
 	BUILD_BUG_ON(ATOMIC_HASH_SIZE & (ATOMIC_HASH_SIZE-1));
 	BUG_ON(ATOMIC_HASH_SIZE < nr_cpu_ids);
@@ -270,6 +182,4 @@ void __init __init_atomic_per_cpu(void)
 	 * That should not produce more indices than ATOMIC_HASH_SIZE.
 	 */
 	BUILD_BUG_ON((PAGE_SIZE >> 3) > ATOMIC_HASH_SIZE);
-
-#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
 }
diff --git a/arch/tile/lib/memcpy_32.S b/arch/tile/lib/memcpy_32.S
index 8ba7626..a2771ae 100644
--- a/arch/tile/lib/memcpy_32.S
+++ b/arch/tile/lib/memcpy_32.S
@@ -22,14 +22,6 @@
 
 #include <linux/linkage.h>
 
-/* On TILE64, we wrap these functions via arch/tile/lib/memcpy_tile64.c */
-#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
-#define memcpy __memcpy_asm
-#define __copy_to_user_inatomic __copy_to_user_inatomic_asm
-#define __copy_from_user_inatomic __copy_from_user_inatomic_asm
-#define __copy_from_user_zeroing __copy_from_user_zeroing_asm
-#endif
-
 #define IS_MEMCPY	  0
 #define IS_COPY_FROM_USER  1
 #define IS_COPY_FROM_USER_ZEROING  2
@@ -159,12 +151,9 @@ EX:	{ sw r0, r3; addi r0, r0, 4; addi r2, r2, -4 }
 
 	{ addi r3, r1, 60; andi r9, r9, -64 }
 
-#if CHIP_HAS_WH64()
 	/* No need to prefetch dst, we'll just do the wh64
 	 * right before we copy a line.
 	 */
-#endif
-
 EX:	{ lw r5, r3; addi r3, r3, 64; movei r4, 1 }
 	/* Intentionally stall for a few cycles to leave L2 cache alone. */
 	{ bnzt zero, .; move r27, lr }
@@ -172,21 +161,6 @@ EX:	{ lw r6, r3; addi r3, r3, 64 }
 	/* Intentionally stall for a few cycles to leave L2 cache alone. */
 	{ bnzt zero, . }
 EX:	{ lw r7, r3; addi r3, r3, 64 }
-#if !CHIP_HAS_WH64()
-	/* Prefetch the dest */
-	/* Intentionally stall for a few cycles to leave L2 cache alone. */
-	{ bnzt zero, . }
-	/* Use a real load to cause a TLB miss if necessary.  We aren't using
-	 * r28, so this should be fine.
-	 */
-EX:	{ lw r28, r9; addi r9, r9, 64 }
-	/* Intentionally stall for a few cycles to leave L2 cache alone. */
-	{ bnzt zero, . }
-	{ prefetch r9; addi r9, r9, 64 }
-	/* Intentionally stall for a few cycles to leave L2 cache alone. */
-	{ bnzt zero, . }
-	{ prefetch r9; addi r9, r9, 64 }
-#endif
 	/* Intentionally stall for a few cycles to leave L2 cache alone. */
 	{ bz zero, .Lbig_loop2 }
 
@@ -287,13 +261,8 @@ EX:	{ lw r7, r3; addi r3, r3, 64 }
 	/* Fill second L1D line. */
 EX:	{ lw r17, r17; addi r1, r1, 48; mvz r3, r13, r1 } /* r17 = WORD_4 */
 
-#if CHIP_HAS_WH64()
 	/* Prepare destination line for writing. */
 EX:	{ wh64 r9; addi r9, r9, 64 }
-#else
-	/* Prefetch dest line */
-	{ prefetch r9; addi r9, r9, 64 }
-#endif
 	/* Load seven words that are L1D hits to cover wh64 L2 usage. */
 
 	/* Load the three remaining words from the last L1D line, which
@@ -331,16 +300,7 @@ EX:	{ lw r18, r1; addi r1, r1, 4 }                  /* r18 = WORD_8 */
 EX:	{ sw r0, r16; addi r0, r0, 4; add r16, r0, r2 } /* store(WORD_0) */
 EX:	{ sw r0, r13; addi r0, r0, 4; andi r16, r16, -64 } /* store(WORD_1) */
 EX:	{ sw r0, r14; addi r0, r0, 4; slt_u r16, r9, r16 } /* store(WORD_2) */
-#if CHIP_HAS_WH64()
 EX:	{ sw r0, r15; addi r0, r0, 4; addi r13, sp, -64 } /* store(WORD_3) */
-#else
-	/* Back up the r9 to a cache line we are already storing to
-	 * if it gets past the end of the dest vector.  Strictly speaking,
-	 * we don't need to back up to the start of a cache line, but it's free
-	 * and tidy, so why not?
-	 */
-EX:	{ sw r0, r15; addi r0, r0, 4; andi r13, r0, -64 } /* store(WORD_3) */
-#endif
 	/* Store second L1D line. */
 EX:	{ sw r0, r17; addi r0, r0, 4; mvz r9, r16, r13 }/* store(WORD_4) */
 EX:	{ sw r0, r19; addi r0, r0, 4 }                  /* store(WORD_5) */
@@ -404,7 +364,6 @@ EX:	{ sb r0, r3;   addi r0, r0, 1; addi r2, r2, -1 }
 
 .Ldest_is_word_aligned:
 
-#if CHIP_HAS_DWORD_ALIGN()
 EX:	{ andi r8, r0, 63; lwadd_na r6, r1, 4}
 	{ slti_u r9, r2, 64; bz r8, .Ldest_is_L2_line_aligned }
 
@@ -512,26 +471,6 @@ EX:	{ swadd r0, r13, 4; addi r2, r2, -32 }
 	/* Move r1 back to the point where it corresponds to r0. */
 	{ addi r1, r1, -4 }
 
-#else /* !CHIP_HAS_DWORD_ALIGN() */
-
-	/* Compute right/left shift counts and load initial source words. */
-	{ andi r5, r1, -4; andi r3, r1, 3 }
-EX:	{ lw r6, r5; addi r5, r5, 4; shli r3, r3, 3 }
-EX:	{ lw r7, r5; addi r5, r5, 4; sub r4, zero, r3 }
-
-	/* Load and store one word at a time, using shifts and ORs
-	 * to correct for the misaligned src.
-	 */
-.Lcopy_unaligned_src_loop:
-	{ shr r6, r6, r3; shl r8, r7, r4 }
-EX:	{ lw r7, r5; or r8, r8, r6; move r6, r7 }
-EX:	{ sw r0, r8; addi r0, r0, 4; addi r2, r2, -4 }
-	{ addi r5, r5, 4; slti_u r8, r2, 8 }
-	{ bzt r8, .Lcopy_unaligned_src_loop; addi r1, r1, 4 }
-
-	{ bz r2, .Lcopy_unaligned_done }
-#endif /* !CHIP_HAS_DWORD_ALIGN() */
-
 	/* Fall through */
 
 /*
diff --git a/arch/tile/lib/memcpy_tile64.c b/arch/tile/lib/memcpy_tile64.c
deleted file mode 100644
index 0290c22..0000000
--- a/arch/tile/lib/memcpy_tile64.c
+++ /dev/null
@@ -1,280 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#include <linux/string.h>
-#include <linux/smp.h>
-#include <linux/module.h>
-#include <linux/uaccess.h>
-#include <asm/fixmap.h>
-#include <asm/kmap_types.h>
-#include <asm/tlbflush.h>
-#include <hv/hypervisor.h>
-#include <arch/chip.h>
-
-
-#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
-
-/* Defined in memcpy.S */
-extern unsigned long __memcpy_asm(void *to, const void *from, unsigned long n);
-extern unsigned long __copy_to_user_inatomic_asm(
-	void __user *to, const void *from, unsigned long n);
-extern unsigned long __copy_from_user_inatomic_asm(
-	void *to, const void __user *from, unsigned long n);
-extern unsigned long __copy_from_user_zeroing_asm(
-	void *to, const void __user *from, unsigned long n);
-
-typedef unsigned long (*memcpy_t)(void *, const void *, unsigned long);
-
-/* Size above which to consider TLB games for performance */
-#define LARGE_COPY_CUTOFF 2048
-
-/* Communicate to the simulator what we are trying to do. */
-#define sim_allow_multiple_caching(b) \
-  __insn_mtspr(SPR_SIM_CONTROL, \
-   SIM_CONTROL_ALLOW_MULTIPLE_CACHING | ((b) << _SIM_CONTROL_OPERATOR_BITS))
-
-/*
- * Copy memory by briefly enabling incoherent cacheline-at-a-time mode.
- *
- * We set up our own source and destination PTEs that we fully control.
- * This is the only way to guarantee that we don't race with another
- * thread that is modifying the PTE; we can't afford to try the
- * copy_{to,from}_user() technique of catching the interrupt, since
- * we must run with interrupts disabled to avoid the risk of some
- * other code seeing the incoherent data in our cache.  (Recall that
- * our cache is indexed by PA, so even if the other code doesn't use
- * our kmap_atomic virtual addresses, they'll still hit in cache using
- * the normal VAs that aren't supposed to hit in cache.)
- */
-static void memcpy_multicache(void *dest, const void *source,
-			      pte_t dst_pte, pte_t src_pte, int len)
-{
-	int idx;
-	unsigned long flags, newsrc, newdst;
-	pmd_t *pmdp;
-	pte_t *ptep;
-	int type0, type1;
-	int cpu = smp_processor_id();
-
-	/*
-	 * Disable interrupts so that we don't recurse into memcpy()
-	 * in an interrupt handler, nor accidentally reference
-	 * the PA of the source from an interrupt routine.  Also
-	 * notify the simulator that we're playing games so we don't
-	 * generate spurious coherency warnings.
-	 */
-	local_irq_save(flags);
-	sim_allow_multiple_caching(1);
-
-	/* Set up the new dest mapping */
-	type0 = kmap_atomic_idx_push();
-	idx = FIX_KMAP_BEGIN + (KM_TYPE_NR * cpu) + type0;
-	newdst = __fix_to_virt(idx) + ((unsigned long)dest & (PAGE_SIZE-1));
-	pmdp = pmd_offset(pud_offset(pgd_offset_k(newdst), newdst), newdst);
-	ptep = pte_offset_kernel(pmdp, newdst);
-	if (pte_val(*ptep) != pte_val(dst_pte)) {
-		set_pte(ptep, dst_pte);
-		local_flush_tlb_page(NULL, newdst, PAGE_SIZE);
-	}
-
-	/* Set up the new source mapping */
-	type1 = kmap_atomic_idx_push();
-	idx += (type0 - type1);
-	src_pte = hv_pte_set_nc(src_pte);
-	src_pte = hv_pte_clear_writable(src_pte);  /* be paranoid */
-	newsrc = __fix_to_virt(idx) + ((unsigned long)source & (PAGE_SIZE-1));
-	pmdp = pmd_offset(pud_offset(pgd_offset_k(newsrc), newsrc), newsrc);
-	ptep = pte_offset_kernel(pmdp, newsrc);
-	__set_pte(ptep, src_pte);   /* set_pte() would be confused by this */
-	local_flush_tlb_page(NULL, newsrc, PAGE_SIZE);
-
-	/* Actually move the data. */
-	__memcpy_asm((void *)newdst, (const void *)newsrc, len);
-
-	/*
-	 * Remap the source as locally-cached and not OLOC'ed so that
-	 * we can inval without also invaling the remote cpu's cache.
-	 * This also avoids known errata with inv'ing cacheable oloc data.
-	 */
-	src_pte = hv_pte_set_mode(src_pte, HV_PTE_MODE_CACHE_NO_L3);
-	src_pte = hv_pte_set_writable(src_pte); /* need write access for inv */
-	__set_pte(ptep, src_pte);   /* set_pte() would be confused by this */
-	local_flush_tlb_page(NULL, newsrc, PAGE_SIZE);
-
-	/*
-	 * Do the actual invalidation, covering the full L2 cache line
-	 * at the end since __memcpy_asm() is somewhat aggressive.
-	 */
-	__inv_buffer((void *)newsrc, len);
-
-	/*
-	 * We're done: notify the simulator that all is back to normal,
-	 * and re-enable interrupts and pre-emption.
-	 */
-	kmap_atomic_idx_pop();
-	kmap_atomic_idx_pop();
-	sim_allow_multiple_caching(0);
-	local_irq_restore(flags);
-}
-
-/*
- * Identify large copies from remotely-cached memory, and copy them
- * via memcpy_multicache() if they look good, otherwise fall back
- * to the particular kind of copying passed as the memcpy_t function.
- */
-static unsigned long fast_copy(void *dest, const void *source, int len,
-			       memcpy_t func)
-{
-	int cpu = get_cpu();
-	unsigned long retval;
-
-	/*
-	 * Check if it's big enough to bother with.  We may end up doing a
-	 * small copy via TLB manipulation if we're near a page boundary,
-	 * but presumably we'll make it up when we hit the second page.
-	 */
-	while (len >= LARGE_COPY_CUTOFF) {
-		int copy_size, bytes_left_on_page;
-		pte_t *src_ptep, *dst_ptep;
-		pte_t src_pte, dst_pte;
-		struct page *src_page, *dst_page;
-
-		/* Is the source page oloc'ed to a remote cpu? */
-retry_source:
-		src_ptep = virt_to_pte(current->mm, (unsigned long)source);
-		if (src_ptep == NULL)
-			break;
-		src_pte = *src_ptep;
-		if (!hv_pte_get_present(src_pte) ||
-		    !hv_pte_get_readable(src_pte) ||
-		    hv_pte_get_mode(src_pte) != HV_PTE_MODE_CACHE_TILE_L3)
-			break;
-		if (get_remote_cache_cpu(src_pte) == cpu)
-			break;
-		src_page = pfn_to_page(pte_pfn(src_pte));
-		get_page(src_page);
-		if (pte_val(src_pte) != pte_val(*src_ptep)) {
-			put_page(src_page);
-			goto retry_source;
-		}
-		if (pte_huge(src_pte)) {
-			/* Adjust the PTE to correspond to a small page */
-			int pfn = pte_pfn(src_pte);
-			pfn += (((unsigned long)source & (HPAGE_SIZE-1))
-				>> PAGE_SHIFT);
-			src_pte = pfn_pte(pfn, src_pte);
-			src_pte = pte_mksmall(src_pte);
-		}
-
-		/* Is the destination page writable? */
-retry_dest:
-		dst_ptep = virt_to_pte(current->mm, (unsigned long)dest);
-		if (dst_ptep == NULL) {
-			put_page(src_page);
-			break;
-		}
-		dst_pte = *dst_ptep;
-		if (!hv_pte_get_present(dst_pte) ||
-		    !hv_pte_get_writable(dst_pte)) {
-			put_page(src_page);
-			break;
-		}
-		dst_page = pfn_to_page(pte_pfn(dst_pte));
-		if (dst_page == src_page) {
-			/*
-			 * Source and dest are on the same page; this
-			 * potentially exposes us to incoherence if any
-			 * part of src and dest overlap on a cache line.
-			 * Just give up rather than trying to be precise.
-			 */
-			put_page(src_page);
-			break;
-		}
-		get_page(dst_page);
-		if (pte_val(dst_pte) != pte_val(*dst_ptep)) {
-			put_page(dst_page);
-			goto retry_dest;
-		}
-		if (pte_huge(dst_pte)) {
-			/* Adjust the PTE to correspond to a small page */
-			int pfn = pte_pfn(dst_pte);
-			pfn += (((unsigned long)dest & (HPAGE_SIZE-1))
-				>> PAGE_SHIFT);
-			dst_pte = pfn_pte(pfn, dst_pte);
-			dst_pte = pte_mksmall(dst_pte);
-		}
-
-		/* All looks good: create a cachable PTE and copy from it */
-		copy_size = len;
-		bytes_left_on_page =
-			PAGE_SIZE - (((int)source) & (PAGE_SIZE-1));
-		if (copy_size > bytes_left_on_page)
-			copy_size = bytes_left_on_page;
-		bytes_left_on_page =
-			PAGE_SIZE - (((int)dest) & (PAGE_SIZE-1));
-		if (copy_size > bytes_left_on_page)
-			copy_size = bytes_left_on_page;
-		memcpy_multicache(dest, source, dst_pte, src_pte, copy_size);
-
-		/* Release the pages */
-		put_page(dst_page);
-		put_page(src_page);
-
-		/* Continue on the next page */
-		dest += copy_size;
-		source += copy_size;
-		len -= copy_size;
-	}
-
-	retval = func(dest, source, len);
-	put_cpu();
-	return retval;
-}
-
-void *memcpy(void *to, const void *from, __kernel_size_t n)
-{
-	if (n < LARGE_COPY_CUTOFF)
-		return (void *)__memcpy_asm(to, from, n);
-	else
-		return (void *)fast_copy(to, from, n, __memcpy_asm);
-}
-
-unsigned long __copy_to_user_inatomic(void __user *to, const void *from,
-				      unsigned long n)
-{
-	if (n < LARGE_COPY_CUTOFF)
-		return __copy_to_user_inatomic_asm(to, from, n);
-	else
-		return fast_copy(to, from, n, __copy_to_user_inatomic_asm);
-}
-
-unsigned long __copy_from_user_inatomic(void *to, const void __user *from,
-					unsigned long n)
-{
-	if (n < LARGE_COPY_CUTOFF)
-		return __copy_from_user_inatomic_asm(to, from, n);
-	else
-		return fast_copy(to, from, n, __copy_from_user_inatomic_asm);
-}
-
-unsigned long __copy_from_user_zeroing(void *to, const void __user *from,
-				       unsigned long n)
-{
-	if (n < LARGE_COPY_CUTOFF)
-		return __copy_from_user_zeroing_asm(to, from, n);
-	else
-		return fast_copy(to, from, n, __copy_from_user_zeroing_asm);
-}
-
-#endif /* !CHIP_HAS_COHERENT_LOCAL_CACHE() */
diff --git a/arch/tile/lib/memset_32.c b/arch/tile/lib/memset_32.c
index 9a7837d..2042bfe 100644
--- a/arch/tile/lib/memset_32.c
+++ b/arch/tile/lib/memset_32.c
@@ -23,11 +23,7 @@ void *memset(void *s, int c, size_t n)
 	int n32;
 	uint32_t v16, v32;
 	uint8_t *out8 = s;
-#if !CHIP_HAS_WH64()
-	int ahead32;
-#else
 	int to_align32;
-#endif
 
 	/* Experimentation shows that a trivial tight loop is a win up until
 	 * around a size of 20, where writing a word at a time starts to win.
@@ -58,21 +54,6 @@ void *memset(void *s, int c, size_t n)
 		return s;
 	}
 
-#if !CHIP_HAS_WH64()
-	/* Use a spare issue slot to start prefetching the first cache
-	 * line early. This instruction is free as the store can be buried
-	 * in otherwise idle issue slots doing ALU ops.
-	 */
-	__insn_prefetch(out8);
-
-	/* We prefetch the end so that a short memset that spans two cache
-	 * lines gets some prefetching benefit. Again we believe this is free
-	 * to issue.
-	 */
-	__insn_prefetch(&out8[n - 1]);
-#endif /* !CHIP_HAS_WH64() */
-
-
 	/* Align 'out8'. We know n >= 3 so this won't write past the end. */
 	while (((uintptr_t) out8 & 3) != 0) {
 		*out8++ = c;
@@ -93,90 +74,6 @@ void *memset(void *s, int c, size_t n)
 	/* This must be at least 8 or the following loop doesn't work. */
 #define CACHE_LINE_SIZE_IN_WORDS (CHIP_L2_LINE_SIZE() / 4)
 
-#if !CHIP_HAS_WH64()
-
-	ahead32 = CACHE_LINE_SIZE_IN_WORDS;
-
-	/* We already prefetched the first and last cache lines, so
-	 * we only need to do more prefetching if we are storing
-	 * to more than two cache lines.
-	 */
-	if (n32 > CACHE_LINE_SIZE_IN_WORDS * 2) {
-		int i;
-
-		/* Prefetch the next several cache lines.
-		 * This is the setup code for the software-pipelined
-		 * loop below.
-		 */
-#define MAX_PREFETCH 5
-		ahead32 = n32 & -CACHE_LINE_SIZE_IN_WORDS;
-		if (ahead32 > MAX_PREFETCH * CACHE_LINE_SIZE_IN_WORDS)
-			ahead32 = MAX_PREFETCH * CACHE_LINE_SIZE_IN_WORDS;
-
-		for (i = CACHE_LINE_SIZE_IN_WORDS;
-		     i < ahead32; i += CACHE_LINE_SIZE_IN_WORDS)
-			__insn_prefetch(&out32[i]);
-	}
-
-	if (n32 > ahead32) {
-		while (1) {
-			int j;
-
-			/* Prefetch by reading one word several cache lines
-			 * ahead.  Since loads are non-blocking this will
-			 * cause the full cache line to be read while we are
-			 * finishing earlier cache lines.  Using a store
-			 * here causes microarchitectural performance
-			 * problems where a victimizing store miss goes to
-			 * the head of the retry FIFO and locks the pipe for
-			 * a few cycles.  So a few subsequent stores in this
-			 * loop go into the retry FIFO, and then later
-			 * stores see other stores to the same cache line
-			 * are already in the retry FIFO and themselves go
-			 * into the retry FIFO, filling it up and grinding
-			 * to a halt waiting for the original miss to be
-			 * satisfied.
-			 */
-			__insn_prefetch(&out32[ahead32]);
-
-#if CACHE_LINE_SIZE_IN_WORDS % 4 != 0
-#error "Unhandled CACHE_LINE_SIZE_IN_WORDS"
-#endif
-
-			n32 -= CACHE_LINE_SIZE_IN_WORDS;
-
-			/* Save icache space by only partially unrolling
-			 * this loop.
-			 */
-			for (j = CACHE_LINE_SIZE_IN_WORDS / 4; j > 0; j--) {
-				*out32++ = v32;
-				*out32++ = v32;
-				*out32++ = v32;
-				*out32++ = v32;
-			}
-
-			/* To save compiled code size, reuse this loop even
-			 * when we run out of prefetching to do by dropping
-			 * ahead32 down.
-			 */
-			if (n32 <= ahead32) {
-				/* Not even a full cache line left,
-				 * so stop now.
-				 */
-				if (n32 < CACHE_LINE_SIZE_IN_WORDS)
-					break;
-
-				/* Choose a small enough value that we don't
-				 * prefetch past the end.  There's no sense
-				 * in touching cache lines we don't have to.
-				 */
-				ahead32 = CACHE_LINE_SIZE_IN_WORDS - 1;
-			}
-		}
-	}
-
-#else /* CHIP_HAS_WH64() */
-
 	/* Determine how many words we need to emit before the 'out32'
 	 * pointer becomes aligned modulo the cache line size.
 	 */
@@ -233,8 +130,6 @@ void *memset(void *s, int c, size_t n)
 		n32 &= CACHE_LINE_SIZE_IN_WORDS - 1;
 	}
 
-#endif /* CHIP_HAS_WH64() */
-
 	/* Now handle any leftover values. */
 	if (n32 != 0) {
 		do {
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 39c48cb..111d5a9 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -466,28 +466,15 @@ good_area:
 		}
 	}
 
-#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
-	/*
-	 * If this was an asynchronous fault,
-	 * restart the appropriate engine.
-	 */
-	switch (fault_num) {
 #if CHIP_HAS_TILE_DMA()
+	/* If this was a DMA TLB fault, restart the DMA engine. */
+	switch (fault_num) {
 	case INT_DMATLB_MISS:
 	case INT_DMATLB_MISS_DWNCL:
 	case INT_DMATLB_ACCESS:
 	case INT_DMATLB_ACCESS_DWNCL:
 		__insn_mtspr(SPR_DMA_CTR, SPR_DMA_CTR__REQUEST_MASK);
 		break;
-#endif
-#if CHIP_HAS_SN_PROC()
-	case INT_SNITLB_MISS:
-	case INT_SNITLB_MISS_DWNCL:
-		__insn_mtspr(SPR_SNCTL,
-			     __insn_mfspr(SPR_SNCTL) &
-			     ~SPR_SNCTL__FRZPROC_MASK);
-		break;
-#endif
 	}
 #endif
 
@@ -804,10 +791,6 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 	case INT_DMATLB_MISS:
 	case INT_DMATLB_MISS_DWNCL:
 #endif
-#if CHIP_HAS_SN_PROC()
-	case INT_SNITLB_MISS:
-	case INT_SNITLB_MISS_DWNCL:
-#endif
 		is_page_fault = 1;
 		break;
 
@@ -823,7 +806,7 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 		panic("Bad fault number %d in do_page_fault", fault_num);
 	}
 
-#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
+#if CHIP_HAS_TILE_DMA()
 	if (!user_mode(regs)) {
 		struct async_tlb *async;
 		switch (fault_num) {
@@ -835,12 +818,6 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 			async = &current->thread.dma_async_tlb;
 			break;
 #endif
-#if CHIP_HAS_SN_PROC()
-		case INT_SNITLB_MISS:
-		case INT_SNITLB_MISS_DWNCL:
-			async = &current->thread.sn_async_tlb;
-			break;
-#endif
 		default:
 			async = NULL;
 		}
@@ -873,14 +850,22 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
 }
 
 
-#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
+#if CHIP_HAS_TILE_DMA()
 /*
- * Check an async_tlb structure to see if a deferred fault is waiting,
- * and if so pass it to the page-fault code.
+ * This routine effectively re-issues asynchronous page faults
+ * when we are returning to user space.
  */
-static void handle_async_page_fault(struct pt_regs *regs,
-				    struct async_tlb *async)
+void do_async_page_fault(struct pt_regs *regs)
 {
+	struct async_tlb *async = &current->thread.dma_async_tlb;
+
+	/*
+	 * Clear thread flag early.  If we re-interrupt while processing
+	 * code here, we will reset it and recall this routine before
+	 * returning to user space.
+	 */
+	clear_thread_flag(TIF_ASYNC_TLB);
+
 	if (async->fault_num) {
 		/*
 		 * Clear async->fault_num before calling the page-fault
@@ -894,28 +879,7 @@ static void handle_async_page_fault(struct pt_regs *regs,
 				  async->address, async->is_write);
 	}
 }
-
-/*
- * This routine effectively re-issues asynchronous page faults
- * when we are returning to user space.
- */
-void do_async_page_fault(struct pt_regs *regs)
-{
-	/*
-	 * Clear thread flag early.  If we re-interrupt while processing
-	 * code here, we will reset it and recall this routine before
-	 * returning to user space.
-	 */
-	clear_thread_flag(TIF_ASYNC_TLB);
-
-#if CHIP_HAS_TILE_DMA()
-	handle_async_page_fault(regs, &current->thread.dma_async_tlb);
-#endif
-#if CHIP_HAS_SN_PROC()
-	handle_async_page_fault(regs, &current->thread.sn_async_tlb);
-#endif
-}
-#endif /* CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC() */
+#endif /* CHIP_HAS_TILE_DMA() */
 
 
 void vmalloc_sync_all(void)
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index e3ee55b..004ba56 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -43,12 +43,9 @@
 #include "migrate.h"
 
 
-#if CHIP_HAS_COHERENT_LOCAL_CACHE()
-
 /*
  * The noallocl2 option suppresses all use of the L2 cache to cache
- * locally from a remote home.  There's no point in using it if we
- * don't have coherent local caching, though.
+ * locally from a remote home.
  */
 static int __write_once noallocl2;
 static int __init set_noallocl2(char *str)
@@ -58,12 +55,6 @@ static int __init set_noallocl2(char *str)
 }
 early_param("noallocl2", set_noallocl2);
 
-#else
-
-#define noallocl2 0
-
-#endif
-
 
 /*
  * Update the irq_stat for cpus that we are going to interrupt
@@ -265,10 +256,8 @@ static int pte_to_home(pte_t pte)
 		return PAGE_HOME_INCOHERENT;
 	case HV_PTE_MODE_UNCACHED:
 		return PAGE_HOME_UNCACHED;
-#if CHIP_HAS_CBOX_HOME_MAP()
 	case HV_PTE_MODE_CACHE_HASH_L3:
 		return PAGE_HOME_HASH;
-#endif
 	}
 	panic("Bad PTE %#llx\n", pte.val);
 }
@@ -325,20 +314,16 @@ pte_t pte_set_home(pte_t pte, int home)
 						      HV_PTE_MODE_CACHE_NO_L3);
 			}
 		} else
-#if CHIP_HAS_CBOX_HOME_MAP()
 		if (hash_default)
 			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_HASH_L3);
 		else
-#endif
 			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_NO_L3);
 		pte = hv_pte_set_nc(pte);
 		break;
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 	case PAGE_HOME_HASH:
 		pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_HASH_L3);
 		break;
-#endif
 
 	default:
 		BUG_ON(home < 0 || home >= NR_CPUS ||
@@ -348,7 +333,6 @@ pte_t pte_set_home(pte_t pte, int home)
 		break;
 	}
 
-#if CHIP_HAS_NC_AND_NOALLOC_BITS()
 	if (noallocl2)
 		pte = hv_pte_set_no_alloc_l2(pte);
 
@@ -357,7 +341,6 @@ pte_t pte_set_home(pte_t pte, int home)
 	    hv_pte_get_mode(pte) == HV_PTE_MODE_CACHE_NO_L3) {
 		pte = hv_pte_set_mode(pte, HV_PTE_MODE_UNCACHED);
 	}
-#endif
 
 	/* Checking this case here gives a better panic than from the hv. */
 	BUG_ON(hv_pte_get_mode(pte) == 0);
@@ -373,16 +356,10 @@ EXPORT_SYMBOL(pte_set_home);
  * so they're not suitable for anything but infrequent use.
  */
 
-#if CHIP_HAS_CBOX_HOME_MAP()
-static inline int initial_page_home(void) { return PAGE_HOME_HASH; }
-#else
-static inline int initial_page_home(void) { return 0; }
-#endif
-
 int page_home(struct page *page)
 {
 	if (PageHighMem(page)) {
-		return initial_page_home();
+		return PAGE_HOME_HASH;
 	} else {
 		unsigned long kva = (unsigned long)page_address(page);
 		return pte_to_home(*virt_to_kpte(kva));
@@ -438,7 +415,7 @@ struct page *homecache_alloc_pages_node(int nid, gfp_t gfp_mask,
 void __homecache_free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page)) {
-		homecache_change_page_home(page, order, initial_page_home());
+		homecache_change_page_home(page, order, PAGE_HOME_HASH);
 		if (order == 0) {
 			free_hot_cold_page(page, 0);
 		} else {
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index c8f58c1..22e41cf 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -106,10 +106,8 @@ pte_t *get_prealloc_pte(unsigned long pfn)
  */
 static int initial_heap_home(void)
 {
-#if CHIP_HAS_CBOX_HOME_MAP()
 	if (hash_default)
 		return PAGE_HOME_HASH;
-#endif
 	return smp_processor_id();
 }
 
@@ -190,14 +188,11 @@ static void __init page_table_range_init(unsigned long start,
 }
 
 
-#if CHIP_HAS_CBOX_HOME_MAP()
-
 static int __initdata ktext_hash = 1;  /* .text pages */
 static int __initdata kdata_hash = 1;  /* .data and .bss pages */
 int __write_once hash_default = 1;     /* kernel allocator pages */
 EXPORT_SYMBOL(hash_default);
 int __write_once kstack_hash = 1;      /* if no homecaching, use h4h */
-#endif /* CHIP_HAS_CBOX_HOME_MAP */
 
 /*
  * CPUs to use to for striping the pages of kernel data.  If hash-for-home
@@ -215,14 +210,12 @@ int __write_once kdata_huge;       /* if no homecaching, small pages */
 static pgprot_t __init construct_pgprot(pgprot_t prot, int home)
 {
 	prot = pte_set_home(prot, home);
-#if CHIP_HAS_CBOX_HOME_MAP()
 	if (home == PAGE_HOME_IMMUTABLE) {
 		if (ktext_hash)
 			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_HASH_L3);
 		else
 			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_NO_L3);
 	}
-#endif
 	return prot;
 }
 
@@ -236,20 +229,15 @@ static pgprot_t __init init_pgprot(ulong address)
 	unsigned long page;
 	enum { CODE_DELTA = MEM_SV_START - PAGE_OFFSET };
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 	/* For kdata=huge, everything is just hash-for-home. */
 	if (kdata_huge)
 		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
-#endif
 
 	/* We map the aliased pages of permanent text inaccessible. */
 	if (address < (ulong) _sinittext - CODE_DELTA)
 		return PAGE_NONE;
 
-	/*
-	 * We map read-only data non-coherent for performance.  We could
-	 * use neighborhood caching on TILE64, but it's not clear it's a win.
-	 */
+	/* We map read-only data non-coherent for performance. */
 	if ((address >= (ulong) __start_rodata &&
 	     address < (ulong) __end_rodata) ||
 	    address == (ulong) empty_zero_page) {
@@ -257,12 +245,10 @@ static pgprot_t __init init_pgprot(ulong address)
 	}
 
 #ifndef __tilegx__
-#if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
 	/* Force the atomic_locks[] array page to be hash-for-home. */
 	if (address == (ulong) atomic_locks)
 		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
 #endif
-#endif
 
 	/*
 	 * Everything else that isn't data or bss is heap, so mark it
@@ -280,11 +266,9 @@ static pgprot_t __init init_pgprot(ulong address)
 	if (address >= (ulong) _end || address < (ulong) _einitdata)
 		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 	/* Use hash-for-home if requested for data/bss. */
 	if (kdata_hash)
 		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
-#endif
 
 	/*
 	 * Make the w1data homed like heap to start with, to avoid
@@ -311,11 +295,9 @@ static pgprot_t __init init_pgprot(ulong address)
 		if (page == (ulong)empty_zero_page)
 			continue;
 #ifndef __tilegx__
-#if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
 		if (page == (ulong)atomic_locks)
 			continue;
 #endif
-#endif
 		cpu = cpumask_next(cpu, &kdata_mask);
 		if (cpu == NR_CPUS)
 			cpu = cpumask_first(&kdata_mask);
@@ -358,7 +340,7 @@ static int __init setup_ktext(char *str)
 
 	ktext_arg_seen = 1;
 
-	/* Default setting on Tile64: use a huge page */
+	/* Default setting: use a huge page */
 	if (strcmp(str, "huge") == 0)
 		pr_info("ktext: using one huge locally cached page\n");
 
@@ -404,10 +386,8 @@ static inline pgprot_t ktext_set_nocache(pgprot_t prot)
 {
 	if (!ktext_nocache)
 		prot = hv_pte_set_nc(prot);
-#if CHIP_HAS_NC_AND_NOALLOC_BITS()
 	else
 		prot = hv_pte_set_no_alloc_l2(prot);
-#endif
 	return prot;
 }
 
@@ -440,7 +420,6 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 	struct cpumask kstripe_mask;
 	int rc, i;
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 	if (ktext_arg_seen && ktext_hash) {
 		pr_warning("warning: \"ktext\" boot argument ignored"
 			   " if \"kcache_hash\" sets up text hash-for-home\n");
@@ -457,7 +436,6 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 			  " kcache_hash=all or =allbutstack\n");
 		kdata_huge = 0;
 	}
-#endif
 
 	/*
 	 * Set up a mask for cpus to use for kernel striping.
@@ -585,13 +563,11 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 	} else {
 		pte_t pteval = pfn_pte(0, PAGE_KERNEL_EXEC);
 		pteval = pte_mkhuge(pteval);
-#if CHIP_HAS_CBOX_HOME_MAP()
 		if (ktext_hash) {
 			pteval = hv_pte_set_mode(pteval,
 						 HV_PTE_MODE_CACHE_HASH_L3);
 			pteval = ktext_set_nocache(pteval);
 		} else
-#endif /* CHIP_HAS_CBOX_HOME_MAP() */
 		if (cpumask_weight(&ktext_mask) == 1) {
 			pteval = set_remote_cache_cpu(pteval,
 					      cpumask_first(&ktext_mask));
@@ -938,26 +914,6 @@ void __init pgtable_cache_init(void)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
 
-#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
-/*
- * The __w1data area holds data that is only written during initialization,
- * and is read-only and thus freely cacheable thereafter.  Fix the page
- * table entries that cover that region accordingly.
- */
-static void mark_w1data_ro(void)
-{
-	/* Loop over page table entries */
-	unsigned long addr = (unsigned long)__w1data_begin;
-	BUG_ON((addr & (PAGE_SIZE-1)) != 0);
-	for (; addr <= (unsigned long)__w1data_end - 1; addr += PAGE_SIZE) {
-		unsigned long pfn = kaddr_to_pfn((void *)addr);
-		pte_t *ptep = virt_to_kpte(addr);
-		BUG_ON(pte_huge(*ptep));   /* not relevant for kdata_huge */
-		set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, PAGE_KERNEL_RO));
-	}
-}
-#endif
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static long __write_once initfree;
 #else
@@ -1026,10 +982,7 @@ void free_initmem(void)
 	/*
 	 * Evict the dirty initdata on the boot cpu, evict the w1data
 	 * wherever it's homed, and evict all the init code everywhere.
-	 * We are guaranteed that no one will touch the init pages any
-	 * more, and although other cpus may be touching the w1data,
-	 * we only actually change the caching on tile64, which won't
-	 * be keeping local copies in the other tiles' caches anyway.
+	 * We are guaranteed that no one will touch the init pages any more.
 	 */
 	homecache_evict(&cpu_cacheable_map);
 
@@ -1045,21 +998,6 @@ void free_initmem(void)
 	free_init_pages("unused kernel text",
 			(unsigned long)_sinittext - text_delta,
 			(unsigned long)_einittext - text_delta);
-
-#if !CHIP_HAS_COHERENT_LOCAL_CACHE()
-	/*
-	 * Upgrade the .w1data section to globally cached.
-	 * We don't do this on tilepro, since the cache architecture
-	 * pretty much makes it irrelevant, and in any case we end
-	 * up having racing issues with other tiles that may touch
-	 * the data after we flush the cache but before we update
-	 * the PTEs and flush the TLBs, causing sharer shootdowns
-	 * later.  Even though this is to clean data, it seems like
-	 * an unnecessary complication.
-	 */
-	mark_w1data_ro();
-#endif
-
 	/* Do a global TLB flush so everyone sees the changes. */
 	flush_tlb_all();
 }
-- 
1.8.3.1

