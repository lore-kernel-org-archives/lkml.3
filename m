Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab3BZWyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:54:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50897 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3BZWyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:54:49 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Radhesh Fadnis <radhesh.fadnis@ti.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 02/15] staging: omap-thermal: introduce clock feature flag
Date: Tue, 26 Feb 2013 18:53:25 -0400
Message-ID: <1361919218-9788-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Radhesh Fadnis <radhesh.fadnis@ti.com>

The clock to Bandgap module is SW controlled on some version of
OMAP silicon (OMAP44xx). But on OMAP54xx ES2.0
onwards this is HW-Auto controlled. Hence introduce a feature flag
to use/not-to-use SW enable/disable of BG clock.

Signed-off-by: Radhesh Fadnis <radhesh.fadnis@ti.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c  |   18 +++++++++++++-----
 drivers/staging/omap-thermal/omap-bandgap.h  |    1 +
 drivers/staging/omap-thermal/omap4-thermal.c |    3 +++
 drivers/staging/omap-thermal/omap5-thermal.c |    3 ++-
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 35b9915..80384ed 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -914,7 +914,9 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Cannot re-set clock rate. Continuing\n");
 
 	bg_ptr->clk_rate = clk_rate;
-	clk_enable(bg_ptr->fclock);
+	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
+		clk_enable(bg_ptr->fclock);
+
 
 	mutex_init(&bg_ptr->bg_mutex);
 	bg_ptr->dev = &pdev->dev;
@@ -982,7 +984,8 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	return 0;
 
 disable_clk:
-	clk_disable(bg_ptr->fclock);
+	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
+		clk_disable(bg_ptr->fclock);
 put_clks:
 	clk_put(bg_ptr->fclock);
 	clk_put(bg_ptr->div_clk);
@@ -1012,7 +1015,8 @@ int omap_bandgap_remove(struct platform_device *pdev)
 
 	omap_bandgap_power(bg_ptr, false);
 
-	clk_disable(bg_ptr->fclock);
+	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
+		clk_disable(bg_ptr->fclock);
 	clk_put(bg_ptr->fclock);
 	clk_put(bg_ptr->div_clk);
 
@@ -1109,7 +1113,9 @@ static int omap_bandgap_suspend(struct device *dev)
 
 	err = omap_bandgap_save_ctxt(bg_ptr);
 	omap_bandgap_power(bg_ptr, false);
-	clk_disable(bg_ptr->fclock);
+
+	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
+		clk_disable(bg_ptr->fclock);
 
 	return err;
 }
@@ -1118,7 +1124,9 @@ static int omap_bandgap_resume(struct device *dev)
 {
 	struct omap_bandgap *bg_ptr = dev_get_drvdata(dev);
 
-	clk_enable(bg_ptr->fclock);
+	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
+		clk_enable(bg_ptr->fclock);
+
 	omap_bandgap_power(bg_ptr, true);
 
 	return omap_bandgap_restore_ctxt(bg_ptr);
diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index 2bb14bd..85e1a2f 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -384,6 +384,7 @@ struct omap_bandgap_data {
 #define OMAP_BANDGAP_FEATURE_MODE_CONFIG	(1 << 3)
 #define OMAP_BANDGAP_FEATURE_COUNTER		(1 << 4)
 #define OMAP_BANDGAP_FEATURE_POWER_SWITCH	(1 << 5)
+#define OMAP_BANDGAP_FEATURE_CLK_CTRL		(1 << 6)
 #define OMAP_BANDGAP_HAS(b, f)			\
 			((b)->conf->features & OMAP_BANDGAP_FEATURE_ ## f)
 	unsigned int			features;
diff --git a/drivers/staging/omap-thermal/omap4-thermal.c b/drivers/staging/omap-thermal/omap4-thermal.c
index 04c02b6..732c853 100644
--- a/drivers/staging/omap-thermal/omap4-thermal.c
+++ b/drivers/staging/omap-thermal/omap4-thermal.c
@@ -69,6 +69,7 @@ omap4430_adc_to_temp[OMAP4430_ADC_END_VALUE - OMAP4430_ADC_START_VALUE + 1] = {
 /* OMAP4430 data */
 const struct omap_bandgap_data omap4430_data = {
 	.features = OMAP_BANDGAP_FEATURE_MODE_CONFIG |
+			OMAP_BANDGAP_FEATURE_CLK_CTRL |
 			OMAP_BANDGAP_FEATURE_POWER_SWITCH,
 	.fclock_name = "bandgap_fclk",
 	.div_ck_name = "bandgap_fclk",
@@ -207,6 +208,7 @@ const struct omap_bandgap_data omap4460_data = {
 			OMAP_BANDGAP_FEATURE_TALERT |
 			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
 			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
+			OMAP_BANDGAP_FEATURE_CLK_CTRL |
 			OMAP_BANDGAP_FEATURE_COUNTER,
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
@@ -236,6 +238,7 @@ const struct omap_bandgap_data omap4470_data = {
 			OMAP_BANDGAP_FEATURE_TALERT |
 			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
 			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
+			OMAP_BANDGAP_FEATURE_CLK_CTRL |
 			OMAP_BANDGAP_FEATURE_COUNTER,
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index 2f3a498..8fca21b 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -260,7 +260,8 @@ const struct omap_bandgap_data omap5430_data = {
 	.features = OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
 			OMAP_BANDGAP_FEATURE_TALERT |
 			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_COUNTER,
+			OMAP_BANDGAP_FEATURE_COUNTER |
+			OMAP_BANDGAP_FEATURE_CLK_CTRL,
 	.fclock_name = "ts_clk_div_ck",
 	.div_ck_name = "ts_clk_div_ck",
 	.conv_table = omap5430_adc_to_temp,
-- 
1.7.7.1.488.ge8e1c

