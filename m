Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaK0JYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:24:54 -0500
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:8017
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755288AbaK0JYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:24:51 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH] ASoC: wm8960: Move register initialisation to I2C driver probe()
Date: Thu, 27 Nov 2014 16:53:08 +0800
Message-ID: <1417078388-1289-1-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(50466002)(48376002)(33646002)(77156002)(104016003)(31966008)(97736003)(105606002)(95666004)(106466001)(88136002)(107046002)(229853001)(2351001)(21056001)(62966003)(89996001)(87936001)(110136001)(104166001)(102836001)(50986999)(86362001)(93916002)(92566001)(92726001)(44976005)(6806004)(68736004)(19580395003)(19580405001)(46102003)(87286001)(20776003)(64706001)(47776003)(84676001)(4396001)(36756003)(50226001)(120916001)(99396003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1253;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1253;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1253;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1253;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must ensure that the clocking configuration is valid as rapidly as possible.
And do software reset before the others registers updates, or the registers
will be reset to the default state.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index bc8793cd..031a1ae 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -128,7 +128,7 @@ struct wm8960_priv {
 	struct wm8960_data pdata;
 };
 
-#define wm8960_reset(c)	snd_soc_write(c, WM8960_RESET, 0)
+#define wm8960_reset(c)	regmap_write(c, WM8960_RESET, 0)
 
 /* enumerated controls */
 static const char *wm8960_polarity[] = {"No Inversion", "Left Inverted",
@@ -947,31 +947,12 @@ static int wm8960_probe(struct snd_soc_codec *codec)
 {
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
 	struct wm8960_data *pdata = &wm8960->pdata;
-	int ret;
 
 	if (pdata->capless)
 		wm8960->set_bias_level = wm8960_set_bias_level_capless;
 	else
 		wm8960->set_bias_level = wm8960_set_bias_level_out3;
 
-	ret = wm8960_reset(codec);
-	if (ret < 0) {
-		dev_err(codec->dev, "Failed to issue reset\n");
-		return ret;
-	}
-
-	/* Latch the update bits */
-	snd_soc_update_bits(codec, WM8960_LINVOL, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_RINVOL, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_LADC, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_RADC, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_LDAC, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_RDAC, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_LOUT1, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_ROUT1, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_LOUT2, 0x100, 0x100);
-	snd_soc_update_bits(codec, WM8960_ROUT2, 0x100, 0x100);
-
 	snd_soc_add_codec_controls(codec, wm8960_snd_controls,
 				     ARRAY_SIZE(wm8960_snd_controls));
 	wm8960_add_widgets(codec);
@@ -1030,7 +1011,13 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 	else if (i2c->dev.of_node)
 		wm8960_set_pdata_from_of(i2c, &wm8960->pdata);
 
-	if (pdata && pdata->shared_lrclk) {
+	ret = wm8960_reset(wm8960->regmap);
+	if (ret != 0) {
+		dev_err(&i2c->dev, "Failed to issue reset\n");
+		return ret;
+	}
+
+	if (wm8960->pdata.shared_lrclk) {
 		ret = regmap_update_bits(wm8960->regmap, WM8960_ADDCTL2,
 					 0x4, 0x4);
 		if (ret != 0) {
@@ -1040,6 +1027,18 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
+	/* Latch the update bits */
+	regmap_update_bits(wm8960->regmap, WM8960_LINVOL, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_RINVOL, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_LADC, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_RADC, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_LDAC, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_RDAC, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_LOUT1, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_ROUT1, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_LOUT2, 0x100, 0x100);
+	regmap_update_bits(wm8960->regmap, WM8960_ROUT2, 0x100, 0x100);
+
 	i2c_set_clientdata(i2c, wm8960);
 
 	ret = snd_soc_register_codec(&i2c->dev,
-- 
1.9.1

