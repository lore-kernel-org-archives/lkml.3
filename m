Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3GWHZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:25:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14890 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3GWHZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:25:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Jul 2013 00:25:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <kishon@ti.com>, <j-keerthy@ti.com>, <gg@slimlogic.co.uk>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4] gpio: palmas: add dt support
Date: Tue, 23 Jul 2013 13:06:04 +0530
Message-ID: <1374564964-1281-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_device_id table for Palma GPIO to be enable the
driver from DT file.

The driver can be registered from DT file as:
	palmas: tps65913@58 {
		:::::::::::
		palmas_gpio: palmas_gpio {
			compatible = "ti,palmas-gpio";
			gpio-controller;
			#gpio-cells = <2>;
		};
	};

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Long back, I sent the similar patch but it was paused due to the DT binding.
http://lkml.indiana.edu/hypermail/linux/kernel/1304.2/00261.html

Now, PMIC DT binding is already finalised and as per mfd binding, we can
go ahead with similar approach for gpios. pmic and other palams sub devices
are already following the same approach.

Sending 3rd version of the change which is same as per code is related but
adding devicetree binding document for gpio also at this time.

Changes from V3:
- Added description in DT binding document for second arg of gpio cells.

 .../devicetree/bindings/gpio/gpio-palmas.txt       |   27 ++++++++++++++++++++
 drivers/gpio/gpio-palmas.c                         |   12 ++++++++-
 2 files changed, 38 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-palmas.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-palmas.txt b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt
new file mode 100644
index 0000000..08b5b52
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt
@@ -0,0 +1,27 @@
+Palmas GPIO controller bindings
+
+Required properties:
+- compatible:
+  - "ti,palams-gpio" for palma series of the GPIO controller
+  - "ti,tps80036-gpio" for Palma series device TPS80036.
+  - "ti,tps65913-gpio" for palma series device TPS65913.
+  - "ti,tps65914-gpio" for palma series device TPS65914.
+- #gpio-cells : Should be two.
+  - first cell is the gpio pin number
+  - second cell is used to specify the gpio polarity:
+      0 = active high
+      1 = active low
+- gpio-controller : Marks the device node as a GPIO controller.
+
+Note: This gpio node will be sub node of palmas node.
+
+Example:
+	palmas: tps65913@58 {
+		:::::::::::
+		palmas_gpio: palmas_gpio {
+			compatible = "ti,palmas-gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+		:::::::::::
+	};
diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index e3a4e56..09360c4 100644
--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -134,7 +134,7 @@ static int palmas_gpio_probe(struct platform_device *pdev)
 	palmas_gpio->gpio_chip.get	= palmas_gpio_get;
 	palmas_gpio->gpio_chip.dev = &pdev->dev;
 #ifdef CONFIG_OF_GPIO
-	palmas_gpio->gpio_chip.of_node = palmas->dev->of_node;
+	palmas_gpio->gpio_chip.of_node = pdev->dev.of_node;
 #endif
 	palmas_pdata = dev_get_platdata(palmas->dev);
 	if (palmas_pdata && palmas_pdata->gpio_base)
@@ -159,9 +159,19 @@ static int palmas_gpio_remove(struct platform_device *pdev)
 	return gpiochip_remove(&palmas_gpio->gpio_chip);
 }
 
+static struct of_device_id of_palmas_gpio_match[] = {
+	{ .compatible = "ti,palmas-gpio"},
+	{ .compatible = "ti,tps65913-gpio"},
+	{ .compatible = "ti,tps65914-gpio"},
+	{ .compatible = "ti,tps80036-gpio"},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
+
 static struct platform_driver palmas_gpio_driver = {
 	.driver.name	= "palmas-gpio",
 	.driver.owner	= THIS_MODULE,
+	.driver.of_match_table = of_palmas_gpio_match,
 	.probe		= palmas_gpio_probe,
 	.remove		= palmas_gpio_remove,
 };
-- 
1.7.1.1

