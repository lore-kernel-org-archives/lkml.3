Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab3EORsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:48:42 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:38696 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806Ab3EORsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:48:40 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Ralph Birt <ralph.birt@maximintegrated.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jerry Wong <jerry.wong@maximintegrated.com>,
        Evan Ragsdale <evan.ragsdale@maximintegrated.com>,
        Dylan Reid <dgreid@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] ASoC: max98090: add digital mic mux to record path
Date: Wed, 15 May 2013 10:48:32 -0700
Message-Id: <1368640112-1417-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max98090 driver currently treats the digital mic enable as a supply
on the record path, causing the digital mic enable to always be turned on
when attempting to record.  This is incorrect, however, since the digital
mic enable is actually a mux control where 0 selects the ADC output as
input to the record-path DSP and 1 selects the digital mic.  This patch
converts the DMIC{L,R}_ENA supplies into DMIC{L,R} muxes so that we can
switch between the ADC and the digital mic for recording.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 sound/soc/codecs/max98090.c | 45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index ce0d364..71b6b8a 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -857,6 +857,22 @@ static const struct soc_enum mic2_mux_enum =
 static const struct snd_kcontrol_new max98090_mic2_mux =
 	SOC_DAPM_ENUM("MIC2 Mux", mic2_mux_enum);
 
+static const char *dmic_mux_text[] = { "ADC", "DMIC" };
+
+static const struct soc_enum dmicl_mux_enum =
+	SOC_ENUM_SINGLE(M98090_REG_DIGITAL_MIC_ENABLE, M98090_DIGMICL_SHIFT,
+		ARRAY_SIZE(dmic_mux_text), dmic_mux_text);
+
+static const struct snd_kcontrol_new max98090_dmicl_mux =
+	SOC_DAPM_ENUM("DMICL Mux", dmicl_mux_enum);
+
+static const struct soc_enum dmicr_mux_enum =
+	SOC_ENUM_SINGLE(M98090_REG_DIGITAL_MIC_ENABLE, M98090_DIGMICR_SHIFT,
+		ARRAY_SIZE(dmic_mux_text), dmic_mux_text);
+
+static const struct snd_kcontrol_new max98090_dmicr_mux =
+	SOC_DAPM_ENUM("DMICR Mux", dmicr_mux_enum);
+
 static const char *max98090_micpre_text[] = { "Off", "On" };
 
 static const struct soc_enum max98090_pa1en_enum =
@@ -1127,10 +1143,6 @@ static const struct snd_soc_dapm_widget max98090_dapm_widgets[] = {
 		M98090_SDIEN_SHIFT, 0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("SDOEN", M98090_REG_IO_CONFIGURATION,
 		M98090_SDOEN_SHIFT, 0, NULL, 0),
-	SND_SOC_DAPM_SUPPLY("DMICL_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
-		 M98090_DIGMICL_SHIFT, 0, NULL, 0),
-	SND_SOC_DAPM_SUPPLY("DMICR_ENA", M98090_REG_DIGITAL_MIC_ENABLE,
-		 M98090_DIGMICR_SHIFT, 0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("AHPF", M98090_REG_FILTER_CONFIG,
 		M98090_AHPF_SHIFT, 0, NULL, 0),
 
@@ -1144,6 +1156,12 @@ static const struct snd_soc_dapm_widget max98090_dapm_widgets[] = {
 	SND_SOC_DAPM_MUX("MIC2 Mux", SND_SOC_NOPM,
 		0, 0, &max98090_mic2_mux),
 
+	SND_SOC_DAPM_MUX("DMICL Mux", SND_SOC_NOPM,
+		0, 0, &max98090_dmicl_mux),
+
+	SND_SOC_DAPM_MUX("DMICR Mux", SND_SOC_NOPM,
+		0, 0, &max98090_dmicr_mux),
+
 	SND_SOC_DAPM_PGA_E("MIC1 Input", M98090_REG_MIC1_INPUT_LEVEL,
 		M98090_MIC_PA1EN_SHIFT, 0, NULL, 0, max98090_micinput_event,
 		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
@@ -1281,8 +1299,6 @@ static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
 	{"MIC1 Input", NULL, "MIC1"},
 	{"MIC2 Input", NULL, "MIC2"},
 
-	{"DMICL", NULL, "DMICL_ENA"},
-	{"DMICR", NULL, "DMICR_ENA"},
 	{"DMICL", NULL, "AHPF"},
 	{"DMICR", NULL, "AHPF"},
 
@@ -1336,11 +1352,14 @@ static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
 	{"ADCL", NULL, "SHDN"},
 	{"ADCR", NULL, "SHDN"},
 
-	{"LBENL Mux", "Normal", "ADCL"},
-	{"LBENL Mux", "Normal", "DMICL"},
+	{"DMICL Mux", "ADC", "ADCL"},
+	{"DMICL Mux", "DMIC", "DMICL"},
+	{"DMICR Mux", "ADC", "ADCR"},
+	{"DMICR Mux", "DMIC", "DMICR"},
+
+	{"LBENL Mux", "Normal", "DMICL Mux"},
 	{"LBENL Mux", "Loopback", "LTENL Mux"},
-	{"LBENR Mux", "Normal", "ADCR"},
-	{"LBENR Mux", "Normal", "DMICR"},
+	{"LBENR Mux", "Normal", "DMICR Mux"},
 	{"LBENR Mux", "Loopback", "LTENR Mux"},
 
 	{"AIFOUTL", NULL, "LBENL Mux"},
@@ -1358,10 +1377,8 @@ static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
 	{"DACL", NULL, "LTENL Mux"},
 	{"DACR", NULL, "LTENR Mux"},
 
-	{"STENL Mux", "Sidetone Left", "ADCL"},
-	{"STENL Mux", "Sidetone Left", "DMICL"},
-	{"STENR Mux", "Sidetone Right", "ADCR"},
-	{"STENR Mux", "Sidetone Right", "DMICR"},
+	{"STENL Mux", "Sidetone Left", "DMICL Mux"},
+	{"STENR Mux", "Sidetone Right", "DMICR Mux"},
 	{"DACL", "NULL", "STENL Mux"},
 	{"DACR", "NULL", "STENL Mux"},
 
-- 
1.8.2.1

