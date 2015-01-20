Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbbATHnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:43:37 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:22421 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293AbbATHnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:43:35 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <Songjun.Wu@atmel.com>, <peda@lysator.liu.se>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2 1/2] ASoC: atmel_ssc_dai: fix start event for I2S mode
Date: Tue, 20 Jan 2015 15:43:16 +0800
Message-ID: <1421739797-25988-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.3.0.rc0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the I2S specification information as following:
  - WS = 0, channel 1 (left)
  - WS = 1, channel 2 (right)
So, the start event should be TF/RF falling edge.

Reported-by: Songjun Wu <songjun.wu@atmel.com>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

Changes in v2: None

 sound/soc/atmel/atmel_ssc_dai.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index 99ff35e..e691aab 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -348,7 +348,6 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 	struct atmel_pcm_dma_params *dma_params;
 	int dir, channels, bits;
 	u32 tfmr, rfmr, tcmr, rcmr;
-	int start_event;
 	int ret;
 	int fslen, fslen_ext;
 
@@ -457,19 +456,10 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 		 * The SSC transmit clock is obtained from the BCLK signal on
 		 * on the TK line, and the SSC receive clock is
 		 * generated from the transmit clock.
-		 *
-		 *  For single channel data, one sample is transferred
-		 * on the falling edge of the LRC clock.
-		 * For two channel data, one sample is
-		 * transferred on both edges of the LRC clock.
 		 */
-		start_event = ((channels == 1)
-				? SSC_START_FALLING_RF
-				: SSC_START_EDGE_RF);
-
 		rcmr =	  SSC_BF(RCMR_PERIOD, 0)
 			| SSC_BF(RCMR_STTDLY, START_DELAY)
-			| SSC_BF(RCMR_START, start_event)
+			| SSC_BF(RCMR_START, SSC_START_FALLING_RF)
 			| SSC_BF(RCMR_CKI, SSC_CKI_RISING)
 			| SSC_BF(RCMR_CKO, SSC_CKO_NONE)
 			| SSC_BF(RCMR_CKS, ssc->clk_from_rk_pin ?
@@ -478,14 +468,14 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 		rfmr =	  SSC_BF(RFMR_FSEDGE, SSC_FSEDGE_POSITIVE)
 			| SSC_BF(RFMR_FSOS, SSC_FSOS_NONE)
 			| SSC_BF(RFMR_FSLEN, 0)
-			| SSC_BF(RFMR_DATNB, 0)
+			| SSC_BF(RFMR_DATNB, (channels - 1))
 			| SSC_BIT(RFMR_MSBF)
 			| SSC_BF(RFMR_LOOP, 0)
 			| SSC_BF(RFMR_DATLEN, (bits - 1));
 
 		tcmr =	  SSC_BF(TCMR_PERIOD, 0)
 			| SSC_BF(TCMR_STTDLY, START_DELAY)
-			| SSC_BF(TCMR_START, start_event)
+			| SSC_BF(TCMR_START, SSC_START_FALLING_RF)
 			| SSC_BF(TCMR_CKI, SSC_CKI_FALLING)
 			| SSC_BF(TCMR_CKO, SSC_CKO_NONE)
 			| SSC_BF(TCMR_CKS, ssc->clk_from_rk_pin ?
@@ -495,7 +485,7 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
 			| SSC_BF(TFMR_FSDEN, 0)
 			| SSC_BF(TFMR_FSOS, SSC_FSOS_NONE)
 			| SSC_BF(TFMR_FSLEN, 0)
-			| SSC_BF(TFMR_DATNB, 0)
+			| SSC_BF(TFMR_DATNB, (channels - 1))
 			| SSC_BIT(TFMR_MSBF)
 			| SSC_BF(TFMR_DATDEF, 0)
 			| SSC_BF(TFMR_DATLEN, (bits - 1));
-- 
2.3.0.rc0

