Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3GXDJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:09:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24777 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3GXDI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:08:59 -0400
Message-ID: <51EF453B.5070200@oracle.com>
Date: Wed, 24 Jul 2013 11:08:43 +0800
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
        "x86@kernel.org >> \"x86@kernel.org\"" <x86@kernel.org>
Subject: [PATCH 3/3] msix restore code optimization for dom0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHYSDEVOP_restore_msi is used to restore all msix entrys in one hypercall
in dom0. But it is called multi times in current code.

This patch split arch_restore_msi_irqs into two functions.
Use arch_restore_msi_irq deal with one entry and avoid call hypercall multi
times in __pci_restore_msix_state.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 arch/x86/include/asm/pci.h      |    8 ++++----
 arch/x86/include/asm/x86_init.h |    2 +-
 arch/x86/pci/xen.c              |    2 +-
 drivers/pci/msi.c               |   17 ++++++++++++-----
 4 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d9e9e6c..40cbea4 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -115,9 +115,9 @@ static inline void x86_teardown_msi_irq(unsigned int irq)
 {
 	x86_msi.teardown_msi_irq(irq);
 }
-static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
+static inline void x86_restore_msi_irqs(struct pci_dev *dev)
 {
-	x86_msi.restore_msi_irqs(dev, irq);
+	x86_msi.restore_msi_irqs(dev);
 }
 #define arch_setup_msi_irqs x86_setup_msi_irqs
 #define arch_teardown_msi_irqs x86_teardown_msi_irqs
@@ -127,14 +127,14 @@ static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
 struct msi_desc;
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
-void native_restore_msi_irqs(struct pci_dev *dev, int irq);
+void native_restore_msi_irqs(struct pci_dev *dev);
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 		  unsigned int irq_base, unsigned int irq_offset);
 /* default to the implementation in drivers/lib/msi.c */
 #define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
 #define HAVE_DEFAULT_MSI_RESTORE_IRQS
 void default_teardown_msi_irqs(struct pci_dev *dev);
-void default_restore_msi_irqs(struct pci_dev *dev, int irq);
+void default_restore_msi_irqs(struct pci_dev *dev);
 #else
 #define native_setup_msi_irqs		NULL
 #define native_teardown_msi_irq		NULL
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
index 922fb49..d4ccfeb 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -214,7 +214,7 @@ void unmask_msi_irq(struct irq_data *data)
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
-void default_restore_msi_irqs(struct pci_dev *dev, int irq)
+static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 {
 	int pos;
 	u16 control;
@@ -244,6 +244,15 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 		}
 	}
 }
+
+void default_restore_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		default_restore_msi_irq(dev, entry->irq);
+	}
+}
 #endif
 
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
@@ -416,7 +425,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, 0);
-	arch_restore_msi_irqs(dev, dev->irq);
+	arch_restore_msi_irqs(dev);
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
@@ -440,9 +449,7 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	control |= PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL;
 	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, control);
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		arch_restore_msi_irqs(dev, entry->irq);
-	}
+	arch_restore_msi_irqs(dev);
 
 	control &= ~PCI_MSIX_FLAGS_MASKALL;
 	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, control);
-- 
1.7.3

