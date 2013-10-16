Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3JPGdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:33:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35223 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3JPGde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:33:34 -0400
Message-ID: <525E3348.9040007@oracle.com>
Date: Wed, 16 Oct 2013 14:33:44 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] Update x86_msi.restore_msi_irqs API param
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change x86_msi.restore_msi_irqs(struct pci_dev *dev, int irq) to
x86_msi.restore_msi_irqs(struct pci_dev *dev)

>From its naming, restore_msi_irqs is used to restore multiple msix irqs,
param 'int irq' is unneeded. This could make code looks consistent in vm
and bare metal.

Dom0 msix restore code could be optimized a bit with this change.

Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/pci.h      |    2 +-
 arch/x86/include/asm/x86_init.h |    2 +-
 arch/x86/kernel/x86_init.c      |    4 ++--
 arch/x86/pci/xen.c              |    2 +-
 drivers/pci/msi.c               |   21 ++++++++++++++-------
 include/linux/msi.h             |    4 ++--
 6 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 7d74432..d44baf4 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -104,7 +104,7 @@ extern void pci_iommu_alloc(void);
 struct msi_desc;
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
-void native_restore_msi_irqs(struct pci_dev *dev, int irq);
+void native_restore_msi_irqs(struct pci_dev *dev);
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 		  unsigned int irq_base, unsigned int irq_offset);
 #else
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 828a156..f58a9c7 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -180,7 +180,7 @@ struct x86_msi_ops {
 			       u8 hpet_id);
 	void (*teardown_msi_irq)(unsigned int irq);
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
-	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
+	void (*restore_msi_irqs)(struct pci_dev *dev);
 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 };
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 8ce0072..234b072 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -134,9 +134,9 @@ void arch_teardown_msi_irq(unsigned int irq)
 	x86_msi.teardown_msi_irq(irq);
 }
 
-void arch_restore_msi_irqs(struct pci_dev *dev, int irq)
+void arch_restore_msi_irqs(struct pci_dev *dev)
 {
-	x86_msi.restore_msi_irqs(dev, irq);
+	x86_msi.restore_msi_irqs(dev);
 }
 #endif
 
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 48e8461..cdd869f 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -337,7 +337,7 @@ out:
 	return ret;
 }
 
-static void xen_initdom_restore_msi_irqs(struct pci_dev *dev, int irq)
+static void xen_initdom_restore_msi_irqs(struct pci_dev *dev)
 {
 	int ret = 0;
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 38237f4..c16928e 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -116,9 +116,9 @@ void __weak arch_teardown_msi_irqs(struct pci_dev *dev)
 	return default_teardown_msi_irqs(dev);
 }
 
-void __weak arch_restore_msi_irqs(struct pci_dev *dev, int irq)
+void __weak arch_restore_msi_irqs(struct pci_dev *dev)
 {
-	return default_restore_msi_irqs(dev, irq);
+	return default_restore_msi_irqs(dev);
 }
 
 static void msi_set_enable(struct pci_dev *dev, int enable)
@@ -234,7 +234,7 @@ void unmask_msi_irq(struct irq_data *data)
 	msi_set_mask_bit(data, 0);
 }
 
-void default_restore_msi_irqs(struct pci_dev *dev, int irq)
+static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 {
 	int pos;
 	u16 control;
@@ -265,6 +265,15 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 	}
 }
 
+void default_restore_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		default_restore_msi_irq(dev, entry->irq);
+	}
+}
+
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
@@ -433,7 +442,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, 0);
-	arch_restore_msi_irqs(dev, dev->irq);
+	arch_restore_msi_irqs(dev);
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
@@ -457,9 +466,7 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	control |= PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL;
 	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, control);
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		arch_restore_msi_irqs(dev, entry->irq);
-	}
+	arch_restore_msi_irqs(dev);
 
 	control &= ~PCI_MSIX_FLAGS_MASKALL;
 	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, control);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index b17ead8..cea1123 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -60,10 +60,10 @@ void arch_teardown_msi_irq(unsigned int irq);
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
 int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
-void arch_restore_msi_irqs(struct pci_dev *dev, int irq);
+void arch_restore_msi_irqs(struct pci_dev *dev);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
-void default_restore_msi_irqs(struct pci_dev *dev, int irq);
+void default_restore_msi_irqs(struct pci_dev *dev);
 
 struct msi_chip {
 	struct module *owner;
-- 
1.7.3

