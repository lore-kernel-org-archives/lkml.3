Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaLJPto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:49:44 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58053 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaLJPtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:22 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f9-54886b802b26
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 15/15] drm/panel/ld9040: convert to restrack API
Date: Wed, 10 Dec 2014 16:48:33 +0100
Message-id: <1418226513-14105-16-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7oN2R0hBiuXSlvcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBldJ3+zFTQL17xtCuhgXGScBcjB4eEgInE0rtAJieQKSZx4d56NhBbSGAp
	o8S2jzJdjFxAdh+TxMutu9hBEmwCmhJ/N98EKxIR0JG43tPNDFLELLCBXWLd9H1gCWEBO4lZ
	i/cxgtgsAqoSp76cB7N5BVwk2s5MYYfYJidx8thkVhCbEyj+9/leRojNzhJLtr1nncDIu4CR
	YRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSFx82cG4+JjVIUYBDkYlHl5zxdYQIdbEsuLK
	3EOMEhzMSiK8C5M7QoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwzp43UcH/YaOnA/s+kYNsn+4Z
	L7YVDmmeoso0f3tHjcTu6+ylKv/cGq2PGxUsX3W2tepO40q24NfzA/bKlk4/Pz+Vq6pg/tY3
	jZOrd3dldpx5N8cy+Pee5F1Lu6/ufyMnYOImmawnmaJxJ2LRNS++ud9m5B9PVXomujeQRbnu
	wTquE938NgYpSizFGYmGWsxFxYkAnL/Vk2kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ld9040 panel driver to use restrack API.
As a result driver have following advantages:
- correctly handles removal of resources,
- do not need to defer probing, so as a result the panel
  becomes available as soon as possible, in case of deferred
  probing it was late_initcall,
- simplified initialization.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/panel/panel-ld9040.c | 41 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ld9040.c b/drivers/gpu/drm/panel/panel-ld9040.c
index 3337f30..619610e 100644
--- a/drivers/gpu/drm/panel/panel-ld9040.c
+++ b/drivers/gpu/drm/panel/panel-ld9040.c
@@ -17,6 +17,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
+#include <linux/restrack.h>
 
 #include <video/mipi_display.h>
 #include <video/of_videomode.h>
@@ -310,9 +311,22 @@ static int ld9040_parse_dt(struct ld9040 *ctx)
 	return 0;
 }
 
+void ld9040_restrack_cb(struct device *dev, int ret)
+{
+	struct ld9040 *ctx = dev_get_drvdata(dev);
+
+	if (ret == 0)
+		drm_panel_add(&ctx->panel);
+	else if (ret == -EPROBE_DEFER)
+		drm_panel_remove(&ctx->panel);
+	else
+		dev_err(dev, "restrack error %d\n", ret);
+}
+
 static int ld9040_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
+	struct restrack_ctx *rtrack;
 	struct ld9040 *ctx;
 	int ret;
 
@@ -331,17 +345,6 @@ static int ld9040_probe(struct spi_device *spi)
 
 	ctx->supplies[0].supply = "vdd3";
 	ctx->supplies[1].supply = "vci";
-	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ctx->supplies),
-				      ctx->supplies);
-	if (ret < 0)
-		return ret;
-
-	ctx->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(ctx->reset_gpio)) {
-		dev_err(dev, "cannot get reset-gpios %ld\n",
-			PTR_ERR(ctx->reset_gpio));
-		return PTR_ERR(ctx->reset_gpio);
-	}
 
 	spi->bits_per_word = 9;
 	ret = spi_setup(spi);
@@ -354,16 +357,13 @@ static int ld9040_probe(struct spi_device *spi)
 	ctx->panel.dev = dev;
 	ctx->panel.funcs = &ld9040_drm_funcs;
 
-	return drm_panel_add(&ctx->panel);
-}
-
-static int ld9040_remove(struct spi_device *spi)
-{
-	struct ld9040 *ctx = spi_get_drvdata(spi);
-
-	drm_panel_remove(&ctx->panel);
+	rtrack = devm_restrack_register(ctx->dev, ld9040_restrack_cb,
+		regulator_bulk_restrack_desc(&ctx->supplies[0]),
+		regulator_bulk_restrack_desc(&ctx->supplies[1]),
+		gpiod_restrack_desc(&ctx->reset_gpio, "reset", GPIOD_OUT_HIGH),
+	);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(rtrack);
 }
 
 static struct of_device_id ld9040_of_match[] = {
@@ -374,7 +374,6 @@ MODULE_DEVICE_TABLE(of, ld9040_of_match);
 
 static struct spi_driver ld9040_driver = {
 	.probe		= ld9040_probe,
-	.remove		= ld9040_remove,
 	.driver = {
 		.name	= "ld9040",
 		.owner	= THIS_MODULE,
-- 
1.9.1

