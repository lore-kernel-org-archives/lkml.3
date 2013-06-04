Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3FDXVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:21:30 -0400
Received: from 1wt.eu ([62.212.114.60]:35268 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab3FDWlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:39 -0400
Message-Id: <20130604172132.011220773@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kailang Yang <kailang@realtek.com.tw>, Takashi Iwai <tiwai@suse.de>,
        Jonathan Nieder <jrnieder@gmail.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 041/184] ALSA: hda - More ALC663 fixes and support of
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 compatible chips

From: Kailang Yang <kailang@realtek.com.tw>

commit ebb83eeb6469bedda83b4dc6f23ddf93eb32b347 upstream.

1. Add more ASUS NB model.
2. Fixed alc663_m51va_setup
   M51VA has Digital Mic that NID is 0x12. The record source index is
   0x9 for ALC663.
   So, to modify the alc663_m51va_setup function to index 0x9
   and add analog Mic aupport function alc663_mode1_setup.
3. Add ASUS mode7 and mode8 modules for ALC663

[jn: backport to 2.6.32.y to address http://bugs.debian.org/688564]

Signed-off-by: Kailang Yang <kailang@realtek.com.tw>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Tested-by: Bill Allombert <Bill.Allombert@math.u-bordeaux1.fr> # Vaio w/ ALC275
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/pci/hda/patch_realtek.c | 306 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 282 insertions(+), 24 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6419095..06e7cc2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -131,8 +131,8 @@ enum {
 enum {
 	ALC269_BASIC,
 	ALC269_QUANTA_FL1,
-	ALC269_ASUS_EEEPC_P703,
-	ALC269_ASUS_EEEPC_P901,
+	ALC269_ASUS_AMIC,
+	ALC269_ASUS_DMIC,
 	ALC269_FUJITSU,
 	ALC269_LIFEBOOK,
 	ALC269_AUTO,
@@ -188,6 +188,8 @@ enum {
 	ALC663_ASUS_MODE4,
 	ALC663_ASUS_MODE5,
 	ALC663_ASUS_MODE6,
+	ALC663_ASUS_MODE7,
+	ALC663_ASUS_MODE8,
 	ALC272_DELL,
 	ALC272_DELL_ZM1,
 	ALC272_SAMSUNG_NC10,
@@ -13234,10 +13236,12 @@ static struct hda_verb alc269_eeepc_amic_init_verbs[] = {
 /* toggle speaker-output according to the hp-jack state */
 static void alc269_speaker_automute(struct hda_codec *codec)
 {
+	struct alc_spec *spec = codec->spec;
+	unsigned int nid = spec->autocfg.hp_pins[0];
 	unsigned int present;
 	unsigned char bits;
 
-	present = snd_hda_codec_read(codec, 0x15, 0,
+	present = snd_hda_codec_read(codec, nid, 0,
 				AC_VERB_GET_PIN_SENSE, 0) & 0x80000000;
 	bits = present ? AMP_IN_MUTE(0) : 0;
 	snd_hda_codec_amp_stereo(codec, 0x0c, HDA_INPUT, 0,
@@ -13463,8 +13467,8 @@ static void alc269_auto_init(struct hda_codec *codec)
 static const char *alc269_models[ALC269_MODEL_LAST] = {
 	[ALC269_BASIC]			= "basic",
 	[ALC269_QUANTA_FL1]		= "quanta",
-	[ALC269_ASUS_EEEPC_P703]	= "eeepc-p703",
-	[ALC269_ASUS_EEEPC_P901]	= "eeepc-p901",
+	[ALC269_ASUS_AMIC]		= "asus-amic",
+	[ALC269_ASUS_DMIC]		= "asus-dmic",
 	[ALC269_FUJITSU]		= "fujitsu",
 	[ALC269_LIFEBOOK]		= "lifebook",
 	[ALC269_AUTO]			= "auto",
@@ -13473,18 +13477,41 @@ static const char *alc269_models[ALC269_MODEL_LAST] = {
 static struct snd_pci_quirk alc269_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_QUANTA_FL1),
 	SND_PCI_QUIRK(0x1043, 0x8330, "ASUS Eeepc P703 P900A",
-		      ALC269_ASUS_EEEPC_P703),
-        SND_PCI_QUIRK(0x1043, 0x1883, "ASUS F81Se", ALC269_ASUS_EEEPC_P703),
-        SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS F5Q", ALC269_ASUS_EEEPC_P703),
-        SND_PCI_QUIRK(0x1043, 0x1723, "ASUS P80", ALC269_ASUS_EEEPC_P703),
-        SND_PCI_QUIRK(0x1043, 0x1773, "ASUS U20A", ALC269_ASUS_EEEPC_P703),
-        SND_PCI_QUIRK(0x1043, 0x1743, "ASUS U80", ALC269_ASUS_EEEPC_P703),
-        SND_PCI_QUIRK(0x1043, 0x1653, "ASUS U50", ALC269_ASUS_EEEPC_P703),
+		      ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1133, "ASUS UJ20ft", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1273, "ASUS UL80JT", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1283, "ASUS U53Jc", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x12b3, "ASUS N82Jv", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x13a3, "ASUS UL30Vt", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1373, "ASUS G73JX", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1383, "ASUS UJ30Jc", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x13d3, "ASUS N61JA", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1413, "ASUS UL50", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1443, "ASUS UL30", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1453, "ASUS M60Jv", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1483, "ASUS UL80", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x14f3, "ASUS F83Vf", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x14e3, "ASUS UL20", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1513, "ASUS UX30", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x15a3, "ASUS N60Jv", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x15b3, "ASUS N60Dp", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x15c3, "ASUS N70De", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x15e3, "ASUS F83T", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1643, "ASUS M60J", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1653, "ASUS U50", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1693, "ASUS F50N", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS F5Q", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_ASUS_DMIC),
+	SND_PCI_QUIRK(0x1043, 0x1723, "ASUS P80", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1743, "ASUS U80", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1773, "ASUS U20A", ALC269_ASUS_AMIC),
+	SND_PCI_QUIRK(0x1043, 0x1883, "ASUS F81Se", ALC269_ASUS_AMIC),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS Eeepc P901",
-		      ALC269_ASUS_EEEPC_P901),
+		      ALC269_ASUS_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS Eeepc S101",
-		      ALC269_ASUS_EEEPC_P901),
-        SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_ASUS_EEEPC_P901),
+		      ALC269_ASUS_DMIC),
+	SND_PCI_QUIRK(0x1043, 0x8398, "ASUS P1005HA", ALC269_ASUS_DMIC),
+	SND_PCI_QUIRK(0x1043, 0x83ce, "ASUS P1005HA", ALC269_ASUS_DMIC),
 	SND_PCI_QUIRK(0x1734, 0x115d, "FSC Amilo", ALC269_FUJITSU),
 	SND_PCI_QUIRK(0x10cf, 0x1475, "Lifebook ICH9M-based", ALC269_LIFEBOOK),
 	{}
@@ -13514,7 +13541,7 @@ static struct alc_config_preset alc269_presets[] = {
 		.setup = alc269_quanta_fl1_setup,
 		.init_hook = alc269_quanta_fl1_init_hook,
 	},
-	[ALC269_ASUS_EEEPC_P703] = {
+	[ALC269_ASUS_AMIC] = {
 		.mixers = { alc269_eeepc_mixer },
 		.cap_mixer = alc269_epc_capture_mixer,
 		.init_verbs = { alc269_init_verbs,
@@ -13528,7 +13555,7 @@ static struct alc_config_preset alc269_presets[] = {
 		.setup = alc269_eeepc_amic_setup,
 		.init_hook = alc269_eeepc_inithook,
 	},
-	[ALC269_ASUS_EEEPC_P901] = {
+	[ALC269_ASUS_DMIC] = {
 		.mixers = { alc269_eeepc_mixer },
 		.cap_mixer = alc269_epc_capture_mixer,
 		.init_verbs = { alc269_init_verbs,
@@ -16144,6 +16171,52 @@ static struct snd_kcontrol_new alc663_g50v_mixer[] = {
 	{ } /* end */
 };
 
+static struct hda_bind_ctls alc663_asus_mode7_8_all_bind_switch = {
+	.ops = &snd_hda_bind_sw,
+	.values = {
+		HDA_COMPOSE_AMP_VAL(0x14, 3, 0, HDA_OUTPUT),
+		HDA_COMPOSE_AMP_VAL(0x15, 3, 0, HDA_OUTPUT),
+		HDA_COMPOSE_AMP_VAL(0x17, 3, 0, HDA_OUTPUT),
+		HDA_COMPOSE_AMP_VAL(0x1b, 3, 0, HDA_OUTPUT),
+		HDA_COMPOSE_AMP_VAL(0x21, 3, 0, HDA_OUTPUT),
+		0
+	},
+};
+
+static struct hda_bind_ctls alc663_asus_mode7_8_sp_bind_switch = {
+	.ops = &snd_hda_bind_sw,
+	.values = {
+		HDA_COMPOSE_AMP_VAL(0x14, 3, 0, HDA_OUTPUT),
+		HDA_COMPOSE_AMP_VAL(0x17, 3, 0, HDA_OUTPUT),
+		0
+	},
+};
+
+static struct snd_kcontrol_new alc663_mode7_mixer[] = {
+	HDA_BIND_SW("Master Playback Switch", &alc663_asus_mode7_8_all_bind_switch),
+	HDA_BIND_VOL("Speaker Playback Volume", &alc663_asus_bind_master_vol),
+	HDA_BIND_SW("Speaker Playback Switch", &alc663_asus_mode7_8_sp_bind_switch),
+	HDA_CODEC_MUTE("Headphone1 Playback Switch", 0x1b, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Headphone2 Playback Switch", 0x21, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("IntMic Playback Volume", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE("IntMic Playback Switch", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x1, HDA_INPUT),
+	HDA_CODEC_MUTE("Mic Playback Switch", 0x0b, 0x1, HDA_INPUT),
+	{ } /* end */
+};
+
+static struct snd_kcontrol_new alc663_mode8_mixer[] = {
+	HDA_BIND_SW("Master Playback Switch", &alc663_asus_mode7_8_all_bind_switch),
+	HDA_BIND_VOL("Speaker Playback Volume", &alc663_asus_bind_master_vol),
+	HDA_BIND_SW("Speaker Playback Switch", &alc663_asus_mode7_8_sp_bind_switch),
+	HDA_CODEC_MUTE("Headphone1 Playback Switch", 0x15, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Headphone2 Playback Switch", 0x21, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE("Mic Playback Switch", 0x0b, 0x0, HDA_INPUT),
+	{ } /* end */
+};
+
+
 static struct snd_kcontrol_new alc662_chmode_mixer[] = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -16431,6 +16504,45 @@ static struct hda_verb alc272_dell_init_verbs[] = {
 	{}
 };
 
+static struct hda_verb alc663_mode7_init_verbs[] = {
+	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
+	{0x16, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
+	{0x17, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
+	{0x1b, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x1b, AC_VERB_SET_CONNECT_SEL, 0x01},
+	{0x21, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
+	{0x21, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x21, AC_VERB_SET_CONNECT_SEL, 0x01},	/* Headphone */
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(9)},
+	{0x19, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_MIC_EVENT},
+	{0x1b, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_HP_EVENT},
+	{0x21, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_HP_EVENT},
+	{}
+};
+
+static struct hda_verb alc663_mode8_init_verbs[] = {
+	{0x12, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
+	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
+	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x15, AC_VERB_SET_CONNECT_SEL, 0x01},
+	{0x16, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
+	{0x17, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+	{0x17, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_IN},
+	{0x21, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
+	{0x21, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x21, AC_VERB_SET_CONNECT_SEL, 0x01},	/* Headphone */
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(0)},
+	{0x22, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(9)},
+	{0x15, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_HP_EVENT},
+	{0x18, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_MIC_EVENT},
+	{0x21, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_HP_EVENT},
+	{}
+};
+
 static struct snd_kcontrol_new alc662_auto_capture_mixer[] = {
 	HDA_CODEC_VOLUME("Capture Volume", 0x09, 0x0, HDA_INPUT),
 	HDA_CODEC_MUTE("Capture Switch", 0x09, 0x0, HDA_INPUT),
@@ -16626,6 +16738,54 @@ static void alc663_two_hp_m2_speaker_automute(struct hda_codec *codec)
 	}
 }
 
+static void alc663_two_hp_m7_speaker_automute(struct hda_codec *codec)
+{
+	unsigned int present1, present2;
+
+	present1 = snd_hda_codec_read(codec, 0x1b, 0,
+			AC_VERB_GET_PIN_SENSE, 0)
+			& AC_PINSENSE_PRESENCE;
+	present2 = snd_hda_codec_read(codec, 0x21, 0,
+			AC_VERB_GET_PIN_SENSE, 0)
+			& AC_PINSENSE_PRESENCE;
+
+	if (present1 || present2) {
+		snd_hda_codec_write_cache(codec, 0x14, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+		snd_hda_codec_write_cache(codec, 0x17, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+	} else {
+		snd_hda_codec_write_cache(codec, 0x14, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		snd_hda_codec_write_cache(codec, 0x17, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+	}
+}
+
+static void alc663_two_hp_m8_speaker_automute(struct hda_codec *codec)
+{
+	unsigned int present1, present2;
+
+	present1 = snd_hda_codec_read(codec, 0x21, 0,
+			AC_VERB_GET_PIN_SENSE, 0)
+			& AC_PINSENSE_PRESENCE;
+	present2 = snd_hda_codec_read(codec, 0x15, 0,
+			AC_VERB_GET_PIN_SENSE, 0)
+			& AC_PINSENSE_PRESENCE;
+
+	if (present1 || present2) {
+		snd_hda_codec_write_cache(codec, 0x14, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+		snd_hda_codec_write_cache(codec, 0x17, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+	} else {
+		snd_hda_codec_write_cache(codec, 0x14, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+		snd_hda_codec_write_cache(codec, 0x17, 0,
+			AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+	}
+}
+
 static void alc663_m51va_unsol_event(struct hda_codec *codec,
 					   unsigned int res)
 {
@@ -16645,7 +16805,7 @@ static void alc663_m51va_setup(struct hda_codec *codec)
 	spec->ext_mic.pin = 0x18;
 	spec->ext_mic.mux_idx = 0;
 	spec->int_mic.pin = 0x12;
-	spec->int_mic.mux_idx = 1;
+	spec->int_mic.mux_idx = 9;
 	spec->auto_mic = 1;
 }
 
@@ -16657,7 +16817,17 @@ static void alc663_m51va_inithook(struct hda_codec *codec)
 
 /* ***************** Mode1 ******************************/
 #define alc663_mode1_unsol_event	alc663_m51va_unsol_event
-#define alc663_mode1_setup		alc663_m51va_setup
+
+static void alc663_mode1_setup(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+	spec->ext_mic.pin = 0x18;
+	spec->ext_mic.mux_idx = 0;
+	spec->int_mic.pin = 0x19;
+	spec->int_mic.mux_idx = 1;
+	spec->auto_mic = 1;
+}
+
 #define alc663_mode1_inithook		alc663_m51va_inithook
 
 /* ***************** Mode2 ******************************/
@@ -16674,7 +16844,7 @@ static void alc662_mode2_unsol_event(struct hda_codec *codec,
 	}
 }
 
-#define alc662_mode2_setup	alc663_m51va_setup
+#define alc662_mode2_setup	alc663_mode1_setup
 
 static void alc662_mode2_inithook(struct hda_codec *codec)
 {
@@ -16695,7 +16865,7 @@ static void alc663_mode3_unsol_event(struct hda_codec *codec,
 	}
 }
 
-#define alc663_mode3_setup	alc663_m51va_setup
+#define alc663_mode3_setup	alc663_mode1_setup
 
 static void alc663_mode3_inithook(struct hda_codec *codec)
 {
@@ -16716,7 +16886,7 @@ static void alc663_mode4_unsol_event(struct hda_codec *codec,
 	}
 }
 
-#define alc663_mode4_setup	alc663_m51va_setup
+#define alc663_mode4_setup	alc663_mode1_setup
 
 static void alc663_mode4_inithook(struct hda_codec *codec)
 {
@@ -16737,7 +16907,7 @@ static void alc663_mode5_unsol_event(struct hda_codec *codec,
 	}
 }
 
-#define alc663_mode5_setup	alc663_m51va_setup
+#define alc663_mode5_setup	alc663_mode1_setup
 
 static void alc663_mode5_inithook(struct hda_codec *codec)
 {
@@ -16758,7 +16928,7 @@ static void alc663_mode6_unsol_event(struct hda_codec *codec,
 	}
 }
 
-#define alc663_mode6_setup	alc663_m51va_setup
+#define alc663_mode6_setup	alc663_mode1_setup
 
 static void alc663_mode6_inithook(struct hda_codec *codec)
 {
@@ -16766,6 +16936,50 @@ static void alc663_mode6_inithook(struct hda_codec *codec)
 	alc_mic_automute(codec);
 }
 
+/* ***************** Mode7 ******************************/
+static void alc663_mode7_unsol_event(struct hda_codec *codec,
+					   unsigned int res)
+{
+	switch (res >> 26) {
+	case ALC880_HP_EVENT:
+		alc663_two_hp_m7_speaker_automute(codec);
+		break;
+	case ALC880_MIC_EVENT:
+		alc_mic_automute(codec);
+		break;
+	}
+}
+
+#define alc663_mode7_setup	alc663_mode1_setup
+
+static void alc663_mode7_inithook(struct hda_codec *codec)
+{
+	alc663_two_hp_m7_speaker_automute(codec);
+	alc_mic_automute(codec);
+}
+
+/* ***************** Mode8 ******************************/
+static void alc663_mode8_unsol_event(struct hda_codec *codec,
+					   unsigned int res)
+{
+	switch (res >> 26) {
+	case ALC880_HP_EVENT:
+		alc663_two_hp_m8_speaker_automute(codec);
+		break;
+	case ALC880_MIC_EVENT:
+		alc_mic_automute(codec);
+		break;
+	}
+}
+
+#define alc663_mode8_setup	alc663_m51va_setup
+
+static void alc663_mode8_inithook(struct hda_codec *codec)
+{
+	alc663_two_hp_m8_speaker_automute(codec);
+	alc_mic_automute(codec);
+}
+
 static void alc663_g71v_hp_automute(struct hda_codec *codec)
 {
 	unsigned int present;
@@ -16904,6 +17118,8 @@ static const char *alc662_models[ALC662_MODEL_LAST] = {
 	[ALC663_ASUS_MODE4] = "asus-mode4",
 	[ALC663_ASUS_MODE5] = "asus-mode5",
 	[ALC663_ASUS_MODE6] = "asus-mode6",
+	[ALC663_ASUS_MODE7] = "asus-mode7",
+	[ALC663_ASUS_MODE8] = "asus-mode8",
 	[ALC272_DELL]		= "dell",
 	[ALC272_DELL_ZM1]	= "dell-zm1",
 	[ALC272_SAMSUNG_NC10]	= "samsung-nc10",
@@ -16920,12 +17136,22 @@ static struct snd_pci_quirk alc662_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x11d3, "ASUS NB", ALC663_ASUS_MODE1),
 	SND_PCI_QUIRK(0x1043, 0x11f3, "ASUS NB", ALC662_ASUS_MODE2),
 	SND_PCI_QUIRK(0x1043, 0x1203, "ASUS NB", ALC663_ASUS_MODE1),
+	SND_PCI_QUIRK(0x1043, 0x1303, "ASUS G60J", ALC663_ASUS_MODE1),
+	SND_PCI_QUIRK(0x1043, 0x1333, "ASUS G60Jx", ALC663_ASUS_MODE1),
 	SND_PCI_QUIRK(0x1043, 0x1339, "ASUS NB", ALC662_ASUS_MODE2),
+	SND_PCI_QUIRK(0x1043, 0x13e3, "ASUS N71JA", ALC663_ASUS_MODE7),
+	SND_PCI_QUIRK(0x1043, 0x1463, "ASUS N71", ALC663_ASUS_MODE7),
+	SND_PCI_QUIRK(0x1043, 0x14d3, "ASUS G72", ALC663_ASUS_MODE8),
+	SND_PCI_QUIRK(0x1043, 0x1563, "ASUS N90", ALC663_ASUS_MODE3),
+	SND_PCI_QUIRK(0x1043, 0x15d3, "ASUS N50SF F50SF", ALC663_ASUS_MODE1),
 	SND_PCI_QUIRK(0x1043, 0x16c3, "ASUS NB", ALC662_ASUS_MODE2),
+	SND_PCI_QUIRK(0x1043, 0x16f3, "ASUS K40C K50C", ALC662_ASUS_MODE2),
+	SND_PCI_QUIRK(0x1043, 0x1733, "ASUS N81De", ALC663_ASUS_MODE1),
 	SND_PCI_QUIRK(0x1043, 0x1753, "ASUS NB", ALC662_ASUS_MODE2),
 	SND_PCI_QUIRK(0x1043, 0x1763, "ASUS NB", ALC663_ASUS_MODE6),
 	SND_PCI_QUIRK(0x1043, 0x1765, "ASUS NB", ALC663_ASUS_MODE6),
 	SND_PCI_QUIRK(0x1043, 0x1783, "ASUS NB", ALC662_ASUS_MODE2),
+	SND_PCI_QUIRK(0x1043, 0x1793, "ASUS F50GX", ALC663_ASUS_MODE1),
 	SND_PCI_QUIRK(0x1043, 0x17b3, "ASUS F70SL", ALC663_ASUS_MODE3),
 	SND_PCI_QUIRK(0x1043, 0x17c3, "ASUS UX20", ALC663_ASUS_M51VA),
 	SND_PCI_QUIRK(0x1043, 0x17f3, "ASUS X58LE", ALC662_ASUS_MODE2),
@@ -17208,6 +17434,36 @@ static struct alc_config_preset alc662_presets[] = {
 		.setup = alc663_mode6_setup,
 		.init_hook = alc663_mode6_inithook,
 	},
+	[ALC663_ASUS_MODE7] = {
+		.mixers = { alc663_mode7_mixer },
+		.cap_mixer = alc662_auto_capture_mixer,
+		.init_verbs = { alc662_init_verbs,
+				alc663_mode7_init_verbs },
+		.num_dacs = ARRAY_SIZE(alc662_dac_nids),
+		.hp_nid = 0x03,
+		.dac_nids = alc662_dac_nids,
+		.dig_out_nid = ALC662_DIGOUT_NID,
+		.num_channel_mode = ARRAY_SIZE(alc662_3ST_2ch_modes),
+		.channel_mode = alc662_3ST_2ch_modes,
+		.unsol_event = alc663_mode7_unsol_event,
+		.setup = alc663_mode7_setup,
+		.init_hook = alc663_mode7_inithook,
+	},
+	[ALC663_ASUS_MODE8] = {
+		.mixers = { alc663_mode8_mixer },
+		.cap_mixer = alc662_auto_capture_mixer,
+		.init_verbs = { alc662_init_verbs,
+				alc663_mode8_init_verbs },
+		.num_dacs = ARRAY_SIZE(alc662_dac_nids),
+		.hp_nid = 0x03,
+		.dac_nids = alc662_dac_nids,
+		.dig_out_nid = ALC662_DIGOUT_NID,
+		.num_channel_mode = ARRAY_SIZE(alc662_3ST_2ch_modes),
+		.channel_mode = alc662_3ST_2ch_modes,
+		.unsol_event = alc663_mode8_unsol_event,
+		.setup = alc663_mode8_setup,
+		.init_hook = alc663_mode8_inithook,
+	},
 	[ALC272_DELL] = {
 		.mixers = { alc663_m51va_mixer },
 		.cap_mixer = alc272_auto_capture_mixer,
@@ -17676,7 +17932,9 @@ static struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },
 	{ .id = 0x10ec0268, .name = "ALC268", .patch = patch_alc268 },
 	{ .id = 0x10ec0269, .name = "ALC269", .patch = patch_alc269 },
+	{ .id = 0x10ec0270, .name = "ALC270", .patch = patch_alc269 },
 	{ .id = 0x10ec0272, .name = "ALC272", .patch = patch_alc662 },
+	{ .id = 0x10ec0275, .name = "ALC275", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
 	  .patch = patch_alc861 },
 	{ .id = 0x10ec0660, .name = "ALC660-VD", .patch = patch_alc861vd },
-- 
1.7.12.2.21.g234cd45.dirty



