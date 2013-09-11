Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3ILFnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:43:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab3ILFkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:46 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Z3pZwQWSRScA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=HGIfrOyXFlIA:10 a=6ohNodAXAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=gDjHQkheYgsA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042905.485233622@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nicolin Chen <b42378@freescale.com>, Mark Brown <broonie@linaro.org>
Subject: [079/251] ASoC: wm8962: Remove remaining direct register cache accesses
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0079-ASoC-wm8962-Remove-remaining-direct-register-cache-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <b42378@freescale.com>

[ Upstream commit 2e7ee15ced914e109a1a5b6dfcd463d846a13bd5 ]

Also fix return values for headphone switch updates.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/codecs/wm8962.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index ce67200..df24c54 100644
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
@@ -3378,7 +3380,6 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 	int ret;
 	struct wm8962_priv *wm8962 = snd_soc_codec_get_drvdata(codec);
 	struct wm8962_pdata *pdata = dev_get_platdata(codec->dev);
-	u16 *reg_cache = codec->reg_cache;
 	int i, trigger, irq_pol;
 	bool dmicclk, dmicdat;
 
@@ -3436,8 +3437,9 @@ static int wm8962_probe(struct snd_soc_codec *codec)
 
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
1.7.10.4


