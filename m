Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3HFM7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:59:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15453 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab3HFM71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:59:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Aug 2013 05:59:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linus.walleij@linaro.org>
CC: <ian.campbell@citrix.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <rob@landley.net>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <grant.likely@linaro.org>,
        <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 2/3] pinctrl: pinconf-generic: add generic APIs for mapping pinctrl node
Date: Tue, 6 Aug 2013 18:42:34 +0530
Message-ID: <1375794755-6246-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1375794755-6246-1-git-send-email-ldewangan@nvidia.com>
References: <1375794755-6246-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic APIs to map the DT node and its sub node in pinconf generic
driver. These APIs can be used from driver to parse the DT node who
uses the pinconf generic APIs for defining their nodes.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes from V1: 
- Add generic property for pins and functions in pinconf-generic.
- Add APIs to map the DT and subnode.
- Move common utils APIs to the pinctrl-utils from this file.
- Update the binding document accordingly.
Changes from V2:
- Rebased the pinctrl binding doc on top of Stephen's cleanup.
- Rename properties "pinctrl-pins" and "pinctrl-function" to
  "pins" and "function".

 .../bindings/pinctrl/pinctrl-bindings.txt          |    3 +
 drivers/pinctrl/pinconf-generic.c                  |   96 ++++++++++++++++++++
 include/linux/pinctrl/pinconf-generic.h            |    6 ++
 3 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index 237823a..4546b23 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -172,3 +172,6 @@ arguments are described below.
 
 More in-depth documentation on these parameters can be found in
 <include/linux/pinctrl/pinconfig-generic.h>
+
+The valid pin names and function are device/chip specific and it can be
+found from the device/chip specific binding documents.
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 8594f03..d9536ca 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include "core.h"
 #include "pinconf.h"
+#include "pinctrl-utils.h"
 
 #ifdef CONFIG_DEBUG_FS
 
@@ -236,4 +237,99 @@ out:
 	kfree(cfg);
 	return ret;
 }
+
+int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *np, struct pinctrl_map **map,
+		unsigned *reserved_maps, unsigned *num_maps)
+{
+	int ret;
+	const char *function;
+	struct device *dev = pctldev->dev;
+	unsigned long *configs = NULL;
+	unsigned num_configs = 0;
+	unsigned reserve;
+	struct property *prop;
+	const char *group;
+
+	ret = of_property_read_string(np, "function", &function);
+	if (ret < 0) {
+		/* EINVAL=missing, which is fine since it's optional */
+		if (ret != -EINVAL)
+			dev_err(dev,
+				"could not parse property ti,function\n");
+		function = NULL;
+	}
+
+	ret = pinconf_generic_parse_dt_config(np, &configs, &num_configs);
+	if (ret < 0) {
+		dev_err(dev, "could not parse node property\n");
+		return ret;
+	}
+
+	reserve = 0;
+	if (function != NULL)
+		reserve++;
+	if (num_configs)
+		reserve++;
+	ret = of_property_count_strings(np, "pins");
+	if (ret < 0) {
+		dev_err(dev, "could not parse property ti,pins\n");
+		goto exit;
+	}
+	reserve *= ret;
+
+	ret = pinctrl_utils_reserve_map(pctldev, map, reserved_maps,
+			num_maps, reserve);
+	if (ret < 0)
+		goto exit;
+
+	of_property_for_each_string(np, "pins", prop, group) {
+		if (function) {
+			ret = pinctrl_utils_add_map_mux(pctldev, map,
+					reserved_maps, num_maps, group,
+					function);
+			if (ret < 0)
+				goto exit;
+		}
+
+		if (num_configs) {
+			ret = pinctrl_utils_add_map_configs(pctldev, map,
+					reserved_maps, num_maps, group, configs,
+					num_configs, PIN_MAP_TYPE_CONFIGS_PIN);
+			if (ret < 0)
+				goto exit;
+		}
+	}
+	ret = 0;
+
+exit:
+	kfree(configs);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_dt_subnode_to_map);
+
+int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *np_config, struct pinctrl_map **map,
+		unsigned *num_maps)
+{
+	unsigned reserved_maps;
+	struct device_node *np;
+	int ret;
+
+	reserved_maps = 0;
+	*map = NULL;
+	*num_maps = 0;
+
+	for_each_child_of_node(np_config, np) {
+		ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
+						&reserved_maps, num_maps);
+		if (ret < 0) {
+			pinctrl_utils_dt_free_map(pctldev, *map, *num_maps);
+			return ret;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_dt_node_to_map);
+
 #endif
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index bf7e989..a472b93 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -137,6 +137,12 @@ static inline unsigned long pinconf_to_config_packed(enum pin_config_param param
 	return PIN_CONF_PACKED(param, argument);
 }
 
+int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *np, struct pinctrl_map **map,
+		unsigned *reserved_maps, unsigned *num_maps);
+int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *np_config, struct pinctrl_map **map,
+		unsigned *num_maps);
 #endif /* CONFIG_GENERIC_PINCONF */
 
 #endif /* __LINUX_PINCTRL_PINCONF_GENERIC_H */
-- 
1.7.1.1

