Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab3GKOZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3GKOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolin Chen <b42378@freescale.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 25/98] ASoC: wm8962: Remove remaining direct register cache accesses
Date: Thu, 11 Jul 2013 15:23:55 +0100
Message-Id: <1373552708-15235-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <b42378@freescale.com>

commit 2e7ee15ced914e109a1a5b6dfcd463d846a13bd5 upstream.

Also fix return values for headphone switch updates.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm8962.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index dab6256..bff98fb 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1600,7 +1600,6 @@ static int wm8962_put_hp_sw(struct snd_kcontrol *kcontrol,
 			    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -1609,16 +1608,19 @@ static int wm8962_put_hp_sw(struct snd_kcontrol *kcontrol,
 		return 0;
 
 	/* If the left PGA is enabled hit that VU bit... */
-	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) & WM8962_HPOUTL_PGA_ENA)
-		return snd_soc_write(codec, WM8962_HPOUTL_VOLUME,
-				     reg_cache[WM8962_HPOUTL_VOLUME]);
+	ret = snd_soc_read(codec, WM8962_PWR_MGMT_2);
+	if (ret & WM8962_HPOUTL_PGA_ENA) {
+		snd_soc_write(codec, WM8962_HPOUTL_VOLUME,
+			      snd_soc_read(codec, WM8962_HPOUTL_VOLUME));
+		return 1;
+	}
 
 	/* ...otherwise the right.  The VU is stereo. */
-	if (snd_soc_read(codec, WM8962_PWR_MGMT_2) & WM8962_HPOUTR_PGA_ENA)
-		return snd_soc_write(codec, WM8962_HPOUTR_VOLUME,
-				     reg_cache[WM8962_HPOUTR_VOLUME]);
+	if (ret & WM8962_HPOUTR_PGA_ENA)
+		snd_soc_write(codec, WM8962_HPOUTR_VOLUME,
+			      snd_soc_read(codec, WM8962_HPOUTR_VOLUME));
 
-	return 0;
+	return 1;
 }
 
 /* The VU bits for the speakers are in a different register to the mute
@@ -3375,7 +3377,6 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 	int ret;
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
 	struct wm8962_pdata *pdata = dev_get_platdata(codec->dev);
-	u16 *reg_cache = codec->reg_cache;
 	int i, trigger, irq_pol;
 	bool dmicclk, dmicdat;
 
@@ -3433,8 +3434,9 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 
 		/* Put the speakers into mono mode? */
 		if (pdata->spk_mono)
-			reg_cache[WM8962_CLASS_D_CONTROL_2]
-				|= WM8962_SPK_MONO;
+			snd_soc_update_bits(codec, WM8962_CLASS_D_CONTROL_2,
+				WM8962_SPK_MONO_MASK, WM8962_SPK_MONO);
+
 
 		/* Micbias setup, detection enable and detection
 		 * threasholds. */
-- 
1.8.1.2

