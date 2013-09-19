Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3ISHi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:38:59 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:24665 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064Ab3ISHhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:37:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <iommu@lists.linux-foundation.org>
CC: Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 3/7] fsl iommu: add get_dev_iommu_domain
Date: Thu, 19 Sep 2013 12:59:19 +0530
Message-ID: <1379575763-2091-4-git-send-email-Bharat.Bhushan@freescale.com>
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

From: Bharat Bhushan <bharat.bhushan@freescale.com>

returns the iommu_domain of the requested device for fsl pamu.

Use PCI controller dev struct for pci devices as current LIODN schema
assign LIODN to PCI controller not PCI device. This will be corrected
with proper LIODN schema.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 drivers/iommu/fsl_pamu_domain.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 14d803a..1d0dfe3 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -1140,6 +1140,35 @@ static u32 fsl_pamu_get_windows(struct iommu_domain *domain)
 	return dma_domain->win_cnt;
 }
 
+static struct iommu_domain *fsl_get_dev_domain(struct device *dev)
+{
+	struct pci_controller *pci_ctl;
+	struct device_domain_info *info;
+	struct pci_dev *pdev;
+
+	/*
+	 * Use PCI controller dev struct for pci devices as current
+	 * LIODN schema assign LIODN to PCI controller not PCI device
+	 * This should get corrected with proper LIODN schema.
+	 */
+	if (dev->bus == &pci_bus_type) {
+		pdev = to_pci_dev(dev);
+		pci_ctl = pci_bus_to_host(pdev->bus);
+		/*
+		 * make dev point to pci controller device
+		 * so we can get the LIODN programmed by
+		 * u-boot.
+		 */
+		dev = pci_ctl->parent;
+	}
+
+	info = dev->archdata.iommu_domain;
+	if (info && info->domain)
+		return info->domain->iommu_domain;
+
+	return NULL;
+}
+
 static struct iommu_ops fsl_pamu_ops = {
 	.domain_init	= fsl_pamu_domain_init,
 	.domain_destroy = fsl_pamu_domain_destroy,
@@ -1155,6 +1184,7 @@ static struct iommu_ops fsl_pamu_ops = {
 	.domain_get_attr = fsl_pamu_get_domain_attr,
 	.add_device	= fsl_pamu_add_device,
 	.remove_device	= fsl_pamu_remove_device,
+	.get_dev_iommu_domain = fsl_get_dev_domain,
 };
 
 int pamu_domain_init()
-- 
1.7.0.4


