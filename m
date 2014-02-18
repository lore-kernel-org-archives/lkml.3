Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaBRW5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:57:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaBRWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 19/40] ALSA: hda - Fix silent output on Toshiba Satellite L40
Date: Tue, 18 Feb 2014 14:47:20 -0800
Message-Id: <20140218224433.879375013@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4528eb19b00d9ccd65ded6f8201eec704267edd8 upstream.

Toshiba Satellite L40 with AD1986A codec requires the EAPD of NID 0x1b
to be constantly on, otherwise the output doesn't work.
Unlike most of other AD1986A machines, EAPD is correctly implemented
in HD-audio manner (that is, bit set = amp on), so we need to clear
the inv_eapd flag in the fixup, too.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=67481
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -243,6 +243,19 @@ static void ad_fixup_inv_jack_detect(str
 	}
 }
 
+/* Toshiba Satellite L40 implements EAPD in a standard way unlike others */
+static void ad1986a_fixup_eapd(struct hda_codec *codec,
+			       const struct hda_fixup *fix, int action)
+{
+	struct ad198x_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		codec->inv_eapd = 0;
+		spec->gen.keep_eapd_on = 1;
+		spec->eapd_nid = 0x1b;
+	}
+}
+
 enum {
 	AD1986A_FIXUP_INV_JACK_DETECT,
 	AD1986A_FIXUP_ULTRA,
@@ -250,6 +263,7 @@ enum {
 	AD1986A_FIXUP_3STACK,
 	AD1986A_FIXUP_LAPTOP,
 	AD1986A_FIXUP_LAPTOP_IMIC,
+	AD1986A_FIXUP_EAPD,
 };
 
 static const struct hda_fixup ad1986a_fixups[] = {
@@ -310,6 +324,10 @@ static const struct hda_fixup ad1986a_fi
 		.chained_before = 1,
 		.chain_id = AD1986A_FIXUP_LAPTOP,
 	},
+	[AD1986A_FIXUP_EAPD] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = ad1986a_fixup_eapd,
+	},
 };
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
@@ -317,6 +335,7 @@ static const struct snd_pci_quirk ad1986
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8100, "ASUS P5", AD1986A_FIXUP_3STACK),
 	SND_PCI_QUIRK_MASK(0x1043, 0xff00, 0x8200, "ASUS M2", AD1986A_FIXUP_3STACK),
 	SND_PCI_QUIRK(0x10de, 0xcb84, "ASUS A8N-VM", AD1986A_FIXUP_3STACK),
+	SND_PCI_QUIRK(0x1179, 0xff40, "Toshiba Satellite L40", AD1986A_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x144d, 0xc01e, "FSC V2060", AD1986A_FIXUP_LAPTOP),
 	SND_PCI_QUIRK_MASK(0x144d, 0xff00, 0xc000, "Samsung", AD1986A_FIXUP_SAMSUNG),
 	SND_PCI_QUIRK(0x144d, 0xc027, "Samsung Q1", AD1986A_FIXUP_ULTRA),


