Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3APQLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:11:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab3APQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 217/222] ALSA: hda - add mute LED for HP Pavilion 17 (Realtek codec)
Date: Wed, 16 Jan 2013 13:56:57 -0200
Message-Id: <1358351822-7675-218-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 6d3cd5d444223c41eabb70dccff14fae4e8cb8b1 upstream.

The mute LED is in this case connected to the Mic1 VREF.

The machine also exposes the following string in BIOS:
"HP_Mute_LED_0_A", so if more machines are coming, it probably
makes sense to try to do something more generic, like for the
IDT codec.

BugLink: https://bugs.launchpad.net/bugs/1096789
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_realtek.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7e3fef0..30ce67b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5851,6 +5851,30 @@ static void alc269_fixup_quanta_mute(struct hda_codec *codec,
 	spec->automute_hook = alc269_quanta_automute;
 }
 
+/* update mute-LED according to the speaker mute state via mic1 VREF pin */
+static void alc269_fixup_mic1_mute_hook(void *private_data, int enabled)
+{
+	struct hda_codec *codec = private_data;
+	unsigned int pinval = AC_PINCTL_IN_EN + (enabled ?
+			      AC_PINCTL_VREF_HIZ : AC_PINCTL_VREF_80);
+	snd_hda_set_pin_ctl_cache(codec, 0x18, pinval);
+}
+
+static void alc269_fixup_mic1_mute(struct hda_codec *codec,
+				   const struct alc_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+	switch (action) {
+	case ALC_FIXUP_ACT_BUILD:
+		spec->vmaster_mute.hook = alc269_fixup_mic1_mute_hook;
+		snd_hda_add_vmaster_hook(codec, &spec->vmaster_mute, true);
+		/* fallthru */
+	case ALC_FIXUP_ACT_INIT:
+		snd_hda_sync_vmaster_hook(&spec->vmaster_mute);
+		break;
+	}
+}
+
 /* update mute-LED according to the speaker mute state via mic2 VREF pin */
 static void alc269_fixup_mic2_mute_hook(void *private_data, int enabled)
 {
@@ -5891,6 +5915,7 @@ enum {
 	ALC269_FIXUP_DMIC,
 	ALC269VB_FIXUP_AMIC,
 	ALC269VB_FIXUP_DMIC,
+	ALC269_FIXUP_MIC1_MUTE_LED,
 	ALC269_FIXUP_MIC2_MUTE_LED,
 	ALC269_FIXUP_LENOVO_DOCK,
 	ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT,
@@ -6016,6 +6041,10 @@ static const struct alc_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC269_FIXUP_MIC1_MUTE_LED] = {
+		.type = ALC_FIXUP_FUNC,
+		.v.func = alc269_fixup_mic1_mute,
+	},
 	[ALC269_FIXUP_MIC2_MUTE_LED] = {
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc269_fixup_mic2_mute,
@@ -6038,6 +6067,7 @@ static const struct alc_fixup alc269_fixups[] = {
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_MIC2_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x1972, "HP Pavilion 17", ALC269_FIXUP_MIC1_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
-- 
1.7.9.5

