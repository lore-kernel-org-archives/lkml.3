Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3DWSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:09:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5668 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab3DWSJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:09:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Apr 2013 11:07:14 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: <linus.walleij@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Bibek Basu <bbasu@nvidia.com>
Subject: [PATCH 1/2] pinctrl: tegra: add suspend-resume support
Date: Tue, 23 Apr 2013 23:39:01 +0530
Message-ID: <1366740542-26127-1-git-send-email-bbasu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pritesh Raithatha <praithatha@nvidia.com>

This patch adds suspend and resume callbacks to the pinctrl-tegra driver.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Bibek Basu <bbasu@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra.c    | 56 ++++++++++++++++++++++++++++++++++++--
 drivers/pinctrl/pinctrl-tegra.h    |  3 +-
 drivers/pinctrl/pinctrl-tegra114.c |  3 ++
 drivers/pinctrl/pinctrl-tegra20.c  |  3 ++
 drivers/pinctrl/pinctrl-tegra30.c  |  2 ++
 5 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index f195d77..16ffd79 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -29,6 +29,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf.h>
 #include <linux/slab.h>
+#include <linux/pm.h>
 
 #include "core.h"
 #include "pinctrl-tegra.h"
@@ -41,6 +42,8 @@ struct tegra_pmx {
 
 	int nbanks;
 	void __iomem **regs;
+	int *regs_size;
+	u32 *pg_data;
 };
 
 static inline u32 pmx_readl(struct tegra_pmx *pmx, u32 bank, u32 reg)
@@ -701,12 +704,42 @@ static struct pinctrl_desc tegra_pinctrl_desc = {
 	.owner = THIS_MODULE,
 };
 
+int pinctrl_suspend(struct device *dev)
+{
+	int i, j;
+	struct tegra_pmx *pmx = dev_get_drvdata(dev);
+	u32 *pg_data = pmx->pg_data;
+	u32 *regs;
+
+	for (i = 0; i < pmx->nbanks; i++) {
+		regs = pmx->regs[i];
+		for (j = 0; j < pmx->regs_size[i] / 4; j++)
+			*pg_data++ = readl(regs++);
+	}
+	return 0;
+}
+
+int pinctrl_resume(struct device *dev)
+{
+	int i, j;
+	struct tegra_pmx *pmx = dev_get_drvdata(dev);
+	u32 *pg_data = pmx->pg_data;
+	u32 *regs;
+
+	for (i = 0; i < pmx->nbanks; i++) {
+		regs = pmx->regs[i];
+		for (j = 0; j < pmx->regs_size[i] / 4; j++)
+			writel(*pg_data++, regs++);
+	}
+	return 0;
+}
+
 int tegra_pinctrl_probe(struct platform_device *pdev,
 			const struct tegra_pinctrl_soc_data *soc_data)
 {
-	struct tegra_pmx *pmx;
 	struct resource *res;
-	int i;
+	struct tegra_pmx *pmx;
+	int i, pg_data_size = 0;
 
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
 	if (!pmx) {
@@ -725,6 +758,7 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res)
 			break;
+		pg_data_size += resource_size(res);
 	}
 	pmx->nbanks = i;
 
@@ -735,6 +769,21 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 		return -ENODEV;
 	}
 
+if (IS_ENABLED(CONFIG_PM_SLEEP))
+	pmx->regs_size = devm_kzalloc(&pdev->dev,
+				pmx->nbanks * sizeof(*(pmx->regs_size)),
+				GFP_KERNEL);
+	if (!pmx->regs_size) {
+		dev_err(&pdev->dev, "Can't alloc regs pointer\n");
+		return -ENODEV;
+	}
+
+	pmx->pg_data = devm_kzalloc(&pdev->dev, pg_data_size, GFP_KERNEL);
+	if (!pmx->pg_data) {
+		dev_err(&pdev->dev, "Can't alloc pingroup data pointer\n");
+		return -ENODEV;
+	}
+
 	for (i = 0; i < pmx->nbanks; i++) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res) {
@@ -756,6 +805,9 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 			dev_err(&pdev->dev, "Couldn't ioremap regs %d\n", i);
 			return -ENODEV;
 		}
