Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaFDLjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:39:01 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58916 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaFDLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:08 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 06/21] mpc85xx_edac: use devm_irq_of_parse_and_map()
Date: Wed,  4 Jun 2014 15:13:06 +0400
Message-Id: <1401880402-30091-7-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids calls to irq_dispose_mapping() while IRQ handler is still
installed.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/edac/mpc85xx_edac.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index f4aec2e..a8b78d2 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -354,7 +354,15 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
 	}
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
-		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
+		pdata->irq = devm_irq_of_parse_and_map(&op->dev,
+				op->dev.of_node, 0);
+		if (pdata->irq <= 0) {
+			printk(KERN_ERR
+			       "%s: Unable to locate irq for MPC85xx PCI err\n",
+			       __func__);
+			res = -ENODEV;
+			goto err2;
+		}
 		res = devm_request_irq(&op->dev, pdata->irq,
 				       mpc85xx_pci_isr,
 				       IRQF_SHARED,
@@ -363,7 +371,6 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
 			printk(KERN_ERR
 			       "%s: Unable to request irq %d for "
 			       "MPC85xx PCI err\n", __func__, pdata->irq);
-			irq_dispose_mapping(pdata->irq);
 			res = -ENODEV;
 			goto err2;
 		}
@@ -631,7 +638,15 @@ static int mpc85xx_l2_err_probe(struct platform_device *op)
 	}
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
-		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
+		pdata->irq = devm_irq_of_parse_and_map(&op->dev,
+				op->dev.of_node, 0);
+		if (pdata->irq <= 0) {
+			printk(KERN_ERR
+			       "%s: Unable to locate irq for MPC85xx L2 err\n",
+			       __func__);
+			res = -ENODEV;
+			goto err2;
+		}
 		res = devm_request_irq(&op->dev, pdata->irq,
 				       mpc85xx_l2_isr, 0,
 				       "[EDAC] L2 err", edac_dev);
@@ -639,7 +654,6 @@ static int mpc85xx_l2_err_probe(struct platform_device *op)
 			printk(KERN_ERR
 			       "%s: Unable to request irq %d for "
 			       "MPC85xx L2 err\n", __func__, pdata->irq);
-			irq_dispose_mapping(pdata->irq);
 			res = -ENODEV;
 			goto err2;
 		}
@@ -674,10 +688,8 @@ static int mpc85xx_l2_err_remove(struct platform_device *op)
 
 	edac_dbg(0, "\n");
 
-	if (edac_op_state == EDAC_OPSTATE_INT) {
+	if (edac_op_state == EDAC_OPSTATE_INT)
 		out_be32(pdata->l2_vbase + MPC85XX_L2_ERRINTEN, 0);
-		irq_dispose_mapping(pdata->irq);
-	}
 
 	out_be32(pdata->l2_vbase + MPC85XX_L2_ERRDIS, orig_l2_err_disable);
 	edac_device_del_device(&op->dev);
@@ -1130,7 +1142,15 @@ static int mpc85xx_mc_err_probe(struct platform_device *op)
 		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_SBE, 0x10000);
 
 		/* register interrupts */
-		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
+		pdata->irq = devm_irq_of_parse_and_map(&op->dev,
+				op->dev.of_node, 0);
+		if (pdata->irq <= 0) {
+			printk(KERN_ERR
+			       "%s: Unable to locate irq for MPC85xx DRAM ERR\n",
+			       __func__);
+			res = -ENODEV;
+			goto err2;
+		}
 		res = devm_request_irq(&op->dev, pdata->irq,
 				       mpc85xx_mc_isr,
 				       IRQF_SHARED,
@@ -1138,7 +1158,6 @@ static int mpc85xx_mc_err_probe(struct platform_device *op)
 		if (res < 0) {
 			printk(KERN_ERR "%s: Unable to request irq %d for "
 			       "MPC85xx DRAM ERR\n", __func__, pdata->irq);
-			irq_dispose_mapping(pdata->irq);
 			res = -ENODEV;
 			goto err2;
 		}
@@ -1168,10 +1187,8 @@ static int mpc85xx_mc_err_remove(struct platform_device *op)
 
 	edac_dbg(0, "\n");
 
-	if (edac_op_state == EDAC_OPSTATE_INT) {
+	if (edac_op_state == EDAC_OPSTATE_INT)
 		out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_INT_EN, 0);
-		irq_dispose_mapping(pdata->irq);
-	}
 
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DISABLE,
 		 orig_ddr_err_disable);
-- 
1.7.10.4

