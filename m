Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3C1RLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:11:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12625 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab3C1RLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:11:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 28 Mar 2013 10:11:22 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Pritesh Raithatha <praithatha@nvidia.com>,
        Bibek Basu <bbasu@nvidia.com>
Subject: [PATCH] pinctrl: tegra: add suspend-resume support
Date: Thu, 28 Mar 2013 22:41:25 +0530
Message-ID: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pritesh Raithatha <praithatha@nvidia.com>

This patch adds suspend and resume callbacks to the pinctrl-tegra driver.

Based on work by:
Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Bibek Basu <bbasu@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra.c | 71 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index f195d77..c789326 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -29,6 +29,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf.h>
 #include <linux/slab.h>
+#include <linux/syscore_ops.h>
 
 #include "core.h"
 #include "pinctrl-tegra.h"
@@ -41,8 +42,13 @@ struct tegra_pmx {
 
 	int nbanks;
 	void __iomem **regs;
+	int *regs_size;
+
+	u32 *pg_data;
 };
 
+static struct tegra_pmx *pmx;
+
 static inline u32 pmx_readl(struct tegra_pmx *pmx, u32 bank, u32 reg)
 {
 	return readl(pmx->regs[bank] + reg);
@@ -701,12 +707,47 @@ static struct pinctrl_desc tegra_pinctrl_desc = {
 	.owner = THIS_MODULE,
 };
 
+#ifdef CONFIG_PM_SLEEP
+
+static int pinctrl_suspend(void)
+{
+	int i, j;
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
+static void pinctrl_resume(void)
+{
+	int i, j;
+	u32 *pg_data = pmx->pg_data;
+	u32 *regs;
+
+	for (i = 0; i < pmx->nbanks; i++) {
+		regs = pmx->regs[i];
+		for (j = 0; j < pmx->regs_size[i] / 4; j++)
+			writel(*pg_data++, regs++);
+	}
+}
+
+static struct syscore_ops pinctrl_syscore_ops = {
+	.suspend = pinctrl_suspend,
+	.resume = pinctrl_resume,
+};
+
+#endif
+
 int tegra_pinctrl_probe(struct platform_device *pdev,
 			const struct tegra_pinctrl_soc_data *soc_data)
-{
-	struct tegra_pmx *pmx;
+	{
 	struct resource *res;
-	int i;
+	int i, pg_data_size = 0;
 
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
 	if (!pmx) {
@@ -725,6 +766,7 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res)
 			break;
+		pg_data_size += resource_size(res);
 	}
 	pmx->nbanks = i;
 
@@ -735,6 +777,22 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 		return -ENODEV;
 	}
 
+#ifdef CONFIG_PM_SLEEP
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
+#endif
+
 	for (i = 0; i < pmx->nbanks; i++) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res) {
@@ -756,6 +814,10 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 			dev_err(&pdev->dev, "Couldn't ioremap regs %d\n", i);
 			return -ENODEV;
 		}
+
+#ifdef CONFIG_PM_SLEEP
+		pmx->regs_size[i] = resource_size(res);
+#endif
 	}
 
 	pmx->pctl = pinctrl_register(&tegra_pinctrl_desc, &pdev->dev, pmx);
@@ -768,6 +830,9 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 
 	platform_set_drvdata(pdev, pmx);
 
+#ifdef CONFIG_PM_SLEEP
+	register_syscore_ops(&pinctrl_syscore_ops);
+#endif
 	dev_dbg(&pdev->dev, "Probed Tegra pinctrl driver\n");
 
 	return 0;
-- 
1.8.1.5

