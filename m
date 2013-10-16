Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab3JPHl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:41:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43985 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004Ab3JPHkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:40:21 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v3 09/12] clk: msm: Add reset controller support
Date: Wed, 16 Oct 2013 00:40:11 -0700
Message-Id: <1381909214-12693-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.1.503.g2b7ca91
In-Reply-To: <1381909214-12693-1-git-send-email-sboyd@codeaurora.org>
References: <1381909214-12693-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset controllers and clock controllers are combined into one IP
block on qualcomm chipsets. Usually a reset signal is
associated with each clock branch but sometimes a reset signal is
associated with a handful of clocks. Either way the register
interface is the same; set a bit to assert a reset and clear a
bit to deassert a reset. Add support for these types of resets
signals.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/msm/Kconfig  |  1 +
 drivers/clk/msm/Makefile |  1 +
 drivers/clk/msm/reset.c  | 63 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/msm/reset.h  | 37 ++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+)
 create mode 100644 drivers/clk/msm/reset.c
 create mode 100644 drivers/clk/msm/reset.h

diff --git a/drivers/clk/msm/Kconfig b/drivers/clk/msm/Kconfig
index 91558ce..5229c7e 100644
--- a/drivers/clk/msm/Kconfig
+++ b/drivers/clk/msm/Kconfig
@@ -2,4 +2,5 @@ config COMMON_CLK_MSM
 	tristate "Support for Qualcomm's MSM designs"
 	depends on OF
 	select REGMAP_MMIO
+	select RESET_CONTROLLER
 
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index e1cee29..8e4c799 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -4,3 +4,4 @@ clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-pll.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-branch.o
+clk-msm-$(CONFIG_COMMON_CLK_MSM) += reset.o
diff --git a/drivers/clk/msm/reset.c b/drivers/clk/msm/reset.c
new file mode 100644
index 0000000..b875dad
--- /dev/null
+++ b/drivers/clk/msm/reset.c
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
+static int msm_reset(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	rcdev->ops->assert(rcdev, id);
+	udelay(1);
+	rcdev->ops->deassert(rcdev, id);
+	return 0;
+}
+
+static int
+msm_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	struct msm_reset_controller *rst;
+	const struct msm_reset_map *map;
+	u32 mask;
+
+	rst = to_msm_reset_controller(rcdev);
+	map = &rst->reset_map[id];
+	mask = BIT(map->bit);
+
+	return regmap_update_bits(rst->regmap, map->reg, mask, mask);
+}
+
+static int
+msm_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	struct msm_reset_controller *rst;
+	const struct msm_reset_map *map;
+	u32 mask;
+
+	rst = to_msm_reset_controller(rcdev);
+	map = &rst->reset_map[id];
+	mask = BIT(map->bit);
+
+	return regmap_update_bits(rst->regmap, map->reg, mask, 0);
+}
+
+struct reset_control_ops msm_reset_ops = {
+	.reset = msm_reset,
+	.assert = msm_reset_assert,
+	.deassert = msm_reset_deassert,
+};
+EXPORT_SYMBOL_GPL(msm_reset_ops);
diff --git a/drivers/clk/msm/reset.h b/drivers/clk/msm/reset.h
new file mode 100644
index 0000000..09de265
--- /dev/null
+++ b/drivers/clk/msm/reset.h
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
+struct msm_reset_map {
+	unsigned int reg;
+	u8 bit;
+};
+
+struct regmap;
+
+struct msm_reset_controller {
+	const struct msm_reset_map *reset_map;
+	struct regmap *regmap;
+	struct reset_controller_dev rcdev;
+};
+
+#define to_msm_reset_controller(r) \
+	container_of(r, struct msm_reset_controller, rcdev);
+
+extern struct reset_control_ops msm_reset_ops;
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

