Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaBQJR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:17:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39974 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBQJGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:06:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-77-5301d1026495
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 05/15] mfd: max14577: Add detection of device type
Date: Mon, 17 Feb 2014 10:05:40 +0100
Message-id: <1392627950-26927-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xa7pMFxmDDc40C1hsnLGe1WLqwyds
	Fte/PGe1mPTkPbPFxJWTmS1evzC0ONv0ht3i/tejjBabHl9jtbi8aw6bxdojd9ktbjeuYLM4
	3c1qsX7GaxYHPo+ds+6ye2xeoeWxaVUnm8eda3vYPOadDPTYvKTeo2/LKkaPz5vkAjiiuGxS
	UnMyy1KL9O0SuDJ+zb7KVLBPu6J58yqmBsYvyl2MnBwSAiYSD+dtZoKwxSQu3FvP1sXIxSEk
	sJRRYv2NblYIp49JYvG6b2wgVWwCxhKbly8BqxIRaGGSeL9+PyOIwyxwiEliwY0bzCBVwgKu
	Eo+6P7OA2CwCqhKr1u4Fi/MKuEusW3oKqJsDaJ+CxJxJNiBhTgEPiZtLb7GD2EJAJU8e7WCZ
	wMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIyH7Zwbj4mNUhRgEORiUeXoNqxmAh
	1sSy4srcQ4wSHMxKIry264BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGJOzZWbUHVDtDEuIfODd
	/FqDvSyyW9HxosWEBTM3vTgvs9lwU2K076acbbf2O56Ye+Z1xv6SZeHHeeQ9tSbumDnjygTL
	1Tw/QnxFpyxgvDLHNean7Ovv0Vp/VHZqLlvUXpe0tODanwtf91oyvVrt5rXxh7/X2Znssy2j
	BB6KOXz83bbx1CzlN/+UWIozEg21mIuKEwEId1Z5NwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch continues the preparation for adding support for max77836
device to existing max14577 driver.

Add enum for types of devices supported by this driver. The device type
will be detected by matching of_device_id, or i2c_device_id as a
fallback.

The patch also moves to separate function the code related to displaying
DeviceID register values.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max14577.c               |   64 ++++++++++++++++++++++++----------
 include/linux/mfd/max14577-private.h |   12 ++++---
 2 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 449e025bd80d..772088cf3ab8 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/of_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max14577.h>
 #include <linux/mfd/max14577-private.h>
@@ -36,6 +37,14 @@ static struct mfd_cell max14577_devs[] = {
 	{ .name = "max14577-charger", },
 };
 
+static struct of_device_id max14577_dt_match[] = {
+	{
+		.compatible = "maxim,max14577",
+		.data = (void *)MAXIM_DEVICE_TYPE_MAX14577,
+	},
+	{},
+};
+
 static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -82,13 +91,34 @@ static const struct regmap_irq_chip max14577_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max14577_irqs),
 };
 
+static void max14577_print_dev_type(struct maxim_core *maxim_core)
+{
+	u8 reg_data, vendor_id, device_id;
+	int ret;
+
+	ret = max14577_read_reg(maxim_core->regmap_muic,
+			MAXIM_MUIC_REG_DEVICEID, &reg_data);
+	if (ret) {
+		dev_err(maxim_core->dev,
+			"Failed to read DEVICEID register: %d\n", ret);
+		return;
+	}
+
+	vendor_id = ((reg_data & MAXIM_DEVID_VENDORID_MASK) >>
+				MAXIM_DEVID_VENDORID_SHIFT);
+	device_id = ((reg_data & MAXIM_DEVID_DEVICEID_MASK) >>
+				MAXIM_DEVID_DEVICEID_SHIFT);
+
+	dev_info(maxim_core->dev, "Device type: %u (ID: 0x%x, vendor: 0x%x)\n",
+			maxim_core->dev_type, device_id, vendor_id);
+}
+
 static int max14577_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct maxim_core *maxim_core;
 	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
-	u8 reg_data;
 	int ret = 0;
 
 	if (np) {
@@ -121,19 +151,17 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = max14577_read_reg(maxim_core->regmap_muic,
-			MAXIM_MUIC_REG_DEVICEID, &reg_data);
-	if (ret) {
-		dev_err(maxim_core->dev, "Device not found on this channel: %d\n",
-				ret);
-		return ret;
+	if (np) {
+		const struct of_device_id *of_id;
+
+		of_id = of_match_device(max14577_dt_match, &i2c->dev);
+		if (of_id)
+			maxim_core->dev_type = (unsigned int)of_id->data;
+	} else {
+		maxim_core->dev_type = id->driver_data;
 	}
-	maxim_core->vendor_id = ((reg_data & MAXIM_DEVID_VENDORID_MASK) >>
-				MAXIM_DEVID_VENDORID_SHIFT);
-	maxim_core->device_id = ((reg_data & MAXIM_DEVID_DEVICEID_MASK) >>
-				MAXIM_DEVID_DEVICEID_SHIFT);
-	dev_info(maxim_core->dev, "Device ID: 0x%x, vendor: 0x%x\n",
-			maxim_core->device_id, maxim_core->vendor_id);
+
+	max14577_print_dev_type(maxim_core);
 
 	ret = regmap_add_irq_chip(maxim_core->regmap_muic, maxim_core->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT, 0,
@@ -172,7 +200,7 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id max14577_i2c_id[] = {
-	{ "max14577", 0 },
+	{ "max14577", MAXIM_DEVICE_TYPE_MAX14577, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
@@ -213,11 +241,6 @@ static int max14577_resume(struct device *dev)
 	return 0;
 }
 
-static struct of_device_id max14577_dt_match[] = {
-	{ .compatible = "maxim,max14577", },
-	{},
-};
-
 static SIMPLE_DEV_PM_OPS(max14577_pm, max14577_suspend, max14577_resume);
 
 static struct i2c_driver max14577_i2c_driver = {
@@ -234,6 +257,9 @@ static struct i2c_driver max14577_i2c_driver = {
 
 static int __init max14577_i2c_init(void)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(max14577_i2c_id) != MAXIM_DEVICE_TYPE_NUM);
+	BUILD_BUG_ON(ARRAY_SIZE(max14577_dt_match) != MAXIM_DEVICE_TYPE_NUM);
+
 	return i2c_add_driver(&max14577_i2c_driver);
 }
 subsys_initcall(max14577_i2c_init);
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index d69c56f02eac..afa4e525f9b7 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -22,6 +22,13 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 
+enum maxim_device_type {
+	MAXIM_DEVICE_TYPE_UNKNOWN	= 0,
+	MAXIM_DEVICE_TYPE_MAX14577,
+
+	MAXIM_DEVICE_TYPE_NUM,
+};
+
 /* Slave addr = 0x4A: MUIC and Charger */
 enum maxim_muic_reg {
 	MAXIM_MUIC_REG_DEVICEID			= 0x00,
@@ -250,15 +257,12 @@ enum maxim_irq {
 struct maxim_core {
 	struct device *dev;
 	struct i2c_client *i2c; /* Slave addr = 0x4A */
+	enum maxim_device_type dev_type;
 
 	struct regmap *regmap_muic;
 
 	struct regmap_irq_chip_data *irq_data_muic;
 	int irq;
-
-	/* Device ID */
-	u8 vendor_id;	/* Vendor Identification */
-	u8 device_id;	/* Chip Version */
 };
 
 /* MAX14577 shared regmap API function */
-- 
1.7.9.5

