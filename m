Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaKSMuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:50:07 -0500
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:62272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752512AbaKSMuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:50:05 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH] ASoC: wm8960: Add shared_lrclk and capless to device tree
Date: Wed, 19 Nov 2014 20:36:08 +0800
Message-ID: <1416400568-7512-1-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(107046002)(64706001)(229853001)(20776003)(2351001)(104016003)(110136001)(33646002)(36756003)(99396003)(47776003)(120916001)(88136002)(87936001)(102836001)(87286001)(48376002)(97736003)(104166001)(85426001)(46102003)(68736004)(62966003)(50226001)(4396001)(50986999)(106466001)(89996001)(77156002)(84676001)(31966008)(86362001)(50466002)(92726001)(93916002)(105606002)(19580405001)(19580395003)(44976005)(95666004)(21056001)(92566001)(6806004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1262;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1262;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1262;
X-Forefront-PRVS: 04004D94E2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1262;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0608;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8960 codec has a wm8960_data struct which has two fields shared_lrclk and capless.
The wm8960_data is get from platform_data and it is reasonable to set it from device
tree when platform_data is null.
And when shared_lrclk is set, LRCM will be enabled. But the following software reset
in wm8960_probe will reset it to the default state. So LRCM operation should after
software reset.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 49 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 4dc4e85..1d56c90 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -125,6 +125,7 @@ struct wm8960_priv {
 	struct snd_soc_dapm_widget *out3;
 	bool deemph;
 	int playback_fs;
+	struct wm8960_data pdata;
 };
 
 #define wm8960_reset(c)	snd_soc_write(c, WM8960_RESET, 0)
@@ -961,17 +962,13 @@ static int wm8960_resume(struct snd_soc_codec *codec)
 static int wm8960_probe(struct snd_soc_codec *codec)
 {
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
-	struct wm8960_data *pdata = dev_get_platdata(codec->dev);
+	struct wm8960_data *pdata = &wm8960->pdata;
 	int ret;
 
-	wm8960->set_bias_level = wm8960_set_bias_level_out3;
-
-	if (!pdata) {
-		dev_warn(codec->dev, "No platform data supplied\n");
-	} else {
-		if (pdata->capless)
-			wm8960->set_bias_level = wm8960_set_bias_level_capless;
-	}
+	if (pdata->capless)
+		wm8960->set_bias_level = wm8960_set_bias_level_capless;
+	else
+		wm8960->set_bias_level = wm8960_set_bias_level_out3;
 
 	ret = wm8960_reset(codec);
 	if (ret < 0) {
@@ -979,6 +976,14 @@ static int wm8960_probe(struct snd_soc_codec *codec)
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
 	wm8960->set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	/* Latch the update bits */
@@ -1029,6 +1034,18 @@ static const struct regmap_config wm8960_regmap = {
 	.volatile_reg = wm8960_volatile,
 };
 
+static void wm8960_set_pdata_from_of(struct i2c_client *i2c,
+				struct wm8960_data *pdata)
+{
+	const struct device_node *np = i2c->dev.of_node;
+
+	if (of_property_read_bool(np, "capless"))
+		pdata->capless = true;
+
+	if (of_property_read_bool(np, "shared_lrclk"))
+		pdata->shared_lrclk = true;
+}
+
 static int wm8960_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -1038,6 +1055,7 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 
 	wm8960 = devm_kzalloc(&i2c->dev, sizeof(struct wm8960_priv),
 			      GFP_KERNEL);
+
 	if (wm8960 == NULL)
 		return -ENOMEM;
 
@@ -1045,15 +1063,10 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 	if (IS_ERR(wm8960->regmap))
 		return PTR_ERR(wm8960->regmap);
 
-	if (pdata && pdata->shared_lrclk) {
-		ret = regmap_update_bits(wm8960->regmap, WM8960_ADDCTL2,
-					 0x4, 0x4);
-		if (ret != 0) {
-			dev_err(&i2c->dev, "Failed to enable LRCM: %d\n",
-				ret);
-			return ret;
-		}
-	}
+	if (pdata)
+		memcpy(&wm8960->pdata, pdata, sizeof(struct wm8960_data));
+	else if (i2c->dev.of_node)
+		wm8960_set_pdata_from_of(i2c, &wm8960->pdata);
 
 	i2c_set_clientdata(i2c, wm8960);
 
-- 
1.9.1

