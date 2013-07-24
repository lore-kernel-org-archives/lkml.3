Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab3GXDI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:08:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24665 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3GXDI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:08:26 -0400
Message-ID: <51EF451A.8050003@oracle.com>
Date: Wed, 24 Jul 2013 11:08:10 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
CC: bhelgaas@google.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: [PATCH 2/3] Refactor msi/msix restore code Part2
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_initdom_restore_msi_irqs trigger a hypercall to restore addr/data/mask
in dom0. It's better to do the same for default_restore_msi_irqs in baremetal.

Move restore of mask in default_restore_msi_irqs, this could avoid mask
restored twice in dom0, once in hypercall, the other in kernel.

Without that, qlcnic driver calling pci_reset_function will lost interrupt
in dom0.

Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/pci/msi.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 87223ae..922fb49 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -216,6 +216,8 @@ void unmask_msi_irq(struct irq_data *data)
 #ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
 void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 {
+	int pos;
+	u16 control;
 	struct msi_desc *entry;
 
 	entry = NULL;
@@ -228,8 +230,19 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 		entry = irq_get_msi_desc(irq);
 	}
 
-	if (entry)
+	if (entry) {
 		write_msi_msg(irq, &entry->msg);
+		if (dev->msix_enabled) {
+			msix_mask_irq(entry, entry->masked);
+			readl(entry->mask_base);
+		} else {
+			pos = entry->msi_attrib.pos;
+			pci_read_config_word(dev, pos + PCI_MSI_FLAGS,
+					     &control);
+			msi_mask_irq(entry, msi_capable_mask(control),
+				     entry->masked);
+		}
+	}
 }
 #endif
 
@@ -406,7 +419,6 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	arch_restore_msi_irqs(dev, dev->irq);
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
-	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
 	control |= (entry->msi_attrib.multiple << 4) | PCI_MSI_FLAGS_ENABLE;
 	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
@@ -430,7 +442,6 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		arch_restore_msi_irqs(dev, entry->irq);
-		msix_mask_irq(entry, entry->masked);
 	}
 
 	control &= ~PCI_MSIX_FLAGS_MASKALL;
-- 
1.7.3

