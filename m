Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaCDJdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:33:14 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:46826
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671AbaCDJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:32:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <lars@metafoo.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [RFC][PATCH 1/3] ASoC: core: Move the default regmap I/O setting to snd_soc_register_codec()
Date: Tue, 4 Mar 2014 16:25:27 +0800
Message-ID: <1393921529-28985-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393921529-28985-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393921529-28985-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the default regmap I/O setting to snd_soc_register_codec() while
the CODEC is initialising, which will be called by CODEC driver device
probe(), and then we can make set_cache_io() go away entirely from each
CODEC ASoC probe.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h  |  3 +++
 sound/soc/soc-core.c | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 4c4d7e1..94bc1c4 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -749,6 +749,9 @@ struct snd_soc_codec_driver {
 	int (*set_pll)(struct snd_soc_codec *codec, int pll_id, int source,
 		unsigned int freq_in, unsigned int freq_out);
 
+	/* codec regmap */
+	struct regmap *regmap;
+
 	/* codec IO */
 	unsigned int (*read)(struct snd_soc_codec *, unsigned int);
 	int (*write)(struct snd_soc_codec *, unsigned int, unsigned int);
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a14155b..0fb502f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4443,6 +4443,17 @@ int snd_soc_register_codec(struct device *dev,
 	codec->num_dai = num_dai;
 	mutex_init(&codec->mutex);
 
+	if (!codec->write && (codec_drv->regmap ||
+			      dev_get_regmap(codec->dev, NULL))) {
+		/* Set the default I/O up try regmap */
+		ret = snd_soc_codec_set_cache_io(codec, codec_drv->regmap);
+		if (ret < 0 && ret != -ENOTSUPP) {
+			dev_err(codec->dev,
+				"Failed to set cache I/O: %d\n", ret);
+			goto fail_codec_name;
+		}
+	}
+
 	for (i = 0; i < num_dai; i++) {
 		fixup_codec_formats(&dai_drv[i].playback);
 		fixup_codec_formats(&dai_drv[i].capture);
-- 
1.8.4


