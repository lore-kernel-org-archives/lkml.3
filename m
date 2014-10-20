Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaJTIK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:10:28 -0400
Received: from down.free-electrons.com ([37.187.137.238]:47636 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752951AbaJTIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:10:14 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] pinctrl: add helpers for group based drivers
Date: Mon, 20 Oct 2014 10:04:18 +0200
Message-Id: <1413792260-4265-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the group based drivers have their dt properties documented in the
generic pinctrl documentation, add generic helpers to avoid duplicating
code and to be sure new drivers won't use specific bindings for a known
purpose.

This patch add two functions to help group based drivers map their
nodes:
- of_pinctrl_utils_read_function(): reads the function name of a
  specified node, and gets the number of groups it should be
  applied to.
- of_pinctrl_for_each_function_group(): navigates through the groups of
  a specified node, reading at each iteration the name of the current
  group.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/pinctrl/pinctrl-utils.c | 26 ++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-utils.h |  9 +++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-utils.c b/drivers/pinctrl/pinctrl-utils.c
index d77693f2cc1b..0ce44ff70197 100644
--- a/drivers/pinctrl/pinctrl-utils.c
+++ b/drivers/pinctrl/pinctrl-utils.c
@@ -140,3 +140,29 @@ void pinctrl_utils_dt_free_map(struct pinctrl_dev *pctldev,
 	kfree(map);
 }
 EXPORT_SYMBOL_GPL(pinctrl_utils_dt_free_map);
+
+#ifdef CONFIG_OF
+int of_pinctrl_utils_read_function(struct pinctrl_dev *pctldev,
+		struct device_node *node, const char **function_name,
+		int *ngroups)
+{
+	int ret;
+
+	ret = of_property_read_string(node, "function", function_name);
+	if (ret) {
+		dev_err(pctldev->dev, "missing function property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	*ngroups = of_property_count_strings(node, "groups");
+	if (ngroups <= 0) {
+		dev_err(pctldev->dev, "missing groups property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_pinctrl_utils_read_function);
+#endif
diff --git a/drivers/pinctrl/pinctrl-utils.h b/drivers/pinctrl/pinctrl-utils.h
index d0ffe1ce200f..d768dfe5daee 100644
--- a/drivers/pinctrl/pinctrl-utils.h
+++ b/drivers/pinctrl/pinctrl-utils.h
@@ -40,4 +40,13 @@ int pinctrl_utils_add_config(struct pinctrl_dev *pctldev,
 void pinctrl_utils_dt_free_map(struct pinctrl_dev *pctldev,
 		struct pinctrl_map *map, unsigned num_maps);
 
+#ifdef CONFIG_OF
+int of_pinctrl_utils_read_function(struct pinctrl_dev *pctrldev,
+		struct device_node *node, const char **function_name,
+		int *ngroups);
+
+#define of_pinctrl_for_each_function_group(node, prop, group_name)	\
+		of_property_for_each_string(node, "groups", prop, group_name)
+#endif
+
 #endif /* __PINCTRL_UTILS_H__ */
-- 
1.9.1

