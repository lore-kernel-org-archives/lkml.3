Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab3HTL5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:57:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7323 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3HTL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:57:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 20 Aug 2013 04:57:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] pinctrl: tegra: use pinctrl-utils APIs for mapping
Date: Tue, 20 Aug 2013 17:42:38 +0530
Message-ID: <1377000758-3795-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1377000758-3795-1-git-send-email-ldewangan@nvidia.com>
References: <1377000758-3795-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pin control utility functions provides the function for creating
map lists.

In place of implementing APIs locally in Tegra pin control driver
for creating map lists, use the utility functions. This reduces
the code size and avoid duplication.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra.c |  130 ++++++---------------------------------
 1 files changed, 18 insertions(+), 112 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 2fa9bc6..b7ceef1 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -32,6 +32,7 @@
 
 #include "core.h"
 #include "pinctrl-tegra.h"
+#include "pinctrl-utils.h"
 
 struct tegra_pmx {
 	struct device *dev;
@@ -90,107 +91,6 @@ static void tegra_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
 }
 #endif
 
-static int reserve_map(struct device *dev, struct pinctrl_map **map,
-		       unsigned *reserved_maps, unsigned *num_maps,
-		       unsigned reserve)
-{
-	unsigned old_num = *reserved_maps;
-	unsigned new_num = *num_maps + reserve;
-	struct pinctrl_map *new_map;
-
-	if (old_num >= new_num)
-		return 0;
-
-	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
-	if (!new_map) {
-		dev_err(dev, "krealloc(map) failed\n");
-		return -ENOMEM;
-	}
-
-	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
-
-	*map = new_map;
-	*reserved_maps = new_num;
-
-	return 0;
-}
-
-static int add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
-		       unsigned *num_maps, const char *group,
-		       const char *function)
-{
-	if (WARN_ON(*num_maps == *reserved_maps))
-		return -ENOSPC;
-
-	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
-	(*map)[*num_maps].data.mux.group = group;
-	(*map)[*num_maps].data.mux.function = function;
-	(*num_maps)++;
-
-	return 0;
-}
-
-static int add_map_configs(struct device *dev, struct pinctrl_map **map,
-			   unsigned *reserved_maps, unsigned *num_maps,
-			   const char *group, unsigned long *configs,
-			   unsigned num_configs)
-{
-	unsigned long *dup_configs;
-
-	if (WARN_ON(*num_maps == *reserved_maps))
-		return -ENOSPC;
-
-	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
-			      GFP_KERNEL);
-	if (!dup_configs) {
-		dev_err(dev, "kmemdup(configs) failed\n");
-		return -ENOMEM;
-	}
-
-	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
-	(*map)[*num_maps].data.configs.group_or_pin = group;
-	(*map)[*num_maps].data.configs.configs = dup_configs;
-	(*map)[*num_maps].data.configs.num_configs = num_configs;
-	(*num_maps)++;
-
-	return 0;
-}
-
-static int add_config(struct device *dev, unsigned long **configs,
-		      unsigned *num_configs, unsigned long config)
-{
-	unsigned old_num = *num_configs;
-	unsigned new_num = old_num + 1;
-	unsigned long *new_configs;
-
-	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
-			       GFP_KERNEL);
-	if (!new_configs) {
-		dev_err(dev, "krealloc(configs) failed\n");
-		return -ENOMEM;
-	}
-
-	new_configs[old_num] = config;
-
-	*configs = new_configs;
-	*num_configs = new_num;
-
-	return 0;
-}
-
-static void tegra_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
-				      struct pinctrl_map *map,
-				      unsigned num_maps)
-{
-	int i;
-
-	for (i = 0; i < num_maps; i++)
-		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
-			kfree(map[i].data.configs.configs);
-
-	kfree(map);
-}
-
 static const struct cfg_param {
 	const char *property;
 	enum tegra_pinconf_param param;
@@ -212,12 +112,13 @@ static const struct cfg_param {
 	{"nvidia,drive-type",		TEGRA_PINCONF_PARAM_DRIVE_TYPE},
 };
 
-static int tegra_pinctrl_dt_subnode_to_map(struct device *dev,
+static int tegra_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 					   struct device_node *np,
 					   struct pinctrl_map **map,
 					   unsigned *reserved_maps,
 					   unsigned *num_maps)
 {
+	struct device *dev = pctldev->dev;
 	int ret, i;
 	const char *function;
 	u32 val;
@@ -241,7 +142,8 @@ static int tegra_pinctrl_dt_subnode_to_map(struct device *dev,
 		ret = of_property_read_u32(np, cfg_params[i].property, &val);
 		if (!ret) {
 			config = TEGRA_PINCONF_PACK(cfg_params[i].param, val);
-			ret = add_config(dev, &configs, &num_configs, config);
+			ret = pinctrl_utils_add_config(pctldev, &configs,
+					&num_configs, config);
 			if (ret < 0)
 				goto exit;
 		/* EINVAL=missing, which is fine since it's optional */
@@ -263,22 +165,25 @@ static int tegra_pinctrl_dt_subnode_to_map(struct device *dev,
 	}
 	reserve *= ret;
 
-	ret = reserve_map(dev, map, reserved_maps, num_maps, reserve);
+	ret = pinctrl_utils_reserve_map(pctldev, map, reserved_maps,
+					num_maps, reserve);
 	if (ret < 0)
 		goto exit;
 
 	of_property_for_each_string(np, "nvidia,pins", prop, group) {
 		if (function) {
-			ret = add_map_mux(map, reserved_maps, num_maps,
-					  group, function);
+			ret = pinctrl_utils_add_map_mux(pctldev, map,
+					reserved_maps, num_maps, group,
+					function);
 			if (ret < 0)
 				goto exit;
 		}
 
 		if (num_configs) {
-			ret = add_map_configs(dev, map, reserved_maps,
-					      num_maps, group, configs,
-					      num_configs);
+			ret = pinctrl_utils_add_map_configs(pctldev, map,
+					reserved_maps, num_maps, group,
+					configs, num_configs,
+					PIN_MAP_TYPE_CONFIGS_GROUP);
 			if (ret < 0)
 				goto exit;
 		}
@@ -305,10 +210,11 @@ static int tegra_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	*num_maps = 0;
 
 	for_each_child_of_node(np_config, np) {
-		ret = tegra_pinctrl_dt_subnode_to_map(pctldev->dev, np, map,
+		ret = tegra_pinctrl_dt_subnode_to_map(pctldev, np, map,
 						      &reserved_maps, num_maps);
 		if (ret < 0) {
-			tegra_pinctrl_dt_free_map(pctldev, *map, *num_maps);
+			pinctrl_utils_dt_free_map_configs_group(pctldev, *map,
+				*num_maps);
 			return ret;
 		}
 	}
@@ -324,7 +230,7 @@ static const struct pinctrl_ops tegra_pinctrl_ops = {
 	.pin_dbg_show = tegra_pinctrl_pin_dbg_show,
 #endif
 	.dt_node_to_map = tegra_pinctrl_dt_node_to_map,
-	.dt_free_map = tegra_pinctrl_dt_free_map,
+	.dt_free_map = pinctrl_utils_dt_free_map_configs_group,
 };
 
 static int tegra_pinctrl_get_funcs_count(struct pinctrl_dev *pctldev)
-- 
1.7.1.1

