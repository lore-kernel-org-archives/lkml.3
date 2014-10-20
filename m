Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaJTIKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:10:23 -0400
Received: from down.free-electrons.com ([37.187.137.238]:47632 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752756AbaJTIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:10:14 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2014 04:10:14 EDT
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] pinctrl: berlin: use the generic node to map function
Date: Mon, 20 Oct 2014 10:04:20 +0200
Message-Id: <1413792260-4265-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A generic node to map function has been added into the pinctrl
framework. It is provieded by GENERIC_PINCONF. Use it in the Berlin
pinctrl driver as it fits the needs.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/pinctrl/berlin/Kconfig  |  1 +
 drivers/pinctrl/berlin/berlin.c | 53 ++---------------------------------------
 2 files changed, 3 insertions(+), 51 deletions(-)

diff --git a/drivers/pinctrl/berlin/Kconfig b/drivers/pinctrl/berlin/Kconfig
index b18322bc7bf9..b38c0abf1790 100644
--- a/drivers/pinctrl/berlin/Kconfig
+++ b/drivers/pinctrl/berlin/Kconfig
@@ -2,6 +2,7 @@ if ARCH_BERLIN
 
 config PINCTRL_BERLIN
 	bool
+	select GENERIC_PINCONF
 	select PINMUX
 	select REGMAP_MMIO
 
diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c
index 86db2235ab00..da98efae8d8f 100644
--- a/drivers/pinctrl/berlin/berlin.c
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
@@ -49,56 +50,6 @@ static const char *berlin_pinctrl_get_group_name(struct pinctrl_dev *pctrl_dev,
 	return pctrl->desc->groups[group].name;
 }
 
-static int berlin_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
-					 struct device_node *node,
-					 struct pinctrl_map **map,
-					 unsigned *num_maps)
-{
-	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
-	struct property *prop;
-	const char *function_name, *group_name;
-	unsigned reserved_maps = 0;
-	int ret, ngroups;
-
-	*map = NULL;
-	*num_maps = 0;
-
-	ret = of_property_read_string(node, "function", &function_name);
-	if (ret) {
-		dev_err(pctrl->dev,
-			"missing function property in node %s\n",
-			node->name);
-		return -EINVAL;
-	}
-
-	ngroups = of_property_count_strings(node, "groups");
-	if (ngroups < 0) {
-		dev_err(pctrl->dev,
-			"missing groups property in node %s\n",
-			node->name);
-		return -EINVAL;
-	}
-
-	ret = pinctrl_utils_reserve_map(pctrl_dev, map, &reserved_maps,
-					num_maps, ngroups);
-	if (ret) {
-		dev_err(pctrl->dev, "can't reserve map: %d\n", ret);
-		return ret;
-	}
-
-	of_property_for_each_string(node, "groups", prop, group_name) {
-		ret = pinctrl_utils_add_map_mux(pctrl_dev, map, &reserved_maps,
-						num_maps, group_name,
-						function_name);
-		if (ret) {
-			dev_err(pctrl->dev, "can't add map: %d\n", ret);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static void berlin_pinctrl_dt_free_map(struct pinctrl_dev *pctrl_dev,
 				       struct pinctrl_map *map,
 				       unsigned nmaps)
@@ -121,7 +72,7 @@ static void berlin_pinctrl_dt_free_map(struct pinctrl_dev *pctrl_dev,
 static const struct pinctrl_ops berlin_pinctrl_ops = {
 	.get_groups_count	= &berlin_pinctrl_get_group_count,
 	.get_group_name		= &berlin_pinctrl_get_group_name,
-	.dt_node_to_map		= &berlin_pinctrl_dt_node_to_map,
+	.dt_node_to_map		= &pinconf_generic_function_groups_dt_node_to_map,
 	.dt_free_map		= &berlin_pinctrl_dt_free_map,
 };
 
-- 
1.9.1

