Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbbATMfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:35:37 -0500
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:48642
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754339AbbATMfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:35:34 -0500
X-Greylist: delayed 895 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 07:35:34 EST
From: Zidan Wang <zidan.wang@freescale.com>
To: <timur@tabi.org>
CC: <nicoleotsuka@gmail.com>, <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Zidan Wang <zidan.wang@freescale.com>
Subject: [alsa-devel][PATCH 2/3] ASoC: fsl_sai: Add support for tdm slots operation
Date: Tue, 20 Jan 2015 20:21:19 +0800
Message-ID: <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=zidan.wang@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(50226001)(87936001)(229853001)(64706001)(62966003)(110136001)(47776003)(77156002)(2950100001)(50466002)(33646002)(46102003)(48376002)(104016003)(575784001)(68736005)(77096005)(36756003)(86362001)(97736003)(19580395003)(50986999)(85426001)(76176999)(19580405001)(105606002)(92566002)(106466001)(2351001)(6806004);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1257;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CY1PR0301MB1257;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB1257;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1257;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 12:20:44.9794
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB1257
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0761;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slots and slot width is set from set_dai_tdm_slot in machine driver.
We should calculate the actual slots per channel using slots/channels.

When using tdm slots, we should generate bclk depends channels, slots
and slot width. And there may be unused BCLK cycles before each LRCLK
transition.

Set TCR2 WNW bit to slot width and TCR4 FRSZ bit to slots * channels to
configure frame Length. And it is no need to set TCR4 SYWD to set frame
sync length for sai slave mode, so just do it when it is sai master mode.

Signed-off-by: Zidan Wang <zidan.wang@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 46 +++++++++++++++++++++++++++++++++++++---------
 sound/soc/fsl/fsl_sai.h |  3 +++
 2 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 499cbd9..4c5040d 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -115,6 +115,17 @@ out:
 		return IRQ_HANDLED;
 }
 
+static int fsl_sai_set_dai_tdm_slot(struct snd_soc_dai *cpu_dai, u32 tx_mask,
+				u32 rx_mask, int slots, int slot_width)
+{
+	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
+
+	sai->slots = slots;
+	sai->slot_width = slot_width;
+
+	return 0;
+}
+
 static int fsl_sai_set_dai_sysclk_tr(struct snd_soc_dai *cpu_dai,
 		int clk_id, unsigned int freq, int fsl_dir)
 {
@@ -369,10 +380,25 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	u32 word_width = snd_pcm_format_width(params_format(params));
 	u32 val_cr4 = 0, val_cr5 = 0;
 	int ret;
+	u32 bclk;
+
+	if (channels == 1)
+		channels = 2;
+
+	if (!sai->slots || sai->slots % channels)
+		sai->slots = channels;
+
+	sai->slots = sai->slots / channels;
+
+	if (sai->slot_width < word_width || sai->is_dsp_mode)
+		sai->slot_width = word_width;
 
 	if (!sai->is_slave_mode) {
-		ret = fsl_sai_set_bclk(cpu_dai, tx,
-			2 * word_width * params_rate(params));
+		bclk = snd_soc_calc_bclk(params_rate(params), sai->slot_width,
+				channels, sai->slots);
+
+		ret = fsl_sai_set_bclk(cpu_dai, tx, bclk);
+
 		if (ret)
 			return ret;
 
@@ -385,20 +411,19 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 			sai->mclk_streams |= BIT(substream->stream);
 		}
 
+		if (!sai->is_dsp_mode)
+			val_cr4 |= FSL_SAI_CR4_SYWD(sai->slot_width);
 	}
 
-	if (!sai->is_dsp_mode)
-		val_cr4 |= FSL_SAI_CR4_SYWD(word_width);
-
-	val_cr5 |= FSL_SAI_CR5_WNW(word_width);
-	val_cr5 |= FSL_SAI_CR5_W0W(word_width);
+	val_cr5 |= FSL_SAI_CR5_WNW(sai->slot_width);
+	val_cr5 |= FSL_SAI_CR5_W0W(sai->slot_width);
 
 	if (sai->is_lsb_first)
 		val_cr5 |= FSL_SAI_CR5_FBT(0);
 	else
 		val_cr5 |= FSL_SAI_CR5_FBT(word_width - 1);
 
-	val_cr4 |= FSL_SAI_CR4_FRSZ(channels);
+	val_cr4 |= FSL_SAI_CR4_FRSZ(sai->slots * channels);
 
 	regmap_update_bits(sai->regmap, FSL_SAI_xCR4(tx),
 			   FSL_SAI_CR4_SYWD_MASK | FSL_SAI_CR4_FRSZ_MASK,
@@ -406,7 +431,9 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 	regmap_update_bits(sai->regmap, FSL_SAI_xCR5(tx),
 			   FSL_SAI_CR5_WNW_MASK | FSL_SAI_CR5_W0W_MASK |
 			   FSL_SAI_CR5_FBT_MASK, val_cr5);
-	regmap_write(sai->regmap, FSL_SAI_xMR(tx), ~0UL - ((1 << channels) - 1));
+
+	regmap_write(sai->regmap, FSL_SAI_xMR(tx),
+		     ~0UL - ((1 << params_channels(params) * sai->slots) - 1));
 
 	return 0;
 }
@@ -531,6 +558,7 @@ static void fsl_sai_shutdown(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
 	.set_sysclk	= fsl_sai_set_dai_sysclk,
 	.set_fmt	= fsl_sai_set_dai_fmt,
+	.set_tdm_slot	= fsl_sai_set_dai_tdm_slot,
 	.hw_params	= fsl_sai_hw_params,
 	.hw_free	= fsl_sai_hw_free,
 	.trigger	= fsl_sai_trigger,
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 2d8c830..111dfce 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -140,6 +140,9 @@ struct fsl_sai {
 	bool sai_on_imx;
 	bool synchronous[2];
 
+	unsigned int slots;
+	unsigned int slot_width;
+
 	unsigned int mclk_id;
 	unsigned int mclk_streams;
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
-- 
1.9.1

