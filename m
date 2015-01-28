Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbbA2Bme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:42:34 -0500
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:37156 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755108AbbA2Bmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:42:33 -0500
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dvhart@infradead.org, andy.shevchenko@gmail.com,
        boon.leong.ong@intel.com, linux-kernel@vger.kernel.org
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH v6 0/2] x86: Add IMR support to Quark/Galileo
Date: Wed, 28 Jan 2015 18:36:24 +0000
Message-Id: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for Isolated Memory Regions to the kernel.

Quark SoC X1000 contains a set of registers called Isolated Memory Regions.
IMRs provide fine grained memory access control to various system agents
within the SoC such as CPU SMM/non-SMM mode, PCIe virtual channels, CPU
snoop cycles, eSRAM flush cycles and the RMU. In simple terms, IMRs provide
a mechanism to protect memory regions from unwarranted access by system
agents that should not have access to that memory.

IMRs support a lock bit. Once a lock bit is set for an individual IMR it is
not possible to tear down that IMR without performing a cold boot of the
system. IMRs support reporting of violations. The SoC system can be
configured to reboot immediately when an IMR violation has taken place.
Immediate reboot of the system on IMR violation is recommended and is
currently how Quark BIOS configures the system.

An example of IMRs in use is given with Arduino compatiable Galileo boards
which ship with an IMR around the ACPI runtime services memory. If a DMA
read/write cycle were to occur to this region of memory this would trigger
the IMR violation mechansim.

As part of the IMR init code all unlocked IMRs are removed to ensure the
EFI memory map and IMR memory map are consistent. This is necessary since at
various stages during the boot of Quark systems firmware and second stage
bootloader will place unlocked IMRs around various assets in memory, with
the expectation that subsequent phases of boot will tear-down unlocked/stale
IMRs before proceeding. The kernel needs to tear-down unlocked IMRs placed
around the boot params structure and compressed kernel in memory. Without
doing so DMA addresses given out by the kernel to DMA capable hardware runs
the risk of triggering an IMR fault when DMA happens to those addresses.
As a result any unlocked IMR must be torn down by the kernel early in the
boot process to sanitize the memory map. 

As an additional protection to the run-time kernel from unwarranted memory
transactions an IMR is placed around the kernel's .text and .rodata
sections. 

Changes since v5:
 - Full stops
   Added to all comments - including one-liners.
   Andy Shevchenko
 - %zu and %zx
   Used to print size_t variables
   Andy Shevchenko
 - imr_selftest
   Split into seperate module
   Andy Shevchenko
Changes since v4:
 - Quark added as a platform in a separate patch to IMRs
   Andy Shevchenko
 - imr_read
   Add extra reg++ to end of read for consistency
   Andy Shevchenko
 - ret
   Declarations of return variable moved to end of each declaration block
   Andy Shevchenko
 - Parameters passed to debugfs hooks
   Andy Shevchenko
 - struct imr_dev *idev = &imr_dev;
   Used globally for entry point functions
   Andy Shevchenko/Bryan O'Donoghue
 - struct imr_dev * passed to static functions
   Andy Shevchenko/Bryan O'Donoghue
 - Comment in imr_fixup_memmap
   Paried down and made more readable
   Andy Shevchenko
 - imr_fixup_memmap/imr_selftest
   phys_addr_t used for base
   Andy Shevchenko
 - phys_addr_t/size_t
   Supplemented globally in place of unsigned long where appropriate
   Bryan O'Donoghue
 - print routines to take %pa globally
   In place of pr_info("0x%08lx\n", (unsigned long)some_phs_addr_t_variable);
   Andy Shevchenko
 - debugfs hook moved to after init = true
   Andy Shevchenko

Changes since v3:
 - Remove reference to imr.o in arch/x86/kernel/Makefile
   Bryan O'Donoghue

