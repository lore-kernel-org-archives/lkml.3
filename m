Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaB0K4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:56:01 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:29888
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217AbaB0Kz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:55:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@linaro.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
Date: Thu, 27 Feb 2014 17:49:52 +0800
Message-ID: <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For most CODEC drivers which the REGMAP is used, the soc_probe_codec()
will do the stuff work of snd_soc_codec_set_cache_io(), which the CODEC
drivers' ASoC probe will do too, and almost at the same time.

This patch set the default I/O up try regmap, and then the CODEC drivers'
stuff work of snd_soc_codec_set_cache_io() will be redundant, while if one
CODEC driver needed to set it's own I/O, then it can rewrite the default ones.
Then could we just discard the snd_soc_codec_set_cache_io() from the CODEC
drivers' ASoC probe to simplify the code.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e5a535b..c159a34 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1137,6 +1137,10 @@ static int soc_probe_codec(struct snd_soc_card *card,
 
 	codec->dapm.idle_bias_off = driver->idle_bias_off;
 
+	/* Set the default I/O up try regmap */
+	if (dev_get_regmap(codec->dev, NULL))
+		snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
+
 	if (driver->probe) {
 		ret = driver->probe(codec);
 		if (ret < 0) {
@@ -1150,10 +1154,6 @@ static int soc_probe_codec(struct snd_soc_card *card,
 			codec->name);
 	}
 
-	/* If the driver didn't set I/O up try regmap */
-	if (!codec->write && dev_get_regmap(codec->dev, NULL))
-		snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-
 	if (driver->controls)
 		snd_soc_add_codec_controls(codec, driver->controls,
 				     driver->num_controls);
-- 
1.8.4


