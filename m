Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbaDILzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:55:04 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33220 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaDILzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:55:00 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com,
        sylvester.nawrocki@gmail.com, gautam.vivek@samsung.com
Subject: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio on/off
Date: Wed,  9 Apr 2014 17:24:45 +0530
Message-Id: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to enable/disable VBUS hooked to a gpio
to enable vbus supply on the port.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Based on 'phy-exynos5-usbdrd' patches:
[PATCH V4 0/5] Add Exynos5 USB 3.0 phy driver based on generic PHY framework
http://www.spinics.net/lists/linux-usb/msg105507.html

 drivers/phy/phy-exynos5-usbdrd.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index ff54a7c..5ca7485 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_gpio.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
@@ -176,6 +177,7 @@ struct exynos5_usbdrd_phy {
 	struct clk *ref_clk;
 	unsigned long ref_rate;
 	unsigned int refclk_reg;
+	int gpio;
 };
 
 #define to_usbdrd_phy(inst) \
@@ -460,6 +462,9 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 	if (!IS_ERR(phy_drd->usb30_sclk))
 		clk_prepare_enable(phy_drd->usb30_sclk);
 
+	/* Toggle VBUS gpio - on */
+	gpio_set_value(phy_drd->gpio, 1);
+
 	/* Power-on PHY*/
 	inst->phy_cfg->phy_isol(inst, 0);
 
@@ -476,6 +481,9 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 	/* Power-off the PHY */
 	inst->phy_cfg->phy_isol(inst, 1);
 
+	/* Toggle VBUS gpio - off */
+	gpio_set_value(phy_drd->gpio, 0);
+
 	if (!IS_ERR(phy_drd->usb30_sclk))
 		clk_disable_unprepare(phy_drd->usb30_sclk);
 
@@ -585,6 +593,16 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 
 	phy_drd->drv_data = drv_data;
 
+	/* Get required GPIO for vbus */
+	phy_drd->gpio = of_get_named_gpio(dev->of_node,
+					  "samsung,vbus-gpio", 0);
+	if (!gpio_is_valid(phy_drd->gpio))
+		dev_dbg(dev, "no usbdrd-phy vbus gpio defined\n");
+
+	if (devm_gpio_request(dev, phy_drd->gpio, "phydrd_vbus_gpio"))
+		dev_dbg(dev, "can't request usbdrd-phy vbus gpio %d\n",
+			phy_drd->gpio);
+
 	if (of_property_read_u32(node, "samsung,pmu-offset", &pmu_offset)) {
 		dev_err(dev, "Missing pmu-offset for phy isolation\n");
 		return -EINVAL;
-- 
1.7.10.4

