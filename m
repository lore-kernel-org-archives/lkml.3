Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab3HBKIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:08:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759003Ab3HBKIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:08:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>, Mark Brown <broonie@linaro.org>
Subject: [ 13/99] ASoC: wm8962: Remove remaining direct register cache accesses
Date: Fri,  2 Aug 2013 18:07:26 +0800
Message-Id: <20130802100227.442170077@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <b42378@freescale.com>

commit 2e7ee15ced914e109a1a5b6dfcd463d846a13bd5 upstream.

Also fix return values for headphone switch updates.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8962.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1600,7 +1600,6 @@ static int wm8962_put_hp_sw(struct snd_k
 			    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -1609,16 +1608,19 @@ static int wm8962_put_hp_sw(struct snd_k
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
@@ -3374,7 +3376,6 @@ static int wm8962_probe(struct snd_soc_c
 	int ret;
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
 	struct wm8962_pdata *pdata = dev_get_platdata(codec->dev);
-	u16 *reg_cache = codec->reg_cache;
 	int i, trigger, irq_pol;
 	bool dmicclk, dmicdat;
 
@@ -3432,8 +3433,9 @@ static int wm8962_probe(struct snd_soc_c
 
 		/* Put the speakers into mono mode? */
 		if (pdata->spk_mono)
-			reg_cache[WM8962_CLASS_D_CONTROL_2]
-				|= WM8962_SPK_MONO;
+			snd_soc_update_bits(codec, WM8962_CLASS_D_CONTROL_2,
+				WM8962_SPK_MONO_MASK, WM8962_SPK_MONO);
+
 
 		/* Micbias setup, detection enable and detection
 		 * threasholds. */


