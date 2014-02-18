Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaBRPa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:30:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50519 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125AbaBRPay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:30:54 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 07/17 v2] ASoC: wm8962: Update locking around use of DAPM pin API
Date: Tue, 18 Feb 2014 15:22:18 +0000
Message-Id: <1392736948-26623-8-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/codecs/wm8962.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index c06bb50..3be4633 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3106,6 +3106,7 @@ static irqreturn_t wm8962_irq(int irq, void *data)
 int wm8962_mic_detect(struct snd_soc_codec *codec, struct snd_soc_jack *jack)
 {
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int irq_mask, enable;
 
 	wm8962->jack = jack;
@@ -3126,14 +3127,18 @@ int wm8962_mic_detect(struct snd_soc_codec *codec, struct snd_soc_jack *jack)
 	snd_soc_jack_report(wm8962->jack, 0,
 			    SND_JACK_MICROPHONE | SND_JACK_BTN_0);
 
+	snd_soc_dapm_mutex_lock(dapm);
+
 	if (jack) {
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "SYSCLK");
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "MICBIAS");
+		snd_soc_dapm_force_enable_pin_unlocked(dapm, "SYSCLK");
+		snd_soc_dapm_force_enable_pin_unlocked(dapm, "MICBIAS");
 	} else {
-		snd_soc_dapm_disable_pin(&codec->dapm, "SYSCLK");
-		snd_soc_dapm_disable_pin(&codec->dapm, "MICBIAS");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "SYSCLK");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "MICBIAS");
 	}
 
+	snd_soc_dapm_mutex_unlock(dapm);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm8962_mic_detect);
-- 
1.7.2.5

