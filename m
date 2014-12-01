Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaLAULM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:11:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33336 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:11:10 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH 2/4] drm/msm/hdmi: enable regulators before clocks to avoid warnings
Date: Mon,  1 Dec 2014 15:10:37 -0500
Message-Id: <1417464637-29461-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPD regulators need to be enabled before clocks, otherwise clock
driver will report warning.

Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_connector.c | 45 +++++++++++++------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
index 92fddd8..caa1301 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_connector.c
@@ -141,6 +141,15 @@ static int hpd_enable(struct hdmi_connector *hdmi_connector)
 	uint32_t hpd_ctrl;
 	int i, ret;
 
+	for (i = 0; i < config->hpd_reg_cnt; i++) {
+		ret = regulator_enable(hdmi->hpd_regs[i]);
+		if (ret) {
+			dev_err(dev->dev, "failed to enable hpd regulator: %s (%d)\n",
+					config->hpd_reg_names[i], ret);
+			goto fail;
+		}
+	}
+
 	ret = gpio_config(hdmi, true);
 	if (ret) {
 		dev_err(dev->dev, "failed to configure GPIOs: %d\n", ret);
@@ -164,15 +173,6 @@ static int hpd_enable(struct hdmi_connector *hdmi_connector)
 		}
 	}
 
-	for (i = 0; i < config->hpd_reg_cnt; i++) {
-		ret = regulator_enable(hdmi->hpd_regs[i]);
-		if (ret) {
-			dev_err(dev->dev, "failed to enable hpd regulator: %s (%d)\n",
-					config->hpd_reg_names[i], ret);
-			goto fail;
-		}
-	}
-
 	hdmi_set_mode(hdmi, false);
 	phy->funcs->reset(phy);
 	hdmi_set_mode(hdmi, true);
@@ -200,7 +200,7 @@ fail:
 	return ret;
 }
 
-static int hdp_disable(struct hdmi_connector *hdmi_connector)
+static void hdp_disable(struct hdmi_connector *hdmi_connector)
 {
 	struct hdmi *hdmi = hdmi_connector->hdmi;
 	const struct hdmi_platform_config *config = hdmi->config;
@@ -212,28 +212,19 @@ static int hdp_disable(struct hdmi_connector *hdmi_connector)
 
 	hdmi_set_mode(hdmi, false);
 
-	for (i = 0; i < config->hpd_reg_cnt; i++) {
-		ret = regulator_disable(hdmi->hpd_regs[i]);
-		if (ret) {
-			dev_err(dev->dev, "failed to disable hpd regulator: %s (%d)\n",
-					config->hpd_reg_names[i], ret);
-			goto fail;
-		}
-	}
-
 	for (i = 0; i < config->hpd_clk_cnt; i++)
 		clk_disable_unprepare(hdmi->hpd_clks[i]);
 
 	ret = gpio_config(hdmi, false);
-	if (ret) {
-		dev_err(dev->dev, "failed to unconfigure GPIOs: %d\n", ret);
-		goto fail;
-	}
-
-	return 0;
+	if (ret)
+		dev_warn(dev->dev, "failed to unconfigure GPIOs: %d\n", ret);
 
-fail:
-	return ret;
+	for (i = 0; i < config->hpd_reg_cnt; i++) {
+		ret = regulator_disable(hdmi->hpd_regs[i]);
+		if (ret)
+			dev_warn(dev->dev, "failed to disable hpd regulator: %s (%d)\n",
+					config->hpd_reg_names[i], ret);
+	}
 }
 
 static void
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

