Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936427AbaICXw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:52:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250AbaICWFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:05:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francesco Muzio <muziofg@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 13/55] ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co
Date: Wed,  3 Sep 2014 15:05:03 -0700
Message-Id: <20140903220456.003863870@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f3ee07d8b6e061bf34a7167c3f564e8da4360a99 upstream.

ALC269 & co have many vendor-specific setups with COEF verbs.
However, some verbs seem specific to some codec versions and they
result in the codec stalling.  Typically, such a case can be avoided
by checking the return value from reading a COEF.  If the return value
is -1, it implies that the COEF is invalid, thus it shouldn't be
written.

This patch adds the invalid COEF checks in appropriate places
accessing ALC269 and its variants.  The patch actually fixes the
resume problem on Acer AO725 laptop.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=52181
Tested-by: Francesco Muzio <muziofg@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -175,6 +175,8 @@ static void alc_fix_pll(struct hda_codec
 			    spec->pll_coef_idx);
 	val = snd_hda_codec_read(codec, spec->pll_nid, 0,
 				 AC_VERB_GET_PROC_COEF, 0);
+	if (val == -1)
+		return;
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_COEF_INDEX,
 			    spec->pll_coef_idx);
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_PROC_COEF,
@@ -2677,6 +2679,8 @@ static int alc269_parse_auto_config(stru
 static void alc269vb_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	int val = alc_read_coef_idx(codec, 0x04);
+	if (val == -1)
+		return;
 	if (power_up)
 		val |= 1 << 11;
 	else
@@ -3822,27 +3826,30 @@ static void alc269_fill_coef(struct hda_
 	if ((alc_get_coef0(codec) & 0x00ff) == 0x017) {
 		val = alc_read_coef_idx(codec, 0x04);
 		/* Power up output pin */
-		alc_write_coef_idx(codec, 0x04, val | (1<<11));
+		if (val != -1)
+			alc_write_coef_idx(codec, 0x04, val | (1<<11));
 	}
 
 	if ((alc_get_coef0(codec) & 0x00ff) == 0x018) {
 		val = alc_read_coef_idx(codec, 0xd);
-		if ((val & 0x0c00) >> 10 != 0x1) {
+		if (val != -1 && (val & 0x0c00) >> 10 != 0x1) {
 			/* Capless ramp up clock control */
 			alc_write_coef_idx(codec, 0xd, val | (1<<10));
 		}
 		val = alc_read_coef_idx(codec, 0x17);
-		if ((val & 0x01c0) >> 6 != 0x4) {
+		if (val != -1 && (val & 0x01c0) >> 6 != 0x4) {
 			/* Class D power on reset */
 			alc_write_coef_idx(codec, 0x17, val | (1<<7));
 		}
 	}
 
 	val = alc_read_coef_idx(codec, 0xd); /* Class D */
-	alc_write_coef_idx(codec, 0xd, val | (1<<14));
+	if (val != -1)
+		alc_write_coef_idx(codec, 0xd, val | (1<<14));
 
 	val = alc_read_coef_idx(codec, 0x4); /* HP */
-	alc_write_coef_idx(codec, 0x4, val | (1<<11));
+	if (val != -1)
+		alc_write_coef_idx(codec, 0x4, val | (1<<11));
 }
 
 /*


