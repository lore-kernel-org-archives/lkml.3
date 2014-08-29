Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaH2GxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:53:17 -0400
Received: from [207.46.163.181] ([207.46.163.181]:4513 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752642AbaH2GxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:53:15 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jean-Francois Moine <moinejf@free.fr>, Jyri Sarha <jsarha@ti.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>
Subject: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link code.
Date: Fri, 29 Aug 2014 14:46:37 +0800
Message-ID: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(105606002)(69596002)(19580405001)(83322001)(50986999)(104016003)(81542001)(87286001)(107046002)(229853001)(19580395003)(31966008)(50466002)(84676001)(48376002)(74662001)(68736004)(62966002)(44976005)(81156004)(74502001)(86362001)(106466001)(99396002)(6806004)(92726001)(77156001)(76482001)(4396001)(26826002)(20776003)(80022001)(64706001)(90102001)(77982001)(575784001)(85306004)(36756003)(97736001)(87936001)(81342001)(95666004)(85852003)(93916002)(46102001)(47776003)(50226001)(83072002)(104166001)(79102001)(88136002)(21056001)(102836001)(89996001)(92566001)(15866825004)(21314002);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0618;H:az84smr01.freescale.net;FPR:;MLV:ovr;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merge single DAI link and muti-DAI links code together,
and simply the simple-card driver code.

And also do some other improvement:

Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
frame clock is as master/slave.

So these same DAI formats should be informed to CPU and CODE DAIs at
the same time. For the Codec driver will set the bit clock and frame
clock as the DAI formats said, but for the CPU driver, if the the
bit clock or frame clock is as Codec master, so it should be set CPU
DAI device as bit clock or frame clock as slave, and vice versa.

The old code will cause confusion, and we should be clear that the
letter 'C' here mean to Codec.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>
---

Hi,

This patch will break the old DT, so i just send one RFC version, and
will add the old DT patches in next version if this patch can work
well.

Any comments and advices are welcome.



 .../devicetree/bindings/sound/simple-card.txt      |  98 ++++++++-------
 sound/soc/generic/simple-card.c                    | 135 ++++++---------------
 2 files changed, 88 insertions(+), 145 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index c2e9841..457fd0b 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -1,13 +1,12 @@
 Simple-Card:
 
+====
 Simple-Card specifies audio DAI connections of SoC <-> codec.
 
 Required properties:
-
 - compatible				: "simple-audio-card"
 
 Optional properties:
-
 - simple-audio-card,name		: User specified audio sound card name, one string
 					  property.
 - simple-audio-card,widgets		: Please refer to widgets.txt.
@@ -18,68 +17,57 @@ Optional properties:
 - simple-audio-card,mclk-fs             : Multiplication factor between stream rate and codec
   					  mclk.
 
-Optional subnodes:
-
-- simple-audio-card,dai-link		: Container for dai-link level
-					  properties and the CPU and CODEC
-					  sub-nodes. This container may be
-					  omitted when the card has only one
-					  DAI link. See the examples and the
-					  section bellow.
-
-Dai-link subnode properties and subnodes:
-
-If dai-link subnode is omitted and the subnode properties are directly
-under "sound"-node the subnode property and subnode names have to be
-prefixed with "simple-audio-card,"-prefix.
+====
+DAI link node(s) and its or their subnodes:
 
-Required dai-link subnodes:
+There must be one DAI link node exsit at least, and each DAI link must
+contain one CPU subnode and one CODEC subnode.
 
-- cpu					: CPU   sub-node
-- codec					: CODEC sub-node
-
-Optional dai-link subnode properties:
+Required DAI link node(s):
+- simple-audio-card,dai-link		: Container for DAI link level
+					  properties and the CPU and CODEC
+					  sub-nodes.
 
+Optional DAI link node properties:
 - format				: CPU/CODEC common audio format.
 					  "i2s", "right_j", "left_j" , "dsp_a"
 					  "dsp_b", "ac97", "pdm", "msb", "lsb"
-- frame-master				: Indicates dai-link frame master.
-					  phandle to a cpu or codec subnode.
-- bitclock-master			: Indicates dai-link bit clock master.
-					  phandle to a cpu or codec subnode.
-- bitclock-inversion			: bool property. Add this if the
-					  dai-link uses bit clock inversion.
-- frame-inversion			: bool property. Add this if the
-					  dai-link uses frame clock inversion.
-
-For backward compatibility the frame-master and bitclock-master
-properties can be used as booleans in codec subnode to indicate if the
-codec is the dai-link frame or bit clock master. In this case there
-should be no dai-link node, the same properties should not be present
-at sound-node level, and the bitclock-inversion and frame-inversion
-properties should also be placed in the codec node if needed.
-
-Required CPU/CODEC subnodes properties:
-
-- sound-dai				: phandle and port of CPU/CODEC
+- frame-master				: Boolean property. If present, for this
+					  DAI link the Codec DAI's frame will be
+					  as master and the CPU DAI's frame will
+					  be as slave, or vice versa.
+- bitclock-master			: Boolean property. If present, for this
+					  DAI link the Codec DAI's bit clock will
+					  be as master and the CPU DAI's bit clock
+					  will be as slave, or vice versa.
+====
+DAI link's subnodes and their properties:
+
+Required DAI link subnodes:
+- cpu					: CPU   sub-node
+- codec					: CODEC sub-node
 
-Optional CPU/CODEC subnodes properties:
+Required DAI link subnodes' properties:
+- sound-dai				: Phandle and port of CPU/CODEC
 
+Optional DAI link subnodes' properties:
+- bitclock-inversion			: Boolean property. Add this if the DAI
+					  device needs bit clock to be inversed.
+- frame-inversion			: Boolean property. Add this if the DAI
+					  device needs frame clock to be inversed.
 - dai-tdm-slot-num			: Please refer to tdm-slot.txt.
 - dai-tdm-slot-width			: Please refer to tdm-slot.txt.
 - clocks / system-clock-frequency	: specify subnode's clock if needed.
 					  it can be specified via "clocks" if system has
 					  clock node (= common clock), or "system-clock-frequency"
 					  (if system doens't support common clock)
+====
 
 Example 1 - single DAI link:
 
 sound {
 	compatible = "simple-audio-card";
 	simple-audio-card,name = "VF610-Tower-Sound-Card";
-	simple-audio-card,format = "left_j";
-	simple-audio-card,bitclock-master = <&dailink0_master>;
-	simple-audio-card,frame-master = <&dailink0_master>;
 	simple-audio-card,widgets =
 		"Microphone", "Microphone Jack",
 		"Headphone", "Headphone Jack",
@@ -89,13 +77,23 @@ sound {
 		"Headphone Jack", "HP_OUT",
 		"External Speaker", "LINE_OUT";
 
-	simple-audio-card,cpu {
-		sound-dai = <&sh_fsi2 0>;
-	};
+	simple-audio-card,dai-link {
+		format = "left_j";
+		cpu {
+			sound-dai = <&sh_fsi2 0>;
+
+			bitclock-inversion;
+			frame-inversion;
+		};
+		codec {
+			sound-dai = <&ak4648>;
+			clocks = <&osc>;
+
+			bitclock-inversion;
+		};
 
-	dailink0_master: simple-audio-card,codec {
-		sound-dai = <&ak4648>;
-		clocks = <&osc>;
+		bitclock-master;
+		frame-master;
 	};
 };
 
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 21b0ea2..a0d3622 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -112,13 +112,20 @@ static int
 asoc_simple_card_sub_parse_of(struct device_node *np,
 			      struct asoc_simple_dai *dai,
 			      struct device_node **p_node,
-			      const char **name)
+			      const char **name,
+			      unsigned int *daifmt)
 {
 	struct device_node *node;
 	struct clk *clk;
 	u32 val;
 	int ret;
 
+	if (!daifmt)
+		return -EINVAL;
+
+	*daifmt = snd_soc_of_parse_daifmt(np, NULL, NULL, NULL);
+	*daifmt &= ~SND_SOC_DAIFMT_MASTER_MASK;
+
 	/*
 	 * get node via "sound-dai = <&phandle port>"
 	 * it will be used as xxx_of_node on soc_bind_dai_link()
@@ -166,102 +173,55 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 static int simple_card_dai_link_of(struct device_node *node,
 				   struct device *dev,
 				   struct snd_soc_dai_link *dai_link,
-				   struct simple_dai_props *dai_props,
-				   bool is_top_level_node)
+				   struct simple_dai_props *dai_props)
 {
 	struct device_node *np = NULL;
-	struct device_node *bitclkmaster = NULL;
-	struct device_node *framemaster = NULL;
 	unsigned int daifmt;
 	char *name;
-	char prop[128];
-	char *prefix = "";
 	int ret;
 
-	if (is_top_level_node)
-		prefix = "simple-audio-card,";
-
-	daifmt = snd_soc_of_parse_daifmt(node, prefix,
-					 &bitclkmaster, &framemaster);
-	daifmt &= ~SND_SOC_DAIFMT_MASTER_MASK;
+	daifmt = snd_soc_of_parse_daifmt(node, NULL, NULL, NULL);
+	daifmt &= SND_SOC_DAIFMT_MASTER_MASK;
+	dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt = daifmt;
 
-	snprintf(prop, sizeof(prop), "%scpu", prefix);
-	np = of_get_child_by_name(node, prop);
+	np = of_get_child_by_name(node, "cpu");
 	if (!np) {
 		ret = -EINVAL;
-		dev_err(dev, "%s: Can't find %s DT node\n", __func__, prop);
+		dev_err(dev, "%s: Can't find cpu DT node\n", __func__);
 		goto dai_link_of_err;
 	}
 
 	ret = asoc_simple_card_sub_parse_of(np, &dai_props->cpu_dai,
 					    &dai_link->cpu_of_node,
-					    &dai_link->cpu_dai_name);
+					    &dai_link->cpu_dai_name,
+					    &daifmt);
 	if (ret < 0)
 		goto dai_link_of_err;
 
-	dai_props->cpu_dai.fmt = daifmt;
-	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
-	case 0x11:
-		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBS_CFS;
-		break;
-	case 0x10:
-		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBS_CFM;
-		break;
-	case 0x01:
-		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBM_CFS;
-		break;
-	default:
-		dai_props->cpu_dai.fmt |= SND_SOC_DAIFMT_CBM_CFM;
-		break;
-	}
-
+	dai_props->cpu_dai.fmt |= daifmt;
 	of_node_put(np);
-	snprintf(prop, sizeof(prop), "%scodec", prefix);
-	np = of_get_child_by_name(node, prop);
+
+	np = of_get_child_by_name(node, "codec");
 	if (!np) {
 		ret = -EINVAL;
-		dev_err(dev, "%s: Can't find %s DT node\n", __func__, prop);
+		dev_err(dev, "%s: Can't find codec DT node\n", __func__);
 		goto dai_link_of_err;
 	}
 
 	ret = asoc_simple_card_sub_parse_of(np, &dai_props->codec_dai,
 					    &dai_link->codec_of_node,
-					    &dai_link->codec_dai_name);
+					    &dai_link->codec_dai_name,
+					    &daifmt);
 	if (ret < 0)
 		goto dai_link_of_err;
 
-	if (strlen(prefix) && !bitclkmaster && !framemaster) {
-		/* No dai-link level and master setting was not found from
-		   sound node level, revert back to legacy DT parsing and
-		   take the settings from codec node. */
-		dev_dbg(dev, "%s: Revert to legacy daifmt parsing\n",
-			__func__);
-		dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt =
-			snd_soc_of_parse_daifmt(np, NULL, NULL, NULL) |
-			(daifmt & ~SND_SOC_DAIFMT_CLOCK_MASK);
-	} else {
-		dai_props->codec_dai.fmt = daifmt;
-		switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
-		case 0x11:
-			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBM_CFM;
-			break;
-		case 0x10:
-			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBM_CFS;
-			break;
-		case 0x01:
-			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBS_CFM;
-			break;
-		default:
-			dai_props->codec_dai.fmt |= SND_SOC_DAIFMT_CBS_CFS;
-			break;
-		}
-	}
-
 	if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name) {
 		ret = -EINVAL;
 		goto dai_link_of_err;
 	}
 
+	dai_props->codec_dai.fmt |= daifmt;
+
 	/* simple-card assumes platform == cpu */
 	dai_link->platform_of_node = dai_link->cpu_of_node;
 
@@ -288,22 +248,18 @@ static int simple_card_dai_link_of(struct device_node *node,
 dai_link_of_err:
 	if (np)
 		of_node_put(np);
-	if (bitclkmaster)
-		of_node_put(bitclkmaster);
-	if (framemaster)
-		of_node_put(framemaster);
 	return ret;
 }
 
 static int asoc_simple_card_parse_of(struct device_node *node,
 				     struct simple_card_data *priv,
-				     struct device *dev,
-				     int multi)
+				     struct device *dev)
 {
 	struct snd_soc_dai_link *dai_link = priv->snd_card.dai_link;
 	struct simple_dai_props *dai_props = priv->dai_props;
+	struct device_node *np = NULL;
 	u32 val;
-	int ret;
+	int ret, i;
 
 	/* parsing the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
@@ -332,23 +288,15 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	dev_dbg(dev, "New simple-card: %s\n", priv->snd_card.name ?
 		priv->snd_card.name : "");
 
-	if (multi) {
-		struct device_node *np = NULL;
-		int i;
-		for (i = 0; (np = of_get_next_child(node, np)); i++) {
-			dev_dbg(dev, "\tlink %d:\n", i);
-			ret = simple_card_dai_link_of(np, dev, dai_link + i,
-						      dai_props + i, false);
-			if (ret < 0) {
-				of_node_put(np);
-				return ret;
-			}
-		}
-	} else {
-		ret = simple_card_dai_link_of(node, dev, dai_link, dai_props,
-					      true);
-		if (ret < 0)
+	/* Parse DAI link(s) */
+	for (i = 0; (np = of_get_next_child(node, np)); i++) {
+		dev_dbg(dev, "\tlink %d:\n", i);
+		ret = simple_card_dai_link_of(np, dev, dai_link + i,
+					      dai_props + i);
+		if (ret < 0) {
+			of_node_put(np);
 			return ret;
+		}
 	}
 
 	if (!priv->snd_card.name)
@@ -384,16 +332,13 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct snd_soc_dai_link *dai_link;
 	struct device_node *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
-	int num_links, multi, ret;
+	int num_links, ret;
 
 	/* get the number of DAI links */
-	if (np && of_get_child_by_name(np, "simple-audio-card,dai-link")) {
+	if (np && of_get_child_by_name(np, "simple-audio-card,dai-link"))
 		num_links = of_get_child_count(np);
-		multi = 1;
-	} else {
-		num_links = 1;
-		multi = 0;
-	}
+	else
+		return -EINVAL;
 
 	/* allocate the private data and the DAI link array */
 	priv = devm_kzalloc(dev,
@@ -420,7 +365,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 	if (np && of_device_is_available(np)) {
 
-		ret = asoc_simple_card_parse_of(np, priv, dev, multi);
+		ret = asoc_simple_card_parse_of(np, priv, dev);
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
-- 
1.8.5

