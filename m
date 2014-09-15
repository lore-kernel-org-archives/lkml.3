Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbaIOW0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:26:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515AbaIOWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/187] ASoC: wm8994: Prevent double lock of accdet_lock mutex on wm1811
Date: Mon, 15 Sep 2014 15:07:40 -0700
Message-Id: <1410818997-9432-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit b38314179c9ccb789e6fe967cff171fa817e8978 upstream.

wm1811_micd_stop takes the accdet_lock mutex, and is called from two
places, one of which is already holding the accdet_lock. This obviously
causes a lock up.

This patch fixes this issue by removing the lock from wm1811_micd_stop
and ensuring that it is always locked externally.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/wm8994.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 86426a1..c9ce977 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3492,6 +3492,7 @@ static irqreturn_t wm8994_mic_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+/* Should be called with accdet_lock held */
 static void wm1811_micd_stop(struct snd_soc_codec *codec)
 {
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
@@ -3499,14 +3500,10 @@ static void wm1811_micd_stop(struct snd_soc_codec *codec)
 	if (!wm8994->jackdet)
 		return;
 
-	mutex_lock(&wm8994->accdet_lock);
-
 	snd_soc_update_bits(codec, WM8958_MIC_DETECT_1, WM8958_MICD_ENA, 0);
 
 	wm1811_jackdet_set_mode(codec, WM1811_JACKDET_MODE_JACK);
 
-	mutex_unlock(&wm8994->accdet_lock);
-
 	if (wm8994->wm8994->pdata.jd_ext_cap)
 		snd_soc_dapm_disable_pin(&codec->dapm,
 					 "MICBIAS2");
@@ -3547,10 +3544,10 @@ static void wm8958_open_circuit_work(struct work_struct *work)
 						  open_circuit_work.work);
 	struct device *dev = wm8994->wm8994->dev;
 
-	wm1811_micd_stop(wm8994->hubs.codec);
-
 	mutex_lock(&wm8994->accdet_lock);
 
+	wm1811_micd_stop(wm8994->hubs.codec);
+
 	dev_dbg(dev, "Reporting open circuit\n");
 
 	wm8994->jack_mic = false;
-- 
1.9.1

