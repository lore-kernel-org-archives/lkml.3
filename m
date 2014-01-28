Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaA1AqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:46:23 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39838 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaA1AqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:46:18 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/21] pinctrl: mvebu: prepare to fix misdesigned resource allocation
Date: Tue, 28 Jan 2014 01:39:17 +0100
Message-Id: <1390869573-27624-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocating the pinctrl resource in common pinctrl-mvebu was a misdesign,
as it does not allow SoC specific parts to access the allocated resource.
This moves resource allocation from mvebu_pinctrl_probe to SoC specific
_probe functions and temporarily passes the base address to common pinctrl
driver instead.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-armada-370.c | 10 +++++++++-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c  | 10 +++++++++-
 drivers/pinctrl/mvebu/pinctrl-dove.c       | 11 ++++++++++-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c   | 11 ++++++++++-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c      | 14 ++++++--------
 drivers/pinctrl/mvebu/pinctrl-mvebu.h      |  2 +-
 6 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-370.c b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
index ae1f760cbdd2..7586072e66c6 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-370.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
@@ -23,6 +23,8 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
 static struct mvebu_mpp_mode mv88f6710_mpp_modes[] = {
 	MPP_MODE(0,
 	   MPP_FUNCTION(0x0, "gpio", NULL),
@@ -385,6 +387,12 @@ static struct pinctrl_gpio_range mv88f6710_mpp_gpio_ranges[] = {
 static int armada_370_pinctrl_probe(struct platform_device *pdev)
 {
 	struct mvebu_pinctrl_soc_info *soc = &armada_370_pinctrl_info;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
 
 	soc->variant = 0; /* no variants for Armada 370 */
 	soc->controls = mv88f6710_mpp_controls;
@@ -396,7 +404,7 @@ static int armada_370_pinctrl_probe(struct platform_device *pdev)
 
 	pdev->dev.platform_data = soc;
 
-	return mvebu_pinctrl_probe(pdev);
+	return mvebu_pinctrl_probe(pdev, mpp_base);
 }
 
 static int armada_370_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index 843a51f9d129..786c629af8a8 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -33,6 +33,8 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
 enum armada_xp_variant {
 	V_MV78230	= BIT(0),
 	V_MV78260	= BIT(1),
@@ -399,10 +401,16 @@ static int armada_xp_pinctrl_probe(struct platform_device *pdev)
 	struct mvebu_pinctrl_soc_info *soc = &armada_xp_pinctrl_info;
 	const struct of_device_id *match =
 		of_match_device(armada_xp_pinctrl_of_match, &pdev->dev);
+	struct resource *res;
 
 	if (!match)
 		return -ENODEV;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
 	soc->variant = (unsigned) match->data & 0xff;
 
 	switch (soc->variant) {
@@ -443,7 +451,7 @@ static int armada_xp_pinctrl_probe(struct platform_device *pdev)
 
 	pdev->dev.platform_data = soc;
 
-	return mvebu_pinctrl_probe(pdev);
+	return mvebu_pinctrl_probe(pdev, mpp_base);
 }
 
 static int armada_xp_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 47268393af34..4d051ba17fee 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -55,6 +55,8 @@
 
 #define CONFIG_PMU	BIT(4)
 
+static void __iomem *mpp_base;
+
 static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 				 unsigned long *config)
 {
@@ -776,6 +778,13 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match =
 		of_match_device(dove_pinctrl_of_match, &pdev->dev);
+	struct resource *mpp_res;
+
+	mpp_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, mpp_res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
 	pdev->dev.platform_data = (void *)match->data;
 
 	/*
@@ -789,7 +798,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	return mvebu_pinctrl_probe(pdev);
+	return mvebu_pinctrl_probe(pdev, mpp_base);
 }
 
 static int dove_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
index 6b504b5935a5..842ceb196726 100644
--- a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
+++ b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
@@ -21,6 +21,8 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
 #define V(f6180, f6190, f6192, f6281, f6282, dx4122)	\
 	((f6180 << 0) | (f6190 << 1) | (f6192 << 2) |	\
 	 (f6281 << 3) | (f6282 << 4) | (dx4122 << 5))
@@ -458,8 +460,15 @@ static int kirkwood_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match =
 		of_match_device(kirkwood_pinctrl_of_match, &pdev->dev);
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
 	pdev->dev.platform_data = (void *)match->data;
-	return mvebu_pinctrl_probe(pdev);
+	return mvebu_pinctrl_probe(pdev, mpp_base);
 }
 
 static int kirkwood_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 0fd1ad31fbf9..90c35b20a7af 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -590,26 +590,24 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
 	return 0;
 }
 
-int mvebu_pinctrl_probe(struct platform_device *pdev)
+int mvebu_pinctrl_probe(struct platform_device *pdev, void __iomem *base)
 {
 	struct mvebu_pinctrl_soc_info *soc = dev_get_platdata(&pdev->dev);
-	struct resource *res;
 	struct mvebu_pinctrl *pctl;
-	void __iomem *base;
 	struct pinctrl_pin_desc *pdesc;
 	unsigned gid, n, k;
 	int ret;
 
+	if (!base) {
+		dev_err(&pdev->dev, "missing base address\n");
+		return -EINVAL;
+	}
+
 	if (!soc || !soc->controls || !soc->modes) {
 		dev_err(&pdev->dev, "wrong pinctrl soc info\n");
 		return -EINVAL;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
 	pctl = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_pinctrl),
 			GFP_KERNEL);
 	if (!pctl) {
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index 90bd3beee860..b66949040e0a 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -186,7 +186,7 @@ struct mvebu_pinctrl_soc_info {
 		.npins = _npins,				\
 	}
 
-int mvebu_pinctrl_probe(struct platform_device *pdev);
+int mvebu_pinctrl_probe(struct platform_device *pdev, void __iomem *base);
 int mvebu_pinctrl_remove(struct platform_device *pdev);
 
 #endif
-- 
1.8.5.2

