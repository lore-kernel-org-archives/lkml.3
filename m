Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaLDIXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:23:08 -0500
Received: from mail-by2on0108.outbound.protection.outlook.com ([207.46.100.108]:57134
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbaLDIXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:23:06 -0500
X-Greylist: delayed 76992 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2014 03:23:06 EST
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH v2] ASoC: wm8960: Let wm8960 codec driver manage its own MCLK
Date: Thu, 4 Dec 2014 16:23:45 +0800
Message-ID: <1417681425-4360-1-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(102836001)(104016003)(110136001)(62966003)(106466001)(68736005)(50986999)(104166001)(86362001)(47776003)(93916002)(20776003)(64706001)(77096005)(229853001)(2351001)(107046002)(31966008)(36756003)(95666004)(77156002)(81156004)(69596002)(105606002)(84676001)(88136002)(46102003)(89996001)(92726001)(92566001)(97736003)(50226001)(4396001)(50466002)(33646002)(21056001)(87936001)(44976005)(19580395003)(19580405001)(6806004)(87286001)(120916001)(99396003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602001);SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 041517DFAB
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B50113@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to use wm8960 codec, we should enable its MCLK in machine
driver. It's reasonable for wm8960 codec driver to manage its own MCLK to
save power.

If platform data is not supplied, we will get MCLK from device tree and check
the return code to handle probe deferral.

Enable runtime power management, and auto enable/disable MCLK in pm_runtime
resume and suspend. When wm8960 codec is being used, it will triger resume()
to enable MCLK. When codec is not being used, it will triger suspend() to
disable MCLK.

If we use PLL to generate sysclk, wm8960_set_dai_pll() will enable PLL. But
PLL doesn't power down after using codec. So power down PLL in suspend().

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 include/sound/wm8960.h    |  1 +
 sound/soc/codecs/wm8960.c | 59 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/include/sound/wm8960.h b/include/sound/wm8960.h
index e8ce8ee..d7e84ed 100644
--- a/include/sound/wm8960.h
+++ b/include/sound/wm8960.h
@@ -16,6 +16,7 @@
 #define WM8960_DRES_MAX  3
 
 struct wm8960_data {
+	struct clk *mclk;
 	bool capless;  /* Headphone outputs configured in capless mode */
 
 	bool shared_lrclk;  /* DAC and ADC LRCLKs are wired together */
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 031a1ae..2c7a97a 100644
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
@@ -978,7 +980,7 @@ static const struct regmap_config wm8960_regmap = {
 	.volatile_reg = wm8960_volatile,
 };
 
-static void wm8960_set_pdata_from_of(struct i2c_client *i2c,
+static int wm8960_set_pdata_from_of(struct i2c_client *i2c,
 				struct wm8960_data *pdata)
 {
 	const struct device_node *np = i2c->dev.of_node;
@@ -988,6 +990,15 @@ static void wm8960_set_pdata_from_of(struct i2c_client *i2c,
 
 	if (of_property_read_bool(np, "wlf,shared-lrclk"))
 		pdata->shared_lrclk = true;
+
+	pdata->mclk = devm_clk_get(&i2c->dev, NULL);
+
+	if (IS_ERR(pdata->mclk)) {
+		if (PTR_ERR(pdata->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+	}
+
+	return 0;
 }
 
 static int wm8960_i2c_probe(struct i2c_client *i2c,
@@ -1008,8 +1019,11 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 
 	if (pdata)
 		memcpy(&wm8960->pdata, pdata, sizeof(struct wm8960_data));
-	else if (i2c->dev.of_node)
-		wm8960_set_pdata_from_of(i2c, &wm8960->pdata);
+	else if (i2c->dev.of_node) {
+		ret = wm8960_set_pdata_from_of(i2c, &wm8960->pdata);
+		if (ret != 0)
+			return ret;
+	}
 
 	ret = wm8960_reset(wm8960->regmap);
 	if (ret != 0) {
@@ -1041,6 +1055,9 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, wm8960);
 
+	pm_runtime_enable(&i2c->dev);
+	pm_request_idle(&i2c->dev);
+
 	ret = snd_soc_register_codec(&i2c->dev,
 			&soc_codec_dev_wm8960, &wm8960_dai, 1);
 
@@ -1053,6 +1070,41 @@ static int wm8960_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int wm8960_runtime_resume(struct device *dev)
+{
+	struct wm8960_priv *wm8960 = dev_get_drvdata(dev);
+	int ret;
+
+	if (!IS_ERR(wm8960->pdata.mclk)) {
+		ret = clk_prepare_enable(wm8960->pdata.mclk);
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
+	/* Power down PLL to save power */
+	regmap_update_bits(wm8960->regmap, WM8960_POWER2, 0x1, 0);
+
+	if (!IS_ERR(wm8960->pdata.mclk))
+		clk_disable_unprepare(wm8960->pdata.mclk);
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
@@ -1070,6 +1122,7 @@ static struct i2c_driver wm8960_i2c_driver = {
 		.name = "wm8960",
 		.owner = THIS_MODULE,
 		.of_match_table = wm8960_of_match,
+		.pm = &wm8960_pm,
 	},
 	.probe =    wm8960_i2c_probe,
 	.remove =   wm8960_i2c_remove,
-- 
1.9.1

