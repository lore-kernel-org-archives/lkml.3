Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaBQRAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:00:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40104 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbaBQRAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:13 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 09/15] ASoC: ams-delta: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:37 +0000
Message-Id: <1392655903-24537-10-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/omap/ams-delta.c |   38 +++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 6294464..73deddf 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -113,46 +113,52 @@ static int ams_delta_set_audio_mode(struct snd_kcontrol *kcontrol,
 
 	/* Setup pins after corresponding bits if changed */
 	pin = !!(pins & (1 << AMS_DELTA_MOUTHPIECE));
+
+	mutex_lock(&dapm->card->dapm_mutex);
+
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Mouthpiece")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Mouthpiece");
+			snd_soc_dapm_enable_pin_locked(dapm, "Mouthpiece");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Mouthpiece");
+			snd_soc_dapm_disable_pin_locked(dapm, "Mouthpiece");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_EARPIECE));
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Earpiece")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Earpiece");
+			snd_soc_dapm_enable_pin_locked(dapm, "Earpiece");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Earpiece");
+			snd_soc_dapm_disable_pin_locked(dapm, "Earpiece");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_MICROPHONE));
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Microphone")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Microphone");
+			snd_soc_dapm_enable_pin_locked(dapm, "Microphone");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Microphone");
+			snd_soc_dapm_disable_pin_locked(dapm, "Microphone");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_SPEAKER));
 	if (pin != snd_soc_dapm_get_pin_status(dapm, "Speaker")) {
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "Speaker");
+			snd_soc_dapm_enable_pin_locked(dapm, "Speaker");
 		else
-			snd_soc_dapm_disable_pin(dapm, "Speaker");
+			snd_soc_dapm_disable_pin_locked(dapm, "Speaker");
 	}
 	pin = !!(pins & (1 << AMS_DELTA_AGC));
 	if (pin != ams_delta_audio_agc) {
 		ams_delta_audio_agc = pin;
 		changed = 1;
 		if (pin)
-			snd_soc_dapm_enable_pin(dapm, "AGCIN");
+			snd_soc_dapm_enable_pin_locked(dapm, "AGCIN");
 		else
-			snd_soc_dapm_disable_pin(dapm, "AGCIN");
+			snd_soc_dapm_disable_pin_locked(dapm, "AGCIN");
 	}
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
 	if (changed)
 		snd_soc_dapm_sync(dapm);
 
@@ -315,11 +321,13 @@ static void cx81801_close(struct tty_struct *tty)
 	v253_ops.close(tty);
 
 	/* Revert back to default audio input/output constellation */
-	snd_soc_dapm_disable_pin(dapm, "Mouthpiece");
-	snd_soc_dapm_enable_pin(dapm, "Earpiece");
-	snd_soc_dapm_enable_pin(dapm, "Microphone");
-	snd_soc_dapm_disable_pin(dapm, "Speaker");
-	snd_soc_dapm_disable_pin(dapm, "AGCIN");
+	mutex_lock(&dapm->card->dapm_mutex);
+	snd_soc_dapm_disable_pin_locked(dapm, "Mouthpiece");
+	snd_soc_dapm_enable_pin_locked(dapm, "Earpiece");
+	snd_soc_dapm_enable_pin_locked(dapm, "Microphone");
+	snd_soc_dapm_disable_pin_locked(dapm, "Speaker");
+	snd_soc_dapm_disable_pin_locked(dapm, "AGCIN");
+	mutex_unlock(&dapm->card->dapm_mutex);
 	snd_soc_dapm_sync(dapm);
 }
 
-- 
1.7.2.5

