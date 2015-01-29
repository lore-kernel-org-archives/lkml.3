Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbbA2Jbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:31:32 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34512 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761224AbbA2JWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:21 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/24] powerpc/iommu/vfio: Enable Dynamic DMA windows
Date: Thu, 29 Jan 2015 20:21:41 +1100
Message-Id: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0029-0000-0000-0000010FD5B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This enables PAPR defined feature called Dynamic DMA windows (DDW).

Each Partitionable Endpoint (IOMMU group) has a separate DMA window on
a PCI bus where devices are allows to perform DMA. By default there is
1 or 2GB window allocated at the host boot time and these windows are
used when an IOMMU group is passed to the userspace (guest). These windows
are mapped at zero offset on a PCI bus.

Hi-speed devices may suffer from limited size of this window. On the host
side a TCE bypass mode is enabled on POWER8 CPU which implements
direct mapping of the host memory to a PCI bus at 1<<59.

For the guest, PAPR defines a DDW RTAS API which allows the pseries guest
to query the hypervisor if it supports DDW and what are the parameters
of possible windows.

Currently POWER8 supports 2 DMA windows per PE - already mentioned and used
small 32bit window and 64bit window which can only start from 1<<59 and
can support various page sizes.

This patchset reworks PPC IOMMU code and adds necessary structures
to extend it to support big windows.

When the guest detectes the feature and the PE is capable of 64bit DMA,
it does:
1. query to hypervisor about number of available windows and page masks;
2. creates a window with the biggest possible page size (current guests can do
64K or 16MB TCEs);
3. maps the entire guest RAM via H_PUT_TCE* hypercalls
4. switches dma_ops to direct_dma_ops on the selected PE.

Once this is done, H_PUT_TCE is not called anymore and the guest gets
maximum performance.

Changes:
v3:
* (!) redesigned the whole thing
* multiple IOMMU groups per PHB -> one PHB is needed for VFIO in the guest ->
no problems with locked_vm counting; also we save memory on actual tables
* guest RAM preregistration is required for DDW
* PEs (IOMMU groups) are passed to VFIO with no DMA windows at all so
we do not bother with iommu_table::it_map anymore
* added multilevel TCE tables support to support really huge guests

v2:
* added missing __pa() in "powerpc/powernv: Release replaced TCE"
* reposted to make some noise




Alexey Kardashevskiy (24):
  vfio: powerpc/spapr: Move page pinning from arch code to VFIO IOMMU
    driver
  vfio: powerpc/iommu: Check that TCE page size is equal to it_page_size
  powerpc/powernv: Do not set "read" flag if direction==DMA_NONE
  vfio: powerpc/spapr: Use it_page_size
  vfio: powerpc/spapr: Move locked_vm accounting to helpers
  powerpc/iommu: Move tce_xxx callbacks from ppc_md to iommu_table
  powerpc/iommu: Introduce iommu_table_alloc() helper
  powerpc/spapr: vfio: Switch from iommu_table to new powerpc_iommu
  powerpc/iommu: Fix IOMMU ownership control functions
  powerpc/powernv/ioda2: Rework IOMMU ownership control
  powerpc/powernv/ioda/ioda2: Rework tce_build()/tce_free()
  powerpc/iommu/powernv: Release replaced TCE
  powerpc/pseries/lpar: Enable VFIO
  vfio: powerpc/spapr: Register memory
  poweppc/powernv/ioda2: Rework iommu_table creation
  powerpc/powernv/ioda2: Introduce pnv_pci_ioda2_create_table
  powerpc/powernv/ioda2: Introduce pnv_pci_ioda2_set_window
  powerpc/iommu: Split iommu_free_table into 2 helpers
  powerpc/powernv: Implement multilevel TCE tables
  powerpc/powernv: Change prototypes to receive iommu
  powerpc/powernv/ioda: Define and implement DMA table/window management
    callbacks
  powerpc/iommu: Get rid of ownership helpers
  vfio/spapr: Enable multiple groups in a container
  vfio: powerpc/spapr: Support Dynamic DMA windows

 arch/powerpc/include/asm/iommu.h            | 107 +++-
 arch/powerpc/include/asm/machdep.h          |  25 -
 arch/powerpc/kernel/eeh.c                   |   2 +-
 arch/powerpc/kernel/iommu.c                 | 282 +++------
 arch/powerpc/kernel/vio.c                   |   5 +
 arch/powerpc/platforms/cell/iommu.c         |   8 +-
 arch/powerpc/platforms/pasemi/iommu.c       |   7 +-
 arch/powerpc/platforms/powernv/pci-ioda.c   | 470 ++++++++++++---
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  21 +-
 arch/powerpc/platforms/powernv/pci.c        | 130 +++--
 arch/powerpc/platforms/powernv/pci.h        |  14 +-
 arch/powerpc/platforms/pseries/iommu.c      |  99 +++-
 arch/powerpc/sysdev/dart_iommu.c            |  12 +-
 drivers/vfio/vfio_iommu_spapr_tce.c         | 874 ++++++++++++++++++++++++----
 include/uapi/linux/vfio.h                   |  53 +-
 15 files changed, 1584 insertions(+), 525 deletions(-)

-- 
2.0.0

