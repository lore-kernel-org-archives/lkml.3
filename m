Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbaCDUJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:09:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbaCDUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 78/97] ALSA: hda - Add a fixup for HP Folio 13 mute LED
Date: Tue,  4 Mar 2014 12:04:31 -0800
Message-Id: <20140304200348.567331715@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 37c367ecdb9a01c9acc980e6e17913570a1788a7 upstream.

HP Folio 13 may have a broken BIOS that doesn't set up the mute LED
GPIO properly, and the driver guesses it wrongly, too.  Add a new
fixup entry for setting the GPIO pin statically for this laptop.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70991
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -98,6 +98,7 @@ enum {
 	STAC_92HD83XXX_HP_LED,
 	STAC_92HD83XXX_HP_INV_LED,
 	STAC_92HD83XXX_HP_MIC_LED,
+	STAC_HP_LED_GPIO10,
 	STAC_92HD83XXX_HEADSET_JACK,
 	STAC_92HD83XXX_HP,
 	STAC_HP_ENVY_BASS,
@@ -2107,6 +2108,17 @@ static void stac92hd83xxx_fixup_hp_mic_l
 		spec->mic_mute_led_gpio = 0x08; /* GPIO3 */
 }
 
+static void stac92hd83xxx_fixup_hp_led_gpio10(struct hda_codec *codec,
+				   const struct hda_fixup *fix, int action)
+{
+	struct sigmatel_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->gpio_led = 0x10; /* GPIO4 */
+		spec->default_polarity = 0;
+	}
+}
+
 static void stac92hd83xxx_fixup_headset_jack(struct hda_codec *codec,
 				   const struct hda_fixup *fix, int action)
 {
@@ -2173,6 +2185,12 @@ static const struct hda_fixup stac92hd83
 		.chained = true,
 		.chain_id = STAC_92HD83XXX_HP,
 	},
+	[STAC_HP_LED_GPIO10] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = stac92hd83xxx_fixup_hp_led_gpio10,
+		.chained = true,
+		.chain_id = STAC_92HD83XXX_HP,
+	},
 	[STAC_92HD83XXX_HEADSET_JACK] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = stac92hd83xxx_fixup_headset_jack,
@@ -2244,6 +2262,8 @@ static const struct snd_pci_quirk stac92
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1888,
 			  "HP Envy Spectre", STAC_HP_ENVY_BASS),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1899,
+			  "HP Folio 13", STAC_HP_LED_GPIO10),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x18df,
 			  "HP Folio", STAC_92HD83XXX_HP_MIC_LED),
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_HP, 0xff00, 0x1900,


