Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3LWFtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:49:52 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:40135
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab3LWFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:49:50 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <rob@landley.net>, <kuninori.morimoto.gx@renesas.com>,
        <fabio.estevam@freescale.com>, <alsa-devel@alsa-project.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: simple-card: Add DAPM routes parse from device tree
Date: Mon, 23 Dec 2013 12:57:01 +0800
Message-ID: <1387774621-23968-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parses a simple DAPM route table from device tree.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/simple-card.txt | 13 +++++++++++--
 sound/soc/generic/simple-card.c                         | 11 +++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index 769a346..2ee80c76 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -9,8 +9,13 @@ Required properties:
 Optional properties:
 
 - simple-audio-card,format		: CPU/CODEC common audio format.
-					"i2s", "right_j", "left_j" , "dsp_a"
-					"dsp_b", "ac97", "pdm", "msb", "lsb"
+					  "i2s", "right_j", "left_j" , "dsp_a"
+					  "dsp_b", "ac97", "pdm", "msb", "lsb"
+- simple-audio-routing			: A list of the connections between audio components.
+					  Each entry is a pair of strings, the first being the
+					  connection's sink, the second being the connection's
+					  source.
+
 Required subnodes:
 
 - simple-audio-card,cpu			: CPU   sub-node
@@ -38,6 +43,10 @@ Example:
 sound {
 	compatible = "simple-audio-card";
 	simple-audio-card,format = "left_j";
+	simple-audio-routing =
+		"MIC_IN", "Mic Jack",
+		"Headphone Jack", "HP_OUT",
+		"Ext Spk", "LINE_OUT";
 
 	simple-audio-card,cpu {
 		sound-dai = <&sh_fsi2 0>;
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 1d87db8..643c9ed 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -116,12 +116,18 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 {
 	struct device_node *np;
 	char *name;
-	int ret = 0;
+	int ret;
 
 	/* get CPU/CODEC common format via simple-audio-card,format */
 	info->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
 		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);
 
+	/* DAPM routes */
+	ret = snd_soc_of_parse_audio_routing(&info->snd_card,
+					"simple-audio-routing");
+	if (ret)
+		return ret;
+
 	/* CPU sub-node */
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
@@ -185,6 +191,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
 		if (cinfo) {
 			int ret;
+			cinfo->snd_card.dev = &pdev->dev;
 			ret = asoc_simple_card_parse_of(np, cinfo, dev,
 							&of_cpu,
 							&of_codec,
@@ -196,6 +203,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 			}
 		}
 	} else {
+		cinfo->snd_card.dev = &pdev->dev;
 		cinfo = pdev->dev.platform_data;
 	}
 
@@ -235,7 +243,6 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	cinfo->snd_card.owner		= THIS_MODULE;
 	cinfo->snd_card.dai_link	= &cinfo->snd_link;
 	cinfo->snd_card.num_links	= 1;
-	cinfo->snd_card.dev		= &pdev->dev;
 
 	return devm_snd_soc_register_card(&pdev->dev, &cinfo->snd_card);
 }
-- 
1.8.4


