Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaKIPJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:09:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:50190 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbaKIPJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:09:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933294"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org
Subject: [RFC Part4 v1 12/17] PCI, MSI: Rename __write_msi_msg() as __pci_write_msi_msg()
Date: Sun,  9 Nov 2014 23:10:34 +0800
Message-Id: <1415545839-28263-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename __write_msi_msg() as __pci_write_msi_msg() to mark it as PCI
specific. Also define pci_write_msi_msg() as write_msi_msg() for easy
transition.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/xen.c  |    2 +-
 drivers/pci/msi.c   |    9 ++++-----
 include/linux/msi.h |    3 ++-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index a48ca2f8b93e..1cfbe32c4b1c 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -240,7 +240,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 				goto error;
 			}
 			xen_msi_compose_msg(dev, pirq, &msg);
-			__write_msi_msg(msidesc, &msg);
+			__pci_write_msi_msg(msidesc, &msg);
 			dev_dbg(&dev->dev, "xen: msi bound to pirq=%d\n", pirq);
 		} else {
 			dev_dbg(&dev->dev,
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6011dfb475a1..80be534df522 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -27,7 +27,6 @@ static int pci_msi_enable = 1;
 
 #define msix_table_size(flags)	((flags & PCI_MSIX_FLAGS_QSIZE) + 1)
 
-
 /* Arch hooks */
 
 int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
@@ -115,7 +114,7 @@ static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 	}
 
 	if (entry)
-		__write_msi_msg(entry, &entry->msg);
+		__pci_write_msi_msg(entry, &entry->msg);
 }
 
 void __weak arch_restore_msi_irqs(struct pci_dev *dev)
@@ -273,7 +272,7 @@ void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	}
 }
 
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
 		/* Don't touch the hardware now */
@@ -314,7 +313,7 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = irq_get_msi_desc(irq);
 
-	__write_msi_msg(entry, msg);
+	__pci_write_msi_msg(entry, msg);
 }
 EXPORT_SYMBOL_GPL(write_msi_msg);
 
@@ -1085,7 +1084,7 @@ void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
 	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
 	 */
 	if (desc->irq == irq_data->irq)
-		__write_msi_msg(desc, msg);
+		__pci_write_msi_msg(desc, msg);
 }
 
 /*
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 4b0d070ff481..5639970db71d 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -62,8 +62,9 @@ void msi_domain_deactivate(struct irq_domain *domain,
 #ifdef CONFIG_PCI_MSI
 /* Helper functions */
 void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+#define pci_write_msi_msg	write_msi_msg
 
 /*
  * The arch hooks to setup up msi irqs. Those functions are
-- 
1.7.10.4

