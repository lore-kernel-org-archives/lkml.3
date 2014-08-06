Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaHFKXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:23:21 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:23903
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755224AbaHFKXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:23:18 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 1/2] ASoC: fsl: esai: refine esai for tdm support
Date: Wed, 6 Aug 2014 18:23:03 +0800
Message-ID: <e68d8fbaaed7000b13688b0f1757b5b9557889d7.1407320232.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407320232.git.shengjiu.wang@freescale.com>
References: <cover.1407320232.git.shengjiu.wang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(6806004)(31966008)(74662001)(93916002)(74502001)(86362001)(19580395003)(44976005)(19580405001)(83322001)(105606002)(85306004)(33646002)(106466001)(4396001)(104016003)(50226001)(107046002)(229853001)(46102001)(87286001)(62966002)(76176999)(99396002)(20776003)(50986999)(47776003)(84676001)(76482001)(36756003)(26826002)(104166001)(88136002)(102836001)(89996001)(87936001)(77156001)(85852003)(83072002)(2201001)(92566001)(92726001)(48376002)(81342001)(97736001)(81542001)(79102001)(80022001)(77982001)(64706001)(95666004)(50466002)(68736004)(21056001)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB250;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add parameter for slots, and caculate the number of TX/RX pins and bclk with
slots. Then driver will be compatible with slots > 2 in TDM mode.

Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
---
 sound/soc/fsl/fsl_esai.c |   10 +++++++---
 sound/soc/fsl/fsl_esai.h |    8 ++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index 72d154e..89aa531 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -56,6 +56,7 @@ struct fsl_esai {
 	struct clk *fsysclk;
 	u32 fifo_depth;
 	u32 slot_width;
+	u32 slots;
 	u32 hck_rate[2];
 	u32 sck_rate[2];
 	bool hck_dir[2];
@@ -363,6 +364,7 @@ static int fsl_esai_set_dai_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask,
 			   ESAI_xSMB_xS_MASK, ESAI_xSMB_xS(rx_mask));
 
 	esai_priv->slot_width = slot_width;
+	esai_priv->slots      = slots;
 
 	return 0;
 }
@@ -510,10 +512,11 @@ static int fsl_esai_hw_params(struct snd_pcm_substream *substream,
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	u32 width = snd_pcm_format_width(params_format(params));
 	u32 channels = params_channels(params);
+	u32 pin = DIV_ROUND_UP(channels, esai_priv->slots);
 	u32 bclk, mask, val;
 	int ret;
 
-	bclk = params_rate(params) * esai_priv->slot_width * 2;
+	bclk = params_rate(params) * esai_priv->slot_width * esai_priv->slots;
 
 	ret = fsl_esai_set_bclk(dai, tx, bclk);
 	if (ret)
@@ -530,7 +533,7 @@ static int fsl_esai_hw_params(struct snd_pcm_substream *substream,
 	mask = ESAI_xFCR_xFR_MASK | ESAI_xFCR_xWA_MASK | ESAI_xFCR_xFWM_MASK |
 	      (tx ? ESAI_xFCR_TE_MASK | ESAI_xFCR_TIEN : ESAI_xFCR_RE_MASK);
 	val = ESAI_xFCR_xWA(width) | ESAI_xFCR_xFWM(esai_priv->fifo_depth) |
-	     (tx ? ESAI_xFCR_TE(channels) | ESAI_xFCR_TIEN : ESAI_xFCR_RE(channels));
+	     (tx ? ESAI_xFCR_TE(pin) | ESAI_xFCR_TIEN : ESAI_xFCR_RE(pin));
 
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_xFCR(tx), mask, val);
 
@@ -565,6 +568,7 @@ static int fsl_esai_trigger(struct snd_pcm_substream *substream, int cmd,
 	struct fsl_esai *esai_priv = snd_soc_dai_get_drvdata(dai);
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
 	u8 i, channels = substream->runtime->channels;
+	u32 pin = DIV_ROUND_UP(channels, esai_priv->slots);
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
@@ -579,7 +583,7 @@ static int fsl_esai_trigger(struct snd_pcm_substream *substream, int cmd,
 
 		regmap_update_bits(esai_priv->regmap, REG_ESAI_xCR(tx),
 				   tx ? ESAI_xCR_TE_MASK : ESAI_xCR_RE_MASK,
-				   tx ? ESAI_xCR_TE(channels) : ESAI_xCR_RE(channels));
+				   tx ? ESAI_xCR_TE(pin) : ESAI_xCR_RE(pin));
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_STOP:
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

