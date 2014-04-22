Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaDVBgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:36:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63310 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaDVBgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:36:01 -0400
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: xuwei5@hisilicon.com, linus.walleij@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        baruch@tkos.co.il
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH 1/2] gpio: pl061: get gpio base from alias id
Date: Tue, 22 Apr 2014 09:35:42 +0800
Message-Id: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gpio base number isn't specified, the gpio base will be find from
the end of gpio number. In order to keep with schematics, use alias
to get the ID of gpio chip.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 .../devicetree/bindings/gpio/gpio-pl061.txt        | 31 ++++++++++++++++++++++
 drivers/gpio/gpio-pl061.c                          | 14 +++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pl061.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-pl061.txt b/Documentation/devicetree/bindings/gpio/gpio-pl061.txt
new file mode 100644
index 0000000..164b5ba
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-pl061.txt
@@ -0,0 +1,31 @@
+PL061 GPIO controller bindings
+
+Required properties:
+- compatible:
+  - "arm,pl061", "arm,primecell".
+- #gpio-cells : Should be two.
+  - first cell is the gpio pin number
+  - second cell is used to specify the gpio polarity:
+      0 = active high
+      1 = active low
+- gpio-controller : Marks the device node as a GPIO controller.
+- interrupt-controller : Marks the device node as an interrupt controller.
+- #interrupt-cells : Should be two.
+  - first cell is the hw irq number
+  - second cell is used to specify the interrupt type:
+      0 = default, unspecified type
+      1 = rising edge triggered
+      2 = falling edge triggered
+      4 = high level triggered
+      8 = low level triggered
+
+Example:
+	gpio0: gpio@fc806000 {
+		compatible = "arm,pl061", "arm,primecell";
+		reg = <0xfc806000 0x1000>;
+		interrupts = <0 64 0x4>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index b0f4752..14f3ab5 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -236,6 +236,18 @@ static struct irq_chip pl061_irqchip = {
 	.irq_set_type	= pl061_irq_type,
 };
 
+/* Parse gpio base from DT */
+static int pl061_parse_gpio_base(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	int ret, id;
+
+	id = of_alias_get_id(np, "gpio");
+	if (id < 0)
+		return id;
+	return (id * PL061_GPIO_NR);
+}
+
 static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 {
 	struct device *dev = &adev->dev;
@@ -255,7 +267,7 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 			return -ENODEV;
 		}
 	} else {
-		chip->gc.base = -1;
+		chip->gc.base = pl061_parse_gpio_base(dev);
 		irq_base = 0;
 	}
 
-- 
1.9.1

