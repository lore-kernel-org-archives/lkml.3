Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaLHGlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:41:22 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1894 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaLHGlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:41:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 07 Dec 2014 22:38:18 -0800
From: Mark Zhang <markz@nvidia.com>
To: <thierry.reding@gmail.com>, <tbergstrom@nvidia.com>, <airlied@linux.ie>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mark Zhang <markz@nvidia.com>
Subject: [PATCH] drm/tegra: dsi: Add suspend/resume support
Date: Mon, 8 Dec 2014 14:40:50 +0800
Message-ID: <1418020850-7664-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the suspend/resume support for Tegra drm
driver by calling the corresponding DPMS functions.

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
Hi,

This patch hooks DSI driver's suspend/resume to implement the whole
display system's suspend/resume. I know this is a super ugly way,
but as we all know, Tegra DRM driver doesn't have a dedicate drm device
so honestly I didn't find a better way to do that.

Thanks,
Mark

 drivers/gpu/drm/tegra/dsi.c | 96 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 90 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 33f67fd601c6..25cd0d93f392 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -61,6 +61,9 @@ struct tegra_dsi {
 	struct tegra_dsi *slave;
 };
 
+static int tegra_dsi_pad_calibrate(struct tegra_dsi *);
+static int tegra_dsi_ganged_setup(struct tegra_dsi *dsi);
+
 static inline struct tegra_dsi *
 host1x_client_to_dsi(struct host1x_client *client)
 {
@@ -805,6 +808,20 @@ static int tegra_output_dsi_setup_clock(struct tegra_output *output,
 
 	lanes = tegra_dsi_get_lanes(dsi);
 
+	err = tegra_dsi_pad_calibrate(dsi);
+	if (err < 0) {
+		dev_err(dsi->dev, "MIPI calibration failed: %d\n", err);
+		return err;
+	}
+	if (dsi->slave) {
+		err = tegra_dsi_pad_calibrate(dsi->slave);
+		if (err < 0) {
+			dev_err(dsi->slave->dev,
+				"MIPI calibration failed: %d\n", err);
+			return err;
+		}
+	}
+
 	err = tegra_dsi_get_muldiv(dsi->format, &mul, &div);
 	if (err < 0)
 		return err;
@@ -833,6 +850,13 @@ static int tegra_output_dsi_setup_clock(struct tegra_output *output,
 		dev_err(dsi->dev, "failed to set parent clock: %d\n", err);
 		return err;
 	}
+	if (dsi->slave) {
+		err = tegra_dsi_ganged_setup(dsi);
+		if (err < 0) {
+			dev_err(dsi->dev, "DSI ganged setup failed: %d\n", err);
+			return err;
+		}
+	}
 
 	err = clk_set_rate(dsi->clk_parent, plld);
 	if (err < 0) {
@@ -1470,12 +1494,6 @@ static int tegra_dsi_probe(struct platform_device *pdev)
 		goto disable_vdd;
 	}
 
-	err = tegra_dsi_pad_calibrate(dsi);
-	if (err < 0) {
-		dev_err(dsi->dev, "MIPI calibration failed: %d\n", err);
-		goto mipi_free;
-	}
-
 	dsi->host.ops = &tegra_dsi_host_ops;
 	dsi->host.dev = &pdev->dev;
 
@@ -1544,6 +1562,67 @@ static int tegra_dsi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int tegra_dsi_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct tegra_dsi *dsi = platform_get_drvdata(pdev);
+	struct tegra_drm *tegra = dev_get_drvdata(dsi->client.parent);
+	struct drm_connector *connector;
+
+	if (dsi->master) {
+		regulator_disable(dsi->vdd);
+		return 0;
+	}
+
+	drm_modeset_lock_all(tegra->drm);
+	list_for_each_entry(connector, &tegra->drm->mode_config.connector_list,
+			    head) {
+		int old_dpms = connector->dpms;
+
+		if (connector->funcs->dpms)
+			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
+
+		/* Set the old mode back to the connector for resume */
+		connector->dpms = old_dpms;
+	}
+	drm_modeset_unlock_all(tegra->drm);
+
+	regulator_disable(dsi->vdd);
+
+	return 0;
+}
+
+static int tegra_dsi_resume(struct platform_device *pdev)
+{
+	struct tegra_dsi *dsi = platform_get_drvdata(pdev);
+	struct tegra_drm *tegra = dev_get_drvdata(dsi->client.parent);
+	struct drm_connector *connector;
+	int err = 0;
+
+	err = regulator_enable(dsi->vdd);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Enable DSI vdd failed: %d\n", err);
+		return err;
+	}
+
+	if (dsi->master)
+		return 0;
+
+	drm_modeset_lock_all(tegra->drm);
+	list_for_each_entry(connector, &tegra->drm->mode_config.connector_list,
+			    head) {
+		if (connector->funcs->dpms)
+			connector->funcs->dpms(connector, connector->dpms);
+	}
+	drm_modeset_unlock_all(tegra->drm);
+
+	drm_helper_resume_force_mode(tegra->drm);
+
+	return 0;
+}
+#endif
+
+
 static const struct of_device_id tegra_dsi_of_match[] = {
 	{ .compatible = "nvidia,tegra114-dsi", },
 	{ },
@@ -1557,4 +1636,9 @@ struct platform_driver tegra_dsi_driver = {
 	},
 	.probe = tegra_dsi_probe,
 	.remove = tegra_dsi_remove,
+#ifdef CONFIG_PM
+	.suspend = tegra_dsi_suspend,
+	.resume = tegra_dsi_resume,
+#endif
+
 };
-- 
1.8.1.5

