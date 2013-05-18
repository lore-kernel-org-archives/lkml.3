Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3ERJPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:15:42 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:54713 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3ERJPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:15:17 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/4] fb: vt8500: Require a device clock for wm8505fb driver
Date: Sat, 18 May 2013 21:15:13 +1200
Message-Id: <1368868514-18975-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
References: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wm8505fb driver requires a clock to work properly. Without a clock,
the driver can only initialize the display resolution that was set in
uboot.
This patch updates the driver to get and use a clock, and updates
the devicetree documentation to indicate the requirement for a clock.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 .../devicetree/bindings/video/wm,wm8505-fb.txt     |    4 ++-
 drivers/video/wm8505fb.c                           |   30 +++++++++++++++++---
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt b/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
index 0bcadb2..601416c 100644
--- a/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
+++ b/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
@@ -5,6 +5,7 @@ Required properties:
 - compatible : "wm,wm8505-fb"
 - reg : Should contain 1 register ranges(address and length)
 - bits-per-pixel : bit depth of framebuffer (16 or 32)
+- clocks : phandle to DVO clock
 
 Required subnodes:
 - display-timings: see display-timing.txt for information
@@ -15,11 +16,12 @@ Example:
 		compatible = "wm,wm8505-fb";
 		reg = <0xd8051700 0x200>;
 		bits-per-pixel = <16>;
+		clocks = <&clkdvo>;
 
 		display-timings {
 			native-mode = <&timing0>;
 			timing0: 800x480 {
-				clock-frequency = <0>; /* unused but required */
+				clock-frequency = <30000000>;
 				hactive = <800>;
 				vactive = <480>;
 				hfront-porch = <40>;
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 167a9e2..f8bffc2 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -14,6 +14,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/fb.h>
@@ -130,9 +131,11 @@
 #define to_wm8505fb_info(__info) container_of(__info, \
 						struct wm8505fb_info, fb)
 struct wm8505fb_info {
-	struct fb_info		fb;
-	void __iomem		*regbase;
-	unsigned int		contrast;
+	struct fb_info fb;
+	void __iomem *regbase;
+	unsigned int contrast;
+	struct device *dev;
+	struct clk *clk_dvo;
 };
 
 
@@ -210,6 +213,13 @@ static int wm8505fb_set_par(struct fb_info *info)
 	if (!fbi)
 		return -EINVAL;
 
+	if (info->var.pixclock == 0) {
+		dev_err(fbi->dev, "requested pixclock = 0\n");
+		return -EINVAL;
+	}
+
+	clk_set_rate(fbi->clk_dvo, PICOS2KHZ(info->var.pixclock)*1000);
+
 	if (info->var.bits_per_pixel == 32) {
 		info->var.red.offset = 16;
 		info->var.red.length = 8;
@@ -369,6 +379,8 @@ static int wm8505fb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	fbi->dev = &pdev->dev;
+
 	strcpy(fbi->fb.fix.id, DRIVER_NAME);
 
 	fbi->fb.fix.type	= FB_TYPE_PACKED_PIXELS;
@@ -408,6 +420,14 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	fbi->clk_dvo = of_clk_get(pdev->dev.of_node, 0);
+	if (IS_ERR(fbi->clk_dvo)) {
+		dev_err(&pdev->dev, "Error retrieving clock\n");
+		return PTR_ERR(fbi->clk_dvo);
+	}
+
+	clk_prepare_enable(fbi->clk_dvo);
+
 	fb_videomode_to_var(&fbi->fb.var, &mode);
 
 	fbi->fb.var.nonstd		= 0;
@@ -421,7 +441,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	fb_mem_virt = dmam_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
-		pr_err("%s: Failed to allocate framebuffer\n", __func__);
+		dev_err(&pdev->dev, "Failed to allocate framebuffer\n");
 		return -ENOMEM;
 	}
 
@@ -480,6 +500,8 @@ static int wm8505fb_remove(struct platform_device *pdev)
 
 	unregister_framebuffer(&fbi->fb);
 
+	clk_disable_unprepare(fbi->clk_dvo);
+
 	writel(0, fbi->regbase);
 
 	if (fbi->fb.cmap.len)
-- 
1.7.9.5

