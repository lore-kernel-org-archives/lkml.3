Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619Ab3DGXzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:55:08 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:56514 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511Ab3DGXzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:55:06 -0400
From: Dan Savilonis <djs@n-cube.org>
To: Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, perex@perex.cz,
        Dan Savilonis <djs@n-cube.org>
Subject: [PATCH] ALSA: hda: fix mute led on HP Envy 15
Date: Sun,  7 Apr 2013 19:54:22 -0400
Message-Id: <1365378862-10296-1-git-send-email-djs@n-cube.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This laptop reports the string HP_Mute_LED_P_G in DMI, but the guess made in
hp_set_mute_led() is wrong. So, hard-code the GPIO id.

Signed-off-by: Dan Savilonis <djs@n-cube.org>
---
 sound/pci/hda/patch_sigmatel.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 1d9d642..3a6b111 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -100,6 +100,7 @@ enum {
 	STAC_92HD83XXX_HEADSET_JACK,
 	STAC_92HD83XXX_HP,
 	STAC_HP_ENVY_BASS,
+	STAC_HP_ENVY_15,
 	STAC_92HD83XXX_MODELS
 };
 
@@ -2092,6 +2093,15 @@ static void stac92hd83xxx_fixup_hp_mic_led(struct hda_codec *codec,
 		spec->mic_mute_led_gpio = 0x08; /* GPIO3 */
 }
 
+static void stac92hd83xxx_fixup_hp_envy_15(struct hda_codec *codec,
+				   const struct hda_fixup *fix, int action)
+{
+	struct sigmatel_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->gpio_led = 0x01; /* GPIO0 */
+}
+
 static void stac92hd83xxx_fixup_headset_jack(struct hda_codec *codec,
 				   const struct hda_fixup *fix, int action)
 {
@@ -2101,6 +2111,7 @@ static void stac92hd83xxx_fixup_headset_jack(struct hda_codec *codec,
 		spec->headset_jack = 1;
 }
 
+
 static const struct hda_fixup stac92hd83xxx_fixups[] = {
 	[STAC_92HD83XXX_REF] = {
 		.type = HDA_FIXUP_PINS,
@@ -2169,6 +2180,12 @@ static const struct hda_fixup stac92hd83xxx_fixups[] = {
 			{}
 		},
 	},
+	[STAC_HP_ENVY_15] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = stac92hd83xxx_fixup_hp_envy_15,
+		.chained = true,
+		.chain_id = STAC_92HD83XXX_HP,
+	},
 };
 
 static const struct hda_model_fixup stac92hd83xxx_models[] = {
@@ -2184,6 +2201,7 @@ static const struct hda_model_fixup stac92hd83xxx_models[] = {
 	{ .id = STAC_92HD83XXX_HP_MIC_LED, .name = "hp-mic-led" },
 	{ .id = STAC_92HD83XXX_HEADSET_JACK, .name = "headset-jack" },
 	{ .id = STAC_HP_ENVY_BASS, .name = "hp-envy-bass" },
+	{ .id = STAC_HP_ENVY_15, .name = "hp-envy-15" },
 	{}
 };
 
@@ -2269,6 +2287,8 @@ static const struct snd_pci_quirk stac92hd83xxx_fixup_tbl[] = {
 			  "HP Pavilion dv5", STAC_92HD83XXX_HP_INV_LED),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x148a,
 		      "HP Mini", STAC_92HD83XXX_HP_LED),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1688,
+			  "HP Envy 15", STAC_HP_ENVY_15),
 	SND_PCI_QUIRK_VENDOR(PCI_VENDOR_ID_HP, "HP", STAC_92HD83XXX_HP),
 	{} /* terminator */
 };
@@ -3968,6 +3988,7 @@ static int patch_stac92hd83xxx(struct hda_codec *codec)
 
 	snd_hda_add_verbs(codec, stac92hd83xxx_core_init);
 
+
 	snd_hda_pick_fixup(codec, stac92hd83xxx_models, stac92hd83xxx_fixup_tbl,
 			   stac92hd83xxx_fixups);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
-- 
1.8.1.2

