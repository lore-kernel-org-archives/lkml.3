Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbbATK7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:59:22 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56343 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbbATKt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:49:28 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/36] drm/tegra: sor: Demidlayer
Date: Tue, 20 Jan 2015 11:48:36 +0100
Message-Id: <1421750935-4023-18-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Implement encoder and connector within the eDP driver itself using the
Tegra output helpers rather than using the Tegra output as midlayer. By
doing so one level of indirection is removed and output drivers become
more flexible while keeping the majority of the advantages provided by
the common output helpers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/drm.h    |   5 -
 drivers/gpu/drm/tegra/output.c |  15 +-
 drivers/gpu/drm/tegra/sor.c    | 810 ++++++++++++++++++++++-------------------
 3 files changed, 436 insertions(+), 394 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index ae3daa436ee6..c74d5db47537 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -192,16 +192,11 @@ struct tegra_output_ops {
 	enum drm_connector_status (*detect)(struct tegra_output *output);
 };
 
-enum tegra_output_type {
-	TEGRA_OUTPUT_EDP,
-};
-
 struct tegra_output {
 	struct device_node *of_node;
 	struct device *dev;
 
 	const struct tegra_output_ops *ops;
-	enum tegra_output_type type;
 
 	struct drm_panel *panel;
 	struct i2c_adapter *ddc;
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
index bc5393fd03c7..042b421416a8 100644
--- a/drivers/gpu/drm/tegra/output.c
+++ b/drivers/gpu/drm/tegra/output.c
@@ -273,19 +273,8 @@ int tegra_output_remove(struct tegra_output *output)
 
 int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
 {
-	int connector, encoder;
-
-	switch (output->type) {
-	case TEGRA_OUTPUT_EDP:
-		connector = DRM_MODE_CONNECTOR_eDP;
-		encoder = DRM_MODE_ENCODER_TMDS;
-		break;
-
-	default:
-		connector = DRM_MODE_CONNECTOR_Unknown;
-		encoder = DRM_MODE_ENCODER_NONE;
-		break;
-	}
+	int connector = DRM_MODE_CONNECTOR_Unknown;
+	int encoder = DRM_MODE_ENCODER_NONE;
 
 	drm_connector_init(drm, &output->connector, &connector_funcs,
 			   connector);
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index 1fe801ee8eb0..be1ad42c69be 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -8,6 +8,7 @@
 
 #include <linux/clk.h>
 #include <linux/debugfs.h>
+#include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
@@ -15,6 +16,7 @@
 #include <soc/tegra/pmc.h>
 
 #include <drm/drm_dp_helper.h>
+#include <drm/drm_panel.h>
 
 #include "dc.h"
 #include "drm.h"
@@ -481,10 +483,342 @@ static int tegra_sor_calc_config(struct tegra_sor *sor,
 	return 0;
 }
 
-static int tegra_output_sor_enable(struct tegra_output *output)
+static int tegra_sor_detach(struct tegra_sor *sor)
+{
+	unsigned long value, timeout;
+
+	/* switch to safe mode */
+	value = tegra_sor_readl(sor, SOR_SUPER_STATE_1);
+	value &= ~SOR_SUPER_STATE_MODE_NORMAL;
+	tegra_sor_writel(sor, value, SOR_SUPER_STATE_1);
+	tegra_sor_super_update(sor);
+
+	timeout = jiffies + msecs_to_jiffies(250);
+
+	while (time_before(jiffies, timeout)) {
+		value = tegra_sor_readl(sor, SOR_PWR);
+		if (value & SOR_PWR_MODE_SAFE)
+			break;
+	}
+
+	if ((value & SOR_PWR_MODE_SAFE) == 0)
+		return -ETIMEDOUT;
+
+	/* go to sleep */
+	value = tegra_sor_readl(sor, SOR_SUPER_STATE_1);
+	value &= ~SOR_SUPER_STATE_HEAD_MODE_MASK;
+	tegra_sor_writel(sor, value, SOR_SUPER_STATE_1);
+	tegra_sor_super_update(sor);
+
+	/* detach */
+	value = tegra_sor_readl(sor, SOR_SUPER_STATE_1);
+	value &= ~SOR_SUPER_STATE_ATTACHED;
+	tegra_sor_writel(sor, value, SOR_SUPER_STATE_1);
+	tegra_sor_super_update(sor);
+
+	timeout = jiffies + msecs_to_jiffies(250);
+
+	while (time_before(jiffies, timeout)) {
+		value = tegra_sor_readl(sor, SOR_TEST);
+		if ((value & SOR_TEST_ATTACHED) == 0)
+			break;
+
+		usleep_range(25, 100);
+	}
+
+	if ((value & SOR_TEST_ATTACHED) != 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int tegra_sor_power_down(struct tegra_sor *sor)
+{
+	unsigned long value, timeout;
+	int err;
+
+	value = tegra_sor_readl(sor, SOR_PWR);
+	value &= ~SOR_PWR_NORMAL_STATE_PU;
+	value |= SOR_PWR_TRIGGER;
+	tegra_sor_writel(sor, value, SOR_PWR);
+
+	timeout = jiffies + msecs_to_jiffies(250);
+
+	while (time_before(jiffies, timeout)) {
+		value = tegra_sor_readl(sor, SOR_PWR);
+		if ((value & SOR_PWR_TRIGGER) == 0)
+			return 0;
+
+		usleep_range(25, 100);
+	}
+
+	if ((value & SOR_PWR_TRIGGER) != 0)
+		return -ETIMEDOUT;
+
+	err = clk_set_parent(sor->clk, sor->clk_safe);
+	if (err < 0)
+		dev_err(sor->dev, "failed to set safe parent clock: %d\n", err);
+
+	value = tegra_sor_readl(sor, SOR_DP_PADCTL_0);
+	value &= ~(SOR_DP_PADCTL_PD_TXD_3 | SOR_DP_PADCTL_PD_TXD_0 |
+		   SOR_DP_PADCTL_PD_TXD_1 | SOR_DP_PADCTL_PD_TXD_2);
+	tegra_sor_writel(sor, value, SOR_DP_PADCTL_0);
+
+	/* stop lane sequencer */
+	value = SOR_LANE_SEQ_CTL_TRIGGER | SOR_LANE_SEQ_CTL_SEQUENCE_UP |
+		SOR_LANE_SEQ_CTL_POWER_STATE_DOWN;
+	tegra_sor_writel(sor, value, SOR_LANE_SEQ_CTL);
+
+	timeout = jiffies + msecs_to_jiffies(250);
+
+	while (time_before(jiffies, timeout)) {
+		value = tegra_sor_readl(sor, SOR_LANE_SEQ_CTL);
+		if ((value & SOR_LANE_SEQ_CTL_TRIGGER) == 0)
+			break;
+
+		usleep_range(25, 100);
+	}
+
+	if ((value & SOR_LANE_SEQ_CTL_TRIGGER) != 0)
+		return -ETIMEDOUT;
+
+	value = tegra_sor_readl(sor, SOR_PLL_2);
+	value |= SOR_PLL_2_PORT_POWERDOWN;
+	tegra_sor_writel(sor, value, SOR_PLL_2);
+
+	usleep_range(20, 100);
+
+	value = tegra_sor_readl(sor, SOR_PLL_0);
+	value |= SOR_PLL_0_POWER_OFF;
+	value |= SOR_PLL_0_VCOPD;
+	tegra_sor_writel(sor, value, SOR_PLL_0);
+
+	value = tegra_sor_readl(sor, SOR_PLL_2);
+	value |= SOR_PLL_2_SEQ_PLLCAPPD;
+	value |= SOR_PLL_2_SEQ_PLLCAPPD_ENFORCE;
+	tegra_sor_writel(sor, value, SOR_PLL_2);
+
+	usleep_range(20, 100);
+
+	return 0;
+}
+
+static int tegra_sor_crc_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static int tegra_sor_crc_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int tegra_sor_crc_wait(struct tegra_sor *sor, unsigned long timeout)
+{
+	u32 value;
+
+	timeout = jiffies + msecs_to_jiffies(timeout);
+
+	while (time_before(jiffies, timeout)) {
+		value = tegra_sor_readl(sor, SOR_CRC_A);
+		if (value & SOR_CRC_A_VALID)
+			return 0;
+
+		usleep_range(100, 200);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static ssize_t tegra_sor_crc_read(struct file *file, char __user *buffer,
+				  size_t size, loff_t *ppos)
+{
+	struct tegra_sor *sor = file->private_data;
+	ssize_t num, err;
+	char buf[10];
+	u32 value;
+
+	mutex_lock(&sor->lock);
+
+	if (!sor->enabled) {
+		err = -EAGAIN;
+		goto unlock;
+	}
+
+	value = tegra_sor_readl(sor, SOR_STATE_1);
+	value &= ~SOR_STATE_ASY_CRC_MODE_MASK;
+	tegra_sor_writel(sor, value, SOR_STATE_1);
+
+	value = tegra_sor_readl(sor, SOR_CRC_CNTRL);
+	value |= SOR_CRC_CNTRL_ENABLE;
+	tegra_sor_writel(sor, value, SOR_CRC_CNTRL);
+
+	value = tegra_sor_readl(sor, SOR_TEST);
+	value &= ~SOR_TEST_CRC_POST_SERIALIZE;
+	tegra_sor_writel(sor, value, SOR_TEST);
+
+	err = tegra_sor_crc_wait(sor, 100);
+	if (err < 0)
+		goto unlock;
+
+	tegra_sor_writel(sor, SOR_CRC_A_RESET, SOR_CRC_A);
+	value = tegra_sor_readl(sor, SOR_CRC_B);
+
+	num = scnprintf(buf, sizeof(buf), "%08x\n", value);
+
+	err = simple_read_from_buffer(buffer, size, ppos, buf, num);
+
+unlock:
+	mutex_unlock(&sor->lock);
+	return err;
+}
+
+static const struct file_operations tegra_sor_crc_fops = {
+	.owner = THIS_MODULE,
+	.open = tegra_sor_crc_open,
+	.read = tegra_sor_crc_read,
+	.release = tegra_sor_crc_release,
+};
+
+static int tegra_sor_debugfs_init(struct tegra_sor *sor,
+				  struct drm_minor *minor)
 {
-	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
-	struct drm_display_mode *mode = &dc->base.mode;
+	struct dentry *entry;
+	int err = 0;
+
+	sor->debugfs = debugfs_create_dir("sor", minor->debugfs_root);
+	if (!sor->debugfs)
+		return -ENOMEM;
+
+	entry = debugfs_create_file("crc", 0644, sor->debugfs, sor,
+				    &tegra_sor_crc_fops);
+	if (!entry) {
+		dev_err(sor->dev,
+			"cannot create /sys/kernel/debug/dri/%s/sor/crc\n",
+			minor->debugfs_root->d_name.name);
+		err = -ENOMEM;
+		goto remove;
+	}
+
+	return err;
+
+remove:
+	debugfs_remove(sor->debugfs);
+	sor->debugfs = NULL;
+	return err;
+}
+
+static int tegra_sor_debugfs_exit(struct tegra_sor *sor)
+{
+	debugfs_remove_recursive(sor->debugfs);
+	sor->debugfs = NULL;
+
+	return 0;
+}
+
+static void tegra_sor_connector_dpms(struct drm_connector *connector, int mode)
+{
+}
+
+static enum drm_connector_status
+tegra_sor_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	struct tegra_sor *sor = to_sor(output);
+
+	if (sor->dpaux)
+		return tegra_dpaux_detect(sor->dpaux);
+
+	return connector_status_unknown;
+}
+
+static const struct drm_connector_funcs tegra_sor_connector_funcs = {
+	.dpms = tegra_sor_connector_dpms,
+	.detect = tegra_sor_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = tegra_output_connector_destroy,
+};
+
+static int tegra_sor_connector_get_modes(struct drm_connector *connector)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	struct tegra_sor *sor = to_sor(output);
+	int err;
+
+	if (sor->dpaux)
+		tegra_dpaux_enable(sor->dpaux);
+
+	err = tegra_output_connector_get_modes(connector);
+
+	if (sor->dpaux)
+		tegra_dpaux_disable(sor->dpaux);
+
+	return err;
+}
+
+static enum drm_mode_status
+tegra_sor_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
+{
+	return MODE_OK;
+}
+
+static const struct drm_connector_helper_funcs tegra_sor_connector_helper_funcs = {
+	.get_modes = tegra_sor_connector_get_modes,
+	.mode_valid = tegra_sor_connector_mode_valid,
+	.best_encoder = tegra_output_connector_best_encoder,
+};
+
+static const struct drm_encoder_funcs tegra_sor_encoder_funcs = {
+	.destroy = tegra_output_encoder_destroy,
+};
+
+static void tegra_sor_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+}
+
+static bool tegra_sor_encoder_mode_fixup(struct drm_encoder *encoder,
+					 const struct drm_display_mode *mode,
+					 struct drm_display_mode *adjusted)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
+	unsigned long pclk = mode->clock * 1000;
+	struct tegra_sor *sor = to_sor(output);
+	int err;
+
+	err = tegra_dc_setup_clock(dc, sor->clk_parent, pclk, 0);
+	if (err < 0) {
+		dev_err(output->dev, "failed to setup DC clock: %d\n", err);
+		return false;
+	}
+
+	err = clk_set_rate(sor->clk_parent, pclk);
+	if (err < 0) {
+		dev_err(output->dev, "failed to set clock rate to %lu Hz\n",
+			pclk);
+		return false;
+	}
+
+	return true;
+}
+
+static void tegra_sor_encoder_prepare(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_sor_encoder_commit(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_sor_encoder_mode_set(struct drm_encoder *encoder,
+				       struct drm_display_mode *mode,
+				       struct drm_display_mode *adjusted)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
 	unsigned int vbe, vse, hbe, hse, vbs, hbs, i;
 	struct tegra_sor *sor = to_sor(output);
 	struct tegra_sor_config config;
@@ -504,6 +838,9 @@ static int tegra_output_sor_enable(struct tegra_output *output)
 
 	reset_control_deassert(sor->rst);
 
+	if (output->panel)
+		drm_panel_prepare(output->panel);
+
 	/* FIXME: properly convert to struct drm_dp_aux */
 	aux = (struct drm_dp_aux *)sor->dpaux;
 
@@ -873,175 +1210,61 @@ static int tegra_output_sor_enable(struct tegra_output *output)
 	value = ((vbs & 0x7fff) << 16) | (hbs & 0x7fff);
 	tegra_sor_writel(sor, value, SOR_HEAD_STATE_4(0));
 
-	/* CSTM (LVDS, link A/B, upper) */
-	value = SOR_CSTM_LVDS | SOR_CSTM_LINK_ACT_A | SOR_CSTM_LINK_ACT_B |
-		SOR_CSTM_UPPER;
-	tegra_sor_writel(sor, value, SOR_CSTM);
-
-	/* PWM setup */
-	err = tegra_sor_setup_pwm(sor, 250);
-	if (err < 0) {
-		dev_err(sor->dev, "failed to setup PWM: %d\n", err);
-		goto unlock;
-	}
-
-	value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
-	value |= SOR_ENABLE;
-	tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
-
-	tegra_sor_update(sor);
-
-	err = tegra_sor_attach(sor);
-	if (err < 0) {
-		dev_err(sor->dev, "failed to attach SOR: %d\n", err);
-		goto unlock;
-	}
-
-	err = tegra_sor_wakeup(sor);
-	if (err < 0) {
-		dev_err(sor->dev, "failed to enable DC: %d\n", err);
-		goto unlock;
-	}
-
-	sor->enabled = true;
-
-unlock:
-	mutex_unlock(&sor->lock);
-	return err;
-}
-
-static int tegra_sor_detach(struct tegra_sor *sor)
-{
-	unsigned long value, timeout;
-
-	/* switch to safe mode */
-	value = tegra_sor_readl(sor, SOR_SUPER_STATE_1);
-	value &= ~SOR_SUPER_STATE_MODE_NORMAL;
-	tegra_sor_writel(sor, value, SOR_SUPER_STATE_1);
-	tegra_sor_super_update(sor);
-
-	timeout = jiffies + msecs_to_jiffies(250);
-
-	while (time_before(jiffies, timeout)) {
-		value = tegra_sor_readl(sor, SOR_PWR);
-		if (value & SOR_PWR_MODE_SAFE)
-			break;
-	}
-
-	if ((value & SOR_PWR_MODE_SAFE) == 0)
-		return -ETIMEDOUT;
-
-	/* go to sleep */
-	value = tegra_sor_readl(sor, SOR_SUPER_STATE_1);
-	value &= ~SOR_SUPER_STATE_HEAD_MODE_MASK;
-	tegra_sor_writel(sor, value, SOR_SUPER_STATE_1);
-	tegra_sor_super_update(sor);
-
-	/* detach */
-	value = tegra_sor_readl(sor, SOR_SUPER_STATE_1);
-	value &= ~SOR_SUPER_STATE_ATTACHED;
-	tegra_sor_writel(sor, value, SOR_SUPER_STATE_1);
-	tegra_sor_super_update(sor);
-
-	timeout = jiffies + msecs_to_jiffies(250);
-
-	while (time_before(jiffies, timeout)) {
-		value = tegra_sor_readl(sor, SOR_TEST);
-		if ((value & SOR_TEST_ATTACHED) == 0)
-			break;
-
-		usleep_range(25, 100);
-	}
-
-	if ((value & SOR_TEST_ATTACHED) != 0)
-		return -ETIMEDOUT;
-
-	return 0;
-}
-
-static int tegra_sor_power_down(struct tegra_sor *sor)
-{
-	unsigned long value, timeout;
-	int err;
-
-	value = tegra_sor_readl(sor, SOR_PWR);
-	value &= ~SOR_PWR_NORMAL_STATE_PU;
-	value |= SOR_PWR_TRIGGER;
-	tegra_sor_writel(sor, value, SOR_PWR);
-
-	timeout = jiffies + msecs_to_jiffies(250);
-
-	while (time_before(jiffies, timeout)) {
-		value = tegra_sor_readl(sor, SOR_PWR);
-		if ((value & SOR_PWR_TRIGGER) == 0)
-			return 0;
-
-		usleep_range(25, 100);
-	}
-
-	if ((value & SOR_PWR_TRIGGER) != 0)
-		return -ETIMEDOUT;
-
-	err = clk_set_parent(sor->clk, sor->clk_safe);
-	if (err < 0)
-		dev_err(sor->dev, "failed to set safe parent clock: %d\n", err);
-
-	value = tegra_sor_readl(sor, SOR_DP_PADCTL_0);
-	value &= ~(SOR_DP_PADCTL_PD_TXD_3 | SOR_DP_PADCTL_PD_TXD_0 |
-		   SOR_DP_PADCTL_PD_TXD_1 | SOR_DP_PADCTL_PD_TXD_2);
-	tegra_sor_writel(sor, value, SOR_DP_PADCTL_0);
-
-	/* stop lane sequencer */
-	value = SOR_LANE_SEQ_CTL_TRIGGER | SOR_LANE_SEQ_CTL_SEQUENCE_UP |
-		SOR_LANE_SEQ_CTL_POWER_STATE_DOWN;
-	tegra_sor_writel(sor, value, SOR_LANE_SEQ_CTL);
-
-	timeout = jiffies + msecs_to_jiffies(250);
-
-	while (time_before(jiffies, timeout)) {
-		value = tegra_sor_readl(sor, SOR_LANE_SEQ_CTL);
-		if ((value & SOR_LANE_SEQ_CTL_TRIGGER) == 0)
-			break;
-
-		usleep_range(25, 100);
+	/* CSTM (LVDS, link A/B, upper) */
+	value = SOR_CSTM_LVDS | SOR_CSTM_LINK_ACT_A | SOR_CSTM_LINK_ACT_B |
+		SOR_CSTM_UPPER;
+	tegra_sor_writel(sor, value, SOR_CSTM);
+
+	/* PWM setup */
+	err = tegra_sor_setup_pwm(sor, 250);
+	if (err < 0) {
+		dev_err(sor->dev, "failed to setup PWM: %d\n", err);
+		goto unlock;
 	}
 
-	if ((value & SOR_LANE_SEQ_CTL_TRIGGER) != 0)
-		return -ETIMEDOUT;
+	value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
+	value |= SOR_ENABLE;
+	tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
 
-	value = tegra_sor_readl(sor, SOR_PLL_2);
-	value |= SOR_PLL_2_PORT_POWERDOWN;
-	tegra_sor_writel(sor, value, SOR_PLL_2);
+	tegra_sor_update(sor);
 
-	usleep_range(20, 100);
+	err = tegra_sor_attach(sor);
+	if (err < 0) {
+		dev_err(sor->dev, "failed to attach SOR: %d\n", err);
+		goto unlock;
+	}
 
-	value = tegra_sor_readl(sor, SOR_PLL_0);
-	value |= SOR_PLL_0_POWER_OFF;
-	value |= SOR_PLL_0_VCOPD;
-	tegra_sor_writel(sor, value, SOR_PLL_0);
+	err = tegra_sor_wakeup(sor);
+	if (err < 0) {
+		dev_err(sor->dev, "failed to enable DC: %d\n", err);
+		goto unlock;
+	}
 
-	value = tegra_sor_readl(sor, SOR_PLL_2);
-	value |= SOR_PLL_2_SEQ_PLLCAPPD;
-	value |= SOR_PLL_2_SEQ_PLLCAPPD_ENFORCE;
-	tegra_sor_writel(sor, value, SOR_PLL_2);
+	if (output->panel)
+		drm_panel_enable(output->panel);
 
-	usleep_range(20, 100);
+	sor->enabled = true;
 
-	return 0;
+unlock:
+	mutex_unlock(&sor->lock);
 }
 
-static int tegra_output_sor_disable(struct tegra_output *output)
+static void tegra_sor_encoder_disable(struct drm_encoder *encoder)
 {
-	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
+	struct tegra_output *output = encoder_to_output(encoder);
+	struct tegra_dc *dc = to_tegra_dc(encoder->crtc);
 	struct tegra_sor *sor = to_sor(output);
-	unsigned long value;
-	int err = 0;
+	u32 value;
+	int err;
 
 	mutex_lock(&sor->lock);
 
 	if (!sor->enabled)
 		goto unlock;
 
+	if (output->panel)
+		drm_panel_disable(output->panel);
+
 	err = tegra_sor_detach(sor);
 	if (err < 0) {
 		dev_err(sor->dev, "failed to detach SOR: %d\n", err);
@@ -1056,21 +1279,6 @@ static int tegra_output_sor_disable(struct tegra_output *output)
 	 * sure it's only executed when the output is attached to one.
 	 */
 	if (dc) {
-		/*
-		 * XXX: We can't do this here because it causes the SOR to go
-		 * into an erroneous state and the output will look scrambled
-		 * the next time it is enabled. Presumably this is because we
-		 * should be doing this only on the next VBLANK. A possible
-		 * solution would be to queue a "power-off" event to trigger
-		 * this code to be run during the next VBLANK.
-		 */
-		/*
-		value = tegra_dc_readl(dc, DC_CMD_DISPLAY_POWER_CONTROL);
-		value &= ~(PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
-			   PW4_ENABLE | PM0_ENABLE | PM1_ENABLE);
-		tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
-		*/
-
 		value = tegra_dc_readl(dc, DC_DISP_DISP_WIN_OPTIONS);
 		value &= ~SOR_ENABLE;
 		tegra_dc_writel(dc, value, DC_DISP_DISP_WIN_OPTIONS);
@@ -1098,187 +1306,27 @@ static int tegra_output_sor_disable(struct tegra_output *output)
 		goto unlock;
 	}
 
-	reset_control_assert(sor->rst);
+	if (output->panel)
+		drm_panel_unprepare(output->panel);
+
 	clk_disable_unprepare(sor->clk);
+	reset_control_assert(sor->rst);
 
 	sor->enabled = false;
 
 unlock:
 	mutex_unlock(&sor->lock);
-	return err;
-}
-
-static int tegra_output_sor_setup_clock(struct tegra_output *output,
-					struct clk *clk, unsigned long pclk,
-					unsigned int *div)
-{
-	struct tegra_sor *sor = to_sor(output);
-	int err;
-
-	err = clk_set_parent(clk, sor->clk_parent);
-	if (err < 0) {
-		dev_err(sor->dev, "failed to set parent clock: %d\n", err);
-		return err;
-	}
-
-	err = clk_set_rate(sor->clk_parent, pclk);
-	if (err < 0) {
-		dev_err(sor->dev, "failed to set clock rate to %lu Hz\n", pclk);
-		return err;
-	}
-
-	*div = 0;
-
-	return 0;
-}
-
-static int tegra_output_sor_check_mode(struct tegra_output *output,
-				       struct drm_display_mode *mode,
-				       enum drm_mode_status *status)
-{
-	/*
-	 * FIXME: For now, always assume that the mode is okay.
-	 */
-
-	*status = MODE_OK;
-
-	return 0;
-}
-
-static enum drm_connector_status
-tegra_output_sor_detect(struct tegra_output *output)
-{
-	struct tegra_sor *sor = to_sor(output);
-
-	if (sor->dpaux)
-		return tegra_dpaux_detect(sor->dpaux);
-
-	return connector_status_unknown;
-}
-
-static const struct tegra_output_ops sor_ops = {
-	.enable = tegra_output_sor_enable,
-	.disable = tegra_output_sor_disable,
-	.setup_clock = tegra_output_sor_setup_clock,
-	.check_mode = tegra_output_sor_check_mode,
-	.detect = tegra_output_sor_detect,
-};
-
-static int tegra_sor_crc_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return 0;
-}
-
-static int tegra_sor_crc_release(struct inode *inode, struct file *file)
-{
-	return 0;
-}
-
-static int tegra_sor_crc_wait(struct tegra_sor *sor, unsigned long timeout)
-{
-	u32 value;
-
-	timeout = jiffies + msecs_to_jiffies(timeout);
-
-	while (time_before(jiffies, timeout)) {
-		value = tegra_sor_readl(sor, SOR_CRC_A);
-		if (value & SOR_CRC_A_VALID)
-			return 0;
-
-		usleep_range(100, 200);
-	}
-
-	return -ETIMEDOUT;
-}
-
-static ssize_t tegra_sor_crc_read(struct file *file, char __user *buffer,
-				  size_t size, loff_t *ppos)
-{
-	struct tegra_sor *sor = file->private_data;
-	ssize_t num, err;
-	char buf[10];
-	u32 value;
-
-	mutex_lock(&sor->lock);
-
-	if (!sor->enabled) {
-		err = -EAGAIN;
-		goto unlock;
-	}
-
-	value = tegra_sor_readl(sor, SOR_STATE_1);
-	value &= ~SOR_STATE_ASY_CRC_MODE_MASK;
-	tegra_sor_writel(sor, value, SOR_STATE_1);
-
-	value = tegra_sor_readl(sor, SOR_CRC_CNTRL);
-	value |= SOR_CRC_CNTRL_ENABLE;
-	tegra_sor_writel(sor, value, SOR_CRC_CNTRL);
-
-	value = tegra_sor_readl(sor, SOR_TEST);
-	value &= ~SOR_TEST_CRC_POST_SERIALIZE;
-	tegra_sor_writel(sor, value, SOR_TEST);
-
-	err = tegra_sor_crc_wait(sor, 100);
-	if (err < 0)
-		goto unlock;
-
-	tegra_sor_writel(sor, SOR_CRC_A_RESET, SOR_CRC_A);
-	value = tegra_sor_readl(sor, SOR_CRC_B);
-
-	num = scnprintf(buf, sizeof(buf), "%08x\n", value);
-
-	err = simple_read_from_buffer(buffer, size, ppos, buf, num);
-
-unlock:
-	mutex_unlock(&sor->lock);
-	return err;
 }
 
-static const struct file_operations tegra_sor_crc_fops = {
-	.owner = THIS_MODULE,
-	.open = tegra_sor_crc_open,
-	.read = tegra_sor_crc_read,
-	.release = tegra_sor_crc_release,
+static const struct drm_encoder_helper_funcs tegra_sor_encoder_helper_funcs = {
+	.dpms = tegra_sor_encoder_dpms,
+	.mode_fixup = tegra_sor_encoder_mode_fixup,
+	.prepare = tegra_sor_encoder_prepare,
+	.commit = tegra_sor_encoder_commit,
+	.mode_set = tegra_sor_encoder_mode_set,
+	.disable = tegra_sor_encoder_disable,
 };
 
-static int tegra_sor_debugfs_init(struct tegra_sor *sor,
-				  struct drm_minor *minor)
-{
-	struct dentry *entry;
-	int err = 0;
-
-	sor->debugfs = debugfs_create_dir("sor", minor->debugfs_root);
-	if (!sor->debugfs)
-		return -ENOMEM;
-
-	entry = debugfs_create_file("crc", 0644, sor->debugfs, sor,
-				    &tegra_sor_crc_fops);
-	if (!entry) {
-		dev_err(sor->dev,
-			"cannot create /sys/kernel/debug/dri/%s/sor/crc\n",
-			minor->debugfs_root->d_name.name);
-		err = -ENOMEM;
-		goto remove;
-	}
-
-	return err;
-
-remove:
-	debugfs_remove(sor->debugfs);
-	sor->debugfs = NULL;
-	return err;
-}
-
-static int tegra_sor_debugfs_exit(struct tegra_sor *sor)
-{
-	debugfs_remove_recursive(sor->debugfs);
-	sor->debugfs = NULL;
-
-	return 0;
-}
-
 static int tegra_sor_init(struct host1x_client *client)
 {
 	struct drm_device *drm = dev_get_drvdata(client->parent);
@@ -1288,16 +1336,31 @@ static int tegra_sor_init(struct host1x_client *client)
 	if (!sor->dpaux)
 		return -ENODEV;
 
-	sor->output.type = TEGRA_OUTPUT_EDP;
-
 	sor->output.dev = sor->dev;
-	sor->output.ops = &sor_ops;
 
-	err = tegra_output_init(drm, &sor->output);
-	if (err < 0) {
-		dev_err(sor->dev, "output setup failed: %d\n", err);
-		return err;
-	}
+	drm_connector_init(drm, &sor->output.connector,
+			   &tegra_sor_connector_funcs,
+			   DRM_MODE_CONNECTOR_eDP);
+	drm_connector_helper_add(&sor->output.connector,
+				 &tegra_sor_connector_helper_funcs);
+	sor->output.connector.dpms = DRM_MODE_DPMS_OFF;
+
+	if (sor->output.panel)
+		drm_panel_attach(sor->output.panel, &sor->output.connector);
+
+	drm_encoder_init(drm, &sor->output.encoder, &tegra_sor_encoder_funcs,
+			 DRM_MODE_ENCODER_TMDS);
+	drm_encoder_helper_add(&sor->output.encoder,
+			       &tegra_sor_encoder_helper_funcs);
+
+	drm_mode_connector_attach_encoder(&sor->output.connector,
+					  &sor->output.encoder);
+	drm_connector_register(&sor->output.connector);
+
+	sor->output.encoder.possible_crtcs = 0x3;
+
+	if (gpio_is_valid(sor->output.hpd_gpio))
+		enable_irq(sor->output.hpd_irq);
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_sor_debugfs_init(sor, drm->primary);
@@ -1313,6 +1376,20 @@ static int tegra_sor_init(struct host1x_client *client)
 		}
 	}
 
+	err = clk_prepare_enable(sor->clk);
+	if (err < 0) {
+		dev_err(sor->dev, "failed to enable clock: %d\n", err);
+		return err;
+	}
+
+	err = clk_prepare_enable(sor->clk_safe);
+	if (err < 0)
+		return err;
+
+	err = clk_prepare_enable(sor->clk_dp);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
@@ -1321,12 +1398,6 @@ static int tegra_sor_exit(struct host1x_client *client)
 	struct tegra_sor *sor = host1x_client_to_sor(client);
 	int err;
 
-	err = tegra_output_disable(&sor->output);
-	if (err < 0) {
-		dev_err(sor->dev, "output failed to disable: %d\n", err);
-		return err;
-	}
-
 	if (sor->dpaux) {
 		err = tegra_dpaux_detach(sor->dpaux);
 		if (err < 0) {
@@ -1335,18 +1406,16 @@ static int tegra_sor_exit(struct host1x_client *client)
 		}
 	}
 
+	clk_disable_unprepare(sor->clk_safe);
+	clk_disable_unprepare(sor->clk_dp);
+	clk_disable_unprepare(sor->clk);
+
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
 		err = tegra_sor_debugfs_exit(sor);
 		if (err < 0)
 			dev_err(sor->dev, "debugfs cleanup failed: %d\n", err);
 	}
 
-	err = tegra_output_exit(&sor->output);
-	if (err < 0) {
-		dev_err(sor->dev, "output cleanup failed: %d\n", err);
-		return err;
-	}
-
 	return 0;
 }
 
@@ -1398,26 +1467,14 @@ static int tegra_sor_probe(struct platform_device *pdev)
 	if (IS_ERR(sor->clk_parent))
 		return PTR_ERR(sor->clk_parent);
 
-	err = clk_prepare_enable(sor->clk_parent);
-	if (err < 0)
-		return err;
-
 	sor->clk_safe = devm_clk_get(&pdev->dev, "safe");
 	if (IS_ERR(sor->clk_safe))
 		return PTR_ERR(sor->clk_safe);
 
-	err = clk_prepare_enable(sor->clk_safe);
-	if (err < 0)
-		return err;
-
 	sor->clk_dp = devm_clk_get(&pdev->dev, "dp");
 	if (IS_ERR(sor->clk_dp))
 		return PTR_ERR(sor->clk_dp);
 
-	err = clk_prepare_enable(sor->clk_dp);
-	if (err < 0)
-		return err;
-
 	INIT_LIST_HEAD(&sor->client.list);
 	sor->client.ops = &sor_client_ops;
 	sor->client.dev = &pdev->dev;
@@ -1448,10 +1505,11 @@ static int tegra_sor_remove(struct platform_device *pdev)
 		return err;
 	}
 
-	clk_disable_unprepare(sor->clk_parent);
-	clk_disable_unprepare(sor->clk_safe);
-	clk_disable_unprepare(sor->clk_dp);
-	clk_disable_unprepare(sor->clk);
+	err = tegra_output_remove(&sor->output);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to remove output: %d\n", err);
+		return err;
+	}
 
 	return 0;
 }
-- 
2.1.3

