Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3FMJyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:54:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7911 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376Ab3FMJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:54:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 13 Jun 2013 02:54:31 -0700
From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
To: <tbergstrom@nvidia.com>, <amerilainen@nvidia.com>,
        <thierry.reding@avionic-design.de>, <airlied@redhat.com>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: [PATCH v2 3/4] gpu: host1x: add runtime pm support for dc
Date: Thu, 13 Jun 2013 15:23:37 +0530
Message-ID: <1371117218-2326-4-git-send-email-mkulkarni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com>
References: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now, the dc clock is enabled in its .probe via
runtime pm and disabled in .remove

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
---
 drivers/gpu/host1x/drm/dc.c | 60 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
index 5360e5a..8e669a9 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/clk/tegra.h>
+#include <linux/pm_runtime.h>
 
 #include "host1x_client.h"
 #include "dc.h"
@@ -1128,9 +1129,7 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return PTR_ERR(dc->clk);
 	}
 
-	err = clk_prepare_enable(dc->clk);
-	if (err < 0)
-		return err;
+	platform_set_drvdata(pdev, dc);
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dc->regs = devm_ioremap_resource(&pdev->dev, regs);
@@ -1147,6 +1146,15 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	dc->client.ops = &dc_client_ops;
 	dc->client.dev = &pdev->dev;
 
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+#else
+	err = clk_prepare_enable(dc->clk);
+	if (err < 0)
+		return err;
+#endif
+
 	err = tegra_dc_rgb_probe(dc);
 	if (err < 0 && err != -ENODEV) {
 		dev_err(&pdev->dev, "failed to probe RGB output: %d\n", err);
@@ -1160,8 +1168,6 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	platform_set_drvdata(pdev, dc);
-
 	return 0;
 }
 
@@ -1178,11 +1184,52 @@ static int tegra_dc_remove(struct platform_device *pdev)
 		return err;
 	}
 
+#ifdef CONFIG_PM_RUNTIME
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+#endif
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int tegra_dc_runtime_suspend(struct device *dev)
+{
+	struct tegra_dc *dc;
+
+	dc = dev_get_drvdata(dev);
+	if (!dc)
+		return -EINVAL;
+
 	clk_disable_unprepare(dc->clk);
 
 	return 0;
 }
 
+static int tegra_dc_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct tegra_dc *dc;
+
+	dc = dev_get_drvdata(dev);
+	if (!dc)
+		return -EINVAL;
+
+	err = clk_prepare_enable(dc->clk);
+	if (err < 0)
+		dev_err(dev, "failed to enable clock\n");
+
+	return err;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops tegra_dc_pm_ops = {
+	SET_RUNTIME_PM_OPS(tegra_dc_runtime_suspend,
+		tegra_dc_runtime_resume, NULL)
+};
+#endif
+
 static struct of_device_id tegra_dc_of_match[] = {
 	{ .compatible = "nvidia,tegra30-dc", },
 	{ .compatible = "nvidia,tegra20-dc", },
@@ -1194,6 +1241,9 @@ struct platform_driver tegra_dc_driver = {
 		.name = "tegra-dc",
 		.owner = THIS_MODULE,
 		.of_match_table = tegra_dc_of_match,
+#ifdef CONFIG_PM
+		.pm = &tegra_dc_pm_ops,
+#endif
 	},
 	.probe = tegra_dc_probe,
 	.remove = tegra_dc_remove,
-- 
1.8.1.5

