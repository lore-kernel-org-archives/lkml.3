Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbbATLAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:00:45 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53532 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbbATKtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:17 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/36] drm/tegra: Convert output midlayer to helpers
Date: Tue, 20 Jan 2015 11:48:30 +0100
Message-Id: <1421750935-4023-12-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The output layer was initially designed to help reduce the amount of
code duplicated in output drivers. An unfortunate side-effect of that
was that it turned into a midlayer and it became difficult to make the
output drivers work without bending over backwards to fit into the
midlayer.

This commit starts to convert the midlayer into a helper library by
exporting most of the common functions so that they can be used by the
output drivers directly. Doing so will allow output drivers to reuse
common code paths but more easily override them where necessary.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/drm.h    |  9 +++++++++
 drivers/gpu/drm/tegra/output.c | 24 ++++++++++++------------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 286a970a4432..bf749ac4a344 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -272,6 +272,15 @@ int tegra_output_remove(struct tegra_output *output);
 int tegra_output_init(struct drm_device *drm, struct tegra_output *output);
 int tegra_output_exit(struct tegra_output *output);
 
+int tegra_output_connector_get_modes(struct drm_connector *connector);
+struct drm_encoder *
+tegra_output_connector_best_encoder(struct drm_connector *connector);
+enum drm_connector_status
+tegra_output_connector_detect(struct drm_connector *connector, bool force);
+void tegra_output_connector_destroy(struct drm_connector *connector);
+
+void tegra_output_encoder_destroy(struct drm_encoder *encoder);
+
 /* from dpaux.c */
 struct tegra_dpaux;
 struct drm_dp_link;
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index c40b38e4a859..bc82743904c1 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -12,7 +12,7 @@
 #include <drm/drm_panel.h>
 #include "drm.h"
 
-static int tegra_connector_get_modes(struct drm_connector *connector)
+int tegra_output_connector_get_modes(struct drm_connector *connector)
 {
 	struct tegra_output *output = connector_to_output(connector);
 	struct edid *edid = NULL;
@@ -57,8 +57,8 @@ static int tegra_connector_mode_valid(struct drm_connector *connector,
 	return status;
 }
 
-static struct drm_encoder *
-tegra_connector_best_encoder(struct drm_connector *connector)
+struct drm_encoder *
+tegra_output_connector_best_encoder(struct drm_connector *connector)
 {
 	struct tegra_output *output = connector_to_output(connector);
 
@@ -66,13 +66,13 @@ tegra_connector_best_encoder(struct drm_connector *connector)
 }
 
 static const struct drm_connector_helper_funcs connector_helper_funcs = {
-	.get_modes = tegra_connector_get_modes,
+	.get_modes = tegra_output_connector_get_modes,
 	.mode_valid = tegra_connector_mode_valid,
-	.best_encoder = tegra_connector_best_encoder,
+	.best_encoder = tegra_output_connector_best_encoder,
 };
 
-static enum drm_connector_status
-tegra_connector_detect(struct drm_connector *connector, bool force)
+enum drm_connector_status
+tegra_output_connector_detect(struct drm_connector *connector, bool force)
 {
 	struct tegra_output *output = connector_to_output(connector);
 	enum drm_connector_status status = connector_status_unknown;
@@ -98,7 +98,7 @@ tegra_connector_detect(struct drm_connector *connector, bool force)
 	return status;
 }
 
-static void tegra_connector_destroy(struct drm_connector *connector)
+void tegra_output_connector_destroy(struct drm_connector *connector)
 {
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
@@ -106,18 +106,18 @@ static void tegra_connector_destroy(struct drm_connector *connector)
 
 static const struct drm_connector_funcs connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
-	.detect = tegra_connector_detect,
+	.detect = tegra_output_connector_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = tegra_connector_destroy,
+	.destroy = tegra_output_connector_destroy,
 };
 
-static void tegra_encoder_destroy(struct drm_encoder *encoder)
+void tegra_output_encoder_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
 }
 
 static const struct drm_encoder_funcs encoder_funcs = {
-	.destroy = tegra_encoder_destroy,
+	.destroy = tegra_output_encoder_destroy,
 };
 
 static void tegra_encoder_dpms(struct drm_encoder *encoder, int mode)
-- 
2.1.3

