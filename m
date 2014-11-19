Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236AbaKSW0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:26:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbaKSUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Szymon Kowalczyk <fazerxlo@o2.pl>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 052/141] ALSA: hda - Add mute LED control for Lenovo Ideapad Z560
Date: Wed, 19 Nov 2014 12:51:15 -0800
Message-Id: <20141119205152.392506896@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -44,6 +44,7 @@ struct conexant_spec {
 	unsigned int num_eapds;
 	hda_nid_t eapds[4];
 	bool dynamic_eapd;
+	hda_nid_t mute_led_eapd;
 
 	unsigned int parse_flags; /* flag for snd_hda_parse_pin_defcfg() */
 
@@ -164,6 +165,17 @@ static void cx_auto_vmaster_hook(void *p
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
@@ -224,6 +236,7 @@ enum {
 	CXT_FIXUP_TOSHIBA_P105,
 	CXT_FIXUP_HP_530,
 	CXT_FIXUP_CAP_MIX_AMP_5047,
+	CXT_FIXUP_MUTE_LED_EAPD,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -557,6 +570,18 @@ static void cxt_fixup_olpc_xo(struct hda
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
@@ -705,6 +730,10 @@ static const struct hda_fixup cxt_fixups
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_cap_mix_amp_5047,
 	},
+	[CXT_FIXUP_MUTE_LED_EAPD] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_mute_led_eapd,
+	},
 };
 
 static const struct snd_pci_quirk cxt5045_fixups[] = {
@@ -761,6 +790,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT_PINCFG_LENOVO_TP410),
+	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo IdeaPad Z560", CXT_FIXUP_MUTE_LED_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
@@ -779,6 +809,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_PINCFG_LEMOTE_A1004, .name = "lemote-a1004" },
 	{ .id = CXT_PINCFG_LEMOTE_A1205, .name = "lemote-a1205" },
 	{ .id = CXT_FIXUP_OLPC_XO, .name = "olpc-xo" },
+	{ .id = CXT_FIXUP_MUTE_LED_EAPD, .name = "mute-led-eapd" },
 	{}
 };
 


