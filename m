Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaKLNnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:43:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:41715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaKLNnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:14 -0500
Message-Id: <20141112134121.019296288@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 14/16] PCI/MSI: Rename __read_msi_msg() to __pci_read_msi_msg()
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=rfc-part4-v1-11-17-pci-msi-rename-__read_msi_msg-as-__pci_read_msi_msg.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename __read_msi_msg() to __pci_read_msi_msg() and kill unused
read_msi_msg(). It's a preparation to separate generic MSI code from
PCI core.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 arch/x86/pci/xen.c                   |    2 +-
 drivers/pci/msi.c                    |    9 +--------
 include/linux/msi.h                  |    6 ++++--
 4 files changed, 7 insertions(+), 12 deletions(-)

Index: tip/arch/powerpc/platforms/pseries/msi.c
===================================================================
--- tip.orig/arch/powerpc/platforms/pseries/msi.c
+++ tip/arch/powerpc/platforms/pseries/msi.c
@@ -476,7 +476,7 @@ again:
 		irq_set_msi_desc(virq, entry);
 
 		/* Read config space back so we can restore after reset */
-		__read_msi_msg(entry, &msg);
+		__pci_read_msi_msg(entry, &msg);
 		entry->msg = msg;
 	}
 
Index: tip/arch/x86/pci/xen.c
===================================================================
--- tip.orig/arch/x86/pci/xen.c
+++ tip/arch/x86/pci/xen.c
@@ -229,7 +229,7 @@ static int xen_hvm_setup_msi_irqs(struct
 		return 1;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		__read_msi_msg(msidesc, &msg);
+		__pci_read_msi_msg(msidesc, &msg);
 		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
 			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
 		if (msg.data != XEN_PIRQ_MSI_DATA ||
Index: tip/drivers/pci/msi.c
===================================================================
--- tip.orig/drivers/pci/msi.c
+++ tip/drivers/pci/msi.c
@@ -242,7 +242,7 @@ void default_restore_msi_irqs(struct pci
 		default_restore_msi_irq(dev, entry->irq);
 }
 
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
 
@@ -272,13 +272,6 @@ void __read_msi_msg(struct msi_desc *ent
 	}
 }
 
-void read_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__read_msi_msg(entry, msg);
-}
-
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
Index: tip/include/linux/msi.h
===================================================================
--- tip.orig/include/linux/msi.h
+++ tip/include/linux/msi.h
@@ -15,10 +15,8 @@ struct irq_data;
 struct msi_desc;
 void mask_msi_irq(struct irq_data *data);
 void unmask_msi_irq(struct irq_data *data);
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
 void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
@@ -48,6 +46,10 @@ struct msi_desc {
 	struct msi_msg msg;
 };
 
+#ifdef CONFIG_PCI_MSI
+void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+#endif
+
 /*
  * The arch hooks to setup up msi irqs. Those functions are
  * implemented as weak symbols so that they /can/ be overriden by


