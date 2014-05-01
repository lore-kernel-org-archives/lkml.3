Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaEAKJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:09:44 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35233 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaEAJ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/47] mtd: nand: stm_nand_bch: IRQ support for ST's BCH NAND Controller driver
Date: Thu,  1 May 2014 10:56:13 +0100
Message-Id: <1398938214-17847-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obtain IRQ number and request IRQ resource via the usual methods. We're
also registering an IRQ handler to inform us of any completed tasks.
Notice that we're starting to make use of the device struct that we
defined before. In keeping with the subject of the patch, we're also
adding the related local enable_irq() and disable_irq() methods. Again,
these will be utilised in a greater capacity in latter commits.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 2d6a81f..d73568c 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -15,11 +15,14 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/completion.h>
 #include <linux/mtd/stm_nand.h>
 
+#include "stm_nand_regs.h"
+
 /* NANDi Controller (Hamming/BCH) */
 struct nandi_controller {
 	void __iomem		*base;		/* Controller base*/
@@ -221,6 +224,51 @@ const struct nand_timing_spec st_nand_onfi_timing_specs[] = {
 	}
 };
 
+/*
+ * NANDi Interrupts (shared by Hamming and BCH controllers)
+ */
+static irqreturn_t nandi_irq_handler(int irq, void *dev)
+{
+	struct nandi_controller *nandi = dev;
+	unsigned int status;
+
+	status = readl(nandi->base + NANDBCH_INT_STA);
+
+	if (status & NANDBCH_INT_SEQNODESOVER) {
+		/* BCH */
+		writel(NANDBCH_INT_CLR_SEQNODESOVER,
+		       nandi->base + NANDBCH_INT_CLR);
+		complete(&nandi->seq_completed);
+	}
+	if (status & NAND_INT_RBN) {
+		/* Hamming */
+		writel(NAND_INT_CLR_RBN, nandi->base + NANDHAM_INT_CLR);
+		complete(&nandi->rbn_completed);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void nandi_enable_interrupts(struct nandi_controller *nandi,
+				    uint32_t irqs)
+{
+	uint32_t val;
+
+	val = readl(nandi->base + NANDBCH_INT_EN);
+	val |= irqs;
+	writel(val, nandi->base + NANDBCH_INT_EN);
+}
+
+static void nandi_disable_interrupts(struct nandi_controller *nandi,
+				     uint32_t irqs)
+{
+	uint32_t val;
+
+	val = readl(nandi->base + NANDBCH_INT_EN);
+	val &= ~irqs;
+	writel(val, nandi->base + NANDBCH_INT_EN);
+}
+
 static int remap_named_resource(struct platform_device *pdev,
 				char *name,
 				void __iomem **io_ptr)
@@ -252,6 +300,7 @@ static struct nandi_controller *
 nandi_init_resources(struct platform_device *pdev)
 {
 	struct nandi_controller *nandi;
+	int irq;
 	int err;
 
 	nandi = devm_kzalloc(&pdev->dev, sizeof(*nandi), GFP_KERNEL);
@@ -271,6 +320,19 @@ nandi_init_resources(struct platform_device *pdev)
 	if (err)
 		return ERR_PTR(err);
 
+	irq = platform_get_irq_byname(pdev, "nand_irq");
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to find IRQ resource\n");
+		return ERR_PTR(irq);
+	}
+
+	err = devm_request_irq(&pdev->dev, irq, nandi_irq_handler,
+			       IRQF_DISABLED, dev_name(&pdev->dev), nandi);
+	if (err) {
+		dev_err(&pdev->dev, "irq request failed\n");
+		return ERR_PTR(err);
+	}
+
 	platform_set_drvdata(pdev, nandi);
 
 	return nandi;
-- 
1.8.3.2

