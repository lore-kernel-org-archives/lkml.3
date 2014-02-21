Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbaBUOAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:00:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46737 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbaBUMtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/121] ALSA: hda - Fix silent output on Toshiba Satellite L40
Date: Fri, 21 Feb 2014 12:47:14 +0000
Message-Id: <1392986945-9693-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_analog.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index c7db6e5..2ef62fe 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1205,8 +1205,22 @@ static void ad_fixup_inv_jack_detect(struct hda_codec *codec,
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
+	AD1986A_FIXUP_EAPD,
 };
 
 static const struct hda_fixup ad1986a_fixups[] = {
@@ -1214,10 +1228,15 @@ static const struct hda_fixup ad1986a_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = ad_fixup_inv_jack_detect,
 	},
+	[AD1986A_FIXUP_EAPD] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = ad1986a_fixup_eapd,
+	},
 };
 
 static const struct snd_pci_quirk ad1986a_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x2066, "Lenovo N100", AD1986A_FIXUP_INV_JACK_DETECT),
+	SND_PCI_QUIRK(0x1179, 0xff40, "Toshiba Satellite L40", AD1986A_FIXUP_EAPD),
 	{}
 };
 
-- 
1.9.0

