Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaIOTh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:37:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbaIOThP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 051/114] ASoC: wm8994: Prevent double lock of accdet_lock mutex on wm1811
Date: Mon, 15 Sep 2014 12:25:51 -0700
Message-Id: <20140915192643.040063705@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3497,6 +3497,7 @@ static irqreturn_t wm8994_mic_irq(int ir
 	return IRQ_HANDLED;
 }
 
+/* Should be called with accdet_lock held */
 static void wm1811_micd_stop(struct snd_soc_codec *codec)
 {
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
@@ -3504,14 +3505,10 @@ static void wm1811_micd_stop(struct snd_
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
@@ -3552,10 +3549,10 @@ static void wm8958_open_circuit_work(str
 						  open_circuit_work.work);
 	struct device *dev = wm8994->wm8994->dev;
 
-	wm1811_micd_stop(wm8994->hubs.codec);
-
 	mutex_lock(&wm8994->accdet_lock);
 
+	wm1811_micd_stop(wm8994->hubs.codec);
+
 	dev_dbg(dev, "Reporting open circuit\n");
 
 	wm8994->jack_mic = false;


