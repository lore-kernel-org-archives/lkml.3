Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaLTWce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:32:34 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64804 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaLTWcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:32:31 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: pci: cx18: cx18-alsa-mixer.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 23:35:17 +0100
Message-Id: <1419114917-12029-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
snd_cx18_mixer_tv_vol_get() snd_cx18_mixer_tv_vol_info() snd_cx18_mixer_tv_vol_put()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/pci/cx18/cx18-alsa-mixer.c |   62 ------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-mixer.c b/drivers/media/pci/cx18/cx18-alsa-mixer.c
index 341bddc..e7b0a1f 100644
--- a/drivers/media/pci/cx18/cx18-alsa-mixer.c
+++ b/drivers/media/pci/cx18/cx18-alsa-mixer.c
@@ -69,68 +69,6 @@ static inline int cx18_av_vol_to_dB(int v)
 	return (v >> 9) - 119;
 }
 
-static int snd_cx18_mixer_tv_vol_info(struct snd_kcontrol *kcontrol,
-				      struct snd_ctl_elem_info *uinfo)
-{
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
-	uinfo->count = 1;
-	/* We're already translating values, just keep this control in dB */
-	uinfo->value.integer.min  = -96;
-	uinfo->value.integer.max  =   8;
-	uinfo->value.integer.step =   1;
-	return 0;
-}
-
-static int snd_cx18_mixer_tv_vol_get(struct snd_kcontrol *kctl,
-				     struct snd_ctl_elem_value *uctl)
-{
-	struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
-	struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
-	struct v4l2_control vctrl;
-	int ret;
-
-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
-	vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-
-	snd_cx18_lock(cxsc);
-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
-	snd_cx18_unlock(cxsc);
-
-	if (!ret)
-		uctl->value.integer.value[0] = cx18_av_vol_to_dB(vctrl.value);
-	return ret;
-}
-
-static int snd_cx18_mixer_tv_vol_put(struct snd_kcontrol *kctl,
-				     struct snd_ctl_elem_value *uctl)
-{
-	struct snd_cx18_card *cxsc = snd_kcontrol_chip(kctl);
-	struct cx18 *cx = to_cx18(cxsc->v4l2_dev);
-	struct v4l2_control vctrl;
-	int ret;
-
-	vctrl.id = V4L2_CID_AUDIO_VOLUME;
-	vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-
-	snd_cx18_lock(cxsc);
-
-	/* Fetch current state */
-	ret = v4l2_subdev_call(cx->sd_av, core, g_ctrl, &vctrl);
-
-	if (ret ||
-	    (cx18_av_vol_to_dB(vctrl.value) != uctl->value.integer.value[0])) {
-
-		/* Set, if needed */
-		vctrl.value = dB_to_cx18_av_vol(uctl->value.integer.value[0]);
-		ret = v4l2_subdev_call(cx->sd_av, core, s_ctrl, &vctrl);
-		if (!ret)
-			ret = 1; /* Indicate control was changed w/o error */
-	}
-	snd_cx18_unlock(cxsc);
-
-	return ret;
-}
-
 
 /* This is a bit of overkill, the slider is already in dB internally */
 static DECLARE_TLV_DB_SCALE(snd_cx18_mixer_tv_vol_db_scale, -9600, 100, 0);
-- 
1.7.10.4

