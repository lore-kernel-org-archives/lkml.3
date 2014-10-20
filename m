Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaJTIKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:10:19 -0400
Received: from down.free-electrons.com ([37.187.137.238]:47634 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752764AbaJTIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:10:14 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] pinctrl: add a generic way to map node to map for group based drivers
Date: Mon, 20 Oct 2014 10:04:19 +0200
Message-Id: <1413792260-4265-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a generic function to use a standard callback to
.dt_node_to_map for group based pinctrl drivers.

It parses nodes of the form:

	foo_pmux: foo-pmux {
		function = "foo";
		groups = "g0", "g1", "g2";
	}

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/pinctrl/pinconf-generic.c       | 36 +++++++++++++++++++++++++++++++++
 include/linux/pinctrl/pinconf-generic.h |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 29ff77f90fcb..456902150226 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -336,4 +336,40 @@ int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 }
 EXPORT_SYMBOL_GPL(pinconf_generic_dt_node_to_map);
 
+int pinconf_generic_function_groups_dt_node_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *node, struct pinctrl_map **map,
+		unsigned *num_maps)
+{
+	struct property *prop;
+	unsigned reserved_maps = 0;
+	const char *function_name, *group_name;
+	int ngroups, ret;
+
+	*map = NULL;
+	*num_maps = 0;
+
+	ret = of_pinctrl_utils_read_function(pctldev, node, &function_name,
+					     &ngroups);
+	if (ret)
+		return ret;
+
+	ret = pinctrl_utils_reserve_map(pctldev, map, &reserved_maps, num_maps,
+					ngroups);
+	if (ret)
+		return ret;
+
+	of_pinctrl_for_each_function_group(node, prop, group_name) {
+		ret = pinctrl_utils_add_map_mux(pctldev, map, &reserved_maps,
+						num_maps, group_name,
+						function_name);
+		if (ret) {
+			dev_err(pctldev->dev, "cannot add map: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinconf_generic_function_groups_dt_node_to_map);
+
 #endif
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index a15f10727eb8..acda4b89596d 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -157,6 +157,9 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np_config, struct pinctrl_map **map,
 		unsigned *num_maps, enum pinctrl_map_type type);
+int pinconf_generic_function_groups_dt_node_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *node, struct pinctrl_map **map,
+		unsigned *num_maps);
 
 static inline int pinconf_generic_dt_node_to_map_group(
 		struct pinctrl_dev *pctldev, struct device_node *np_config,
-- 
1.9.1

