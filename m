Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaHHFV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:21:56 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:57713
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754179AbaHHFVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:21:50 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 1/2] ASoC: fsl_esai: refine esai for TDM support
Date: Fri, 8 Aug 2014 13:21:23 +0800
Message-ID: <5428d24b20316f690b2b1119724ebf5cbd0fa1c0.1407475184.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407475184.git.shengjiu.wang@freescale.com>
References: <cover.1407475184.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(26826002)(87936001)(46102001)(107046002)(50226001)(68736004)(31966008)(50466002)(229853001)(105606002)(81342001)(33646002)(93916002)(104166001)(48376002)(77156001)(19580395003)(83072002)(64706001)(85852003)(87286001)(20776003)(74502001)(102836001)(76176999)(47776003)(106466001)(74662001)(88136002)(89996001)(6806004)(86362001)(79102001)(21056001)(50986999)(77982001)(83322001)(85306004)(80022001)(44976005)(19580405001)(4396001)(92726001)(76482001)(84676001)(95666004)(81542001)(104016003)(97736001)(99396002)(62966002)(92566001)(2201001)(36756003)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB255;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original driver didn't store the number of slots, just fix the slot number
to 2, use this default number to calculate bclk and pins for TX/RX.
In this patch, add one parameter for slots, and update the calculation of
bclk and pins of TX/RX. Then driver will be compatible with slots > 2 in
TDM mode.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/fsl_esai.c |   14 +++++++++++---
 sound/soc/fsl/fsl_esai.h |    8 ++++----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index 72d154e..f252370 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -38,6 +38,7 @@
  * @fsysclk: system clock source to derive HCK, SCK and FS
  * @fifo_depth: depth of tx/rx FIFO
  * @slot_width: width of each DAI slot
+ * @slots: number of slots
  * @hck_rate: clock rate of desired HCKx clock
  * @sck_rate: clock rate of desired SCKx clock
  * @hck_dir: the direction of HCKx pads
@@ -56,6 +57,7 @@ struct fsl_esai {
 	struct clk *fsysclk;
 	u32 fifo_depth;
 	u32 slot_width;
+	u32 slots;
 	u32 hck_rate[2];
 	u32 sck_rate[2];
 	bool hck_dir[2];
@@ -363,6 +365,7 @@ static int fsl_esai_set_dai_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask,
 			   ESAI_xSMB_xS_MASK, ESAI_xSMB_xS(rx_mask));
 
 	esai_priv->slot_width = slot_width;
+	esai_priv->slots = slots;
 
 	return 0;
 }
