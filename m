Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaKTI4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:56:06 -0500
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:52352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbaKTI4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:56:04 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH v2 1/2] ASoC: wm8960: Add device tree support
Date: Thu, 20 Nov 2014 16:41:17 +0800
Message-ID: <1416472878-12108-1-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(95666004)(107046002)(2351001)(105606002)(97736003)(99396003)(33646002)(110136001)(104016003)(89996001)(87286001)(6806004)(85426001)(20776003)(47776003)(46102003)(106466001)(64706001)(229853001)(4396001)(120916001)(77156002)(62966003)(50226001)(87936001)(93916002)(92726001)(50986999)(31966008)(86362001)(92566001)(21056001)(36756003)(88136002)(102836001)(68736004)(19580395003)(104166001)(44976005)(19580405001)(48376002)(50466002)(84676001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1262;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1262;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1262;
X-Forefront-PRVS: 0401647B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1262;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1263;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the device tree binding for the WM8960 codec, and modify the
driver to extract the platform data from device tree, if present.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 Documentation/devicetree/bindings/sound/wm8960.txt | 27 ++++++++++++++
 sound/soc/codecs/wm8960.c                          | 41 ++++++++++++++++------
 2 files changed, 58 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/wm8960.txt

diff --git a/Documentation/devicetree/bindings/sound/wm8960.txt b/Documentation/devicetree/bindings/sound/wm8960.txt
new file mode 100644
index 0000000..1a9ad07
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/wm8960.txt
@@ -0,0 +1,27 @@
+WM8960 audio CODEC
+
+This device supports I2C only.
+
+Required properties:
+
+  - compatible : "wlf,wm8960"
+
+  - reg : the I2C address of the device.
+
+Optional properties:
+  - shared_lrclk: This is a boolean property. If present, the LRCM bit of
+	R24 (Additional control 2 ) gets set, indicating that ADCLRC and DACLRC
+	will be disabled only when ADC (Left and Right) and DAC (Left and Right)
+	are disabled.
+
+  - capless: This is a boolean property. If present, OUT3 will be enabled
+	and disabled together with HP_L and HP_R in response to jack detect events.
+
+Example:
+
+codec: wm8960@1a {
+	compatible = "wlf,wm8960";
+	reg = <0x1a>;
+
+	shared_lrclk;
+};
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 4dc4e85..e5d89a2 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -125,6 +125,7 @@ struct wm8960_priv {
 	struct snd_soc_dapm_widget *out3;
 	bool deemph;
 	int playback_fs;
+	struct wm8960_data pdata;
 };
 
 #define wm8960_reset(c)	snd_soc_write(c, WM8960_RESET, 0)
@@ -440,8 +441,8 @@ static const struct snd_soc_dapm_route audio_paths_capless[] = {
 
 static int wm8960_add_widgets(struct snd_soc_codec *codec)
 {
-	struct wm8960_data *pdata = codec->dev->platform_data;
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
+	struct wm8960_data *pdata = &wm8960->pdata;
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	struct snd_soc_dapm_widget *w;
 
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
@@ -1029,6 +1026,18 @@ static const struct regmap_config wm8960_regmap = {
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
@@ -1045,6 +1054,11 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 	if (IS_ERR(wm8960->regmap))
 		return PTR_ERR(wm8960->regmap);
 
+	if (pdata)
+		memcpy(&wm8960->pdata, pdata, sizeof(struct wm8960_data));
+	else if (i2c->dev.of_node)
+		wm8960_set_pdata_from_of(i2c, &wm8960->pdata);
+
 	if (pdata && pdata->shared_lrclk) {
 		ret = regmap_update_bits(wm8960->regmap, WM8960_ADDCTL2,
 					 0x4, 0x4);
@@ -1075,10 +1089,17 @@ static const struct i2c_device_id wm8960_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wm8960_i2c_id);
 
+static const struct of_device_id wm8960_of_match[] = {
+       { .compatible = "wlf,wm8960", },
+       { }
+};
+MODULE_DEVICE_TABLE(of, wm8960_of_match);
+
 static struct i2c_driver wm8960_i2c_driver = {
 	.driver = {
 		.name = "wm8960",
 		.owner = THIS_MODULE,
+		.of_match_table = wm8960_of_match,
 	},
 	.probe =    wm8960_i2c_probe,
 	.remove =   wm8960_i2c_remove,
-- 
1.9.1

