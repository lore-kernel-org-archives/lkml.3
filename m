Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaLHUMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:12:42 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46567 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaLHUMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:12:39 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 5/6] irqchip: GICv2m: Get rid of struct msi_controller
Date: Mon,  8 Dec 2014 20:12:22 +0000
Message-Id: <1418069543-21969-6-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
References: <1418069543-21969-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GICv2m only uses the msi_controller structure as a way to match
the PHB with its MSI HW, and thus the msi_domain. But now that
we can directly associate an msi_domain with a device, there is
no use keeping this msi_controller around.

Just remove all traces of msi_controller from the driver.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v2m.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index fdf7065..a76b802 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -45,7 +45,6 @@
 
 struct v2m_data {
 	spinlock_t msi_cnt_lock;
-	struct msi_controller mchip;
 	struct resource res;	/* GICv2m resource */
 	void __iomem *base;	/* GICv2m virt address */
 	u32 spi_start;		/* The SPI number that MSIs start */
@@ -218,6 +217,7 @@ static int __init gicv2m_init_one(struct device_node *node,
 {
 	int ret;
 	struct v2m_data *v2m;
+	struct irq_domain *inner_domain;
 
 	v2m = kzalloc(sizeof(struct v2m_data), GFP_KERNEL);
 	if (!v2m) {
@@ -261,19 +261,17 @@ static int __init gicv2m_init_one(struct device_node *node,
 		goto err_iounmap;
 	}
 
-	v2m->domain = irq_domain_add_tree(NULL, &gicv2m_domain_ops, v2m);
-	if (!v2m->domain) {
+	inner_domain = irq_domain_add_tree(NULL, &gicv2m_domain_ops, v2m);
+	if (!inner_domain) {
 		pr_err("Failed to create GICv2m domain\n");
 		ret = -ENOMEM;
 		goto err_free_bm;
 	}
 
-	v2m->domain->parent = parent;
-	v2m->mchip.of_node = node;
-	v2m->mchip.domain = pci_msi_create_irq_domain(node,
-						      &gicv2m_msi_domain_info,
-						      v2m->domain);
-	if (!v2m->mchip.domain) {
+	inner_domain->parent = parent;
+	v2m->domain = pci_msi_create_irq_domain(node, &gicv2m_msi_domain_info,
+						inner_domain);
+	if (!v2m->domain) {
 		pr_err("Failed to create MSI domain\n");
 		ret = -ENOMEM;
 		goto err_free_domains;
@@ -281,12 +279,6 @@ static int __init gicv2m_init_one(struct device_node *node,
 
 	spin_lock_init(&v2m->msi_cnt_lock);
 
-	ret = of_pci_msi_chip_add(&v2m->mchip);
-	if (ret) {
-		pr_err("Failed to add msi_chip.\n");
-		goto err_free_domains;
-	}
-
 	pr_info("Node %s: range[%#lx:%#lx], SPI[%d:%d]\n", node->name,
 		(unsigned long)v2m->res.start, (unsigned long)v2m->res.end,
 		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
@@ -294,10 +286,10 @@ static int __init gicv2m_init_one(struct device_node *node,
 	return 0;
 
 err_free_domains:
-	if (v2m->mchip.domain)
-		irq_domain_remove(v2m->mchip.domain);
 	if (v2m->domain)
 		irq_domain_remove(v2m->domain);
+	if (inner_domain)
+		irq_domain_remove(inner_domain);
 err_free_bm:
 	kfree(v2m->bm);
 err_iounmap:
-- 
2.1.3

