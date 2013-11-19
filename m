Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3KSQIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:08:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49224 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab3KSQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:04:51 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: lgirdwood@gmail.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmico.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ASoC: wm5110: Hook up ADSP2 cores
Date: Tue, 19 Nov 2013 16:03:33 +0000
Message-Id: <1384877015-5596-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384877015-5596-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384877015-5596-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/Kconfig  |    2 +
 sound/soc/codecs/wm5110.c |  119 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index b33b45d..983d087a 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -163,8 +163,10 @@ config SND_SOC_WM_HUBS
 config SND_SOC_WM_ADSP
 	tristate
 	default y if SND_SOC_WM5102=y
+	default y if SND_SOC_WM5110=y
 	default y if SND_SOC_WM2200=y
 	default m if SND_SOC_WM5102=m
+	default m if SND_SOC_WM5110=m
 	default m if SND_SOC_WM2200=m
 
 config SND_SOC_AB8500_CODEC
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index c3c7396..d5ecdd2 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -30,13 +30,51 @@
 #include <linux/mfd/arizona/registers.h>
 
 #include "arizona.h"
+#include "wm_adsp.h"
 #include "wm5110.h"
 
+#define WM5110_NUM_ADSP 4
+
 struct wm5110_priv {
 	struct arizona_priv core;
 	struct arizona_fll fll[2];
 };
 
