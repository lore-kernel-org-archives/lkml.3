Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3J2LeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:34:19 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:24123
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638Ab3J2LeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:34:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <galak@kernel.crashing.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <stuart.yoder@freescale.com>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 1/5 RFC] pci:msi: add weak function for returning msi region info
Date: Tue, 29 Oct 2013 16:57:37 +0530
Message-ID: <1383046062-16520-1-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Aperture type of IOMMU (like FSL PAMU), VFIO-iommu system need to know
the MSI region to map its window in h/w. This patch just defines the
required weak functions only and will be used by followup patches.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 drivers/pci/msi.c   |   22 ++++++++++++++++++++++
 include/linux/msi.h |   14 ++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d5f90d6..2643a29 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -67,6 +67,28 @@ int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 	return chip->check_device(chip, dev, nvec, type);
 }
 
+int __weak arch_msi_get_region_count(void)
+{
+	return 0;
+}
+
+int __weak arch_msi_get_region(int region_num, struct msi_region *region)
+{
+	return 0;
+}
+
+int msi_get_region_count(void)
+{
+	return arch_msi_get_region_count();
+}
+EXPORT_SYMBOL(msi_get_region_count);
+
+int msi_get_region(int region_num, struct msi_region *region)
+{
+	return arch_msi_get_region(region_num, region);
+}
+EXPORT_SYMBOL(msi_get_region);
+
 int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
diff --git a/include/linux/msi.h b/include/linux/msi.h
index b17ead8..0deedb4 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -51,6 +51,18 @@ struct msi_desc {
 };
 
 /*
+ * This structure is used to get
+ * 	- physical address
+ * 	- size
+ * of a msi region
+ */
+struct msi_region {
+	int region_num; /* MSI region number */
+	dma_addr_t addr; /* Address of MSI region */
+	size_t size; /* Size of MSI region */
+};
+
+/*
  * The arch hooks to setup up msi irqs. Those functions are
  * implemented as weak symbols so that they /can/ be overriden by
  * architecture specific code if needed.
@@ -64,6 +76,8 @@ void arch_restore_msi_irqs(struct pci_dev *dev, int irq);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
 void default_restore_msi_irqs(struct pci_dev *dev, int irq);
+int arch_msi_get_region_count(void);
+int arch_msi_get_region(int region_num, struct msi_region *region);
 
 struct msi_chip {
 	struct module *owner;
-- 
1.7.0.4


