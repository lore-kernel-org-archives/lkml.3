Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaG1KyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:54:17 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:56957
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751982AbaG1KyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:54:16 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <patches@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <b42378@freescale.com>,
        <b02247@freescale.com>
Subject: [PATCH] ASoC: wm8962: Let CODEC driver enable and disable its own MCLK
Date: Mon, 28 Jul 2014 18:56:01 +0800
Message-ID: <1406544961-19923-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130510184538278525;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199002)(189002)(102836001)(92726001)(74502001)(61266001)(47776003)(74662001)(20776003)(229853001)(64706001)(99396002)(107046002)(93916002)(19580395003)(6806004)(62966002)(19580405001)(44976005)(68736004)(50986999)(73392001)(73972005)(55446002)(104166001)(87572001)(80022001)(50226001)(92566001)(86362001)(84676001)(46102001)(87936001)(2351001)(33646002)(85306003)(81342001)(31966008)(81442001)(81542001)(26826002)(110136001)(97736001)(105596002)(79102001)(77156001)(48376002)(21056001)(4396001)(106466001)(77982001)(88136002)(85852003)(95666004)(89996001)(36756003)(104016003)(87286001)(82202001)(50466002)(83072002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB358;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_soc_open() will trigger pm_runtime resume() which will then enable
the regulator and initialization. So we should make sure the MCLK is
enabled before this resume().

Previously we let the machine driver get the clock and enable it in
its probe(). However, considering about power saving, it'll be better
to enable it when it's going to be used and disable it after using.

So this patch just simply adds clk_get() and clk_enable() to WM8962
driver. Meanwhile, it marks clock pointer to NULL if no clock assigned
to it so it will not break any current function.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 include/sound/wm8962.h    |  1 +
 sound/soc/codecs/wm8962.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/sound/wm8962.h b/include/sound/wm8962.h
index 79e6d42..0af7c16 100644
--- a/include/sound/wm8962.h
+++ b/include/sound/wm8962.h
@@ -37,6 +37,7 @@
 #define WM8962_GPIO_FN_MICSCD          22
 
 struct wm8962_pdata {
+	struct clk *mclk;
 	int gpio_base;
 	u32 gpio_init[WM8962_MAX_GPIO];
 
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index ca2fda9..256ae51 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/gcd.h>
@@ -3541,6 +3542,8 @@ static int wm8962_set_pdata_from_of(struct i2c_client *i2c,
 				pdata->gpio_init[i] = 0x0;
 		}
 
+	pdata->mclk = devm_clk_get(&i2c->dev, NULL);
+
 	return 0;
 }
 
@@ -3572,6 +3575,10 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
 			return ret;
 	}
 
+	/* Mark the mclk pointer to NULL if no mclk assigned */
+	if (IS_ERR(pdata->mclk))
+		pdata->mclk = NULL;
+
 	for (i = 0; i < ARRAY_SIZE(wm8962->supplies); i++)
 		wm8962->supplies[i].supply = wm8962_supply_names[i];
 
@@ -3780,6 +3787,8 @@ static int wm8962_runtime_resume(struct device *dev)
 	struct wm8962_priv *wm8962 = dev_get_drvdata(dev);
 	int ret;
 
+	clk_prepare_enable(wm8962->pdata.mclk);
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(wm8962->supplies),
 				    wm8962->supplies);
 	if (ret != 0) {
@@ -3839,6 +3848,8 @@ static int wm8962_runtime_suspend(struct device *dev)
 	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies),
 			       wm8962->supplies);
 
+	clk_disable_unprepare(wm8962->pdata.mclk);
+
 	return 0;
 }
 #endif
-- 
1.8.4

