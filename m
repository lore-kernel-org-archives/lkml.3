Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab3CJGqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:46:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18963 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3CJGqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:46:05 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/20] x86, ACPI, numa: Parse numa info early
Date: Sat,  9 Mar 2013 22:44:27 -0800
Message-Id: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One commit that tried to parse SRAT early get reverted before v3.9-rc1.

| commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
| Author: Tang Chen <tangchen@cn.fujitsu.com>
| Date:   Fri Feb 22 16:33:44 2013 -0800
|
|    acpi, memory-hotplug: parse SRAT before memblock is ready

It broke several things, like acpi override and fall back path etc.

This patchset is clean implementation that will parse numa info early.
1. keep the acpi table initrd override working by split finding with copying.
   finding is done at head_32.S and head64.c stage,
        in head_32.S, initrd is accessed in 32bit flat mode with phys addr.
        in head64.c, initrd is accessed via kernel low mapping address
        with help of #PF set page table.
   copying is done with early_ioremap just after memblock is setup.
2. keep fallback path working. numaq and ACPI and amd_nmua and dummy.
   seperate initmem_init to two stages.
   early_initmem_init will only extract numa info early into numa_meminfo.
   initmem_init will keep slit and emulation handling.
3. keep other old code flow untouched like relocate_initrd and initmem_init.
   early_initmem_init will take old init_mem_mapping position.
   it call early_x86_numa_init and init_mem_mapping for every nodes.
   For 64bit, we avoid having size limit on initrd, as relocate_initrd
   is still after init_mem_mapping for all memory.
4. last patch will try to put page table on local node, so that memory
   hotplug will be happy.

In short, early_initmem_init will parse numa info early and call
init_mem_mapping to set page table for every nodes's mem.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

and it is based on today's Linus tree.

-v2: Address tj's review and split patches to small ones.

Thanks

Yinghai

Yinghai Lu (20):
  x86: Change get_ramdisk_image() to global
  x86, microcode: Use common get_ramdisk_image()
  x86, ACPI, mm: Kill max_low_pfn_mapped
  x86, ACPI: Increase override tables number limit
  x86, ACPI: Split acpi_initrd_override to find/copy two functions
  x86, ACPI: Store override acpi tables phys addr in cpio files info array
  x86, ACPI: Make acpi_initrd_override_find work with 32bit flat mode
  x86, ACPI: Find acpi tables in initrd early from head_32.S/head64.c
  x86, mm, numa: Move two functions calling on successful path later
  x86, mm, numa: Call numa_meminfo_cover_memory() checking early
  x86, mm, numa: Move node_map_pfn alignment() to x86
  x86, mm, numa: Use numa_meminfo to check node_map_pfn alignment
  x86, mm, numa: Set memblock nid later
  x86, mm, numa: Move node_possible_map setting later
  x86, mm, numa: Move emulation handling down.
  x86, ACPI, numa, ia64: split SLIT handling out
  x86, mm, numa: Add early_initmem_init() stub
  x86, mm: Parse numa info early
  x86, mm: Make init_mem_mapping be able to be called several times
  x86, mm, numa: Put pagetable on local node ram for 64bit

 arch/ia64/kernel/setup.c                |    4 +-
 arch/x86/include/asm/acpi.h             |    3 +-
 arch/x86/include/asm/page_types.h       |    2 +-
 arch/x86/include/asm/pgtable.h          |    2 +-
 arch/x86/include/asm/setup.h            |    9 ++
 arch/x86/kernel/head64.c                |    2 +
 arch/x86/kernel/head_32.S               |    4 +
 arch/x86/kernel/microcode_intel_early.c |    8 +-
 arch/x86/kernel/setup.c                 |   86 ++++++-----
 arch/x86/mm/init.c                      |   88 +++++++-----
 arch/x86/mm/numa.c                      |  240 ++++++++++++++++++++++++-------
 arch/x86/mm/numa_emulation.c            |    2 +-
 arch/x86/mm/numa_internal.h             |    2 +
 arch/x86/mm/srat.c                      |   11 +-
 drivers/acpi/numa.c                     |   13 +-
 drivers/acpi/osl.c                      |  134 +++++++++++------
 include/linux/acpi.h                    |   20 +--
 include/linux/mm.h                      |    3 -
 mm/page_alloc.c                         |   52 +------
 19 files changed, 445 insertions(+), 240 deletions(-)

-- 
1.7.10.4

