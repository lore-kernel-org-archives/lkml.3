Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaIBKRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:17:46 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:42522
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751180AbaIBKRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:17:43 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/4] ASoC: simple-card: Merge single and muti DAI link(s) code.
Date: Tue, 2 Sep 2014 17:26:07 +0800
Message-ID: <1409649969-15759-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(107046002)(81542001)(46102001)(50466002)(76482001)(64706001)(36756003)(85306004)(50986999)(31966008)(47776003)(87286001)(81342001)(80022001)(76176999)(99396002)(20776003)(62966002)(104016003)(104166001)(21056001)(89996001)(86362001)(92566001)(92726001)(95666004)(87936001)(2201001)(97736001)(77982001)(68736004)(106466001)(105606002)(74662001)(4396001)(84676001)(50226001)(102836001)(74502001)(229853001)(48376002)(26826002)(83322001)(44976005)(69596002)(93916002)(83072002)(79102001)(19580405001)(6806004)(77156001)(19580395003)(90102001)(81156004)(88136002)(85852003)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0624;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0322B4EDE1
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
index cad2b30..667fa49 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -198,6 +198,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	char *prefix = "";
 	int ret;
 
+	/* For single DAI link & old style of DT node */
 	if (is_top_level_node)
 		prefix = "simple-audio-card,";
 
@@ -306,14 +307,16 @@ dai_link_of_err:
 
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
 
@@ -341,7 +344,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	dev_dbg(dev, "New simple-card: %s\n", priv->snd_card.name ?
 		priv->snd_card.name : "");
 
-	if (multi) {
+	/* Single/Muti DAI link(s) & New style of DT node */
+	if (of_get_child_by_name(node, "simple-audio-card,dai-link")) {
 		struct device_node *np = NULL;
 		int i = 0;
 
@@ -358,6 +362,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			i++;
 		}
 	} else {
+		/* For single DAI link & old style of DT node */
 		ret = asoc_simple_card_dai_link_of(node, dev,
 						   dai_link, dai_props, true);
 		if (ret < 0)
@@ -397,16 +402,13 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
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
@@ -433,7 +435,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 	if (np && of_device_is_available(np)) {
 
-		ret = asoc_simple_card_parse_of(np, priv, dev, multi);
+		ret = asoc_simple_card_parse_of(np, priv, dev);
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
-- 
1.8.4

