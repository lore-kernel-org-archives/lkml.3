Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaKXUUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:20:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaKXUUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:20:33 -0500
Date: Sun, 23 Nov 2014 10:14:31 -0800
From: tip-bot for Marc Zyngier <tipbot@zytor.com>
Message-ID: <tip-020c312658d61297ffe43b412441c69b1c36fb1b@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, marc.zyngier@arm.com, bhelgaas@google.com,
        yingjoe.chen@mediatek.com, jiang.liu@linux.intel.com
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de, marc.zyngier@arm.com,
        jiang.liu@linux.intel.com, yingjoe.chen@mediatek.com
In-Reply-To: <1416048553-29289-2-git-send-email-marc.zyngier@arm.com>
References: <1416048553-29289-2-git-send-email-marc.zyngier@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] PCI/MSI:
  Allow an msi_controller to be associated to an irq domain
Git-Commit-ID: 020c312658d61297ffe43b412441c69b1c36fb1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  020c312658d61297ffe43b412441c69b1c36fb1b
Gitweb:     http://git.kernel.org/tip/020c312658d61297ffe43b412441c69b1c36fb1b
Author:     Marc Zyngier <marc.zyngier@arm.com>
AuthorDate: Sat, 15 Nov 2014 10:49:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 17:14:43 +0100

PCI/MSI: Allow an msi_controller to be associated to an irq domain

With the new stacked irq domains, it becomes pretty tempting to
allocate an MSI domain per PCI bus, which would remove the requirement
of either relying on arch-specific code, or a default PCI MSI domain.

By allowing the msi_controller structure to carry a pointer to an
irq_domain, we can easily use this in pci_msi_setup_msi_irqs.  The
existing code can still be used as a fallback if the MSI driver does
not populate the domain field.

Tested on arm64 with the GICv3 ITS driver.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Link: http://lkml.kernel.org/r/1416048553-29289-2-git-send-email-marc.zyngier@arm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/msi.c   | 16 ++++++++++++++--
 include/linux/msi.h |  3 +++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 4befe09..476f4b1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -37,11 +37,23 @@ struct irq_domain * __weak arch_get_pci_msi_domain(struct pci_dev *dev)
 	return pci_msi_default_domain;
 }
 
+static struct irq_domain *pci_msi_get_domain(struct pci_dev *dev)
+{
+	struct irq_domain *domain = NULL;
+
+	if (dev->bus->msi)
+		domain = dev->bus->msi->domain;
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
 		return pci_msi_domain_alloc_irqs(domain, dev, nvec, type);
 
@@ -52,7 +64,7 @@ static void pci_msi_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct irq_domain *domain;
 
-	domain = arch_get_pci_msi_domain(dev);
+	domain = pci_msi_get_domain(dev);
 	if (domain)
 		pci_msi_domain_free_irqs(domain, dev);
 	else
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 692f217..8ac4a68 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -108,6 +108,9 @@ struct msi_controller {
 	struct device *dev;
 	struct device_node *of_node;
 	struct list_head list;
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	struct irq_domain *domain;
+#endif
 
 	int (*setup_irq)(struct msi_controller *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
