Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3EaSr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:47:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58420 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3EaSrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:47:21 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH] pps-gpio: add device-tree binding and support
Date: Fri, 31 May 2013 20:46:55 +0200
Message-Id: <1370026015-9584-1-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
This patch depends on my two recent pps-gpio patches, which are currently
in Andrew Morton's mmotm. So it should probably also go via Andrew if it
is acceptable.

 Documentation/devicetree/bindings/pps/pps-gpio.txt |   20 +++++++
 drivers/pps/clients/pps-gpio.c                     |   55 +++++++++++++++++++-
 2 files changed, 73 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pps/pps-gpio.txt

diff --git a/Documentation/devicetree/bindings/pps/pps-gpio.txt b/Documentation/devicetree/bindings/pps/pps-gpio.txt
new file mode 100644
index 0000000..40bf9c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/pps/pps-gpio.txt
@@ -0,0 +1,20 @@
+Device-Tree Bindings for a PPS Signal on GPIO
+
+These properties describe a PPS (pulse-per-second) signal connected to
+a GPIO pin.
+
+Required properties:
+- compatible: should be "pps-gpio"
+- gpios: one PPS GPIO in the format described by ../gpio/gpio.txt
+
+Optional properties:
+- assert-falling-edge: when present, assert is indicated by a falling edge
+                       (instead of by a rising edge)
+
+Example:
+	pps {
+		compatible = "pps-gpio";
+		gpios = <&gpio2 6 0>;
+
+		assert-falling-edge;
+	};
diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 6768f95..b5806da 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -33,6 +33,8 @@
 #include <linux/pps-gpio.h>
 #include <linux/gpio.h>
 #include <linux/list.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
 
 /* Info for each registered platform device */
 struct pps_gpio_device_data {
@@ -103,14 +105,62 @@ get_irqf_trigger_flags(const struct pps_gpio_platform_data *pdata)
 	return flags;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id pps_gpio_dt_ids[] = {
+	{ .compatible = "pps-gpio", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pps_gpio_dt_ids);
+
+static struct pps_gpio_platform_data *
+of_get_pps_gpio_pdata(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct pps_gpio_platform_data *pdata;
+	int ret;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	ret = of_get_gpio(np, 0);
+	if (ret < 0) {
+		pr_err("failed to get GPIO from device tree\n");
+		return NULL;
+	}
+
+	pdata->gpio_pin = ret;
+	pdata->gpio_label = PPS_GPIO_NAME;
+
+	if (of_get_property(np, "assert-falling-edge", NULL))
+		pdata->assert_falling_edge = true;
+
+	return pdata;
+}
+#else
+static struct pps_gpio_platform_data *
+of_get_pps_gpio_pdata(struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif
+
 static int pps_gpio_probe(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data;
 	int irq;
 	int ret;
 	int pps_default_params;
-	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct pps_gpio_platform_data *pdata;
+	const struct of_device_id *match;
+
+	match = of_match_device(pps_gpio_dt_ids, &pdev->dev);
+	if (match)
+		pdev->dev.platform_data = of_get_pps_gpio_pdata(pdev);
+	pdata = pdev->dev.platform_data;
 
+	if (!pdata)
+		return -ENODEV;
 
 	/* GPIO setup */
 	ret = pps_gpio_setup(pdev);
@@ -184,7 +234,8 @@ static struct platform_driver pps_gpio_driver = {
 	.remove		= pps_gpio_remove,
 	.driver		= {
 		.name	= PPS_GPIO_NAME,
-		.owner	= THIS_MODULE
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(pps_gpio_dt_ids),
 	},
 };
 
-- 
1.7.10.4

