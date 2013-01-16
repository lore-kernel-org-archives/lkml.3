Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3APMpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:45:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40131 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab3APMpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:45:20 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
CC: Archit Taneja <archit@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] OMAPDSS: Panel NEC: Only register backlight when we have valid callback
Date: Wed, 16 Jan 2013 13:45:09 +0100
Message-ID: <1358340309-8774-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1358340309-8774-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358340309-8774-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not register a backlight device when the dssdev->set_backlight callback
is not set by the board.
In this case either we do not have means to control the backlight or the
board is using other means to control it, like bl-pwm.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../omap2/displays/panel-nec-nl8048hl11-01b.c      | 60 ++++++++++++----------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
index e6589fe..11302b2 100644
--- a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
+++ b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
@@ -85,9 +85,6 @@ static int nec_8048_bl_update_status(struct backlight_device *bl)
 	struct omap_dss_device *dssdev = dev_get_drvdata(&bl->dev);
 	int level;
 
-	if (!dssdev->set_backlight)
-		return -EINVAL;
-
 	if (bl->props.fb_blank == FB_BLANK_UNBLANK &&
 			bl->props.power == FB_BLANK_UNBLANK)
 		level = bl->props.brightness;
@@ -114,30 +111,33 @@ static const struct backlight_ops nec_8048_bl_ops = {
 static int nec_8048_panel_probe(struct omap_dss_device *dssdev)
 {
 	struct backlight_device *bl;
-	struct backlight_properties props;
 	int r;
 
 	dssdev->panel.timings = nec_8048_panel_timings;
 
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.max_brightness = 255;
-	props.type = BACKLIGHT_RAW;
+	if (dssdev->set_backlight) {
+		struct backlight_properties props;
+
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.max_brightness = 255;
+		props.type = BACKLIGHT_RAW;
 
-	bl = backlight_device_register("nec-8048", &dssdev->dev, dssdev,
-			&nec_8048_bl_ops, &props);
-	if (IS_ERR(bl))
-		return PTR_ERR(bl);
+		bl = backlight_device_register("nec-8048", &dssdev->dev, dssdev,
+				&nec_8048_bl_ops, &props);
+		if (IS_ERR(bl))
+			return PTR_ERR(bl);
 
-	dev_set_drvdata(&dssdev->dev, bl);
+		dev_set_drvdata(&dssdev->dev, bl);
 
-	bl->props.fb_blank = FB_BLANK_UNBLANK;
-	bl->props.power = FB_BLANK_UNBLANK;
-	bl->props.max_brightness = dssdev->max_backlight_level;
-	bl->props.brightness = dssdev->max_backlight_level;
+		bl->props.fb_blank = FB_BLANK_UNBLANK;
+		bl->props.power = FB_BLANK_UNBLANK;
+		bl->props.max_brightness = dssdev->max_backlight_level;
+		bl->props.brightness = dssdev->max_backlight_level;
 
-	r = nec_8048_bl_update_status(bl);
-	if (r < 0)
-		dev_err(&dssdev->dev, "failed to set lcd brightness\n");
+		r = nec_8048_bl_update_status(bl);
+		if (r < 0)
+			dev_err(&dssdev->dev, "failed to set lcd brightness\n");
+	}
 
 	return 0;
 }
@@ -146,9 +146,11 @@ static void nec_8048_panel_remove(struct omap_dss_device *dssdev)
 {
 	struct backlight_device *bl = dev_get_drvdata(&dssdev->dev);
 
-	bl->props.power = FB_BLANK_POWERDOWN;
-	nec_8048_bl_update_status(bl);
-	backlight_device_unregister(bl);
+	if (bl) {
+		bl->props.power = FB_BLANK_POWERDOWN;
+		nec_8048_bl_update_status(bl);
+		backlight_device_unregister(bl);
+	}
 }
 
 static int nec_8048_panel_power_on(struct omap_dss_device *dssdev)
@@ -172,9 +174,11 @@ static int nec_8048_panel_power_on(struct omap_dss_device *dssdev)
 			goto err1;
 	}
 
-	r = nec_8048_bl_update_status(bl);
-	if (r < 0)
-		dev_err(&dssdev->dev, "failed to set lcd brightness\n");
+	if (bl) {
+		r = nec_8048_bl_update_status(bl);
+		if (r < 0)
+			dev_err(&dssdev->dev, "failed to set lcd brightness\n");
+	}
 
 	return 0;
 err1:
@@ -190,8 +194,10 @@ static void nec_8048_panel_power_off(struct omap_dss_device *dssdev)
 	if (dssdev->state != OMAP_DSS_DISPLAY_ACTIVE)
 		return;
 
-	bl->props.brightness = 0;
-	nec_8048_bl_update_status(bl);
+	if (bl) {
+		bl->props.brightness = 0;
+		nec_8048_bl_update_status(bl);
+	}
 
 	if (dssdev->platform_disable)
 		dssdev->platform_disable(dssdev);
-- 
1.8.1

