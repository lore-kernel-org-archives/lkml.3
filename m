Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab3GZKFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:05:11 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19078 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab3GZKEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:04:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 26 Jul 2013 03:04:50 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@linaro.org>, <linus.walleij@linaro.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] pinctrl: pinconf_generic: add utility functions for add map/configs
Date: Fri, 26 Jul 2013 15:45:53 +0530
Message-ID: <1374833754-19659-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com>
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of pincontrol driver needs the utility function to create map
list. The utility function needed for adding mux, configs etc.

In place of duplicating this in each driver, add the common utility
function in pin_conf and use from device specific driver. This will
reduce the duplicating of code across drivers.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/pinctrl/pinconf-generic.c       |  105 +++++++++++++++++++++++++++++++
 include/linux/pinctrl/pinconf-generic.h |   52 +++++++++++++++
 2 files changed, 157 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 8594f03..d9eae95 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -236,4 +236,109 @@ out:
 	kfree(cfg);
 	return ret;
 }
+
+int pinconf_generic_reserve_map(struct device *dev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, unsigned reserve)
+{
+	unsigned old_num = *reserved_maps;
+	unsigned new_num = *num_maps + reserve;
+	struct pinctrl_map *new_map;
+
+	if (old_num >= new_num)
+		return 0;
+
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map) {
+		dev_err(dev, "krealloc(map) failed\n");
+		return -ENOMEM;
+	}
+
+	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
+
+	*map = new_map;
+	*reserved_maps = new_num;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_reserve_map);
+
+int pinconf_generic_add_map_mux(struct pinctrl_map **map,
+		unsigned *reserved_maps, unsigned *num_maps,
+		const char *group, const char *function)
+{
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[*num_maps].data.mux.group = group;
+	(*map)[*num_maps].data.mux.function = function;
+	(*num_maps)++;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_add_map_mux);
+
+int pinconf_generic_add_map_configs(struct device *dev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		unsigned long *configs, unsigned num_configs)
+{
+	unsigned long *dup_configs;
+
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs) {
+		dev_err(dev, "kmemdup(configs) failed\n");
+		return -ENOMEM;
+	}
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+	(*map)[*num_maps].data.configs.group_or_pin = group;
+	(*map)[*num_maps].data.configs.configs = dup_configs;
+	(*map)[*num_maps].data.configs.num_configs = num_configs;
+	(*num_maps)++;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_add_map_configs);
+
+int pinconf_generic_add_config(struct device *dev, unsigned long **configs,
+		      unsigned *num_configs, unsigned long config)
+{
+	unsigned old_num = *num_configs;
+	unsigned new_num = old_num + 1;
+	unsigned long *new_configs;
+
+	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
+			       GFP_KERNEL);
+	if (!new_configs) {
+		dev_err(dev, "krealloc(configs) failed\n");
+		return -ENOMEM;
+	}
+
+	new_configs[old_num] = config;
+
+	*configs = new_configs;
+	*num_configs = new_num;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_add_config);
+
+void pinconf_generic_dt_free_map(struct pinctrl_dev *pctldev,
+		      struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_dt_free_map);
+
 #endif
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index bf7e989..694ea5c 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -137,6 +137,58 @@ static inline unsigned long pinconf_to_config_packed(enum pin_config_param param
 	return PIN_CONF_PACKED(param, argument);
 }
 
+int pinconf_generic_reserve_map(struct device *dev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, unsigned reserve);
+
+int pinconf_generic_add_map_mux(struct pinctrl_map **map,
+		unsigned *reserved_maps, unsigned *num_maps,
+		const char *group, const char *function);
+
+int pinconf_generic_add_map_configs(struct device *dev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		unsigned long *configs, unsigned num_configs);
+
+int pinconf_generic_add_config(struct device *dev, unsigned long **configs,
+		unsigned *num_configs, unsigned long config);
+
+void pinconf_generic_dt_free_map(struct pinctrl_dev *pctldev,
+		struct pinctrl_map *map, unsigned num_maps);
+#else
+static inline int pinconf_generic_reserve_map(struct device *dev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, unsigned reserve)
+{
+	return -ENOTSUPP;
+}
+
+static inline int pinconf_generic_add_map_mux(struct pinctrl_map **map,
+		unsigned *reserved_maps, unsigned *num_maps,
+		const char *group, const char *function)
+{
+	return -ENOTSUPP;
+}
+
+static inline int pinconf_generic_add_map_configs(struct device *dev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		unsigned long *configs, unsigned num_configs)
+{
+	return -ENOTSUPP;
+}
+
+static inline int pinconf_generic_add_config(struct device *dev,
+		unsigned long **configs, unsigned *num_configs,
+		unsigned long config)
+{
+	return -ENOTSUPP;
+}
+
+static inline void pinconf_generic_dt_free_map(struct pinctrl_dev *pctldev,
+		struct pinctrl_map *map, unsigned num_maps)
+{
+}
 #endif /* CONFIG_GENERIC_PINCONF */
 
 #endif /* __LINUX_PINCTRL_PINCONF_GENERIC_H */
-- 
1.7.1.1

