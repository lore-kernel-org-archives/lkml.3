Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaBNCix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:38:53 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:47961
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbaBNCiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:38:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zze0eahc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <lars@metafoo.de>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <b47053@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH v3 3/3] ASoC: simple-card: add slot information parsing supports
Date: Fri, 14 Feb 2014 09:34:36 +0800
Message-ID: <1392341676-4143-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
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
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@linaro.org>
---
 .../devicetree/bindings/sound/simple-card.txt          |  5 +++++
 include/sound/simple_card.h                            |  2 ++
 sound/soc/generic/simple-card.c                        | 18 ++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index 0527358..b30c222 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -18,6 +18,8 @@ Optional properties:
 					  Each entry is a pair of strings, the first being the
 					  connection's sink, the second being the connection's
 					  source.
+- dai-tdm-slot-num			: Please refer to tdm-slot.txt.
+- dai-tdm-slot-width			: Please refer to tdm-slot.txt.
 
 Required subnodes:
 
@@ -56,6 +58,9 @@ sound {
 		"Headphone Jack", "HP_OUT",
 		"External Speaker", "LINE_OUT";
 
+	dai-tdm-slot-num = <2>;
+	dai-tdm-slot-width = <8>;
+
 	simple-audio-card,cpu {
 		sound-dai = <&sh_fsi2 0>;
 	};
diff --git a/include/sound/simple_card.h b/include/sound/simple_card.h
index e1ac996..9b0ac77 100644
--- a/include/sound/simple_card.h
+++ b/include/sound/simple_card.h
@@ -18,6 +18,8 @@ struct asoc_simple_dai {
 	const char *name;
 	unsigned int fmt;
 	unsigned int sysclk;
+	int slots;
+	int slot_width;
 };
 
 struct asoc_simple_card_info {
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 4fe8abc..bdd176d 100644
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
@@ -44,6 +47,16 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 		}
 	}
 
+	if (set->slots) {
+		ret = snd_soc_dai_set_tdm_slot(dai, 0, 0,
+						set->slots,
+						set->slot_width);
+		if (ret && ret != -ENOTSUPP) {
+			dev_err(dai->dev, "simple-card: set_tdm_slot error\n");
+			goto err;
+		}
+	}
+
 	ret = 0;
 
 err:
@@ -94,6 +107,11 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	if (ret < 0)
 		goto parse_error;
 
+	/* parse TDM slot */
+	ret = snd_soc_of_parse_tdm_slot(np, &dai->slots, &dai->slot_width);
+	if (ret)
+		goto parse_error;
+
 	/*
 	 * bitclock-inversion, frame-inversion
 	 * bitclock-master,    frame-master
-- 
1.8.4


