Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbbAGV1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:27:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57118 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbbAGV1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:27:50 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 1/3] drm/msm/hdmi: use dynamic allocation for hdmi resources
Date: Wed,  7 Jan 2015 16:27:25 -0500
Message-Id: <1420666047-3690-2-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1420666047-3690-1-git-send-email-sviau@codeaurora.org>
References: <1420666047-3690-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reporting BUG_ON when resources arrays are not
dimensioned correctly, this patch does a dynamic allocation of
these arrays. This is needed for the following patches that add a
regulator for a new target.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 33 +++++++++++++++++++++++++++++----
 drivers/gpu/drm/msm/hdmi/hdmi.h |  8 ++++----
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 062c687..a9092d6 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -65,6 +65,11 @@ static void hdmi_destroy(struct hdmi *hdmi)
 	if (hdmi->i2c)
 		hdmi_i2c_destroy(hdmi->i2c);
 
+	devm_kfree(&hdmi->pdev->dev, hdmi->pwr_clks);
+	devm_kfree(&hdmi->pdev->dev, hdmi->hpd_clks);
+	devm_kfree(&hdmi->pdev->dev, hdmi->pwr_regs);
+	devm_kfree(&hdmi->pdev->dev, hdmi->hpd_regs);
+
 	platform_set_drvdata(hdmi->pdev, NULL);
 }
 
@@ -106,7 +111,12 @@ static struct hdmi *hdmi_init(struct platform_device *pdev)
 		goto fail;
 	}
 
-	BUG_ON(config->hpd_reg_cnt > ARRAY_SIZE(hdmi->hpd_regs));
+	hdmi->hpd_regs = devm_kzalloc(&pdev->dev, sizeof(hdmi->hpd_regs[0]) *
+			config->hpd_reg_cnt, GFP_KERNEL);
+	if (!hdmi->hpd_regs) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 	for (i = 0; i < config->hpd_reg_cnt; i++) {
 		struct regulator *reg;
 
@@ -122,7 +132,12 @@ static struct hdmi *hdmi_init(struct platform_device *pdev)
 		hdmi->hpd_regs[i] = reg;
 	}
 
-	BUG_ON(config->pwr_reg_cnt > ARRAY_SIZE(hdmi->pwr_regs));
+	hdmi->pwr_regs = devm_kzalloc(&pdev->dev, sizeof(hdmi->pwr_regs[0]) *
+			config->pwr_reg_cnt, GFP_KERNEL);
+	if (!hdmi->pwr_regs) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 	for (i = 0; i < config->pwr_reg_cnt; i++) {
 		struct regulator *reg;
 
@@ -138,7 +153,12 @@ static struct hdmi *hdmi_init(struct platform_device *pdev)
 		hdmi->pwr_regs[i] = reg;
 	}
 
-	BUG_ON(config->hpd_clk_cnt > ARRAY_SIZE(hdmi->hpd_clks));
+	hdmi->hpd_clks = devm_kzalloc(&pdev->dev, sizeof(hdmi->hpd_clks[0]) *
+			config->hpd_clk_cnt, GFP_KERNEL);
+	if (!hdmi->hpd_clks) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 	for (i = 0; i < config->hpd_clk_cnt; i++) {
 		struct clk *clk;
 
@@ -153,7 +173,12 @@ static struct hdmi *hdmi_init(struct platform_device *pdev)
 		hdmi->hpd_clks[i] = clk;
 	}
 
-	BUG_ON(config->pwr_clk_cnt > ARRAY_SIZE(hdmi->pwr_clks));
+	hdmi->pwr_clks = devm_kzalloc(&pdev->dev, sizeof(hdmi->pwr_clks[0]) *
+			config->pwr_clk_cnt, GFP_KERNEL);
+	if (!hdmi->pwr_clks) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 	for (i = 0; i < config->pwr_clk_cnt; i++) {
 		struct clk *clk;
 
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.h b/drivers/gpu/drm/msm/hdmi/hdmi.h
index 43e654f..9973e03 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.h
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.h
@@ -52,10 +52,10 @@ struct hdmi {
 
 	void __iomem *mmio;
 
-	struct regulator *hpd_regs[2];
-	struct regulator *pwr_regs[2];
-	struct clk *hpd_clks[3];
-	struct clk *pwr_clks[2];
+	struct regulator **hpd_regs;
+	struct regulator **pwr_regs;
+	struct clk **hpd_clks;
+	struct clk **pwr_clks;
 
 	struct hdmi_phy *phy;
 	struct i2c_adapter *i2c;
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

