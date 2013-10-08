Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3JHGc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:32:58 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2954 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3JHGcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:32:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Oct 2013 23:27:54 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv4 4/5] drm/tegra: Add runtime pm support for dc
Date: Tue, 8 Oct 2013 09:27:27 +0300
Message-ID: <1381213648-5931-5-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
References: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
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
 drivers/gpu/host1x/drm/dc.c | 59 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
index b1a05ad..ca09ceb 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/clk/tegra.h>
+#include <linux/pm_runtime.h>
 
 #include "host1x_client.h"
 #include "dc.h"
@@ -24,6 +25,27 @@ struct tegra_plane {
 	unsigned int index;
 };
 
+static int tegra_dc_runtime_suspend(struct device *dev)
+{
+	struct tegra_dc *dc = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(dc->clk);
+
+	return 0;
+}
+
+static int tegra_dc_runtime_resume(struct device *dev)
+{
+	int err = 0;
+	struct tegra_dc *dc = dev_get_drvdata(dev);
+
+	err = clk_prepare_enable(dc->clk);
+	if (err < 0)
+		dev_err(dev, "failed to enable clock\n");
+
+	return err;
+}
+
 static inline struct tegra_plane *to_tegra_plane(struct drm_plane *plane)
 {
 	return container_of(plane, struct tegra_plane, base);
@@ -1128,9 +1150,7 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return PTR_ERR(dc->clk);
 	}
 
-	err = clk_prepare_enable(dc->clk);
-	if (err < 0)
-		return err;
+	platform_set_drvdata(pdev, dc);
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dc->regs = devm_ioremap_resource(&pdev->dev, regs);
@@ -1147,22 +1167,37 @@ static int tegra_dc_probe(struct platform_device *pdev)
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
-		return err;
+		goto err_dc_rgb_probe;
 	}
 
 	err = host1x_register_client(host1x, &dc->client);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
 			err);
-		return err;
+		goto err_register_client;
 	}
 
-	platform_set_drvdata(pdev, dc);
-
 	return 0;
+
+err_register_client:
+err_dc_rgb_probe:
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		tegra_dc_runtime_suspend(&pdev->dev);
+
+	return err;
 }
 
 static int tegra_dc_remove(struct platform_device *pdev)
@@ -1178,11 +1213,18 @@ static int tegra_dc_remove(struct platform_device *pdev)
 		return err;
 	}
 
-	clk_disable_unprepare(dc->clk);
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		tegra_dc_runtime_suspend(&pdev->dev);
 
 	return 0;
 }
 
+static const struct dev_pm_ops tegra_dc_pm_ops = {
+	SET_RUNTIME_PM_OPS(tegra_dc_runtime_suspend,
+			   tegra_dc_runtime_resume, NULL)
+};
+
 static struct of_device_id tegra_dc_of_match[] = {
 	{ .compatible = "nvidia,tegra30-dc", },
 	{ .compatible = "nvidia,tegra20-dc", },
@@ -1194,6 +1236,7 @@ struct platform_driver tegra_dc_driver = {
 		.name = "tegra-dc",
 		.owner = THIS_MODULE,
 		.of_match_table = tegra_dc_of_match,
+		.pm = &tegra_dc_pm_ops,
 	},
 	.probe = tegra_dc_probe,
 	.remove = tegra_dc_remove,
-- 
1.8.1.5

