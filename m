Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaIBKRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:17:41 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:13803
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750863AbaIBKRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:17:39 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/4] ASoC: simple-card: add asoc_simple_card_fmt_master() to simplify the code.
Date: Tue, 2 Sep 2014 17:26:06 +0800
Message-ID: <1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(47776003)(20776003)(84676001)(87286001)(64706001)(80022001)(26826002)(83072002)(86362001)(92566001)(88136002)(89996001)(85306004)(2201001)(85852003)(62966002)(77156001)(21056001)(36756003)(93916002)(102836001)(104016003)(92726001)(104166001)(50986999)(81342001)(46102001)(76176999)(99396002)(50466002)(48376002)(6806004)(44976005)(4396001)(50226001)(83322001)(19580405001)(19580395003)(68736004)(69596002)(97736001)(106466001)(31966008)(76482001)(107046002)(77982001)(79102001)(87936001)(74662001)(90102001)(81156004)(74502001)(81542001)(105606002)(229853001)(95666004)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0623;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 61 ++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 986d2c7..cad2b30 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -163,6 +163,26 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	return 0;
 }
 
+static inline unsigned int
+asoc_simple_card_fmt_master(struct device_node *np,
+			    struct device_node *bitclkmaster,
+			    struct device_node *framemaster)
+{
+	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
+	case 0x11:
+		return SND_SOC_DAIFMT_CBS_CFS;
+	case 0x10:
+		return SND_SOC_DAIFMT_CBS_CFM;
+	case 0x01:
+		return SND_SOC_DAIFMT_CBM_CFS;
+	default:
+		return SND_SOC_DAIFMT_CBM_CFM;
+	}
+
+	/* Shouldn't be here */
+	return -EINVAL;
+}
+
 static int asoc_simple_card_dai_link_of(struct device_node *node,
 					struct device *dev,
 					struct snd_soc_dai_link *dai_link,
@@ -172,7 +192,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	struct device_node *np = NULL;
 	struct device_node *bitclkmaster = NULL;
 	struct device_node *framemaster = NULL;
-	unsigned int daifmt;
+	unsigned int daifmt, fmt;
 	char *name;
 	char prop[128];
 	char *prefix = "";
@@ -185,6 +205,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 					 &bitclkmaster, &framemaster);
 	daifmt &= ~SND_SOC_DAIFMT_MASTER_MASK;
 
+	/* Parse CPU DAI sub-node */
 	snprintf(prop, sizeof(prop), "%scpu", prefix);
 	np = of_get_child_by_name(node, prop);
 	if (!np) {
@@ -199,23 +220,11 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
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
+	fmt = asoc_simple_card_fmt_master(np, bitclkmaster, framemaster);
+	dai_props->cpu_dai.fmt = daifmt | fmt;
 	of_node_put(np);
+
+	/* Parse CODEC DAI sub-node */
 	snprintf(prop, sizeof(prop), "%scodec", prefix);
 	np = of_get_child_by_name(node, prop);
 	if (!np) {
@@ -240,21 +249,9 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 			snd_soc_of_parse_daifmt(np, NULL, NULL, NULL) |
 			(daifmt & ~SND_SOC_DAIFMT_CLOCK_MASK);
 	} else {
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
+		fmt = asoc_simple_card_fmt_master(np, bitclkmaster,
+						  framemaster);
+		dai_props->codec_dai.fmt = daifmt | fmt;
 	}
 
 	if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name) {
-- 
1.8.4

