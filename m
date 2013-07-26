Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766Ab3GZUlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:41:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19457 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3GZUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:41:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 26 Jul 2013 13:40:33 -0700
From: Andrew Chew <achew@nvidia.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>, <rob@landley.net>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>, <j-keerthy@ti.com>,
        <gg@slimlogic.co.uk>, <ldewangan@nvidia.com>
CC: <achew@nvidia.com>, <rklein@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: palmas: Add DVFS mux setting
Date: Fri, 26 Jul 2013 13:41:48 -0700
Message-ID: <1374871308-490-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exists a PRIMARY_SECONDARY_PAD3 in the same register base as
PRIMARY_SECONDARY_PAD2, which controls the function of certain pins. Add
a property for this setting.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 Documentation/devicetree/bindings/mfd/palmas.txt |  3 ++-
 drivers/mfd/palmas.c                             | 29 ++++++++++++++++++++++--
 include/linux/mfd/palmas.h                       | 12 +++++++++-
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
index 892537d..a718db5 100644
--- a/Documentation/devicetree/bindings/mfd/palmas.txt
+++ b/Documentation/devicetree/bindings/mfd/palmas.txt
@@ -24,7 +24,7 @@ and also the generic series names
 - interrupt-parent : The parent interrupt controller.
 
 Optional properties:
-  ti,mux-padX : set the pad register X (1-2) to the correct muxing for the
+  ti,mux-padX : set the pad register X (1-3) to the correct muxing for the
 		hardware, if not set will use muxing in OTP.
 
 Example:
@@ -38,6 +38,7 @@ palmas {
 
 	ti,mux-pad1 = <0>;
 	ti,mux-pad2 = <0>;
+	ti,mux-pad3 = <0>;
 
 	#address-cells = <1>;
 	#size-cells = <0>;
diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index e4d1c70..b07b706 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -219,6 +219,12 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
 		pdata->pad2 = prop;
 	}
 
+	ret = of_property_read_u32(node, "ti,mux-pad3", &prop);
+	if (!ret) {
+		pdata->mux_from_pdata = 1;
+		pdata->pad3 = prop;
+	}
+
 	/* The default for this register is all masked */
 	ret = of_property_read_u32(node, "ti,power-ctrl", &prop);
 	if (!ret)
@@ -404,9 +410,28 @@ no_irq:
 	if (!(reg & PALMAS_PRIMARY_SECONDARY_PAD2_GPIO_7_MASK))
 		palmas->gpio_muxed |= PALMAS_GPIO_7_MUXED;
 
-	dev_info(palmas->dev, "Muxing GPIO %x, PWM %x, LED %x\n",
+	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
+			PALMAS_PRIMARY_SECONDARY_PAD3);
+
+	if (pdata->mux_from_pdata) {
+		reg = pdata->pad3;
+		ret = regmap_write(palmas->regmap[slave], addr, reg);
+		if (ret)
+			goto err_irq;
+	} else {
+		ret = regmap_read(palmas->regmap[slave], addr, &reg);
+		if (ret)
+			goto err_irq;
+	}
+
+	if (reg & PALMAS_PRIMARY_SECONDARY_PAD3_DVFS1)
+		palmas->dvfs_muxed |= PALMAS_DVFS1_MUXED;
+	if (reg & PALMAS_PRIMARY_SECONDARY_PAD3_DVFS2)
+		palmas->dvfs_muxed |= PALMAS_DVFS2_MUXED;
+
+	dev_info(palmas->dev, "Muxing GPIO %x, PWM %x, LED %x, DVFS %x\n",
 			palmas->gpio_muxed, palmas->pwm_muxed,
-			palmas->led_muxed);
+			palmas->led_muxed, palmas->dvfs_muxed);
 
 	reg = pdata->power_ctrl;
 
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 1a8dd7a..e479107 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -84,6 +84,7 @@ struct palmas {
 	u8 gpio_muxed;
 	u8 led_muxed;
 	u8 pwm_muxed;
+	u8 dvfs_muxed;
 };
 
 struct palmas_gpadc_platform_data {
@@ -257,7 +258,7 @@ struct palmas_platform_data {
 	 * then the two value to load into the registers if true
 	 */
 	int mux_from_pdata;
-	u8 pad1, pad2;
+	u8 pad1, pad2, pad3;
 
 	struct palmas_pmic_platform_data *pmic_pdata;
 	struct palmas_gpadc_platform_data *gpadc_pdata;
@@ -436,6 +437,9 @@ enum usb_irq_events {
 #define PALMAS_PWM1_MUXED					(1 << 0)
 #define PALMAS_PWM2_MUXED					(1 << 1)
 
+#define PALMAS_DVFS1_MUXED					(1 << 0)
+#define PALMAS_DVFS2_MUXED					(1 << 1)
+
 /* helper macro to get correct slave number */
 #define PALMAS_BASE_TO_SLAVE(x)		((x >> 8) - 1)
 #define PALMAS_BASE_TO_REG(x, y)	((x & 0xff) + y)
@@ -1833,6 +1837,12 @@ enum usb_irq_events {
 #define PALMAS_PRIMARY_SECONDARY_PAD2_GPIO_4			0x01
 #define PALMAS_PRIMARY_SECONDARY_PAD2_GPIO_4_SHIFT		0
 
+/* Bit definitions for PRIMARY_SECONDARY_PAD3 */
+#define PALMAS_PRIMARY_SECONDARY_PAD3_DVFS2			0x02
+#define PALMAS_PRIMARY_SECONDARY_PAD3_DVFS2_SHIFT		1
+#define PALMAS_PRIMARY_SECONDARY_PAD3_DVFS1			0x01
+#define PALMAS_PRIMARY_SECONDARY_PAD3_DVFS1_SHIFT		0
+
 /* Bit definitions for I2C_SPI */
 #define PALMAS_I2C_SPI_I2C2OTP_EN				0x80
 #define PALMAS_I2C_SPI_I2C2OTP_EN_SHIFT				7
-- 
1.8.1.5

