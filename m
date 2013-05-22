Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3EVHMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:12:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57526 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3EVHMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:12:14 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, KV Sujith <sujithkv@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 09/11] gpio: davinci: DT changes for driver
Date: Wed, 22 May 2013 12:40:32 +0530
Message-ID: <1369206634-6778-10-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

- Add of_device_id for Davinci GPIO driver.
- Add function to populate data from DT.
- Modify the probe to read from DT if DT match is found.
- Add DT binding documentation for Davinci GPIO properties in a new file
  gpio-davinci.txt located at Documentation/devicetree/bindings/gpio/.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 .../devicetree/bindings/gpio/gpio-davinci.txt      |   26 +++++++++
 drivers/gpio/gpio-davinci.c                        |   57 ++++++++++++++++++--
 2 files changed, 80 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
new file mode 100644
index 0000000..0d599d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
@@ -0,0 +1,26 @@
+Davinci GPIO controller bindings
+
+Required Properties:
+- compatible:"ti,da830-gpio"
+
+- reg: Physical base address of the controller and length of memory mapped
+	region.
+
+- interrupts: The Starting IRQ number for GPIO
+
+- ngpio: The number of GPIO pins supported
+
+- intc_irq_num: The number of IRQs supported by the Interrupt Controller
+
+- gpio_unbanked: The number of GPIOs that have an individual interrupt
+		line to processor.
+
+Example:
+gpio: gpio@1e26000 {
+	compatible = "ti,da830-gpio";
+	reg = <0x226000 0x1000>;
+	interrupts = <42>;
+	ngpio = <144>;
+	intc_irq_num = <101>;
+	gpio_unbanked = <0>;
+};
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 08830aa..dbe3b83 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -19,6 +19,8 @@
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/gpio-davinci.h>
 #include <mach/gpio-davinci.h>
@@ -133,6 +135,50 @@ static void davinci_gpio_set(struct gpio_chip *chip, unsigned offset,
 	__raw_writel((1 << offset), value ? &regs->set_data : &regs->clr_data);
 }
 
+static struct davinci_gpio_platform_data *davinci_gpio_set_pdata_of(
+						struct platform_device *pdev)
+{
+	struct device_node *dn = pdev->dev.of_node;
+	struct davinci_gpio_platform_data *pdata;
+	u32 val, ret;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (pdata) {
+		ret = of_property_read_u32(dn, "ngpio", &val);
+		if (ret)
+			goto of_err;
+
+		pdata->ngpio = val;
+
+		ret = of_property_read_u32(dn, "gpio_unbanked", &val);
+		if (ret)
+			goto of_err;
+
+		pdata->gpio_unbanked = val;
+
+		ret = of_property_read_u32(dn, "intc_irq_num", &val);
+		if (ret)
+			goto of_err;
+
+		pdata->intc_irq_num = val;
+	}
+
+	return pdata;
+
+of_err:
+	dev_err(&pdev->dev, "Populating pdata from DT failed: err %d\n", ret);
+	return NULL;
+}
+
+static const struct of_device_id davinci_gpio_ids[] = {
+	{
+		.compatible = "ti,da830-gpio",
+	},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, davinci_gpio_ids);
+
 static int davinci_gpio_probe(struct platform_device *pdev)
 {
 	int i, base;
@@ -142,13 +188,17 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 	struct davinci_gpio_regs *regs;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	const struct of_device_id *match =
+		of_match_device(of_match_ptr(davinci_gpio_ids), &pdev->dev);
 
-	pdata = dev->platform_data;
+	pdata = match ? davinci_gpio_set_pdata_of(pdev) : dev->platform_data;
 	if (!pdata) {
 		dev_err(dev, "GPIO: No Platform Data Supplied\n");
 		return -EINVAL;
 	}
 
+	dev->platform_data = pdata;
+
 	/*
 	 * The gpio banks conceptually expose a segmented bitmap,
 	 * and "ngpio" is one more than the largest zero-based
@@ -490,8 +540,9 @@ done:
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

