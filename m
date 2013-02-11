Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3BKQ2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:28:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35473 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757958Ab3BKQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 05/11] extcon: arizona: Use regulated mode for microphone supply when detecting
Date: Mon, 11 Feb 2013 16:27:00 +0000
Message-Id: <1360600026-16878-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When starting microphone detection some headsets should be exposed to
the fully regulated microphone bias in order to ensure that they behave
in an optimal fashion.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/Kconfig            |    2 +-
 drivers/extcon/extcon-arizona.c   |   93 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/arizona/pdata.h |    3 ++
 3 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 07122a9..9377050 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -47,7 +47,7 @@ config EXTCON_MAX8997
 
 config EXTCON_ARIZONA
 	tristate "Wolfson Arizona EXTCON support"
-	depends on MFD_ARIZONA && INPUT
+	depends on MFD_ARIZONA && INPUT && SND_SOC
 	help
 	  Say Y here to enable support for external accessory detection
 	  with Wolfson Arizona devices. These are audio CODECs with
diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index d7e1047..aa72431 100644
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
@@ -113,6 +115,52 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 	dev_dbg(arizona->dev, "Set jack polarity to %d\n", mode);
 }
 
+static const char *arizona_extcon_get_micbias(struct arizona_extcon_info *info)
+{
+	switch (info->micd_modes[0].bias >> ARIZONA_MICD_BIAS_SRC_SHIFT) {
+	case 1:
+		return "MICBIAS1";
+	case 2:
+		return "MICBIAS2";
+	case 3:
+		return "MICBIAS3";
+	default:
+		return "MICVDD";
+	}
+}
+
+static void arizona_extcon_pulse_micbias(struct arizona_extcon_info *info)
+{
+	struct arizona *arizona = info->arizona;
+	const char *widget = arizona_extcon_get_micbias(info);
+	struct snd_soc_dapm_context *dapm = arizona->dapm;
+	int ret;
+
+	mutex_lock(&dapm->card->dapm_mutex);
+
+	ret = snd_soc_dapm_force_enable_pin(dapm, widget);
+	if (ret != 0)
+		dev_warn(arizona->dev, "Failed to enable %s: %d\n",
+			 widget, ret);
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
+	snd_soc_dapm_sync(dapm);
+
+	if (!arizona->pdata.micd_force_micbias) {
+		mutex_lock(&dapm->card->dapm_mutex);
+
+		ret = snd_soc_dapm_disable_pin(arizona->dapm, widget);
+		if (ret != 0)
+			dev_warn(arizona->dev, "Failed to disable %s: %d\n",
+				 widget, ret);
+
+		mutex_unlock(&dapm->card->dapm_mutex);
+
+		snd_soc_dapm_sync(dapm);
+	}
+}
+
 static void arizona_start_mic(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
@@ -122,6 +170,15 @@ static void arizona_start_mic(struct arizona_extcon_info *info)
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
@@ -138,6 +195,8 @@ static void arizona_start_mic(struct arizona_extcon_info *info)
 			   ARIZONA_ACCESSORY_DETECT_MODE_1,
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
+	arizona_extcon_pulse_micbias(info);
+
 	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
 				 ARIZONA_MICD_ENA, ARIZONA_MICD_ENA,
 				 &change);
@@ -150,18 +209,39 @@ static void arizona_start_mic(struct arizona_extcon_info *info)
 static void arizona_stop_mic(struct arizona_extcon_info *info)
 {
 	struct arizona *arizona = info->arizona;
+	const char *widget = arizona_extcon_get_micbias(info);
+	struct snd_soc_dapm_context *dapm = arizona->dapm;
 	bool change;
+	int ret;
 
 	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
 				 ARIZONA_MICD_ENA, 0,
 				 &change);
 
+	mutex_lock(&dapm->card->dapm_mutex);
+
+	ret = snd_soc_dapm_disable_pin(dapm, widget);
+	if (ret != 0)
+		dev_warn(arizona->dev,
+			 "Failed to disable %s: %d\n",
+			 widget, ret);
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
+	snd_soc_dapm_sync(dapm);
+
 	if (info->micd_reva) {
 		regmap_write(arizona->regmap, 0x80, 0x3);
 		regmap_write(arizona->regmap, 0x294, 2);
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
@@ -564,6 +644,8 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 
 	info->hpdet_active = true;
 
+	arizona_extcon_pulse_micbias(info);
+
 	ret = regmap_update_bits(arizona->regmap, 0x225, 0x4000, 0x4000);
 	if (ret != 0)
 		dev_warn(arizona->dev, "Failed to do magic: %d\n", ret);
@@ -649,6 +731,13 @@ static irqreturn_t arizona_micdet(int irq, void *data)
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
@@ -716,6 +805,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			input_report_key(info->input,
 					 arizona_lvl_to_key[i].report, 0);
 		input_sync(info->input);
+		arizona_extcon_pulse_micbias(info);
 	}
 
 handled:
@@ -817,6 +907,9 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	int jack_irq_fall, jack_irq_rise;
 	int ret, mode, i;
 
+	if (!arizona->dapm || !arizona->dapm->card)
+		return -EPROBE_DEFER;
+
 	pdata = dev_get_platdata(arizona->dev);
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 2f5f08e..f824175 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -117,6 +117,9 @@ struct arizona_pdata {
 	/** Mic detect debounce level */
 	int micd_dbtime;
 
+	/** Force MICBIAS on for mic detect */
+	bool micd_force_micbias;
+
 	/** Headset polarity configurations */
 	struct arizona_micd_config *micd_configs;
 	int num_micd_configs;
-- 
1.7.10.4

