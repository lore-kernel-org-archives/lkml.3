Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbbATK6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:58:36 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60982 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbbATKtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:33 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/36] drm/tegra: Output cleanup functions cannot fail
Date: Tue, 20 Jan 2015 11:48:39 +0100
Message-Id: <1421750935-4023-21-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The tegra_output_exit() and tegra_output_remove() functions cannot fail,
so make them return void.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/drm.h    |  4 ++--
 drivers/gpu/drm/tegra/dsi.c    |  6 +-----
 drivers/gpu/drm/tegra/hdmi.c   |  6 +-----
 drivers/gpu/drm/tegra/output.c |  8 ++------
 drivers/gpu/drm/tegra/rgb.c    | 13 ++++---------
 drivers/gpu/drm/tegra/sor.c    |  8 +++-----
 6 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 699211a89a2e..bf1c47ec46b6 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -213,9 +213,9 @@ int tegra_dc_rgb_exit(struct tegra_dc *dc);
 
 /* from output.c */
 int tegra_output_probe(struct tegra_output *output);
-int tegra_output_remove(struct tegra_output *output);
+void tegra_output_remove(struct tegra_output *output);
 int tegra_output_init(struct drm_device *drm, struct tegra_output *output);
-int tegra_output_exit(struct tegra_output *output);
+void tegra_output_exit(struct tegra_output *output);
 
 int tegra_output_connector_get_modes(struct drm_connector *connector);
 struct drm_encoder *
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 8568e1b44397..f8bfb45587d8 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -1578,11 +1578,7 @@ static int tegra_dsi_remove(struct platform_device *pdev)
 		return err;
 	}
 
-	err = tegra_output_remove(&dsi->output);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to remove output: %d\n", err);
-		return err;
-	}
+	tegra_output_remove(&dsi->output);
 
 	mipi_dsi_host_unregister(&dsi->host);
 	tegra_mipi_free(dsi->mipi);
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 03ceb50b1dc9..d41530f1097c 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1563,11 +1563,7 @@ static int tegra_hdmi_remove(struct platform_device *pdev)
 		return err;
 	}
 
-	err = tegra_output_remove(&hdmi->output);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to remove output: %d\n", err);
-		return err;
-	}
+	tegra_output_remove(&hdmi->output);
 
 	clk_disable_unprepare(hdmi->clk_parent);
 	clk_disable_unprepare(hdmi->clk);
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index c6d70d774494..d027e3079c17 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -172,7 +172,7 @@ int tegra_output_probe(struct tegra_output *output)
 	return 0;
 }
 
-int tegra_output_remove(struct tegra_output *output)
+void tegra_output_remove(struct tegra_output *output)
 {
 	if (gpio_is_valid(output->hpd_gpio)) {
 		free_irq(output->hpd_irq, output);
@@ -183,8 +183,6 @@ int tegra_output_remove(struct tegra_output *output)
 		put_device(&output->ddc->dev);
 
 	drm_panel_unref(output->panel);
-
-	return 0;
 }
 
 int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
@@ -207,7 +205,7 @@ int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
 	return 0;
 }
 
-int tegra_output_exit(struct tegra_output *output)
+void tegra_output_exit(struct tegra_output *output)
 {
 	/*
 	 * The connector is going away, so the interrupt must be disabled to
@@ -218,6 +216,4 @@ int tegra_output_exit(struct tegra_output *output)
 
 	if (output->panel)
 		drm_panel_detach(output->panel);
-
-	return 0;
 }
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index ab6093889be8..0c932f9dc12d 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -287,15 +287,10 @@ int tegra_dc_rgb_probe(struct tegra_dc *dc)
 
 int tegra_dc_rgb_remove(struct tegra_dc *dc)
 {
-	int err;
-
 	if (!dc->rgb)
 		return 0;
 
-	err = tegra_output_remove(dc->rgb);
-	if (err < 0)
-		return err;
-
+	tegra_output_remove(dc->rgb);
 	dc->rgb = NULL;
 
 	return 0;
@@ -342,8 +337,8 @@ int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
 
 int tegra_dc_rgb_exit(struct tegra_dc *dc)
 {
-	if (!dc->rgb)
-		return 0;
+	if (dc->rgb)
+		tegra_output_exit(dc->rgb);
 
-	return tegra_output_exit(dc->rgb);
+	return 0;
 }
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index ee18adf7f653..9e67838c1562 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -1396,6 +1396,8 @@ static int tegra_sor_exit(struct host1x_client *client)
 	struct tegra_sor *sor = host1x_client_to_sor(client);
 	int err;
 
+	tegra_output_exit(&sor->output);
+
 	if (sor->dpaux) {
 		err = tegra_dpaux_detach(sor->dpaux);
 		if (err < 0) {
@@ -1500,11 +1502,7 @@ static int tegra_sor_remove(struct platform_device *pdev)
 		return err;
 	}
 
-	err = tegra_output_remove(&sor->output);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to remove output: %d\n", err);
-		return err;
-	}
+	tegra_output_remove(&sor->output);
 
 	return 0;
 }
-- 
2.1.3

