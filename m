Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaDNJRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:17:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54678 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaDNJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:39 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b4-534ba7afecde
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 3/9] mfd: max14577: Add detection of device type
Date: Mon, 14 Apr 2014 11:17:14 +0200
Message-id: <1397467040-30502-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Fd31y72DDRpahC02zljPajH14RM2
	i+tfnrNavH5haHG26Q27xf2vRxktvl3pYLK4vGsOm8XaI3fZLW43rmCzON3N6sDtsXPWXXaP
	Tas62TzuXNvD5jHvZKBH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZXx69Y+1YJdWxaul3cwN
	jD+Uuhg5OSQETCQO3+hhgrDFJC7cW88GYgsJLGWUWDkppouRC8juY5JoXPuGHSTBJmAssXn5
	EjaQhIhAM5NES99ZRhCHWeAoo8T03rdAozg4hAWcJfaeFQIxWQRUJX7vBxvKK+Au0Tt7HtQy
	BYllX9Yyg9icAh4St7qPMUMsdpd48ek2+wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLz
	czcxQgLw6w7GpcesDjEKcDAq8fB2zPEOFmJNLCuuzD3EKMHBrCTCuy3DK1iINyWxsiq1KD++
	qDQntfgQIxMHp1QD4xx+m1eGi52d99q+qkipyL0hOr8sN7nCJO+nWMtNw+iQrbrd7u8urGxY
	vKOEz+PR2/p43qQtQU/uzbAzqXVPkDU6wGJeuferf8kbJiH284c27BF6f7P6/r2IUrn46Twx
	HIkfG6Tztmu7hQcKZF6sWv7pteMTp13y+n93r5OL4y0q6svf5Z6sxFKckWioxVxUnAgAVmps
	+h4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch continues the preparation for adding support for MAX77836
device to existing max14577 driver.

Add enum for types of devices supported by this driver. The device type
will be detected by matching of_device_id, or i2c_device_id as a
fallback.

The patch also moves to separate function the code related to displaying
DeviceID register values.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max14577.c               | 64 +++++++++++++++++++++++++-----------
 include/linux/mfd/max14577-private.h | 12 ++++---
 2 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index d180fae8e317..0e07ed74ab41 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/of_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max14577.h>
 #include <linux/mfd/max14577-private.h>
@@ -37,6 +38,14 @@ static struct mfd_cell max14577_devs[] = {
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
@@ -83,13 +92,34 @@ static const struct regmap_irq_chip max14577_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max14577_irqs),
 };
 
+static void max14577_print_dev_type(struct max14577 *max14577)
+{
+	u8 reg_data, vendor_id, device_id;
+	int ret;
+
+	ret = max14577_read_reg(max14577->regmap, MAX14577_REG_DEVICEID,
+			&reg_data);
+	if (ret) {
+		dev_err(max14577->dev,
+			"Failed to read DEVICEID register: %d\n", ret);
+		return;
+	}
+
+	vendor_id = ((reg_data & DEVID_VENDORID_MASK) >>
+				DEVID_VENDORID_SHIFT);
+	device_id = ((reg_data & DEVID_DEVICEID_MASK) >>
+				DEVID_DEVICEID_SHIFT);
+
+	dev_info(max14577->dev, "Device type: %u (ID: 0x%x, vendor: 0x%x)\n",
+			max14577->dev_type, device_id, vendor_id);
+}
+
 static int max14577_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct max14577 *max14577;
 	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
-	u8 reg_data;
 	int ret = 0;
 
 	if (np) {
@@ -122,19 +152,17 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = max14577_read_reg(max14577->regmap, MAX14577_REG_DEVICEID,
-			&reg_data);
-	if (ret) {
-		dev_err(max14577->dev, "Device not found on this channel: %d\n",
-				ret);
-		return ret;
+	if (np) {
+		const struct of_device_id *of_id;
+
+		of_id = of_match_device(max14577_dt_match, &i2c->dev);
+		if (of_id)
+			max14577->dev_type = (unsigned int)of_id->data;
+	} else {
+		max14577->dev_type = id->driver_data;
 	}
-	max14577->vendor_id = ((reg_data & DEVID_VENDORID_MASK) >>
-				DEVID_VENDORID_SHIFT);
-	max14577->device_id = ((reg_data & DEVID_DEVICEID_MASK) >>
-				DEVID_DEVICEID_SHIFT);
-	dev_info(max14577->dev, "Device ID: 0x%x, vendor: 0x%x\n",
-			max14577->device_id, max14577->vendor_id);
+
+	max14577_print_dev_type(max14577);
 
 	ret = regmap_add_irq_chip(max14577->regmap, max14577->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT, 0,
@@ -173,7 +201,7 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id max14577_i2c_id[] = {
-	{ "max14577", 0 },
+	{ "max14577", MAXIM_DEVICE_TYPE_MAX14577, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
@@ -216,11 +244,6 @@ static int max14577_resume(struct device *dev)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static struct of_device_id max14577_dt_match[] = {
-	{ .compatible = "maxim,max14577", },
-	{},
-};
-
 static SIMPLE_DEV_PM_OPS(max14577_pm, max14577_suspend, max14577_resume);
 
 static struct i2c_driver max14577_i2c_driver = {
@@ -237,6 +260,9 @@ static struct i2c_driver max14577_i2c_driver = {
 
 static int __init max14577_i2c_init(void)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(max14577_i2c_id) != MAXIM_DEVICE_TYPE_NUM);
+	BUILD_BUG_ON(ARRAY_SIZE(max14577_dt_match) != MAXIM_DEVICE_TYPE_NUM);
+
 	return i2c_add_driver(&max14577_i2c_driver);
 }
 subsys_initcall(max14577_i2c_init);
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 97b78d94f92f..1ce6f2952cc9 100644
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
 enum max14577_reg {
 	MAX14577_REG_DEVICEID		= 0x00,
@@ -271,15 +278,12 @@ enum max14577_irq {
 struct max14577 {
 	struct device *dev;
 	struct i2c_client *i2c; /* Slave addr = 0x4A */
+	enum maxim_device_type dev_type;
 
 	struct regmap *regmap;
 
 	struct regmap_irq_chip_data *irq_data;
 	int irq;
-
-	/* Device ID */
-	u8 vendor_id;	/* Vendor Identification */
-	u8 device_id;	/* Chip Version */
 };
 
 /* MAX14577 shared regmap API function */
-- 
1.8.3.2

