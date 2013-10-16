Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab3JPLAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:00:18 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38748 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760524Ab3JPLAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:00:15 -0400
From: Robert Richter <rric@kernel.org>
To: linux-edac@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH 3/5] edac, highbank: Add Calxeda ECX-2000 support
Date: Wed, 16 Oct 2013 12:59:36 +0200
Message-Id: <1381921178-28511-4-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381921178-28511-1-git-send-email-rric@kernel.org>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Implement edac support for Calxeda ECX-2000.

The ECX-2000 memory controller is similar to Highbank but has
different register bases for error and interrupt registers. There is
an own device tree name "calxeda,ecx-2000-ddr-ctrl" for identification
and initialization of the ECX-2000 and its base addresses.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 drivers/edac/highbank_mc_edac.c | 105 ++++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 35 deletions(-)

diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index 7a78307..79cb872 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -26,31 +26,40 @@
 #include "edac_module.h"
 
 /* DDR Ctrlr Error Registers */
-#define HB_DDR_ECC_OPT			0x128
-#define HB_DDR_ECC_U_ERR_ADDR		0x130
-#define HB_DDR_ECC_U_ERR_STAT		0x134
-#define HB_DDR_ECC_U_ERR_DATAL		0x138
-#define HB_DDR_ECC_U_ERR_DATAH		0x13c
-#define HB_DDR_ECC_C_ERR_ADDR		0x140
-#define HB_DDR_ECC_C_ERR_STAT		0x144
-#define HB_DDR_ECC_C_ERR_DATAL		0x148
-#define HB_DDR_ECC_C_ERR_DATAH		0x14c
-#define HB_DDR_ECC_INT_STATUS		0x180
-#define HB_DDR_ECC_INT_ACK		0x184
-#define HB_DDR_ECC_U_ERR_ID		0x424
-#define HB_DDR_ECC_C_ERR_ID		0x428
 
-#define HB_DDR_ECC_INT_STAT_CE		0x8
-#define HB_DDR_ECC_INT_STAT_DOUBLE_CE	0x10
-#define HB_DDR_ECC_INT_STAT_UE		0x20
-#define HB_DDR_ECC_INT_STAT_DOUBLE_UE	0x40
+#define HB_DDR_ECC_ERR_BASE		0x128
+#define MW_DDR_ECC_ERR_BASE		0x1b4
+
+#define HB_DDR_ECC_OPT			0x00
+#define HB_DDR_ECC_U_ERR_ADDR		0x08
+#define HB_DDR_ECC_U_ERR_STAT		0x0c
+#define HB_DDR_ECC_U_ERR_DATAL		0x10
+#define HB_DDR_ECC_U_ERR_DATAH		0x14
+#define HB_DDR_ECC_C_ERR_ADDR		0x18
+#define HB_DDR_ECC_C_ERR_STAT		0x1c
+#define HB_DDR_ECC_C_ERR_DATAL		0x20
+#define HB_DDR_ECC_C_ERR_DATAH		0x24
 
 #define HB_DDR_ECC_OPT_MODE_MASK	0x3
 #define HB_DDR_ECC_OPT_FWC		0x100
 #define HB_DDR_ECC_OPT_XOR_SHIFT	16
 
+/* DDR Ctrlr Interrupt Registers */
+
+#define HB_DDR_ECC_INT_BASE		0x180
+#define MW_DDR_ECC_INT_BASE		0x218
+
+#define HB_DDR_ECC_INT_STATUS		0x00
+#define HB_DDR_ECC_INT_ACK		0x04
+
+#define HB_DDR_ECC_INT_STAT_CE		0x8
+#define HB_DDR_ECC_INT_STAT_DOUBLE_CE	0x10
+#define HB_DDR_ECC_INT_STAT_UE		0x20
+#define HB_DDR_ECC_INT_STAT_DOUBLE_UE	0x40
+
 struct hb_mc_drvdata {
-	void __iomem *mc_vbase;
+	void __iomem *mc_err_base;
+	void __iomem *mc_int_base;
 };
 
 static irqreturn_t highbank_mc_err_handler(int irq, void *dev_id)
@@ -60,10 +69,10 @@ static irqreturn_t highbank_mc_err_handler(int irq, void *dev_id)
 	u32 status, err_addr;
 
 	/* Read the interrupt status register */
