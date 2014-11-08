Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaKHAjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:39:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaKHAjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:39:10 -0500
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>
Date: Sat, 08 Nov 2014 11:38:03 +1100
Subject: [PATCH 3/3] ASoC: twl4030: enable routing audio to 'voice'
 interface.
Cc: GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141108003803.6561.52497.stgit@notabene.brown>
In-Reply-To: <20141108002637.6561.19002.stgit@notabene.brown>
References: <20141108002637.6561.19002.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 'voice' is some external connection, we power up
the downlink when the downline amplifier is not muted,
and power up the uplink when a new switch "Voice Uplink" is
turned on.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 sound/soc/codecs/twl4030.c |   58 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 39b6d24377e5..f51fb749087f 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -348,9 +348,9 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 		 * tri-state until enabled */
 		twl4030_voice_set_codec_fmt(codec,
 					    twl4030->pdata->voice_fmt);
-		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
-				 TWL4030_VIF_TRI_EN,
-				 TWL4030_REG_VOICE_IF);
+		/* These pins only relevant when voice_fmt set */
+		snd_soc_dapm_disable_pin(&codec->dapm, "VOICEIN");
+		snd_soc_dapm_disable_pin(&codec->dapm, "VOICEOUT");
 	}
 
 	twl4030_codec_enable(codec, 0);
@@ -985,15 +985,17 @@ static int snd_soc_put_twl4030_opmode_enum_double(struct snd_kcontrol *kcontrol,
 		return -EBUSY;
 	}
 	if (twl4030->pdata->voice_fmt) {
-		/* There is no SND interface to voice, we need to control
-		 * it here.
-		 */
-		/* If 'val' then voice is disabled, so tri-state it as well */
-		snd_soc_update_bits(codec, TWL4030_REG_VOICE_IF,
-				    TWL4030_VIF_TRI_EN,
-				    val ? 0xff : 0);
+		if (val) {
+			/* Voice now disabled */
+			snd_soc_dapm_disable_pin(&codec->dapm, "VOICEIN");
+			snd_soc_dapm_disable_pin(&codec->dapm, "VOICEOUT");
+		} else {
+			/* Voice now enabled */
+			snd_soc_dapm_enable_pin(&codec->dapm, "VOICEIN");
+			snd_soc_dapm_enable_pin(&codec->dapm, "VOICEOUT");
+		}
+		snd_soc_dapm_sync(&codec->dapm);
 	}
-
 	return snd_soc_put_enum_double(kcontrol, ucontrol);
 }
 
@@ -1016,6 +1018,13 @@ static DECLARE_TLV_DB_SCALE(digital_coarse_tlv, 0, 600, 0);
  */
 static DECLARE_TLV_DB_SCALE(digital_voice_downlink_tlv, -3700, 100, 1);
 
+static const struct snd_kcontrol_new twl4030_dapm_vdown_control =
+	SOC_DAPM_SINGLE_TLV("Volume",
+			    TWL4030_REG_VRXPGA, 0, 0x31, 0,
+			    digital_voice_downlink_tlv);
+
+static const struct snd_kcontrol_new twl4030_dapm_vup_control =
+	SOC_DAPM_SINGLE("Switch", TWL4030_REG_VOICE_IF, 5, 1, 0);
 /*
  * Analog playback gain
  * -24 dB to 12 dB in 2 dB steps
@@ -1126,9 +1135,6 @@ static const struct snd_kcontrol_new twl4030_snd_controls[] = {
 		TWL4030_REG_ARXL2_APGA_CTL, TWL4030_REG_ARXR2_APGA_CTL,
 		1, 1, 0),
 
-	/* Common voice downlink gain controls */
-	SOC_SINGLE_TLV("DAC Voice Digital Downlink Volume",
-		TWL4030_REG_VRXPGA, 0, 0x31, 0, digital_voice_downlink_tlv),
 
 	SOC_SINGLE_TLV("DAC Voice Analog Downlink Volume",
 		TWL4030_REG_VDL_APGA_CTL, 3, 0x12, 1, analog_tlv),
@@ -1188,6 +1194,7 @@ static const struct snd_soc_dapm_widget twl4030_dapm_widgets[] = {
 	/* Digital microphones (Stereo) */
 	SND_SOC_DAPM_INPUT("DIGIMIC0"),
 	SND_SOC_DAPM_INPUT("DIGIMIC1"),
+	SND_SOC_DAPM_INPUT("VOICEIN"),
 
 	/* Outputs */
 	SND_SOC_DAPM_OUTPUT("EARPIECE"),
@@ -1200,6 +1207,7 @@ static const struct snd_soc_dapm_widget twl4030_dapm_widgets[] = {
 	SND_SOC_DAPM_OUTPUT("HFL"),
 	SND_SOC_DAPM_OUTPUT("HFR"),
 	SND_SOC_DAPM_OUTPUT("VIBRA"),
+	SND_SOC_DAPM_OUTPUT("VOICEOUT"),
 
 	/* AIF and APLL clocks for running DAIs (including loopback) */
 	SND_SOC_DAPM_OUTPUT("Virtual HiFi OUT"),
@@ -1216,6 +1224,10 @@ static const struct snd_soc_dapm_widget twl4030_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_IN("VAIFIN", "Voice Playback", 0,
 			    TWL4030_REG_VOICE_IF, 6, 0),
 
+	SND_SOC_DAPM_SUPPLY("VoiceEnable", TWL4030_REG_VOICE_IF, 6, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("VoicePlay", TWL4030_REG_OPTION, 4, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("VoiceCapture", TWL4030_REG_OPTION, 2, 0, NULL, 0),
+
 	/* Analog bypasses */
 	SND_SOC_DAPM_SWITCH("Right1 Analog Loopback", SND_SOC_NOPM, 0, 0,
 			&twl4030_dapm_abypassr1_control),
@@ -1395,9 +1407,27 @@ static const struct snd_soc_dapm_widget twl4030_dapm_widgets[] = {
 			    TWL4030_REG_MICBIAS_CTL, 2, 0, NULL, 0),
 
 	SND_SOC_DAPM_SUPPLY("VIF Enable", TWL4030_REG_VOICE_IF, 0, 0, NULL, 0),
+
+	SND_SOC_DAPM_SUPPLY("Voice NO-tri", TWL4030_REG_VOICE_IF, 2, 1, NULL, 0),
+
+	SND_SOC_DAPM_SWITCH("DAC Voice Digital Downlink", SND_SOC_NOPM,
+			    0, 0, &twl4030_dapm_vdown_control),
+	SND_SOC_DAPM_SWITCH("Voice Uplink", SND_SOC_NOPM,
+			    0, 0, &twl4030_dapm_vup_control),
 };
 
 static const struct snd_soc_dapm_route intercon[] = {
+	{"DAC Voice", NULL, "DAC Voice Digital Downlink"},
+	{"DAC Voice", NULL, "VoiceEnable"},
+	{"DAC Voice", NULL, "VoicePlay"},
+	{"DAC Voice Digital Downlink", "Volume", "VOICEIN"},
+
+	{"VOICEOUT", NULL, "Voice Uplink"},
+	{"VOICEOUT", NULL, "VoiceEnable"},
+	{"VOICEOUT", NULL, "VoiceCapture"},
+	{"VOICEOUT", NULL, "Voice NO-tri"},
+	{"Voice Uplink", "Switch", "TX2 Capture Route"},
+
 	/* Stream -> DAC mapping */
 	{"DAC Right1", NULL, "HiFi Playback"},
 	{"DAC Left1", NULL, "HiFi Playback"},


