Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3KUSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:16:27 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44919 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3KUSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:16:20 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v6 4/6] gpio: davinci: add OF support
Date: Thu, 21 Nov 2013 23:45:29 +0530
Message-Id: <1385057731-4348-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

This patch adds OF parser support for davinci gpio
driver and also appropriate documentation in gpio-davinci.txt
located at Documentation/devicetree/bindings/gpio/.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
[prabhakar.csengg@gmail.com: simplified the OF code, removed
		unnecessary DT property and also simplified
		the commit message]
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 .../devicetree/bindings/gpio/gpio-davinci.txt      |   41 ++++++++++++++
 drivers/gpio/gpio-davinci.c                        |   57 ++++++++++++++++++--
 2 files changed, 95 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
new file mode 100644
index 0000000..a2e839d
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
@@ -0,0 +1,41 @@
+Davinci GPIO controller bindings
+
+Required Properties:
+- compatible: should be "ti,dm6441-gpio"
+
+- reg: Physical base address of the controller and the size of memory mapped
+       registers.
+
+- gpio-controller : Marks the device node as a gpio controller.
+
+- interrupt-parent: phandle of the parent interrupt controller.
+
+- interrupts: Array of GPIO interrupt number. Only banked or unbanked IRQs are
+	      supported at a time.
+
+- ti,ngpio: The number of GPIO pins supported.
+
+- ti,davinci-gpio-unbanked: The number of GPIOs that have an individual interrupt
+		             line to processor.
+
+The GPIO controller also acts as an interrupt controller. It uses the default
+two cells specifier as described in Documentation/devicetree/bindings/
+interrupt-controller/interrupts.txt.
+
+Example:
+
+gpio: gpio@1e26000 {
+	compatible = "ti,dm6441-gpio";
+	gpio-controller;
+	reg = <0x226000 0x1000>;
+	interrupt-parent = <&intc>;
+	interrupts = <42 IRQ_TYPE_EDGE_BOTH 43 IRQ_TYPE_EDGE_BOTH
+		44 IRQ_TYPE_EDGE_BOTH 45 IRQ_TYPE_EDGE_BOTH
+		46 IRQ_TYPE_EDGE_BOTH 47 IRQ_TYPE_EDGE_BOTH
+		48 IRQ_TYPE_EDGE_BOTH 49 IRQ_TYPE_EDGE_BOTH
+		50 IRQ_TYPE_EDGE_BOTH>;
+	ti,ngpio = <144>;
+	ti,davinci-gpio-unbanked = <0>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+};
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 4d6adbc..5bdd9f8 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -17,6 +17,9 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/gpio-davinci.h>
 
@@ -134,6 +137,40 @@ davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	writel((1 << offset), value ? &g->set_data : &g->clr_data);
 }
 
+static struct davinci_gpio_platform_data *
+davinci_gpio_get_pdata(struct platform_device *pdev)
+{
+	struct device_node *dn = pdev->dev.of_node;
+	struct davinci_gpio_platform_data *pdata;
+	int ret;
+	u32 val;
+
+	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
+		return pdev->dev.platform_data;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	ret = of_property_read_u32(dn, "ti,ngpio", &val);
+	if (ret)
+		goto of_err;
+
+	pdata->ngpio = val;
+
+	ret = of_property_read_u32(dn, "ti,davinci-gpio-unbanked", &val);
+	if (ret)
+		goto of_err;
+
+	pdata->gpio_unbanked = val;
+
+	return pdata;
+
+of_err:
+	dev_err(&pdev->dev, "Populating pdata from DT failed: err %d\n", ret);
+	return NULL;
+}
+
 static int davinci_gpio_probe(struct platform_device *pdev)
 {
 	int i, base;
@@ -144,12 +181,14 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 
-	pdata = dev->platform_data;
+	pdata = davinci_gpio_get_pdata(pdev);
 	if (!pdata) {
 		dev_err(dev, "No platform data found\n");
 		return -EINVAL;
 	}
 
+	dev->platform_data = pdata;
+
 	/*
 	 * The gpio banks conceptually expose a segmented bitmap,
 	 * and "ngpio" is one more than the largest zero-based
@@ -195,6 +234,9 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 		if (chips[i].chip.ngpio > 32)
 			chips[i].chip.ngpio = 32;
 
+#ifdef CONFIG_OF_GPIO
+		chips[i].chip.of_node = dev->of_node;
+#endif
 		spin_lock_init(&chips[i].lock);
 
 		regs = gpio2regs(base);
@@ -506,11 +548,20 @@ done:
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id davinci_gpio_ids[] = {
+	{ .compatible = "ti,dm6441-gpio", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, davinci_gpio_ids);
+#endif
+
 static struct platform_driver davinci_gpio_driver = {
 	.probe		= davinci_gpio_probe,
 	.driver		= {
-		.name	= "davinci_gpio",
-		.owner	= THIS_MODULE,
+		.name		= "davinci_gpio",
+		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(davinci_gpio_ids),
 	},
 };
 
-- 
1.7.9.5

