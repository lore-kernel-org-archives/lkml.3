Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab3AWLsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:48:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44469 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab3AWLsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:48:50 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 09/12] video: da8xx-fb: obtain fb_videomode info from dt
Date: Wed, 23 Jan 2013 17:18:40 +0530
Message-ID: <0773a0c87508af79c4547a1579e12f4ab28dec09.1358937685.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358937685.git.afzal@ti.com>
References: <cover.1358937685.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obtain fb_videomode details for the connected lcd panel using the
display timing details present in DT.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 .../devicetree/bindings/video/fb-da8xx.txt          | 21 +++++++++++++++++++++
 drivers/video/da8xx-fb.c                            | 17 +++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/fb-da8xx.txt b/Documentation/devicetree/bindings/video/fb-da8xx.txt
index 581e014..0741f78 100644
--- a/Documentation/devicetree/bindings/video/fb-da8xx.txt
+++ b/Documentation/devicetree/bindings/video/fb-da8xx.txt
@@ -6,6 +6,12 @@ Required properties:
 	AM335x SoC's - "ti,am3352-lcdc", "ti,da830-lcdc"
 - reg: Address range of lcdc register set
 - interrupts: lcdc interrupt
+- display-timings: typical videomode of lcd panel, represented as child.
+  Refer Documentation/devicetree/bindings/video/display-timing.txt for
+  display timing binding details. If multiple videomodes are mentioned
+  in display timings node, typical videomode has to be mentioned as the
+  native mode or it has to be first child (driver cares only for native
+  videomode).
 
 Example:
 
@@ -13,4 +19,19 @@ lcdc@4830e000 {
 	compatible = "ti,am3352-lcdc", "ti,da830-lcdc";
 	reg =  <0x4830e000 0x1000>;
 	interrupts = <36>;
+	display-timings {
+		800x480p62 {
+			clock-frequency = <30000000>;
+			hactive = <800>;
+			vactive = <480>;
+			hfront-porch = <39>;
+			hback-porch = <39>;
+			hsync-len = <47>;
+			vback-porch = <29>;
+			vfront-porch = <13>;
+			vsync-len = <2>;
+			hsync-active = <1>;
+			vsync-active = <1>;
+		};
+	};
 };
diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 0beed20..0c68712 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -36,6 +36,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/lcm.h>
+#include <video/of_display_timing.h>
 #include <video/da8xx-fb.h>
 #include <asm/div64.h>
 
@@ -1257,8 +1258,24 @@ static struct fb_videomode *da8xx_fb_get_videomode(struct platform_device *dev)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata = dev->dev.platform_data;
 	struct fb_videomode *lcdc_info;
+	struct device_node *np = dev->dev.of_node;
 	int i;
 
+	if (np) {
+		lcdc_info = devm_kzalloc(&dev->dev,
+					 sizeof(struct fb_videomode),
+					 GFP_KERNEL);
+		if (!lcdc_info) {
+			dev_err(&dev->dev, "memory allocation failed\n");
+			return NULL;
+		}
+		if (of_get_fb_videomode(np, lcdc_info, OF_USE_NATIVE_MODE)) {
+			dev_err(&dev->dev, "timings not available in DT\n");
+			return NULL;
+		}
+		return lcdc_info;
+	}
+
 	for (i = 0, lcdc_info = known_lcd_panels;
 		i < ARRAY_SIZE(known_lcd_panels); i++, lcdc_info++) {
 		if (strcmp(fb_pdata->type, lcdc_info->name) == 0)
-- 
1.7.12

