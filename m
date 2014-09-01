Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaIAFVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:13 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:53858
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbaIAFVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:10 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>
Subject: [PATCHv1 1/7] ASoC: simple-card: Merge single and muti DAI link code.
Date: Mon, 1 Sep 2014 12:29:35 +0800
Message-ID: <1409545781-20530-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(106466001)(62966002)(64706001)(81342001)(74502001)(50226001)(87936001)(86362001)(80022001)(81542001)(31966008)(229853001)(4396001)(83072002)(90102001)(79102001)(68736004)(97736001)(6806004)(77982001)(105606002)(84676001)(88136002)(20776003)(107046002)(48376002)(26826002)(50466002)(76176999)(85852003)(77156001)(93916002)(104166001)(69596002)(81156004)(104016003)(95666004)(44976005)(50986999)(92566001)(21056001)(76482001)(74662001)(19580405001)(46102001)(36756003)(99396002)(89996001)(102836001)(92726001)(19580395003)(47776003)(85306004)(83322001)(87286001)(2201001)(15866825004)(21314002)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0613;H:az84smr01.freescale.net;FPR:;MLV:ovr;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
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
 .../devicetree/bindings/sound/simple-card.txt      | 101 +++++++-------
 sound/soc/generic/simple-card.c                    | 152 +++++++--------------
 2 files changed, 102 insertions(+), 151 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index c2e9841..6cc44a6a 100644
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
+		bitclock-master;
+		frame-master;
+
+		cpu {
+			sound-dai = <&sh_fsi2 0>;
 
-	dailink0_master: simple-audio-card,codec {
-		sound-dai = <&ak4648>;
-		clocks = <&osc>;
+			bitclock-inversion;
+			frame-inversion;
+		};
+		codec {
+			sound-dai = <&ak4648>;
+			clocks = <&osc>;
+
+			bitclock-inversion;
+		};
 	};
 };
 
@@ -123,6 +121,9 @@ sound {
 
 	simple-audio-card,dai-link@0 {		/* I2S - HDMI */
 		format = "i2s";
+		bitclock-master;
+		frame-master;
+
 		cpu {
 			sound-dai = <&audio1 0>;
 		};
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 08c5d7d..d45c8dd 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -112,13 +112,24 @@ static int
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
+	/*
+	 * Parse format, bitclock-inversion and frame-inversion
+	 * for DAI each device.
+	 */
+	*daifmt = snd_soc_of_parse_daifmt(np, NULL, NULL, NULL);
+	*daifmt &= ~(SND_SOC_DAIFMT_MASTER_MASK | SND_SOC_DAIFMT_FORMAT_MASK);
+
 	/*
 	 * get node via "sound-dai = <&phandle port>"
 	 * it will be used as xxx_of_node on soc_bind_dai_link()
@@ -166,102 +177,58 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 static int asoc_simple_card_dai_link_of(struct device_node *node,
 					struct device *dev,
 					struct snd_soc_dai_link *dai_link,
-					struct simple_dai_props *dai_props,
-					bool is_top_level_node)
+					struct simple_dai_props *dai_props)
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
+	/* Parse bitclock-master and frame-master for DAI link */
+	daifmt = snd_soc_of_parse_daifmt(node, NULL, NULL, NULL);
+	daifmt &= (SND_SOC_DAIFMT_MASTER_MASK | SND_SOC_DAIFMT_FORMAT_MASK);
+	dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt = daifmt;
 
-	snprintf(prop, sizeof(prop), "%scpu", prefix);
-	np = of_get_child_by_name(node, prop);
+	/* Parse CPU DAI */
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
+	/* Parse CODEC DAI */
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
 
@@ -300,10 +267,6 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 dai_link_of_err:
 	if (np)
 		of_node_put(np);
-	if (bitclkmaster)
-		of_node_put(bitclkmaster);
-	if (framemaster)
-		of_node_put(framemaster);
 	return ret;
 }
 
@@ -325,13 +288,13 @@ asoc_simple_card_unref(const struct snd_soc_dai_link *dai_link,
 
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
+	int ret, i = 0;
 
 	/* parsing the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
@@ -360,30 +323,20 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	dev_dbg(dev, "New simple-card: %s\n", priv->snd_card.name ?
 		priv->snd_card.name : "");
 
-	if (multi) {
-		struct device_node *np = NULL;
-		int i = 0;
-
-		for_each_child_of_node(node, np) {
-			dev_dbg(dev, "\tlink %d:\n", i);
-			ret = asoc_simple_card_dai_link_of(np, dev,
-							   dai_link + i,
-							   dai_props + i,
-							   false);
-			if (ret < 0) {
-				asoc_simple_card_unref(dai_link, i + 1);
-				of_node_put(np);
-				return ret;
-			}
-			i++;
-		}
-		of_node_put(np);
-	} else {
-		ret = asoc_simple_card_dai_link_of(node, dev,
-						   dai_link, dai_props, true);
-		if (ret < 0)
+	/* Parse DAI link(s) */
+	for_each_child_of_node(node, np) {
+		dev_dbg(dev, "\tlink %d:\n", i);
+		ret = asoc_simple_card_dai_link_of(np, dev,
+				dai_link + i,
+				dai_props + i);
+		if (ret < 0) {
+			asoc_simple_card_unref(dai_link, i + 1);
+			of_node_put(np);
 			return ret;
+		}
+		i++;
 	}
+	of_node_put(np);
 
 	if (!priv->snd_card.name)
 		priv->snd_card.name = priv->snd_card.dai_link->name;
@@ -397,16 +350,13 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
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
@@ -433,7 +383,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 	if (np && of_device_is_available(np)) {
 
-		ret = asoc_simple_card_parse_of(np, priv, dev, multi);
+		ret = asoc_simple_card_parse_of(np, priv, dev);
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
-- 
1.8.4

