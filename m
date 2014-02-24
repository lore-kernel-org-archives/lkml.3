Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaBXInW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:43:22 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33517 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBXInO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:43:14 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] pinctrl: mvebu: dove: request syscon regmap for global registers
Date: Mon, 24 Feb 2014 09:42:58 +0100
Message-Id: <1393231382-11078-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/Kconfig        |  1 +
 drivers/pinctrl/mvebu/pinctrl-dove.c | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/pinctrl/mvebu/Kconfig b/drivers/pinctrl/mvebu/Kconfig
index a22b0302922d..cc298fade93a 100644
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
index 8d57d4bc1f0c..e4f954a78b15 100644
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
 #define INT_REGS_MASK		~(SZ_1M - 1)
 #define MPP4_REGS_OFFS		0xd0440
 #define PMU_REGS_OFFS		0xd802c
+#define GC_REGS_OFFS		0xe802c
 
 #define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
 #define DOVE_MPP_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE + 0xd0200)
@@ -59,6 +62,7 @@
 static void __iomem *mpp_base;
 static void __iomem *mpp4_base;
 static void __iomem *pmu_base;
+static struct regmap *gconfmap;
 
 static int dove_mpp_ctrl_get(unsigned pid, unsigned long *config)
 {
@@ -756,6 +760,13 @@ static struct of_device_id dove_pinctrl_of_match[] = {
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
 	struct resource *res, *mpp_res;
@@ -808,6 +819,22 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	if (IS_ERR(pmu_base))
 		return PTR_ERR(pmu_base);
 
+	gconfmap = syscon_regmap_lookup_by_compatible("marvell,dove-global-config");
+	if (IS_ERR(gconfmap)) {
+		void __iomem *gc_base;
+
+		dev_warn(&pdev->dev, "falling back to hardcoded global registers\n");
+		adjust_resource(&fb_res,
+			(mpp_res->start & INT_REGS_MASK) + GC_REGS_OFFS, 0x14);
+		gc_base = devm_ioremap_resource(&pdev->dev, &fb_res);
+		if (IS_ERR(gc_base))
+			return PTR_ERR(gc_base);
+		gconfmap = devm_regmap_init_mmio(&pdev->dev,
+						 gc_base, &gc_regmap_config);
+		if (IS_ERR(gconfmap))
+			return PTR_ERR(gconfmap);
+	}
+
 	/* Warn on any missing DT resource */
 	WARN(fb_res.start, FW_BUG "Missing pinctrl regs in DTB. Please update your firmware.\n");
 
-- 
1.8.5.3

