Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939Ab3CVQQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:16:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57730 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704Ab3CVQQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:16:19 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v3 3/3] backlight: as3711: add OF support
Date: Fri, 22 Mar 2013 17:15:49 +0100
Message-Id: <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:6x+48Jvz9HRvkY5bLyHmg5NPVduLpe2JJwZ+HT9w2Z1
 Qax9iNZXEia8peBM50eyYT7Ml58sbi1F7OsGFo6Cf3HPT6Z/G5
 +X3S3iuneDlA2EmLI+2x7qiqoiMCRzJPSo+1/G15+hfN0JWCNg
 ajzjm2jJEdOp9W4bClyqCwywJncfPaV+HxFdxnpC29R5h9pU9C
 9zRFkdY2z/qhqvzT6hGlt/RnTaB18GI+nFrAMGiikrI9IJge2O
 Nlx42d6M+inr5lEZqM2u0basmgmZ6j+bipV3dkzyU3XHou42Iw
 18r2ABzB0f/D9NB9ilTyl9jpTWg2vsVHLgR9Wbjgr7xXhvllTA
 sqLhHsqPNiuBgfzKnejV/NT5czhDmrNEboCERaaT6T5coDAfvc
 HET9GnyXTrCvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for configuring AS3711 backlight driver from DT.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/video/backlight/as3711_bl.c |  118 ++++++++++++++++++++++++++++++++++-
 1 files changed, 117 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
index 41d52fe..123887c 100644
--- a/drivers/video/backlight/as3711_bl.c
+++ b/drivers/video/backlight/as3711_bl.c
@@ -258,6 +258,109 @@ static int as3711_bl_register(struct platform_device *pdev,
 	return 0;
 }
 
+static int as3711_backlight_parse_dt(struct device *dev)
+{
+	struct as3711_bl_pdata *pdata = dev_get_platdata(dev);
+	struct device_node *bl =
+		of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;
+	int ret;
+
+	if (!bl) {
+		dev_dbg(dev, "backlight node not found\n");
+		return -ENODEV;
+	}
+
+	fb = of_parse_phandle(bl, "su1-dev", 0);
+	if (fb) {
+		pdata->su1_fb = fb->full_name;
+
+		ret = of_property_read_u32(bl, "su1-max-uA", &pdata->su1_max_uA);
+		if (pdata->su1_max_uA <= 0)
+			ret = -EINVAL;
+		if (ret < 0)
+			return ret;
+	}
+
+	fb = of_parse_phandle(bl, "su2-dev", 0);
+	if (fb) {
+		int count = 0;
+
+		pdata->su2_fb = fb->full_name;
+
+		ret = of_property_read_u32(bl, "su2-max-uA", &pdata->su2_max_uA);
+		if (pdata->su2_max_uA <= 0)
+			ret = -EINVAL;
+		if (ret < 0)
+			return ret;
+
+		if (of_find_property(bl, "su2-feedback-voltage", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_VOLTAGE;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr1", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR1;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr2", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR2;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr3", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR3;
+			count++;
+		}
+		if (of_find_property(bl, "su2-feedback-curr-auto", NULL)) {
+			pdata->su2_feedback = AS3711_SU2_CURR_AUTO;
+			count++;
+		}
+		if (count != 1)
+			return -EINVAL;
+
+		count = 0;
+		if (of_find_property(bl, "su2-fbprot-lx-sd4", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_LX_SD4;
+			count++;
+		}
+		if (of_find_property(bl, "su2-fbprot-gpio2", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_GPIO2;
+			count++;
+		}
+		if (of_find_property(bl, "su2-fbprot-gpio3", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_GPIO3;
+			count++;
+		}
+		if (of_find_property(bl, "su2-fbprot-gpio4", NULL)) {
+			pdata->su2_fbprot = AS3711_SU2_GPIO4;
+			count++;
+		}
+		if (count != 1)
+			return -EINVAL;
+
+		count = 0;
+		if (of_find_property(bl, "su2-auto-curr1", NULL)) {
+			pdata->su2_auto_curr1 = true;
+			count++;
+		}
+		if (of_find_property(bl, "su2-auto-curr2", NULL)) {
+			pdata->su2_auto_curr2 = true;
+			count++;
+		}
+		if (of_find_property(bl, "su2-auto-curr3", NULL)) {
+			pdata->su2_auto_curr3 = true;
+			count++;
+		}
+
+		/*
+		 * At least one su2-auto-curr* must be specified iff
+		 * AS3711_SU2_CURR_AUTO is used
+		 */
+		if (!count ^ (pdata->su2_feedback != AS3711_SU2_CURR_AUTO))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int as3711_backlight_probe(struct platform_device *pdev)
 {
 	struct as3711_bl_pdata *pdata = dev_get_platdata(&pdev->dev);
@@ -267,11 +370,24 @@ static int as3711_backlight_probe(struct platform_device *pdev)
 	unsigned int max_brightness;
 	int ret;
 
-	if (!pdata || (!pdata->su1_fb && !pdata->su2_fb)) {
+	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data, exiting...\n");
 		return -ENODEV;
 	}
 
+	if (pdev->dev.parent->of_node) {
+		ret = as3711_backlight_parse_dt(&pdev->dev);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "DT parsing failed: %d\n", ret);
+			return ret;
+		}
+	}
+
+	if (!pdata->su1_fb && !pdata->su2_fb) {
+		dev_err(&pdev->dev, "No framebuffer specified\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Due to possible hardware damage I chose to block all modes,
 	 * unsupported on my hardware. Anyone, wishing to use any of those modes
-- 
1.7.2.5

