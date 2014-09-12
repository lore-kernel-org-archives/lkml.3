Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaILNQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:16:32 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:36613 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaILNP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:15:26 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/4] irqchip: renesas-intc-irqpin: Add helper variable dev = &pdev->dev
Date: Fri, 12 Sep 2014 15:15:17 +0200
Message-Id: <1410527720-18061-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
References: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/irqchip/irq-renesas-intc-irqpin.c | 45 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-intc-irqpin.c b/drivers/irqchip/irq-renesas-intc-irqpin.c
index a9efceb0c4a0..a6b205b72c9b 100644
--- a/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ b/drivers/irqchip/irq-renesas-intc-irqpin.c
@@ -329,7 +329,8 @@ static struct irq_domain_ops intc_irqpin_irq_domain_ops = {
 
 static int intc_irqpin_probe(struct platform_device *pdev)
 {
-	struct renesas_intc_irqpin_config *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct renesas_intc_irqpin_config *pdata = dev->platform_data;
 	struct intc_irqpin_priv *p;
 	struct intc_irqpin_iomem *i;
 	struct resource *io[INTC_IRQPIN_REG_NR];
@@ -337,14 +338,14 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	struct irq_chip *irq_chip;
 	void (*enable_fn)(struct irq_data *d);
 	void (*disable_fn)(struct irq_data *d);
-	const char *name = dev_name(&pdev->dev);
+	const char *name = dev_name(dev);
 	int ref_irq;
 	int ret;
 	int k;
 
-	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+		dev_err(dev, "failed to allocate driver data\n");
 		ret = -ENOMEM;
 		goto err0;
 	}
@@ -353,9 +354,9 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	if (pdata) {
 		memcpy(&p->config, pdata, sizeof(*pdata));
 	} else {
-		of_property_read_u32(pdev->dev.of_node, "sense-bitfield-width",
+		of_property_read_u32(dev->of_node, "sense-bitfield-width",
 				     &p->config.sense_bitfield_width);
-		p->config.control_parent = of_property_read_bool(pdev->dev.of_node,
+		p->config.control_parent = of_property_read_bool(dev->of_node,
 								 "control-parent");
 	}
 	if (!p->config.sense_bitfield_width)
@@ -368,7 +369,7 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	for (k = 0; k < INTC_IRQPIN_REG_NR; k++) {
 		io[k] = platform_get_resource(pdev, IORESOURCE_MEM, k);
 		if (!io[k]) {
-			dev_err(&pdev->dev, "not enough IOMEM resources\n");
+			dev_err(dev, "not enough IOMEM resources\n");
 			ret = -EINVAL;
 			goto err0;
 		}
@@ -386,7 +387,7 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 
 	p->number_of_irqs = k;
 	if (p->number_of_irqs < 1) {
-		dev_err(&pdev->dev, "not enough IRQ resources\n");
+		dev_err(dev, "not enough IRQ resources\n");
 		ret = -EINVAL;
 		goto err0;
 	}
@@ -407,15 +408,15 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 			i->write = intc_irqpin_write32;
 			break;
 		default:
-			dev_err(&pdev->dev, "IOMEM size mismatch\n");
+			dev_err(dev, "IOMEM size mismatch\n");
 			ret = -EINVAL;
 			goto err0;
 		}
 
-		i->iomem = devm_ioremap_nocache(&pdev->dev, io[k]->start,
+		i->iomem = devm_ioremap_nocache(dev, io[k]->start,
 						resource_size(io[k]));
 		if (!i->iomem) {
-			dev_err(&pdev->dev, "failed to remap IOMEM\n");
+			dev_err(dev, "failed to remap IOMEM\n");
 			ret = -ENXIO;
 			goto err0;
 		}
@@ -457,34 +458,32 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	irq_chip->irq_set_type = intc_irqpin_irq_set_type;
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
 
-	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
+	p->irq_domain = irq_domain_add_simple(dev->of_node,
 					      p->number_of_irqs,
 					      p->config.irq_base,
 					      &intc_irqpin_irq_domain_ops, p);
 	if (!p->irq_domain) {
 		ret = -ENXIO;
-		dev_err(&pdev->dev, "cannot initialize irq domain\n");
+		dev_err(dev, "cannot initialize irq domain\n");
 		goto err0;
 	}
 
 	if (p->shared_irqs) {
 		/* request one shared interrupt */
-		if (devm_request_irq(&pdev->dev, p->irq[0].requested_irq,
+		if (devm_request_irq(dev, p->irq[0].requested_irq,
 				intc_irqpin_shared_irq_handler,
 				IRQF_SHARED, name, p)) {
-			dev_err(&pdev->dev, "failed to request low IRQ\n");
+			dev_err(dev, "failed to request low IRQ\n");
 			ret = -ENOENT;
 			goto err1;
 		}
 	} else {
 		/* request interrupts one by one */
 		for (k = 0; k < p->number_of_irqs; k++) {
-			if (devm_request_irq(&pdev->dev,
-					p->irq[k].requested_irq,
-					intc_irqpin_irq_handler,
-					0, name, &p->irq[k])) {
-				dev_err(&pdev->dev,
-					"failed to request low IRQ\n");
+			if (devm_request_irq(dev, p->irq[k].requested_irq,
+					     intc_irqpin_irq_handler, 0, name,
+					     &p->irq[k])) {
+				dev_err(dev, "failed to request low IRQ\n");
 				ret = -ENOENT;
 				goto err1;
 			}
@@ -495,12 +494,12 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	for (k = 0; k < p->number_of_irqs; k++)
 		intc_irqpin_mask_unmask_prio(p, k, 0);
 
-	dev_info(&pdev->dev, "driving %d irqs\n", p->number_of_irqs);
+	dev_info(dev, "driving %d irqs\n", p->number_of_irqs);
 
 	/* warn in case of mismatch if irq base is specified */
 	if (p->config.irq_base) {
 		if (p->config.irq_base != p->irq[0].domain_irq)
-			dev_warn(&pdev->dev, "irq base mismatch (%d/%d)\n",
+			dev_warn(dev, "irq base mismatch (%d/%d)\n",
 				 p->config.irq_base, p->irq[0].domain_irq);
 	}
 
-- 
1.9.1

