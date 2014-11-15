Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaKOKtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:49:41 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:58279 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbaKOKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:49:38 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] PCI/MSI: Allow an msi_chip to be associated to an irq domain
Date: Sat, 15 Nov 2014 10:49:12 +0000
Message-Id: <1416048553-29289-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416048553-29289-1-git-send-email-marc.zyngier@arm.com>
References: <1416048553-29289-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: tglx@linutronix.de, jiang.liu@linux.intel.com, yingjoe.chen@mediatek.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new stacked irq domains, it becomes pretty tempting
to allocate an MSI domain per PCI bus, which would remove
the requirement of either relying on arch-specific code, or
a default PCI MSI domain.

By allowing the msi_chip structure to carry a pointer to
an irq_domain, we can easily use this in pci_msi_setup_msi_irqs.
The existing code can still be used as a fallback if the MSI driver
does not populate the domain field.

Tested on arm64 with the GICv3 ITS driver.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/msi.c   | 16 +++++++++++++++-
 include/linux/msi.h |  3 +++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index af66b95..aa3b720 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -84,11 +84,25 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	return 0;
 }
 
+static struct irq_domain *pci_msi_get_domain(struct pci_dev *dev)
+{
+	struct irq_domain *domain = NULL;
+
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	if (dev->bus->msi)
+		domain = dev->bus->msi->domain;
+#endif
+	if (!domain)
+		domain = arch_get_pci_msi_domain(dev);
+
+	return domain;
+}
+
 static int pci_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct irq_domain *domain;
 
-	domain = arch_get_pci_msi_domain(dev);
+	domain = pci_msi_get_domain(dev);
 	if (domain)
 		return pci_msi_domain_alloc_irqs(domain, type, dev);
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8b4a69b..a8d309a 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -89,6 +89,9 @@ struct msi_chip {
 	struct device *dev;
 	struct device_node *of_node;
 	struct list_head list;
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	struct irq_domain *domain;
+#endif
 
 	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
-- 
2.1.0

