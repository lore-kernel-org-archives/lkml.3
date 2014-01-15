Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaAOSv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:51:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49378 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaAOSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v5 03/14] clk: qcom: Add a regmap type clock struct
Date: Wed, 15 Jan 2014 10:47:23 -0800
Message-Id: <1389811654-21397-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock type that associates a regmap pointer and some
enable/disable bits with a clk_hw struct. This will be the struct
that a hw specific implementation wraps if it wants to use the
regmap helper functions.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/Kconfig           |   2 +
 drivers/clk/Makefile          |   1 +
 drivers/clk/qcom/Kconfig      |   5 ++
 drivers/clk/qcom/Makefile     |   3 ++
 drivers/clk/qcom/clk-regmap.c | 114 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-regmap.h |  45 +++++++++++++++++
 6 files changed, 170 insertions(+)
 create mode 100644 drivers/clk/qcom/Kconfig
 create mode 100644 drivers/clk/qcom/Makefile
 create mode 100644 drivers/clk/qcom/clk-regmap.c
 create mode 100644 drivers/clk/qcom/clk-regmap.h

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 5c51115081b3..afd2a45bba82 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -107,6 +107,8 @@ config COMMON_CLK_KEYSTONE
           Supports clock drivers for Keystone based SOCs. These SOCs have local
 	  a power sleep control module that gate the clock to the IPs and PLLs.
 
+source "drivers/clk/qcom/Kconfig"
+
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 7a10bc9a23e7..088b517245cd 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_U300)		+= clk-u300.o
 obj-$(CONFIG_COMMON_CLK_VERSATILE) += versatile/
 obj-$(CONFIG_ARCH_SIRF)		+= clk-prima2.o
+obj-$(CONFIG_COMMON_CLK_QCOM)	+= qcom/
 obj-$(CONFIG_PLAT_ORION)	+= mvebu/
 ifeq ($(CONFIG_COMMON_CLK), y)
 obj-$(CONFIG_ARCH_MMP)		+= mmp/
diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
new file mode 100644
index 000000000000..73a8c8fb547f
--- /dev/null
+++ b/drivers/clk/qcom/Kconfig
@@ -0,0 +1,5 @@
+config COMMON_CLK_QCOM
+	tristate "Support for Qualcomm's clock controllers"
+	depends on OF
+	select REGMAP_MMIO
+
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
new file mode 100644
index 000000000000..f9faa8fa9392
--- /dev/null
+++ b/drivers/clk/qcom/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_COMMON_CLK_QCOM) += clk-qcom.o
+
+clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-regmap.o
diff --git a/drivers/clk/qcom/clk-regmap.c b/drivers/clk/qcom/clk-regmap.c
new file mode 100644
index 000000000000..a58ba39a900c
--- /dev/null
+++ b/drivers/clk/qcom/clk-regmap.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+#include <linux/export.h>
+
+#include "clk-regmap.h"
+
+/**
+ * clk_is_enabled_regmap - standard is_enabled() for regmap users
+ *
+ * @hw: clk to operate on
+ *
+ * Clocks that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their struct clk_regmap and then use
+ * this as their is_enabled operation, saving some code.
+ */
+int clk_is_enabled_regmap(struct clk_hw *hw)
+{
+	struct clk_regmap *rclk = to_clk_regmap(hw);
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(rclk->regmap, rclk->enable_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	if (rclk->enable_is_inverted)
+		return (val & rclk->enable_mask) == 0;
+	else
+		return (val & rclk->enable_mask) != 0;
+}
+EXPORT_SYMBOL_GPL(clk_is_enabled_regmap);
+
+/**
+ * clk_enable_regmap - standard enable() for regmap users
+ *
+ * @hw: clk to operate on
+ *
+ * Clocks that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their struct clk_regmap and then use
+ * this as their enable() operation, saving some code.
+ */
+int clk_enable_regmap(struct clk_hw *hw)
+{
+	struct clk_regmap *rclk = to_clk_regmap(hw);
+	unsigned int val;
+
+	if (rclk->enable_is_inverted)
+		val = 0;
+	else
+		val = rclk->enable_mask;
+
+	return regmap_update_bits(rclk->regmap, rclk->enable_reg,
+				  rclk->enable_mask, val);
+}
+EXPORT_SYMBOL_GPL(clk_enable_regmap);
+
+/**
+ * clk_disable_regmap - standard disable() for regmap users
+ *
+ * @hw: clk to operate on
+ *
+ * Clocks that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their struct clk_regmap and then use
+ * this as their disable() operation, saving some code.
+ */
+void clk_disable_regmap(struct clk_hw *hw)
+{
+	struct clk_regmap *rclk = to_clk_regmap(hw);
+	unsigned int val;
+
+	if (rclk->enable_is_inverted)
+		val = rclk->enable_mask;
+	else
+		val = 0;
+
+	regmap_update_bits(rclk->regmap, rclk->enable_reg, rclk->enable_mask,
+			   val);
+}
+EXPORT_SYMBOL_GPL(clk_disable_regmap);
+
+/**
+ * devm_clk_register_regmap - register a clk_regmap clock
+ *
+ * @rclk: clk to operate on
+ *
+ * Clocks that use regmap for their register I/O should register their
+ * clk_regmap struct via this function so that the regmap is initialized
+ * and so that the clock is registered with the common clock framework.
+ */
+struct clk *devm_clk_register_regmap(struct device *dev,
+				     struct clk_regmap *rclk)
+{
+	if (dev && dev_get_regmap(dev, NULL))
+		rclk->regmap = dev_get_regmap(dev, NULL);
+	else if (dev && dev->parent)
+		rclk->regmap = dev_get_regmap(dev->parent, NULL);
+
+	return devm_clk_register(dev, &rclk->hw);
+}
+EXPORT_SYMBOL_GPL(devm_clk_register_regmap);
diff --git a/drivers/clk/qcom/clk-regmap.h b/drivers/clk/qcom/clk-regmap.h
new file mode 100644
index 000000000000..491a63d537df
--- /dev/null
+++ b/drivers/clk/qcom/clk-regmap.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __QCOM_CLK_REGMAP_H__
+#define __QCOM_CLK_REGMAP_H__
+
+#include <linux/clk-provider.h>
+
+struct regmap;
+
+/**
+ * struct clk_regmap - regmap supporting clock
+ * @hw:		handle between common and hardware-specific interfaces
+ * @regmap:	regmap to use for regmap helpers and/or by providers
+ * @enable_reg: register when using regmap enable/disable ops
+ * @enable_mask: mask when using regmap enable/disable ops
+ * @enable_is_inverted: flag to indicate set enable_mask bits to disable
+ *                      when using clock_enable_regmap and friends APIs.
+ */
+struct clk_regmap {
+	struct clk_hw hw;
+	struct regmap *regmap;
+	unsigned int enable_reg;
+	unsigned int enable_mask;
+	bool enable_is_inverted;
+};
+#define to_clk_regmap(_hw) container_of(_hw, struct clk_regmap, hw)
+
+int clk_is_enabled_regmap(struct clk_hw *hw);
+int clk_enable_regmap(struct clk_hw *hw);
+void clk_disable_regmap(struct clk_hw *hw);
+struct clk *
+devm_clk_register_regmap(struct device *dev, struct clk_regmap *rclk);
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

