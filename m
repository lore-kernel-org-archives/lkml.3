Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab3FQMQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:16:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46622 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab3FQMQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:16:55 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <gg@slimlogic.co.uk>
Subject: [PATCH 1/4] MFD: Palmas: Add Interrupt feature
Date: Mon, 17 Jun 2013 17:39:11 +0530
Message-ID: <1371470954-9124-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
References: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas PMICs have an INT line. This line is one single
Interrupt line to the application processor. The interrupt
feature enables to selectively request irq for only those
specific chips which have INT line connected to a valid
IRQ line of the application processor.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 drivers/mfd/palmas.c       |   32 +++++++++++++++++++++++++-------
 include/linux/mfd/palmas.h |   14 ++++++++++++++
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 62fa728..d06ce62 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -231,6 +231,16 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
 		palmas_set_pdata_irq_flag(i2c, pdata);
 }
 
+static unsigned int palmas_features = PALMAS_PMIC_FEATURE_INTERRUPT;
+
+static const struct of_device_id of_palmas_match_tbl[] = {
+	{
+		.compatible = "ti,palmas",
+		.data = &palmas_features,
+	},
+	{ },
+};
+
 static int palmas_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -238,8 +248,9 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	struct palmas_platform_data *pdata;
 	struct device_node *node = i2c->dev.of_node;
 	int ret = 0, i;
-	unsigned int reg, addr;
+	unsigned int reg, addr, *features;
 	int slave;
+	const struct of_device_id *match;
 
 	pdata = dev_get_platdata(&i2c->dev);
 
@@ -261,9 +272,17 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, palmas);
 	palmas->dev = &i2c->dev;
-	palmas->id = id->driver_data;
 	palmas->irq = i2c->irq;
 
+	match = of_match_device(of_match_ptr(of_palmas_match_tbl), &i2c->dev);
+
+	if (match) {
+		features = (unsigned int *)match->data;
+		palmas->features = *features;
+	} else {
+		return -ENODATA;
+	}
+
 	for (i = 0; i < PALMAS_NUM_CLIENTS; i++) {
 		if (i == 0)
 			palmas->i2c_clients[i] = i2c;
@@ -290,6 +309,9 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
+	if (!PALMAS_PMIC_HAS(palmas, INTERRUPT))
+		goto no_int;
+
 	/* Change interrupt line output polarity */
 	if (pdata->irq_flags & IRQ_TYPE_LEVEL_HIGH)
 		reg = PALMAS_POLARITY_CTRL_INT_POLARITY;
@@ -316,6 +338,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
+no_int:
 	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
 	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
 			PALMAS_PRIMARY_SECONDARY_PAD1);
@@ -427,11 +450,6 @@ static const struct i2c_device_id palmas_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, palmas_i2c_id);
 
-static struct of_device_id of_palmas_match_tbl[] = {
-	{ .compatible = "ti,palmas", },
-	{ /* end */ }
-};
-
 static struct i2c_driver palmas_i2c_driver = {
 	.driver = {
 		   .name = "palmas",
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 8f21daf..1b5b5f3 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -32,6 +32,19 @@
 			((a) == PALMAS_CHIP_ID))
 #define is_palmas_charger(a) ((a) == PALMAS_CHIP_CHARGER_ID)
 
+/**
+ * DOC: Palmas PMIC feature types
+ *
+ * PALMAS_PMIC_FEATURE_INTERRUPT - used when the PMIC has Interrupt line going
+ *	to an application processor.
+ *
+ * PALMAS_PMIC_HAS(b, f) - macro to check if a bandgap device is capable of a
+ *	specific feature (above) or not. Return non-zero, if yes.
+ */
+#define PALMAS_PMIC_FEATURE_INTERRUPT	BIT(0)
+#define PALMAS_PMIC_HAS(b, f)			\
+			((b)->features & PALMAS_PMIC_FEATURE_ ## f)
+
 struct palmas_pmic;
 struct palmas_gpadc;
 struct palmas_resource;
@@ -46,6 +59,7 @@ struct palmas {
 	/* Stored chip id */
 	int id;
 
+	unsigned int features;
 	/* IRQ Data */
 	int irq;
 	u32 irq_mask;
-- 
1.7.5.4

