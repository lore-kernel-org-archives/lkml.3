Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaA1MVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:21:46 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26915 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbaA1MTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:11 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-f4-52e7a03ad19b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 10/18] mfd: max14577: Add detection of device type
Date: Tue, 28 Jan 2014 13:18:34 +0100
Message-id: <1390911522-28209-11-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xa7pWC54HGey/bmUx9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6Mn4t+shX816rY
	vKOFpYHxgHIXIyeHhICJxMnvR1kgbDGJC/fWs3UxcnEICSxllLi0HMbpY5KYuuADM0gVm4Cx
	xOblS8ASIgKrmSTWLJgK1s4s0MsocXO3B4gtLOAk8WrPKVYQm0VAVeLHpNWMIDavgIfEnB9L
	geo5gNYpSMyZZAMS5gQKv7rayARiCwm4S5w6/o5lAiPvAkaGVYyiqaXJBcVJ6blGesWJucWl
	eel6yfm5mxghofh1B+PSY1aHGAU4GJV4eB90PwsSYk0sK67MPcQowcGsJMKbOPt5kBBvSmJl
	VWpRfnxRaU5q8SFGJg5OqQbGAqMX83J0k6J0NMoZHR4a/PqSbj9f/MeUb9kVz1ewLdjRPy9S
	Jdj1T0gh9xdJvSN31FT6n9YeV2z85akW+WBv6TydBUy29p1Tcz4dYF07W60u6ZK87LmH2x9O
	2tO0/5i87oPOY3eU2w94H91fGxOf1vunWjDzk3DK7zkfGCMirWdNSwis7ctTYinOSDTUYi4q
	TgQAoGJThyMCAAA=
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
---
 drivers/mfd/max14577.c               |   61 +++++++++++++++++++++++-----------
 include/linux/mfd/max14577-private.h |   12 ++++---
 2 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 1d8104213b3e..224aba8c5b3f 100644
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
@@ -82,13 +91,32 @@ static const struct regmap_irq_chip max14577_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max14577_irqs),
 };
 
+static void max14577_print_dev_type(struct maxim_core *maxim_core)
+{
+	u8 reg_data, vendor_id, device_id;
+	int ret = max14577_read_reg(maxim_core->regmap_muic,
+			MAXIM_MUIC_REG_DEVICEID, &reg_data);
+	if (ret) {
+		dev_err(maxim_core->dev, "Failed to read DEVICEID register: %d\n",
+				ret);
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
@@ -121,19 +149,16 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = max14577_read_reg(maxim_core->regmap_muic,
-			MAXIM_MUIC_REG_DEVICEID, &reg_data);
-	if (ret) {
-		dev_err(maxim_core->dev, "Device not found on this channel: %d\n",
-				ret);
-		return ret;
+	if (np) {
+		const struct of_device_id *of_id =
+			of_match_device(max14577_dt_match, &i2c->dev);
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
@@ -172,7 +197,7 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id max14577_i2c_id[] = {
-	{ "max14577", 0 },
+	{ "max14577", MAXIM_DEVICE_TYPE_MAX14577, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
@@ -213,11 +238,6 @@ static int max14577_resume(struct device *dev)
 	return 0;
 }
 
-static struct of_device_id max14577_dt_match[] = {
-	{ .compatible = "maxim,max14577", },
-	{},
-};
-
 static SIMPLE_DEV_PM_OPS(max14577_pm, max14577_suspend, max14577_resume);
 
 static struct i2c_driver max14577_i2c_driver = {
@@ -234,6 +254,9 @@ static struct i2c_driver max14577_i2c_driver = {
 
 static int __init max14577_i2c_init(void)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(max14577_i2c_id) != MAXIM_DEVICE_TYPE_NUM);
+	BUILD_BUG_ON(ARRAY_SIZE(max14577_dt_match) != MAXIM_DEVICE_TYPE_NUM);
+
 	return i2c_add_driver(&max14577_i2c_driver);
 }
 subsys_initcall(max14577_i2c_init);
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 6cf417dc030c..814bf013d3e8 100644
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
@@ -253,15 +260,12 @@ enum maxim_irq {
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

