Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3GXOKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45724 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab3GXOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicolin Chen" <b42378@freescale.com>,
        "Mark Brown" <broonie@linaro.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.312387739@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [22/85] ASoC: wm8962: Remove remaining direct register cache accesses
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <b42378@freescale.com>

commit 2e7ee15ced914e109a1a5b6dfcd463d846a13bd5 upstream.

Also fix return values for headphone switch updates.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8962.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2117,7 +2117,6 @@ static int wm8962_put_hp_sw(struct snd_k
 			    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -2126,16 +2125,19 @@ static int wm8962_put_hp_sw(struct snd_k
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
@@ -3944,7 +3946,6 @@ static int wm8962_probe(struct snd_soc_c
 	int ret;
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
 	struct wm8962_pdata *pdata = dev_get_platdata(codec->dev);
-	u16 *reg_cache = codec->reg_cache;
 	int i, trigger, irq_pol;
 	bool dmicclk, dmicdat;
 
@@ -4055,8 +4056,9 @@ static int wm8962_probe(struct snd_soc_c
 
 		/* Put the speakers into mono mode? */
 		if (pdata->spk_mono)
-			reg_cache[WM8962_CLASS_D_CONTROL_2]
-				|= WM8962_SPK_MONO;
+			snd_soc_update_bits(codec, WM8962_CLASS_D_CONTROL_2,
+				WM8962_SPK_MONO_MASK, WM8962_SPK_MONO);
+
 
 		/* Micbias setup, detection enable and detection
 		 * threasholds. */

