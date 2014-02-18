Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbaBRPg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:36:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50502 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194AbaBRPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:30:52 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 06/17 v2] ASoC: wm5100: Update locking around use of DAPM pin API
Date: Tue, 18 Feb 2014 15:22:17 +0000
Message-Id: <1392736948-26623-7-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/codecs/wm5100.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 4e3e31a..492fe84 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2100,6 +2100,7 @@ static void wm5100_micd_irq(struct wm5100_priv *wm5100)
 int wm5100_detect(struct snd_soc_codec *codec, struct snd_soc_jack *jack)
 {
 	struct wm5100_priv *wm5100 = snd_soc_codec_get_drvdata(codec);
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
 
 	if (jack) {
 		wm5100->jack = jack;
@@ -2117,9 +2118,14 @@ int wm5100_detect(struct snd_soc_codec *codec, struct snd_soc_jack *jack)
 				    WM5100_ACCDET_RATE_MASK);
 
 		/* We need the charge pump to power MICBIAS */
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "CP2");
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "SYSCLK");
-		snd_soc_dapm_sync(&codec->dapm);
+		snd_soc_dapm_mutex_lock(dapm);
+
+		snd_soc_dapm_force_enable_pin_unlocked(dapm, "CP2");
+		snd_soc_dapm_force_enable_pin_unlocked(dapm, "SYSCLK");
+
+		snd_soc_dapm_sync_unlocked(dapm);
+
+		snd_soc_dapm_mutex_unlock(dapm);
 
 		/* We start off just enabling microphone detection - even a
 		 * plain headphone will trigger detection.
-- 
1.7.2.5

