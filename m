Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288Ab3CHE7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:59:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43472 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3CHE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/14] x86, ACPI, numa: Parse numa info early
Date: Thu,  7 Mar 2013 20:58:26 -0800
Message-Id: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
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

It broke several several things, like acpi override and fall back path etc.

This patchset is clean implementation that will parse numa info early.
1. keep the acpi table initrd override working by split finding with copying.
   finding is done at head_32.S and head64.c stage, that mimics microcode updating.
   copying is just after memblock is setup.
2. keep fallback path working. numaq and ACPI and amd_nmua and dummy.
   seperate initmem_init to two stages. early_initmem_init will only extract
   numa info early into numa_meminfo.
3. keep other old code flow untouched like relocate_initrd and initmem_init.
4. last patch will try to put page table on local node, so that memory
   hotplug will be happy.

In short, early_initmem_init will parse numa info early and call
init_mem_mapping to set page table for every nodes's mem.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

and it is based on today's Linus tree that merges x86_urgent.

Tested on x86 32bit non-numa/numa, 64bit non-numa/numa configurations.

Thanks

Yinghai

Yinghai Lu (14):
  x86, ACPI, mm: Kill max_low_pfn_mapped
  x86, ACPI: Split find/copy from acpi_initrd_override
  x86, ACPI: store override acpi tables phys addr
  x86, ACPI: make acpi override finding work with 32bit flat mode
  x86, ACPI: Find acpi tables in initrd early at head_32.S/head64.c
  x86, mm, numa: Move successful path handling code later
  x86, mm, numa: call numa_meminfo_cover_memory() early
  x86, mm, numa: use numa_meminfo to check node_map_pfn alignment
  x86, mm, numa: set memblock nid later
  x86, mm, numa: Move emulation handling down.
  x86, acpi, numa: split SLIT handling out
  x86, mm, numa: Add early_initmem_init() stub
  x86, mm: Parse numa info early
  x86, mm: Put pagetable on local node ram

 arch/x86/include/asm/acpi.h            |    3 +-
 arch/x86/include/asm/page_types.h      |    2 +-
 arch/x86/include/asm/pgtable.h         |    2 +-
 arch/x86/include/asm/setup.h           |    2 +
 arch/x86/kernel/head64.c               |    2 +
 arch/x86/kernel/head_32.S              |    4 +
 arch/x86/kernel/setup.c                |   56 +++++---
 arch/x86/mm/init.c                     |   87 ++++++------
 arch/x86/mm/init_32.c                  |   11 ++
 arch/x86/mm/init_64.c                  |   12 ++
 arch/x86/mm/numa.c                     |  236 +++++++++++++++++++++++++-------
 arch/x86/mm/numa_emulation.c           |    2 +-
 arch/x86/mm/numa_internal.h            |    2 +
 arch/x86/mm/srat.c                     |    8 +-
 drivers/acpi/numa.c                    |   22 ++-
 drivers/acpi/osl.c                     |  122 +++++++++++------
 drivers/gpu/drm/i915/i915_gem_stolen.c |    2 +-
 include/linux/acpi.h                   |   18 +--
 include/linux/mm.h                     |    3 -
 mm/page_alloc.c                        |   52 +------
 20 files changed, 425 insertions(+), 223 deletions(-)

-- 
1.7.10.4

