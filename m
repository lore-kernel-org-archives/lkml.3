Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3ISHhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:37:23 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:42828
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253Ab3ISHhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:37:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <iommu@lists.linux-foundation.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 4/7] powerpc: translate msi addr to iova if iommu is in use
Date: Thu, 19 Sep 2013 12:59:20 +0530
Message-ID: <1379575763-2091-5-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is attached with iommu domain then set MSI address
to the iova configured in PAMU.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/sysdev/fsl_msi.c |   56 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index ed045cb..c7cf018 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -18,6 +18,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/of_platform.h>
+#include <linux/iommu.h>
 #include <sysdev/fsl_soc.h>
 #include <asm/prom.h>
 #include <asm/hw_irq.h>
@@ -150,7 +151,40 @@ static void fsl_teardown_msi_irqs(struct pci_dev *pdev)
 	return;
 }
 
-static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
+static uint64_t fsl_iommu_get_iova(struct pci_dev *pdev, dma_addr_t msi_phys)
+{
+	struct iommu_domain *domain;
+	struct iommu_domain_geometry geometry;
+	u32 wins = 0;
+	uint64_t iova, size;
+	int ret, i;
+
+	domain = iommu_get_dev_domain(&pdev->dev);
+	if (!domain)
+		return 0;
+
+	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_WINDOWS, &wins);
+	if (ret)
+		return 0;
+
+	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_GEOMETRY, &geometry);
+	if (ret)
+		return 0;
+
+	iova = geometry.aperture_start;
+	size = geometry.aperture_end - geometry.aperture_start + 1;
+	do_div(size, wins);
+	for (i = 0; i < wins; i++) {
+		phys_addr_t phys;
+		phys = iommu_iova_to_phys(domain, iova);
+		if (phys == (msi_phys & ~(PAGE_SIZE - 1)))
+			return (iova + (msi_phys & (PAGE_SIZE - 1)));
+		iova += size;
+	}
+	return 0;
+}
+
+static int fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 				struct msi_msg *msg,
 				struct fsl_msi *fsl_msi_data)
 {
@@ -168,6 +202,16 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 		address = fsl_pci_immrbar_base(hose) +
 			   (msi_data->msiir & 0xfffff);
 
+	/*
+	 * If the device is attached with iommu domain then set MSI address
+	 * to the iova configured in PAMU.
+	 */
+	if (iommu_get_dev_domain(&pdev->dev)) {
+		address = fsl_iommu_get_iova(pdev, msi_data->msiir);
+		if (!address)
+			return -ENODEV;
+	}
+
 	msg->address_lo = lower_32_bits(address);
 	msg->address_hi = upper_32_bits(address);
 
@@ -175,6 +219,8 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 
 	pr_debug("%s: allocated srs: %d, ibs: %d\n",
 		__func__, hwirq / IRQS_PER_MSI_REG, hwirq % IRQS_PER_MSI_REG);
+
+	return 0;
 }
 
 static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
@@ -244,7 +290,13 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 		/* chip_data is msi_data via host->hostdata in host->map() */
 		irq_set_msi_desc(virq, entry);
 
-		fsl_compose_msi_msg(pdev, hwirq, &msg, msi_data);
+		if (fsl_compose_msi_msg(pdev, hwirq, &msg, msi_data)) {
+			dev_err(&pdev->dev, "Fail to set MSI for hwirq %i\n",
+				hwirq);
+			msi_bitmap_free_hwirqs(&msi_data->bitmap, hwirq, 1);
+			rc = -ENODEV;
+			goto out_free;
+		}
 		write_msi_msg(virq, &msg);
 	}
 	return 0;
-- 
1.7.0.4


