Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaCCDtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:49:46 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:41493
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236AbaCCDtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:49:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lars@metafoo.de>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 2/3] ASoC: io: New signature for snd_soc_codec_set_cache_io()
Date: Mon, 3 Mar 2014 10:42:23 +0800
Message-ID: <1393814545-15002-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users have been converted to regmap and the config.reg_bits
and config.val_bits can be setted by each user through regmap core API.
So these two params are redundant here.

Since the only control type that left is SND_SOC_REGMAP, so remove it. Drop
the control params and add struct regmap *regmap to simplify the code.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h            |  7 +------
 sound/soc/codecs/cq93vc.c      |  3 +--
 sound/soc/codecs/mc13783.c     |  4 ++--
 sound/soc/codecs/tlv320dac33.c |  1 -
 sound/soc/codecs/wm5102.c      |  4 +---
 sound/soc/codecs/wm5110.c      |  3 +--
 sound/soc/codecs/wm8350.c      |  4 +---
 sound/soc/codecs/wm8400.c      |  3 +--
 sound/soc/codecs/wm8994.c      |  3 +--
 sound/soc/codecs/wm8997.c      |  4 +---
 sound/soc/soc-core.c           |  2 +-
 sound/soc/soc-io.c             | 47 ++++++++++++++++++------------------------
 12 files changed, 31 insertions(+), 54 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index ecfb334..4c4d7e1 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -354,10 +354,6 @@ typedef int (*hw_write_t)(void *,const char* ,int);
 
 extern struct snd_ac97_bus_ops *soc_ac97_ops;
 
-enum snd_soc_control_type {
-	SND_SOC_REGMAP,
-};
-
 enum snd_soc_pcm_subclass {
 	SND_SOC_PCM_CLASS_PCM	= 0,
 	SND_SOC_PCM_CLASS_BE	= 1,
@@ -404,8 +400,7 @@ int snd_soc_codec_readable_register(struct snd_soc_codec *codec,
 int snd_soc_codec_writable_register(struct snd_soc_codec *codec,
 				    unsigned int reg);
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
-			       enum snd_soc_control_type control);
+			       struct regmap *regmap);
 int snd_soc_cache_sync(struct snd_soc_codec *codec);
 int snd_soc_cache_init(struct snd_soc_codec *codec);
 int snd_soc_cache_exit(struct snd_soc_codec *codec);
diff --git a/sound/soc/codecs/cq93vc.c b/sound/soc/codecs/cq93vc.c
index 43737a27..1e25c7a 100644
--- a/sound/soc/codecs/cq93vc.c
+++ b/sound/soc/codecs/cq93vc.c
@@ -138,9 +138,8 @@ static int cq93vc_probe(struct snd_soc_codec *codec)
 	struct davinci_vc *davinci_vc = codec->dev->platform_data;
 
 	davinci_vc->cq93vc.codec = codec;
-	codec->control_data = davinci_vc->regmap;
 
-	snd_soc_codec_set_cache_io(codec, 32, 32, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, davinci_vc->regmap);
 
 	/* Off, with power on */
 	cq93vc_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index c605036..3331cc7 100644
--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -614,8 +614,8 @@ static int mc13783_probe(struct snd_soc_codec *codec)
 	struct mc13783_priv *priv = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
-	ret = snd_soc_codec_set_cache_io(codec, 8, 24, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec,
+			dev_get_regmap(codec->dev->parent, NULL));
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/tlv320dac33.c b/sound/soc/codecs/tlv320dac33.c
index 9ce8496..30d8596 100644
--- a/sound/soc/codecs/tlv320dac33.c
+++ b/sound/soc/codecs/tlv320dac33.c
@@ -122,7 +122,6 @@ struct tlv320dac33_priv {
 	unsigned int uthr;
 
 	enum dac33_state state;
-	enum snd_soc_control_type control_type;
 	void *control_data;
 };
 
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index 293dffc..01b6ee4 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -1760,9 +1760,7 @@ static int wm5102_codec_probe(struct snd_soc_codec *codec)
 	struct wm5102_priv *priv = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = priv->core.arizona->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, priv->core.arizona->regmap);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 4de2bf1..cf5d828f 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -1587,10 +1587,9 @@ static int wm5110_codec_probe(struct snd_soc_codec *codec)
 	struct wm5110_priv *priv = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = priv->core.arizona->regmap;
 	priv->core.arizona->dapm = &codec->dapm;
 
