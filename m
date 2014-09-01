Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaIAC1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:27:07 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:4578
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752209AbaIAC1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:27:03 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <moinejf@free.fr>, <kuninori.morimoto.gx@renesas.com>,
        <jsarha@ti.com>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/2] ASoC: simple-card: Fix bug of wrong decrement DT node's refcount
Date: Mon, 1 Sep 2014 09:35:27 +0800
Message-ID: <1409535327-11449-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(62966002)(19580395003)(89996001)(19580405001)(104166001)(105606002)(74502001)(102836001)(81542001)(80022001)(69596002)(92726001)(83322001)(87286001)(79102001)(104016003)(2201001)(50226001)(4396001)(87936001)(50466002)(106466001)(76482001)(68736004)(92566001)(44976005)(81342001)(64706001)(86362001)(93916002)(6806004)(99396002)(21056001)(95666004)(48376002)(20776003)(47776003)(26826002)(97736001)(31966008)(76176999)(46102001)(50986999)(229853001)(107046002)(74662001)(81156004)(36756003)(84676001)(90102001)(77982001)(85852003)(77156001)(88136002)(85306004)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DAI links's cpu_of_node's and codec_of_node's refcounts shouldn't
be decremented immediately at the end of the probe() fucntion.
Because we will still use them before the audio card is removed.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 52 ++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 9e170fe..08c5d7d 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -307,6 +307,22 @@ dai_link_of_err:
 	return ret;
 }
 
+static inline void
+asoc_simple_card_unref(const struct snd_soc_dai_link *dai_link,
+		       int num_links)
+{
+	struct device_node *np;
+
+	while (num_links--) {
+		np = dai_link[num_links].cpu_of_node;
+		if (np)
+			of_node_put(np);
+		np = dai_link[num_links].codec_of_node;
+		if (np)
+			of_node_put(np);
+	}
+}
+
 static int asoc_simple_card_parse_of(struct device_node *node,
 				     struct simple_card_data *priv,
 				     struct device *dev,
@@ -355,6 +371,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 							   dai_props + i,
 							   false);
 			if (ret < 0) {
+				asoc_simple_card_unref(dai_link, i + 1);
 				of_node_put(np);
 				return ret;
 			}
@@ -374,27 +391,6 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	return 0;
 }
 
-/* update the reference count of the devices nodes at end of probe */
-static int asoc_simple_card_unref(struct platform_device *pdev)
-{
-	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct snd_soc_dai_link *dai_link;
-	struct device_node *np;
-	int num_links;
-
-	for (num_links = 0, dai_link = card->dai_link;
-	     num_links < card->num_links;
-	     num_links++, dai_link++) {
-		np = (struct device_node *) dai_link->cpu_of_node;
-		if (np)
-			of_node_put(np);
-		np = (struct device_node *) dai_link->codec_of_node;
-		if (np)
-			of_node_put(np);
-	}
-	return 0;
-}
-
 static int asoc_simple_card_probe(struct platform_device *pdev)
 {
 	struct simple_card_data *priv;
@@ -441,7 +437,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
-			goto err;
+			return ret;
 		}
 
 	} else {
@@ -483,11 +479,18 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
 
-err:
-	asoc_simple_card_unref(pdev);
 	return ret;
 }
 
+static int asoc_simple_card_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	asoc_simple_card_unref(card->dai_link, card->num_links);
+
+	return 0;
+}
+
 static const struct of_device_id asoc_simple_of_match[] = {
 	{ .compatible = "simple-audio-card", },
 	{},
@@ -501,6 +504,7 @@ static struct platform_driver asoc_simple_card = {
 		.of_match_table = asoc_simple_of_match,
 	},
 	.probe = asoc_simple_card_probe,
+	.remove = asoc_simple_card_remove,
 };
 
 module_platform_driver(asoc_simple_card);
-- 
1.8.4