@@ -510,10 +513,11 @@ static int fsl_esai_hw_params(struct snd_pcm_substream *substream,
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	u32 width = snd_pcm_format_width(params_format(params));
 	u32 channels = params_channels(params);
+	u32 pins = DIV_ROUND_UP(channels, esai_priv->slots);
 	u32 bclk, mask, val;
 	int ret;
 
-	bclk = params_rate(params) * esai_priv->slot_width * 2;
+	bclk = params_rate(params) * esai_priv->slot_width * esai_priv->slots;
 
 	ret = fsl_esai_set_bclk(dai, tx, bclk);
 	if (ret)
@@ -530,7 +534,7 @@ static int fsl_esai_hw_params(struct snd_pcm_substream *substream,
 	mask = ESAI_xFCR_xFR_MASK | ESAI_xFCR_xWA_MASK | ESAI_xFCR_xFWM_MASK |
 	      (tx ? ESAI_xFCR_TE_MASK | ESAI_xFCR_TIEN : ESAI_xFCR_RE_MASK);
 	val = ESAI_xFCR_xWA(width) | ESAI_xFCR_xFWM(esai_priv->fifo_depth) |
-	     (tx ? ESAI_xFCR_TE(channels) | ESAI_xFCR_TIEN : ESAI_xFCR_RE(channels));
+	     (tx ? ESAI_xFCR_TE(pins) | ESAI_xFCR_TIEN : ESAI_xFCR_RE(pins));
 
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_xFCR(tx), mask, val);
 
@@ -565,6 +569,7 @@ static int fsl_esai_trigger(struct snd_pcm_substream *substream, int cmd,
 	struct fsl_esai *esai_priv = snd_soc_dai_get_drvdata(dai);
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	u8 i, channels = substream->runtime->channels;
+	u32 pins = DIV_ROUND_UP(channels, esai_priv->slots);
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -579,7 +584,7 @@ static int fsl_esai_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		regmap_update_bits(esai_priv->regmap, REG_ESAI_xCR(tx),
 				   tx ? ESAI_xCR_TE_MASK : ESAI_xCR_RE_MASK,
-				   tx ? ESAI_xCR_TE(channels) : ESAI_xCR_RE(channels));
+				   tx ? ESAI_xCR_TE(pins) : ESAI_xCR_RE(pins));
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
@@ -783,6 +788,9 @@ static int fsl_esai_probe(struct platform_device *pdev)
 	/* Set a default slot size */
 	esai_priv->slot_width = 32;
 
+	/* Set a default slot number */
+	esai_priv->slots = 2;
+
 	/* Set a default master/slave state */
 	esai_priv->slave_mode = true;
 
diff --git a/sound/soc/fsl/fsl_esai.h b/sound/soc/fsl/fsl_esai.h
index 75e1403..91a550f 100644
--- a/sound/soc/fsl/fsl_esai.h
+++ b/sound/soc/fsl/fsl_esai.h
@@ -130,8 +130,8 @@
 #define ESAI_xFCR_RE_WIDTH	4
 #define ESAI_xFCR_TE_MASK	(((1 << ESAI_xFCR_TE_WIDTH) - 1) << ESAI_xFCR_xE_SHIFT)
 #define ESAI_xFCR_RE_MASK	(((1 << ESAI_xFCR_RE_WIDTH) - 1) << ESAI_xFCR_xE_SHIFT)
-#define ESAI_xFCR_TE(x) 	((ESAI_xFCR_TE_MASK >> (ESAI_xFCR_TE_WIDTH - ((x + 1) >> 1))) & ESAI_xFCR_TE_MASK)
-#define ESAI_xFCR_RE(x) 	((ESAI_xFCR_RE_MASK >> (ESAI_xFCR_RE_WIDTH - ((x + 1) >> 1))) & ESAI_xFCR_RE_MASK)
+#define ESAI_xFCR_TE(x) 	((ESAI_xFCR_TE_MASK >> (ESAI_xFCR_TE_WIDTH - x)) & ESAI_xFCR_TE_MASK)
+#define ESAI_xFCR_RE(x) 	((ESAI_xFCR_RE_MASK >> (ESAI_xFCR_RE_WIDTH - x)) & ESAI_xFCR_RE_MASK)
 #define ESAI_xFCR_xFR_SHIFT	1
 #define ESAI_xFCR_xFR_MASK	(1 << ESAI_xFCR_xFR_SHIFT)
 #define ESAI_xFCR_xFR		(1 << ESAI_xFCR_xFR_SHIFT)
@@ -272,8 +272,8 @@
 #define ESAI_xCR_RE_WIDTH	4
 #define ESAI_xCR_TE_MASK	(((1 << ESAI_xCR_TE_WIDTH) - 1) << ESAI_xCR_xE_SHIFT)
 #define ESAI_xCR_RE_MASK	(((1 << ESAI_xCR_RE_WIDTH) - 1) << ESAI_xCR_xE_SHIFT)
-#define ESAI_xCR_TE(x) 		((ESAI_xCR_TE_MASK >> (ESAI_xCR_TE_WIDTH - ((x + 1) >> 1))) & ESAI_xCR_TE_MASK)
-#define ESAI_xCR_RE(x) 		((ESAI_xCR_RE_MASK >> (ESAI_xCR_RE_WIDTH - ((x + 1) >> 1))) & ESAI_xCR_RE_MASK)
+#define ESAI_xCR_TE(x) 		((ESAI_xCR_TE_MASK >> (ESAI_xCR_TE_WIDTH - x)) & ESAI_xCR_TE_MASK)
+#define ESAI_xCR_RE(x) 		((ESAI_xCR_RE_MASK >> (ESAI_xCR_RE_WIDTH - x)) & ESAI_xCR_RE_MASK)
 
 /*
  * Transmit Clock Control Register -- REG_ESAI_TCCR 0xD8
-- 
1.7.9.5

