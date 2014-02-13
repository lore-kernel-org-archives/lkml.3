Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaBMNrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:47:47 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:46505 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaBMNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:47:43 -0500
X-Auth-Info: zwkOPK6Pruv4JidJH+V63Qd0OF4iYUzmgiX62n/mfVQ=
From: Heiko Schocher <hs@denx.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Heiko Schocher <hs@denx.de>, Anatolij Gustschin <agust@denx.de>,
        Benoit Parrot <bparrot@ti.com>, Rob Clark <robdclark@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] gpu:drm:tilcdc: backlight node never found
Date: Thu, 13 Feb 2014 14:47:38 +0100
Message-Id: <1392299258-16968-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In panel_probe() the backlight node is never found, correct this.

Signed-off-by: Heiko Schocher <hs@denx.de>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Benoit Parrot <bparrot@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 86c6732..0b97cf4 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -356,6 +356,7 @@ static struct of_device_id panel_of_match[];
 static int panel_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
+	struct device_node *backlight_node;
 	struct panel_module *panel_mod;
 	struct tilcdc_module *mod;
 	struct pinctrl *pinctrl;
@@ -395,9 +396,15 @@ static int panel_probe(struct platform_device *pdev)
 
 	mod->preferred_bpp = panel_mod->info->bpp;
 
-	panel_mod->backlight = of_find_backlight_by_node(node);
-	if (panel_mod->backlight)
-		dev_info(&pdev->dev, "found backlight\n");
+	backlight_node = of_parse_phandle(pdev->dev.of_node, "backlight", 0);
+	if (backlight_node) {
+		panel_mod->backlight =
+			of_find_backlight_by_node(backlight_node);
+		if (panel_mod->backlight)
+			dev_info(&pdev->dev, "found backlight\n");
+	} else {
+		dev_warn(&pdev->dev, "backlight node missing...\n");
+	}
 
 	return 0;
 
-- 
1.8.3.1

