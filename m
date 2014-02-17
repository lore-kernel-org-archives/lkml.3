Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaBQRAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:00:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40176 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbaBQRAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:22 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 15/15] ASoC: pxa: tosa: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:43 +0000
Message-Id: <1392655903-24537-16-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/pxa/tosa.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/sound/soc/pxa/tosa.c b/sound/soc/pxa/tosa.c
index 1d9c2ed..64f9620 100644
--- a/sound/soc/pxa/tosa.c
+++ b/sound/soc/pxa/tosa.c
@@ -48,29 +48,33 @@ static void tosa_ext_control(struct snd_soc_codec *codec)
 {
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 
+	mutex_lock(&dapm->card->dapm_mutex);
+
 	/* set up jack connection */
 	switch (tosa_jack_func) {
 	case TOSA_HP:
-		snd_soc_dapm_disable_pin(dapm, "Mic (Internal)");
-		snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Mic (Internal)");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
 		break;
 	case TOSA_MIC_INT:
-		snd_soc_dapm_enable_pin(dapm, "Mic (Internal)");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Mic (Internal)");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
 		break;
 	case TOSA_HEADSET:
-		snd_soc_dapm_disable_pin(dapm, "Mic (Internal)");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_enable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Mic (Internal)");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headset Jack");
 		break;
 	}
 
 	if (tosa_spk_func == TOSA_SPK_ON)
-		snd_soc_dapm_enable_pin(dapm, "Speaker");
+		snd_soc_dapm_enable_pin_locked(dapm, "Speaker");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Speaker");
+		snd_soc_dapm_disable_pin_locked(dapm, "Speaker");
+
+	mutex_unlock(&dapm->card->dapm_mutex);
 
 	snd_soc_dapm_sync(dapm);
 }
-- 
1.7.2.5

