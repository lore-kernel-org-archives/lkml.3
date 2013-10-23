Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3JWR3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:29:03 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63582 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3JWR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:29:01 -0400
From: marcus.folkesson@gmail.com
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] rtc: ds1511: add device-tree bindings
Date: Wed, 23 Oct 2013 19:28:34 +0200
Message-Id: <1382549314-5012-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

Compatible with ds1500, ds1501 and ds1511

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 .../devicetree/bindings/rtc/maxim-ds1511.txt       |   18 +++++
 drivers/rtc/rtc-ds1511.c                           |   84 +++++++++++++++++---
 2 files changed, 89 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/maxim-ds1511.txt

diff --git a/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt b/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt
new file mode 100644
index 0000000..77ac5c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt
@@ -0,0 +1,18 @@
+* Maxim Real Time Clock
+
+
+Support for Maxim DS1500, DS1501 and DS1511 RTC.
+
+Required properties:
+- compatible : Should be "maxim,ds1500-rtc", "maxim,ds1501-rtc" or "maxim,ds1511-rtc".
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: IRQ line for the RTC.
+
+Example:
+
+rtc@10300 {
+        compatible = "maxim,ds1511-rtc";
+        reg = <0xd0010300 0x14>;
+        interrupts = <50>;
+};
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 6a3fcfe..be77482 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -24,6 +24,9 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #define DRV_VERSION "0.6"
 
@@ -476,6 +479,51 @@ static struct bin_attribute ds1511_nvram_attr = {
 	.write = ds1511_nvram_write,
 };
 
+#ifdef CONFIG_OF
+static int ds1511_of_probe(struct platform_device *pdev,
+	 struct rtc_plat_data *pdata)
+{
+	struct device *dev = &pdev->dev;
+	u32 val;
+	int ret;
+	struct resource res;
+
+	ret = of_address_to_resource(&pdev->dev.of_node, 0, &res);
+	if (ret)
+		return -EINVAL;
+
+	pdata->size = resource_size(&res);
+
+	if (!devm_request_mem_region(&pdev->dev, res.start, pdata->size,
+			pdev->name))
+		return -EBUSY;
+
+	ds1511_base = devm_ioremap(&pdev->dev, res.start, pdata->size);
+	if (!ds1511_base)
+		return -ENOMEM;
+
+	pdata->ioaddr = ds1511_base;
+	pdata->irq = irq_of_parse_and_map(&pdev->dev.of_node, 0);
+
+	return 0;
+}
+
+static const struct of_device_id rtc_of_match[] = {
+	{ .compatible = "maxim,ds1500-rtc" },
+	{ .compatible = "maxim,ds1501-rtc" },
+	{ .compatible = "maxim,ds1511-rtc" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rtc_of_match);
+
+#else
+static int ds1511_of_probe(struct platform_device *pdev,
+				struct rtc_plat_data *pdata)
+{
+	return -ENODEV;
+}
+#endif
+
 static int ds1511_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
@@ -483,22 +531,31 @@ static int ds1511_rtc_probe(struct platform_device *pdev)
 	struct rtc_plat_data *pdata;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		return -ENODEV;
-	}
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
-			pdev->name))
-		return -EBUSY;
-	ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
-	if (!ds1511_base)
-		return -ENOMEM;
-	pdata->ioaddr = ds1511_base;
-	pdata->irq = platform_get_irq(pdev, 0);
+
+	if (pdev->dev.of_node) {
+		ret = ds1511_of_probe(pdev, pdata);
+		if (ret < 0)
+			return ret;
+
+	} else {
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res)
+			return -ENODEV;
+
+		pdata->size = resource_size(res);
+		if (!devm_request_mem_region(&pdev->dev, res->start,
+						pdata->size, pdev->name))
+			return -EBUSY;
+		ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
+		if (!ds1511_base)
+			return -ENOMEM;
+		pdata->ioaddr = ds1511_base;
+		pdata->irq = platform_get_irq(pdev, 0);
+	}
 
 	/*
 	 * turn on the clock and the crystal, etc.
@@ -575,6 +632,7 @@ static struct platform_driver ds1511_rtc_driver = {
 	.driver		= {
 		.name	= "ds1511",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(rtc_of_match),
 	},
 };
 
-- 
1.7.10.4

