Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab3ECOjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:39:18 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:46470 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832Ab3ECOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 49/63] usb: musb: ux500: add device tree probing support
Date: Fri,  3 May 2013 15:32:35 +0100
Message-Id: <1367591569-32197-50-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will allow ux500-musb to be probed and configured solely from
configuration found in Device Tree.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/usb/ux500-usb.txt          |   50 +++++++++++++++++++
 drivers/usb/musb/ux500.c                           |   51 ++++++++++++++++++++
 2 files changed, 101 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ux500-usb.txt

diff --git a/Documentation/devicetree/bindings/usb/ux500-usb.txt b/Documentation/devicetree/bindings/usb/ux500-usb.txt
new file mode 100644
index 0000000..330d6ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ux500-usb.txt
@@ -0,0 +1,50 @@
+Ux500 MUSB
+
+Required properties:
+ - compatible : Should be "stericsson,db8500-musb"
+ - reg        : Offset and length of registers
+ - interrupts : Interrupt; mode, number and trigger
+ - dr_mode    : Dual-role; either host mode "host", peripheral mode "peripheral"
+                or both "otg"
+
+Optional properties:
+ - dmas       : A list of dma channels;
+                dma-controller, event-line, fixed-channel, flags
+ - dma-names  : An ordered list of channel names affiliated to the above
+
+Example:
+
+usb_per5@a03e0000 {
+	compatible = "stericsson,db8500-musb", "mentor,musb";
+	reg = <0xa03e0000 0x10000>;
+	interrupts = <0 23 0x4>;
+	interrupt-names = "mc";
+
+	dr_mode = "otg";
+
+	dmas = <&dma 38 0 0x2>, /* Logical - DevToMem */
+	       <&dma 38 0 0x0>, /* Logical - MemToDev */
+	       <&dma 37 0 0x2>, /* Logical - DevToMem */
+	       <&dma 37 0 0x0>, /* Logical - MemToDev */
+	       <&dma 36 0 0x2>, /* Logical - DevToMem */
+	       <&dma 36 0 0x0>, /* Logical - MemToDev */
+	       <&dma 19 0 0x2>, /* Logical - DevToMem */
+	       <&dma 19 0 0x0>, /* Logical - MemToDev */
+	       <&dma 18 0 0x2>, /* Logical - DevToMem */
+	       <&dma 18 0 0x0>, /* Logical - MemToDev */
+	       <&dma 17 0 0x2>, /* Logical - DevToMem */
+	       <&dma 17 0 0x0>, /* Logical - MemToDev */
+	       <&dma 16 0 0x2>, /* Logical - DevToMem */
+	       <&dma 16 0 0x0>, /* Logical - MemToDev */
+	       <&dma 39 0 0x2>, /* Logical - DevToMem */
+	       <&dma 39 0 0x0>; /* Logical - MemToDev */
+
+	dma-names = "iep_1_9",  "oep_1_9",
+		    "iep_2_10", "oep_2_10",
+		    "iep_3_11", "oep_3_11",
+		    "iep_4_12", "oep_4_12",
+		    "iep_5_13", "oep_5_13",
+		    "iep_6_14", "oep_6_14",
+		    "iep_7_15", "oep_7_15",
+		    "iep_8",    "oep_8";
+};
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 7ddb132..5ff304c 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -25,6 +25,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 
 #include "musb_core.h"
@@ -88,14 +89,57 @@ static const struct musb_platform_ops ux500_ops = {
 	.exit		= ux500_musb_exit,
 };
 
+static struct musb_hdrc_platform_data *
+ux500_of_probe(struct platform_device *pdev, struct device_node *np)
+{
+	struct musb_hdrc_platform_data *pdata;
+	const char *mode;
+	int strlen;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	mode = of_get_property(np, "dr_mode", &strlen);
+	if (!mode) {
+		dev_err(&pdev->dev, "No 'dr_mode' property found\n");
+		return NULL;
+	}
+
+	if (strlen > 0) {
+		if (!strcmp(mode, "host"))
+			pdata->mode = MUSB_HOST;
+		if (!strcmp(mode, "otg"))
+			pdata->mode = MUSB_OTG;
+		if (!strcmp(mode, "peripheral"))
+			pdata->mode = MUSB_PERIPHERAL;
+	}
+
+	return pdata;
+}
+
 static int ux500_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
+	struct device_node		*np = pdev->dev.of_node;
 	struct platform_device		*musb;
 	struct ux500_glue		*glue;
 	struct clk			*clk;
 	int				ret = -ENOMEM;
 
+	if (!pdata) {
+		if (np) {
+			pdata = ux500_of_probe(pdev, np);
+			if (!pdata)
+				goto err0;
+
+			pdev->dev.platform_data = pdata;
+		} else {
+			dev_err(&pdev->dev, "no pdata or device tree found\n");
+			goto err0;
+		}
+	}
+
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
@@ -124,6 +168,7 @@ static int ux500_probe(struct platform_device *pdev)
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &pdev->dev.coherent_dma_mask;
 	musb->dev.coherent_dma_mask	= pdev->dev.coherent_dma_mask;
+	musb->dev.of_node		= pdev->dev.of_node;
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
@@ -222,12 +267,18 @@ static const struct dev_pm_ops ux500_pm_ops = {
 #define DEV_PM_OPS	NULL
 #endif
 
+static const struct of_device_id ux500_match[] = {
+        { .compatible = "stericsson,db8500-musb", },
+        {}
+};
+
 static struct platform_driver ux500_driver = {
 	.probe		= ux500_probe,
 	.remove		= ux500_remove,
 	.driver		= {
 		.name	= "musb-ux500",
 		.pm	= DEV_PM_OPS,
+		.of_match_table = ux500_match,
 	},
 };
 
-- 
1.7.10.4

