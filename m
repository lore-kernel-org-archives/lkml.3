Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3AVQwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:52:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54158 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab3AVQwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:52:47 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 06/12] video: da8xx-fb: reorganize panel detection
Date: Tue, 22 Jan 2013 22:22:36 +0530
Message-ID: <7c0c379679493edfbc97ff9de0adfb7202e1fdb7.1358871750.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358871750.git.afzal@ti.com>
References: <cover.1358871750.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move panel detection to a separate function, this helps in readability
as well as makes DT support cleaner.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 3b146bc..b6ea5e9 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1253,6 +1253,27 @@ static struct fb_ops da8xx_fb_ops = {
 	.fb_blank = cfb_blank,
 };
 
+static struct fb_videomode *da8xx_fb_get_videomode(struct platform_device *dev)
+{
+	struct da8xx_lcdc_platform_data *fb_pdata = dev->dev.platform_data;
+	struct fb_videomode *lcdc_info;
+	int i;
+
+	for (i = 0, lcdc_info = known_lcd_panels;
+		i < ARRAY_SIZE(known_lcd_panels); i++, lcdc_info++) {
+		if (strcmp(fb_pdata->type, lcdc_info->name) == 0)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(known_lcd_panels)) {
+		dev_err(&dev->dev, "no panel found\n");
+		return NULL;
+	}
+	dev_info(&dev->dev, "found %s panel\n", lcdc_info->name);
+
+	return lcdc_info;
+}
+
 static int fb_probe(struct platform_device *device)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata =
@@ -1262,7 +1283,7 @@ static int fb_probe(struct platform_device *device)
 	struct fb_info *da8xx_fb_info;
 	struct clk *fb_clk = NULL;
 	struct da8xx_fb_par *par;
-	int ret, i;
+	int ret;
 	unsigned long ulcm;
 
 	if (fb_pdata == NULL) {
@@ -1270,6 +1291,10 @@ static int fb_probe(struct platform_device *device)
 		return -ENOENT;
 	}
 
+	lcdc_info = da8xx_fb_get_videomode(device);
+	if (lcdc_info == NULL)
+		return -ENODEV;
+
 	lcdc_regs = platform_get_resource(device, IORESOURCE_MEM, 0);
 	da8xx_fb_reg_base = devm_request_and_ioremap(&device->dev, lcdc_regs);
 	if (!da8xx_fb_reg_base) {
@@ -1303,21 +1328,6 @@ static int fb_probe(struct platform_device *device)
 		break;
 	}
 
-	for (i = 0, lcdc_info = known_lcd_panels;
-		i < ARRAY_SIZE(known_lcd_panels);
-		i++, lcdc_info++) {
-		if (strcmp(fb_pdata->type, lcdc_info->name) == 0)
-			break;
-	}
-
-	if (i == ARRAY_SIZE(known_lcd_panels)) {
-		dev_err(&device->dev, "GLCD: No valid panel found\n");
-		ret = -ENODEV;
-		goto err_pm_runtime_disable;
-	} else
-		dev_info(&device->dev, "GLCD: Found %s panel\n",
-					fb_pdata->type);
-
 	lcd_cfg = (struct lcd_ctrl_config *)fb_pdata->controller_data;
 
 	if (!lcd_cfg) {
-- 
1.7.12

