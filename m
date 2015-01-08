Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbbAHRGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:06:50 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58125 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbbAHRGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:06:40 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2 7/8] irqchip: gicv3-its: Get rid of struct msi_controller
Date: Thu,  8 Jan 2015 17:06:11 +0000
Message-Id: <1420736772-11088-8-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GICv3 ITS only uses the msi_controller structure as a way
to match the PHB with its MSI HW, and thus the msi_domain.
But now that we can directly associate an msi_domain with a device,
there is no use keeping this msi_controller around.

Just remove all traces of msi_controller from the driver.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 86e4684..2a2fb2e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -54,13 +54,12 @@ struct its_collection {
 
 /*
  * The ITS structure - contains most of the infrastructure, with the
- * msi_controller, the command queue, the collections, and the list of
- * devices writing to it.
+ * top-level MSI domain, the command queue, the collections, and the
+ * list of devices writing to it.
  */
 struct its_node {
 	raw_spinlock_t		lock;
 	struct list_head	entry;
-	struct msi_controller	msi_chip;
 	struct irq_domain	*domain;
 	void __iomem		*base;
 	unsigned long		phys_base;
@@ -875,7 +874,7 @@ retry_baser:
 
 		if (val != tmp) {
 			pr_err("ITS: %s: GITS_BASER%d doesn't stick: %lx %lx\n",
-			       its->msi_chip.of_node->full_name, i,
+			       its->domain->of_node->full_name, i,
 			       (unsigned long) val, (unsigned long) tmp);
 			err = -ENXIO;
 			goto out_free;
@@ -1260,6 +1259,7 @@ static int its_probe(struct device_node *node, struct irq_domain *parent)
 	struct resource res;
 	struct its_node *its;
 	void __iomem *its_base;
+	struct irq_domain *inner_domain = NULL;
 	u32 val;
 	u64 baser, tmp;
 	int err;
@@ -1296,7 +1296,6 @@ static int its_probe(struct device_node *node, struct irq_domain *parent)
 	INIT_LIST_HEAD(&its->its_device_list);
 	its->base = its_base;
 	its->phys_base = res.start;
-	its->msi_chip.of_node = node;
 	its->ite_size = ((readl_relaxed(its_base + GITS_TYPER) >> 4) & 0xf) + 1;
 
 	its->cmd_base = kzalloc(ITS_CMD_QUEUE_SZ, GFP_KERNEL);
@@ -1330,26 +1329,22 @@ static int its_probe(struct device_node *node, struct irq_domain *parent)
 		its->flags |= ITS_FLAGS_CMDQ_NEEDS_FLUSHING;
 	}
 
-	if (of_property_read_bool(its->msi_chip.of_node, "msi-controller")) {
-		its->domain = irq_domain_add_tree(NULL, &its_domain_ops, its);
-		if (!its->domain) {
+	if (of_property_read_bool(node, "msi-controller")) {
+		inner_domain = irq_domain_add_tree(NULL, &its_domain_ops, its);
+		if (!inner_domain) {
 			err = -ENOMEM;
 			goto out_free_tables;
 		}
 
-		its->domain->parent = parent;
+		inner_domain->parent = parent;
 
-		its->msi_chip.domain = pci_msi_create_irq_domain(node,
-								 &its_pci_msi_domain_info,
-								 its->domain);
-		if (!its->msi_chip.domain) {
+		its->domain = pci_msi_create_irq_domain(node,
+							&its_pci_msi_domain_info,
+							inner_domain);
+		if (!its->domain) {
 			err = -ENOMEM;
 			goto out_free_domains;
 		}
-
-		err = of_pci_msi_chip_add(&its->msi_chip);
-		if (err)
-			goto out_free_domains;
 	}
 
 	spin_lock(&its_lock);
@@ -1359,10 +1354,10 @@ static int its_probe(struct device_node *node, struct irq_domain *parent)
 	return 0;
 
 out_free_domains:
-	if (its->msi_chip.domain)
-		irq_domain_remove(its->msi_chip.domain);
 	if (its->domain)
 		irq_domain_remove(its->domain);
+	if (inner_domain)
+		irq_domain_remove(inner_domain);
 out_free_tables:
 	its_free_tables(its);
 out_free_cmd:
-- 
2.1.4

