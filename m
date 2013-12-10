Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3LJI1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:27:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3LJIAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 04/52] ALSA: hda - Fix silent output on MacBook Air 2,1
Date: Tue, 10 Dec 2013 00:00:37 -0800
Message-Id: <20131210075954.527796936@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0756f09c4946fe2d9ce2ebcb6f2e3c58830d22a3 upstream.

MacBook Air 2,1 has a fairly different pin assignment from its brother
MBA 1,1, and yet another quirks are needed for pin 0x18 and 0x19,
similarly like what iMac 9,1 requires, in order to make the sound
working on it.

Reported-and-tested-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1763,6 +1763,7 @@ enum {
 	ALC889_FIXUP_DAC_ROUTE,
 	ALC889_FIXUP_MBP_VREF,
 	ALC889_FIXUP_IMAC91_VREF,
+	ALC889_FIXUP_MBA21_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
 	ALC887_FIXUP_ASUS_BASS,
@@ -1866,17 +1867,13 @@ static void alc889_fixup_mbp_vref(struct
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
@@ -1885,6 +1882,26 @@ static void alc889_fixup_imac91_vref(str
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
@@ -2079,6 +2096,12 @@ static const struct hda_fixup alc882_fix
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
@@ -2143,7 +2166,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x106b, 0x3000, "iMac", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3200, "iMac 7,1 Aluminum", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x106b, 0x3400, "MacBookAir 1,1", ALC889_FIXUP_MBP_VREF),
-	SND_PCI_QUIRK(0x106b, 0x3500, "MacBookAir 2,1", ALC889_FIXUP_MBP_VREF),
+	SND_PCI_QUIRK(0x106b, 0x3500, "MacBookAir 2,1", ALC889_FIXUP_MBA21_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3600, "Macbook 3,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3800, "MacbookPro 4,1", ALC889_FIXUP_MBP_VREF),
 	SND_PCI_QUIRK(0x106b, 0x3e00, "iMac 24 Aluminum", ALC885_FIXUP_MACPRO_GPIO),


