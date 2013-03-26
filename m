Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584Ab3CZPkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:40:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49967 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965170Ab3CZPkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:40:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] ASoC: arizona: Fix interaction between headphone outputs and identification
Date: Tue, 26 Mar 2013 15:40:32 +0000
Message-Id: <1364312433-589-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364312433-589-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130326154014.GD18316@opensource.wolfsonmicro.com>
 <1364312433-589-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running HPDET while the headphone outputs are enabled can disrupt the
operation of HPDET. In order to avoid this HPDET needs to disable the
headphone outputs and ASoC needs to not enable them while HPDET is
running.

Do the ASoC side of this by storing the enable state in the core driver
structure and only writing to the device if a flag indicating that the
accessory detection side is in a state where it can have the headphone
output stage enabled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/arizona/core.h |    3 +++
 sound/soc/codecs/arizona.c       |   33 +++++++++++++++++++++++++++++++++
 sound/soc/codecs/arizona.h       |    3 +++
 sound/soc/codecs/wm5102.c        |    8 ++++----
 sound/soc/codecs/wm5110.c        |    8 ++++----
 5 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index a710255..cc28136 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -100,6 +100,9 @@ struct arizona {
 	struct regmap_irq_chip_data *aod_irq_chip;
 	struct regmap_irq_chip_data *irq_chip;
 
+	bool hpdet_magic;
+	unsigned int hp_ena;
+
 	struct mutex clk_lock;
 	int clk32k_ref;
 
diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index ac948a6..35da804 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -364,6 +364,39 @@ int arizona_out_ev(struct snd_soc_dapm_widget *w,
 }
 EXPORT_SYMBOL_GPL(arizona_out_ev);
 
+int arizona_hp_ev(struct snd_soc_dapm_widget *w,
+		   struct snd_kcontrol *kcontrol,
+		   int event)
+{
+	struct arizona_priv *priv = snd_soc_codec_get_drvdata(w->codec);
+	unsigned int mask = 1 << w->shift;
+	unsigned int val;
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+		val = mask;
+		break;
+	case SND_SOC_DAPM_PRE_PMD:
+		val = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Store the desired state for the HP outputs */
+	priv->arizona->hp_ena &= ~mask;
+	priv->arizona->hp_ena |= val;
+
+	/* Force off if HPDET magic is active */
+	if (priv->arizona->hpdet_magic)
+		val = 0;
+
+	snd_soc_update_bits(w->codec, ARIZONA_OUTPUT_ENABLES_1, mask, val);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(arizona_hp_ev);
+
 static unsigned int arizona_sysclk_48k_rates[] = {
 	6144000,
 	12288000,
diff --git a/sound/soc/codecs/arizona.h b/sound/soc/codecs/arizona.h
index 116372c..13dd291 100644
--- a/sound/soc/codecs/arizona.h
+++ b/sound/soc/codecs/arizona.h
@@ -184,6 +184,9 @@ extern int arizona_in_ev(struct snd_soc_dapm_widget *w,
 extern int arizona_out_ev(struct snd_soc_dapm_widget *w,
 			  struct snd_kcontrol *kcontrol,
 			  int event);
+extern int arizona_hp_ev(struct snd_soc_dapm_widget *w,
+			 struct snd_kcontrol *kcontrol,
+			 int event);
 
 extern int arizona_set_sysclk(struct snd_soc_codec *codec, int clk_id,
 			      int source, unsigned int freq, int dir);
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index b82bbf58..2657aad 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -1131,11 +1131,11 @@ ARIZONA_DSP_WIDGETS(DSP1, "DSP1"),
 SND_SOC_DAPM_VALUE_MUX("AEC Loopback", ARIZONA_DAC_AEC_CONTROL_1,
 		       ARIZONA_AEC_LOOPBACK_ENA, 0, &wm5102_aec_loopback_mux),
 
-SND_SOC_DAPM_PGA_E("OUT1L", ARIZONA_OUTPUT_ENABLES_1,
-		   ARIZONA_OUT1L_ENA_SHIFT, 0, NULL, 0, arizona_out_ev,
+SND_SOC_DAPM_PGA_E("OUT1L", SND_SOC_NOPM,
+		   ARIZONA_OUT1L_ENA_SHIFT, 0, NULL, 0, arizona_hp_ev,
 		   SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMU),
-SND_SOC_DAPM_PGA_E("OUT1R", ARIZONA_OUTPUT_ENABLES_1,
-		   ARIZONA_OUT1R_ENA_SHIFT, 0, NULL, 0, arizona_out_ev,
+SND_SOC_DAPM_PGA_E("OUT1R", SND_SOC_NOPM,
+		   ARIZONA_OUT1R_ENA_SHIFT, 0, NULL, 0, arizona_hp_ev,
 		   SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMU),
 SND_SOC_DAPM_PGA_E("OUT2L", ARIZONA_OUTPUT_ENABLES_1,
 		   ARIZONA_OUT2L_ENA_SHIFT, 0, NULL, 0, arizona_out_ev,
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index cdeb301..7841b42 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -551,11 +551,11 @@ SND_SOC_DAPM_AIF_IN("AIF3RX1", NULL, 0,
 SND_SOC_DAPM_AIF_IN("AIF3RX2", NULL, 0,
 		    ARIZONA_AIF3_RX_ENABLES, ARIZONA_AIF3RX2_ENA_SHIFT, 0),
 
-SND_SOC_DAPM_PGA_E("OUT1L", ARIZONA_OUTPUT_ENABLES_1,
-		   ARIZONA_OUT1L_ENA_SHIFT, 0, NULL, 0, arizona_out_ev,
+SND_SOC_DAPM_PGA_E("OUT1L", SND_SOC_NOPM,
+		   ARIZONA_OUT1L_ENA_SHIFT, 0, NULL, 0, arizona_hp_ev,
 		   SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMU),
-SND_SOC_DAPM_PGA_E("OUT1R", ARIZONA_OUTPUT_ENABLES_1,
-		   ARIZONA_OUT1R_ENA_SHIFT, 0, NULL, 0, arizona_out_ev,
+SND_SOC_DAPM_PGA_E("OUT1R", SND_SOC_NOPM,
+		   ARIZONA_OUT1R_ENA_SHIFT, 0, NULL, 0, arizona_hp_ev,
 		   SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMU),
 SND_SOC_DAPM_PGA_E("OUT2L", ARIZONA_OUTPUT_ENABLES_1,
 		   ARIZONA_OUT2L_ENA_SHIFT, 0, NULL, 0, arizona_out_ev,
-- 
1.7.10.4

