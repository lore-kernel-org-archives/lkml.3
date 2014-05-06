Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaEFWsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:48:07 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50825 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaEFWsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:48:04 -0400
Subject: [PATCH v2 0/5] Clean up DMA API & IOMMU dma_addr_t usage
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 May 2014 16:48:13 -0600
Message-ID: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought this was going to be a simple doc clarification patch, but
it's suffered a bit of feature creep.

The main point is that the DMA API uses "dma_addr_t" as the type for
addresses to be programmed into devices for doing DMA, but the
documentation sometimes refers to these as "bus addresses" and sometimes as
"physical addresses."  So I tried to use "bus address" consistently.

I added a few comments about what dma_addr_t is.  These are likely the most
controversial changes.  For example:

  A dma_addr_t can hold any valid DMA or bus address for the platform.
  It can be given to a device to use as a DMA source or target, or it
  may appear on the bus when a cpu performs programmed I/O.  A cpu
  cannot reference a dma_addr_t directly because there may be
  translation between its physical address space and the bus address
  space.

  This type can hold any valid DMA or bus address for the platform and
  should be used everywhere you hold a DMA address returned from the DMA
  mapping functions or a bus address read from a device register such as a
  PCI BAR.

I also made minor capitalization, punctuation, and wording changes for
consistency and clarity.

Secondly, dma_declare_coherent_memory() takes two addresses for a region of
memory: a "dma_addr_t bus_addr" and a "dma_addr_t device_addr".  I thought
this was misleading, so the second patch converts "bus_addr" to a
"phys_addr_t phys_addr" since it should be a CPU physical address suitable
for ioremapping.

The third patch fixes up one dma_declare_coherent_memory() caller to
convert a PCI bus address to a CPU physical address (only a theoretical
issue, since they are identical on the affected platform).

Some of the IOMMU API uses dma_addr_t for bus addresses (also known as
IOVAs), but not all of it, so the fourth patch uses dma_addr_t more
consistently.

The last patch is a trivial cleanup of exynos_iommu_ops to be consistent
with other iommu_ops structures.

---

Bjorn Helgaas (5):
      DMA-API: Clarify physical/bus address distinction
      DMA-API: Change dma_declare_coherent_memory() CPU address to phys_addr_t
      sh/PCI: Pass GAPSPCI_DMA_BASE CPU address to dma_declare_coherent_memory()
      iommu: Use dma_addr_t for IOVA arguments
      iommu/exynos: Remove unnecessary "&" from function pointers


 Documentation/DMA-API-HOWTO.txt          |  122 +++++++++++--------------
 Documentation/DMA-API.txt                |  149 ++++++++++++++++--------------
 Documentation/DMA-ISA-LPC.txt            |    4 -
 arch/sh/drivers/pci/fixups-dreamcast.c   |    8 +-
 drivers/base/dma-coherent.c              |   10 +-
 drivers/base/dma-mapping.c               |    6 +
 drivers/gpu/drm/msm/msm_iommu.c          |    2 
 drivers/infiniband/hw/usnic/usnic_uiom.c |    2 
 drivers/iommu/amd_iommu.c                |    4 -
 drivers/iommu/arm-smmu.c                 |    4 -
 drivers/iommu/exynos-iommu.c             |   18 ++--
 drivers/iommu/intel-iommu.c              |    4 -
 drivers/iommu/iommu.c                    |    6 +
 drivers/iommu/msm_iommu.c                |    6 +
 drivers/iommu/omap-iommu.c               |    4 -
 drivers/iommu/shmobile-iommu.c           |    4 -
 drivers/iommu/tegra-gart.c               |    4 -
 drivers/iommu/tegra-smmu.c               |    4 -
 drivers/remoteproc/remoteproc_core.c     |    2 
 include/asm-generic/dma-coherent.h       |   13 +--
 include/linux/dma-mapping.h              |   14 ++-
 include/linux/iommu.h                    |   16 ++-
 include/linux/types.h                    |    1 
 23 files changed, 208 insertions(+), 199 deletions(-)
