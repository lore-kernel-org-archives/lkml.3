Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3KVHRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:17:23 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46190 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KVHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:17:03 -0500
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        a.zummo@towertech.it, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH] rtc: ds1511: add device-tree bindings
Date: Fri, 22 Nov 2013 08:16:39 +0100
Message-Id: <1385104599-7527-2-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385104599-7527-1-git-send-email-marcus.folkesson@gmail.com>
References: <Marcus Folkesson <marcus.folkesson@gmail.com>
 <1385104599-7527-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compatible with ds1500, ds1501 and ds1511

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 .../devicetree/bindings/rtc/maxim-ds1511.txt       |   18 +++++
 drivers/rtc/rtc-ds1511.c                           |   85 +++++++++++++++++---
 2 files changed, 90 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/maxim-ds1511.txt

diff --git a/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt b/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt
new file mode 100644
index 0000000..17fa356
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
+        reg = <0xd0010300 0x20>;
+        interrupts = <50>;
+};
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 6a3fcfe..3778a8e 100644
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
 
@@ -476,6 +479,52 @@ static struct bin_attribute ds1511_nvram_attr = {
 	.write = ds1511_nvram_write,
 };
 
+
+
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
+		return -ENODEV;
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
+static int ds1511_of_probe(struct platform_device *pdev, struct rtc_plat_data *pdata)
+{
+	return -ENODEV;
+}
+#endif
+
 static int ds1511_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
@@ -483,22 +532,31 @@ static int ds1511_rtc_probe(struct platform_device *pdev)
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
+	} else if (!pdev) {
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res) {
+			return -ENODEV;
+		}
+		pdata->size = resource_size(res);
+		if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
+				pdev->name))
+			return -EBUSY;
+		ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
+		if (!ds1511_base)
+			return -ENOMEM;
+		pdata->ioaddr = ds1511_base;
+		pdata->irq = platform_get_irq(pdev, 0);
+	} else
+		return -ENODEV;
 
 	/*
 	 * turn on the clock and the crystal, etc.
@@ -575,6 +633,7 @@ static struct platform_driver ds1511_rtc_driver = {
 	.driver		= {
 		.name	= "ds1511",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(rtc_of_match),
 	},
 };
 
-- 
1.7.10.4