Changes since v2:
 - Move IMR code to arch/x86/platform/intel-quark/imr.c
   Thomas Gleixner/Darren Hart
 - #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
    Andy Shevchenko
 - ret = iosf_mbi_read()
    Style made consistent in imr_write
    Andy Shevchenko
 - reg++/IMR_NUM_REGS
    Offset used for lock bit in imr_write
    Andy Shevchenko
 - debugfs s->private pointer used
    Andy Shevchenko
 - debugfs
    Conditional compilation defines removed
    Andy Shevchenko
 - debugfs
    Failure to hook debugfs treated as non-fatal
    Andy Shevchenko
 - phys_addr_t
    Updated API to use phys_addr_t in place of unsigned long for base param
    Andy Shevchenko
 - printk
    "KiB" instead of "k"
    Andy Shevchenko
 - imr_enabled
    -> static inline imr_is_enabled
    Ong, Boon Leong/Andy Shevchenko
 - imr_write
    trap final ret from iosf_mbi_write for lock bit in imr_write - bugfix
    Ong, Boon Leong
 - imr_fixup_size
    -> static inline imr_fixup_size
    Ong, Boon Leong
 - imr_address_overlap
    -> imr_address_overlap
    Ong, Boon Leong
 - imr_add_range
    End address in imr_add_range calculated after imr_fixup_size()
    Ong, Boon Leong
 - imr_del_range
    Pass i in place of reg in imr_del_range() - bugfix
    Ong, Boon Leong
 - Add test case
    imr_del_range(-1, addr, size)
    Ong, Boon Leong/Andy Shevchenko
 - Added text "aligned to 1 KiB" removed reference to "4 k"
    Ong, Boon Leong
 - imr_is_enabled
    Definition of enabled updated to be negation of disabled
    Bryan O'Donoghue
 - imr_add_range
    Add check for adding an IMR in the disabled state
    Bryan O'Donoghue
 - Add test case IMR @ invalid address, @0 with rmask/wmask=CPU, @ 0 size 0x800
    Bryan O'Donoghue
 - Add WARN() to failed IMR test in print routine
    Bryan O'Donoghue
 - Update license to Dual BSD/GPL
    Reflect licensing in Intel reference code
    Bryan O'Donoghue

Changes since v1:
 - Galileo platform code
    Removed completely. Policy to tear-down unlocked IMRs and setup IMR
    around kernel .text and .rodata as part of IMR init code.
    Darren Hart/Ong, Boon Leong
 - imr_add/imr_del
    Renamed to imr_add_range and imr_del_range respectively.
    Andy Shevchenko
 - x86_match_cpu
    Used in place of DMI strings specific to Galileo.
    Andy Shevchenko/Ong, Boon Leong
 - Expanded git log definitions of IMRs
    Addition of more descriptive text to deliniate between different IMR
    types.
    Ong, Boon Leong
 - struct imr
    Renamed to struct imr_regs
    Andy Shevchenko/Darren Hart
 - imr_read/imr_write
    Flow reworked flow of register indexing
    Andy Shevchenko
 - debugfs hooks changed
    Andy Shevchenko
 - imr_enabled
    Definition of an enabled IMR updated to include read/write mask values
    present in IMR. Address @ zero and read/write mask in conjunction will
    be the definition of a disabled IMR on X1000 to be consistent with
    firmware both old and current which also defines a disabled IMR this
    way.
    Darren Hart/Ong, Boon Leong
 - Overlapping
    Comment added to code to explain the design decision not to allow IMR
    overlaps.
    Darren Hart/Ong, Boon Leong
 - CONFIG_DEBUG_IMR_SELFTEST
    Automated IMR self test moved from removed Galileo platform code and
    added to IMR init code. Option exists in the kernel hacking section.
    Darren Hart
 - IMR self test
    Expanded to over more scenarios
    Bryan O'Donoghue
 - Remove reference to IMR_ENABLE bit
    Undocumented bit with respect to Quark X1000
    Ong, Boon Leong
 - Expanded kernel IMR to encompass .text and .rodata
    IMR protecting both .text and .rodata as in the same way as .text and
    .rodata are marked read-only in the relevant page-table entries.
    Bryan O'Donoghue
 - Overlap bounds checking
    Moved range checking of overlap into a function
    Andy Shevchenko

Bryan O'Donoghue (2):
  x86: Add Isolated Memory Regions for Quark X1000
  x86, quark: Add Intel Quark platform support

 arch/x86/Kconfig                             |  16 +
 arch/x86/Kconfig.debug                       |  12 +
 arch/x86/include/asm/imr.h                   |  60 +++
 arch/x86/platform/Makefile                   |   1 +
 arch/x86/platform/intel-quark/Makefile       |   2 +
 arch/x86/platform/intel-quark/imr.c          | 616 +++++++++++++++++++++++++++
 arch/x86/platform/intel-quark/imr_selftest.c | 135 ++++++
 drivers/platform/x86/Kconfig                 |  25 ++
 8 files changed, 867 insertions(+)
 create mode 100644 arch/x86/include/asm/imr.h
 create mode 100644 arch/x86/platform/intel-quark/Makefile
 create mode 100644 arch/x86/platform/intel-quark/imr.c
 create mode 100644 arch/x86/platform/intel-quark/imr_selftest.c

-- 
1.9.1

