Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3AWQEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:04:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44482 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428Ab3AWQEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:04:13 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/5] extcon: arizona: Use regulated mode for microphone supply when detecting
Date: Thu, 24 Jan 2013 00:03:49 +0800
Message-Id: <1358957029-5421-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1358957029-5421-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When starting microphone detection some headsets should be exposed to
the fully regulated microphone bias in order to ensure that they behave
in an optimal fashion.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   62 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index d7e1047..3aacacc 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -27,6 +27,8 @@
 #include <linux/regulator/consumer.h>
 #include <linux/extcon.h>
 
+#include <sound/soc.h>
+
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/pdata.h>
 #include <linux/mfd/arizona/registers.h>
@@ -113,6 +115,40 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 	dev_dbg(arizona->dev, "Set jack polarity to %d\n", mode);
 }
 
+static void arizona_extcon_pulse_micbias(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	const char *widget;
+	int ret;
+
+	if (arizona->dapm) {
+		switch (info->micd_modes[0].bias) {
+		case 1:
+			widget = "MICBIAS1";
+			break;
+		case 2:
+			widget = "MICBIAS2";
+			break;
+		case 3:
+			widget = "MICBIAS3";
+			break;
+		default:
+			widget = "MICVDD";
+			break;
+		}
+
+		ret = snd_soc_dapm_force_enable_pin(arizona->dapm, widget);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to enable %s: %d\n",
+				 widget, ret);
+
+		ret = snd_soc_dapm_disable_pin(arizona->dapm, widget);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to disable %s: %d\n",
+				 widget, ret);
+	}
+}
+
 static void arizona_start_mic(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
@@ -122,6 +158,15 @@ static void arizona_start_mic(struct arizona_extcon_info *info)
 	/* Microphone detection can't use idle mode */
 	pm_runtime_get(info->dev);
 
+	if (info->detecting) {
+		ret = regulator_allow_bypass(info->micvdd, false);
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Failed to regulate MICVDD: %d\n",
+				ret);
+		}
+	}
+
 	ret = regulator_enable(info->micvdd);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to enable MICVDD: %d\n",
@@ -151,6 +196,7 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
 	bool change;
+	int ret;
 
 	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
 				 ARIZONA_MICD_ENA, 0,
@@ -162,6 +208,12 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
 		regmap_write(arizona->regmap, 0x80, 0x0);
 	}
 
+	ret = regulator_allow_bypass(info->micvdd, true);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to bypass MICVDD: %d\n",
+			ret);
+	}
+
 	if (change) {
 		regulator_disable(info->micvdd);
 		pm_runtime_mark_last_busy(info->dev);
@@ -564,6 +616,8 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 
 	info->hpdet_active = true;
 
+	arizona_extcon_pulse_micbias(info);
+
 	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0x4000);
 	if (ret != 0)
 		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
@@ -649,6 +703,13 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			dev_err(arizona->dev, "Headset report failed: %d\n",
 				ret);
 
+		/* Don't need to regulate for button detection */
+		ret = regulator_allow_bypass(info->micvdd, false);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to bypass MICVDD: %d\n",
+				ret);
+		}
+
 		info->mic = true;
 		info->detecting = false;
 		goto handled;
@@ -716,6 +777,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			input_report_key(info->input,
 					 arizona_lvl_to_key[i].report, 0);
 		input_sync(info->input);
+		arizona_extcon_pulse_micbias(info);
 	}
 
 handled:
-- 
1.7.10.4

