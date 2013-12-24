Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3LXBQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:16:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49691 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab3LXBMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:12:45 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v4 08/15] clk: qcom: Add reset controller support
Date: Mon, 23 Dec 2013 17:12:32 -0800
Message-Id: <1387847559-18330-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset controllers and clock controllers are combined into one IP
block on Qualcomm chipsets. Usually a reset signal is associated
with each clock branch but sometimes a reset signal is associated
with a handful of clocks. Either way the register interface is
the same; set a bit to assert a reset and clear a bit to deassert
a reset. Add support for these types of resets signals.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig  |  2 +-
 drivers/clk/qcom/Makefile |  1 +
 drivers/clk/qcom/reset.c  | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/reset.h  | 37 ++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/qcom/reset.c
 create mode 100644 drivers/clk/qcom/reset.h

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 73a8c8f..06ccce6 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -2,4 +2,4 @@ config COMMON_CLK_QCOM
 	tristate "Support for Qualcomm's clock controllers"
 	depends on OF
 	select REGMAP_MMIO
-
+	select RESET_CONTROLLER
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index 58a5ab3..b2568be 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -4,3 +4,4 @@ clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-pll.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg2.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-branch.o
+clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += reset.o
diff --git a/drivers/clk/qcom/reset.c b/drivers/clk/qcom/reset.c
new file mode 100644
index 0000000..6c977d3
--- /dev/null
+++ b/drivers/clk/qcom/reset.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#include <linux/bitops.h>
+#include <linux/export.h>
+#include <linux/regmap.h>
+#include <linux/reset-controller.h>
+#include <linux/delay.h>
+
+#include "reset.h"
+
+static int qcom_reset(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	rcdev->ops->assert(rcdev, id);
+	udelay(1);
+	rcdev->ops->deassert(rcdev, id);
+	return 0;
+}
+
+static int
+qcom_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	struct qcom_reset_controller *rst;
+	const struct qcom_reset_map *map;
+	u32 mask;
+
+	rst = to_qcom_reset_controller(rcdev);
+	map = &rst->reset_map[id];
+	mask = BIT(map->bit);
+
+	return regmap_update_bits(rst->regmap, map->reg, mask, mask);
+}
+
+static int
+qcom_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	struct qcom_reset_controller *rst;
+	const struct qcom_reset_map *map;
+	u32 mask;
+
+	rst = to_qcom_reset_controller(rcdev);
+	map = &rst->reset_map[id];
+	mask = BIT(map->bit);
+
+	return regmap_update_bits(rst->regmap, map->reg, mask, 0);
+}
+
+struct reset_control_ops qcom_reset_ops = {
+	.reset = qcom_reset,
+	.assert = qcom_reset_assert,
+	.deassert = qcom_reset_deassert,
+};
+EXPORT_SYMBOL_GPL(qcom_reset_ops);
diff --git a/drivers/clk/qcom/reset.h b/drivers/clk/qcom/reset.h
new file mode 100644
index 0000000..e22b167
--- /dev/null
+++ b/drivers/clk/qcom/reset.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#ifndef __MSM_CLK_RESET_H__
+#define __MSM_CLK_RESET_H__
+
+#include <linux/reset-controller.h>
+
+struct qcom_reset_map {
+	unsigned int reg;
+	u8 bit;
+};
+
+struct regmap;
+
+struct qcom_reset_controller {
+	const struct qcom_reset_map *reset_map;
+	struct regmap *regmap;
+	struct reset_controller_dev rcdev;
+};
+
+#define to_qcom_reset_controller(r) \
+	container_of(r, struct qcom_reset_controller, rcdev);
+
+extern struct reset_control_ops qcom_reset_ops;
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