+
+if (IS_ENABLED(CONFIG_PM_SLEEP))
+		pmx->regs_size[i] = resource_size(res);
 	}
 
 	pmx->pctl = pinctrl_register(&tegra_pinctrl_desc, &pdev->dev, pmx);
diff --git a/drivers/pinctrl/pinctrl-tegra.h b/drivers/pinctrl/pinctrl-tegra.h
index 817f706..71616c7 100644
--- a/drivers/pinctrl/pinctrl-tegra.h
+++ b/drivers/pinctrl/pinctrl-tegra.h
@@ -202,5 +202,6 @@ struct tegra_pinctrl_soc_data {
 int tegra_pinctrl_probe(struct platform_device *pdev,
 			const struct tegra_pinctrl_soc_data *soc_data);
 int tegra_pinctrl_remove(struct platform_device *pdev);
-
+int pinctrl_suspend(struct device *dev);
+int pinctrl_resume(struct device *dev);
 #endif
diff --git a/drivers/pinctrl/pinctrl-tegra114.c b/drivers/pinctrl/pinctrl-tegra114.c
index 622c485..9641588 100644
--- a/drivers/pinctrl/pinctrl-tegra114.c
+++ b/drivers/pinctrl/pinctrl-tegra114.c
@@ -2752,10 +2752,13 @@ static struct of_device_id tegra114_pinctrl_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tegra114_pinctrl_of_match);
 
+static SIMPLE_DEV_PM_OPS(pinctrl_dev_pm_ops, pinctrl_suspend, pinctrl_resume);
+
 static struct platform_driver tegra114_pinctrl_driver = {
 	.driver = {
 		.name = "tegra114-pinctrl",
 		.owner = THIS_MODULE,
+		.pm = &pinctrl_dev_pm_ops,
 		.of_match_table = tegra114_pinctrl_of_match,
 	},
 	.probe = tegra114_pinctrl_probe,
diff --git a/drivers/pinctrl/pinctrl-tegra20.c b/drivers/pinctrl/pinctrl-tegra20.c
index fcfb7d0..ea45ad5 100644
--- a/drivers/pinctrl/pinctrl-tegra20.c
+++ b/drivers/pinctrl/pinctrl-tegra20.c
@@ -2872,10 +2872,13 @@ static struct of_device_id tegra20_pinctrl_of_match[] = {
 	{ },
 };
 
+static SIMPLE_DEV_PM_OPS(pinctrl_dev_pm_ops, pinctrl_suspend, pinctrl_resume);
+
 static struct platform_driver tegra20_pinctrl_driver = {
 	.driver = {
 		.name = "tegra20-pinctrl",
 		.owner = THIS_MODULE,
+		.pm = &pinctrl_dev_pm_ops,
 		.of_match_table = tegra20_pinctrl_of_match,
 	},
 	.probe = tegra20_pinctrl_probe,
diff --git a/drivers/pinctrl/pinctrl-tegra30.c b/drivers/pinctrl/pinctrl-tegra30.c
index 2300deb..11899d4 100644
--- a/drivers/pinctrl/pinctrl-tegra30.c
+++ b/drivers/pinctrl/pinctrl-tegra30.c
@@ -3736,6 +3736,8 @@ static struct of_device_id tegra30_pinctrl_of_match[] = {
 	{ },
 };
 
+static SIMPLE_DEV_PM_OPS(pinctrl_dev_pm_ops, pinctrl_suspend, pinctrl_resume);
+
 static struct platform_driver tegra30_pinctrl_driver = {
 	.driver = {
 		.name = "tegra30-pinctrl",
-- 
1.8.1.5

