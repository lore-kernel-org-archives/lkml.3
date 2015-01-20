Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbbATKty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:49:54 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:44580 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbbATKtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:47 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 29/36] drm/tegra: sor: Implement ->atomic_check()
Date: Tue, 20 Jan 2015 11:48:48 +0100
Message-Id: <1421750935-4023-30-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The implementation of the ->atomic_check() callback precomputes all
parameters to check if the given configuration can be applied. If so the
precomputed values are stored in the atomic state object for the encoder
and applied during modeset. In that way the modeset no longer needs to
perform any checking but simply program values into registers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/sor.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 2793e75c6573..7463ea02a083 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -1320,6 +1320,27 @@ unlock:
 	mutex_unlock(&sor->lock);
 }
 
+static int
+tegra_sor_encoder_atomic_check(struct drm_encoder *encoder,
+			       struct drm_crtc_state *crtc_state,
+			       struct drm_connector_state *conn_state)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(conn_state->crtc);
+	unsigned long pclk = crtc_state->mode.clock * 1000;
+	struct tegra_sor *sor = to_sor(output);
+	int err;
+
+	err = tegra_dc_state_setup_clock(dc, crtc_state, sor->clk_parent,
+					 pclk, 0);
+	if (err < 0) {
+		dev_err(output->dev, "failed to setup CRTC state: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static const struct drm_encoder_helper_funcs tegra_sor_encoder_helper_funcs = {
 	.dpms = tegra_sor_encoder_dpms,
 	.mode_fixup = tegra_sor_encoder_mode_fixup,
@@ -1327,6 +1348,7 @@ static const struct drm_encoder_helper_funcs tegra_sor_encoder_helper_funcs = {
 	.commit = tegra_sor_encoder_commit,
 	.mode_set = tegra_sor_encoder_mode_set,
 	.disable = tegra_sor_encoder_disable,
+	.atomic_check = tegra_sor_encoder_atomic_check,
 };
 
 static int tegra_sor_init(struct host1x_client *client)
-- 
2.1.3

