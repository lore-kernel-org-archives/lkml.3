Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaIAHiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:38:11 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:6778
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751078AbaIAHiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:38:10 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <moinejf@free.fr>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>,
        <jsarha@ti.com>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3] ASoC: simple-card: Fix bug of wrong decrement DT node's refcount
Date: Mon, 1 Sep 2014 14:46:52 +0800
Message-ID: <1409554012-1427-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(77982001)(68736004)(87936001)(95666004)(2201001)(97736001)(4396001)(106466001)(74662001)(105606002)(104166001)(92566001)(86362001)(92726001)(89996001)(83322001)(44976005)(69596002)(93916002)(26826002)(48376002)(81156004)(88136002)(19580405001)(83072002)(85852003)(6806004)(79102001)(77156001)(102836001)(19580395003)(50226001)(74502001)(90102001)(84676001)(229853001)(64706001)(50986999)(36756003)(85306004)(81542001)(46102001)(107046002)(50466002)(20776003)(31966008)(76482001)(21056001)(62966002)(87286001)(99396002)(104016003)(81342001)(47776003)(80022001)(15866825004);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0624;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
Cc: Jean-Francois Moine <moinejf@free.fr>
---

Change in v3:
- Follow Jean-Francois Moine's advice.
- Remove the following patch:
  "ASoC: simple-card: Fix bug of forgetting decrement DT node's refcount"




 sound/soc/generic/simple-card.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index fd8b045..986d2c7 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -481,12 +481,19 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	snd_soc_card_set_drvdata(&priv->snd_card, priv);
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
+	if (ret >= 0)
+		return ret;
 
 err:
 	asoc_simple_card_unref(pdev);
 	return ret;
 }
 
+static int asoc_simple_card_remove(struct platform_device *pdev)
+{
+	return asoc_simple_card_unref(pdev);
+}
+
 static const struct of_device_id asoc_simple_of_match[] = {
 	{ .compatible = "simple-audio-card", },
 	{},
@@ -500,6 +507,7 @@ static struct platform_driver asoc_simple_card = {
 		.of_match_table = asoc_simple_of_match,
 	},
 	.probe = asoc_simple_card_probe,
+	.remove = asoc_simple_card_remove,
 };
 
 module_platform_driver(asoc_simple_card);
-- 
1.8.4

