Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaA1BQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:16:16 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46611 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaA1BQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:16:15 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/21] pinctrl: mvebu: dove: request additional resources
Date: Tue, 28 Jan 2014 01:39:27 +0100
Message-Id: <1390869573-27624-16-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
Changelog:
v1->v2:
- add FW_BUG to WARN message

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 39 +++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 98f8cae72ace..bb7ff396ddd1 100644
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
@@ -56,6 +61,8 @@
 #define CONFIG_PMU	BIT(4)
 
 static void __iomem *mpp_base;
+static void __iomem *mpp4_base;
+static void __iomem *pmu_base;
 
 static int dove_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 			     unsigned long *config)
@@ -802,13 +809,43 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match =
 		of_match_device(dove_pinctrl_of_match, &pdev->dev);
-	struct resource *mpp_res;
+	struct resource *mpp_res, *res;
+	struct resource res_fallback;
 
 	mpp_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mpp_base = devm_ioremap_resource(&pdev->dev, mpp_res);
 	if (IS_ERR(mpp_base))
 		return PTR_ERR(mpp_base);
 
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
+
+	/* Warn on any missing DT resource */
+	WARN(res_fallback.start, FW_BUG "Missing pinctrl regs in DTB. Please update your firmware.\n");
+
 	pdev->dev.platform_data = (void *)match->data;
 
 	/*
-- 
1.8.5.2

