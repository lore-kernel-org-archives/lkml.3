Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbbATK4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:56:02 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50700 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbbATKtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:45 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 28/36] drm/tegra: hdmi: Implement ->atomic_check()
Date: Tue, 20 Jan 2015 11:48:47 +0100
Message-Id: <1421750935-4023-29-git-send-email-thierry.reding@gmail.com>
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
 drivers/gpu/drm/tegra/hdmi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 728681a3f8c9..abb1ea0385ec 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1081,6 +1081,27 @@ static void tegra_hdmi_encoder_disable(struct drm_encoder *encoder)
 	}
 }
 
+static int
+tegra_hdmi_encoder_atomic_check(struct drm_encoder *encoder,
+				struct drm_crtc_state *crtc_state,
+				struct drm_connector_state *conn_state)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(conn_state->crtc);
+	unsigned long pclk = crtc_state->mode.clock * 1000;
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	int err;
+
+	err = tegra_dc_state_setup_clock(dc, crtc_state, hdmi->clk_parent,
+					 pclk, 0);
+	if (err < 0) {
+		dev_err(output->dev, "failed to setup CRTC state: %d\n", err);
+		return err;
+	}
+
+	return err;
+}
+
 static const struct drm_encoder_helper_funcs tegra_hdmi_encoder_helper_funcs = {
 	.dpms = tegra_hdmi_encoder_dpms,
 	.mode_fixup = tegra_hdmi_encoder_mode_fixup,
@@ -1088,6 +1109,7 @@ static const struct drm_encoder_helper_funcs tegra_hdmi_encoder_helper_funcs = {
 	.commit = tegra_hdmi_encoder_commit,
 	.mode_set = tegra_hdmi_encoder_mode_set,
 	.disable = tegra_hdmi_encoder_disable,
+	.atomic_check = tegra_hdmi_encoder_atomic_check,
 };
 
 static int tegra_hdmi_show_regs(struct seq_file *s, void *data)
-- 
2.1.3

