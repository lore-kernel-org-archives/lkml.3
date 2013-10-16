Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab3JPGcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:32:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34723 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3JPGcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:32:08 -0400
Message-ID: <525E32FC.3010604@oracle.com>
Date: Wed, 16 Oct 2013 14:32:28 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: [PATCH 1/3] PCI: Refactor restore_msi_irqs - code movement
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move default_restore_msi_irqs down to reference msi_mask_irq and msix_mask_irq.

This patch lays the groundwork for patch titled:
'PCI: Refactor MSI/MSIX mask restore code to fix interrupt lost issue'

Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/msi.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d5f90d6..ecd4cdf 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -116,24 +116,6 @@ void __weak arch_teardown_msi_irqs(struct pci_dev *dev)
 	return default_teardown_msi_irqs(dev);
 }
 
-void default_restore_msi_irqs(struct pci_dev *dev, int irq)
-{
-	struct msi_desc *entry;
-
-	entry = NULL;
-	if (dev->msix_enabled) {
-		list_for_each_entry(entry, &dev->msi_list, list) {
-			if (irq == entry->irq)
-				break;
-		}
-	} else if (dev->msi_enabled)  {
-		entry = irq_get_msi_desc(irq);
-	}
-
-	if (entry)
-		write_msi_msg(irq, &entry->msg);
-}
-
 void __weak arch_restore_msi_irqs(struct pci_dev *dev, int irq)
 {
 	return default_restore_msi_irqs(dev, irq);
@@ -252,6 +234,24 @@ void unmask_msi_irq(struct irq_data *data)
 	msi_set_mask_bit(data, 0);
 }
 
+void default_restore_msi_irqs(struct pci_dev *dev, int irq)
+{
+	struct msi_desc *entry;
+
+	entry = NULL;
+	if (dev->msix_enabled) {
+		list_for_each_entry(entry, &dev->msi_list, list) {
+			if (irq == entry->irq)
+				break;
+		}
+	} else if (dev->msi_enabled)  {
+		entry = irq_get_msi_desc(irq);
+	}
+
+	if (entry)
+		write_msi_msg(irq, &entry->msg);
+}
+
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
-- 
1.7.3

