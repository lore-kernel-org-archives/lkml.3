Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaKMPh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:37:57 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:46374 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753304AbaKMPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:37:32 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>, <srv_heupstream@mediatek.com>,
        <yingjoe.chen@gmail.com>, <hc.yen@mediatek.com>,
        <eddie.huang@mediatek.com>, <nathan.chung@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH v6 3/6] irqchip: gic: Support hierarchy irq domain.
Date: Thu, 13 Nov 2014 23:37:06 +0800
Message-ID: <1415893029-2971-4-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to use gic as a parent for stacked irq domain.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 drivers/irqchip/Kconfig   |  1 +
 drivers/irqchip/irq-gic.c | 80 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b21f12f..7f34138 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -5,6 +5,7 @@ config IRQCHIP
 config ARM_GIC
 	bool
 	select IRQ_DOMAIN
+	select IRQ_DOMAIN_HIERARCHY
 	select MULTI_IRQ_HANDLER
 
 config GIC_NON_BANKED
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 38493ff..fe9ab93 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -788,17 +788,16 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 {
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_percpu_devid_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_percpu_devid_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	} else {
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_fasteoi_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_fasteoi_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 
 		gic_routable_irq_domain_ops->map(d, irq, hw);
 	}
-	irq_set_chip_data(irq, d->host_data);
 	return 0;
 }
 
@@ -814,8 +813,6 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 {
 	unsigned long ret = 0;
 
-	if (d->of_node != controller)
-		return -EINVAL;
 	if (intsize < 3)
 		return -EINVAL;
 
@@ -858,6 +855,31 @@ static struct notifier_block gic_cpu_notifier = {
 };
 #endif
 
+static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;
+	struct of_phandle_args *irq_data = arg;
+
+	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
+				   irq_data->args_count, &hwirq, &type);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++)
+		gic_irq_domain_map(domain, virq+i, hwirq+i);
+
+	return 0;
+}
+
+static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
+	.xlate = gic_irq_domain_xlate,
+	.alloc = gic_irq_domain_alloc,
+	.free = irq_domain_free_irqs_top,
+};
+
 static const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
 	.unmap = gic_irq_domain_unmap,
@@ -948,18 +970,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		gic_cpu_map[i] = 0xff;
 
 	/*
-	 * For primary GICs, skip over SGIs.
-	 * For secondary GICs, skip over PPIs, too.
-	 */
-	if (gic_nr == 0 && (irq_start & 31) > 0) {
-		hwirq_base = 16;
-		if (irq_start != -1)
-			irq_start = (irq_start & ~31) + 16;
-	} else {
-		hwirq_base = 32;
-	}
-
-	/*
 	 * Find out how many interrupts are supported.
 	 * The GIC only supports up to 1020 interrupt sources.
 	 */
@@ -969,10 +979,32 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		gic_irqs = 1020;
 	gic->gic_irqs = gic_irqs;
 
-	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
+	if (node) {		/* DT case */
+		const struct irq_domain_ops *ops =
+					&gic_irq_domain_hierarchy_ops;
+
+		if (!of_property_read_u32(node, "arm,routable-irqs",
+					  &nr_routable_irqs)) {
+			ops = &gic_irq_domain_ops;
+			gic_irqs = nr_routable_irqs;
+		}
+
+		gic->domain = irq_domain_add_linear(node, gic_irqs, ops, gic);
+	} else {		/* Non-DT case */
+		/*
+		 * For primary GICs, skip over SGIs.
+		 * For secondary GICs, skip over PPIs, too.
+		 */
+		if (gic_nr == 0 && (irq_start & 31) > 0) {
+			hwirq_base = 16;
+			if (irq_start != -1)
+				irq_start = (irq_start & ~31) + 16;
+		} else {
+			hwirq_base = 32;
+		}
+
+		gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
 
-	if (of_property_read_u32(node, "arm,routable-irqs",
-				 &nr_routable_irqs)) {
 		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
 					   numa_node_id());
 		if (IS_ERR_VALUE(irq_base)) {
@@ -983,10 +1015,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 
 		gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
 					hwirq_base, &gic_irq_domain_ops, gic);
-	} else {
-		gic->domain = irq_domain_add_linear(node, nr_routable_irqs,
-						    &gic_irq_domain_ops,
-						    gic);
 	}
 
 	if (WARN_ON(!gic->domain))
-- 
1.8.1.1.dirty

