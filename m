Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab3HULHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:07:34 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17784 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3HULHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:07:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Aug 2013 04:07:32 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/2] pinctrl: utils : add support to pass config type in generic util APIs
Date: Wed, 21 Aug 2013 16:53:37 +0530
Message-ID: <1377084218-13858-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to pass the config type like GROUP or PIN when using
the utils or generic pin configuration APIs. This will make the
APIs more generic.

Added additional inline APIs such that it can be use directly as
callback for the pinctrl_ops.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Remove separate implementation for pins and group for
  pinctrl_utils_dt_free_map and improve this function
  to support both i.e. PINS and GROUPs.

 drivers/pinctrl/pinconf-generic.c       |    9 +++++----
 drivers/pinctrl/pinctrl-palmas.c        |    2 +-
 drivers/pinctrl/pinctrl-utils.c         |   12 +++++++++---
 include/linux/pinctrl/pinconf-generic.h |   22 ++++++++++++++++++++--
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index d9536ca..2c62225 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -240,7 +240,8 @@ out:
 
 int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np, struct pinctrl_map **map,
-		unsigned *reserved_maps, unsigned *num_maps)
+		unsigned *reserved_maps, unsigned *num_maps,
+		enum pinctrl_map_type type)
 {
 	int ret;
 	const char *function;
@@ -295,7 +296,7 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		if (num_configs) {
 			ret = pinctrl_utils_add_map_configs(pctldev, map,
 					reserved_maps, num_maps, group, configs,
-					num_configs, PIN_MAP_TYPE_CONFIGS_PIN);
+					num_configs, type);
 			if (ret < 0)
 				goto exit;
 		}
@@ -310,7 +311,7 @@ EXPORT_SYMBOL_GPL(pinconf_generic_dt_subnode_to_map);
 
 int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np_config, struct pinctrl_map **map,
-		unsigned *num_maps)
+		unsigned *num_maps, enum pinctrl_map_type type)
 {
 	unsigned reserved_maps;
 	struct device_node *np;
@@ -322,7 +323,7 @@ int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 	for_each_child_of_node(np_config, np) {
 		ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
-						&reserved_maps, num_maps);
+					&reserved_maps, num_maps, type);
 		if (ret < 0) {
 			pinctrl_utils_dt_free_map(pctldev, *map, *num_maps);
 			return ret;
diff --git a/drivers/pinctrl/pinctrl-palmas.c b/drivers/pinctrl/pinctrl-palmas.c
index 2697c2e..9550c33 100644
--- a/drivers/pinctrl/pinctrl-palmas.c
+++ b/drivers/pinctrl/pinctrl-palmas.c
@@ -655,7 +655,7 @@ static const struct pinctrl_ops palmas_pinctrl_ops = {
 	.get_groups_count = palmas_pinctrl_get_groups_count,
 	.get_group_name = palmas_pinctrl_get_group_name,
 	.get_group_pins = palmas_pinctrl_get_group_pins,
-	.dt_node_to_map = pinconf_generic_dt_node_to_map,
+	.dt_node_to_map = pinconf_generic_dt_node_to_map_pin,
 	.dt_free_map = pinctrl_utils_dt_free_map,
 };
 
diff --git a/drivers/pinctrl/pinctrl-utils.c b/drivers/pinctrl/pinctrl-utils.c
index b7ac646..48277e0 100644
--- a/drivers/pinctrl/pinctrl-utils.c
+++ b/drivers/pinctrl/pinctrl-utils.c
@@ -126,10 +126,16 @@ void pinctrl_utils_dt_free_map(struct pinctrl_dev *pctldev,
 {
 	int i;
 
-	for (i = 0; i < num_maps; i++)
-		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+	for (i = 0; i < num_maps; i++) {
+		switch (map[i].type) {
+		case PIN_MAP_TYPE_CONFIGS_GROUP:
+		case PIN_MAP_TYPE_CONFIGS_PIN:
 			kfree(map[i].data.configs.configs);
-
+			break;
+		default:
+			break;
+		}
+	}
 	kfree(map);
 }
 EXPORT_SYMBOL_GPL(pinctrl_utils_dt_free_map);
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 83f5179..fb90ef5 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -140,15 +140,33 @@ static inline unsigned long pinconf_to_config_packed(enum pin_config_param param
 #ifdef CONFIG_OF
 
 #include <linux/device.h>
+#include <linux/pinctrl/machine.h>
 struct pinctrl_dev;
 struct pinctrl_map;
 
 int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np, struct pinctrl_map **map,
-		unsigned *reserved_maps, unsigned *num_maps);
+		unsigned *reserved_maps, unsigned *num_maps,
+		enum pinctrl_map_type type);
 int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np_config, struct pinctrl_map **map,
-		unsigned *num_maps);
+		unsigned *num_maps, enum pinctrl_map_type type);
+
+static inline int pinconf_generic_dt_node_to_map_group(
+		struct pinctrl_dev *pctldev, struct device_node *np_config,
+		struct pinctrl_map **map, unsigned *num_maps)
+{
+	return pinconf_generic_dt_node_to_map(pctldev, np_config, map, num_maps,
+			PIN_MAP_TYPE_CONFIGS_GROUP);
+}
+
+static inline int pinconf_generic_dt_node_to_map_pin(
+		struct pinctrl_dev *pctldev, struct device_node *np_config,
+		struct pinctrl_map **map, unsigned *num_maps)
+{
+	return pinconf_generic_dt_node_to_map(pctldev, np_config, map, num_maps,
+			PIN_MAP_TYPE_CONFIGS_PIN);
+}
 
 #endif
 
-- 
1.7.1.1

