Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3HEHUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:20:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7645 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3HEHUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:20:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 05 Aug 2013 00:19:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linus.walleij@linaro.org>
CC: <ian.campbell@citrix.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <rob@landley.net>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <grant.likely@linaro.org>,
        <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/3] pinctrl: add utility functions for add map/configs
Date: Mon, 5 Aug 2013 13:03:32 +0530
Message-ID: <1375688014-6117-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1375688014-6117-1-git-send-email-ldewangan@nvidia.com>
References: <1375688014-6117-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of pincontrol driver needs the utility function to create map
list. The utility function needed for adding mux, configs etc.

In place of duplicating this in each driver, add the common utility
function in common file and use from device specific driver. This will
reduce the duplicating of code across drivers.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- Add this files in this patch and add common utility APIs to here.

 drivers/pinctrl/Makefile        |    2 +-
 drivers/pinctrl/pinctrl-utils.c |  135 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-utils.h |   42 ++++++++++++
 3 files changed, 178 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-utils.c
 create mode 100644 drivers/pinctrl/pinctrl-utils.h

diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index d64563b..bc03a6e 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -2,7 +2,7 @@
 
 ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 
-obj-$(CONFIG_PINCTRL)		+= core.o
+obj-$(CONFIG_PINCTRL)		+= core.o pinctrl-utils.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
 ifeq ($(CONFIG_OF),y)
diff --git a/drivers/pinctrl/pinctrl-utils.c b/drivers/pinctrl/pinctrl-utils.c
new file mode 100644
index 0000000..b7ac646
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-utils.c
@@ -0,0 +1,135 @@
+/*
+ * Utils functions to implement the pincontrol driver.
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307, USA
+ */
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include "core.h"
+#include "pinctrl-utils.h"
+
+int pinctrl_utils_reserve_map(struct pinctrl_dev *pctldev,
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
+		dev_err(pctldev->dev, "krealloc(map) failed\n");
+		return -ENOMEM;
+	}
+
+	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
+
+	*map = new_map;
+	*reserved_maps = new_num;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinctrl_utils_reserve_map);
+
+int pinctrl_utils_add_map_mux(struct pinctrl_dev *pctldev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		const char *function)
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
+EXPORT_SYMBOL_GPL(pinctrl_utils_add_map_mux);
+
+int pinctrl_utils_add_map_configs(struct pinctrl_dev *pctldev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		unsigned long *configs, unsigned num_configs,
+		enum pinctrl_map_type type)
+{
+	unsigned long *dup_configs;
+
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs) {
+		dev_err(pctldev->dev, "kmemdup(configs) failed\n");
+		return -ENOMEM;
+	}
+
+	(*map)[*num_maps].type = type;
+	(*map)[*num_maps].data.configs.group_or_pin = group;
+	(*map)[*num_maps].data.configs.configs = dup_configs;
+	(*map)[*num_maps].data.configs.num_configs = num_configs;
+	(*num_maps)++;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinctrl_utils_add_map_configs);
+
+int pinctrl_utils_add_config(struct pinctrl_dev *pctldev,
+		unsigned long **configs, unsigned *num_configs,
+		unsigned long config)
+{
+	unsigned old_num = *num_configs;
+	unsigned new_num = old_num + 1;
+	unsigned long *new_configs;
+
+	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
+			       GFP_KERNEL);
+	if (!new_configs) {
+		dev_err(pctldev->dev, "krealloc(configs) failed\n");
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
+EXPORT_SYMBOL_GPL(pinctrl_utils_add_config);
+
+void pinctrl_utils_dt_free_map(struct pinctrl_dev *pctldev,
+	      struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+EXPORT_SYMBOL_GPL(pinctrl_utils_dt_free_map);
diff --git a/drivers/pinctrl/pinctrl-utils.h b/drivers/pinctrl/pinctrl-utils.h
new file mode 100644
index 0000000..932f149
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-utils.h
@@ -0,0 +1,42 @@
+/*
+ * Utils functions to implement the pincontrol driver.
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307, USA
+ */
+#ifndef __PINCTRL_UTILS_H__
+#define __PINCTRL_UTILS_H__
+
+int pinctrl_utils_reserve_map(struct pinctrl_dev *pctldev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, unsigned reserve);
+int pinctrl_utils_add_map_mux(struct pinctrl_dev *pctldev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		const char *function);
+int pinctrl_utils_add_map_configs(struct pinctrl_dev *pctldev,
+		struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		unsigned long *configs, unsigned num_configs,
+		enum pinctrl_map_type type);
+int pinctrl_utils_add_config(struct pinctrl_dev *pctldev,
+		unsigned long **configs, unsigned *num_configs,
+		unsigned long config);
+void pinctrl_utils_dt_free_map(struct pinctrl_dev *pctldev,
+		struct pinctrl_map *map, unsigned num_maps);
+#endif /* __PINCTRL_UTILS_H__ */
-- 
1.7.1.1

