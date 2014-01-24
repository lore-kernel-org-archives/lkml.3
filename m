Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaAXIol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:44:41 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:24380
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbaAXIog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <kuninori.morimoto.gx@renesas.com>
CC: <rob@landley.net>, <perex@perex.cz>, <moinejf@free.fr>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 4/7] ASoC: simple-card: add tdm slot supports
Date: Fri, 24 Jan 2014 15:43:03 +0800
Message-ID: <1390549386-4702-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some CPU/CODEC DAI devices the tdm slot maybe needed. This patch
adds the tdm slot supporting for simple-card driver.

The style of the tdm slot in DT:

For instance:

	simple-tdm-slot = <0xffffffc 0xffffffc 2 0>;

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/simple_card.h     |  8 ++++++
 sound/soc/generic/simple-card.c | 60 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/include/sound/simple_card.h b/include/sound/simple_card.h
index e1ac996..cfc5b66 100644
--- a/include/sound/simple_card.h
+++ b/include/sound/simple_card.h
@@ -14,10 +14,18 @@
 
 #include <sound/soc.h>
 
+struct asoc_simple_tdm_slot {
+	unsigned int tx_mask;
+	unsigned int rx_mask;
+	int slots;
+	int slot_width;
+};
+
 struct asoc_simple_dai {
 	const char *name;
 	unsigned int fmt;
 	unsigned int sysclk;
+	struct asoc_simple_tdm_slot *tdm;
 };
 
 struct asoc_simple_card_info {
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 0890fcd..3177aa8 100644
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
 
+	if (set->tdm) {
+		ret = snd_soc_dai_set_tdm_slot(dai, set->tdm->tx_mask,
+						set->tdm->rx_mask,
+						set->tdm->slots,
+						set->tdm->slot_width);
+		if (ret && ret != -ENOTSUPP) {
+			dev_err(dai->dev, "simple-card: set_tdm_slot error\n");
+			goto err;
+		}
+	}
+
 	ret = 0;
 
 err:
@@ -70,11 +84,43 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 }
 
 static int
+asoc_simple_card_of_parse_tdm_slot(struct device_node *np,
+				   struct device *dev,
+				   struct asoc_simple_dai *dai,
+				   const char *propname)
+{
+	struct asoc_simple_tdm_slot *tdm;
+	u32 out_value[4];
+	int ret;
+
+	if (!of_property_read_bool(np, propname))
+		return 0;
+
+	tdm = devm_kzalloc(dev, sizeof(*tdm), GFP_KERNEL);
+	if (!tdm)
+		return -ENOMEM;
+
+	ret = of_property_read_u32_array(np, propname, out_value, 4);
+	if (ret)
+		return ret;
+
+	tdm->tx_mask = out_value[0];
+	tdm->rx_mask = out_value[1];
+	tdm->slots = out_value[2];
+	tdm->slot_width = out_value[3];
+
+	dai->tdm = tdm;
+
+	return 0;
+}
+
+static int
 asoc_simple_card_sub_parse_of(struct device_node *np,
 			      unsigned int daifmt,
 			      struct asoc_simple_dai *dai,
 			      const struct device_node **p_node,
-			      const char **name)
+			      const char **name,
+			      struct device *dev)
 {
 	struct device_node *node;
 	struct clk *clk;
@@ -94,6 +140,12 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	if (ret < 0)
 		goto parse_error;
 
+	/* parse tdm_slot */
+	ret = asoc_simple_card_of_parse_tdm_slot(np, dev, dai,
+				"simple-audio-card,tdm-slot");
+	if (ret < 0)
+		goto parse_error;
+
 	/*
 	 * bitclock-inversion, frame-inversion
 	 * bitclock-master,    frame-master
@@ -165,7 +217,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
 						  &priv->cpu_dai,
 						  &dai_link->cpu_of_node,
-						  &dai_link->cpu_dai_name);
+						  &dai_link->cpu_dai_name,
+						  dev);
 	if (ret < 0)
 		return ret;
 
@@ -176,7 +229,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
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


