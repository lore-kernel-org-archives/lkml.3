Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbaEMJ26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:28:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60720 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/182] ALSA: hda - automute via amp instead of pinctl on some AIO models
Date: Tue, 13 May 2014 11:25:54 +0200
Message-Id: <5c9b463ca49ed99558585628a608b0914179eee9.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 493a52a9b6645f61954580c7d4bd52fa62110934 upstream.

On some AIO (All In One) models with the codec alc668
(Vendor ID: 0x10ec0668) on it, when we plug a headphone into the jack,
the system will switch the output to headphone and set the speaker to
automute as well as change the speaker Pin-ctls from 0x40 to 0x00,
this will bring loud noise to the headphone.

I tried to disable the corresponding EAPD, but it did not help to
eliminate the noise.

According to Takashi's suggestion, we use amp operation to replace the
pinctl modification for the automute, this really eliminate the noise.

BugLink: https://bugs.launchpad.net/bugs/1268468
Cc: David Henningsson <david.henningsson@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6a32c857f704..855074950e6c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3480,6 +3480,15 @@ static void alc_fixup_no_shutup(struct hda_codec *codec,
 	}
 }
 
+static void alc_fixup_auto_mute_via_amp(struct hda_codec *codec,
+					const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		struct alc_spec *spec = codec->spec;
+		spec->gen.auto_mute_via_amp = 1;
+	}
+}
+
 static void alc_fixup_headset_mode_alc668(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -4646,6 +4655,7 @@ enum {
 	ALC662_FIXUP_BASS_CHMAP,
 	ALC662_FIXUP_BASS_1A,
 	ALC662_FIXUP_BASS_1A_CHMAP,
+	ALC668_FIXUP_AUTO_MUTE,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -4806,6 +4816,12 @@ static const struct hda_fixup alc662_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_inv_dmic_0x12,
 	},
+	[ALC668_FIXUP_AUTO_MUTE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_auto_mute_via_amp,
+		.chained = true,
+		.chain_id = ALC668_FIXUP_DELL_MIC_NO_PRESENCE
+	},
 	[ALC668_FIXUP_DELL_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -4851,11 +4867,11 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x1028, 0x05d8, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05db, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1028, 0x0623, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1028, 0x0624, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0623, "Dell", ALC668_FIXUP_AUTO_MUTE),
+	SND_PCI_QUIRK(0x1028, 0x0624, "Dell", ALC668_FIXUP_AUTO_MUTE),
 	SND_PCI_QUIRK(0x1028, 0x0625, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0626, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1028, 0x0628, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0628, "Dell", ALC668_FIXUP_AUTO_MUTE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
 	SND_PCI_QUIRK(0x1043, 0x11cd, "Asus N550", ALC662_FIXUP_BASS_1A_CHMAP),
 	SND_PCI_QUIRK(0x1043, 0x1477, "ASUS N56VZ", ALC662_FIXUP_BASS_CHMAP),
-- 
1.9.3

