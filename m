Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3ISHin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:38:43 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:46777
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844Ab3ISHhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:37:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <iommu@lists.linux-foundation.org>
CC: Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 0/7] vfio-pci: add support for Freescale IOMMU (PAMU)
Date: Thu, 19 Sep 2013 12:59:16 +0530
Message-ID: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharat Bhushan <bharat.bhushan@freescale.com>

This patchset adds support for vfio-pci with Freescale
IOMMU (PAMU- Peripheral Access Management Unit)

The Freescale PAMU is an aperture-based IOMMU with the following
characteristics.  Each device has an entry in a table in memory
describing the iova->phys mapping. The mapping has:
  -an overall aperture that is power of 2 sized, and has a start iova that
   is naturally aligned
  -has 1 or more windows within the aperture
  -number of windows must be power of 2, max is 256
  -size of each window is determined by aperture size / # of windows
  -iova of each window is determined by aperture start iova / # of windows
  -the mapped region in each window can be different than
   the window size...mapping must power of 2
  -physical address of the mapping must be naturally aligned
   with the mapping size

Because of some of above said limitations we need to set limited aperture 
window which will have space for MSI address mapping. So we create space
for MSI windows just after the IOVA (guest memory).
First 4 patches in this patchset are for setting up MSI window and MSI address
at device accordingly.

Fifth patch resolves compilation error.
Sixth patch moves some common functions in a separate file so that they can be
used by FSL_PAMU implementation (next patch uses this). These will be used later for
iommu-none implementation. I believe we can do more of this but will take step by step.

Finally the seventh patch actually adds the support for FSL-PAMU :)

Bharat Bhushan (7):
  powerpc: Add interface to get msi region information
  iommu: add api to get iommu_domain of a device
  fsl iommu: add get_dev_iommu_domain
  powerpc: translate msi addr to iova if iommu is in use
  iommu: supress loff_t compilation error on powerpc
  vfio: moving some functions in common file
  vfio pci: Add vfio iommu implementation for FSL_PAMU

 arch/powerpc/include/asm/machdep.h |    8 +
 arch/powerpc/include/asm/pci.h     |    2 +
 arch/powerpc/kernel/msi.c          |   18 +
 arch/powerpc/sysdev/fsl_msi.c      |   95 ++++-
 arch/powerpc/sysdev/fsl_msi.h      |   11 +-
 drivers/iommu/fsl_pamu_domain.c    |   30 ++
 drivers/iommu/iommu.c              |   10 +
 drivers/pci/msi.c                  |   26 +
 drivers/vfio/Kconfig               |    6 +
 drivers/vfio/Makefile              |    5 +-
 drivers/vfio/pci/vfio_pci_rdwr.c   |    3 +-
 drivers/vfio/vfio_iommu_common.c   |  235 +++++++++
 drivers/vfio/vfio_iommu_common.h   |   30 ++
 drivers/vfio/vfio_iommu_fsl_pamu.c |  952 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c    |  206 +--------
 include/linux/iommu.h              |    7 +
 include/linux/msi.h                |    8 +
 include/linux/pci.h                |   13 +
 include/uapi/linux/vfio.h          |  100 ++++
 19 files changed, 1550 insertions(+), 215 deletions(-)
 create mode 100644 drivers/vfio/vfio_iommu_common.c
 create mode 100644 drivers/vfio/vfio_iommu_common.h
 create mode 100644 drivers/vfio/vfio_iommu_fsl_pamu.c


