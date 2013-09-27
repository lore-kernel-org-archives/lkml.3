Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3I0QJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:09:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8729 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3I0QJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:09:54 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="55582211"
Date: Fri, 27 Sep 2013 17:09:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v6 0/19] enable swiotlb-xen on arm and arm64
Message-ID: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series enables xen-swiotlb on arm and arm64.

Considering that all guests, including dom0, run on xen on arm with
second stage translation enabled, it follows that without an IOMMU no
guests could actually drive the hardware.

The solution for platforms without an IOMMU is to use swiotlb-xen,
adapted to autotranslate guests. swiotlb-xen provides a set of dma_ops
that can be used by Linux to setup a contiguous buffer in stage-2
addresses and use it for dma operations.
Basically Linux asks Xen to make a buffer contiguous and gets the
machine address for it. This buffer is going to be used by lib/swiotlb.c
to allocate bounce buffers.

In few cases we can actually avoid going through the swiotlb bounce
buffer: if a dma request involves only a single page we can try to pin
the page passed in as an argument and return its machine address.
In order to do this we need to keep track of the machine to physical
mappings of the pinned pages.
Since this approach is preferable to bouncing all the times but it only
works with single pages, we force biovec requests not to be merged.

Cheers,

Stefano


Changes in v6:
- check for dev->dma_mask being NULL in dma_capable;
- update the comments and the hypercalls structures;
- add a xen_dma_info entry to the rbtree in xen_swiotlb_alloc_coherent
to keep track of the new mapping. Free the entry in xen_swiotlb_free_coherent;
- rename xen_dma_seg to dma_info in xen_swiotlb_alloc/free_coherent to
avoid confusions;
- introduce and export xen_dma_ops;
- call xen_mm_init from as arch_initcall;
- call __get_dma_ops to get the native dma_ops pointer on arm;
- do not merge biovecs;
- add single page optimization: pin the page rather than bouncing.

Changes in v5:
- dropped the first two patches, already in the Xen tree;
- implement dma_mark_clean using dmac_flush_range on arm;
- add "arm64: define DMA_ERROR_CODE"
- better comment for XENMEM_exchange_and_pin return codes;
- fix xen_dma_add_entry error path;
- remove the spin_lock: the red-black tree is not modified at run time;
- add "swiotlb-xen: introduce xen_swiotlb_set_dma_mask";
- add "xen: introduce xen_alloc/free_coherent_pages";
- add "swiotlb-xen: use xen_alloc/free_coherent_pages";
- add "swiotlb: don't assume that io_tlb_start-io_tlb_end is coherent".

Changes in v4:
- rename XENMEM_get_dma_buf to XENMEM_exchange_and_pin;
- rename XENMEM_put_dma_buf to XENMEM_unpin;
- improve the documentation of the new hypercalls;
- add a note about out.address_bits for XENMEM_exchange;
- code style fixes;
- add err_out label in xen_dma_add_entry;
- remove INVALID_ADDRESS, use DMA_ERROR_CODE instead;
- add in-code comments regarding the usage of xen_dma_seg[0].dma_addr.

Changes in v3:
- add a patch to compile SWIOTLB without CONFIG_NEED_SG_DMA_LENGTH;
- add a patch to compile SWIOTLB_XEN without CONFIG_NEED_SG_DMA_LENGTH;
- arm/dma_capable: do not treat dma_mask as a limit;
- arm/dmabounce: keep using arm_dma_ops;
- add missing __init in xen_early_init declaration;
- many code style and name changes in swiotlb-xen.c;
- improve error checks in xen_dma_add_entry;
- warn on XENMEM_put_dma_buf failures.

Changes in v2:
- fixed a couple of errors in xen_bus_to_phys, xen_phys_to_bus and
xen_swiotlb_fixup.



Julien Grall (1):
      ASoC: Samsung: Rename dma_ops by samsung_dma_ops

Stefano Stabellini (18):
      arm: make SWIOTLB available
      arm64: define DMA_ERROR_CODE
      xen: introduce XENMEM_exchange_and_pin and XENMEM_unpin
      xen: make xen_create_contiguous_region return the dma address
      swiotlb-xen: support autotranslate guests
      xen/arm,arm64: enable SWIOTLB_XEN
      swiotlb-xen: introduce xen_swiotlb_set_dma_mask
      arm/xen: get_dma_ops: return xen_dma_ops if we are running on Xen
      arm64/xen: get_dma_ops: return xen_dma_ops if we are running on Xen
      xen: introduce xen_alloc/free_coherent_pages
      swiotlb-xen: use xen_alloc/free_coherent_pages
      swiotlb: don't assume that io_tlb_start-io_tlb_end is coherent
      swiotlb: print a warning when the swiotlb is full
      swiotlb-xen: call dma_capable only if dev->dma_mask is allocated
      arm,arm64: do not always merge biovec if we are running on Xen
      xen: introduce XENMEM_pin
      swiotlb-xen: introduce a rbtree to track phys to bus mappings
      swiotlb-xen: instead of bouncing on the swiotlb, pin single pages

 arch/arm/Kconfig                           |    7 +
 arch/arm/include/asm/dma-mapping.h         |   50 +++-
 arch/arm/include/asm/io.h                  |    8 +
 arch/arm/include/asm/xen/hypervisor.h      |    2 +
 arch/arm/include/asm/xen/page-coherent.h   |   22 ++
 arch/arm/include/asm/xen/page.h            |    2 +
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/mm.c                          |  137 ++++++++
 arch/arm64/Kconfig                         |    1 +
 arch/arm64/include/asm/dma-mapping.h       |   14 +-
 arch/arm64/include/asm/io.h                |    9 +
 arch/arm64/include/asm/xen/page-coherent.h |   24 ++
 arch/arm64/xen/Makefile                    |    2 +-
 arch/ia64/include/asm/xen/page-coherent.h  |   24 ++
 arch/x86/include/asm/xen/page-coherent.h   |   24 ++
 arch/x86/xen/mmu.c                         |   18 +-
 drivers/xen/Kconfig                        |    1 -
 drivers/xen/biomerge.c                     |    4 +-
 drivers/xen/swiotlb-xen.c                  |  464 +++++++++++++++++++++++++---
 include/xen/interface/memory.h             |   83 +++++
 include/xen/swiotlb-xen.h                  |    2 +
 include/xen/xen-ops.h                      |    8 +-
 lib/swiotlb.c                              |   14 +-
 sound/soc/samsung/dma.c                    |    4 +-
 24 files changed, 870 insertions(+), 56 deletions(-)
 create mode 100644 arch/arm/include/asm/xen/page-coherent.h
 create mode 100644 arch/arm/xen/mm.c
 create mode 100644 arch/arm64/include/asm/xen/page-coherent.h
 create mode 100644 arch/ia64/include/asm/xen/page-coherent.h
 create mode 100644 arch/x86/include/asm/xen/page-coherent.h

git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git swiotlb-xen-6
