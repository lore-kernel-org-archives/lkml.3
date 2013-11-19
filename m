Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab3KSFXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:23:20 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:47116
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab3KSFXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:23:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>, <bhelgaas@google.com>,
        <agraf@suse.de>, <scottwood@freescale.com>,
        <stuart.yoder@freescale.com>, <iommu@lists.linux-foundation.org>,
        <linux-pci@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Date: Tue, 19 Nov 2013 10:47:04 +0530
Message-ID: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharat Bhushan <bharat.bhushan@freescale.com>

PAMU (FSL IOMMU) has a concept of primary window and subwindows.
Primary window corresponds to the complete guest iova address space
(including MSI space), with respect to IOMMU_API this is termed as
geometry. IOVA Base of subwindow is determined from the number of
subwindows (configurable using iommu API).
MSI I/O page must be within the geometry and maximum supported
subwindows, so MSI IO-page is setup just after guest memory iova space.

So patch 1/9-4/9(inclusive) are for defining the interface to get:
  - Number of MSI regions (which is number of MSI banks for powerpc)
  - MSI-region address range: Physical page which have the
    address/addresses used for generating MSI interrupt
    and size of the page.

Patch 5/9-7/9(inclusive) is defining the interface of setting up
MSI iova-base for a msi region(bank) for a device. so that when
msi-message will be composed then this configured iova will be used.
Earlier we were using iommu interface for getting the configured iova
which was not currect and Alex Williamson suggeested this type of interface.

patch 8/9 moves some common functions in a separate file so that these
can be used by FSL_PAMU implementation (next patch uses this).
These will be used later for iommu-none implementation. I believe we
can do more of this but will take step by step.

Finally last patch actually adds the support for FSL-PAMU :)

v1->v2
 - Added interface for setting msi iova for a msi region for a device.
   Earlier I added iommu interface for same but as per comment that is
   removed and now created a direct interface between vfio and msi.
 - Incorporated review comments (details is in individual patch)

Bharat Bhushan (9):
  pci:msi: add weak function for returning msi region info
  pci: msi: expose msi region information functions
  powerpc: pci: Add arch specific msi region interface
  powerpc: msi: Extend the msi region interface to get info from
    fsl_msi
  pci/msi: interface to set an iova for a msi region
  powerpc: pci: Extend msi iova page setup to arch specific
  pci: msi: Extend msi iova setting interface to powerpc arch
  vfio: moving some functions in common file
  vfio pci: Add vfio iommu implementation for FSL_PAMU

 arch/powerpc/include/asm/machdep.h |   10 +
 arch/powerpc/kernel/msi.c          |   28 +
 arch/powerpc/sysdev/fsl_msi.c      |  132 +++++-
 arch/powerpc/sysdev/fsl_msi.h      |   25 +-
 drivers/pci/msi.c                  |   35 ++
 drivers/vfio/Kconfig               |    6 +
 drivers/vfio/Makefile              |    5 +-
 drivers/vfio/vfio_iommu_common.c   |  227 ++++++++
 drivers/vfio/vfio_iommu_common.h   |   27 +
 drivers/vfio/vfio_iommu_fsl_pamu.c | 1003 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c    |  206 +--------
 include/linux/msi.h                |   14 +
 include/linux/pci.h                |   21 +
 include/uapi/linux/vfio.h          |  100 ++++
 14 files changed, 1623 insertions(+), 216 deletions(-)
 create mode 100644 drivers/vfio/vfio_iommu_common.c
 create mode 100644 drivers/vfio/vfio_iommu_common.h
 create mode 100644 drivers/vfio/vfio_iommu_fsl_pamu.c


