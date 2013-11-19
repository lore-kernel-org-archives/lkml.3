Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3KSFYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:24:11 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:29030
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab3KSFXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:23:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>, <bhelgaas@google.com>,
        <agraf@suse.de>, <scottwood@freescale.com>,
        <stuart.yoder@freescale.com>, <iommu@lists.linux-foundation.org>,
        <linux-pci@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 5/9 v2] pci/msi: interface to set an iova for a msi region
Date: Tue, 19 Nov 2013 10:47:09 +0530
Message-ID: <1384838233-24847-6-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines an interface by which a msi page
can be mapped to a specific iova page.

This is a requirement in aperture type of IOMMUs (like Freescale PAMU),
where we map msi iova page just after guest memory iova address.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
v2
 - new patch

 drivers/pci/msi.c   |   13 +++++++++++++
 include/linux/pci.h |    8 ++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 2643a29..040609f 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -77,6 +77,19 @@ int __weak arch_msi_get_region(int region_num, struct msi_region *region)
 	return 0;
 }
 
+int __weak arch_msi_set_iova(struct pci_dev *pdev, int region_num,
+			     dma_addr_t iova, bool set)
+{
+	return 0;
+}
+
+int msi_set_iova(struct pci_dev *pdev, int region_num,
+		 dma_addr_t iova, bool set)
+{
+	return arch_msi_set_iova(pdev, region_num, iova, set);
+}
+EXPORT_SYMBOL(msi_set_iova);
+
 int msi_get_region_count(void)
 {
 	return arch_msi_get_region_count();
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c587034..c6d3e58 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1195,6 +1195,12 @@ static inline int msi_get_region(int region_num, struct msi_region *region)
 {
 	return 0;
 }
+
+static inline int msi_set_iova(struct pci_dev *pdev, int region_num,
+			       dma_addr_t iova, bool set)
+{
+	return 0;
+}
 #else
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
@@ -1209,6 +1215,8 @@ void pci_restore_msi_state(struct pci_dev *dev);
 int pci_msi_enabled(void);
 int msi_get_region_count(void);
 int msi_get_region(int region_num, struct msi_region *region);
+int msi_set_iova(struct pci_dev *pdev, int region_num,
+		 dma_addr_t iova, bool set);
 #endif
 
 #ifdef CONFIG_PCIEPORTBUS
-- 
1.7.0.4


