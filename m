Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaAPD3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:29:07 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:53625
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaAPD3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:29:04 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: simple-card: fix __asoc_simple_card_dai_init
Date: Thu, 16 Jan 2014 10:31:10 +0800
Message-ID: <1389839470-31199-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the CPU/CODEC DAI set_sysclk() is not support, the -ENOTSUPP will returnd.
Here do the check like set_fmt().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 2a1b1b5..b6014fe 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -19,22 +19,27 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 				       struct asoc_simple_dai *set,
 				       unsigned int daifmt)
 {
-	int ret = 0;
+	int ret;
 
 	daifmt |= set->fmt;
 
-	if (daifmt)
+	if (daifmt) {
 		ret = snd_soc_dai_set_fmt(dai, daifmt);
-
-	if (ret == -ENOTSUPP) {
-		dev_dbg(dai->dev, "ASoC: set_fmt is not supported\n");
-		ret = 0;
+		if (ret && ret != -ENOTSUPP) {
+			dev_err(dai->dev, "simple-card: set_fmt error\n");
+			return ret;
+		}
 	}
 
-	if (!ret && set->sysclk)
+	if (set->sysclk) {
 		ret = snd_soc_dai_set_sysclk(dai, 0, set->sysclk, 0);
+		if (ret && ret != -ENOTSUPP) {
+			dev_err(dai->dev, "simple-card: set_sysclk error\n");
+			return ret;
+		}
+	}
 
-	return ret;
+	return 0;
 }
 
 static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
-- 
1.8.4


