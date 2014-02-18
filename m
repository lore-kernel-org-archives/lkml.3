Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaBRPbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:31:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50562 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125AbaBRPbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:31:01 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 11/17 v2] ASoC: ams-delta: Update locking around use of DAPM pin API
Date: Tue, 18 Feb 2014 15:22:22 +0000
Message-Id: <1392736948-26623-12-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin updates in this driver look like they are intended to be done
atomically, update to do so. It looks like these were originally locked
with the CODEC mutex and not updated since the patch "ASoC: dapm: Use
DAPM mutex for DAPM ops instead of codec mutex", so remove the original
CODEC mutex locking as well.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/omap/ams-delta.c |   45 +++++++++++++++++++++++++------------------
 1 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 6294464..5750de1 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -106,57 +106,59 @@ static int ams_delta_set_audio_mode(struct snd_kcontrol *kcontrol,
 	if (ucontrol->value.enumerated.item[0] >= control->max)
 		return -EINVAL;
 
-	mutex_lock(&codec->mutex);
+	snd_soc_dapm_mutex_lock(dapm);
 
 	/* Translate selection to bitmap */
 	pins = ams_delta_audio_mode_pins[ucontrol->value.enumerated.item[0]];
 
 	/* Setup pins after corresponding bits if changed */
 	pin = !!(pins & (1 << AMS_DELTA_MOUTHPIECE));
+
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Mouthpiece")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Mouthpiece");
+			snd_soc_dapm_enable_pin_unlocked(dapm, "Mouthpiece");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Mouthpiece");
+			snd_soc_dapm_disable_pin_unlocked(dapm, "Mouthpiece");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_EARPIECE));
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Earpiece")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Earpiece");
+			snd_soc_dapm_enable_pin_unlocked(dapm, "Earpiece");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Earpiece");
+			snd_soc_dapm_disable_pin_unlocked(dapm, "Earpiece");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_MICROPHONE));
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Microphone")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Microphone");
+			snd_soc_dapm_enable_pin_unlocked(dapm, "Microphone");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Microphone");
+			snd_soc_dapm_disable_pin_unlocked(dapm, "Microphone");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_SPEAKER));
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Speaker")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Speaker");
+			snd_soc_dapm_enable_pin_unlocked(dapm, "Speaker");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Speaker");
+			snd_soc_dapm_disable_pin_unlocked(dapm, "Speaker");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_AGC));
 	if (pin != ams_delta_audio_agc) {
 		ams_delta_audio_agc = pin;
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "AGCIN");
+			snd_soc_dapm_enable_pin_unlocked(dapm, "AGCIN");
 		else
-			snd_soc_dapm_disable_pin(dapm, "AGCIN");
+			snd_soc_dapm_disable_pin_unlocked(dapm, "AGCIN");
 	}
+
 	if (changed)
-		snd_soc_dapm_sync(dapm);
+		snd_soc_dapm_sync_unlocked(dapm);
 
-	mutex_unlock(&codec->mutex);
+	snd_soc_dapm_mutex_unlock(dapm);
 
 	return changed;
 }
@@ -315,12 +317,17 @@ static void cx81801_close(struct tty_struct *tty)
 	v253_ops.close(tty);
 
 	/* Revert back to default audio input/output constellation */
-	snd_soc_dapm_disable_pin(dapm, "Mouthpiece");
-	snd_soc_dapm_enable_pin(dapm, "Earpiece");
-	snd_soc_dapm_enable_pin(dapm, "Microphone");
-	snd_soc_dapm_disable_pin(dapm, "Speaker");
-	snd_soc_dapm_disable_pin(dapm, "AGCIN");
-	snd_soc_dapm_sync(dapm);
+	snd_soc_dapm_mutex_lock(dapm);
+
+	snd_soc_dapm_disable_pin_unlocked(dapm, "Mouthpiece");
+	snd_soc_dapm_enable_pin_unlocked(dapm, "Earpiece");
+	snd_soc_dapm_enable_pin_unlocked(dapm, "Microphone");
+	snd_soc_dapm_disable_pin_unlocked(dapm, "Speaker");
+	snd_soc_dapm_disable_pin_unlocked(dapm, "AGCIN");
+
+	snd_soc_dapm_sync_unlocked(dapm);
+
+	snd_soc_dapm_mutex_unlock(codec);
 }
 
 /* Line discipline .hangup() */
-- 
1.7.2.5