-	ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, priv->core.arizona->regmap);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index a183dcf..757256b 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -1505,9 +1505,7 @@ static  int wm8350_codec_probe(struct snd_soc_codec *codec)
 	if (ret != 0)
 		return ret;
 
-	codec->control_data = wm8350->regmap;
-
-	snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, wm8350->regmap);
 
 	/* Put the codec into reset if it wasn't already */
 	wm8350_clear_bits(wm8350, WM8350_POWER_MGMT_5, WM8350_CODEC_ENA);
diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index 6d684d9..146564f 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -1316,10 +1316,9 @@ static int wm8400_codec_probe(struct snd_soc_codec *codec)
 
 	snd_soc_codec_set_drvdata(codec, priv);
 	priv->wm8400 = wm8400;
-	codec->control_data = wm8400->regmap;
 	priv->codec = codec;
 
-	snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, wm8400->regmap);
 
 	ret = devm_regulator_bulk_get(wm8400->dev,
 				 ARRAY_SIZE(power), &power[0]);
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 699b527..decc3c9 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3999,9 +3999,8 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 	int ret, i;
 
 	wm8994->hubs.codec = codec;
-	codec->control_data = control->regmap;
 
-	snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_REGMAP);
+	snd_soc_codec_set_cache_io(codec, control->regmap);
 
 	mutex_init(&wm8994->accdet_lock);
 	INIT_DELAYED_WORK(&wm8994->jackdet_bootstrap,
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 4e6442c..5e1a32e 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1053,9 +1053,7 @@ static int wm8997_codec_probe(struct snd_soc_codec *codec)
 	struct wm8997_priv *priv = snd_soc_codec_get_drvdata(codec);
 	int ret;
 
-	codec->control_data = priv->core.arizona->regmap;
-
-	ret = snd_soc_codec_set_cache_io(codec, 32, 16, SND_SOC_REGMAP);
+	ret = snd_soc_codec_set_cache_io(codec, priv->core.arizona->regmap);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index c159a34..6880fad 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1139,7 +1139,7 @@ static int soc_probe_codec(struct snd_soc_card *card,
 
 	/* Set the default I/O up try regmap */
 	if (dev_get_regmap(codec->dev, NULL))
-		snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+		snd_soc_codec_set_cache_io(codec, NULL);
 
 	if (driver->probe) {
 		ret = driver->probe(codec);
diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index 18353f1..8aa0869 100644
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -69,9 +69,7 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
  * snd_soc_codec_set_cache_io: Set up standard I/O functions.
  *
  * @codec: CODEC to configure.
- * @addr_bits: Number of bits of register address data.
- * @data_bits: Number of bits of data per register.
- * @control: Control bus used.
+ * @map: Register map to write to
  *
  * Register formats are frequently shared between many I2C and SPI
  * devices.  In order to promote code reuse the ASoC core provides
@@ -85,41 +83,36 @@ static unsigned int hw_read(struct snd_soc_codec *codec, unsigned int reg)
  * volatile registers.
  */
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
-			       enum snd_soc_control_type control)
+			       struct regmap *regmap)
 {
 	int ret;
 
+	/* Device has made its own regmap arrangements */
+	if (!regmap)
+		codec->control_data = dev_get_regmap(codec->dev, NULL);
+	else
+		codec->control_data = regmap;
+
+	if (IS_ERR(codec->control_data))
+		return PTR_ERR(codec->control_data);
+
 	codec->write = hw_write;
 	codec->read = hw_read;
 
-	switch (control) {
-	case SND_SOC_REGMAP:
-		/* Device has made its own regmap arrangements */
-		codec->using_regmap = true;
-		if (!codec->control_data)
-			codec->control_data = dev_get_regmap(codec->dev, NULL);
-
-		if (codec->control_data) {
-			ret = regmap_get_val_bytes(codec->control_data);
-			/* Errors are legitimate for non-integer byte
-			 * multiples */
-			if (ret > 0)
-				codec->val_bytes = ret;
-		}
-		break;
-
-	default:
-		return -EINVAL;
-	}
+	ret = regmap_get_val_bytes(codec->control_data);
+	/* Errors are legitimate for non-integer byte
+	 * multiples */
+	if (ret > 0)
+		codec->val_bytes = ret;
+
+	codec->using_regmap = true;
 
-	return PTR_ERR_OR_ZERO(codec->control_data);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_soc_codec_set_cache_io);
 #else
 int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
-			       int addr_bits, int data_bits,
-			       enum snd_soc_control_type control)
+			       struct regmap *regmap)
 {
 	return -ENOTSUPP;
 }
-- 
1.8.4


