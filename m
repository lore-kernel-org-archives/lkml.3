Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab3GLLcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:32:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51891 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3GLLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:32:07 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] MFD: twl6040: Remove support for legacy (pdata) mode
Date: Fri, 12 Jul 2013 13:32:02 +0200
Message-ID: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL6040 is used only with OMAP4/5 SoCs and they can only boot in in DT mode.
The support for pdata/legacy boot can be removed.

Add TODO comment to the header file that all pdata struct can be removed in
the next merge window (after the sub driver updates are in).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040.c       | 55 +++++++++++----------------------------------
 include/linux/mfd/twl6040.h |  1 +
 2 files changed, 14 insertions(+), 42 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 492ee2c..a4034ed 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -44,17 +44,12 @@
 #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
 #define TWL6040_NUM_SUPPLIES	(2)
 
-static bool twl6040_has_vibra(struct twl6040_platform_data *pdata,
-			      struct device_node *node)
+static bool twl6040_has_vibra(struct device_node *node)
 {
-	if (pdata && pdata->vibra)
-		return true;
-
 #ifdef CONFIG_OF
 	if (of_find_node_by_name(node, "vibra"))
 		return true;
 #endif
-
 	return false;
 }
 
@@ -520,14 +515,13 @@ static struct regmap_irq_chip twl6040_irq_chip = {
 static int twl6040_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
-	struct twl6040_platform_data *pdata = client->dev.platform_data;
 	struct device_node *node = client->dev.of_node;
 	struct twl6040 *twl6040;
 	struct mfd_cell *cell = NULL;
 	int irq, ret, children = 0;
 
-	if (!pdata && !node) {
-		dev_err(&client->dev, "Platform data is missing\n");
+	if (!node) {
+		dev_err(&client->dev, "of node is missing\n");
 		return -EINVAL;
 	}
 
@@ -576,13 +570,10 @@ static int twl6040_probe(struct i2c_client *client,
 	twl6040->rev = twl6040_reg_read(twl6040, TWL6040_REG_ASICREV);
 
 	/* ERRATA: Automatic power-up is not possible in ES1.0 */
-	if (twl6040_get_revid(twl6040) > TWL6040_REV_ES1_0) {
-		if (pdata)
-			twl6040->audpwron = pdata->audpwron_gpio;
-		else
-			twl6040->audpwron = of_get_named_gpio(node,
-						"ti,audpwron-gpio", 0);
-	} else
+	if (twl6040_get_revid(twl6040) > TWL6040_REV_ES1_0)
+		twl6040->audpwron = of_get_named_gpio(node,
+						      "ti,audpwron-gpio", 0);
+	else
 		twl6040->audpwron = -EINVAL;
 
 	if (gpio_is_valid(twl6040->audpwron)) {
@@ -625,8 +616,6 @@ static int twl6040_probe(struct i2c_client *client,
 	/*
 	 * The main functionality of twl6040 to provide audio on OMAP4+ systems.
 	 * We can add the ASoC codec child whenever this driver has been loaded.
-	 * The ASoC codec can work without pdata, pass the platform_data only if
-	 * it has been provided.
 	 */
 	irq = regmap_irq_get_virq(twl6040->irq_data, TWL6040_IRQ_PLUG);
 	cell = &twl6040->cells[children];
@@ -635,13 +624,10 @@ static int twl6040_probe(struct i2c_client *client,
 	twl6040_codec_rsrc[0].end = irq;
 	cell->resources = twl6040_codec_rsrc;
 	cell->num_resources = ARRAY_SIZE(twl6040_codec_rsrc);
-	if (pdata && pdata->codec) {
-		cell->platform_data = pdata->codec;
-		cell->pdata_size = sizeof(*pdata->codec);
-	}
 	children++;
 
-	if (twl6040_has_vibra(pdata, node)) {
+	/* Vibra input driver support */
+	if (twl6040_has_vibra(node)) {
 		irq = regmap_irq_get_virq(twl6040->irq_data, TWL6040_IRQ_VIB);
 
 		cell = &twl6040->cells[children];
@@ -650,28 +636,13 @@ static int twl6040_probe(struct i2c_client *client,
 		twl6040_vibra_rsrc[0].end = irq;
 		cell->resources = twl6040_vibra_rsrc;
 		cell->num_resources = ARRAY_SIZE(twl6040_vibra_rsrc);
-
-		if (pdata && pdata->vibra) {
-			cell->platform_data = pdata->vibra;
-			cell->pdata_size = sizeof(*pdata->vibra);
-		}
 		children++;
 	}
 
-	/*
-	 * Enable the GPO driver in the following cases:
-	 * DT booted kernel or legacy boot with valid gpo platform_data
-	 */
-	if (!pdata || (pdata && pdata->gpo)) {
-		cell = &twl6040->cells[children];
-		cell->name = "twl6040-gpo";
-
-		if (pdata) {
-			cell->platform_data = pdata->gpo;
-			cell->pdata_size = sizeof(*pdata->gpo);
-		}
-		children++;
-	}
+	/* GPO support */
+	cell = &twl6040->cells[children];
+	cell->name = "twl6040-gpo";
+	children++;
 
 	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
 			      NULL, 0, NULL);
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 7e7fbce..6dd8893 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -185,6 +185,7 @@
 
 #define TWL6040_GPO_MAX	3
 
+/* TODO: All platform data struct can be removed */
 struct twl6040_codec_data {
 	u16 hs_left_step;
 	u16 hs_right_step;
-- 
1.8.2.1

