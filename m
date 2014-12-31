Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaLaDiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 22:38:24 -0500
Received: from mail-bl2on0133.outbound.protection.outlook.com ([65.55.169.133]:42555
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751374AbaLaDiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 22:38:22 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH 1/4] ASoC: wm8960: Let wm8960 codec driver manage its own MCLK
Date: Wed, 31 Dec 2014 11:39:11 +0800
Message-ID: <1419997154-860-1-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(89996001)(50226001)(50466002)(120916001)(85426001)(77156002)(4396001)(19580395003)(64706001)(62966003)(87936001)(20776003)(46102003)(50986999)(106466001)(21056001)(48376002)(19580405001)(81156004)(99396003)(6806004)(104016003)(33646002)(84676001)(36756003)(47776003)(69596002)(229853001)(2351001)(68736005)(97736003)(92566001)(86362001)(107046002)(77096005)(31966008)(110136001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1252;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1252;
X-Forefront-PRVS: 0442E569BC
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 03:38:18.6309
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to use wm8960 codec, we should enable its MCLK in machine driver.
It's reasonable for wm8960 codec driver to manage its own MCLK.

When current bias_level is SND_SOC_BIAS_ON, it is preparing for a transition
away from ON. In this case, disable the codec mclk. When current bias_level
is not SND_SOC_BIAS_ON, it preparing for a transition to ON. In this case,
enable the codec mclk.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 031a1ae..1a5f47b 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
+#include <linux/clk.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <sound/core.h>
@@ -117,6 +118,7 @@ static bool wm8960_volatile(struct device *dev, unsigned int reg)
 }
 
 struct wm8960_priv {
+	struct clk *mclk;
 	struct regmap *regmap;
 	int (*set_bias_level)(struct snd_soc_codec *,
 			      enum snd_soc_bias_level level);
@@ -618,6 +620,7 @@ static int wm8960_set_bias_level_out3(struct snd_soc_codec *codec,
 				      enum snd_soc_bias_level level)
 {
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
+	int ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -626,6 +629,20 @@ static int wm8960_set_bias_level_out3(struct snd_soc_codec *codec,
 	case SND_SOC_BIAS_PREPARE:
 		/* Set VMID to 2x50k */
 		snd_soc_update_bits(codec, WM8960_POWER1, 0x180, 0x80);
+
+		if (!IS_ERR(wm8960->mclk)) {
+			if (codec->dapm.bias_level == SND_SOC_BIAS_ON)
+				clk_disable_unprepare(wm8960->mclk);
+			else {
+				ret = clk_prepare_enable(wm8960->mclk);
+				if (ret) {
+					dev_err(codec->dev,
+						"Failed to enable MCLK: %d\n",
+						ret);
+					return ret;
+				}
+			}
+		}
 		break;
 
 	case SND_SOC_BIAS_STANDBY:
@@ -661,6 +678,7 @@ static int wm8960_set_bias_level_out3(struct snd_soc_codec *codec,
 
 		/* Disable VMID and VREF, let them discharge */
 		snd_soc_write(codec, WM8960_POWER1, 0);
+
 		msleep(600);
 		break;
 	}
@@ -674,7 +692,7 @@ static int wm8960_set_bias_level_capless(struct snd_soc_codec *codec,
 					 enum snd_soc_bias_level level)
 {
 	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
-	int reg;
+	int reg, ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -715,9 +733,22 @@ static int wm8960_set_bias_level_capless(struct snd_soc_codec *codec,
 					    WM8960_VREF, WM8960_VREF);
 
 			msleep(100);
+
+			if (!IS_ERR(wm8960->mclk)) {
+				ret = clk_prepare_enable(wm8960->mclk);
+				if (ret) {
+					dev_err(codec->dev,
+						"Failed to enable MCLK: %d\n",
+						ret);
+					return ret;
+				}
+			}
 			break;
 
 		case SND_SOC_BIAS_ON:
+			if (!IS_ERR(wm8960->mclk))
+				clk_disable_unprepare(wm8960->mclk);
+
 			/* Enable anti-pop mode */
 			snd_soc_update_bits(codec, WM8960_APOP1,
 					    WM8960_POBCTRL | WM8960_SOFT_ST |
@@ -728,6 +759,7 @@ static int wm8960_set_bias_level_capless(struct snd_soc_codec *codec,
 			/* Disable VMID and VREF */
 			snd_soc_update_bits(codec, WM8960_POWER1,
 					    WM8960_VREF | WM8960_VMID_MASK, 0);
+
 			break;
 
 		case SND_SOC_BIAS_OFF:
@@ -1002,6 +1034,12 @@ static int wm8960_i2c_probe(struct i2c_client *i2c,
 	if (wm8960 == NULL)
 		return -ENOMEM;
 
+	wm8960->mclk = devm_clk_get(&i2c->dev, "codec_mclk");
+	if (IS_ERR(wm8960->mclk)) {
+		if (PTR_ERR(wm8960->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+	}
+
 	wm8960->regmap = devm_regmap_init_i2c(i2c, &wm8960_regmap);
 	if (IS_ERR(wm8960->regmap))
 		return PTR_ERR(wm8960->regmap);
-- 
1.9.1

