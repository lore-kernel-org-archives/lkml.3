Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbbATKte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:34 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46424 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbbATKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:29 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 18/36] drm/tegra: debugfs cleanup cannot fail
Date: Tue, 20 Jan 2015 11:48:37 +0100
Message-Id: <1421750935-4023-19-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The debugfs cleanup code never fails, so no error is returned. Therefore
the functions can all return void instead.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dsi.c  | 12 +++---------
 drivers/gpu/drm/tegra/hdmi.c | 13 +++----------
 drivers/gpu/drm/tegra/sor.c  | 11 +++--------
 3 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 817114ce42fb..4cdfd471aef7 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -228,7 +228,7 @@ remove:
 	return err;
 }
 
-static int tegra_dsi_debugfs_exit(struct tegra_dsi *dsi)
+static void tegra_dsi_debugfs_exit(struct tegra_dsi *dsi)
 {
 	drm_debugfs_remove_files(dsi->debugfs_files, ARRAY_SIZE(debugfs_files),
 				 dsi->minor);
@@ -239,8 +239,6 @@ static int tegra_dsi_debugfs_exit(struct tegra_dsi *dsi)
 
 	debugfs_remove(dsi->debugfs);
 	dsi->debugfs = NULL;
-
-	return 0;
 }
 
 #define PKT_ID0(id)	((((id) & 0x3f) <<  3) | (1 <<  9))
@@ -1025,15 +1023,11 @@ reset:
 static int tegra_dsi_exit(struct host1x_client *client)
 {
 	struct tegra_dsi *dsi = host1x_client_to_dsi(client);
-	int err;
 
 	tegra_output_exit(&dsi->output);
 
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_dsi_debugfs_exit(dsi);
-		if (err < 0)
-			dev_err(dsi->dev, "debugfs cleanup failed: %d\n", err);
-	}
+	if (IS_ENABLED(CONFIG_DEBUG_FS))
+		tegra_dsi_debugfs_exit(dsi);
 
 	reset_control_assert(dsi->rst);
 
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 056bb2c1c426..b4fe90949f27 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1310,7 +1310,7 @@ remove:
 	return err;
 }
 
-static int tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
+static void tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
 {
 	drm_debugfs_remove_files(hdmi->debugfs_files, ARRAY_SIZE(debugfs_files),
 				 hdmi->minor);
@@ -1321,8 +1321,6 @@ static int tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
 
 	debugfs_remove(hdmi->debugfs);
 	hdmi->debugfs = NULL;
-
-	return 0;
 }
 
 static int tegra_hdmi_init(struct host1x_client *client)
@@ -1393,7 +1391,6 @@ static int tegra_hdmi_init(struct host1x_client *client)
 static int tegra_hdmi_exit(struct host1x_client *client)
 {
 	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
-	int err;
 
 	tegra_output_exit(&hdmi->output);
 
@@ -1404,12 +1401,8 @@ static int tegra_hdmi_exit(struct host1x_client *client)
 	regulator_disable(hdmi->pll);
 	regulator_disable(hdmi->hdmi);
 
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_hdmi_debugfs_exit(hdmi);
-		if (err < 0)
-			dev_err(client->dev, "debugfs cleanup failed: %d\n",
-				err);
-	}
+	if (IS_ENABLED(CONFIG_DEBUG_FS))
+		tegra_hdmi_debugfs_exit(hdmi);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index be1ad42c69be..a1c16c5c0cf6 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -710,12 +710,10 @@ remove:
 	return err;
 }
 
-static int tegra_sor_debugfs_exit(struct tegra_sor *sor)
+static void tegra_sor_debugfs_exit(struct tegra_sor *sor)
 {
 	debugfs_remove_recursive(sor->debugfs);
 	sor->debugfs = NULL;
-
-	return 0;
 }
 
 static void tegra_sor_connector_dpms(struct drm_connector *connector, int mode)
@@ -1410,11 +1408,8 @@ static int tegra_sor_exit(struct host1x_client *client)
 	clk_disable_unprepare(sor->clk_dp);
 	clk_disable_unprepare(sor->clk);
 
-	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
-		err = tegra_sor_debugfs_exit(sor);
-		if (err < 0)
-			dev_err(sor->dev, "debugfs cleanup failed: %d\n", err);
-	}
+	if (IS_ENABLED(CONFIG_DEBUG_FS))
+		tegra_sor_debugfs_exit(sor);
 
 	return 0;
 }
-- 
2.1.3

