Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbaBRPbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:31:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50622 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388AbaBRPbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:31:09 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 17/17 v2] ASoC: pxa: tosa: Update locking around use of DAPM pin API
Date: Tue, 18 Feb 2014 15:22:28 +0000
Message-Id: <1392736948-26623-18-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin updates in this driver look like they are intended to be done
atomically, update to do so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/pxa/tosa.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/sound/soc/pxa/tosa.c b/sound/soc/pxa/tosa.c
index 1d9c2ed..2a4b438 100644
--- a/sound/soc/pxa/tosa.c
+++ b/sound/soc/pxa/tosa.c
@@ -48,31 +48,35 @@ static void tosa_ext_control(struct snd_soc_codec *codec)
 {
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 
+	snd_soc_dapm_mutex_lock(dapm);
+
 	/* set up jack connection */
 	switch (tosa_jack_func) {
 	case TOSA_HP:
-		snd_soc_dapm_disable_pin(dapm, "Mic (Internal)");
-		snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Mic (Internal)");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headset Jack");
 		break;
 	case TOSA_MIC_INT:
-		snd_soc_dapm_enable_pin(dapm, "Mic (Internal)");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Mic (Internal)");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headset Jack");
 		break;
 	case TOSA_HEADSET:
-		snd_soc_dapm_disable_pin(dapm, "Mic (Internal)");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_enable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Mic (Internal)");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphone Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Headset Jack");
 		break;
 	}
 
 	if (tosa_spk_func == TOSA_SPK_ON)
-		snd_soc_dapm_enable_pin(dapm, "Speaker");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Speaker");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Speaker");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Speaker");
+
+	snd_soc_dapm_sync_unlocked(dapm);
 
-	snd_soc_dapm_sync(dapm);
+	snd_soc_dapm_mutex_unlock(dapm);
 }
 
 static int tosa_startup(struct snd_pcm_substream *substream)
-- 
1.7.2.5

