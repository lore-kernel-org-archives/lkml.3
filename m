Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaICJ7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:59:34 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57480 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932647AbaICJ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:59:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 26/56] ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co
Date: Wed,  3 Sep 2014 11:26:45 +0200
Message-Id: <023d6fee44656ea69701c69f2837fc33f82f3d1a.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a718b9939e17..e1f2c9a6d67d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -179,6 +179,8 @@ static void alc_fix_pll(struct hda_codec *codec)
 			    spec->pll_coef_idx);
 	val = snd_hda_codec_read(codec, spec->pll_nid, 0,
 				 AC_VERB_GET_PROC_COEF, 0);
+	if (val == -1)
+		return;
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_COEF_INDEX,
 			    spec->pll_coef_idx);
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_PROC_COEF,
@@ -2688,6 +2690,8 @@ static int alc269_parse_auto_config(struct hda_codec *codec)
 static void alc269vb_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	int val = alc_read_coef_idx(codec, 0x04);
+	if (val == -1)
+		return;
 	if (power_up)
 		val |= 1 << 11;
 	else
@@ -4234,27 +4238,30 @@ static void alc269_fill_coef(struct hda_codec *codec)
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
-- 
2.1.0

