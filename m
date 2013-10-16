Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997Ab3JPR5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:57:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934603Ab3JPRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 24/50] ALSA: hda - Fix mono speakers and headset mic on Dell Vostro 5470
Date: Wed, 16 Oct 2013 10:45:10 -0700
Message-Id: <20131016174401.316109523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

This is a backport for stable. The original commit SHA is
338cae565c53755de9f87d6a801517940d2d56f7.

On this machine, DAC on node 0x03 seems to give mono output.

Also, it needs additional patches for headset mic support.
It supports CTIA style headsets only.

Alsa-info available at the bug link below.

BugLink: https://bugs.launchpad.net/bugs/1236228
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3308,6 +3308,15 @@ static void alc269_fixup_limit_int_mic_b
 	}
 }
 
+static void alc290_fixup_mono_speakers(struct hda_codec *codec,
+				       const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		/* Remove DAC node 0x03, as it seems to be
+		   giving mono output */
+		snd_hda_override_wcaps(codec, 0x03, 0);
+}
+
 enum {
 	ALC269_FIXUP_SONY_VAIO,
 	ALC275_FIXUP_SONY_VAIO_GPIO2,
@@ -3335,6 +3344,8 @@ enum {
 	ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT,
 	ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL2_MIC_NO_PRESENCE,
+	ALC269_FIXUP_DELL3_MIC_NO_PRESENCE,
+	ALC290_FIXUP_MONO_SPEAKERS,
 	ALC269_FIXUP_HEADSET_MODE,
 	ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC,
 	ALC269_FIXUP_ASUS_X101_FUNC,
@@ -3522,6 +3533,15 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC269_FIXUP_DELL3_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
+	},
 	[ALC269_FIXUP_HEADSET_MODE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_headset_mode,
@@ -3603,6 +3623,12 @@ static const struct hda_fixup alc269_fix
 			{ }
 		},
 	},
+	[ALC290_FIXUP_MONO_SPEAKERS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc290_fixup_mono_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL3_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -3639,6 +3665,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0608, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0609, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0613, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0616, "Dell Vostro 5470", ALC290_FIXUP_MONO_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x15cc, "Dell X5 Precision", ALC269_FIXUP_DELL2_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x15cd, "Dell X5 Precision", ALC269_FIXUP_DELL2_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),


