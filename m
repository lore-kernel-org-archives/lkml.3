Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaFFOGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:06:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41512 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaFFOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:06:17 -0400
From: Stephane Viau <sviau@codeaurora.org>
To: robdclark@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH] drm/msm/hdmi: set hdp clock rate before prepare_enable call
Date: Fri,  6 Jun 2014 10:03:32 -0400
Message-Id: <1402063412-10407-1-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock driver usually complains when a clock is being prepared
before setting its rate. It is the case here for "core_clk" which
needs to be set at 19.2 MHz before we attempt a prepare_enable().

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c           | 2 ++
 drivers/gpu/drm/msm/hdmi/hdmi.h           | 1 +
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c | 8 ++++++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index ae750f6..7f7aade 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -277,6 +277,7 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 	static const char *hpd_reg_names[] = {"hpd-gdsc", "hpd-5v"};
 	static const char *pwr_reg_names[] = {"core-vdda", "core-vcc"};
 	static const char *hpd_clk_names[] = {"iface_clk", "core_clk", "mdp_core_clk"};
+	static unsigned long hpd_clk_freq[] = {0, 19200000, 0};
 	static const char *pwr_clk_names[] = {"extp_clk", "alt_iface_clk"};
 
 	config.phy_init      = hdmi_phy_8x74_init;
@@ -286,6 +287,7 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 	config.pwr_reg_names = pwr_reg_names;
 	config.pwr_reg_cnt   = ARRAY_SIZE(pwr_reg_names);
 	config.hpd_clk_names = hpd_clk_names;
+	config.hpd_freq      = hpd_clk_freq;
 	config.hpd_clk_cnt   = ARRAY_SIZE(hpd_clk_names);
 	config.pwr_clk_names = pwr_clk_names;
 	config.pwr_clk_cnt   = ARRAY_SIZE(pwr_clk_names);
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.h b/drivers/gpu/drm/msm/hdmi/hdmi.h
index 9fafee6..9d7723c 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.h
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.h
@@ -87,6 +87,7 @@ struct hdmi_platform_config {
 
 	/* clks that need to be on for hpd: */
 	const char **hpd_clk_names;
+	const long unsigned *hpd_freq;
 	int hpd_clk_cnt;
 
 	/* clks that need to be on for screen pwr (ie pixel clk): */
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
index 7dedfdd..93d1551 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
@@ -127,6 +127,14 @@ static int hpd_enable(struct hdmi_connector *hdmi_connector)
 	}
 
 	for (i = 0; i < config->hpd_clk_cnt; i++) {
+		if (config->hpd_freq[i]) {
+			ret = clk_set_rate(hdmi->hpd_clks[i],
+					config->hpd_freq[i]);
+			if (ret)
+				dev_warn(dev->dev, "failed to set clk %s (%d)\n",
+						config->hpd_clk_names[i], ret);
+		}
+
 		ret = clk_prepare_enable(hdmi->hpd_clks[i]);
 		if (ret) {
 			dev_err(dev->dev, "failed to enable hpd clk: %s (%d)\n",
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

