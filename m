Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab3DXHnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:43:43 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57387 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3DXHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:43:42 -0400
Date: Wed, 24 Apr 2013 08:43:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH 06/10 v2] usb: musb: ux500: add device tree probing support
Message-ID: <20130424074336.GD17416@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366729394-11406-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: musb: ux500: add device tree probing support

This patch will allow ux500-musb to be probed and configured solely from
configuration found in Device Tree.

Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>

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
