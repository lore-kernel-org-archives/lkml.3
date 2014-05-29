Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbaE2MtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:49:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26848 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbaE2MtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:49:04 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-99-53872cbe5f28
From: Andrzej Hajda <a.hajda@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH] drm/panel/s6e8aa0: add backlight support
Date: Thu, 29 May 2014 14:48:05 +0200
Message-id: <1401367685-22528-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xa7r7dNqDDWa3sFjcWneO1aL33Ekm
	iytf37NZXN41h81ixvl9TBZrj9xlt/i5ax6LA7vHzll32T22f3vA6nG/+ziTR9+WVYwenzfJ
	BbBGcdmkpOZklqUW6dslcGV0XLrJWnBJuqL72wGWBsY/Yl2MnBwSAiYSS77fZ4SwxSQu3FvP
	1sXIxSEksJRR4sXSF8wQTh+TRP/5BnaQKjYBTYm/m2+ygdgiAroS/0+/YQEpYha4zSgxdcNT
	IIeDQ1jAUmLCklyQGhYBVYlziw6B1fMKOEu0Pt7MBLFNTuLkscmsExi5FzAyrGIUTS1NLihO
	Ss810itOzC0uzUvXS87P3cQICZOvOxiXHrM6xCjAwajEw3vzaFuwEGtiWXFl7iFGCQ5mJRFe
	LuX2YCHelMTKqtSi/Pii0pzU4kOMTBycUg2MNlILFi1vqrsbZeHhfK08eUomT/lU62fpscdM
	azuXqT1Zes1yfdMR7Ve90+Te8SYYJxT8cTPZ2bxn4lnbk45TxJzS/7A0r/F9KqG9zDKT+fCZ
	BwKREs881VxaL2c67+y2Xag7e9aBbJ7n8+2mngops01fMO3g5zrvmJslJa0NEm5zjVr3pi5S
	YinOSDTUYi4qTgQAVCT+APEBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds backlight support to s6e8aa0 panel.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/panel/Kconfig         |  2 ++
 drivers/gpu/drm/panel/panel-s6e8aa0.c | 50 +++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 4ec874d..a54d89b 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -29,5 +29,7 @@ config DRM_PANEL_S6E8AA0
 	depends on OF
 	select DRM_MIPI_DSI
 	select VIDEOMODE_HELPERS
+	select BACKLIGHT_LCD_SUPPORT
+	select BACKLIGHT_CLASS_DEVICE
 
 endmenu
diff --git a/drivers/gpu/drm/panel/panel-s6e8aa0.c b/drivers/gpu/drm/panel/panel-s6e8aa0.c
index 35941d2..98a59a7 100644
--- a/drivers/gpu/drm/panel/panel-s6e8aa0.c
+++ b/drivers/gpu/drm/panel/panel-s6e8aa0.c
@@ -19,6 +19,7 @@
 #include <drm/drm_mipi_dsi.h>
 #include <drm/drm_panel.h>
 
+#include <linux/backlight.h>
 #include <linux/gpio/consumer.h>
 #include <linux/regulator/consumer.h>
 
@@ -91,6 +92,8 @@ struct s6e8aa0_variant {
 	const s6e8aa0_gamma_table *gamma_tables;
 };
 
+#define S6E8AA0_STATE_BIT_ENABLED	0
+
 struct s6e8aa0 {
 	struct device *dev;
 	struct drm_panel panel;
@@ -106,6 +109,7 @@ struct s6e8aa0 {
 	u32 width_mm;
 	u32 height_mm;
 
+	unsigned long state;
 	u8 version;
 	u8 id;
 	const struct s6e8aa0_variant *variant;
@@ -890,6 +894,7 @@ static int s6e8aa0_disable(struct drm_panel *panel)
 {
 	struct s6e8aa0 *ctx = panel_to_s6e8aa0(panel);
 
+	clear_bit(S6E8AA0_STATE_BIT_ENABLED, &ctx->state);
 	s6e8aa0_dcs_write_seq_static(ctx, MIPI_DCS_ENTER_SLEEP_MODE);
 	s6e8aa0_dcs_write_seq_static(ctx, MIPI_DCS_SET_DISPLAY_OFF);
 	msleep(40);
@@ -913,6 +918,8 @@ static int s6e8aa0_enable(struct drm_panel *panel)
 
 	if (ret < 0)
 		s6e8aa0_disable(panel);
+	else
+		set_bit(S6E8AA0_STATE_BIT_ENABLED, &ctx->state);
 
 	return ret;
 }
@@ -947,6 +954,47 @@ static const struct drm_panel_funcs s6e8aa0_drm_funcs = {
 	.get_modes = s6e8aa0_get_modes,
 };
 
+static int s6e8aa0_get_brightness(struct backlight_device *bd)
+{
+	return bd->props.brightness;
+}
+
+static int s6e8aa0_set_brightness(struct backlight_device *bd)
+{
+	struct s6e8aa0 *ctx = bl_get_data(bd);
+
+	bd->props.power = FB_BLANK_UNBLANK;
+	if (ctx->brightness != bd->props.brightness) {
+		ctx->brightness = bd->props.brightness;
+		if (test_bit(S6E8AA0_STATE_BIT_ENABLED, &ctx->state))
+			s6e8aa0_brightness_set(ctx);
+	}
+
+	return s6e8aa0_clear_error(ctx);
+}
+
+static const struct backlight_ops s6e8aa0_backlight_ops = {
+	.get_brightness = s6e8aa0_get_brightness,
+	.update_status = s6e8aa0_set_brightness,
+};
+
+static void s6e8aa0_backlight_register(struct s6e8aa0 *ctx)
+{
+	struct backlight_properties props = {
+		.type = BACKLIGHT_RAW,
+		.brightness = ctx->brightness,
+		.max_brightness = GAMMA_LEVEL_NUM - 1
+	};
+	struct device *dev = ctx->dev;
+	struct backlight_device *bd;
+
+	bd = devm_backlight_device_register(dev, "s6e8aa0-bl", dev, ctx,
+					    &s6e8aa0_backlight_ops, &props);
+	if (IS_ERR(bd))
+		dev_err(dev, "error registering backlight device (%ld)\n",
+			PTR_ERR(bd));
+}
+
 static int s6e8aa0_parse_dt(struct s6e8aa0 *ctx)
 {
 	struct device *dev = ctx->dev;
@@ -1029,6 +1077,8 @@ static int s6e8aa0_probe(struct mipi_dsi_device *dsi)
 	if (ret < 0)
 		drm_panel_remove(&ctx->panel);
 
+	s6e8aa0_backlight_register(ctx);
+
 	return ret;
 }
 
-- 
1.9.1

