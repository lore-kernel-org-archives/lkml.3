Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab3JQPkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:40:42 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60204 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3JQPkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:40:41 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        alsa-devel@alsa-project.org (moderated list:SOUND),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] sound: pci: emu10k1: code refactoring and casting removal
Date: Thu, 17 Oct 2013 12:35:31 -0300
Message-Id: <1382024137-27716-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Partially restructures _snd_emu10k1_audigy_init_efx() and
_snd_emu10k1_init_efx() functions.

Removes useless casting (void *) from value returned by kcalloc;
see Documentation/CodingStyle, Chap 14.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 sound/pci/emu10k1/emufx.c | 76 ++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 0275209..6c45714 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -1182,15 +1182,20 @@ static int _snd_emu10k1_audigy_init_efx(struct snd_emu10k1 *emu)
 	u32 *gpr_map;
 	mm_segment_t seg;
 
-	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL ||
-	    (icode->gpr_map = (u_int32_t __user *)
-	     kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
-		     GFP_KERNEL)) == NULL ||
-	    (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
-				sizeof(*controls), GFP_KERNEL)) == NULL) {
-		err = -ENOMEM;
-		goto __err;
-	}
+	err = -ENOMEM;
+	icode = kzalloc(sizeof(*icode), GFP_KERNEL);
+	if (!icode)
+		return err;
+
+	icode->gpr_map = (__user) kcalloc(512 + 256 + 256 + 2 * 1024,
+					  sizeof(u_int32_t), GFP_KERNEL);
+	if (!icode->gpr_map)
+		goto __err_gpr;
+	controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
+			   sizeof(*controls), GFP_KERNEL);
+	if (!controls)
+		goto __err_ctrls;
+
 	gpr_map = (u32 __force *)icode->gpr_map;
 
 	icode->tram_data_map = icode->gpr_map + 512;
@@ -1741,12 +1746,12 @@ A_OP(icode, &ptr, iMAC0, A_GPR(var), A_GPR(var), A_GPR(vol), A_EXTIN(input))
 	emu->support_tlv = 0; /* clear again */
 	snd_leave_user(seg);
 
- __err:
+__err:
 	kfree(controls);
-	if (icode != NULL) {
-		kfree((void __force *)icode->gpr_map);
-		kfree(icode);
-	}
+__err_ctrls:
+	kfree((void __force *)icode->gpr_map);
+__err_gpr:
+	kfree(icode);
 	return err;
 }
 
@@ -1813,18 +1818,26 @@ static int _snd_emu10k1_init_efx(struct snd_emu10k1 *emu)
 	u32 *gpr_map;
 	mm_segment_t seg;
 
-	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL)
-		return -ENOMEM;
-	if ((icode->gpr_map = (u_int32_t __user *)
-	     kcalloc(256 + 160 + 160 + 2 * 512, sizeof(u_int32_t),
-		     GFP_KERNEL)) == NULL ||
-            (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
-				sizeof(struct snd_emu10k1_fx8010_control_gpr),
-				GFP_KERNEL)) == NULL ||
-	    (ipcm = kzalloc(sizeof(*ipcm), GFP_KERNEL)) == NULL) {
-		err = -ENOMEM;
-		goto __err;
-	}
+	err = -ENOMEM;
+	icode = kzalloc(sizeof(*icode), GFP_KERNEL);
+	if (!icode)
+		return err;
+
+	icode->gpr_map = (__user) kcalloc(256 + 160 + 160 + 2 * 512,
+					  sizeof(u_int32_t), GFP_KERNEL);
+	if (!icode->gpr_map)
+		goto __err_gpr;
+
+	controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
+			   sizeof(struct snd_emu10k1_fx8010_control_gpr),
+			   GFP_KERNEL);
+	if (!controls)
+		goto __err_ctrls;
+
+	ipcm = kzalloc(sizeof(*ipcm), GFP_KERNEL);
+	if (!ipcm)
+		goto __err_ipcm;
+
 	gpr_map = (u32 __force *)icode->gpr_map;
 
 	icode->tram_data_map = icode->gpr_map + 256;
@@ -2363,13 +2376,14 @@ static int _snd_emu10k1_init_efx(struct snd_emu10k1 *emu)
 	snd_leave_user(seg);
 	if (err >= 0)
 		err = snd_emu10k1_ipcm_poke(emu, ipcm);
-      __err:
+__err:
 	kfree(ipcm);
+__err_ipcm:
 	kfree(controls);
-	if (icode != NULL) {
-		kfree((void __force *)icode->gpr_map);
-		kfree(icode);
-	}
+__err_ctrls:
+	kfree((void __force *)icode->gpr_map);
+__err_gpr:
+	kfree(icode);
 	return err;
 }
 
-- 
1.8.4

