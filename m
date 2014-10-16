Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaJPKM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:12:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45637 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJPKM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:12:26 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: tegra-xusb: Don't leak configurations
Date: Thu, 16 Oct 2014 12:12:22 +0200
Message-Id: <1413454342-16935-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The pinctrl config helpers make a separate copy of the configuration, so
callers must make sure to free any dynamically allocated memory that was
used to store it.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra-xusb.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl-tegra-xusb.c
index 1631ec94fb02..080ec7723ef2 100644
--- a/drivers/pinctrl/pinctrl-tegra-xusb.c
+++ b/drivers/pinctrl/pinctrl-tegra-xusb.c
@@ -20,6 +20,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
+#include <linux/slab.h>
 
 #include <dt-bindings/pinctrl/pinctrl-tegra-xusb.h>
 
@@ -171,7 +172,7 @@ static int tegra_xusb_padctl_parse_subnode(struct tegra_xusb_padctl *padctl,
 			if (err == -EINVAL)
 				continue;
 
-			return err;
+			goto out;
 		}
 
 		config = TEGRA_XUSB_PADCTL_PACK(properties[i].param, value);
@@ -179,7 +180,7 @@ static int tegra_xusb_padctl_parse_subnode(struct tegra_xusb_padctl *padctl,
 		err = pinctrl_utils_add_config(padctl->pinctrl, &configs,
 					       &num_configs, config);
 		if (err < 0)
-			return err;
+			goto out;
 	}
 
 	if (function)
@@ -190,14 +191,14 @@ static int tegra_xusb_padctl_parse_subnode(struct tegra_xusb_padctl *padctl,
 
 	err = of_property_count_strings(np, "nvidia,lanes");
 	if (err < 0)
-		return err;
+		goto out;
 
 	reserve *= err;
 
 	err = pinctrl_utils_reserve_map(padctl->pinctrl, maps, reserved_maps,
 					num_maps, reserve);
 	if (err < 0)
-		return err;
+		goto out;
 
 	of_property_for_each_string(np, "nvidia,lanes", prop, group) {
 		if (function) {
@@ -205,7 +206,7 @@ static int tegra_xusb_padctl_parse_subnode(struct tegra_xusb_padctl *padctl,
 					reserved_maps, num_maps, group,
 					function);
 			if (err < 0)
-				return err;
+				goto out;
 		}
 
 		if (num_configs) {
@@ -214,11 +215,15 @@ static int tegra_xusb_padctl_parse_subnode(struct tegra_xusb_padctl *padctl,
 					configs, num_configs,
 					PIN_MAP_TYPE_CONFIGS_GROUP);
 			if (err < 0)
-				return err;
+				goto out;
 		}
 	}
 
-	return 0;
+	err = 0;
+
+out:
+	kfree(configs);
+	return err;
 }
 
 static int tegra_xusb_padctl_dt_node_to_map(struct pinctrl_dev *pinctrl,
-- 
2.1.2

