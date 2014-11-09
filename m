Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaKIPI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:08:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:33893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaKIPI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:08:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604932976"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 05/17] PCI/MSI: Move msi_set_affinity() to PCI core
Date: Sun,  9 Nov 2014 23:10:27 +0800
Message-Id: <1415545839-28263-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move msi_set_affinity() to PCI core, so it could be reused later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |   20 ++------------------
 drivers/pci/msi.c          |   16 ++++++++++++++++
 include/linux/msi.h        |    2 ++
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 727e4254f124..0b2261fe6adf 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -53,22 +53,6 @@ static void msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 		MSI_DATA_VECTOR(cfg->vector);
 }
 
-static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			    bool force)
-{
-	struct irq_data *parent = data->parent_data;
-	struct msi_msg msg;
-	int ret;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		irq_chip_compose_msi_msg(data, &msg);
-		__write_msi_msg(data->msi_desc, &msg);
-	}
-
-	return ret;
-}
-
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -78,7 +62,7 @@ static struct irq_chip msi_chip = {
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_set_affinity	= msi_set_affinity,
+	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= msi_compose_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
@@ -142,7 +126,7 @@ static struct irq_chip msi_ir_chip = {
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_set_affinity	= msi_set_affinity,
+	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8de7c8774fd2..49a8bd37189d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1101,6 +1101,22 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 EXPORT_SYMBOL(pci_enable_msix_range);
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force)
+{
+	struct irq_data *parent = data->parent_data;
+	struct msi_msg msg;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
+		irq_chip_compose_msi_msg(data, &msg);
+		__write_msi_msg(data->msi_desc, &msg);
+	}
+
+	return ret;
+}
+
 /*
  * Generate a unique ID number for each possible MSI source, the ID number
  * is only used within the irqdomain.
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 662c628fc2fa..daea96489a39 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -79,6 +79,8 @@ struct msi_chip {
 struct irq_domain;
 struct irq_chip;
 
+int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force);
 struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
 					 struct irq_chip *chip,
 					 struct irq_domain *parent);
-- 
1.7.10.4

