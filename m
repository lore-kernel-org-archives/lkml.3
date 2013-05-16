Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3EPTD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:03:59 -0400
Received: from mail-gg0-f201.google.com ([209.85.161.201]:37103 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3EPTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:03:58 -0400
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
        Matthew Mowdy <Matthew.Mowdy@maximintegrated.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2] ASoC: max98090: add digital mic mux to record path
Date: Thu, 16 May 2013 12:03:54 -0700
Message-Id: <1368731034-30135-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20130516175241.GF1627@sirena.org.uk>
References: <20130516175241.GF1627@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max98090 driver currently treats the digital mic enable as a supply
on the record path, causing the digital mic enable to always be turned on
when attempting to record.  This is incorrect, however, since the digital
mic enable is also a mux control where 0 selects the ADC output as input
to the record-path DSP and 1 selects the digital mic.  This patch adds
a virtual DMIC mux to the reocrd path so that we can switch between the
ADC and the digital mic for recording.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 sound/soc/codecs/max98090.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index ce0d364..cbb272b 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -857,6 +857,14 @@ static const struct soc_enum mic2_mux_enum =
 static const struct snd_kcontrol_new max98090_mic2_mux =
 	SOC_DAPM_ENUM("MIC2 Mux", mic2_mux_enum);
 
+static const char *dmic_mux_text[] = { "ADC", "DMIC" };
+
+static const struct soc_enum dmic_mux_enum =
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(dmic_mux_text), dmic_mux_text);
+
+static const struct snd_kcontrol_new max98090_dmic_mux =
+	SOC_DAPM_ENUM_VIRT("DMIC Mux", dmic_mux_enum);
+
 static const char *max98090_micpre_text[] = { "Off", "On" };
 
 static const struct soc_enum max98090_pa1en_enum =
@@ -1144,6 +1152,9 @@ static const struct snd_soc_dapm_widget max98090_dapm_widgets[] = {
 	SND_SOC_DAPM_MUX("MIC2 Mux", SND_SOC_NOPM,
 		0, 0, &max98090_mic2_mux),
 
+	SND_SOC_DAPM_VIRT_MUX("DMIC Mux", SND_SOC_NOPM,
+		0, 0, &max98090_dmic_mux),
+
 	SND_SOC_DAPM_PGA_E("MIC1 Input", M98090_REG_MIC1_INPUT_LEVEL,
 		M98090_MIC_PA1EN_SHIFT, 0, NULL, 0, max98090_micinput_event,
 		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
@@ -1336,11 +1347,14 @@ static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
 	{"ADCL", NULL, "SHDN"},
 	{"ADCR", NULL, "SHDN"},
 
-	{"LBENL Mux", "Normal", "ADCL"},
-	{"LBENL Mux", "Normal", "DMICL"},
+	{"DMIC Mux", "ADC", "ADCL"},
+	{"DMIC Mux", "ADC", "ADCR"},
+	{"DMIC Mux", "DMIC", "DMICL"},
+	{"DMIC Mux", "DMIC", "DMICR"},
+
+	{"LBENL Mux", "Normal", "DMIC Mux"},
 	{"LBENL Mux", "Loopback", "LTENL Mux"},
-	{"LBENR Mux", "Normal", "ADCR"},
-	{"LBENR Mux", "Normal", "DMICR"},
+	{"LBENR Mux", "Normal", "DMIC Mux"},
 	{"LBENR Mux", "Loopback", "LTENR Mux"},
 
 	{"AIFOUTL", NULL, "LBENL Mux"},
-- 
1.8.2.1

