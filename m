Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaBGLvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbaBGLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 176/233] ALSA: hda - Fix silent output on MacBook Air 1,1
Date: Fri,  7 Feb 2014 11:46:35 +0000
Message-Id: <1391773652-25214-177-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>

commit e7729a415315fcd9516912050d85d5aaebcededc upstream.

Similarly to other Apple products, MBA 1,1 needs a specific quirk.
Pin 0x18 must be set to VREF_50 to have sound output.  This was no
longer done since commit 1a97b7f, resulting in a mute built-in speaker.

This patch corrects the regression by creating a fixup for the MBA 1,1.

Fixes: 1a97b7f22774 ("ALSA: hda/realtek - Remove the last static quirks for ALC882")
Tested-by: Adrien Vergé <adrienverge@gmail.com>
Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e0bafd8..cd4cbad 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1767,6 +1767,7 @@ enum {
 	ALC889_FIXUP_DAC_ROUTE,
 	ALC889_FIXUP_MBP_VREF,
 	ALC889_FIXUP_IMAC91_VREF,
+	ALC889_FIXUP_MBA11_VREF,
 	ALC889_FIXUP_MBA21_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
@@ -1896,6 +1897,16 @@ static void alc889_fixup_imac91_vref(struct hda_codec *codec,
 		alc889_fixup_mac_pins(codec, nids, ARRAY_SIZE(nids));
 }
 
+/* Set VREF on speaker pins on mba11 */
+static void alc889_fixup_mba11_vref(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	static hda_nid_t nids[1] = { 0x18 };
+
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc889_fixup_mac_pins(codec, nids, ARRAY_SIZE(nids));
+}
+
 /* Set VREF on speaker pins on mba21 */
 static void alc889_fixup_mba21_vref(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
@@ -2100,6 +2111,12 @@ static const struct hda_fixup alc882_fixups[] = {
 		.chained = true,
 		.chain_id = ALC882_FIXUP_GPIO1,
 	},
+	[ALC889_FIXUP_MBA11_VREF] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc889_fixup_mba11_vref,
+		.chained = true,
+		.chain_id = ALC889_FIXUP_MBP_VREF,
+	},
 	[ALC889_FIXUP_MBA21_VREF] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc889_fixup_mba21_vref,
@@ -2169,7 +2186,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x2c00, "MacbookPro rev3", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3000, "iMac", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3200, "iMac 7,1 Aluminum", ALC882_FIXUP_EAPD),
-	SND_PCI_QUIRK(0x106b, 0x3400, "MacBookAir 1,1", ALC889_FIXUP_MBP_VREF),
+	SND_PCI_QUIRK(0x106b, 0x3400, "MacBookAir 1,1", ALC889_FIXUP_MBA11_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3500, "MacBookAir 2,1", ALC889_FIXUP_MBA21_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3600, "Macbook 3,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3800, "MacbookPro 4,1", ALC889_FIXUP_MBP_VREF),
-- 
1.8.3.2

