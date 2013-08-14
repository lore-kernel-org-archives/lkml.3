Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab3HNIaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:30:23 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:47335 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759410Ab3HNIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:30:19 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 3/4] mfd: 88pm800: add device tree support
Date: Wed, 14 Aug 2013 04:28:49 -0400
Message-ID: <1376468930-9794-4-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 Documentation/devicetree/bindings/mfd/88pm800.c |   55 +++++++++++++++++++++++
 drivers/mfd/88pm800.c                           |   55 +++++++++++++++++++++++
 2 files changed, 110 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/88pm800.c

diff --git a/Documentation/devicetree/bindings/mfd/88pm800.c b/Documentation/devicetree/bindings/mfd/88pm800.c
new file mode 100644
index 0000000..2299752
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/88pm800.c
@@ -0,0 +1,55 @@
+* Marvell 88PM800 Power Management IC
+
+Required parent device properties:
+- compatible : "marvell,88pm800"
+- reg : the I2C slave address for the 88pm800 chip
+- interrupts : IRQ line for the 88pm800 chip
+- interrupt-controller: describes the 88pm800 as an interrupt controller (has its own domain)
+- #interrupt-cells : should be 1.
+		- The cell is the 88pm800 local IRQ number
+
+Optional parent device properties:
+- marvell,88pm800-irq-write-clear: inicates whether interrupt status is cleared by write
+- marvell,88pm800-battery-detection: indicats whether need 88pm800 to support battery
+				detection or not.
+
+88pm800 consists of a large and varied group of sub-devices:
+
+Device			 Supply Names	 Description
+------			 ------------	 -----------
+88pm80x-onkey		:		: On key
+88pm80x-rtc		:		: RTC
+88pm80x-regulator	:		: Regulators
+
+Example:
+
+	pmic: 88pm800@30 {
+		compatible = "marvell,88pm800";
+		reg = <0x30>;
+		interrupts = <0 4 0x4>;
+		interrupt-parent = <&gic>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+
+		marvell,88pm800-irq-write-clr;
+
+		regulators {
+			compatible = "marvell,88pm80x-regulator";
+
+			BUCK1 {
+				regulator-min-microvolt = <600000>;
+				regulator-max-microvolt = <3950000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO1 {
+				regulator-min-microvolt = <600000>;
+				regulator-max-microvolt = <3950000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+		};
+		rtc {
+			compatible = "marvell,88pm80x-rtc";
+		};
+	};
diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index d4d272f..07a24e2 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/88pm80x.h>
 #include <linux/slab.h>
+#include <linux/of_device.h>
 
 /* Interrupt Registers */
 #define PM800_INT_STATUS1		(0x05)
@@ -121,6 +122,12 @@ static const struct i2c_device_id pm80x_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, pm80x_id_table);
 
+static const struct of_device_id pm80x_dt_ids[] = {
+	{ .compatible = "marvell,88pm800", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pm80x_dt_ids);
+
 static struct resource rtc_resources[] = {
 	{
 	 .name = "88pm80x-rtc",
@@ -133,6 +140,7 @@ static struct resource rtc_resources[] = {
 static struct mfd_cell rtc_devs[] = {
 	{
 	 .name = "88pm80x-rtc",
+	 .of_compatible = "marvell,88pm80x-rtc",
 	 .num_resources = ARRAY_SIZE(rtc_resources),
 	 .resources = &rtc_resources[0],
 	 .id = -1,
@@ -151,6 +159,7 @@ static struct resource onkey_resources[] = {
 static struct mfd_cell onkey_devs[] = {
 	{
 	 .name = "88pm80x-onkey",
+	 .of_compatible = "marvell,88pm80x-onkey",
 	 .num_resources = 1,
 	 .resources = &onkey_resources[0],
 	 .id = -1,
@@ -160,6 +169,7 @@ static struct mfd_cell onkey_devs[] = {
 static struct mfd_cell regulator_devs[] = {
 	{
 	 .name = "88pm80x-regulator",
+	 .of_compatible = "marvell,88pm80x-regulator",
 	 .id = -1,
 	},
 };
@@ -538,14 +548,58 @@ out:
 	return ret;
 }
 
+static int pm800_dt_init(struct device_node *np,
+			 struct device *dev,
+			 struct pm80x_platform_data *pdata)
+{
+	pdata->irq_mode =
+		!of_property_read_bool(np, "marvell,88pm800-irq-write-clear");
+	pdata->batt_det =
+		of_property_read_bool(np, "marvell,88pm800-battery-detection");
+
+	return 0;
+}
+
+
 static int pm800_probe(struct i2c_client *client,
 				 const struct i2c_device_id *id)
 {
 	int ret = 0;
 	struct pm80x_chip *chip;
 	struct pm80x_platform_data *pdata = client->dev.platform_data;
+	struct device_node *node = client->dev.of_node;
 	struct pm80x_subchip *subchip;
 
+	if (IS_ENABLED(CONFIG_OF)) {
+		if (!pdata) {
+			pdata = devm_kzalloc(&client->dev,
+					     sizeof(*pdata), GFP_KERNEL);
+			if (!pdata)
+				return -ENOMEM;
+		}
+		ret = pm800_dt_init(node, &client->dev, pdata);
+		if (ret)
+			return ret;
+	} else if (!pdata) {
+		return -EINVAL;
+	}
+
+	/*
+	 * RTC in pmic can run even the core is powered off, and user can set
+	 * alarm in RTC. When the alarm is time out, the PMIC will power up
+	 * the core, and the whole system will boot up. When PMIC driver is
+	 * probed, it will read out some register to find out whether this
+	 * boot is caused by RTC timeout or not, and it need pass this
+	 * information to RTC driver.
+	 * So we need rtc platform data to be existed to pass this information.
+	 */
+	if (!pdata->rtc) {
+		pdata->rtc = devm_kzalloc(&client->dev,
+					  sizeof(*(pdata->rtc)), GFP_KERNEL);
+		if (!pdata->rtc)
+			return -ENOMEM;
+	}
+
 	ret = pm80x_init(client);
 	if (ret) {
 		dev_err(&client->dev, "pm800_init fail\n");
@@ -612,6 +666,7 @@ static struct i2c_driver pm800_driver = {
 		.name = "88PM800",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
+		.of_match_table	= of_match_ptr(pm80x_dt_ids),
 		},
 	.probe = pm800_probe,
 	.remove = pm800_remove,
-- 
1.7.4.1

