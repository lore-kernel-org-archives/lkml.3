Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3LSMqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:46:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3LSL52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 090/208] ALSA: hda - Fix silent output on MacBook Air 2,1
Date: Thu, 19 Dec 2013 11:53:08 +0000
Message-Id: <1387454106-19326-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0756f09c4946fe2d9ce2ebcb6f2e3c58830d22a3 upstream.

MacBook Air 2,1 has a fairly different pin assignment from its brother
MBA 1,1, and yet another quirks are needed for pin 0x18 and 0x19,
similarly like what iMac 9,1 requires, in order to make the sound
working on it.

Reported-and-tested-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 40407f4..de47748 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1767,6 +1767,7 @@ enum {
 	ALC889_FIXUP_DAC_ROUTE,
 	ALC889_FIXUP_MBP_VREF,
 	ALC889_FIXUP_IMAC91_VREF,
+	ALC889_FIXUP_MBA21_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
 	ALC887_FIXUP_ASUS_BASS,
@@ -1870,17 +1871,13 @@ static void alc889_fixup_mbp_vref(struct hda_codec *codec,
 	}
 }
 
-/* Set VREF on speaker pins on imac91 */
-static void alc889_fixup_imac91_vref(struct hda_codec *codec,
-				     const struct hda_fixup *fix, int action)
+static void alc889_fixup_mac_pins(struct hda_codec *codec,
+				  const hda_nid_t *nids, int num_nids)
 {
 	struct alc_spec *spec = codec->spec;
-	static hda_nid_t nids[2] = { 0x18, 0x1a };
 	int i;
 
-	if (action != HDA_FIXUP_ACT_INIT)
-		return;
-	for (i = 0; i < ARRAY_SIZE(nids); i++) {
+	for (i = 0; i < num_nids; i++) {
 		unsigned int val;
 		val = snd_hda_codec_get_pin_target(codec, nids[i]);
 		val |= AC_PINCTL_VREF_50;
@@ -1889,6 +1886,26 @@ static void alc889_fixup_imac91_vref(struct hda_codec *codec,
 	spec->gen.keep_vref_in_automute = 1;
 }
 
+/* Set VREF on speaker pins on imac91 */
+static void alc889_fixup_imac91_vref(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	static hda_nid_t nids[2] = { 0x18, 0x1a };
+
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc889_fixup_mac_pins(codec, nids, ARRAY_SIZE(nids));
+}
+
+/* Set VREF on speaker pins on mba21 */
+static void alc889_fixup_mba21_vref(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	static hda_nid_t nids[2] = { 0x18, 0x19 };
+
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc889_fixup_mac_pins(codec, nids, ARRAY_SIZE(nids));
+}
+
 /* Don't take HP output as primary
  * Strangely, the speaker output doesn't work on Vaio Z and some Vaio
  * all-in-one desktop PCs (for example VGC-LN51JGB) through DAC 0x05
@@ -2083,6 +2100,12 @@ static const struct hda_fixup alc882_fixups[] = {
 		.chained = true,
 		.chain_id = ALC882_FIXUP_GPIO1,
 	},
+	[ALC889_FIXUP_MBA21_VREF] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc889_fixup_mba21_vref,
+		.chained = true,
+		.chain_id = ALC889_FIXUP_MBP_VREF,
+	},
 	[ALC882_FIXUP_INV_DMIC] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_inv_dmic_0x12,
@@ -2147,7 +2170,7 @@ static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x106b, 0x3000, "iMac", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3200, "iMac 7,1 Aluminum", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x106b, 0x3400, "MacBookAir 1,1", ALC889_FIXUP_MBP_VREF),
-	SND_PCI_QUIRK(0x106b, 0x3500, "MacBookAir 2,1", ALC889_FIXUP_MBP_VREF),
+	SND_PCI_QUIRK(0x106b, 0x3500, "MacBookAir 2,1", ALC889_FIXUP_MBA21_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3600, "Macbook 3,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3800, "MacbookPro 4,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3e00, "iMac 24 Aluminum", ALC885_FIXUP_MACPRO_GPIO),
-- 
1.8.3.2

