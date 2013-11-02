Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3KBPkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:40:52 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39168 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab3KBPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:40:30 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-gpio@vger.kernel.org, Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v4 4/6] gpio: davinci: add OF support
Date: Sat,  2 Nov 2013 21:09:33 +0530
Message-Id: <1383406775-14902-5-git-send-email-prabhakar.csenng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

This patch adds OF parser support for davinci gpio
driver and also appropriate documentation in gpio-davinci.txt
located at Documentation/devicetree/bindings/gpio/.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
[prabhakar.csengg@gmail.com: simplified the OF code, removed
		unnecessary DT property and also simplified
		the commit message]
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 .../devicetree/bindings/gpio/gpio-davinci.txt      |   32 ++++++++++++
 drivers/gpio/gpio-davinci.c                        |   54 ++++++++++++++++++--
 2 files changed, 83 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
new file mode 100644
index 0000000..55aae1c
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
@@ -0,0 +1,32 @@
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
+- interrupts: Array of GPIO interrupt number.
+
+- ti,ngpio: The number of GPIO pins supported.
+
+- ti,davinci-gpio-unbanked: The number of GPIOs that have an individual interrupt
+		             line to processor.
+
+Example:
+
+gpio: gpio@1e26000 {
+	compatible = "ti,dm6441-gpio";
+	gpio-controller;
+	reg = <0x226000 0x1000>;
+	interrupts = <42 IRQ_TYPE_EDGE_BOTH 43 IRQ_TYPE_EDGE_BOTH
+		44 IRQ_TYPE_EDGE_BOTH 45 IRQ_TYPE_EDGE_BOTH
+		46 IRQ_TYPE_EDGE_BOTH 47 IRQ_TYPE_EDGE_BOTH
+		48 IRQ_TYPE_EDGE_BOTH 49 IRQ_TYPE_EDGE_BOTH
+		50 IRQ_TYPE_EDGE_BOTH>;
+	ti,ngpio = <144>;
+	ti,davinci-gpio-irq-base = <101>;
+	ti,davinci-gpio-unbanked = <0>;
+};
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index bcb6d8d..bb20a39 100644
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
 	__raw_writel((1 << offset), value ? &g->set_data : &g->clr_data);
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
@@ -501,11 +540,20 @@ done:
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

