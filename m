Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaI3HOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:14:43 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62297 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaI3HOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:14:41 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] pinctrl: nomadik: refactor DT parser to take two paths
Date: Tue, 30 Sep 2014 09:14:35 +0200
Message-Id: <1412061275-20829-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We refactor the DT parser to look for either a config or a
function and then look for further nodes and reserve maps,
not the two things mixed up like prior to this patch.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-nomadik.c | 62 ++++++++++++++++---------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index 6c9667a44b7b..09efb8c1a2eb 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1505,51 +1505,55 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	const char *function = NULL;
 	unsigned long configs = 0;
 	bool has_config = 0;
-	unsigned reserve = 0;
 	struct property *prop;
 	const char *group, *gpio_name;
 	struct device_node *np_config;
 
 	ret = of_property_read_string(np, "ste,function", &function);
-	if (ret >= 0)
-		reserve = 1;
-
-	has_config = nmk_pinctrl_dt_get_config(np, &configs);
-
-	np_config = of_parse_phandle(np, "ste,config", 0);
-	if (np_config)
-		has_config |= nmk_pinctrl_dt_get_config(np_config, &configs);
-
-	ret = of_property_count_strings(np, "ste,pins");
-	if (ret < 0)
-		goto exit;
-
-	if (has_config)
-		reserve++;
-
-	reserve *= ret;
-
-	ret = pinctrl_utils_reserve_map(pctldev, map, reserved_maps, num_maps, reserve);
-	if (ret < 0)
-		goto exit;
-
-	of_property_for_each_string(np, "ste,pins", prop, group) {
-		if (function) {
+	if (ret >= 0) {
+		ret = of_property_count_strings(np, "ste,pins");
+		if (ret < 0)
+			goto exit;
+
+		ret = pinctrl_utils_reserve_map(pctldev, map,
+						reserved_maps,
+						num_maps, ret);
+		if (ret < 0)
+			goto exit;
+
+		of_property_for_each_string(np, "ste,pins", prop, group) {
 			ret = nmk_dt_add_map_mux(map, reserved_maps, num_maps,
 					  group, function);
 			if (ret < 0)
 				goto exit;
 		}
-		if (has_config) {
+	}
+
+	has_config = nmk_pinctrl_dt_get_config(np, &configs);
+	np_config = of_parse_phandle(np, "ste,config", 0);
+	if (np_config)
+		has_config |= nmk_pinctrl_dt_get_config(np_config, &configs);
+	if (has_config) {
+		ret = of_property_count_strings(np, "ste,pins");
+		if (ret < 0)
+			goto exit;
+		ret = pinctrl_utils_reserve_map(pctldev, map,
+						reserved_maps,
+						num_maps, ret);
+		if (ret < 0)
+			goto exit;
+
+		of_property_for_each_string(np, "ste,pins", prop, group) {
 			gpio_name = nmk_find_pin_name(pctldev, group);
 
-			ret = nmk_dt_add_map_configs(map, reserved_maps, num_maps,
-					      gpio_name, &configs, 1);
+			ret = nmk_dt_add_map_configs(map, reserved_maps,
+						     num_maps,
+						     gpio_name, &configs, 1);
 			if (ret < 0)
 				goto exit;
 		}
-
 	}
+
 exit:
 	return ret;
 }
-- 
1.9.3

