Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbANKh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:37:56 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:38504 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbbANKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:37:54 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <davem@davemloft.net>
CC: <Zubair.Kakakhel@imgtec.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <s.hauer@pengutronix.de>, <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH_V4] dm9000: Add regulator and reset support to dm9000
Date: Wed, 14 Jan 2015 10:36:17 +0000
Message-ID: <1421231777-12589-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In boards, the dm9000 chip's power and reset can be controlled by gpio.

It makes sense to add them to the dm9000 driver and let dt be used to
enable power and reset the phy.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Signed-off-by: Paul Burton <paul.burton@imgtec.com>

---
V3 Fixed an indentation and removed a call to gpio_direction_output as
devm_gpio_request_one can handle it.

V2 A few fixes and more error checks. Nothing major

V1 Minor blooper
---
 .../devicetree/bindings/net/davicom-dm9000.txt     |  4 +++
 drivers/net/ethernet/davicom/dm9000.c              | 40 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/davicom-dm9000.txt b/Documentation/devicetree/bindings/net/davicom-dm9000.txt
index 28767ed..5224bf0 100644
--- a/Documentation/devicetree/bindings/net/davicom-dm9000.txt
+++ b/Documentation/devicetree/bindings/net/davicom-dm9000.txt
@@ -11,6 +11,8 @@ Required properties:
 Optional properties:
 - davicom,no-eeprom : Configuration EEPROM is not available
 - davicom,ext-phy : Use external PHY
+- reset-gpios : phandle of gpio that will be used to reset chip during probe
+- vcc-supply : phandle of regulator that will be used to enable power to chip
 
 Example:
 
@@ -21,4 +23,6 @@ Example:
 		interrupts = <7 4>;
 		local-mac-address = [00 00 de ad be ef];
 		davicom,no-eeprom;
+		reset-gpios = <&gpf 12 GPIO_ACTIVE_LOW>;
+		vcc-supply = <&eth0_power>;
 	};
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index ef0bb58..375a16d 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -36,6 +36,9 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <linux/slab.h>
+#include <linux/regulator/consumer.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
 
 #include <asm/delay.h>
 #include <asm/irq.h>
@@ -1426,11 +1429,48 @@ dm9000_probe(struct platform_device *pdev)
 	struct dm9000_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct board_info *db;	/* Point a board information structure */
 	struct net_device *ndev;
+	struct device *dev = &pdev->dev;
 	const unsigned char *mac_src;
 	int ret = 0;
 	int iosize;
 	int i;
 	u32 id_val;
+	int reset_gpios;
+	enum of_gpio_flags flags;
+	struct regulator *power;
+
+	power = devm_regulator_get(dev, "vcc");
+	if (PTR_ERR(power) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+	if (IS_ERR(power)) {
+		dev_dbg(dev, "no regulator provided\n");
+	} else {
+		ret = regulator_enable(power);
+		if (ret != 0) {
+			dev_err(dev,
+				"Failed to enable power regulator: %d\n", ret);
+			return ret;
+		}
+		dev_dbg(dev, "regulator enabled\n");
+	}
+
+	reset_gpios = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0,
+					      &flags);
+	if (gpio_is_valid(reset_gpios)) {
+		ret = devm_gpio_request_one(dev, reset_gpios, flags,
+					    "dm9000_reset");
+		if (ret) {
+			dev_err(dev, "failed to request reset gpio %d: %d\n",
+				reset_gpios, ret);
+			return -ENODEV;
+		}
+
+		/* According to manual PWRST# Low Period Min 1ms */
+		msleep(2);
+		gpio_set_value(reset_gpios, 1);
+		/* Needs 3ms to read eeprom when PWRST is deasserted */
+		msleep(4);
+	}
 
 	if (!pdata) {
 		pdata = dm9000_parse_dt(&pdev->dev);
-- 
1.9.1

