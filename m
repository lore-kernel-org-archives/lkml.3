Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbbAGIE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:04:56 -0500
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:37996
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752290AbbAGIEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:04:54 -0500
From: Zidan Wang <zidan.wang@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <patches@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH v2 2/2] ASoC: wm8960: Let wm8960 driver configure its bit clock and frame clock
Date: Wed, 7 Jan 2015 15:31:45 +0800
Message-ID: <1420615905-4078-2-git-send-email-zidan.wang@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420615905-4078-1-git-send-email-zidan.wang@freescale.com>
References: <1420615905-4078-1-git-send-email-zidan.wang@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=zidan.wang@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(92566001)(68736005)(77096005)(4396001)(2950100001)(50226001)(48376002)(20776003)(85426001)(31966008)(89996001)(47776003)(36756003)(50466002)(120916001)(105606002)(21056001)(2351001)(107046002)(229853001)(97736003)(104016003)(62966003)(77156002)(76176999)(50986999)(110136001)(19580395003)(84676001)(19580405001)(86362001)(87936001)(6806004)(33646002)(69596002)(106466001)(81156004)(46102003)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1250;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1250;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1250;
X-Forefront-PRVS: 044968D9E1
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1250;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2015 07:30:48.4282
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zidan Wang <b50113@freescale.com>

wm8960 codec driver missing configure its bit clock and frame clock, so add
support for it. It will calculate a appropriate frequency dividing ratio
according to the system clock, bit clock and frame clock, then set the
corresponding registers.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index fd25973..aba6bbf 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -127,6 +127,8 @@ struct wm8960_priv {
 	struct snd_soc_dapm_widget *out3;
 	bool deemph;
 	int playback_fs;
+	int bclk;
+	int sysclk;
 	struct wm8960_data pdata;
 };
 
@@ -563,6 +565,68 @@ static struct {
 	{  8000, 5 },
 };
 
+/* Multiply 256 for internal 256 div */
+static const int dac_divs[] = { 256, 384, 512, 768, 1024, 1408, 1536 };
+
+/* Multiply 10 to eliminate decimials */
+static const int bclk_divs[] = {
+	10, 15, 20, 30, 40, 55, 60, 80, 110,
+	120, 160, 220, 240, 320, 320, 320
+};
+
+static void wm8960_configure_clocking(struct snd_soc_codec *codec,
+		int stream, int lrclk)
+{
+	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
+	u16 iface1 = snd_soc_read(codec, WM8960_IFACE1);
+	u16 iface2 = snd_soc_read(codec, WM8960_IFACE2);
+	int i, j;
+
+	if (!(iface1 & (1<<6))) {
+		dev_dbg(codec->dev,
+			"Codec is slave mode, no need to configure clock\n");
+		return;
+	}
+
+	if (!wm8960->sysclk) {
+		dev_dbg(codec->dev, "No SYSCLK configured\n");
+		return;
+	}
+
+	if (!wm8960->bclk || !lrclk) {
+		dev_dbg(codec->dev, "No audio clocks configured\n");
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(dac_divs); ++i) {
+		if (wm8960->sysclk == lrclk * dac_divs[i]) {
+			for (j = 0; j < ARRAY_SIZE(bclk_divs); ++j) {
+				if (wm8960->sysclk ==  wm8960->bclk *
+						bclk_divs[j] / 10) {
+					goto config_clock;
+				}
+			}
+		}
+	}
+
+	dev_err(codec->dev, "Unsupported sysclk %d\n", wm8960->sysclk);
+	return;
+
+config_clock:
+	/* configure frame clock. If ADCLRC configure as GPIO pin, DACLRC
+	 * pin is used as a frame clock for ADCs and DACs.
+	 */
+	if (iface2 & (1<<6))
+		snd_soc_update_bits(codec, WM8960_CLOCK1, 0x7 << 3, i << 3);
+	else if (SNDRV_PCM_STREAM_PLAYBACK == stream)
+		snd_soc_update_bits(codec, WM8960_CLOCK1, 0x7 << 3, i << 3);
+	else if (SNDRV_PCM_STREAM_CAPTURE == stream)
+		snd_soc_update_bits(codec, WM8960_CLOCK1, 0x7 << 6, i << 6);
+
+	/* configure bit clock */
+	snd_soc_update_bits(codec, WM8960_CLOCK2, 0xf, j);
+}
+
 static int wm8960_hw_params(struct snd_pcm_substream *substream,
 			    struct snd_pcm_hw_params *params,
 			    struct snd_soc_dai *dai)
@@ -572,6 +636,10 @@ static int wm8960_hw_params(struct snd_pcm_substream *substream,
 	u16 iface = snd_soc_read(codec, WM8960_IFACE1) & 0xfff3;
 	int i;
 
+	wm8960->bclk = snd_soc_params_to_bclk(params);
+	if (params_channels(params) == 1)
+		wm8960->bclk *= 2;
+
 	/* bit size */
 	switch (params_width(params)) {
 	case 16:
@@ -602,6 +670,10 @@ static int wm8960_hw_params(struct snd_pcm_substream *substream,
 
 	/* set iface */
 	snd_soc_write(codec, WM8960_IFACE1, iface);
+
+	wm8960_configure_clocking(codec, substream->stream,
+			params_rate(params));
+
 	return 0;
 }
 
@@ -950,6 +1022,30 @@ static int wm8960_set_bias_level(struct snd_soc_codec *codec,
 	return wm8960->set_bias_level(codec, level);
 }
 
+static int wm8960_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
+					unsigned int freq, int dir)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct wm8960_priv *wm8960 = snd_soc_codec_get_drvdata(codec);
+
+	switch (clk_id) {
+	case WM8960_SYSCLK_MCLK:
+		snd_soc_update_bits(codec, WM8960_CLOCK1,
+					0x1, WM8960_SYSCLK_MCLK);
+		break;
+	case WM8960_SYSCLK_PLL:
+		snd_soc_update_bits(codec, WM8960_CLOCK1,
+					0x1, WM8960_SYSCLK_PLL);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	wm8960->sysclk = freq;
+
+	return 0;
+}
+
 #define WM8960_RATES SNDRV_PCM_RATE_8000_48000
 
 #define WM8960_FORMATS \
@@ -962,6 +1058,7 @@ static const struct snd_soc_dai_ops wm8960_dai_ops = {
 	.set_fmt = wm8960_set_dai_fmt,
 	.set_clkdiv = wm8960_set_dai_clkdiv,
 	.set_pll = wm8960_set_dai_pll,
+	.set_sysclk = wm8960_set_dai_sysclk,
 };
 
 static struct snd_soc_dai_driver wm8960_dai = {
-- 
1.9.1

