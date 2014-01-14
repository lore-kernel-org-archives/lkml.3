Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaANOOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:14:15 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65121 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaANOOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:14:14 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v2 0/5] enhance DMA CMA on x86
Date: Tue, 14 Jan 2014 23:13:45 +0900
Message-Id: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enhances the DMA Contiguous Memory Allocator on x86.

Currently the DMA CMA is only supported with pci-nommu dma_map_ops
and furthermore it can't be enabled on x86_64.  But I would like to
allocate big contiguous memory with dma_alloc_coherent() and tell it
to the device that requires it, regardless of which dma mapping
implementation is actually used in the system.

So this makes it work with swiotlb and intel-iommu dma_map_ops, too.
And this also extends "cma=" kernel parameter to specify placement
constraint by the physical address range of memory allocations.  For
example, CMA allocates memory below 4GB by "cma=64M@0-4G", it is
required for the devices only supporting 32-bit addressing on 64-bit
systems without iommu.

* Changes from v1
- fix dma_alloc_coherent() with __GFP_ZERO
- add placement specifier for "cma=" kernel parameter

Akinobu Mita (5):
  x86: make dma_alloc_coherent() return zeroed memory if CMA is enabled
  x86: enable DMA CMA with swiotlb
  intel-iommu: integrate DMA CMA
  memblock: introduce memblock_alloc_range()
  cma: add placement specifier for "cma=" kernel parameter

 Documentation/kernel-parameters.txt |  7 +++++--
 arch/x86/Kconfig                    |  2 +-
 arch/x86/include/asm/swiotlb.h      |  7 +++++++
 arch/x86/kernel/amd_gart_64.c       |  2 +-
 arch/x86/kernel/pci-dma.c           |  3 +--
 arch/x86/kernel/pci-swiotlb.c       |  9 +++++---
 arch/x86/pci/sta2x11-fixup.c        |  6 ++----
 drivers/base/dma-contiguous.c       | 42 ++++++++++++++++++++++++++++---------
 drivers/iommu/intel-iommu.c         | 32 +++++++++++++++++++++-------
 include/linux/dma-contiguous.h      |  9 +++++---
 include/linux/memblock.h            |  2 ++
 include/linux/swiotlb.h             |  2 ++
 lib/swiotlb.c                       |  2 +-
 mm/memblock.c                       | 27 +++++++++++++++++-------
 14 files changed, 110 insertions(+), 42 deletions(-)

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
-- 
1.8.3.2