-	status = readl(drvdata->mc_vbase + HB_DDR_ECC_INT_STATUS);
+	status = readl(drvdata->mc_int_base + HB_DDR_ECC_INT_STATUS);
 
 	if (status & HB_DDR_ECC_INT_STAT_UE) {
-		err_addr = readl(drvdata->mc_vbase + HB_DDR_ECC_U_ERR_ADDR);
+		err_addr = readl(drvdata->mc_err_base + HB_DDR_ECC_U_ERR_ADDR);
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & ~PAGE_MASK, 0,
@@ -71,9 +80,9 @@ static irqreturn_t highbank_mc_err_handler(int irq, void *dev_id)
 				     mci->ctl_name, "");
 	}
 	if (status & HB_DDR_ECC_INT_STAT_CE) {
-		u32 syndrome = readl(drvdata->mc_vbase + HB_DDR_ECC_C_ERR_STAT);
+		u32 syndrome = readl(drvdata->mc_err_base + HB_DDR_ECC_C_ERR_STAT);
 		syndrome = (syndrome >> 8) & 0xff;
-		err_addr = readl(drvdata->mc_vbase + HB_DDR_ECC_C_ERR_ADDR);
+		err_addr = readl(drvdata->mc_err_base + HB_DDR_ECC_C_ERR_ADDR);
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
 				     err_addr >> PAGE_SHIFT,
 				     err_addr & ~PAGE_MASK, syndrome,
@@ -82,7 +91,7 @@ static irqreturn_t highbank_mc_err_handler(int irq, void *dev_id)
 	}
 
 	/* clear the error, clears the interrupt */
-	writel(status, drvdata->mc_vbase + HB_DDR_ECC_INT_ACK);
+	writel(status, drvdata->mc_int_base + HB_DDR_ECC_INT_ACK);
 	return IRQ_HANDLED;
 }
 
@@ -104,10 +113,10 @@ static ssize_t highbank_mc_err_inject_write(struct file *file,
 	buf[buf_size] = 0;
 
 	if (!kstrtou8(buf, 16, &synd)) {
-		reg = readl(pdata->mc_vbase + HB_DDR_ECC_OPT);
+		reg = readl(pdata->mc_err_base + HB_DDR_ECC_OPT);
 		reg &= HB_DDR_ECC_OPT_MODE_MASK;
 		reg |= (synd << HB_DDR_ECC_OPT_XOR_SHIFT) | HB_DDR_ECC_OPT_FWC;
-		writel(reg, pdata->mc_vbase + HB_DDR_ECC_OPT);
+		writel(reg, pdata->mc_err_base + HB_DDR_ECC_OPT);
 	}
 
 	return count;
@@ -131,17 +140,46 @@ static void highbank_mc_create_debugfs_nodes(struct mem_ctl_info *mci)
 {}
 #endif
 
+struct hb_mc_settings {
+	int	err_offset;
+	int	int_offset;
+};
+
+static struct hb_mc_settings hb_settings = {
+	.err_offset = HB_DDR_ECC_ERR_BASE,
+	.int_offset = HB_DDR_ECC_INT_BASE,
+};
+
+static struct hb_mc_settings mw_settings = {
+	.err_offset = MW_DDR_ECC_ERR_BASE,
+	.int_offset = MW_DDR_ECC_INT_BASE,
+};
+
+static struct of_device_id hb_ddr_ctrl_of_match[] = {
+	{ .compatible = "calxeda,hb-ddr-ctrl",		.data = &hb_settings },
+	{ .compatible = "calxeda,ecx-2000-ddr-ctrl",	.data = &mw_settings },
+	{},
+};
+MODULE_DEVICE_TABLE(of, hb_ddr_ctrl_of_match);
+
 static int highbank_mc_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *id;
+	const struct hb_mc_settings *settings;
 	struct edac_mc_layer layers[2];
 	struct mem_ctl_info *mci;
 	struct hb_mc_drvdata *drvdata;
 	struct dimm_info *dimm;
 	struct resource *r;
+	void __iomem *base;
 	u32 control;
 	int irq;
 	int res = 0;
 
+	id = of_match_device(hb_ddr_ctrl_of_match, &pdev->dev);
+	if (!id)
+		return -ENODEV;
+
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = 1;
 	layers[0].is_virt_csrow = true;
@@ -174,15 +212,18 @@ static int highbank_mc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	drvdata->mc_vbase = devm_ioremap(&pdev->dev,
-					  r->start, resource_size(r));
-	if (!drvdata->mc_vbase) {
+	base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
+	if (!base) {
 		dev_err(&pdev->dev, "Unable to map regs\n");
 		res = -ENOMEM;
 		goto err;
 	}
 
-	control = readl(drvdata->mc_vbase + HB_DDR_ECC_OPT) & 0x3;
+	settings = id->data;
+	drvdata->mc_err_base = base + settings->err_offset;
+	drvdata->mc_int_base = base + settings->int_offset;
+
+	control = readl(drvdata->mc_err_base + HB_DDR_ECC_OPT) & 0x3;
 	if (!control || (control == 0x2)) {
 		dev_err(&pdev->dev, "No ECC present, or ECC disabled\n");
 		res = -ENODEV;
@@ -238,12 +279,6 @@ static int highbank_mc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id hb_ddr_ctrl_of_match[] = {
-	{ .compatible = "calxeda,hb-ddr-ctrl", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, hb_ddr_ctrl_of_match);
-
 static struct platform_driver highbank_mc_edac_driver = {
 	.probe = highbank_mc_probe,
 	.remove = highbank_mc_remove,
-- 
1.8.4.rc3

