Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaHOJtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:49:15 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4943 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaHOJtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:49:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Aug 2014 02:39:52 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <ldewangan@nvidia.com>, <wsa@the-dreams.de>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>
CC: <pdeschrijver@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
Date: Fri, 15 Aug 2014 12:47:14 +0300
Message-ID: <1408096034-17270-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the i2c-tegra bus driver prepares, enables
and set_rates its clocks separately for each transfer.
This causes locking problems when doing I2C transfers
from clock notifiers; see
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/268653.html

This patch moves clk_prepare/unprepare and clk_set_rate calls to
the probe function, leaving only clk_enable/disable to be
done on each transfer. This solves the locking issue.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c | 57 +++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 87d0371..251f172 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -380,34 +380,33 @@ static inline int tegra_i2c_clock_enable(struct tegra_i2c_dev *i2c_dev)
 {
 	int ret;
 	if (!i2c_dev->hw->has_single_clk_source) {
-		ret = clk_prepare_enable(i2c_dev->fast_clk);
+		ret = clk_enable(i2c_dev->fast_clk);
 		if (ret < 0) {
 			dev_err(i2c_dev->dev,
 				"Enabling fast clk failed, err %d\n", ret);
 			return ret;
 		}
 	}
-	ret = clk_prepare_enable(i2c_dev->div_clk);
+	ret = clk_enable(i2c_dev->div_clk);
 	if (ret < 0) {
 		dev_err(i2c_dev->dev,
 			"Enabling div clk failed, err %d\n", ret);
-		clk_disable_unprepare(i2c_dev->fast_clk);
+		clk_disable(i2c_dev->fast_clk);
 	}
 	return ret;
 }
 
 static inline void tegra_i2c_clock_disable(struct tegra_i2c_dev *i2c_dev)
 {
-	clk_disable_unprepare(i2c_dev->div_clk);
+	clk_disable(i2c_dev->div_clk);
 	if (!i2c_dev->hw->has_single_clk_source)
-		clk_disable_unprepare(i2c_dev->fast_clk);
+		clk_disable(i2c_dev->fast_clk);
 }
 
 static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 {
 	u32 val;
 	int err = 0;
-	int clk_multiplier = I2C_CLK_MULTIPLIER_STD_FAST_MODE;
 	u32 clk_divisor;
 
 	err = tegra_i2c_clock_enable(i2c_dev);
@@ -428,9 +427,6 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	i2c_writel(i2c_dev, val, I2C_CNFG);
 	i2c_writel(i2c_dev, 0, I2C_INT_MASK);
 
-	clk_multiplier *= (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
-	clk_set_rate(i2c_dev->div_clk, i2c_dev->bus_clk_rate * clk_multiplier);
-
 	/* Make sure clock divisor programmed correctly */
 	clk_divisor = i2c_dev->hw->clk_divisor_hs_mode;
 	clk_divisor |= i2c_dev->hw->clk_divisor_std_fast_mode <<
@@ -712,6 +708,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	void __iomem *base;
 	int irq;
 	int ret = 0;
+	int clk_multiplier = I2C_CLK_MULTIPLIER_STD_FAST_MODE;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
@@ -777,17 +774,39 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, i2c_dev);
 
+	if (!i2c_dev->hw->has_single_clk_source) {
+		ret = clk_prepare(i2c_dev->fast_clk);
+		if (ret < 0) {
+			dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
+			return ret;
+		}
+	}
+
+	ret = clk_prepare(i2c_dev->div_clk);
+	if (ret < 0) {
+		dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
+		goto unprepare_fast_clk;
+	}
+
+	clk_multiplier *= (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
+	ret = clk_set_rate(i2c_dev->div_clk,
+			   i2c_dev->bus_clk_rate * clk_multiplier);
+	if (ret) {
+		dev_err(i2c_dev->dev, "Clock rate change failed %d\n", ret);
+		goto unprepare_div_clk;
+	}
+
 	ret = tegra_i2c_init(i2c_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize i2c controller");
-		return ret;
+		goto unprepare_div_clk;
 	}
 
 	ret = devm_request_irq(&pdev->dev, i2c_dev->irq,
 			tegra_i2c_isr, 0, dev_name(&pdev->dev), i2c_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %i\n", i2c_dev->irq);
-		return ret;
+		goto unprepare_div_clk;
 	}
 
 	i2c_set_adapdata(&i2c_dev->adapter, i2c_dev);
@@ -803,16 +822,30 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to add I2C adapter\n");
-		return ret;
+		goto unprepare_div_clk;
 	}
 
 	return 0;
+
+unprepare_div_clk:
+	clk_unprepare(i2c_dev->div_clk);
+
+unprepare_fast_clk:
+	if (!i2c_dev->hw->has_single_clk_source)
+		clk_unprepare(i2c_dev->fast_clk);
+
+	return ret;
 }
 
 static int tegra_i2c_remove(struct platform_device *pdev)
 {
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 	i2c_del_adapter(&i2c_dev->adapter);
+
+	clk_unprepare(i2c_dev->div_clk);
+	if (!i2c_dev->hw->has_single_clk_source)
+		clk_unprepare(i2c_dev->fast_clk);
+
 	return 0;
 }
 
-- 
1.8.1.5

