Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaAYSgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:36:52 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:61960 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaAYSed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:34:33 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] pinctrl: mvebu: dove: request syscon regmap for global registers
Date: Sat, 25 Jan 2014 19:34:12 +0100
Message-Id: <1390674856-4993-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dove pinctrl uses some global config registers to control pins.
This patch requests a syscon regmap for those registers. As this
changes DT to driver requirements, fallback to a self-registered
regmap with hardcoded resources, if the corresponding syscon DT
node is missing. Also, WARN about old DT binding usage to encourage
users to update their DTBs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/Kconfig        |  1 +
 drivers/pinctrl/mvebu/pinctrl-dove.c | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/pinctrl/mvebu/Kconfig b/drivers/pinctrl/mvebu/Kconfig
index 366fa541ee91..8dc4948c1202 100644
--- a/drivers/pinctrl/mvebu/Kconfig
+++ b/drivers/pinctrl/mvebu/Kconfig
@@ -8,6 +8,7 @@ config PINCTRL_MVEBU
 config PINCTRL_DOVE
 	bool
 	select PINCTRL_MVEBU
+	select MFD_SYSCON
 
 config PINCTRL_KIRKWOOD
 	bool
diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 3f34975c441f..d2ad130ba21e 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -18,7 +18,9 @@
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/mfd/syscon.h>
 #include <linux/pinctrl/pinctrl.h>
+#include <linux/regmap.h>
 
 #include "pinctrl-mvebu.h"
 
@@ -26,6 +28,7 @@
 #define INT_REGS_MASK			~(SZ_1M - 1)
 #define MPP4_REGS_OFFS			0xd0440
 #define PMU_REGS_OFFS			0xd802c
+#define GC_REGS_OFFS			0xe802c
 
 #define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
 #define DOVE_MPP_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE + 0xd0200)
@@ -63,6 +66,7 @@
 static void __iomem *mpp_base;
 static void __iomem *mpp4_base;
 static void __iomem *pmu_base;
+static struct regmap *gconfmap;
 
 static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 				 unsigned long *config)
@@ -781,6 +785,13 @@ static struct of_device_id dove_pinctrl_of_match[] = {
 	{ }
 };
 
+static struct regmap_config gc_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.max_register = 5,
+};
+
 static int dove_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match =
@@ -819,6 +830,22 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	if (IS_ERR(pmu_base))
 		return PTR_ERR(pmu_base);
 
+	gconfmap = syscon_regmap_lookup_by_compatible("marvell,dove-global-config");
+	if (IS_ERR(gconfmap)) {
+		void __iomem *gc_base;
+
+		dev_warn(&pdev->dev, "falling back to hardcoded global registers\n");
+		adjust_resource(&res_fallback,
+			(mpp_res->start & INT_REGS_MASK) + GC_REGS_OFFS, 0x14);
+		gc_base = devm_ioremap_resource(&pdev->dev, &res_fallback);
+		if (IS_ERR(gc_base))
+			return PTR_ERR(gc_base);
+		gconfmap = devm_regmap_init_mmio(&pdev->dev,
+						 gc_base, &gc_regmap_config);
+		if (IS_ERR(gconfmap))
+			return PTR_ERR(gconfmap);
+	}
+
 	/* Warn on any missing DT resource */
 	WARN(res_fallback.start, "Missing pinctrl regs in DTB. Please update your firmware.\n");
 
-- 
1.8.5.2

