Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaIZKWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:22:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbaIZJqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/142] ASoC: wm8994: Prevent double lock of accdet_lock mutex on wm1811
Date: Fri, 26 Sep 2014 11:44:44 +0200
Message-Id: <0eff4d68aefc30b4b759aa6c6d6e554d430a4a4e.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b38314179c9ccb789e6fe967cff171fa817e8978 upstream.

wm1811_micd_stop takes the accdet_lock mutex, and is called from two
places, one of which is already holding the accdet_lock. This obviously
causes a lock up.

This patch fixes this issue by removing the lock from wm1811_micd_stop
and ensuring that it is always locked externally.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/wm8994.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 86426a117b07..c9ce9772e49b 100644
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
2.1.0

