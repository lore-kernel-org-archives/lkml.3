Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab3AaV7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:59:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51539 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab3AaV7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:59:01 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <sboyd@codeaurora.org>, <will.deacon@arm.com>,
        <paulmck@linux.vnet.ibm.com>, <nico@linaro.org>,
        <catalin.marinas@arm.com>, <marc.zyngier@arm.com>,
        <linus.walleij@linaro.org>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 00/13] ARM LPAE Fixes - Part 1
Date: Thu, 31 Jan 2013 16:58:19 -0500
Message-ID: <1359669512-31276-1-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a repost of the LPAE related changes in preparation for the
introduction of the Keystone sub-architecture.  The original series has now
been split, and this particular series excludes the earlier changes to the
runtime code patching implementation.  Earlier versions of this series can be
found at [1], [2], [3] and [4].

These patches are also available in git:
git://git.kernel.org/pub/scm/linux/kernel/git/cchemparathy/linux-keystone.git upstream/keystone-lpae-v4

[1] http://comments.gmane.org/gmane.linux.kernel/1341497
[2] http://comments.gmane.org/gmane.linux.kernel/1332069
[3] http://comments.gmane.org/gmane.linux.kernel/1356716
[4] http://comments.gmane.org/gmane.linux.kernel/1362529

Series changelog:

[01/13] ARM: LPAE: use signed arithmetic for mask
[02/13] ARM: LPAE: use phys_addr_t in alloc_init_pud()
[03/13] ARM: LPAE: use phys_addr_t in free_memmap()
  (v4)	unchanged from v3
  (v3)	unchanged from v2
  (v2)	unchanged from v1

[04/13] ARM: LPAE: use phys_addr_t for initrd location
  (v4)	unchanged from v3
  (v3)	unchanged from v2
  (v2)	revert to unsigned long for initrd size

[05/13] ARM: LPAE: use phys_addr_t in switch_mm()
  (v4)  collapse shift and or into a single instruction
  (v3)	remove unnecessary handling for !LPAE in proc-v7-3level
  (v2)	use phys_addr_t instead of u64 in switch_mm()
  (v2)	revert on changes to v6 and v7-2level
  (v2)	fix register mapping for big-endian in v7-3level

[06/13] ARM: LPAE: use 64-bit accessors for TTBR registers
  (v4)  remove unnecessary condition code clobber
  (v3)	remove unnecessary condition code clobber
  (v2)	restore comment in cpu_set_reserved_ttbr0()

[07/13] ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for
  (v4)	unchanged from v3
  (v3)	unchanged from v2
  (v2)	unchanged from v1

[08/13] ARM: LPAE: factor out T1SZ and TTBR1 computations
  (v4)  cleanup and move code comments
  (v3)	unchanged from v2
  (v2)	unchanged from v1

[09/13] ARM: LPAE: accomodate >32-bit addresses for page
  (v4)	unchanged from v3
  (v3)	unchanged from v2
  (v2)	apply arch_pgd_shift only on lpae
  (v2)	move arch_pgd_shift definition to asm/memory.h
  (v2)	revert on changes to non-lpae procs
  (v2)	add check to ensure that the pgd physical address is aligned at an
	ARCH_PGD_SHIFT boundary

[10/13] ARM: mm: use physical addresses in highmem sanity
[11/13] ARM: mm: cleanup checks for membank overlap with
[12/13] ARM: mm: clean up membank size limit checks
  (v4)	unchanged from v3
  (v3)	unchanged from v2
  (v2)	unchanged from v1

[13/13] ARM: fix type of PHYS_PFN_OFFSET to unsigned long
  (v4)	introduced here


Cyril Chemparathy (10):
  ARM: LPAE: use signed arithmetic for mask definitions
  ARM: LPAE: use phys_addr_t in switch_mm()
  ARM: LPAE: use 64-bit accessors for TTBR registers
  ARM: LPAE: define ARCH_LOW_ADDRESS_LIMIT for bootmem
  ARM: LPAE: factor out T1SZ and TTBR1 computations
  ARM: LPAE: accomodate >32-bit addresses for page table base
  ARM: mm: use physical addresses in highmem sanity checks
  ARM: mm: cleanup checks for membank overlap with vmalloc area
  ARM: mm: clean up membank size limit checks
  ARM: fix type of PHYS_PFN_OFFSET to unsigned long

Vitaly Andrianov (3):
  ARM: LPAE: use phys_addr_t in alloc_init_pud()
  ARM: LPAE: use phys_addr_t in free_memmap()
  ARM: LPAE: use phys_addr_t for initrd location

 arch/arm/include/asm/memory.h               |   20 +++++++++-
 arch/arm/include/asm/page.h                 |    2 +-
 arch/arm/include/asm/pgtable-3level-hwdef.h |   20 ++++++++++
 arch/arm/include/asm/pgtable-3level.h       |    6 +--
 arch/arm/include/asm/proc-fns.h             |   26 +++++++++----
 arch/arm/kernel/head.S                      |   10 ++---
 arch/arm/kernel/smp.c                       |   11 +++++-
 arch/arm/mm/context.c                       |    9 +----
 arch/arm/mm/init.c                          |   19 +++++-----
 arch/arm/mm/mmu.c                           |   49 +++++++++----------------
 arch/arm/mm/proc-v7-3level.S                |   53 ++++++++++++++-------------
 11 files changed, 132 insertions(+), 93 deletions(-)

-- 
1.7.9.5

