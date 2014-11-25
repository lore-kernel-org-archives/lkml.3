Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaKYKnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59001 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaKYKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 201/254] ALSA: hda - Add mute LED control for Lenovo Ideapad Z560
Date: Tue, 25 Nov 2014 10:39:11 +0000
Message-Id: <1416912004-5928-202-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3542aed7480925eb859f7ce101982209cc19a126 upstream.

Lenovo Ideapad Z560 has a mute LED that is controlled via EAPD pin
0x1b on CX20585 codec.  (EAPD bit on corresponds to mute LED on.)
The machine doesn't need other EAPD, so the fixup concentrates on
controlling EAPD 0x1b following the vmaster state (but inversely).

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=665315
Reported-by: Szymon Kowalczyk <fazerxlo@o2.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_conexant.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index d5792653e77b..c5eded4f9ed3 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -64,6 +64,7 @@ struct conexant_spec {
 	unsigned int num_eapds;
 	hda_nid_t eapds[4];
 	bool dynamic_eapd;
+	hda_nid_t mute_led_eapd;
 
 	unsigned int parse_flags; /* flag for snd_hda_parse_pin_defcfg() */
 
@@ -2769,6 +2770,17 @@ static void cx_auto_vmaster_hook(void *private_data, int enabled)
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, enabled);
 }
 
+/* turn on/off EAPD according to Master switch (inversely!) for mute LED */
+static void cx_auto_vmaster_hook_mute_led(void *private_data, int enabled)
+{
+	struct hda_codec *codec = private_data;
+	struct conexant_spec *spec = codec->spec;
+
+	snd_hda_codec_write(codec, spec->mute_led_eapd, 0,
+			    AC_VERB_SET_EAPD_BTLENABLE,
+			    enabled ? 0x00 : 0x02);
+}
+
 static int cx_auto_build_controls(struct hda_codec *codec)
 {
 	int err;
@@ -2829,6 +2841,7 @@ enum {
 	CXT_FIXUP_TOSHIBA_P105,
 	CXT_FIXUP_HP_530,
 	CXT_FIXUP_CAP_MIX_AMP_5047,
+	CXT_FIXUP_MUTE_LED_EAPD,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -3162,6 +3175,18 @@ static void cxt_fixup_olpc_xo(struct hda_codec *codec,
 	}
 }
 
+static void cxt_fixup_mute_led_eapd(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	struct conexant_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_eapd = 0x1b;
+		spec->dynamic_eapd = 1;
+		spec->gen.vmaster_mute.hook = cx_auto_vmaster_hook_mute_led;
+	}
+}
+
 /*
  * Fix max input level on mixer widget to 0dB
  * (originally it has 0x2b steps with 0dB offset 0x14)
@@ -3310,6 +3335,10 @@ static const struct hda_fixup cxt_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_cap_mix_amp_5047,
 	},
+	[CXT_FIXUP_MUTE_LED_EAPD] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_mute_led_eapd,
+	},
 };
 
 static const struct snd_pci_quirk cxt5045_fixups[] = {
@@ -3366,6 +3395,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo IdeaPad Z560", CXT_FIXUP_MUTE_LED_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
@@ -3384,6 +3414,7 @@ static const struct hda_model_fixup cxt5066_fixup_models[] = {
 	{ .id = CXT_PINCFG_LEMOTE_A1004, .name = "lemote-a1004" },
 	{ .id = CXT_PINCFG_LEMOTE_A1205, .name = "lemote-a1205" },
 	{ .id = CXT_FIXUP_OLPC_XO, .name = "olpc-xo" },
+	{ .id = CXT_FIXUP_MUTE_LED_EAPD, .name = "mute-led-eapd" },
 	{}
 };
 
-- 
2.1.0

