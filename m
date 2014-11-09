Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaKIPIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:08:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:34359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbaKIPIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:08:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933074"
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
Subject: [RFC Part4 v1 07/17] x86, irq: Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET irq_chips
Date: Sun,  9 Nov 2014 23:10:29 +0800
Message-Id: <1415545839-28263-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET irq_chips, they
will be used to share common code later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |   14 ++++++++++++++
 drivers/pci/msi.c          |   15 +++++++++++++--
 include/linux/msi.h        |    1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 0b2261fe6adf..842d71699912 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -65,6 +65,7 @@ static struct irq_chip msi_chip = {
 	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= msi_compose_msg,
+	.irq_write_msi_msg	= pci_msi_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -128,6 +129,7 @@ static struct irq_chip msi_ir_chip = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_write_msi_msg	= pci_msi_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -155,6 +157,11 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
+static void dmar_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	dmar_msi_write(data->irq, msg);
+}
+
 static struct irq_chip dmar_msi_type = {
 	.name			= "DMAR-MSI",
 	.irq_unmask		= dmar_msi_unmask,
@@ -163,6 +170,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_set_affinity	= dmar_msi_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= msi_compose_msg,
+	.irq_write_msi_msg	= dmar_msi_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -285,6 +293,11 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	return ret;
 }
 
+static void hpet_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	hpet_msi_write(data->handler_data, msg);
+}
+
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET-MSI",
 	.irq_unmask = hpet_msi_unmask,
@@ -293,6 +306,7 @@ static struct irq_chip hpet_msi_type = {
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg = msi_compose_msg,
+	.irq_write_msi_msg = hpet_msi_write_msg,
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 49a8bd37189d..b811739b43c5 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1117,6 +1117,18 @@ int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
+void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
+{
+	struct msi_desc *desc = irq_data->msi_desc;
+
+	/*
+	 * MSI-X message is written per-IRQ.
+	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
+	 */
+	if (desc->irq == irq_data->irq)
+		__write_msi_msg(desc, msg);
+}
+
 /*
  * Generate a unique ID number for each possible MSI source, the ID number
  * is only used within the irqdomain.
@@ -1144,8 +1156,7 @@ static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
 	for (i = 0; i < nr_irqs; i++) {
 		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
-					      domain->host_data,
-					      (void *)(long)i);
+					      domain->host_data, NULL);
 		__irq_set_handler(virq + i, handle_edge_irq, 0, "edge");
 	}
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index daea96489a39..312197f64070 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -84,6 +84,7 @@ int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
 					 struct irq_chip *chip,
 					 struct irq_domain *parent);
+void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
 int msi_irq_domain_alloc_irqs(struct irq_domain *domain, int type,
 			      struct pci_dev *dev, void *arg);
 
-- 
1.7.10.4

