Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaICDPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:15:14 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:15514
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753853AbaICDPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:15:09 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 1/3] ASoC: simple-card: Merge single and muti DAI link(s) code.
Date: Wed, 3 Sep 2014 10:23:39 +0800
Message-ID: <1409711021-19277-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(19580395003)(104166001)(19580405001)(89996001)(87936001)(6806004)(81542001)(80022001)(69596002)(92726001)(83322001)(62966002)(64706001)(76482001)(104016003)(50466002)(44976005)(2201001)(106466001)(92566001)(81342001)(4396001)(86362001)(99396002)(68736004)(87286001)(93916002)(50226001)(79102001)(21056001)(48376002)(95666004)(47776003)(20776003)(26826002)(31966008)(97736001)(76176999)(46102001)(50986999)(74502001)(229853001)(102836001)(90102001)(85852003)(74662001)(77982001)(81156004)(36756003)(85306004)(105606002)(77156001)(88136002)(84676001)(107046002)(83072002)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will split the DT node into old style and new style:
The new style will merge the single DAI link and muti DAI links code
together, the new style will be easier to add muti DAI links from old
single DAI link DTs.

This patch will maintian compatibility with the old DTs.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 986d2c7..1597a24 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -178,6 +178,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	char *prefix = "";
 	int ret;
 
+	/* For single DAI link & old style of DT node */
 	if (is_top_level_node)
 		prefix = "simple-audio-card,";
 
@@ -309,14 +310,16 @@ dai_link_of_err:
 
 static int asoc_simple_card_parse_of(struct device_node *node,
 				     struct simple_card_data *priv,
-				     struct device *dev,
-				     int multi)
+				     struct device *dev)
 {
 	struct snd_soc_dai_link *dai_link = priv->snd_card.dai_link;
 	struct simple_dai_props *dai_props = priv->dai_props;
 	u32 val;
 	int ret;
 
+	if (!node)
+		return -EINVAL;
+
 	/* parsing the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
 
@@ -344,7 +347,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	dev_dbg(dev, "New simple-card: %s\n", priv->snd_card.name ?
 		priv->snd_card.name : "");
 
-	if (multi) {
+	/* Single/Muti DAI link(s) & New style of DT node */
+	if (of_get_child_by_name(node, "simple-audio-card,dai-link")) {
 		struct device_node *np = NULL;
 		int i = 0;
 
@@ -361,6 +365,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			i++;
 		}
 	} else {
+		/* For single DAI link & old style of DT node */
 		ret = asoc_simple_card_dai_link_of(node, dev,
 						   dai_link, dai_props, true);
 		if (ret < 0)
@@ -400,16 +405,13 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
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
+	else
 		num_links = 1;
-		multi = 0;
-	}
 
 	/* allocate the private data and the DAI link array */
 	priv = devm_kzalloc(dev,
@@ -436,7 +438,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 	if (np && of_device_is_available(np)) {
 
-		ret = asoc_simple_card_parse_of(np, priv, dev, multi);
+		ret = asoc_simple_card_parse_of(np, priv, dev);
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
-- 
1.8.4

