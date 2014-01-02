Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaABRVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:21:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40401 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaABRJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 77/91] ALSA: hda - Fix silent output on ASUS W7J laptop
Date: Thu,  2 Jan 2014 09:04:52 -0800
Message-Id: <1388682306-30859-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6ddf0fd1c462a418a3cbb8b0653820dc48ffbd98 upstream.

The recent kernels got regressions on ASUS W7J with ALC660 codec where
no sound comes out.  After a long debugging session, we found out that
setting the pin control on the unused NID 0x10 is mandatory for the
outputs.  And, it was found out that another magic of NID 0x0f that is
required for other ASUS laptops isn't needed on this machine.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66081
Reported-and-tested-by: Andrey Lipaev <lipaev@mail.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8a4764a..a67e6e2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6578,6 +6578,7 @@ enum {
 	ALC861_FIXUP_AMP_VREF_0F,
 	ALC861_FIXUP_NO_JACK_DETECT,
 	ALC861_FIXUP_ASUS_A6RP,
+	ALC660_FIXUP_ASUS_W7J,
 };
 
 /* On some laptops, VREF of pin 0x0f is abused for controlling the main amp */
@@ -6628,10 +6629,21 @@ static const struct alc_fixup alc861_fixups[] = {
 		.v.func = alc861_fixup_asus_amp_vref_0f,
 		.chained = true,
 		.chain_id = ALC861_FIXUP_NO_JACK_DETECT,
+	},
+	[ALC660_FIXUP_ASUS_W7J] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* ASUS W7J needs a magic pin setup on unused NID 0x10
+			 * for enabling outputs
+			 */
+			{0x10, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24},
+			{ }
+		},
 	}
 };
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1043, 0x1253, "ASUS W7J", ALC660_FIXUP_ASUS_W7J),
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
 	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),
-- 
1.8.3.2

