Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaBQRBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:01:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40149 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbaBQRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:19 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 13/15] ASoC: pxa: magician: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:41 +0000
Message-Id: <1392655903-24537-14-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin updates in this driver look like they are intended to be done
atomically, update to do so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/pxa/magician.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/soc/pxa/magician.c b/sound/soc/pxa/magician.c
index aace19e..b5f0e00 100644
--- a/sound/soc/pxa/magician.c
+++ b/sound/soc/pxa/magician.c
@@ -45,26 +45,30 @@ static void magician_ext_control(struct snd_soc_codec *codec)
 {
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 
+	mutex_lock(&dapm->card->dapm_mutex);
+
 	if (magician_spk_switch)
-		snd_soc_dapm_enable_pin(dapm, "Speaker");
+		snd_soc_dapm_enable_pin_locked(dapm, "Speaker");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Speaker");
+		snd_soc_dapm_disable_pin_locked(dapm, "Speaker");
 	if (magician_hp_switch)
-		snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headphone Jack");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
 
 	switch (magician_in_sel) {
 	case MAGICIAN_MIC:
-		snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-		snd_soc_dapm_enable_pin(dapm, "Call Mic");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Mic");
+		snd_soc_dapm_enable_pin_locked(dapm, "Call Mic");
 		break;
 	case MAGICIAN_MIC_EXT:
-		snd_soc_dapm_disable_pin(dapm, "Call Mic");
-		snd_soc_dapm_enable_pin(dapm, "Headset Mic");
+		snd_soc_dapm_disable_pin_locked(dapm, "Call Mic");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headset Mic");
 		break;
 	}
 
+	mutex_unlock(&dapm->card->dapm_mutex);
+
 	snd_soc_dapm_sync(dapm);
 }
 
-- 
1.7.2.5

