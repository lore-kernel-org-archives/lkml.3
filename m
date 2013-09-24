Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3IXMJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:09:36 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9261 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3IXMJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Sep 2013 05:05:58 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv3 3/4] drm/tegra: Add runtime pm support for dc
Date: Tue, 24 Sep 2013 15:05:24 +0300
Message-ID: <1380024325-18280-4-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com>
References: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mayuresh Kulkarni <mkulkarni@nvidia.com>

This patch adds initial runtime pm support for Tegra display
controller. As of now, the dc clock is enabled in device probe via
runtime pm and disabled in device remove. In case pm runtime is not
configured, we simply enable the clock in device probe (..and disable
it in remove).

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/dc.c | 58 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
index b1a05ad..6d1d5fc 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/clk/tegra.h>
+#include <linux/pm_runtime.h>
 
 #include "host1x_client.h"
 #include "dc.h"
@@ -24,6 +25,9 @@ struct tegra_plane {
 	unsigned int index;
 };
 
+static int tegra_dc_runtime_suspend(struct device *dev);
+static int tegra_dc_runtime_resume(struct device *dev);
+
 static inline struct tegra_plane *to_tegra_plane(struct drm_plane *plane)
 {
 	return container_of(plane, struct tegra_plane, base);
@@ -1128,9 +1132,7 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return PTR_ERR(dc->clk);
 	}
 
-	err = clk_prepare_enable(dc->clk);
-	if (err < 0)
-		return err;
+	platform_set_drvdata(pdev, dc);
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dc->regs = devm_ioremap_resource(&pdev->dev, regs);
@@ -1147,6 +1149,15 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	dc->client.ops = &dc_client_ops;
 	dc->client.dev = &pdev->dev;
 
+	pm_runtime_enable(&pdev->dev);
+	if (!pm_runtime_enabled(&pdev->dev)) {
+		err = tegra_dc_runtime_resume(&pdev->dev);
+		if (err < 0)
+			return err;
+	}
+
+	pm_runtime_get_sync(&pdev->dev);
+
 	err = tegra_dc_rgb_probe(dc);
 	if (err < 0 && err != -ENODEV) {
 		dev_err(&pdev->dev, "failed to probe RGB output: %d\n", err);
@@ -1160,8 +1171,6 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	platform_set_drvdata(pdev, dc);
-
 	return 0;
 }
 
@@ -1178,11 +1187,49 @@ static int tegra_dc_remove(struct platform_device *pdev)
 		return err;
 	}
 
+	pm_runtime_put(&pdev->dev);
+	if (pm_runtime_enabled(&pdev->dev))
+		pm_runtime_disable(&pdev->dev);
+	else
+		tegra_dc_runtime_suspend(&pdev->dev);
+
+	return 0;
+}
+
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
+
+static const struct dev_pm_ops tegra_dc_pm_ops = {
+	SET_RUNTIME_PM_OPS(tegra_dc_runtime_suspend,
+			   tegra_dc_runtime_resume, NULL)
+};
+
 static struct of_device_id tegra_dc_of_match[] = {
 	{ .compatible = "nvidia,tegra30-dc", },
 	{ .compatible = "nvidia,tegra20-dc", },
@@ -1194,6 +1241,7 @@ struct platform_driver tegra_dc_driver = {
 		.name = "tegra-dc",
 		.owner = THIS_MODULE,
 		.of_match_table = tegra_dc_of_match,
+		.pm = &tegra_dc_pm_ops,
 	},
 	.probe = tegra_dc_probe,
 	.remove = tegra_dc_remove,
-- 
1.8.1.5

