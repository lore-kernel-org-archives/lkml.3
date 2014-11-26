Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaKZLRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:17:09 -0500
Received: from mail-bl2on0103.outbound.protection.outlook.com ([65.55.169.103]:61472
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbaKZLRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:17:07 -0500
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2014 06:17:07 EST
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH] ASoC: wm8960: LRCM operation should after software reset
Date: Wed, 26 Nov 2014 19:02:20 +0800
Message-ID: <1416999740-21805-1-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(84676001)(97736003)(33646002)(110136001)(104016003)(64706001)(19580395003)(62966003)(77156002)(6806004)(44976005)(19580405001)(93916002)(86362001)(92726001)(20776003)(92566001)(89996001)(88136002)(87936001)(87286001)(104166001)(102836001)(105606002)(95666004)(107046002)(106466001)(4396001)(50226001)(21056001)(50986999)(2351001)(229853001)(31966008)(46102003)(50466002)(48376002)(120916001)(99396003)(68736004)(47776003)(36756003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1251;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1251;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1251;
X-Forefront-PRVS: 04073E895A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1251;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When shared_lrclk is set, LRCM will be enabled. But the following software
reset in wm8960_probe will reset it to the default state. So LRCM operation
should after software reset.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index bc8793cd..21db90c 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -960,6 +960,14 @@ static int wm8960_probe(struct snd_soc_codec *codec)
 		return ret;
 	}
 
+	if (pdata->shared_lrclk) {
+		ret = snd_soc_update_bits(codec, WM8960_ADDCTL2, 0x4, 0x4);
+		if (ret < 0) {
+			dev_err(codec->dev, "Failed to enable LRCM: %d\n", ret);
+			return ret;
+		}
+	}
+
 	/* Latch the update bits */
 	snd_soc_update_bits(codec, WM8960_LINVOL, 0x100, 0x100);
 	snd_soc_update_bits(codec, WM8960_RINVOL, 0x100, 0x100);
@@ -1030,15 +1038,6 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
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
 
 	i2c_set_clientdata(i2c, wm8960);
 
-- 
1.9.1

