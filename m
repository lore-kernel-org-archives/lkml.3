Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaIKMwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:52:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51593 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Francesco Muzio" <muziofg@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.605249104@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 067/131] ALSA: hda/realtek - Avoid setting wrong COEF
 on ALC269 & co
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -436,6 +436,8 @@ static void alc_fix_pll(struct hda_codec
 			    spec->pll_coef_idx);
 	val = snd_hda_codec_read(codec, spec->pll_nid, 0,
 				 AC_VERB_GET_PROC_COEF, 0);
+	if (val == -1)
+		return;
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_COEF_INDEX,
 			    spec->pll_coef_idx);
 	snd_hda_codec_write(codec, spec->pll_nid, 0, AC_VERB_SET_PROC_COEF,
@@ -4773,6 +4775,8 @@ static int alc269_parse_auto_config(stru
 static void alc269_toggle_power_output(struct hda_codec *codec, int power_up)
 {
 	int val = alc_read_coef_idx(codec, 0x04);
+	if (val == -1)
+		return;
 	if (power_up)
 		val |= 1 << 11;
 	else
@@ -5184,27 +5188,30 @@ static int alc269_fill_coef(struct hda_c
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
 
 	return 0;
 }

