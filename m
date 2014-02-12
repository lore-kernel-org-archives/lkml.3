Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaBLIs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:48:59 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:32222
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbaBLIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:48:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <tiwai@suse.de>, <perex@perex.cz>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 3/3] ASoC: simple-card: add slot information parsing supports
Date: Wed, 12 Feb 2014 15:45:12 +0800
Message-ID: <1392191112-27028-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some CPU/CODEC DAI devices the slot information maybe needed. This
patch adds the slot information parsing for simple-card driver.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/sound/simple-card.txt      |  1 +
 include/sound/simple_card.h                        |  1 +
 sound/soc/generic/simple-card.c                    | 35 ++++++++++++++++++++--
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index 0527358..7abf8f3 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -18,6 +18,7 @@ Optional properties:
 					  Each entry is a pair of strings, the first being the
 					  connection's sink, the second being the connection's
 					  source.
+- simple-audio-card,slot-info		: Please refer to tdm-slot.txt.
 
 Required subnodes:
 
diff --git a/include/sound/simple_card.h b/include/sound/simple_card.h
index e1ac996..d645241 100644
--- a/include/sound/simple_card.h
+++ b/include/sound/simple_card.h
@@ -18,6 +18,7 @@ struct asoc_simple_dai {
 	const char *name;
 	unsigned int fmt;
 	unsigned int sysclk;
+	struct soc_slot_info *slot;
 };
 
 struct asoc_simple_card_info {
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 4fe8abc..fd230c7 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -9,11 +9,14 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
+#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/string.h>
 #include <sound/simple_card.h>
+#include <sound/soc-dai.h>
+#include <sound/soc.h>
 
 struct simple_card_data {
 	struct snd_soc_card snd_card;
@@ -44,6 +47,17 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 		}
 	}
 
+	if (set->slot) {
+		ret = snd_soc_dai_set_tdm_slot(dai, set->slot->tx_mask,
+						set->slot->rx_mask,
+						set->slot->slots,
+						set->slot->slot_width);
+		if (ret && ret != -ENOTSUPP) {
+			dev_err(dai->dev, "simple-card: set_tdm_slot error\n");
+			goto err;
+		}
+	}
+
 	ret = 0;
 
 err:
@@ -74,7 +88,8 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 			      unsigned int daifmt,
 			      struct asoc_simple_dai *dai,
 			      const struct device_node **p_node,
-			      const char **name)
+			      const char **name,
+			      struct device *dev)
 {
 	struct device_node *node;
 	struct clk *clk;
@@ -94,6 +109,18 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	if (ret < 0)
 		goto parse_error;
 
+	/* parse TDM slot information */
+	if (of_property_read_bool(np, "simple-audio-card,slot-info")) {
+		dai->slot = devm_kzalloc(dev, sizeof(*dai->slot), GFP_KERNEL);
+		if (!dai->slot)
+			return -ENOMEM;
+
+		ret = snd_soc_of_parse_slot_info(np, dai->slot,
+				"simple-audio-card,slot-info");
+		if (ret < 0)
+			goto parse_error;
+	}
+
 	/*
 	 * bitclock-inversion, frame-inversion
 	 * bitclock-master,    frame-master
@@ -173,7 +200,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
 						  &priv->cpu_dai,
 						  &dai_link->cpu_of_node,
-						  &dai_link->cpu_dai_name);
+						  &dai_link->cpu_dai_name,
+						  dev);
 	if (ret < 0)
 		return ret;
 
@@ -184,7 +212,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
 						  &priv->codec_dai,
 						  &dai_link->codec_of_node,
-						  &dai_link->codec_dai_name);
+						  &dai_link->codec_dai_name,
+						  dev);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.4


