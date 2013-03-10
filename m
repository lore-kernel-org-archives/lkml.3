Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3CJQ6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 12:58:34 -0400
Received: from mail.tpi.com ([70.99.223.143]:1121 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3CJQ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 12:58:33 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org
Subject: [PATCH linux-next] ASoC: wm_hubs: Silence reg_r and reg_l 'may be used uninitialized' warnings
Date: Sun, 10 Mar 2013 10:58:21 -0600
Message-Id: <1362934701-75951-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return an error from wm_hubs_read_dc_servo() if hubs->dcs_readback_mode is not
correctly initialized. You might as well bail out since nothing is likely to
work correctly afterwards.

sound/soc/codecs/wm_hubs.c:321:11: warning: 'reg_r' may be used uninitialized in this function [-Wuninitialized]
sound/soc/codecs/wm_hubs.c:251:13: note: 'reg_r' was declared here
sound/soc/codecs/wm_hubs.c:322:11: warning: 'reg_l' may be used uninitialized in this function [-Wuninitialized]
sound/soc/codecs/wm_hubs.c:251:6: note: 'reg_l' was declared here

gcc version 4.6.3

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: patches@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 sound/soc/codecs/wm_hubs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 867ae97..f5d81b9 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -199,11 +199,12 @@ static void wm_hubs_dcs_cache_set(struct snd_soc_codec *codec, u16 dcs_cfg)
 	list_add_tail(&cache->list, &hubs->dcs_cache);
 }
 
-static void wm_hubs_read_dc_servo(struct snd_soc_codec *codec,
+static int wm_hubs_read_dc_servo(struct snd_soc_codec *codec,
 				  u16 *reg_l, u16 *reg_r)
 {
 	struct wm_hubs_data *hubs = snd_soc_codec_get_drvdata(codec);
 	u16 dcs_reg, reg;
+	int ret = 0;
 
 	switch (hubs->dcs_readback_mode) {
 	case 2:
@@ -236,8 +237,9 @@ static void wm_hubs_read_dc_servo(struct snd_soc_codec *codec,
 		break;
 	default:
 		WARN(1, "Unknown DCS readback method\n");
-		return;
+		ret = -1;
 	}
+	return ret;
 }
 
 /*
@@ -286,7 +288,8 @@ static void enable_dc_servo(struct snd_soc_codec *codec)
 				  WM8993_DCS_TRIG_STARTUP_1);
 	}
 
-	wm_hubs_read_dc_servo(codec, &reg_l, &reg_r);
+	if (wm_hubs_read_dc_servo(codec, &reg_l, &reg_r) < 0)
+		return;
 
 	dev_dbg(codec->dev, "DCS input: %x %x\n", reg_l, reg_r);
 
-- 
1.7.9.5

