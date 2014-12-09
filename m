Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaLIF71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 00:59:27 -0500
Received: from mail-by2on0142.outbound.protection.outlook.com ([207.46.100.142]:19476
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752953AbaLIF7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 00:59:25 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver manage its own MCLK
Date: Tue, 9 Dec 2014 13:45:16 +0800
Message-ID: <1418103916-31295-1-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(84676001)(68736005)(87936001)(62966003)(97736003)(48376002)(104016003)(105606002)(46102003)(33646002)(77156002)(99396003)(110136001)(229853001)(120916001)(77096005)(89996001)(106466001)(107046002)(2351001)(92566001)(64706001)(47776003)(20776003)(4396001)(50226001)(86362001)(31966008)(50466002)(19580395003)(19580405001)(50986999)(36756003)(6806004)(21056001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1263;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1263;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB1263;
X-Forefront-PRVS: 0420213CCD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1263;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0654;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to use wm8960 codec, we should enable its MCLK in machine
driver. It's reasonable for wm8960 codec driver to manage its own MCLK to
save power.

Enable runtime power management, and auto enable/disable MCLK in pm_runtime
resume and suspend. When wm8960 codec is being used, it will triger resume()
to enable MCLK. When codec is not being used, it will triger suspend() to
disable MCLK.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 031a1ae..aff24a7 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <sound/core.h>
@@ -117,6 +119,7 @@ static bool wm8960_volatile(struct device *dev, unsigned int reg)
 }
 
 struct wm8960_priv {
+	struct clk *mclk;
 	struct regmap *regmap;
 	int (*set_bias_level)(struct snd_soc_codec *,
 			      enum snd_soc_bias_level level);
@@ -1002,6 +1005,13 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 	if (wm8960 == NULL)
 		return -ENOMEM;
 
+	wm8960->mclk = devm_clk_get(&i2c->dev, "codec_mclk");
+
+	if (IS_ERR(wm8960->mclk)) {
+		if (PTR_ERR(wm8960->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+	}
+
 	wm8960->regmap = devm_regmap_init_i2c(i2c, &wm8960_regmap);
 	if (IS_ERR(wm8960->regmap))
 		return PTR_ERR(wm8960->regmap);
@@ -1041,6 +1051,9 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm8960);
 
+	pm_runtime_enable(&i2c->dev);
+	pm_request_idle(&i2c->dev);
+
 	ret = snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_wm8960, &wm8960_dai, 1);
 
@@ -1053,6 +1066,38 @@ static int wm8960_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int wm8960_runtime_resume(struct device *dev)
+{
+	struct wm8960_priv *wm8960 = dev_get_drvdata(dev);
+	int ret;
+
+	if (!IS_ERR(wm8960->mclk)) {
+		ret = clk_prepare_enable(wm8960->mclk);
+		if (ret) {
+			dev_err(dev, "Failed to enable MCLK: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int wm8960_runtime_suspend(struct device *dev)
+{
+	struct wm8960_priv *wm8960 = dev_get_drvdata(dev);
+
+	if (!IS_ERR(wm8960->mclk))
+		clk_disable_unprepare(wm8960->mclk);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops wm8960_pm = {
+	SET_RUNTIME_PM_OPS(wm8960_runtime_suspend, wm8960_runtime_resume, NULL)
+};
+
 static const struct i2c_device_id wm8960_i2c_id[] = {
 	{ "wm8960", 0 },
 	{ }
@@ -1070,6 +1115,7 @@ static struct i2c_driver wm8960_i2c_driver = {
 		.name = "wm8960",
 		.owner = THIS_MODULE,
 		.of_match_table = wm8960_of_match,
+		.pm = &wm8960_pm,
 	},
 	.probe =    wm8960_i2c_probe,
 	.remove =   wm8960_i2c_remove,
-- 
1.9.1

