Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaBQRC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:02:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40046 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbaBQRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:07 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 05/15] ASoC: wm8962: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:33 +0000
Message-Id: <1392655903-24537-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/codecs/wm8962.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index c06bb50..535a7dc 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3126,14 +3126,18 @@ int wm8962_mic_detect(struct snd_soc_codec *codec, struct snd_soc_jack *jack)
 	snd_soc_jack_report(wm8962->jack, 0,
 			    SND_JACK_MICROPHONE | SND_JACK_BTN_0);
 
+	mutex_lock(&codec->dapm.card->dapm_mutex);
+
 	if (jack) {
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "SYSCLK");
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "MICBIAS");
+		snd_soc_dapm_force_enable_pin_locked(&codec->dapm, "SYSCLK");
+		snd_soc_dapm_force_enable_pin_locked(&codec->dapm, "MICBIAS");
 	} else {
-		snd_soc_dapm_disable_pin(&codec->dapm, "SYSCLK");
-		snd_soc_dapm_disable_pin(&codec->dapm, "MICBIAS");
+		snd_soc_dapm_disable_pin_locked(&codec->dapm, "SYSCLK");
+		snd_soc_dapm_disable_pin_locked(&codec->dapm, "MICBIAS");
 	}
 
+	mutex_unlock(&codec->dapm.card->dapm_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm8962_mic_detect);
-- 
1.7.2.5