+static const struct wm_adsp_region wm5110_dsp1_regions[] = {
+	{ .type = WMFW_ADSP2_PM, .base = 0x100000 },
+	{ .type = WMFW_ADSP2_ZM, .base = 0x180000 },
+	{ .type = WMFW_ADSP2_XM, .base = 0x190000 },
+	{ .type = WMFW_ADSP2_YM, .base = 0x1a8000 },
+};
+
+static const struct wm_adsp_region wm5110_dsp2_regions[] = {
+	{ .type = WMFW_ADSP2_PM, .base = 0x200000 },
+	{ .type = WMFW_ADSP2_ZM, .base = 0x280000 },
+	{ .type = WMFW_ADSP2_XM, .base = 0x290000 },
+	{ .type = WMFW_ADSP2_YM, .base = 0x2a8000 },
+};
+
+static const struct wm_adsp_region wm5110_dsp3_regions[] = {
+	{ .type = WMFW_ADSP2_PM, .base = 0x300000 },
+	{ .type = WMFW_ADSP2_ZM, .base = 0x380000 },
+	{ .type = WMFW_ADSP2_XM, .base = 0x390000 },
+	{ .type = WMFW_ADSP2_YM, .base = 0x3a8000 },
+};
+
+static const struct wm_adsp_region wm5110_dsp4_regions[] = {
+	{ .type = WMFW_ADSP2_PM, .base = 0x400000 },
+	{ .type = WMFW_ADSP2_ZM, .base = 0x480000 },
+	{ .type = WMFW_ADSP2_XM, .base = 0x490000 },
+	{ .type = WMFW_ADSP2_YM, .base = 0x4a8000 },
+};
+
+static const struct wm_adsp_region *wm5110_dsp_regions[] = {
+	wm5110_dsp1_regions,
+	wm5110_dsp2_regions,
+	wm5110_dsp3_regions,
+	wm5110_dsp4_regions,
+};
+
 static const struct reg_default wm5110_sysclk_revd_patch[] = {
 	{ 0x3093, 0x1001 },
 	{ 0x30E3, 0x1301 },
@@ -372,6 +410,22 @@ ARIZONA_MIXER_ENUMS(LHPF2, ARIZONA_HPLP2MIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(LHPF3, ARIZONA_HPLP3MIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(LHPF4, ARIZONA_HPLP4MIX_INPUT_1_SOURCE);
 
+ARIZONA_MIXER_ENUMS(DSP1L, ARIZONA_DSP1LMIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(DSP1R, ARIZONA_DSP1RMIX_INPUT_1_SOURCE);
+ARIZONA_DSP_AUX_ENUMS(DSP1, ARIZONA_DSP1AUX1MIX_INPUT_1_SOURCE);
+
+ARIZONA_MIXER_ENUMS(DSP2L, ARIZONA_DSP2LMIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(DSP2R, ARIZONA_DSP2RMIX_INPUT_1_SOURCE);
+ARIZONA_DSP_AUX_ENUMS(DSP2, ARIZONA_DSP2AUX1MIX_INPUT_1_SOURCE);
+
+ARIZONA_MIXER_ENUMS(DSP3L, ARIZONA_DSP3LMIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(DSP3R, ARIZONA_DSP3RMIX_INPUT_1_SOURCE);
+ARIZONA_DSP_AUX_ENUMS(DSP3, ARIZONA_DSP3AUX1MIX_INPUT_1_SOURCE);
+
+ARIZONA_MIXER_ENUMS(DSP4L, ARIZONA_DSP4LMIX_INPUT_1_SOURCE);
+ARIZONA_MIXER_ENUMS(DSP4R, ARIZONA_DSP4RMIX_INPUT_1_SOURCE);
+ARIZONA_DSP_AUX_ENUMS(DSP4, ARIZONA_DSP4AUX1MIX_INPUT_1_SOURCE);
+
 ARIZONA_MIXER_ENUMS(Mic, ARIZONA_MICMIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(Noise, ARIZONA_NOISEMIX_INPUT_1_SOURCE);
 
@@ -560,6 +614,11 @@ SND_SOC_DAPM_PGA("ASRC2L", ARIZONA_ASRC_ENABLE, ARIZONA_ASRC2L_ENA_SHIFT, 0,
 SND_SOC_DAPM_PGA("ASRC2R", ARIZONA_ASRC_ENABLE, ARIZONA_ASRC2R_ENA_SHIFT, 0,
 		 NULL, 0),
 
+WM_ADSP2("DSP1", 0),
+WM_ADSP2("DSP2", 1),
+WM_ADSP2("DSP3", 2),
+WM_ADSP2("DSP4", 3),
+
 SND_SOC_DAPM_VALUE_MUX("AEC Loopback", ARIZONA_DAC_AEC_CONTROL_1,
 		       ARIZONA_AEC_LOOPBACK_ENA_SHIFT, 0,
 		       &wm5110_aec_loopback_mux),
@@ -762,6 +821,11 @@ ARIZONA_MUX_WIDGETS(ASRC1R, "ASRC1R"),
 ARIZONA_MUX_WIDGETS(ASRC2L, "ASRC2L"),
 ARIZONA_MUX_WIDGETS(ASRC2R, "ASRC2R"),
 
+ARIZONA_DSP_WIDGETS(DSP1, "DSP1"),
+ARIZONA_DSP_WIDGETS(DSP2, "DSP2"),
+ARIZONA_DSP_WIDGETS(DSP3, "DSP3"),
+ARIZONA_DSP_WIDGETS(DSP4, "DSP4"),
+
 SND_SOC_DAPM_OUTPUT("HPOUT1L"),
 SND_SOC_DAPM_OUTPUT("HPOUT1R"),
 SND_SOC_DAPM_OUTPUT("HPOUT2L"),
@@ -830,7 +894,31 @@ SND_SOC_DAPM_OUTPUT("MICSUPP"),
 	{ name, "ASRC1L", "ASRC1L" }, \
 	{ name, "ASRC1R", "ASRC1R" }, \
 	{ name, "ASRC2L", "ASRC2L" }, \
-	{ name, "ASRC2R", "ASRC2R" }
+	{ name, "ASRC2R", "ASRC2R" }, \
+	{ name, "DSP1.1", "DSP1" }, \
+	{ name, "DSP1.2", "DSP1" }, \
+	{ name, "DSP1.3", "DSP1" }, \
+	{ name, "DSP1.4", "DSP1" }, \
+	{ name, "DSP1.5", "DSP1" }, \
+	{ name, "DSP1.6", "DSP1" }, \
+	{ name, "DSP2.1", "DSP2" }, \
+	{ name, "DSP2.2", "DSP2" }, \
+	{ name, "DSP2.3", "DSP2" }, \
+	{ name, "DSP2.4", "DSP2" }, \
+	{ name, "DSP2.5", "DSP2" }, \
+	{ name, "DSP2.6", "DSP2" }, \
+	{ name, "DSP3.1", "DSP3" }, \
+	{ name, "DSP3.2", "DSP3" }, \
+	{ name, "DSP3.3", "DSP3" }, \
+	{ name, "DSP3.4", "DSP3" }, \
+	{ name, "DSP3.5", "DSP3" }, \
+	{ name, "DSP3.6", "DSP3" }, \
+	{ name, "DSP4.1", "DSP4" }, \
+	{ name, "DSP4.2", "DSP4" }, \
+	{ name, "DSP4.3", "DSP4" }, \
+	{ name, "DSP4.4", "DSP4" }, \
+	{ name, "DSP4.5", "DSP4" }, \
+	{ name, "DSP4.6", "DSP4" }
 
 static const struct snd_soc_dapm_route wm5110_dapm_routes[] = {
 	{ "AIF2 Capture", NULL, "DBVDD2" },
@@ -1024,6 +1112,11 @@ static const struct snd_soc_dapm_route wm5110_dapm_routes[] = {
 	ARIZONA_MUX_ROUTES("ASRC2L", "ASRC2L"),
 	ARIZONA_MUX_ROUTES("ASRC2R", "ASRC2R"),
 
+	ARIZONA_DSP_ROUTES("DSP1"),
+	ARIZONA_DSP_ROUTES("DSP2"),
+	ARIZONA_DSP_ROUTES("DSP3"),
+	ARIZONA_DSP_ROUTES("DSP4"),
+
 	{ "AEC Loopback", "HPOUT1L", "OUT1L" },
 	{ "AEC Loopback", "HPOUT1R", "OUT1R" },
 	{ "HPOUT1L", NULL, "OUT1L" },
@@ -1229,6 +1322,10 @@ static int wm5110_codec_probe(struct snd_soc_codec *codec)
 	arizona_init_spk(codec);
 	arizona_init_gpio(codec);
 
+	ret = snd_soc_add_codec_controls(codec, wm_adsp2_fw_controls, 8);
+	if (ret != 0)
+		return ret;
+
 	snd_soc_dapm_disable_pin(&codec->dapm, "HAPTICS");
 
 	priv->core.arizona->dapm = &codec->dapm;
@@ -1283,7 +1380,7 @@ static int wm5110_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
 	struct wm5110_priv *wm5110;
-	int i;
+	int i, ret;
 
 	wm5110 = devm_kzalloc(&pdev->dev, sizeof(struct wm5110_priv),
 			      GFP_KERNEL);
@@ -1294,6 +1391,24 @@ static int wm5110_probe(struct platform_device *pdev)
 	wm5110->core.arizona = arizona;
 	wm5110->core.num_inputs = 8;
 
+	for (i = 0; i < WM5110_NUM_ADSP; i++) {
+		wm5110->core.adsp[i].part = "wm5110";
+		wm5110->core.adsp[i].num = i + 1;
+		wm5110->core.adsp[i].type = WMFW_ADSP2;
+		wm5110->core.adsp[i].dev = arizona->dev;
+		wm5110->core.adsp[i].regmap = arizona->regmap;
+
+		wm5110->core.adsp[i].base = ARIZONA_DSP1_CONTROL_1
+			+ (0x100 * i);
+		wm5110->core.adsp[i].mem = wm5110_dsp_regions[i];
+		wm5110->core.adsp[i].num_mems
+			= ARRAY_SIZE(wm5110_dsp1_regions);
+
+		ret = wm_adsp2_init(&wm5110->core.adsp[i], false);
+		if (ret != 0)
+			return ret;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(wm5110->fll); i++)
 		wm5110->fll[i].vco_mult = 3;
 
-- 
1.7.2.5

