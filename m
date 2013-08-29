Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3H2Sb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:31:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:62560 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3H2SbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:31:24 -0400
X-IronPort-AV: E=Sophos;i="4.89,984,1367971200"; 
   d="scan'208";a="46541627"
Date: Thu, 29 Aug 2013 19:31:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH v5 0/13] enable swiotlb-xen on arm and arm64
Message-ID: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
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


Feedback is very welcome.
Cheers,

Stefano



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



Stefano Stabellini (13):
      arm: make SWIOTLB available
      arm: introduce a global dma_ops pointer
      arm64: define DMA_ERROR_CODE
      arm64: do not initialize arm64_swiotlb if dma_ops is already set
      xen/arm,arm64: move Xen initialization earlier
      xen: introduce XENMEM_exchange_and_pin and XENMEM_unpin
      xen: make xen_create_contiguous_region return the dma address
      swiotlb-xen: support autotranslate guests
      xen/arm,arm64: enable SWIOTLB_XEN
      swiotlb-xen: introduce xen_swiotlb_set_dma_mask
      xen: introduce xen_alloc/free_coherent_pages
      swiotlb-xen: use xen_alloc/free_coherent_pages
      swiotlb: don't assume that io_tlb_start-io_tlb_end is coherent

 arch/arm/Kconfig                           |    7 +
 arch/arm/include/asm/dma-mapping.h         |   35 +++++-
 arch/arm/include/asm/xen/hypervisor.h      |    8 +
 arch/arm/include/asm/xen/page-coherent.h   |   22 +++
 arch/arm/include/asm/xen/page.h            |    2 +
 arch/arm/kernel/setup.c                    |    2 +
 arch/arm/mm/dma-mapping.c                  |    3 +
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/enlighten.c                   |   24 +++-
 arch/arm/xen/mm.c                          |  117 ++++++++++++++++
 arch/arm64/Kconfig                         |    1 +
 arch/arm64/include/asm/dma-mapping.h       |    1 +
 arch/arm64/include/asm/xen/page-coherent.h |   24 +++
 arch/arm64/kernel/setup.c                  |    2 +
 arch/arm64/mm/dma-mapping.c                |    2 +
 arch/arm64/xen/Makefile                    |    2 +-
 arch/ia64/include/asm/xen/page-coherent.h  |   24 +++
 arch/x86/include/asm/xen/page-coherent.h   |   24 +++
 arch/x86/xen/mmu.c                         |   11 +-
 drivers/xen/Kconfig                        |    1 -
 drivers/xen/swiotlb-xen.c                  |  209 ++++++++++++++++++++++++----
 include/xen/interface/memory.h             |   37 +++++
 include/xen/swiotlb-xen.h                  |    2 +
 include/xen/xen-ops.h                      |    7 +-
 lib/swiotlb.c                              |   12 ++-
 25 files changed, 535 insertions(+), 46 deletions(-)

git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git swiotlb-xen-5
