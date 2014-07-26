Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761196AbaGZCoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:18 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45740 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030AbaGZCnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:51 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 07/11] PCI/MSI: Mask MSI-X entry in msix_setup_entries()
Date: Sat, 26 Jul 2014 11:08:44 +0800
Message-ID: <1406344128-27055-8-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the MSI-X entry initial mask status in
msix_setup_entries(), also mask the entry.
This is preparation for generic MSI.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/msi.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index f96dd38..41c33da 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -672,7 +672,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 			      struct msix_entry *entries, int nvec)
 {
 	struct msi_desc *entry;
-	int i;
+	int i, offset;
 
 	for (i = 0; i < nvec; i++) {
 		entry = alloc_msi_entry(dev);
@@ -691,6 +691,15 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
 
+		msix_clear_and_set_ctrl(dev, 0, 
+				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE);
+		offset = entries[i].entry * PCI_MSIX_ENTRY_SIZE +
+						PCI_MSIX_ENTRY_VECTOR_CTRL;
+		entry->masked = readl(entry->mask_base + offset);
+		msix_mask_irq(entry, 1);
+		msix_clear_and_set_ctrl(dev, 
+				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
+
 		list_add_tail(&entry->list, &dev->msi_list);
 	}
 
@@ -704,13 +713,8 @@ static void msix_program_entries(struct pci_dev *dev,
 	int i = 0;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		int offset = entries[i].entry * PCI_MSIX_ENTRY_SIZE +
-						PCI_MSIX_ENTRY_VECTOR_CTRL;
-
 		entries[i].vector = entry->irq;
 		irq_set_msi_desc(entry->irq, entry);
-		entry->masked = readl(entry->mask_base + offset);
-		msix_mask_irq(entry, 1);
 		i++;
 	}
 }
@@ -746,16 +750,13 @@ static int msix_capability_init(struct pci_dev *dev, void __iomem *base,
 	 * MSI-X registers.  We need to mask all the vectors to prevent
 	 * interrupts coming in before they're fully set up.
 	 */
-	msix_clear_and_set_ctrl(dev, 0,
-				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE);
-
 	msix_program_entries(dev, entries);
 
 	/* Set MSI-X enabled bits and unmask the function */
 	pci_intx_for_msi(dev, 0);
 	dev->msix_enabled = 1;
 
-	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
+	msix_clear_and_set_ctrl(dev, 0, PCI_MSIX_FLAGS_ENABLE);
 
 	return 0;
 
-- 
1.7.1

