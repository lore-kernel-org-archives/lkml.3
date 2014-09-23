Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaIWCgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:36:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:37707 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbaIWCgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:36:14 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 13/45] ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co
Date: Tue, 23 Sep 2014 10:31:15 +0800
Message-Id: <1411439507-30391-13-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/pci/hda/patch_realtek.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4dac0b3..36284b8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -458,6 +458,8 @@ static void alc_fix_pll(struct hda_codec *codec)
 			    spec->pll_coef_idx);
 	val = snd_hda_codec_read(codec, spec->pll_nid, 0,
 				 AC_VERB_GET_PROC_COEF, 0);
+	if (val == -1)
+		return;
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_COEF_INDEX,
 			    spec->pll_coef_idx);
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_PROC_COEF,
@@ -5843,6 +5845,8 @@ static int alc269_parse_auto_config(struct hda_codec *codec)
 static void alc269_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	int val = alc_read_coef_idx(codec, 0x04);
+	if (val == -1)
+		return;
 	if (power_up)
 		val |= 1 << 11;
 	else
@@ -6273,27 +6277,30 @@ static void alc269_fill_coef(struct hda_codec *codec)
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
1.7.9.5

