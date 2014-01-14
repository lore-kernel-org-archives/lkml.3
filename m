Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaAND2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:28:15 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:45346 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaAND2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:28:10 -0500
From: Bo Shen <voice.shen@atmel.com>
To: broonie@kernel.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-sound@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ASoC: atmel_ssc_dai: make option to choose clock
Date: Tue, 14 Jan 2014 11:25:54 +0800
Message-Id: <1389669956-2304-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389669956-2304-1-git-send-email-voice.shen@atmel.com>
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SSC works in slave mode, according to the hardware design, the
clock can get from TK pin, also can get from RK pin. So, add one
parameter to choose where the clock from.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 sound/soc/atmel/atmel_ssc_dai.c | 16 ++++++++++++----
 sound/soc/atmel/atmel_ssc_dai.h |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 8697ced..03eb0be 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -340,6 +340,7 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_dai *dai)
 {
 	int id = dai->id;
+	struct snd_soc_card *card = dai->card;
 	struct atmel_ssc_info *ssc_p = &ssc_info[id];
 	struct atmel_pcm_dma_params *dma_params;
 	int dir, channels, bits;
@@ -347,6 +348,9 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 	int start_event;
 	int ret;
 
+	ssc_p->clk_from_rk_pin =
+		((struct atmel_ssc_info *)(card->drvdata))->clk_from_rk_pin;
+
 	/*
 	 * Currently, there is only one set of dma params for
 	 * each direction.  If more are added, this code will
@@ -466,7 +470,8 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 			| SSC_BF(RCMR_START, start_event)
 			| SSC_BF(RCMR_CKI, SSC_CKI_RISING)
 			| SSC_BF(RCMR_CKO, SSC_CKO_NONE)
-			| SSC_BF(RCMR_CKS, SSC_CKS_CLOCK);
+			| SSC_BF(RCMR_CKS, ssc_p->clk_from_rk_pin ?
+					   SSC_CKS_PIN : SSC_CKS_CLOCK);
 
 		rfmr =	  SSC_BF(RFMR_FSEDGE, SSC_FSEDGE_POSITIVE)
 			| SSC_BF(RFMR_FSOS, SSC_FSOS_NONE)
@@ -481,7 +486,8 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 			| SSC_BF(TCMR_START, start_event)
 			| SSC_BF(TCMR_CKI, SSC_CKI_FALLING)
 			| SSC_BF(TCMR_CKO, SSC_CKO_NONE)
-			| SSC_BF(TCMR_CKS, SSC_CKS_PIN);
+			| SSC_BF(TCMR_CKS, ssc_p->clk_from_rk_pin ?
+					   SSC_CKS_CLOCK : SSC_CKS_PIN);
 
 		tfmr =	  SSC_BF(TFMR_FSEDGE, SSC_FSEDGE_POSITIVE)
 			| SSC_BF(TFMR_FSDEN, 0)
@@ -550,7 +556,8 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 			| SSC_BF(RCMR_START, SSC_START_RISING_RF)
 			| SSC_BF(RCMR_CKI, SSC_CKI_RISING)
 			| SSC_BF(RCMR_CKO, SSC_CKO_NONE)
-			| SSC_BF(RCMR_CKS, SSC_CKS_PIN);
+			| SSC_BF(RCMR_CKS, ssc_p->clk_from_rk_pin ?
+					   SSC_CKS_PIN : SSC_CKS_CLOCK);
 
 		rfmr =	  SSC_BF(RFMR_FSEDGE, SSC_FSEDGE_POSITIVE)
 			| SSC_BF(RFMR_FSOS, SSC_FSOS_NONE)
@@ -565,7 +572,8 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 			| SSC_BF(TCMR_START, SSC_START_RISING_RF)
 			| SSC_BF(TCMR_CKI, SSC_CKI_FALLING)
 			| SSC_BF(TCMR_CKO, SSC_CKO_NONE)
-			| SSC_BF(TCMR_CKS, SSC_CKS_PIN);
+			| SSC_BF(RCMR_CKS, ssc_p->clk_from_rk_pin ?
+					   SSC_CKS_CLOCK : SSC_CKS_PIN);
 
 		tfmr =	  SSC_BF(TFMR_FSEDGE, SSC_FSEDGE_POSITIVE)
 			| SSC_BF(TFMR_FSDEN, 0)
diff --git a/sound/soc/atmel/atmel_ssc_dai.h b/sound/soc/atmel/atmel_ssc_dai.h
index b1f08d5..f147895 100644
--- a/sound/soc/atmel/atmel_ssc_dai.h
+++ b/sound/soc/atmel/atmel_ssc_dai.h
@@ -113,6 +113,7 @@ struct atmel_ssc_info {
 	unsigned short cmr_div;
 	unsigned short tcmr_period;
 	unsigned short rcmr_period;
+	bool clk_from_rk_pin;
 	struct atmel_pcm_dma_params *dma_params[2];
 	struct atmel_ssc_state ssc_state;
 };
-- 
1.8.5.2

