Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab3BZLxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:53:35 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62604 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3BZLxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:53:32 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kuninori.morimoto.gx@renesas.com, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Tue, 26 Feb 2013 20:59:13 +0900
Message-Id: <20130226115913.5630.4712.sendpatchset@w520>
In-Reply-To: <20130226115834.5630.45471.sendpatchset@w520>
References: <20130226115834.5630.45471.sendpatchset@w520>
Subject: [PATCH 04/05] irqchip: intc-irqpin: Make use of devm functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use devm_kzalloc(), devm_ioremap_nocache()
and devm_request_irq() to simplify error
handling.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Thanks to Kuninori Morimoto for this suggestion.

 drivers/irqchip/irq-renesas-intc-irqpin.c |   41 +++++++++--------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

--- 0007/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ work/drivers/irqchip/irq-renesas-intc-irqpin.c	2013-02-26 19:50:11.000000000 +0900
@@ -294,7 +294,7 @@ static int intc_irqpin_probe(struct plat
 	int ret;
 	int k;
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		ret = -ENOMEM;
@@ -316,7 +316,7 @@ static int intc_irqpin_probe(struct plat
 		if (!io[k]) {
 			dev_err(&pdev->dev, "not enough IOMEM resources\n");
 			ret = -EINVAL;
-			goto err1;
+			goto err0;
 		}
 	}
 
@@ -334,7 +334,7 @@ static int intc_irqpin_probe(struct plat
 	if (p->number_of_irqs < 1) {
 		dev_err(&pdev->dev, "not enough IRQ resources\n");
 		ret = -EINVAL;
-		goto err1;
+		goto err0;
 	}
 
 	/* ioremap IOMEM and setup read/write callbacks */
@@ -355,14 +355,15 @@ static int intc_irqpin_probe(struct plat
 		default:
 			dev_err(&pdev->dev, "IOMEM size mismatch\n");
 			ret = -EINVAL;
-			goto err2;
+			goto err0;
 		}
 
-		i->iomem = ioremap_nocache(io[k]->start, resource_size(io[k]));
+		i->iomem = devm_ioremap_nocache(&pdev->dev, io[k]->start,
+						resource_size(io[k]));
 		if (!i->iomem) {
 			dev_err(&pdev->dev, "failed to remap IOMEM\n");
 			ret = -ENXIO;
-			goto err2;
+			goto err0;
 		}
 	}
 
@@ -395,17 +396,17 @@ static int intc_irqpin_probe(struct plat
 	if (!p->irq_domain) {
 		ret = -ENXIO;
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
-		goto err2;
+		goto err0;
 	}
 
 	/* request and set priority on interrupts one by one */
 	for (k = 0; k < p->number_of_irqs; k++) {
-		if (request_irq(p->irq[k].requested_irq,
-				intc_irqpin_irq_handler,
-				0, name, &p->irq[k])) {
+		if (devm_request_irq(&pdev->dev, p->irq[k].requested_irq,
+				     intc_irqpin_irq_handler,
+				     0, name, &p->irq[k])) {
 			dev_err(&pdev->dev, "failed to request low IRQ\n");
 			ret = -ENOENT;
-			goto err3;
+			goto err1;
 		}
 		intc_irqpin_mask_unmask_prio(p, k, 0);
 	}
@@ -421,16 +422,8 @@ static int intc_irqpin_probe(struct plat
 
 	return 0;
 
-err3:
-	for (; k >= 0; k--)
-		free_irq(p->irq[k - 1].requested_irq, &p->irq[k - 1]);
-
-	irq_domain_remove(p->irq_domain);
-err2:
-	for (k = 0; k < INTC_IRQPIN_REG_NR; k++)
-		iounmap(p->iomem[k].iomem);
 err1:
-	kfree(p);
+	irq_domain_remove(p->irq_domain);
 err0:
 	return ret;
 }
@@ -438,17 +431,9 @@ err0:
 static int intc_irqpin_remove(struct platform_device *pdev)
 {
 	struct intc_irqpin_priv *p = platform_get_drvdata(pdev);
-	int k;
-
-	for (k = 0; k < p->number_of_irqs; k++)
-		free_irq(p->irq[k].requested_irq, &p->irq[k]);
 
 	irq_domain_remove(p->irq_domain);
 
-	for (k = 0; k < INTC_IRQPIN_REG_NR; k++)
-		iounmap(p->iomem[k].iomem);
-
-	kfree(p);
 	return 0;
 }
 
