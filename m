Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbaKTIkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:40:47 -0500
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:40124
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756129AbaKTIkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:40:46 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH v2 2/2] ASoC: wm8960: LRCM operation should after software reset
Date: Thu, 20 Nov 2014 16:41:18 +0800
Message-ID: <1416472878-12108-2-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416472878-12108-1-git-send-email-b50113@freescale.com>
References: <1416472878-12108-1-git-send-email-b50113@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(44976005)(47776003)(92726001)(68736004)(50466002)(99396003)(6806004)(120916001)(19580405001)(19580395003)(104016003)(64706001)(77156002)(62966003)(33646002)(50986999)(76176999)(31966008)(20776003)(102836001)(21056001)(92566001)(104166001)(93916002)(86362001)(87936001)(87286001)(89996001)(88136002)(48376002)(84676001)(85426001)(110136001)(2351001)(4396001)(95666004)(107046002)(36756003)(229853001)(46102003)(50226001)(106466001)(105606002)(97736003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1259;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1259;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1259;
X-Forefront-PRVS: 0401647B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1259;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When shared_lrclk is set, LRCM will be enabled. But the following software
reset in wm8960_probe will reset it to the default state. So LRCM operation
should after software reset.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index e5d89a2..a7f60b7 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -976,6 +976,14 @@ static int wm8960_probe(struct snd_soc_codec *codec)
 		return ret;
 	}
 
+    if (pdata->shared_lrclk) {
+		ret = snd_soc_update_bits(codec, WM8960_ADDCTL2, 0x4, 0x4);
+		if (ret < 0) {
+			dev_err(codec->dev, "Failed to enable LRCM: %d\n", ret);
+			return ret;
+		}
+	}
+
 	wm8960->set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	/* Latch the update bits */
@@ -1059,16 +1067,6 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 	else if (i2c->dev.of_node)
 		wm8960_set_pdata_from_of(i2c, &wm8960->pdata);
 
-	if (pdata && pdata->shared_lrclk) {
-		ret = regmap_update_bits(wm8960->regmap, WM8960_ADDCTL2,
-					 0x4, 0x4);
-		if (ret != 0) {
-			dev_err(&i2c->dev, "Failed to enable LRCM: %d\n",
-				ret);
-			return ret;
-		}
-	}
-
 	i2c_set_clientdata(i2c, wm8960);
 
 	ret = snd_soc_register_codec(&i2c->dev,
-- 
1.9.1

