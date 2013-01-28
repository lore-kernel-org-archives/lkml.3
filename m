Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3A1JV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:21:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43513 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab3A1JVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:21:53 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v5 11/12] video: da8xx-fb: setup struct lcd_ctrl_config for dt
Date: Mon, 28 Jan 2013 14:51:42 +0530
Message-ID: <4f79aabac23ce9f105e1e0dc1c35458ebe28c169.1359356015.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1359356015.git.afzal@ti.com>
References: <cover.1359356015.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strcut lcd_ctrl_config information required for driver is currently
obtained via platform data. To handle DT probing, create
lcd_ctrl_config and populate it with default values, these values are
sufficient for the panels so far used with this controller to work.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 1c1a616..5455682 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1254,6 +1254,35 @@ static struct fb_ops da8xx_fb_ops = {
 	.fb_blank = cfb_blank,
 };
 
+static struct lcd_ctrl_config *da8xx_fb_create_cfg(struct platform_device *dev)
+{
+	struct lcd_ctrl_config *cfg;
+
+	cfg = devm_kzalloc(&dev->dev, sizeof(struct fb_videomode), GFP_KERNEL);
+	if (!cfg) {
+		dev_err(&dev->dev, "memory allocation failed\n");
+		return NULL;
+	}
+
+	/* default values */
+
+	if (lcd_revision == LCD_VERSION_1)
+		cfg->bpp = 16;
+	else
+		cfg->bpp = 32;
+
+	/*
+	 * For panels so far used with this LCDC, below statement is sufficient.
+	 * For new panels, if required, struct lcd_ctrl_cfg fields to be updated
+	 * with additional/modified values. Those values would have to be then
+	 * obtained from dt(requiring new dt bindings).
+	 */
+
+	cfg->panel_shade = COLOR_ACTIVE;
+
+	return cfg;
+}
+
 static struct fb_videomode *da8xx_fb_get_videomode(struct platform_device *dev)
 {
 	struct da8xx_lcdc_platform_data *fb_pdata = dev->dev.platform_data;
@@ -1345,7 +1374,10 @@ static int fb_probe(struct platform_device *device)
 		break;
 	}
 
-	lcd_cfg = (struct lcd_ctrl_config *)fb_pdata->controller_data;
+	if (device->dev.of_node)
+		lcd_cfg = da8xx_fb_create_cfg(device);
+	else
+		lcd_cfg = (struct lcd_ctrl_config *)fb_pdata->controller_data;
 
 	if (!lcd_cfg) {
 		ret = -EINVAL;
-- 
1.7.12

