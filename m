Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaI3JWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:22:55 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49445 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaI3JWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:22:52 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl: abx500: use helpers for map allocation/free
Date: Tue, 30 Sep 2014 11:22:47 +0200
Message-Id: <1412068967-24253-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the abx500 driver to use the pin control helper
utils for allocating and free:ing maps.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c | 43 ++++----------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index b0289824cf73..be95f5e68c01 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -34,6 +34,7 @@
 #include "pinctrl-abx500.h"
 #include "../core.h"
 #include "../pinconf.h"
+#include "../pinctrl-utils.h"
 
 /*
  * The AB9540 and AB8540 GPIO support are extended versions
@@ -827,41 +828,6 @@ static void abx500_pin_dbg_show(struct pinctrl_dev *pctldev,
 				 chip->base + offset - 1);
 }
 
-static void abx500_dt_free_map(struct pinctrl_dev *pctldev,
-		struct pinctrl_map *map, unsigned num_maps)
-{
-	int i;
-
-	for (i = 0; i < num_maps; i++)
-		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
-			kfree(map[i].data.configs.configs);
-	kfree(map);
-}
-
-static int abx500_dt_reserve_map(struct pinctrl_map **map,
-		unsigned *reserved_maps,
-		unsigned *num_maps,
-		unsigned reserve)
-{
-	unsigned old_num = *reserved_maps;
-	unsigned new_num = *num_maps + reserve;
-	struct pinctrl_map *new_map;
-
-	if (old_num >= new_num)
-		return 0;
-
-	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
-	if (!new_map)
-		return -ENOMEM;
-
-	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
-
-	*map = new_map;
-	*reserved_maps = new_num;
-
-	return 0;
-}
-
 static int abx500_dt_add_map_mux(struct pinctrl_map **map,
 		unsigned *reserved_maps,
 		unsigned *num_maps, const char *group,
@@ -958,7 +924,8 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 
 	reserve *= ret;
 
-	ret = abx500_dt_reserve_map(map, reserved_maps, num_maps, reserve);
+	ret = pinctrl_utils_reserve_map(pctldev, map, reserved_maps,
+					num_maps, reserve);
 	if (ret < 0)
 		goto exit;
 
@@ -999,7 +966,7 @@ static int abx500_dt_node_to_map(struct pinctrl_dev *pctldev,
 		ret = abx500_dt_subnode_to_map(pctldev, np, map,
 				&reserved_maps, num_maps);
 		if (ret < 0) {
-			abx500_dt_free_map(pctldev, *map, *num_maps);
+			pinctrl_utils_dt_free_map(pctldev, *map, *num_maps);
 			return ret;
 		}
 	}
@@ -1013,7 +980,7 @@ static const struct pinctrl_ops abx500_pinctrl_ops = {
 	.get_group_pins = abx500_get_group_pins,
 	.pin_dbg_show = abx500_pin_dbg_show,
 	.dt_node_to_map = abx500_dt_node_to_map,
-	.dt_free_map = abx500_dt_free_map,
+	.dt_free_map = pinctrl_utils_dt_free_map,
 };
 
 static int abx500_pin_config_get(struct pinctrl_dev *pctldev,
-- 
1.9.3

