Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbaGDWXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:23:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760801AbaGDWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:23:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 46/46] ALSA: hda - Adjust speaker HPF and add LED support for HP Spectre 13
Date: Fri,  4 Jul 2014 15:19:50 -0700
Message-Id: <20140704221604.387295204@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8b3dfdaf0c25a584cb31d04d2574115cf2d422ab upstream.

HP Spectre 13 has the IDT 92HD95 codec, and BIOS seems to set the
default high-pass filter in some "safer" range, which results in the
very soft tone from the built-in speakers in contrast to Windows.
Also, the mute LED control is missing, since 92HD95 codec still has no
HP-specific fixups for GPIO setups.

This patch adds these missing features: the HPF is adjusted by the
vendor-specific verb, and the LED is set up from a DMI string (but
with the default polarity = 0 assumption due to the incomplete BIOS on
the given machine).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=74841
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/sound/alsa/HD-Audio-Models.txt |    5 ++
 sound/pci/hda/patch_sigmatel.c               |   58 ++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletion(-)

--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -284,6 +284,11 @@ STAC92HD83*
   hp-inv-led	HP with broken BIOS for inverted mute LED
   auto		BIOS setup (default)
 
+STAC92HD95
+==========
+  hp-led	LED support for HP laptops
+  hp-bass	Bass HPF setup for HP Spectre 13
+
 STAC9872
 ========
   vaio		VAIO laptop without SPDIF
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -121,6 +121,12 @@ enum {
 };
 
 enum {
+	STAC_92HD95_HP_LED,
+	STAC_92HD95_HP_BASS,
+	STAC_92HD95_MODELS
+};
+
+enum {
 	STAC_925x_REF,
 	STAC_M1,
 	STAC_M1_2,
@@ -3560,6 +3566,48 @@ static const struct snd_pci_quirk stac92
 	{} /* terminator */
 };
 
+static void stac92hd95_fixup_hp_led(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	struct sigmatel_spec *spec = codec->spec;
+
+	if (action != HDA_FIXUP_ACT_PRE_PROBE)
+		return;
+
+	if (find_mute_led_cfg(codec, spec->default_polarity))
+		codec_dbg(codec, "mute LED gpio %d polarity %d\n",
+				spec->gpio_led,
+				spec->gpio_led_polarity);
+}
+
+static const struct hda_fixup stac92hd95_fixups[] = {
+	[STAC_92HD95_HP_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = stac92hd95_fixup_hp_led,
+	},
+	[STAC_92HD95_HP_BASS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{0x1a, 0x795, 0x00}, /* HPF to 100Hz */
+			{}
+		},
+		.chained = true,
+		.chain_id = STAC_92HD95_HP_LED,
+	},
+};
+
+static const struct snd_pci_quirk stac92hd95_fixup_tbl[] = {
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1911, "HP Spectre 13", STAC_92HD95_HP_BASS),
+	{} /* terminator */
+};
+
+static const struct hda_model_fixup stac92hd95_models[] = {
+	{ .id = STAC_92HD95_HP_LED, .name = "hp-led" },
+	{ .id = STAC_92HD95_HP_BASS, .name = "hp-bass" },
+	{}
+};
+
+
 static int stac_parse_auto_config(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec = codec->spec;
@@ -4045,10 +4093,16 @@ static int patch_stac92hd95(struct hda_c
 	spec->gen.beep_nid = 0x19; /* digital beep */
 	spec->pwr_nids = stac92hd95_pwr_nids;
 	spec->num_pwrs = ARRAY_SIZE(stac92hd95_pwr_nids);
-	spec->default_polarity = -1; /* no default cfg */
+	spec->default_polarity = 0;
 
 	codec->patch_ops = stac_patch_ops;
 
+	snd_hda_pick_fixup(codec, stac92hd95_models, stac92hd95_fixup_tbl,
+			   stac92hd95_fixups);
+	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
+
+	stac_setup_gpio(codec);
+
 	err = stac_parse_auto_config(codec);
 	if (err < 0) {
 		stac_free(codec);
@@ -4057,6 +4111,8 @@ static int patch_stac92hd95(struct hda_c
 
 	codec->proc_widget_hook = stac92hd_proc_hook;
 
+	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PROBE);
+
 	return 0;
 }
 


