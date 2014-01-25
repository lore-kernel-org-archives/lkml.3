Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaAYShb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:37:31 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50972 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaAYSec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:34:32 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] pinctrl: mvebu: dove: request additional resources
Date: Sat, 25 Jan 2014 19:34:11 +0100
Message-Id: <1390674856-4993-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dove pinctrl also requires additional registers to control all pins.
This patch requests resources for mpp4 and pmu-mpp register ranges.
As this changes DT to driver requirements, fallback to hardcoded
resources, if the corresponding DT regs have not been set.
Also, WARN about old DT binding usage to encourage users to update
their DTBs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 52 +++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index f4141e60a52b..3f34975c441f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -22,6 +22,11 @@
 
 #include "pinctrl-mvebu.h"
 
+/* Internal registers can be configured at any 1 MiB aligned address */
+#define INT_REGS_MASK			~(SZ_1M - 1)
+#define MPP4_REGS_OFFS			0xd0440
+#define PMU_REGS_OFFS			0xd802c
+
 #define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
 #define DOVE_MPP_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE + 0xd0200)
 #define DOVE_PMU_MPP_GENERAL_CTRL	(DOVE_MPP_VIRT_BASE + 0x10)
@@ -55,6 +60,10 @@
 
 #define CONFIG_PMU	BIT(4)
 
+static void __iomem *mpp_base;
+static void __iomem *mpp4_base;
+static void __iomem *pmu_base;
+
 static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 				 unsigned long *config)
 {
@@ -776,13 +785,42 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match =
 		of_match_device(dove_pinctrl_of_match, &pdev->dev);
-	struct resource *res;
-	void __iomem *base;
+	struct resource *mpp_res, *res;
+	struct resource res_fallback;
+
+	mpp_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, mpp_res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
+	/* prepare fallback resource */
+	memcpy(&res_fallback, mpp_res, sizeof(struct resource));
+	res_fallback.start = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		dev_warn(&pdev->dev, "falling back to hardcoded MPP4 resource\n");
+		adjust_resource(&res_fallback,
+			(mpp_res->start & INT_REGS_MASK) + MPP4_REGS_OFFS, 0x4);
+		res = &res_fallback;
+	}
+	mpp4_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp4_base))
+		return PTR_ERR(mpp4_base);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (!res) {
+		dev_warn(&pdev->dev, "falling back to hardcoded PMU resource\n");
+		adjust_resource(&res_fallback,
+			(mpp_res->start & INT_REGS_MASK) + PMU_REGS_OFFS, 0x8);
+		res = &res_fallback;
+	}
+	pmu_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pmu_base))
+		return PTR_ERR(pmu_base);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	/* Warn on any missing DT resource */
+	WARN(res_fallback.start, "Missing pinctrl regs in DTB. Please update your firmware.\n");
 
 	pdev->dev.platform_data = (void *)match->data;
 
@@ -797,7 +835,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	return mvebu_pinctrl_probe(pdev, base);
+	return mvebu_pinctrl_probe(pdev, mpp_base);
 }
 
 static int dove_pinctrl_remove(struct platform_device *pdev)
-- 
1.8.5.2

